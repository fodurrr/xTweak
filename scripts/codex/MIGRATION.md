# Codex CLI MCP Migration Guide

**Date**: October 28, 2025
**Branch**: `main`
**Status**: ✅ Complete

## Summary

Successfully completed two major simplifications:
1. Migrated from Node.js proxy-based MCP configuration to native HTTP support in Codex CLI 0.50+
2. Simplified configuration from `scripts/codex/local/` with `CODE_CONFIG_HOME` to project-local `.codex/config.toml`

These changes eliminate complexity and make Codex CLI usage straightforward for all team members.

## What Changed

### Before (Proxy-Based)
```toml
[mcp_servers.tidewave]
command = "node"
args = ["/path/to/scripts/mcp/tidewave-stdio-proxy.js"]
env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp" }

[mcp_servers.ash_ai]
command = "node"
args = ["/path/to/scripts/mcp/ashai-stdio-proxy.js"]
env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp" }
```

### After (Native HTTP)
```toml
# Enable native HTTP MCP support
experimental_use_rmcp_client = true

[mcp_servers.tidewave]
url = "http://127.0.0.1:4000/tidewave/mcp"

[mcp_servers.ash_ai]
url = "http://127.0.0.1:4000/ash_ai/mcp"
```

## Phase 2: Configuration Simplification (October 28, 2025)

### What Changed

**Before**: Complex setup with template files, setup script, and environment variables
- Configuration template: `scripts/codex/config.xtweak.toml` (with `{{PROJECT_ROOT}}` placeholders)
- Setup script: `scripts/codex/setup.sh` (replaced placeholders, wrote to `scripts/codex/local/`)
- Runtime: Required `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex ...` for every command
- Version control: Template checked in, generated local config in `.gitignore`

**After**: Simple project-local configuration
- Configuration file: `.codex/config.toml` (project root, checked into version control)
- No setup script needed
- Runtime: Just `cd /path/to/xTweak && codex ...` - automatic config detection
- Version control: Production config checked in, only cache/sessions ignored

### Simplification Steps

1. **Created `.codex/config.toml`**: Moved all 21 profiles and MCP server configurations to project root
2. **Removed obsolete files**:
   - `scripts/codex/config.xtweak.toml` (template no longer needed)
   - `scripts/codex/setup.sh` (setup script no longer needed)
   - `scripts/codex/local/` (entire directory removed)
3. **Updated `.gitignore`**: Changed from ignoring `scripts/codex/local/` to `.codex/cache/` and `.codex/sessions/`
4. **Updated `scripts/codex/validate.sh`**: Now checks for `.codex/config.toml` instead of `scripts/codex/local/config.xtweak.toml`
5. **Updated documentation**:
   - `AGENTS.md` - New simple workflow instructions
   - `docs/codex_profiles.md` - Removed `CODE_CONFIG_HOME` references
   - `dev_docs/codex_mcp_troubleshooting.md` - Updated paths

### Benefits

1. **Zero setup required**: New team members just clone and run `codex` from project root
2. **No environment variables**: No need to remember or export `CODE_CONFIG_HOME`
3. **Version controlled**: Production config is checked in, ensuring consistency across team
4. **Simpler commands**: `codex --profile xtweak-review` instead of `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-review`
5. **Less maintenance**: No template placeholders to manage or setup scripts to maintain

### New Workflow

```bash
# That's it! No CODE_CONFIG_HOME, no setup script
cd /path/to/xTweak
codex --profile xtweak-mcp-verify-first "PLAN"
```

Old workflow (obsolete):
```bash
# Old way - DEPRECATED
cd /path/to/xTweak
bash scripts/codex/setup.sh  # Generate config from template
CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first "PLAN"
```

## Phase 1: Migration Steps (Native HTTP MCP)

### 1. Update Configuration Files

**Project config** (`.codex/config.toml`):
```toml
# Enable native HTTP MCP support
experimental_use_rmcp_client = true

# Update model (optional but recommended)
model = "gpt-5-codex-medium"

# Replace old MCP server configs with:
[mcp_servers.tidewave]
url = "http://127.0.0.1:4000/tidewave/mcp"

[mcp_servers.ash_ai]
url = "http://127.0.0.1:4000/ash_ai/mcp"
```

**Note**: Global config (`~/.codex/config.toml`) can also be updated for personal use outside this project.

### 2. Archive Proxy Scripts

Proxy scripts moved to `scripts/mcp/archive/`:
- `tidewave-stdio-proxy.js.bak`
- `ashai-stdio-proxy.js.bak`
- `mcp-proxy-test.js.bak`

These are kept for rollback purposes and can be permanently deleted after 1 week of successful operation.

### 3. Verify Configuration

```bash
# List all MCP servers
codex mcp list

# Expected output:
# HTTP servers (TideWave, AshAI): transport: streamable_http
# STDIO servers (Context7, Playwright): command-based

# Check specific server
codex mcp get tidewave
# Should show: transport: streamable_http
```

### 4. Test Functionality

All MCP tools work as before - no functional changes, just improved configuration:
- TideWave: `project_eval`, `get_docs`, `search_package_docs`, etc.
- AshAI: `list_ash_resources`, `list_generators`, `get_usage_rules`
- Context7: `resolve-library-id`, `get-library-docs`
- Playwright: browser automation tools

## Benefits

1. **Simpler configuration**: Direct URL-based configuration instead of proxy scripts
2. **Better performance**: No intermediate proxy layer
3. **Easier troubleshooting**: Native HTTP transport with better error messages
4. **Future-proof**: Uses Codex CLI's official HTTP MCP support
5. **Reduced dependencies**: No need to maintain proxy scripts

## Rollback Procedure

If you need to revert to proxy-based configuration:

### 1. Restore Proxy Scripts
```bash
cd scripts/mcp/archive
cp *.bak ..
cd ..
rename 's/\.bak$//' *.bak
```

### 2. Update Configuration
```toml
# Remove experimental_use_rmcp_client flag

[mcp_servers.tidewave]
command = "node"
args = ["/absolute/path/to/scripts/mcp/tidewave-stdio-proxy.js"]
env = { TIDEWAVE_BASE_URL = "http://127.0.0.1:4000/tidewave/mcp" }

[mcp_servers.ash_ai]
command = "node"
args = ["/absolute/path/to/scripts/mcp/ashai-stdio-proxy.js"]
env = { ASHAI_BASE_URL = "http://127.0.0.1:4000/ash_ai/mcp" }
```

### 3. Verify Configuration
```bash
cd /path/to/xTweak
codex mcp list  # Verify servers are detected
```

## Troubleshooting

### MCP servers not detected
**Solution**: Ensure `experimental_use_rmcp_client = true` is at the top of your config file.

### Wrong transport type
**Solution**: Remove old `command` and `args` fields, use only `url` field for HTTP servers.

### Connection timeouts
**Solution**:
- Verify Phoenix server is running: `mix phx.server`
- Test endpoints with curl (see `dev_docs/codex_mcp_troubleshooting.md`)
- Use `127.0.0.1` instead of `localhost`

## Files Modified

### Phase 1 (Native HTTP MCP)
- `~/.codex/config.toml` - Updated global configuration (optional)
- `.gitignore` - Added `scripts/mcp/archive/` exclusion
- Archived: `scripts/mcp/*.js` → `scripts/mcp/archive/*.js.bak`

### Phase 2 (Configuration Simplification)
- **Created**: `.codex/config.toml` - Project-local configuration with all 21 profiles
- **Removed**: `scripts/codex/config.xtweak.toml` - Template no longer needed
- **Removed**: `scripts/codex/setup.sh` - Setup script no longer needed
- **Removed**: `scripts/codex/local/` - Entire directory deleted
- **Updated**: `.gitignore` - Changed to `.codex/cache/` and `.codex/sessions/`
- **Updated**: `scripts/codex/validate.sh` - Now checks `.codex/config.toml`
- **Updated**: `AGENTS.md` - Simple workflow instructions
- **Updated**: `docs/codex_profiles.md` - Removed `CODE_CONFIG_HOME` references
- **Updated**: `dev_docs/codex_mcp_troubleshooting.md` - Updated paths

## Validation Checklist

### Phase 1 (Native HTTP MCP)
- [x] All 4 MCP servers detected by `codex mcp list`
- [x] TideWave and AshAI show `transport: streamable_http`
- [x] Context7 and Playwright remain stdio-based
- [x] Default model set to `gpt-5-codex-medium`
- [x] Proxy scripts archived with `.bak` extension

### Phase 2 (Configuration Simplification)
- [x] `.codex/config.toml` created with all 21 profiles
- [x] Obsolete files removed (`scripts/codex/config.xtweak.toml`, `scripts/codex/setup.sh`, `scripts/codex/local/`)
- [x] `.gitignore` updated to handle `.codex/` directory properly
- [x] `scripts/codex/validate.sh` updated and passing
- [x] Documentation updated (AGENTS.md, docs/codex_profiles.md, dev_docs/codex_mcp_troubleshooting.md)
- [x] Simple workflow tested: `cd /path/to/xTweak && codex --profile xtweak-mcp-verify-first "test"`

## References

- Codex CLI docs: https://developers.openai.com/codex/mcp/
- Context7 MCP: Used for documentation lookups
- Migration branch: `codex-mcp-updates`
- Troubleshooting guide: `dev_docs/codex_mcp_troubleshooting.md`

## Support

For issues or questions:
1. Check `dev_docs/codex_mcp_troubleshooting.md`
2. Run `codex mcp list` and `codex mcp get <server_name>`
3. Verify Phoenix server is running
4. Review this migration guide's rollback procedure
