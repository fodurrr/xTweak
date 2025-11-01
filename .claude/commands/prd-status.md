You are the status reporter using the `mcp-verify-first` agent.

## Your Task
Provide a concise dashboard of PRD progress showing what's done, in progress, next, and any blockers.

## Responsible Agent
- **Primary**: `mcp-verify-first` (Haiku - fast reporting)

## Steps

### 1. Gather Current Status
Read key files to understand project state:
- `prd/QUICK_START.md` - Current state and where we left off
- `prd/.prd-completion-status.md` - Completed phases/sprints
- Current sprint `REPORTS.md` (if exists) - Recent activity
- Git status: `git status` and `git log -1 --oneline`

### 2. Analyze & Categorize
Extract:
- **Completed**: Which sprints are done (from completion status)
- **In Progress**: Current sprint and task (from QUICK_START)
- **Blockers**: Any documented issues preventing progress
- **Next Milestone**: What's recommended next

### 3. Present Dashboard
Format as scannable dashboard:

```markdown
📊 xTweak Project Status
=======================

## ✅ Completed
- ✅ Sprint 1: [Name] (Completed [date])
[List completed sprints]

**Total Progress**: [X] of [Y] sprints ([Z]%)

## 🚧 In Progress
**Current Sprint**: Sprint [N]: [Name]
**Current Task**: Task [X] of [Y]: [Description]
**Started**: [date]
**Progress**: [X] of [Y] tasks complete ([Z]%)

## ⏳ Next Up
**Immediate Next**: [Next task or sprint]
**After That**: [Following milestone]

## 🚫 Blockers
[List blockers with severity, or "🎉 No blockers!"]

## 💾 Git Status
**Branch**: [name]
**Status**: [Clean / X files modified]
**Last Commit**: [message]

## 🎯 Recommended Action
**[Clear command to run next]**
```

### 4. Determine Recommendation
Based on analysis:
- Sprint in progress with no blockers → `/prd-implement`
- Sprint complete, git clean → `/prd-plan-sprint`
- Blocker exists → Resolve blocker first
- Uncommitted changes → Review and commit
- Unclear → `/prd-continue`

## Quality Checks
- [ ] All percentages calculated correctly
- [ ] Git status accurate
- [ ] Blocker severity matches impact
- [ ] Recommended action is specific
- [ ] Dashboard fits on one screen

## Notes
- Keep concise but informative
- Use emojis for visual scanning
- Always provide clear next command
- Mention uncommitted changes explicitly
- Progress percentages show momentum
