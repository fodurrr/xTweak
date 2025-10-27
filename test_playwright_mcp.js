// Test script to verify Playwright MCP server connection
const { spawn } = require('child_process');

console.log('Testing Playwright MCP server with Microsoft Edge...');

const mcpServer = spawn('npx', ['@playwright/mcp', '--browser', 'msedge'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

let responseBuffer = '';

mcpServer.stdout.on('data', (data) => {
  responseBuffer += data.toString();
  console.log('STDOUT:', data.toString());
});

mcpServer.stderr.on('data', (data) => {
  console.error('STDERR:', data.toString());
});

mcpServer.on('error', (error) => {
  console.error('Failed to start MCP server:', error);
});

// Send initialize request
const initRequest = {
  jsonrpc: "2.0",
  id: 1,
  method: "initialize",
  params: {
    protocolVersion: "2025-03-26",
    clientInfo: {
      name: "test-client",
      version: "1.0.0"
    },
    capabilities: {}
  }
};

const requestString = JSON.stringify(initRequest);
const contentLength = Buffer.byteLength(requestString, 'utf8');

// Send properly formatted MCP request
mcpServer.stdin.write(`Content-Length: ${contentLength}\r\n\r\n${requestString}`);

// Timeout after 10 seconds
setTimeout(() => {
  console.log('Test completed or timed out');
  mcpServer.kill();
  process.exit(0);
}, 10000);
