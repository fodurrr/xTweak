# Codex CLI Change Log

## 2025-10-27
- **Initial Synchronization:** Complete Codex CLI setup synchronized with Claude CLI master
- **Agent System:** Added 21 specialized agent markdown files mirroring Claude agents exactly
- **Pattern Library:** Created symlinked patterns directory (`.codex/patterns/`) pointing to `.claude/patterns/`
- **Agent Documentation:** Created `AGENT_USAGE_GUIDE.md` with Codex launch syntax and agent matrix
- **Workflow System:** Added `agent-workflows.md` with multi-agent sequence patterns
- **Configuration Integration:** Harmonized with existing Codex profile system (`scripts/codex/config.xtweak.toml`)
- **Launch Protocol:** Standardized on `CODE_CONFIG_HOME=$(pwd)/scripts/codex/local codex --profile xtweak-[agent] "PLAN"` syntax
- **Quality Parity:** Achieved feature parity with Claude CLI system (21 agents, 10 patterns, complete documentation)

## Future Entries
- Changes specific to Codex CLI will be tracked here
- Cross-references to Claude CLI changes that affect shared patterns
- Agent updates and new profile additions
- Validation improvements and testing enhancements