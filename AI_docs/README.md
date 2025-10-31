# AI Documentation Index

## 🎯 Start Here

**For Agents**:
- Read this index to understand documentation structure
- Then read your specific task files as directed by slash commands

**Where are we?** Check `prd/QUICK_START.md` for current status

---

## 📂 Directory Structure

### prd/ - Product Requirements Document (WHAT to build)
**Purpose**: Single source of truth for project objectives, requirements, and implementation plans.

**Contents**:
- `QUICK_START.md` - Current status and "where we left off"
- `README.md` - PRD table of contents
- `00-executive-summary.md` - Vision, mission, business case
- `01-technical-specification.md` - Research, framework analysis
- `02-requirements.md` - Functional and non-functional requirements
- `03-architecture.md` - System design, umbrella structure
- `04-component-inventory.md` - 105+ components to build
- `05-implementation-roadmap.md` - Timeline, phases, sprints
- `06-sprint-plans/` - Detailed sprint plans with REPORTS.md
- `.prd-completion-status.md` - Completion tracker

**When to read**: Every session - PRD is central to all work

---

### framework_rules/ - MOVED TO /usage-rules/

**⚠️ DEPRECATED**: This directory has been removed. All framework rules are now consolidated in `/usage-rules/` at the project root.

**New location**: All framework rules and xTweak-specific patterns are in `/usage-rules/`

**When to read**:
- When implementing Ash resources → read `/usage-rules/ash.md`
- When working with database → read `/usage-rules/ash_postgres.md`
- When building LiveView → read `/usage-rules/heex.md` + `/usage-rules/ash_phoenix.md`

---

### frontend_design_principles/ - UI Guidelines (HOW to build - Design)
**Purpose**: Tailwind CSS + Phoenix Component workflows for consistent UI.

**Contents**:
- `frontend-design-principles.md` - Tailwind strategy, component patterns

**When to read**: When implementing UI components or LiveView templates

---

## 🔗 Related Documentation (Outside AI_docs)

### Human Documentation (`/Human_docs/`)
**Not for agents** - Human-readable guides for developers:
- `WORKFLOW_GUIDE.md` - How Peter kicks off workflows (slash commands)
- `claude_agent_workflow.md` - Detailed agent mechanics
- `project-renaming.md` - How to rename xTweak
- `template-initialization.md` - Using xTweak as template
- `AI_WORKFLOW_REFACTOR_PLAN.md` - Complete refactor plan and philosophy

### Claude Configuration (`/.claude/`)
**Agent system files**:
- `README.md` - Agent matrix, workflows, model strategy
- `agents/` - 24 specialized agent definitions
- `patterns/` - 10 reusable execution patterns
- `commands/` - 5 PRD-centric slash commands

### Usage Rules (`/usage-rules.md` and `/usage-rules/`)
**All framework rules and xTweak-specific patterns**:
- Root `usage-rules.md` - Overview and index of all framework rules
- `usage-rules/` folder - All framework patterns (Ash, Phoenix, HEEx, etc.)
- Includes both framework basics AND xTweak-specific extensions
- See `/usage-rules/README.md` for complete guide

---

## 🧭 Navigation by Task Type

### Planning a Sprint
1. Read `prd/QUICK_START.md` (current status)
2. Read `prd/05-implementation-roadmap.md` (phase structure)
3. Read `.prd-completion-status.md` (what's done)
4. Create plan in `prd/06-sprint-plans/[phase]/[sprint].md`

### Implementing a Sprint
1. Read `prd/QUICK_START.md` (current status)
2. Read current sprint plan in `prd/06-sprint-plans/[phase]/[sprint].md`
3. For each task, read relevant files from `/usage-rules/`
4. Apply patterns from `/.claude/patterns/`
5. Log progress in sprint `REPORTS.md`

### Updating PRD
1. Read specified PRD section
2. Verify current state with MCP tools
3. Update section with new information
4. Update `QUICK_START.md` if status changed
5. Update `.prd-completion-status.md` if completion changed

### Checking Status
1. Read `prd/QUICK_START.md`
2. Read `.prd-completion-status.md`
3. Read current sprint `REPORTS.md` (if exists)
4. Check git status
5. Present dashboard to Peter

---

## 🎯 Key Principles for Agents

1. **PRD is central** - Always check QUICK_START.md first
2. **Usage rules have everything** - Read `/usage-rules/` for all framework guidance
3. **Patterns guide execution** - Consult `/.claude/patterns/` for workflows
4. **Reports live with sprints** - Log all decisions in sprint REPORTS.md
5. **Todo lists for Peter** - Always create todos showing progress

---

## 📝 Documentation Maintenance

**After dependency upgrades**:
```bash
bash scripts/setup_usage_rules.sh
```

**After sprint completion**:
1. Update `QUICK_START.md` with new status
2. Update `.prd-completion-status.md`
3. Finalize sprint REPORTS.md

**After architecture changes**:
1. Update relevant PRD section
2. Update `/usage-rules/` if xTweak patterns changed
3. Update QUICK_START.md if current work affected

---

## 🚀 Quick Command Reference

**For Peter** (see `Human_docs/WORKFLOW_GUIDE.md` for details):
- `/prd-plan-sprint` - Plan next sprint
- `/prd-implement` - Execute current sprint
- `/prd-status` - Check progress dashboard
- `/prd-update [section]` - Update PRD section
- `/prd-continue` - Resume where left off

**For Agents**: Slash commands automatically load correct files and launch appropriate agents.

---

*This index was created as part of the AI workflow refactor (2025-10-30) to provide clear navigation and PRD-centric workflows.*
