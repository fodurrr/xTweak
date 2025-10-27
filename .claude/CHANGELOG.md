# Claude CLI Change Log

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
