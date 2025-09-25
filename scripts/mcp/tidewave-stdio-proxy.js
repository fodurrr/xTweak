#!/usr/bin/env node
/**
 * TideWave MCP stdio↔HTTP proxy
 *
 * Bridges Codex CLI (stdio MCP) to the TideWave HTTP MCP endpoint.
 * Requires Node.js >= 18 (uses global fetch and WHATWG streams).
 *
 * Environment variables:
 *  - TIDEWAVE_BASE_URL   (default: http://localhost:4000/tidewave/mcp)
 *  - TIDEWAVE_RPC_PATH   (default: "")      // TideWave uses POST /tidewave/mcp
 *  - TIDEWAVE_EVENTS_PATH(default: "")      // TideWave does not use SSE (GET returns 405)
 *  - TIDEWAVE_PROTOCOL_VERSION (default: 2025-03-26)
 *  - TIDEWAVE_TOKEN      (optional: adds Authorization: Bearer <token>)
 *
 * TOML example (~/.codex/config.toml):
 *  [mcp_servers.tidewave]
 *  command = "node"
 *  args = ["/absolute/path/to/scripts/mcp/tidewave-stdio-proxy.js"]
 *  env = { TIDEWAVE_BASE_URL = "http://localhost:4000/tidewave/mcp" }
 */

const BASE = process.env.TIDEWAVE_BASE_URL || 'http://localhost:4000/tidewave/mcp';
const RPC_PATH = process.env.TIDEWAVE_RPC_PATH ?? '';
const EVENTS_PATH = process.env.TIDEWAVE_EVENTS_PATH ?? '';
const PROTOCOL_VERSION = process.env.TIDEWAVE_PROTOCOL_VERSION || '2025-03-26';
const TOKEN = process.env.TIDEWAVE_TOKEN || '';

const DEBUG = process.env.TIDEWAVE_DEBUG === '1' || process.env.TIDEWAVE_DEBUG === 'true';

const HEADERS = {
  'content-type': 'application/json',
  ...(TOKEN ? { authorization: `Bearer ${TOKEN}` } : {})
};

// ---- stdio framing -------------------------------------------------------
// By default we emit LSP-style frames with Content-Length. If the client sends
// raw JSON without headers, we switch to raw replies to match its expectations.
let OUTPUT_FRAMING = (process.env.TIDEWAVE_FORCE_RAW === '1' || process.env.TIDEWAVE_FORCE_RAW === 'true') ? 'raw' : 'lsp'; // 'lsp' | 'raw'

function writeMessage(obj) {
  try {
    const json = JSON.stringify(obj);
    if (OUTPUT_FRAMING === 'raw') {
      if (DEBUG) {
        console.error(`[tidewave-proxy] -> client RAW json bytes=${Buffer.byteLength(json, 'utf8')}`);
        try { const maybeId = obj && obj.id; console.error(`[tidewave-proxy] -> client id: ${maybeId}`); } catch {}
      }
      process.stdout.write(json + '\n');
    } else {
      const buf = Buffer.from(json, 'utf8');
      if (DEBUG) {
        console.error(`[tidewave-proxy] -> client Content-Length: ${buf.length}`);
        try { const maybeId = obj && obj.id; console.error(`[tidewave-proxy] -> client id: ${maybeId}`); } catch {}
      }
      process.stdout.write(`Content-Length: ${buf.length}\r\n\r\n`);
      process.stdout.write(buf);
    }
  } catch (e) {
    // Last resort: log to stderr.
    console.error('[tidewave-proxy] writeMessage error:', e);
  }
}

let stdinBuf = Buffer.alloc(0);
let RAW_BUFFER = '';
process.stdin.on('data', (chunk) => {
  if (DEBUG) console.error(`[tidewave-proxy] stdin chunk bytes=${chunk.length}`);
  stdinBuf = Buffer.concat([stdinBuf, chunk]);
  while (true) {
    let headerEndCRLF = stdinBuf.indexOf('\r\n\r\n');
    let headerEndLF = headerEndCRLF === -1 ? stdinBuf.indexOf('\n\n') : -1;
    const headerEnd = headerEndCRLF !== -1 ? headerEndCRLF : headerEndLF;
    const delimLen = headerEndCRLF !== -1 ? 4 : (headerEndLF !== -1 ? 2 : 0);

    if (headerEnd === -1) {
      // No LSP header; accumulate raw JSON stream and extract complete objects
      RAW_BUFFER += stdinBuf.toString('utf8');
      if (DEBUG) console.error(`[tidewave-proxy] no header yet; buffer bytes=${stdinBuf.length}`);
      stdinBuf = Buffer.alloc(0);
      const { messages, remainder } = extractJsonObjects(RAW_BUFFER);
      RAW_BUFFER = remainder;
      if (messages.length > 0) {
        OUTPUT_FRAMING = 'raw'; // mirror client style
        for (const msg of messages) {
          try {
            const obj = JSON.parse(msg);
            if (DEBUG) console.error('[tidewave-proxy] RAW JSON fallback');
            handleClientMessage(JSON.stringify(obj)).catch((e)=>{
              if (DEBUG) console.error('[tidewave-proxy] handle error:', e?.message || e);
            });
          } catch (e) {
            if (DEBUG) console.error('[tidewave-proxy] RAW parse error:', e?.message || e);
          }
        }
        continue;
      } else {
        // need more bytes
        break;
      }
    }

    const header = stdinBuf.slice(0, headerEnd).toString('utf8');
    if (DEBUG) console.error(`[tidewave-proxy] header=\n${header}`);
    const m = header.match(/Content-Length:\s*(\d+)/i);
    if (!m) { stdinBuf = stdinBuf.slice(headerEnd + delimLen); continue; }
    const len = parseInt(m[1], 10);
    const total = headerEnd + delimLen + len;
    if (stdinBuf.length < total) break;
    const body = stdinBuf.slice(headerEnd + delimLen, total).toString('utf8');
    if (DEBUG) console.error(`[tidewave-proxy] body bytes=${len}`);
    stdinBuf = stdinBuf.slice(total);
    handleClientMessage(body).catch((err) => {
      try {
        const msg = JSON.parse(body);
        writeMessage({ jsonrpc: '2.0', id: msg.id, error: { code: -32603, message: String(err) } });
      } catch {
        console.error('[tidewave-proxy] failed to handle message:', err);
      }
    });
  }
});

process.stdin.on('end', () => process.exit(0));
process.on('SIGINT', () => process.exit(0));
process.on('SIGTERM', () => process.exit(0));

// ---- HTTP RPC forwarder ---------------------------------------------------
async function handleClientMessage(body) {
  // Forward JSON-RPC payload to TideWave HTTP endpoint (POST only)
  const url = joinUrl(BASE, RPC_PATH);
  let payload = body;
  try {
    const msg = JSON.parse(body);
    if (DEBUG) console.error(`[tidewave-proxy] <- client method=${msg.method} id=${msg.id}`);
    if (msg && msg.method === 'initialize') {
      // Ensure protocolVersion is provided as required by TideWave
      msg.params = msg.params || {};
      if (!msg.params.protocolVersion) {
        msg.params.protocolVersion = PROTOCOL_VERSION;
      }
      payload = JSON.stringify(msg);
    }
  } catch {
    // if not JSON, just pass through
  }
  if (DEBUG) console.error(`[tidewave-proxy] POST ${url}`);
  const res = await fetch(url, { method: 'POST', headers: HEADERS, body: payload });
  const text = await res.text();
  if (DEBUG) console.error(`[tidewave-proxy] HTTP ${res.status} bytes=${Buffer.byteLength(text)}`);

  // If non-2xx, try to pass through error in JSON-RPC error shape
  if (!res.ok) {
    let id = null;
    try { id = JSON.parse(body).id; } catch {}
    writeMessage({ jsonrpc: '2.0', id, error: { code: -32000, message: `HTTP ${res.status}: ${text}` } });
    return;
  }

  try {
    const reply = JSON.parse(text);
    writeMessage(reply);
  } catch (e) {
    // In case server returns ND-JSON or text, wrap into JSON-RPC error
    let id = null;
    try { id = JSON.parse(body).id; } catch {}
    writeMessage({ jsonrpc: '2.0', id, error: { code: -32700, message: 'Invalid JSON from server' } });
  }
}

// ---- SSE (disabled by default; TideWave returns 405 on GET /mcp) ---------
async function startSSE() {
  if (!EVENTS_PATH) return; // disabled unless explicitly configured
  const url = joinUrl(BASE, EVENTS_PATH);
  for (;;) {
    try {
      const res = await fetch(url, { headers: { accept: 'text/event-stream', ...HEADERS }, signal: AbortSignal.timeout(90_000) });
      if (!res.ok || !res.body) {
        await delay(1000);
        continue;
      }
      await pumpEventStream(res.body);
    } catch {
      await delay(1000);
    }
  }
}

async function pumpEventStream(stream) {
  const reader = stream.getReader();
  const decoder = new TextDecoder('utf-8');
  let buffer = '';
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    let idx;
    while ((idx = buffer.indexOf('\n\n')) !== -1) {
      const rawEvent = buffer.slice(0, idx);
      buffer = buffer.slice(idx + 2);
      const dataLines = rawEvent
        .split(/\r?\n/)
        .filter((l) => l.startsWith('data:'))
        .map((l) => l.slice(5).trim());
      if (dataLines.length > 0) {
        const payload = dataLines.join('\n');
        try {
          const msg = JSON.parse(payload);
          writeMessage(msg);
        } catch {
          // non-JSON data: ignore
        }
      }
    }
  }
}

function joinUrl(base, path) {
  if (!path) return base; // no extra path
  const b = base.endsWith('/') ? base.slice(0, -1) : base;
  const p = path.startsWith('/') ? path : `/${path}`;
  return `${b}${p}`;
}

function delay(ms) { return new Promise((r) => setTimeout(r, ms)); }

// Start SSE listener (no-op unless EVENTS_PATH set)
startSSE();

// Extract complete JSON objects from a raw string stream (handles concatenated
// messages and partials). We track brace depth while skipping braces inside
// quoted strings and escaped quotes.
function extractJsonObjects(s) {
  const out = [];
  let depth = 0;
  let inString = false;
  let escape = false;
  let start = -1;
  for (let i = 0; i < s.length; i++) {
    const ch = s[i];
    if (inString) {
      if (escape) {
        escape = false;
      } else if (ch === '\\') {
        escape = true;
      } else if (ch === '"') {
        inString = false;
      }
      continue;
    }
    if (ch === '"') {
      inString = true;
      continue;
    }
    if (ch === '{') {
      if (depth === 0) start = i;
      depth++;
    } else if (ch === '}') {
      if (depth > 0) depth--;
      if (depth === 0 && start !== -1) {
        out.push(s.slice(start, i + 1));
        start = -1;
      }
    }
  }
  let remainder = '';
  if (depth > 0 && start !== -1) {
    remainder = s.slice(start);
  } else {
    // include any trailing whitespace/newlines after last complete object
    const lastEnd = out.length > 0 ? s.lastIndexOf(out[out.length - 1]) + out[out.length - 1].length : 0;
    remainder = s.slice(lastEnd);
  }
  return { messages: out, remainder };
}
