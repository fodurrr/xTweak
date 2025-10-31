# xTweak Documentation Flow

## 📐 Complete Documentation Flow Diagram

This diagram shows how Peter (human) and Claude (AI) navigate the xTweak documentation.

```
                    Peter starts new session
                              │
                              ▼
                  ┌─────────────────────┐
                  │ Human_docs/         │
                  │ WORKFLOW_GUIDE.md   │◄─── "How do I start X?"
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │ Peter runs slash    │
                  │ command:            │
                  │ /prd-plan-sprint    │◄─── Kicks off workflow
                  │ /prd-implement      │
                  │ /prd-status         │
                  │ /prd-continue       │
                  └──────────┬──────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
    ┌────────┐         ┌────────┐         ┌────────┐
    │Command │         │Command │         │Command │
    │reads:  │         │reads:  │         │reads:  │
    └────┬───┘         └────┬───┘         └────┬───┘
         │                  │                   │
         └──────────────────┼───────────────────┘
                            │
                            ▼
         ┌──────────────────────────────────────┐
         │ Claude Code automatically reads:     │
         ├──────────────────────────────────────┤
         │ 1. CLAUDE.md (entry point)           │
         │ 2. MANDATORY_AI_RULES.md             │◄─ Override everything
         │ 3. .claude/README.md                 │◄─ Agent matrix, workflows
         │ 4. AI_docs/README.md                 │◄─ Navigation map
         │ 5. AI_docs/prd/QUICK_START.md        │◄─ WHERE WE LEFT OFF
         │ 6. [Current sprint plan]             │◄─ WHAT to build
         │ 7. /usage-rules/                     │◄─ Framework rules & patterns
         │ 8. .claude/patterns/                 │◄─ Execution workflows
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
         │ Agent(s) execute tasks:              │
         │ - docs-maintainer (Haiku)            │
         │ - mcp-verify-first (Haiku)           │
         │ - ash-resource-architect (Sonnet)    │
         │ - frontend-design-enforcer (Sonnet)  │
         │ - test-builder (Sonnet)              │
         │ - etc.                               │
         └──────────────┬───────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ Results written to:                  │
         │ ✅ Code changes (implementation)     │
         │ ✅ Sprint REPORTS.md (decisions)     │
         │ ✅ PRD updates (if needed)           │
         │ ✅ QUICK_START.md (where we are)     │
         │ ✅ Todo list for Peter               │
         └──────────────────────────────────────┘
                        │
                        ▼
         ┌──────────────────────────────────────┐
         │ Peter sees:                          │
         │ 📋 Todo list showing progress        │
         │ ✅ What's completed                  │
         │ 🚧 What's in progress                │
         │ ⏳ What's next                       │
         │ 💡 Recommended next command          │
         └──────────────────────────────────────┘
```

## 🎯 Simple Reading Paths

### For Peter (Human)

```
1. Human_docs/WORKFLOW_GUIDE.md
2. Use slash commands
```

That's it! Everything else happens automatically.

### For Claude Code (AI)

```
1. CLAUDE.md (entry point)
   ↓
2. MANDATORY_AI_RULES.md (mandatory overrides)
   ↓
3. .claude/README.md (agent matrix, workflows, model strategy)
   ↓
4. AI_docs/README.md (navigation map)
   ↓
5. AI_docs/prd/QUICK_START.md (current PRD status)
   ↓
6. [Current sprint plan] (what to build)
   ↓
7. /usage-rules/ (framework rules and xTweak patterns)
   ↓
8. .claude/patterns/ (execution workflows)
```

## 📚 Documentation Separation

| Audience | Entry Point | Purpose |
|----------|-------------|---------|
| **Peter** | WORKFLOW_GUIDE.md | How to use slash commands and kick off workflows |
| **Claude** | CLAUDE.md | Technical reference for AI execution |

**Key Principle**: No mixing. Peter doesn't need to know about AI internals. Claude doesn't need human workflow guides.

## 🔄 Workflow Commands

Peter uses these commands from WORKFLOW_GUIDE.md:

- `/prd-plan-sprint` - Plan next sprint based on PRD roadmap
- `/prd-implement` - Execute current sprint with appropriate agents
- `/prd-status` - Check progress dashboard
- `/prd-update [section]` - Update PRD section
- `/prd-continue` - Resume where you left off (checks git + PRD)

Each command automatically loads the correct documentation for Claude to execute the task.

## ✅ Quality Gates

After each task, agents automatically run:

```bash
mix format                           # Code formatting
mix credo --strict                   # Code quality
mix compile --warnings-as-errors     # No warnings
mix test [path]                      # Relevant tests
```

If any fail, Claude fixes and retries before marking task complete.

## 🤝 Human-AI Handoff

```
Peter → Slash command → Claude reads docs → Agents execute → Results → Peter reviews
```

Clear handoff points:
1. **Peter to Claude**: Slash command with intent
2. **Claude to Agents**: Task breakdown with patterns
3. **Agents to Claude**: Completion with validation
4. **Claude to Peter**: Todo list + recommendations
