# xTweak Complete Workflow Guide

**For Human Developers Only - Last Updated: November 1, 2025**

This comprehensive guide explains how to work with Claude Code on the xTweak project. It combines workflow mechanics, command usage, and the human-AI collaboration model.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [The Clarification-First Approach](#the-clarification-first-approach)
3. [Understanding the Layered Architecture](#understanding-the-layered-architecture)
4. [Workflow Commands](#workflow-commands)
5. [How Claude Decides Which Agent](#how-claude-decides-which-agent)
6. [Complete Documentation Flow](#complete-documentation-flow)
7. [Agent Quick Reference](#agent-quick-reference)
8. [Understanding Agent Workflow](#understanding-agent-workflow)
9. [Typical End-to-End Scenarios](#typical-end-to-end-scenarios)
10. [Understanding Agent Outputs](#understanding-agent-outputs)
11. [Tips for Best Experience](#tips-for-best-experience)
12. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Starting Fresh

1. Read this guide (you are here)
2. Use slash commands OR give direct prompts
3. Let Claude handle the rest

### Two Ways to Work with Claude

**Option 1: Direct Prompts** (NEW - Recommended!)
- Just describe what you want
- Claude asks clarifying questions if needed
- Confirms understanding before proceeding
- Launches appropriate agents automatically

**Option 2: Slash Commands** (Structured Workflows)
- Use predefined commands for common tasks
- Best for PRD-based feature development
- Automated workflows with quality gates

---

## The Clarification-First Approach

**NEW (2025-11-01)**: Claude now intelligently analyzes every prompt before taking action.

### How It Works

1. **You give a prompt** (any request, even vague ones)
2. **Claude checks for clarity** using 5 questions:
   - Is the **scope** clear?
   - Is the **target** clear?
   - Are **success criteria** clear?
   - Are **constraints** clear?
   - Is the **approach** clear?
3. **If ambiguous**: Claude asks 2-4 structured questions with clear options
4. **After clarification**: Claude confirms understanding and waits for "yes"
5. **Then proceeds**: Loads architecture rules, detects context, launches appropriate agent

### Why This Matters

**Before**: Guessing led to implementing the wrong thing, wasting time on rework.

**Now**: 30-60 seconds of clarification upfront saves hours of implementation time.

### Examples

| Your Prompt | What Claude Does |
|-------------|------------------|
| "Add authentication" | Asks: Which method (email/password, OAuth)? What scope? Use Ash Authentication? |
| "Make it better" | Asks: What to improve? Code quality, tests, performance, UX? |
| "Fix the search" | Asks: Which search component? What's broken? Expected behavior? |
| "Add email field to User resource" | Clear! Proceeds directly (all 5 clarity checks pass) |

---

## Understanding the Layered Architecture

**NEW (2025-11-01)**: Claude Code uses a layered documentation architecture to minimize context consumption while maintaining quality.

### The Three Levels

**Level 0: Always Read**
- `MANDATORY_AI_RULES.md` - Your preferences, identity, permanent rules
- `CLAUDE.md` - High-level workflow routing logic

**Level 1: Coordinator (Routes Only)**
- Minimal Phase Zero detection (which apps/resources exist)
- Classification logic (which agent for this request)
- Clarification questions (if prompt is ambiguous)
- Agent launch (delegate to specialist)
- Result synthesis (present to you)

**Level 2: Subagents (Full Context)**
- Load patterns from their frontmatter (9-15 patterns each)
- Load usage rules from their frontmatter (framework-specific rules)
- Detailed Phase Zero (resource fields, actions, policies)
- Implementation work
- Quality gates and handoff

### Visual Flow (How It All Works Together)

```
Peter's Prompt
     ↓
📋 Read MANDATORY_AI_RULES.md ← COORDINATOR
📋 Read CLAUDE.md ← COORDINATOR
     ↓
❓ Step 0: Clarity Check ← COORDINATOR
     ├─ Ambiguous? → Ask Questions → Enhance & Confirm
     └─ Clear? → Proceed
     ↓
🔍 Step 1: Minimal Phase Zero ← COORDINATOR
     - ls apps/
     - list_ash_resources
     - Store session context
     [NO pattern/usage-rules reading here!]
     ↓
🎯 Step 2: Classify Request ← COORDINATOR
     - Use hardcoded table
     - "Add email field" → ash-resource-architect
     ↓
⚡ Step 3: Check Slash Commands ← COORDINATOR
     - Any shortcuts apply?
     ↓
🚀 Step 4: Launch Subagent ← COORDINATOR
     - Task tool: ash-resource-architect
     - Pass: {apps, domain, resources}
     - Instruction: "Read YOUR patterns/usage-rules"
     ↓

👷 SUBAGENT: ash-resource-architect
     📖 Pre-Flight Checklist:
        - Read 9 patterns from pattern-stack
        - Read 3 usage-rules from required-usage-rules
        - Run FULL Phase Zero (detailed)
     💻 Implementation work
     ✅ Quality gates
     📦 Collaboration handoff
     ↓

📊 Step 5: Synthesize Results ← COORDINATOR
     - Present to Peter
```

### Key Benefits

**64% Context Reduction**: Coordinator reads ~1,000 tokens (down from ~14,500)

**Faster Routing**: Coordinator makes decisions in ~2 seconds without reading implementation docs

**Specialized Context**: Each subagent reads exactly what IT needs for its specific task

**No Redundancy**: Files read once (by subagent) instead of twice (coordinator + subagent)

### What This Means for You

**You still get**:
- Clarification questions when prompts are ambiguous
- Smart agent selection based on your request
- Quality implementation following all framework rules
- Complete result synthesis

**You now benefit from**:
- Faster response times (less reading overhead)
- Lower token costs (coordinator reads less)
- Same quality output (subagents read everything they need)

---

## Workflow Commands

### PRD Workflows (Feature Development)

#### Plan Next Sprint
```bash
/prd-plan-sprint
```

**What happens**: Claude analyzes PRD, determines next sprint, creates detailed plan
**Agent**: `docs-maintainer` (Haiku - cost effective)
**Output**: Todo list with sprint objectives and next steps
**Next**: Run `/prd-implement` to start building

---

#### Start/Continue Implementation
```bash
/prd-implement
```

**What happens**: Executes current sprint plan with specialized agents
**Agents**: Varies by task (ash-resource-architect, frontend-design-enforcer, test-builder, etc.)
**Output**: Todo list tracking each task, quality gates, and completion status
**Next**: Run `/prd-status` to check progress or `/prd-continue` when done

---

#### Check Status
```bash
/prd-status
```

**What happens**: Dashboard of what's done, in progress, and next
**Agent**: `mcp-verify-first` (Haiku - fast reporting)
**Output**: Concise dashboard with recommended next action
**Next**: Follow recommendation from dashboard

---

#### Continue Where You Left Off
```bash
/prd-continue
```

**What happens**: Claude checks git status, reads QUICK_START.md and sprint reports, resumes appropriate workflow
**Agent**: `mcp-verify-first` (Haiku - routes to appropriate workflow)
**Output**: Todo list showing where we left off and what's resuming
**Next**: Automated - Claude continues the workflow

---

#### Update PRD Section
```bash
/prd-update 03-architecture
```

**What happens**: Update specific PRD chapter with new decisions/information
**Agent**: `docs-maintainer` (Haiku - documentation updates)
**Output**: Todo list showing changes made
**Next**: Continue with current sprint or run `/prd-status`

---

### Non-PRD Workflows (Maintenance & Quality)

#### Fix Bugs & Hotfixes
```bash
/fix-bug "emoji crashes search LiveView"
```

**What happens**: Systematic bug fix - reproduce with test, analyze, fix, verify
**Agents**: `test-builder` (Sonnet) → domain specialist → `code-reviewer` (Sonnet)
**Output**: Hotfix-ready commit with regression tests
**When to use**: Production issues, critical bugs that can't wait for sprint planning

---

#### Refactor Code
```bash
/refactor extract-ash-preparation apps/xtweak_core/lib/xtweak/core/user.ex
```

**What happens**: Improve code quality without changing behavior
**Agents**: `code-reviewer` (Sonnet) → domain specialist → `test-builder` (Sonnet)
**Output**: Quality-improved code with metrics
**When to use**: Technical debt, code smells, preparing for future features

---

#### Upgrade Dependencies
```bash
/upgrade-deps ash --to=3.8.0
```

**What happens**: Safe dependency upgrade - audit changelog, adapt code, verify compatibility
**Agents**: `dependency-auditor` (Sonnet) → domain specialists → `docs-maintainer` (Haiku)
**Output**: Upgraded package with documented breaking changes
**When to use**: Security patches, framework upgrades, staying current

---

#### Update Documentation
```bash
/update-docs framework-rules ash
```

**What happens**: Update non-PRD docs - README, migration guides, framework rules
**Agent**: `docs-maintainer` (Haiku)
**Output**: Current, accurate documentation
**When to use**: After dependency upgrades, README updates, migration guides

---

#### Setup Tools
```bash
/setup-tool mcp-server playwright
```

**What happens**: Add and configure dev tools, CI checks, MCP servers
**Agents**: `tools-config-guardian` (Haiku) → `ci-cd-optimizer` (Sonnet) → `docs-maintainer` (Haiku)
**Output**: Working tool integration
**When to use**: New MCP servers, CI checks, development tools

---

### Command Decision Guide

| Your Need | Recommended Approach |
|-----------|---------------------|
| Build a feature | PRD workflows (`/prd-plan-sprint`, `/prd-implement`) OR direct prompt |
| Something is broken NOW | `/fix-bug "description"` OR direct prompt "fix [bug]" |
| Code is messy but works | `/refactor [operation] [target]` OR direct prompt |
| Upgrade a package | `/upgrade-deps [package]` |
| Docs are outdated | `/update-docs [type]` |
| Add a tool/check | `/setup-tool [type] [name]` |

---

## How Claude Decides Which Agent

**2025-11-01 Update**: Claude follows an explicit decision tree for all prompts:

### The Decision Flow

```
Your Prompt
     ↓
Step 0: Check Clarity (5 questions)
     ↓
  Ambiguous? ──YES──> Ask Questions → Enhance & Confirm
     │                       ↓
     NO                     ↓
     └─────────────────────┘
     ↓
Step 1: Pre-Task Protocol
  - Detect project context (apps, domain, resources)
  - Load architecture rules (from /usage-rules/)
  - Load core patterns (5 execution patterns)
  - Output confirmation
     ↓
Step 2: Classify Request Type
     ↓
Step 3: Check for Slash Command
     │
     ├─> Slash Command Exists → Suggest → Wait for Decision
     │                                         ↓
     └─────────────────────────────────────────┘
     ↓
Step 4: Launch Agent with Full Context
     ↓
Step 5: Monitor & Synthesize Results
```

### Request Classification Table

| Request Type | Indicators | Lead Agent | Model |
|--------------|-----------|------------|-------|
| **New Ash Resource** | "create resource", "new model" | `ash-resource-architect` | Sonnet |
| **Modify Ash Resource** | "add action/policy/field" | `ash-resource-architect` | Sonnet |
| **LiveView Page/Component** | "create page", "build component" | `frontend-design-enforcer` | Sonnet |
| **HEEx Template Work** | "modernize template", "fix HEEx" | `heex-template-expert` | Sonnet |
| **Bug Fix** | "fix bug", "broken", "error" | Use `/fix-bug` workflow | - |
| **Code Review** | "review code", "check quality" | `code-reviewer` | Sonnet |
| **Refactoring** | "refactor", "clean up" | Use `/refactor` workflow | - |
| **Testing** | "write tests", "add coverage" | `test-builder` | Sonnet |
| **Database Migration** | "migration", "schema change" | `database-migration-specialist` | Haiku |
| **Documentation** | "update docs", "write README" | `docs-maintainer` | Haiku |
| **Performance** | "slow", "optimize" | `performance-profiler` | Sonnet |
| **Security** | "security", "vulnerability" | `security-reviewer` | Sonnet |
| **Question/Research** | "how does X work", "what is Y" | `mcp-verify-first` | Haiku |

### You're Always in Control

Claude tells you:
- Which agent it's launching
- Why it selected that agent
- What the agent will do
- Estimated time

You can override or adjust at any time.

---

## Complete Documentation Flow

### How Everything Connects

```
                    You start new session
                              │
                              ▼
                  ┌─────────────────────┐
                  │ Human_docs/         │
                  │ README.md           │◄─── "How do I start X?"
                  │ (This Guide)        │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │ You run slash       │
                  │ command OR give     │
                  │ direct prompt       │
                  └──────────┬──────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
    Direct Prompt      Slash Command      Research Question
         │                   │                   │
         └──────────────────┼───────────────────┘
                            │
                            ▼
         ┌──────────────────────────────────────┐
         │ Claude Code automatically reads:     │
         ├──────────────────────────────────────┤
         │ 1. CLAUDE.md (entry point)           │
         │ 2. MANDATORY_AI_RULES.md             │
         │ 3. .claude/README.md                 │
         │ 4. AI_docs/README.md                 │
         │ 5. AI_docs/prd/QUICK_START.md        │
         │ 6. [Current sprint plan]             │
         │ 7. /usage-rules/                     │
         │ 8. .claude/patterns/                 │
         └──────────────┬───────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ Claude determines:                   │
         │ - Current phase & sprint             │
         │ - Last action taken                  │
         │ - Which agent(s) to launch           │
         │ - What patterns to apply             │
         └──────────────┬───────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ Agent(s) execute tasks               │
         └──────────────┬───────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ Results written to:                  │
         │ ✅ Code changes                      │
         │ ✅ Sprint REPORTS.md                 │
         │ ✅ PRD updates                       │
         │ ✅ QUICK_START.md                    │
         │ ✅ Todo list for you                 │
         └──────────────┬───────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ You see:                             │
         │ 📋 Todo list showing progress        │
         │ ✅ What's completed                  │
         │ 🚧 What's in progress                │
         │ ⏳ What's next                       │
         │ 💡 Recommended next command          │
         └──────────────────────────────────────┘
```

### Simple Reading Paths

**For You (Quick Start)**:
1. This file - Human_docs/README.md or COMPLETE_WORKFLOW_GUIDE.md
2. AI_docs/prd/QUICK_START.md - Current PRD status
3. Use slash commands or direct prompts

**For Claude (Automatic - You Don't Need to Know This)**:
1. CLAUDE.md → MANDATORY_AI_RULES.md → .claude/README.md → AI_docs/README.md → etc.

**Key Principle**: You focus on WHAT you want. Claude handles HOW and WHO.

---

## Agent Quick Reference

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
- **dependency-auditor** (Sonnet): Dependency analysis
- **performance-profiler** (Sonnet): Performance investigation
- **tools-config-guardian** (Haiku): Tool setup and configuration

---

## Understanding Agent Workflow

### What You Do vs. What Claude Does

| Stage | Your Role | Claude's Role |
|-------|-----------|---------------|
| **Kickoff** | Describe the task | Auto-detect project context |
| **Planning** | Optional: ask for Todo list | Load patterns and architecture rules |
| **Execution** | Review proposals, approve/tweak | Domain agents do the work, log evidence |
| **Validation** | Ask for tests/screenshots if needed | Run quality gates, verify completion |
| **Wrap-up** | Decide next action: merge, run locally, or follow-up | Output structured hand-off with summary |

**You never run MCP commands manually** - Claude does it. Your job is to give clear intent and react to outputs.

---

## Typical End-to-End Scenarios

### A. New Feature Slice (Backend + Frontend)

**Request**: "Implement a reputation leaderboard page with Ash resource changes and LiveView UI."

**Flow**:
1. Claude runs context detection, proposes plan
2. You approve
3. `ash-resource-architect` → backend changes
4. `frontend-design-enforcer` → UI implementation
5. `test-builder` → tests
6. `code-reviewer` → quality check
7. Each stage: hand-off summary (you can stop/adjust/continue)

---

### B. Pure Frontend Tweak

**Request**: "Tighten spacing on dashboard card and make it responsive."

**Flow**:
1. Claude runs context detection
2. `frontend-design-enforcer` → handles change
3. Playwright screenshots for verification
4. You review and accept (or ask for iterations)

---

### C. Debug/Test Fix

**Request**: "Tests failing in `user_live_test.exs`, please diagnose and fix."

**Flow**:
1. `mcp-verify-first` → gather context
2. `test-builder` → reproduce failure, create Todos
3. Relevant agent → fix code
4. Final summary: which failures fixed, remaining issues, commands run

---

### D. Preparing a Release

**Request**: "Cut a release candidate for the latest sprint."

**Flow**:
1. `dependency-auditor` → check deps (if needed)
2. `test-builder` → focused checks
3. `release-coordinator` → readiness notes, changelog
4. `docs-maintainer` → finalize documentation

---

### E. Documentation Overhaul

**Request**: "Update the placeholder pattern and ensure all agents reference it."

**Flow**:
1. `pattern-librarian` → audit patterns, bump versions
2. `docs-maintainer` → update developer guides

---

## Understanding Agent Outputs

### What to Expect

**Evidence Blocks**:
- Commands run, logs, doc excerpts
- Proof that Claude didn't guess
- Required by MCP tool discipline

**Dual Examples**:
- Generic + xTweak versions shown
- Copy the xTweak example for your code

**Self-Check Confirmation**:
- "Self-check complete" at end of run
- Agent verified: placeholders, context, evidence, outstanding actions

**Hand-off Summary**:
- Summary of work
- Artifact list (files changed)
- Outstanding tasks
- Validation status
- Suggested next steps

**Use this to decide**: More work from Claude? Ready to run locally? Done?

---

## Tips for Best Experience

### When to Use Each Command

| Use This | When |
|----------|------|
| `/prd-continue` | Starting new session, unsure what's next, resume previous work |
| `/prd-plan-sprint` | Ready to plan next sprint, completed previous sprint, new phase |
| `/prd-implement` | Sprint plan ready, want to build, resuming implementation |
| `/prd-status` | Quick overview, check blockers, see what's completed |
| `/prd-update` | Architecture changed, requirements evolved, PRD needs updates |

### Working with Todo Lists

All commands create todo lists showing:
- ✅ Completed
- 🚧 In progress
- ⏳ Next
- 🚫 Blockers

You see real-time progress as Claude works.

### Quality Gates

`/prd-implement` automatically runs after each task:
- `mix format` - Code formatting
- `mix credo --strict` - Code quality
- `mix compile --warnings-as-errors` - No warnings
- `mix test [path]` - Relevant tests

If any fail, Claude fixes and retries.

### Git Workflow

**Claude never commits without your permission** (per MANDATORY_AI_RULES.md).

When sprint complete:
1. Claude shows you changes
2. You review
3. You decide to commit or not

Use `/prd-status` to check git status anytime.

### Prompting Tips

1. **Be explicit about work type**: "implement Ash resource", "build LiveView page", "write tests"
2. **Mention constraints**: "Use Tailwind utilities", "focus on authorization", "keep API backward compatible"
3. **Ask for artifacts**: code diffs, UI screenshots, test plan
4. **Indicate next step**: "okay, run the UI pass" or "wrap up"

---

## Troubleshooting

### Claude doesn't know where to start
→ Run `/prd-continue` - it will figure out context

### Sprint plan is unclear
→ Run `/prd-update [sprint-file]` to clarify, then `/prd-implement`

### Agent picked seems wrong for task
→ Ask Claude to use a different agent, or check agent matrix

### Todo list not showing
→ Slash commands should always create todos - report if missing

### Want to skip a task
→ Manually update sprint REPORTS.md to mark skipped, then `/prd-continue`

### Claude says it's missing context
→ Provide additional clues (file paths, business rules) and rerun

### Agent chain stops early
→ Ask Claude to continue: "Please proceed with the UI implementation"

### Need a new agent
→ Prompt: "Create new agent for [requirements]" (uses `agent-architect`)

---

## PRD is Central (The Philosophy)

Everything flows from the PRD:

```
         PRD (WHAT to build)
              │
              ├─→ usage-rules (HOW - framework patterns)
              ├─→ patterns (HOW - execution workflows)
              └─→ agents (WHO - specialized builders)
```

Slash commands orchestrate this flow:
1. You run a command
2. Command reads PRD (WHAT)
3. Selects agents (WHO) based on task
4. Agents use patterns (HOW - execution) and usage-rules (HOW - frameworks)
5. Results written back to PRD (REPORTS.md, QUICK_START.md)

**You focus on WHAT. Claude handles HOW and WHO.**

---

## Related Documentation

### For Humans (This Folder)
- **README.md** - Complete documentation index
- **COMPLETE_WORKFLOW_GUIDE.md** - This guide (workflow + agent mechanics)
- **SHOWCASE_GUIDE.md** - Interactive component showcase
- **claude_cli_setup.md** - Claude Code CLI setup

### For AI (AI_docs Folder)
- **AI_docs/README.md** - AI documentation index
- **AI_docs/prd/** - Complete PRD

### For Framework Rules
- **/usage-rules.md** - Overview and index
- **/usage-rules/** - All framework rules and xTweak patterns

---

## Summary

### The Modern Claude Workflow

1. **You give a prompt** (direct or slash command)
2. **Claude clarifies** if needed (NEW!)
3. **Claude loads context** (automatic)
4. **Claude selects agent** (transparent)
5. **Agent executes** (with evidence)
6. **Claude synthesizes** results for you
7. **You decide** next action

### Key Benefits

- **No more guessing**: Clarification-first approach
- **Always verified**: MCP tools provide evidence
- **Transparent**: You see which agent and why
- **Quality built-in**: Automatic quality gates
- **Flexible**: Direct prompts OR slash commands

### Start Here

**New to the project?**
1. Read Human_docs/README.md (documentation index)
2. Use `/prd-continue` to see current status
3. Give direct prompts or use slash commands
4. Let Claude handle the rest

**Ready to build?**
- Direct prompt: "Add [feature]" (Claude will clarify and proceed)
- OR structured: `/prd-plan-sprint` → `/prd-implement`

**Questions?**
- Direct prompt: "How does [X] work?"
- Claude will research using MCP tools and explain

---

**Welcome to xTweak!** 🚀

You're now equipped to work efficiently with Claude Code. Focus on your intent, and let Claude handle the execution details.

Happy coding! 🎉
