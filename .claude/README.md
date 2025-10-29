# Claude Code Configuration

This directory contains project-local Claude Code configuration for the xTweak project.

## Configuration Files

### `settings.json` (THIS FILE)
**Location**: `.claude/settings.json`
**Purpose**: Team-shared configuration for permissions and MCP server enablement
**Format**: Pure JSON (no comments allowed)
**Version Controlled**: Yes

**Important**: This file must be valid JSON without comments. Claude Code does not support JSONC (JSON with Comments).

### Configuration Hierarchy

Settings are merged with the following precedence (highest to lowest):
1. Command-line arguments
2. `.claude/settings.local.json` (personal overrides, gitignored)
3. `.claude/settings.json` (THIS FILE - team-shared)
4. `~/.claude/settings.json` (user global)

## MCP Server Configuration

**Important**: MCP server definitions are in `.mcp.json` at the project root (not in this folder).

Claude Code requires `.mcp.json` to be at the project root for MCP server discovery.

### Two-File Structure

```
.mcp.json                    ← MCP server DEFINITIONS (required location)
.claude/
└── settings.json            ← MCP ENABLEMENT + permissions
```

### Configured MCP Servers

See `.mcp.json` (project root) for server definitions:

- **tidewave**: Elixir/Phoenix project evaluation (HTTP: `http://127.0.0.1:4000/tidewave/mcp`)
- **ash_ai**: Ash Framework generators (HTTP: `http://127.0.0.1:4000/ash_ai/mcp`)
- **playwright**: Browser automation (stdio: `npx @playwright/mcp --browser msedge`)
- **context7**: Library documentation (stdio: `npx -y @upstash/context7-mcp`)

### MCP Server Enablement

In `settings.json`:
- `enableAllProjectMcpServers: true` - Auto-approve all servers from `.mcp.json`
- `enabledMcpjsonServers: [...]` - Explicitly list enabled servers

## Tool Permissions

The `permissions` object controls what Claude Code can access and execute.

### Permission Patterns

Format: `"ToolName(pattern)"` where pattern uses glob syntax.

**Examples**:
- `"Bash(mix test:*)"` - Allow all `mix test` commands
- `"Read(/app/src/**)"` - Allow reading files in `/app/src/`
- `"Edit(**/*.js)"` - Allow editing all JavaScript files

### Allowed Tools

The `permissions.allow` array includes:

**File Operations**: `md-tree`, `mkdir`, `cat`, `mv`, `find`, `grep`

**Mix (Elixir Build Tool)**:
- Dependency management: `mix deps.get`, `mix deps.update`, `mix compile`
- Code quality: `mix format`, `mix dialyzer`
- Testing: `mix test` (various patterns with timeouts)
- Database: `mix ash_postgres.*`, `mix ecto.migrate`

**Web Resources**:
- `WebFetch(domain:hex.pm)` - Hex package manager
- `WebFetch(domain:hexdocs.pm)` - Hex documentation
- `WebFetch(domain:github.com)` - GitHub
- `WebSearch` - General web search

**MCP Tools**:
- TideWave: `mcp__tidewave__*` (project_eval, get_docs, search_package_docs, get_logs, get_ecto_schemas)
- Ash AI: `mcp__ash_ai__*` (list_generators, list_ash_resources)
- Playwright: `mcp__playwright__*` (browser automation)
- Context7: `mcp__context7__*` (library documentation)

### Denied Tools

The `permissions.deny` array blocks access to sensitive directories:

- `.ignore/` - Private notes and scratch files
- `.dev_docs/` - Personal development notes

## Personal Overrides

To customize settings without affecting the team:

1. Create `.claude/settings.local.json` (automatically gitignored)
2. Add your personal overrides
3. Your settings will merge with highest precedence

**Example** `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "Bash(my-custom-command:*)"
    ]
  }
}
```

## Other Directories

- `agents/` - Custom Claude Code agents
- `commands/` - Slash commands
- `patterns/` - Reusable patterns
- `agent-reports/` - Reports from agent executions

## Troubleshooting

**"Invalid or malformed JSON"**:
- Ensure `settings.json` has no comments (JSON does not support comments)
- Validate JSON syntax: `python3 -m json.tool .claude/settings.json`

**"MCP servers not found"**:
- Check that `.mcp.json` exists at project root
- Verify server names match between `.mcp.json` and `enabledMcpjsonServers`
- Ensure Phoenix server is running on port 4000 for HTTP servers

**"Property is not allowed"**:
- Do NOT put `mcpServers` in `settings.json`
- MCP servers MUST be defined in `.mcp.json` (project root)

## Related Files

- `../../.mcp.json` - MCP server definitions (project root)

## Parallel Structure

xTweak uses consistent configuration patterns:

- **Codex CLI**: `.codex/config.toml` (all-in-one config)
- **Claude Code**: `.mcp.json` + `.claude/settings.json` (two-file structure)

Both are project-local, version controlled, and team-shared.
