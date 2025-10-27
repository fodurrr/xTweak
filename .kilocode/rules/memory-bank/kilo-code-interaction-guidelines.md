# Kilo Code Interaction Guidelines

## Core Principles for AI-Kilo Code Interactions

### 1. Tool Usage Priority
- **Always check available tools first** - Before making assumptions, verify what tools are available
- **Context7 MCP is primary for internet access** - Use Context7 MCP to access current documentation and internet resources
- **MCP first** – Verification beats assumption. Use available MCP tools before writing or editing code

### 2. Information Verification Workflow
1. **Check Context7 MCP first** for current documentation
2. **Verify facts before answering** - Don't rely on assumptions or memory
3. **Use proper channels** - Context7 MCP provides direct access to up-to-date information
4. **Cite sources** - Reference documentation when providing information

### 3. Key Lessons Learned
- **Internet access is available** - Context7 MCP tool provides internet connectivity
- **Don't make assumptions** - Always verify information through proper tools
- **Check before responding** - Use available tools to gather accurate information
- **Generator-first, customize second** – Check available generators, run scaffold, then extend safely

### 4. MCP Configuration Examples
The documentation shows three types of MCP server transports:
- **STDIO** - For local servers (command/args/env)
- **SSE** - Deprecated, use Streamable HTTP instead
- **Streamable HTTP** - For remote servers (url/headers with type: "streamable-http")

### 5. Quality Gates
- Run appropriate format checks for the language
- Run static analysis tools
- Compile with warnings as errors
- Run targeted tests before declaring success

### 6. Memory Bank Usage
- Initialize with `initialize memory bank` command
- Store tasks with `add task` or `store this as a task`
- Update with `update memory bank` command
- Status indicators: `[Memory Bank: Active]` or `[Memory Bank: Missing]`

### 7. File Structure for Rules
- Global: `~/.kilocode/rules/`
- Project: `.kilocode/rules/`
- Mode-specific: `.kilo/rules-{mode-slug}/`

**Last updated:** October 6, 2025
**Context:** AI-Kilo Code interaction improvement session
