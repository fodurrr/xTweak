#!/usr/bin/env node
/**
 * Ash AI MCP stdio↔HTTP proxy
 *
 * Bridges Codex CLI (stdio MCP) to the Ash AI HTTP MCP endpoint.
 * Requires Node.js >= 18 (global fetch + WHATWG streams).
 *
 * Env:
 *  - ASHAI_BASE_URL          default: http://127.0.0.1:4000/ash_ai/mcp
 *  - ASHAI_PROTOCOL_VERSION  default: 2025-03-26
 *  - ASHAI_FORCE_RAW         "1" to always reply with raw JSON
 *  - ASHAI_TOKEN             optional Authorization: Bearer <token>
 *  - ASHAI_DEBUG             "1" for verbose stderr logs
 */

const BASE = process.env.ASHAI_BASE_URL || 'http://127.0.0.1:4000/ash_ai/mcp';
const TOKEN = process.env.ASHAI_TOKEN || '';
const PROTOCOL_VERSION = process.env.ASHAI_PROTOCOL_VERSION || '2025-03-26';
const DEBUG = process.env.ASHAI_DEBUG === '1' || process.env.ASHAI_DEBUG === 'true';

let OUTPUT_FRAMING = (process.env.ASHAI_FORCE_RAW === '1' || process.env.ASHAI_FORCE_RAW === 'true') ? 'raw' : 'lsp';

const HEADERS = {
  'content-type': 'application/json',
  ...(TOKEN ? { authorization: `Bearer ${TOKEN}` } : {})
};

function writeMessage(obj) {
  try {
    const json = JSON.stringify(obj);
    if (OUTPUT_FRAMING === 'raw') {
      if (DEBUG) {
        console.error(`[ashai-proxy] -> client RAW json bytes=${Buffer.byteLength(json, 'utf8')}`);
        try { console.error(`[ashai-proxy] -> client id: ${obj?.id}`); } catch {}
      }
      process.stdout.write(json + '\n');
    } else {
      const buf = Buffer.from(json, 'utf8');
      if (DEBUG) {
        console.error(`[ashai-proxy] -> client Content-Length: ${buf.length}`);
        try { console.error(`[ashai-proxy] -> client id: ${obj?.id}`); } catch {}
      }
      process.stdout.write(`Content-Length: ${buf.length}\r\n\r\n`);
      process.stdout.write(buf);
    }
  } catch (e) {
    console.error('[ashai-proxy] writeMessage error:', e);
  }
}

let stdinBuf = Buffer.alloc(0);
let RAW_BUFFER = '';

process.stdin.on('data', (chunk) => {
  if (DEBUG) console.error(`[ashai-proxy] stdin chunk bytes=${chunk.length}`);
  stdinBuf = Buffer.concat([stdinBuf, chunk]);
  while (true) {
    let headerEndCRLF = stdinBuf.indexOf('\r\n\r\n');
    let headerEndLF = headerEndCRLF === -1 ? stdinBuf.indexOf('\n\n') : -1;
    const headerEnd = headerEndCRLF !== -1 ? headerEndCRLF : headerEndLF;
    const delimLen = headerEndCRLF !== -1 ? 4 : (headerEndLF !== -1 ? 2 : 0);

    if (headerEnd === -1) {
      RAW_BUFFER += stdinBuf.toString('utf8');
      if (DEBUG) console.error(`[ashai-proxy] no header yet; buffer bytes=${stdinBuf.length}`);
      stdinBuf = Buffer.alloc(0);
      const { messages, remainder } = extractJsonObjects(RAW_BUFFER);
      RAW_BUFFER = remainder;
      if (messages.length > 0) {
        OUTPUT_FRAMING = OUTPUT_FRAMING === 'lsp' ? 'raw' : OUTPUT_FRAMING;
        for (const msg of messages) {
          try {
            const obj = JSON.parse(msg);
            if (DEBUG) console.error('[ashai-proxy] RAW JSON fallback');
            handleClientMessage(JSON.stringify(obj)).catch((e)=>{
              if (DEBUG) console.error('[ashai-proxy] handle error:', e?.message || e);
            });
          } catch (e) {
            if (DEBUG) console.error('[ashai-proxy] RAW parse error:', e?.message || e);
          }
        }
        continue;
      } else {
        break; // need more bytes
      }
    }

    const header = stdinBuf.slice(0, headerEnd).toString('utf8');
    if (DEBUG) console.error(`[ashai-proxy] header=\n${header}`);
    const m = header.match(/Content-Length:\s*(\d+)/i);
    if (!m) { stdinBuf = stdinBuf.slice(headerEnd + delimLen); continue; }
    const len = parseInt(m[1], 10);
    const total = headerEnd + delimLen + len;
    if (stdinBuf.length < total) break;
    const body = stdinBuf.slice(headerEnd + delimLen, total).toString('utf8');
    if (DEBUG) console.error(`[ashai-proxy] body bytes=${len}`);
    stdinBuf = stdinBuf.slice(total);
    handleClientMessage(body).catch((err) => {
      try {
        const msg = JSON.parse(body);
        writeMessage({ jsonrpc: '2.0', id: msg.id, error: { code: -32603, message: String(err) } });
      } catch {
        console.error('[ashai-proxy] failed to handle message:', err);
      }
    });
  }
});

process.stdin.on('end', () => process.exit(0));
process.on('SIGINT', () => process.exit(0));
process.on('SIGTERM', () => process.exit(0));

async function handleClientMessage(body) {
  const url = BASE; // POST-only endpoint
  let payload = body;
  try {
    const msg = JSON.parse(body);
    if (DEBUG) console.error(`[ashai-proxy] <- client method=${msg.method} id=${msg.id}`);
    if (msg && msg.method === 'initialize') {
      msg.params = msg.params || {};
      if (!msg.params.protocolVersion) {
        msg.params.protocolVersion = PROTOCOL_VERSION;
      }
      payload = JSON.stringify(msg);
    }
  } catch {}

  if (DEBUG) console.error(`[ashai-proxy] POST ${url}`);
  const res = await fetch(url, { method: 'POST', headers: HEADERS, body: payload });
  const text = await res.text();
  if (DEBUG) console.error(`[ashai-proxy] HTTP ${res.status} bytes=${Buffer.byteLength(text)}`);

  if (!res.ok) {
    let id = null;
    try { id = JSON.parse(body).id; } catch {}
    writeMessage({ jsonrpc: '2.0', id, error: { code: -32000, message: `HTTP ${res.status}: ${text}` } });
    return;
  }

  try {
    const reply = JSON.parse(text);
    writeMessage(reply);
  } catch {
    let id = null;
    try { id = JSON.parse(body).id; } catch {}
    writeMessage({ jsonrpc: '2.0', id, error: { code: -32700, message: 'Invalid JSON from server' } });
  }
}

function extractJsonObjects(s) {
  const out = [];
  let depth = 0, inString = false, escape = false, start = -1;
  for (let i = 0; i < s.length; i++) {
    const ch = s[i];
    if (inString) {
      if (escape) escape = false;
      else if (ch === '\\') escape = true;
      else if (ch === '"') inString = false;
      continue;
    }
    if (ch === '"') { inString = true; continue; }
    if (ch === '{') { if (depth === 0) start = i; depth++; }
    else if (ch === '}') { if (depth > 0) depth--; if (depth === 0 && start !== -1) { out.push(s.slice(start, i+1)); start = -1; } }
  }
  let remainder = '';
  if (depth > 0 && start !== -1) remainder = s.slice(start);
  else {
    const last = out[out.length - 1];
    const lastEnd = last ? s.lastIndexOf(last) + last.length : 0;
    remainder = s.slice(lastEnd);
  }
  return { messages: out, remainder };
}

