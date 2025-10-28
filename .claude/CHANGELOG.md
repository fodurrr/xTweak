# Claude CLI Change Log

## 2025-10-28

### Documentation Flow Refactoring
- **Established one-way tree structure:** Removed circular links between documentation files
- **Entry point hierarchy:** CLAUDE.md, AGENTS.md → docs/README.md → reference materials
- **DEV_PREFERENCES.md priority:** Established as mandatory first read for all AI tools
- **Created docs/README.md:** Central documentation hub linking to all guides and references
- **Simplified navigation:** Entry points link down only, hubs never link back to entry points
- **Files modified:** CLAUDE.md, AGENTS.md, docs/README.md (new), .claude/README.md, README.md, DEV_PREFERENCES.md (new)
- **Result:** Clean information flow with no circular dependencies (entry → hub → references)

### New Agent: tools-config-guardian
- **Purpose:** Verify Claude Code and Codex CLI configurations stay current with latest tool versions
- **Key features:**
  - Configuration validation (JSON/TOML syntax, schema correctness)
  - MCP server health checks (all 4 servers: TideWave, Ash AI, Playwright, Context7)
  - Documentation accuracy validation (structure + content)
  - Version tracking via web research (detect breaking changes)
  - Generates timestamped reports in `.claude/agent-reports/`
- **Usage:** Run monthly or after major tool updates
- **Integration:** Can delegate to `docs-maintainer` for documentation fixes
- **Pattern stack:** All 8 core patterns (placeholder-basics, phase-zero-context, mcp-tool-discipline, self-check-core, dual-example-bridge, context-handling, collaboration-handoff, error-recovery-loop)
- **Updated:** AGENT_USAGE_GUIDE.md with new agent row and Maintenance section

### Codex CLI Configuration Simplification (Phase 2)
- **Simplified configuration:** From `scripts/codex/local/` to project-local `.codex/config.toml`
  - Created `.codex/config.toml` with all 21 profiles and MCP server configurations at project root
  - Removed obsolete files: `scripts/codex/config.xtweak.toml` (template), `scripts/codex/setup.sh` (setup script), `scripts/codex/local/` (entire directory)
  - Updated `.gitignore` to properly handle `.codex/` directory (keep config, ignore cache/sessions)
  - Updated `scripts/codex/validate.sh` to check `.codex/config.toml` instead of `scripts/codex/local/config.xtweak.toml`
  - Updated `Makefile` to remove `codex-setup` target and simplify `codex-validate` help text
  - Updated documentation: `docs/codex_profiles.md`, `dev_docs/codex_mcp_troubleshooting.md`, `scripts/codex/MIGRATION.md` with Phase 2 section
  - Simplified workflow: `cd /path/to/xTweak && codex --profile <name>` (no `CODE_CONFIG_HOME` needed!)
  - Benefits: Zero setup required, no environment variables, version controlled config, simpler commands, less maintenance

- **Codex CLI Native HTTP MCP Migration (Phase 1):** Migrated from proxy-based MCP configuration to native HTTP support in Codex CLI 0.50+
  - Enabled `experimental_use_rmcp_client` flag for native HTTP MCP support
  - Configured TideWave and AshAI with direct HTTP URLs in `.codex/config.toml`
  - Archived legacy proxy scripts to `scripts/mcp/archive/*.bak`
  - Updated `.gitignore` to exclude archived proxy scripts
  - Created comprehensive migration guide at `scripts/codex/MIGRATION.md`
  - Updated troubleshooting guide at `dev_docs/codex_mcp_troubleshooting.md` for native HTTP
  - Updated `docs/codex_profiles.md` with native HTTP examples and MCP integration section
  - Updated `AGENTS.md` to replace proxy-based setup with native HTTP configuration
  - All 4 MCP servers verified working (TideWave, AshAI via HTTP; Context7, Playwright via stdio)
  - Benefits: Simpler configuration, better performance, no proxy layer, easier troubleshooting

## 2025-10-27
- **Dependency Upgrade:** Completed comprehensive phased upgrade of 30 packages (Ash 3.5.42 → 3.7.6, Phoenix ecosystem, dev tools)
- **Security Fix:** Applied CVE-2025-48043 patch (Ash policy bypass vulnerability)
- **Newsletter Resource:** Added authorization policies for defense-in-depth security
- **Dialyzer Cleanup:** Cleared all project-specific Dialyzer warnings
- **Configuration Fix:** Corrected legacy `xpando_web` → `xtweak_web` references in runtime.exs
- **Documentation Updates:** Updated README.md, CLAUDE.md, and app-level READMEs with current versions and features
- **Agent Report:** Added detailed dependency audit report to `.claude/agent-reports/2025-10-27-dependency-auditor-phased-upgrade.md`

## 2025-10-02
- Established versioned pattern library (`placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`, `ash-resource-template`, `error-recovery-loop`, `context-handling`, `collaboration-handoff`).
- Standardized all agents with metadata (`version`, `updated`, `pattern-stack`) and concise prompts.
- Added planning document `CLAUDE_CLI_REFACTOR_PLAN.md` plus quick references (`docs/claude/pattern-guide.md`, `docs/claude/quick-reference.md`).
- Introduced lightweight compliance script (`scripts/check_claude_patterns.exs`).
- Added new operational agents: `docs-maintainer`, `release-coordinator`, `dependency-auditor`, `database-migration-specialist`, `performance-profiler`, `api-contract-guardian`, `ci-cd-optimizer`, `monitoring-setup`, `pattern-librarian`, `beam-runtime-specialist`, `daisyui-expert`, `tailwind-strategist`.
- Updated agent usage/workflow docs to incorporate new personas.
