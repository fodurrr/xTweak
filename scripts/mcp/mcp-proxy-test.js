const cp = require('child_process');
const path = '/home/fodurrr/dev/xpando_ai/scripts/mcp/tidewave-stdio-proxy.js';
const p = cp.spawn('node', [path], { stdio: ['pipe', 'pipe', 'pipe'] });
const msg = JSON.stringify({ jsonrpc: '2.0', id: 1, method: 'initialize', params: { clientInfo: { name: 'test' }, capabilities: {}, protocolVersion: '2025-03-26' } });
const header = 'Content-Length: ' + Buffer.byteLength(msg, 'utf8') + '\r\n\r\n'; const frame = Buffer.concat([Buffer.from(header, 'utf8'), Buffer.from(msg, 'utf8')]);
p.stderr.on('data', d => process.stderr.write(d)); p.stdout.on('data', d => process.stdout.write(d)); p.stdin.write(frame); setTimeout(() => p.kill('SIGTERM'), 1500);        
