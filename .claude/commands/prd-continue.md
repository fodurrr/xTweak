You are the continuation coordinator using the `mcp-verify-first` agent.

## Your Task
Determine where we left off and automatically resume the appropriate workflow.

## Responsible Agent
- **Primary**: `mcp-verify-first` (Haiku - determines context and routes appropriately)

## Steps

### 1. Check Git Status
Understand current state:
```bash
git status
git branch --show-current
git log -1 --oneline
```

Analyze:
- Uncommitted changes → Work in progress
- Merge conflicts → Blocker
- Clean directory → Last task completed
- Last commit → Clue about what finished

### 2. Read QUICK_START.md
Primary source of truth: `AI_docs/prd/QUICK_START.md`

Extract:
- **Current Phase/Sprint**: Where are we?
- **Last Action**: What was last done?
- **Next Action**: What's recommended?
- **Status**: Planning, implementing, blocked, complete?

### 3. Read Sprint REPORTS.md (if exists)
If sprint active, read current REPORTS.md for:
- Last completed task
- Current task in progress
- Incomplete tasks
- Blockers
- Last agent used

### 4. Identify Scenario
Combine all sources to determine one of:

1. **In Planning Phase** - No sprint active → Run `/prd-plan-sprint`
2. **Sprint Ready** - Plan created, not started → Run `/prd-implement`
3. **Sprint In Progress** - Task incomplete → Continue `/prd-implement`
4. **Task Complete, Uncommitted** - Show changes, suggest commit, then `/prd-implement`
5. **Sprint Complete** - All done, git clean → Run `/prd-plan-sprint`
6. **Blocked** - Show blocker, suggest resolution
7. **Unclear** - Show `/prd-status` dashboard

### 5. Create Context Summary
Always show where we left off:

```markdown
📍 Resuming from Where We Left Off

## Context Analysis
✅ **Git**: [branch] - [status] - [last commit]
✅ **QUICK_START**: Phase [X], Sprint [Y] - [last action]
✅ **REPORTS** (if exists): [progress summary]

## Determined State
🎯 **Status**: [scenario identified]

## Where We Left Off
[Clear narrative combining all sources]

## What Will Resume
- **Command**: [/prd-implement or /prd-plan-sprint or /prd-status]
- **Expected**: [What happens next]

## Next Steps
[Automatic action or what Peter needs to do]
```

### 6. Resume Workflow
Based on scenario, automatically launch:
- `/prd-plan-sprint` - For planning next sprint
- `/prd-implement` - For continuing sprint work
- `/prd-status` - If unclear state
- Or show blocker details and wait

## Scenario Quick Reference

| Indicators | Action |
|------------|--------|
| QUICK_START says "Planning" + no sprint | → `/prd-plan-sprint` |
| Sprint plan exists, not started | → `/prd-implement` |
| Sprint active, task in progress | → `/prd-implement` |
| Task done, uncommitted changes | → Suggest commit, then `/prd-implement` |
| Sprint complete, git clean | → `/prd-plan-sprint` |
| Blocker documented | → Show details, wait for resolution |
| Conflicting information | → `/prd-status` |

## Quality Checks
- [ ] Git status checked
- [ ] QUICK_START.md read
- [ ] Sprint REPORTS.md read (if exists)
- [ ] Scenario identified
- [ ] Context summary shows all sources
- [ ] Clear next action

## Notes
- Always create context summary first
- Show uncommitted changes if present
- Be specific about what will resume
- Auto-launch unless blocker present
