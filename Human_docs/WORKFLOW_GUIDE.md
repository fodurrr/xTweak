# xTweak AI Workflow Guide (For Humans)

## 🚀 Quick Start: How to Kick Off Tasks

### Starting Fresh
1. Read this guide (you are here)
2. Use slash commands below

### PRD Workflows (Feature Development)

#### Plan Next Sprint
```
/prd-plan-sprint
```
**What happens**: Claude analyzes PRD, determines next sprint, creates detailed plan.
**Agent**: `docs-maintainer` (Haiku - cost effective)
**Output**: Todo list with sprint objectives and next steps
**Next**: Run `/prd-implement` to start building

#### Start/Continue Implementation
```
/prd-implement
```
**What happens**: Claude reads current sprint plan and executes tasks with specialized agents.
**Agents**: Varies by task (ash-resource-architect, frontend-design-enforcer, test-builder, etc.)
**Output**: Todo list tracking each task, quality gates, and completion status
**Next**: Run `/prd-status` to check progress or `/prd-continue` when done

#### Check Status
```
/prd-status
```
**What happens**: Get dashboard of what's done, what's in progress, what's next.
**Agent**: `mcp-verify-first` (Haiku - fast reporting)
**Output**: Concise dashboard with recommended next action
**Next**: Follow recommendation from dashboard

#### Continue Where You Left Off
```
/prd-continue
```
**What happens**: Claude checks git status, reads QUICK_START.md and sprint reports, determines context, resumes appropriate workflow.
**Agent**: `mcp-verify-first` (Haiku - routes to appropriate workflow)
**Output**: Todo list showing where we left off and what's resuming
**Next**: Automated - Claude continues the workflow

#### Update PRD Section
```
/prd-update 03-architecture
```
**What happens**: Update specific PRD chapter with new decisions/information.
**Agent**: `docs-maintainer` (Haiku - documentation updates)
**Output**: Todo list showing changes made
**Next**: Continue with current sprint or run `/prd-status`

### Command Decision Guide

**"I want to build a feature"** → Use PRD workflows (`/prd-plan-sprint`, `/prd-implement`)
**"Something is broken NOW"** → `/fix-bug "description"`
**"Code is messy but works"** → `/refactor [operation] [target]`
**"Need to upgrade a package"** → `/upgrade-deps [package]`
**"Docs are outdated"** → `/update-docs [type]`
**"Want to add a tool/check"** → `/setup-tool [type] [name]`

### Non-PRD Workflows (Maintenance & Quality)

#### Fix Bugs & Hotfixes
```
/fix-bug "emoji crashes search LiveView"
```
**What happens**: Systematic bug fix - reproduce with test, analyze, fix, verify.
**Agents**: `test-builder` (Sonnet) → domain specialist → `code-reviewer` (Sonnet)
**Output**: Hotfix-ready commit with regression tests
**When to use**: Production issues, critical bugs that can't wait for sprint planning

#### Refactor Code
```
/refactor extract-ash-preparation apps/xtweak_core/lib/xtweak/core/user.ex
```
**What happens**: Improve code quality without changing behavior - extract, simplify, deduplicate.
**Agents**: `code-reviewer` (Sonnet) → domain specialist → `test-builder` (Sonnet)
**Output**: Quality-improved code, metrics showing improvement
**When to use**: Technical debt, code smells, preparing for future features

#### Upgrade Dependencies
```
/upgrade-deps ash --to=3.8.0
```
**What happens**: Safe dependency upgrade - audit changelog, adapt code, verify compatibility.
**Agents**: `dependency-auditor` (Sonnet) → domain specialists → `docs-maintainer` (Haiku)
**Output**: Upgraded package with documented breaking changes
**When to use**: Security patches, framework upgrades, staying current

#### Update Documentation
```
/update-docs framework-rules ash
```
**What happens**: Update non-PRD docs - README, migration guides, framework rules.
**Agent**: `docs-maintainer` (Haiku)
**Output**: Current, accurate documentation
**When to use**: After dependency upgrades, README updates, migration guides

#### Setup Tools
```
/setup-tool mcp-server playwright
```
**What happens**: Add and configure dev tools, CI checks, MCP servers.
**Agents**: `tools-config-guardian` (Haiku) → `ci-cd-optimizer` (Sonnet) → `docs-maintainer` (Haiku)
**Output**: Working tool integration
**When to use**: New MCP servers, CI checks, development tools

---

## 📚 Reading Order for New Sessions

### For You (Peter - Quick Start)
1. This file - [Human_docs/WORKFLOW_GUIDE.md](./WORKFLOW_GUIDE.md)
2. [AI_docs/prd/QUICK_START.md](../AI_docs/prd/QUICK_START.md) - Current PRD status
3. Use slash commands above

### For Claude Agents (Full Context - Automatic)
Agents automatically read in this order:
1. [CLAUDE.md](../CLAUDE.md) (entry point)
2. [MANDATORY_AI_RULES.md](../MANDATORY_AI_RULES.md) (mandatory rules)
4. [AI_docs/README.md](../AI_docs/README.md) (navigation map)
5. [AI_docs/prd/QUICK_START.md](../AI_docs/prd/QUICK_START.md) (current PRD status)
6. Current PRD sprint plan
7. [/usage-rules.md](../usage-rules.md) and [/usage-rules/](../usage-rules/) (all framework rules and xTweak patterns)
8. [.claude/patterns/](../.claude/patterns/) (execution patterns)

You don't need to tell agents what to read - slash commands handle this.

---

## 🎯 Agent Quick Reference (Who Does What)

### Planning & Documentation
- **docs-maintainer** (Haiku): PRD planning, updates, documentation
- **mcp-verify-first** (Haiku): Context gathering, verification, status reports

### Implementation
- **ash-resource-architect** (Sonnet): Design Ash resources, actions, policies
- **frontend-design-enforcer** (Sonnet): LiveView UI coordination
- **heex-template-expert** (Sonnet): HEEx template generation
- **test-builder** (Sonnet): ExUnit test authoring
- **database-migration-specialist** (Haiku): Migration planning

### Review & Quality
- **code-reviewer** (Sonnet): Code audit (read-only analysis)
- **code-review-implement** (Haiku): Apply review feedback
- **security-reviewer** (Sonnet): Security assessment

### Specialized
- **cytoscape-expert** (Sonnet): Graph visualization
- **nuxt-ui-expert** (Sonnet): Nuxt UI component research
- **tailwind-strategist** (Sonnet): Tailwind strategy


---

## 📋 PRD is Central (The Philosophy)

Everything flows from the PRD:

```
         PRD (WHAT to build)
              │
              ├─→ usage-rules (HOW - framework patterns)
              ├─→ patterns (HOW - execution workflows)
              └─→ agents (WHO - specialized builders)
```

Slash commands orchestrate this flow automatically:
1. You run a command
2. Command reads PRD to understand WHAT
3. Command selects agents (WHO) based on task
4. Agents use patterns (HOW - execution) and usage-rules (HOW - frameworks)
5. Results written back to PRD (REPORTS.md, QUICK_START.md, etc.)

You focus on the WHAT. Claude handles the HOW and WHO.

---

## 💡 Tips for Best Experience

### When to Use Each Command

**Use `/prd-continue`** when:
- Starting a new session
- Unsure what to do next
- Want to resume previous work

**Use `/prd-plan-sprint`** when:
- Ready to plan next sprint
- Completed previous sprint
- Starting a new phase

**Use `/prd-implement`** when:
- Sprint plan is ready
- Want to start building
- Resuming implementation work

**Use `/prd-status`** when:
- Want quick overview
- Check for blockers
- See what's completed

**Use `/prd-update`** when:
- Architecture changed
- Requirements evolved
- Decisions made that affect PRD

### Working with Todo Lists

All slash commands create todo lists for you. They show:
- ✅ What's completed
- 🚧 What's in progress
- ⏳ What's next
- 🚫 Any blockers

You can see todo progress in real-time as Claude works.

### Quality Gates

`/prd-implement` automatically runs quality checks after each task:
- `mix format` - Code formatting
- `mix credo --strict` - Code quality
- `mix compile --warnings-as-errors` - No warnings
- `mix test [path]` - Relevant tests

If any fail, Claude will fix and retry.

### Git Workflow

Claude **never commits without your permission** (per MANDATORY_AI_RULES.md).

When sprint complete:
1. Claude shows you changes
2. You review
3. You decide to commit or not

Use `/prd-status` to check git status anytime.

---

## 🔧 Troubleshooting

### "Claude doesn't know where to start"
→ Run `/prd-continue` - it will figure out context

### "Sprint plan is unclear"
→ Run `/prd-update [sprint-file]` to clarify, then `/prd-implement`

### "Agent picked seems wrong for task"
→ Check agent matrix if needed, manually specify agent

### "Todo list not showing"
→ Slash commands should always create todos - report if missing

### "Want to skip a task"
→ Manually update sprint [REPORTS.md](../AI_docs/prd/06-sprint-plans/) to mark skipped, then `/prd-continue`

---

## 📖 Related Documentation

**For Humans** (this folder):
- [DOCUMENTATION_FLOW.md](./DOCUMENTATION_FLOW.md) - Complete flow diagram (how everything connects)
- [claude_agent_workflow.md](./claude_agent_workflow.md) - Detailed agent mechanics
- [project-renaming.md](./project-renaming.md) - How to rename xTweak
- [template-initialization.md](./template-initialization.md) - Using xTweak as template

**For AI** (AI_docs folder):
- [AI_docs/README.md](../AI_docs/README.md) - AI documentation index
- [AI_docs/prd/](../AI_docs/prd/) - Complete PRD

**For Framework Rules**:
- [/usage-rules.md](../usage-rules.md) - Overview and index
- [/usage-rules/](../usage-rules/) - All framework rules and xTweak patterns
