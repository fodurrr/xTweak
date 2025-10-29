# Claude CLI Change Log

## 2025-10-30

### Pattern Library Audit and Compliance Fixes

**Audit Report:** `.claude/agent-reports/pattern-audit-2025-10-30.md`

Comprehensive audit of pattern library and all agent pattern-stack declarations revealed 3 critical issues now resolved:

**Issues Fixed:**

1. **error-recovery-haiku.md Missing YAML Frontmatter (CRITICAL)**
   - Pattern file existed but lacked proper `---` YAML frontmatter
   - Added complete frontmatter: title, version (1.0.0), updated (2025-10-29), tags
   - Restores metadata consistency across all patterns
   - File had inline metadata (e.g., `**Version**: 1.0.0`) which is non-standard

2. **Self-Check Core Version Skew Across All Agents (HIGH)**
   - Pattern updated to v1.1.0 on 2025-10-29 (model selection strategy)
   - ALL 24 agents still referenced outdated `self-check-core@1.0.0`
   - Updated all 24 agent files to reference `self-check-core@1.1.0`
   - Affected agents now use updated model-specific workflow validation
   - Verified: 24/24 agents now reference v1.1.0

3. **HEEx Template Expert Incomplete Pattern Stack (HIGH)**
   - New agent v1.2.0 (updated 2025-10-30) referenced only 6 patterns
   - Added `context-handling@1.0.0` - for managing LiveView state across refactors
   - Added `error-recovery-loop@1.0.0` - for handling rendering failures and edge cases
   - Pattern stack now 8 patterns (aligned with frontend-design-enforcer)

**Pattern Library Enhancements:**

- **Pattern Index Updated** (`.claude/patterns/README.md`)
  - Updated version: 1.0.0 → 1.1.0 (2025-10-30)
  - Added version column to Core Stack table (tracking v1.0.0 and v1.1.0)
  - Updated Self-Check Core description to note model-specific workflows
  - Added error-recovery-haiku to Specialized Patterns table
  - Now lists all 10 patterns (including error-recovery-haiku which was missing)

**Verification Results:**

- All 11 pattern files have proper YAML frontmatter ✓
- Zero version mismatches between agents and pattern files ✓
- Zero broken pattern references ✓
- No circular dependencies in pattern dependency graph ✓
- All Haiku agents (6) properly include error-recovery-haiku pattern ✓

**Audit Statistics:**

- Patterns audited: 11 files
- Agents audited: 24 agents
- Pattern usage: 100% coverage of Core Stack, 62.5% coverage of Specialized Patterns
- Critical issues resolved: 3/3
- High-priority issues resolved: 2/3

**Impact:**

- Restores pattern metadata consistency and discoverability
- Aligns all agents with latest model-specific validation workflows
- Enables heex-template-expert to properly recover from rendering errors and state conflicts
- Pattern index now complete and discoverable

---

## 2025-10-29

### HEEx Template Expert Agent

**New Agent:** `heex-template-expert` v1.0.0 → v1.2.0 (updated 2025-10-30)

Specialized agent for generating and refactoring production-grade HEEx templates using modern Phoenix 1.8+ directives.

**Key Capabilities:**
- Enforces modern HEEx syntax (`:if`, `:for`, `:let`) over legacy EEx (`<%= if %>`, `<% for %>`)
- Complete `attr/3` and `slot/3` type specifications with documentation
- Accessibility compliance (ARIA roles, keyboard navigation, focus management)
- Ash form integration (`AshPhoenix.Form` patterns)
- Phoenix.LiveView.JS helper patterns (declarative event handling)
- Tailwind CSS utility-first styling
- Security defaults (auto-escaping, minimal `raw/1` usage)

**Pattern Stack:**
- placeholder-basics@1.0.0
- phase-zero-context@1.0.0
- mcp-tool-discipline@1.0.0
- self-check-core@1.0.0
- dual-example-bridge@1.0.0
- collaboration-handoff@1.0.0

**Integration:**
- Works downstream of `frontend-design-enforcer` (design → implementation)
- Coordinates with `daisyui-expert`, `nuxt-ui-expert`, `tailwind-strategist` for component/styling research
- Feeds into `test-builder` (testable component patterns) and `code-reviewer` (compliance auditing)

**Common Use Cases:**
- Refactoring legacy xtweak_ui Button component (currently using `<%= if %>` on lines 127-152)
- Creating new accessible components (modals, dropdowns, cards, forms)
- Auditing existing templates for HEEx directive compliance
- Generating Ash form integrations with proper validation/error display

**Documentation Updates:**
- Added to AGENT_USAGE_GUIDE.md Quick Selection Matrix
- Updated frontend-design-enforcer, daisyui-expert, nuxt-ui-expert, tailwind-strategist follow-up chains
- Incremented Sonnet agent count from 17 to 18
- Added "HEEx refactoring" pattern shortcut

**Model:** Sonnet 4.5 (requires design reasoning and accessibility analysis)

### Model Selection Strategy Implementation

**Strategic Change:** Introduced cost optimization strategy converting 26% of agent fleet (6 agents) to Haiku 4.5 with structured escalation to Sonnet 4.5.

**Philosophy:**
- **Haiku 4.5:** Bounded implementation tasks with clear patterns (~90% cheaper than Sonnet)
- **Sonnet 4.5:** Architecture, analysis, coordination, complex reasoning (baseline cost)
- **Escalation:** Automatic via structured error messages when Haiku encounters complexity

**Converted Agents (6):**
1. `mcp-verify-first` v1.2.0 - Structured MCP context gathering
2. `docs-maintainer` v1.1.0 - Markdown editing and changelog updates
3. `code-review-implement` v1.2.0 - Applying structured review feedback
4. `database-migration-specialist` v1.1.0 - Schema-focused SQL generation
5. `pattern-librarian` v1.1.0 - Pattern compliance auditing
6. `monitoring-setup` v1.1.0 - Telemetry configuration

**New Pattern:**
- `error-recovery-haiku` v1.0.0 - Haiku-specific error handling with escalation format

**Updated Patterns:**
- `self-check-core` v1.1.0 - Added model-specific workflow validation checkpoints

**Documentation Updates:**
- `.claude/MODEL_SELECTION_STRATEGY.md` (new) - Complete philosophy, agent assignments, cost analysis
- `.claude/agent-workflows.md` - Added model selection overview, decision trees, escalation recognition
- `.claude/AGENT_USAGE_GUIDE.md` - Added model selection matrix with cost factors and escalation patterns
- `docs/claude/quick-reference.md` - Added model selection quick reference with agent cheat sheet

**Expected Impact:**
- 26% of agent fleet on Haiku (targeting 40-50% of execution volume)
- 30-40% cost reduction with <10% escalation rate
- Maintains quality through automatic escalation on complexity

**Escalation Triggers:**
- Compile errors requiring deep analysis
- Test failures with unclear root cause
- MCP server errors after retry
- Pattern interpretation ambiguity
- Complex architectural decisions

**All Haiku agents now:**
- Include `error-recovery-haiku@1.0.0` in pattern-stack
- Document agent-specific escalation triggers
- Provide structured escalation output format
- Include pre-escalation checklist

### New Agent: nuxt-ui-expert
- **Purpose:** Read-only Nuxt UI component API research via MCP server
- **Key features:**
  - Queries Nuxt UI MCP server (`nuxt-ui-remote`) for component specifications
  - Extracts props, slots, events, variants, sizes, and colors
  - Returns dual-format output: markdown tables (human-readable) + JSON schema (machine-readable)
  - Documents accessibility patterns (ARIA, keyboard navigation, screen reader support)
  - Strict read-only mode: NO implementation recommendations or code generation
- **MCP servers:** nuxt-ui-remote (primary), context7 (fallback)
- **Pattern stack:** placeholder-basics, phase-zero-context, mcp-tool-discipline, self-check-core, dual-example-bridge
- **Integration:** Designed to feed structured component data to `frontend-design-enforcer` for implementation
- **Output template:** Standardized format with overview, props table, slots, events, variants, accessibility notes, and JSON schema
- **Use cases:**
  - Pre-implementation component API research
  - Design system component comparison
  - Accessibility pattern documentation
  - Multi-agent workflows (research → implementation → testing)
- **Updated files:**
  - `.claude/agents/nuxt-ui-expert.md` (new agent)
  - `.claude/AGENT_USAGE_GUIDE.md` (added to Quick Selection Matrix and Pattern Shortcuts)
  - `docs/codex_profiles.md` (added xtweak-nuxt-ui-expert profile)
  - `docs/claude/quick-reference.md` (added to Agent Cheat Sheet)
  - `.claude/CHANGELOG.md` (this entry)

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
