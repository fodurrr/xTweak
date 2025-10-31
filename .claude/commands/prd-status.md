You are the status reporter using the `mcp-verify-first` agent.

## Your Task
Provide a concise dashboard of PRD progress for Peter, showing what's done, what's in progress, what's next, and any blockers.

## Responsible Agents
- **Primary**: `mcp-verify-first` (Haiku - fast reporting)

## Steps

### 1. Read Key Status Files
Use `mcp-verify-first` to gather current status from multiple sources:

**PRD Status Files**:
- `AI_docs/prd/QUICK_START.md` - Current state and "where we left off"
- `AI_docs/prd/.prd-completion-status.md` - What's completed across all phases
- Current sprint `REPORTS.md` (if exists) - Recent activity and blockers

**Git Status**:
```bash
git status
```
Check for:
- Uncommitted changes (files modified, staged, untracked)
- Current branch
- Ahead/behind origin

**Recent Activity**:
```bash
git log -1 --oneline
```
Get last commit message as a clue about recent work.

### 2. Analyze and Categorize

**Completed Work**:
- From `.prd-completion-status.md`: Which phases/sprints are complete
- From `QUICK_START.md`: Last completed action
- Count: Total sprints planned vs completed

**In Progress**:
- From `QUICK_START.md`: Current sprint and task
- From sprint `REPORTS.md`: Which specific task is active
- From git status: Any uncommitted work related to current task

**Blockers**:
- From sprint `REPORTS.md`: Any documented blockers
- From git status: Merge conflicts, uncommitted changes blocking progress
- Identify severity: Critical (blocking all work) vs Minor (one task blocked)

**Next Milestone**:
- From `QUICK_START.md`: Next recommended action
- From sprint `REPORTS.md`: Next pending task in current sprint
- From `.prd-completion-status.md`: Next sprint to plan

### 3. Present as Dashboard
Format the status as a clear, scannable dashboard:

```markdown
📊 xTweak Project Status
=======================

## ✅ Completed
[List completed sprints with checkmarks]
- ✅ Phase 1, Sprint 1: Infrastructure (Completed [date])
- [etc.]

**Total Progress**: [X] of [Y] sprints complete ([Z]%)

## 🚧 In Progress
**Current Sprint**: Sprint [number]: [Name]
**Current Task**: Task [X] of [Y]: [Task name]
**Agent Working**: [agent-name] (Haiku/Sonnet)
**Started**: [date or "just started"]

**Progress**: [X] of [Y] tasks in current sprint complete ([Z]%)

## ⏳ Next Up
**Immediate Next**: [Next task in current sprint OR next sprint to plan]
**After That**: [Following milestone]
**Phase Target**: [Current phase goal]

## 🚫 Blockers
[If any blockers exist, list them. Otherwise: "None"]
- [Blocker description]
  - **Severity**: Critical / High / Medium / Low
  - **Resolution**: [What needs to happen]

[If no blockers: "🎉 No blockers! Clear path forward."]

## 💾 Git Status
**Branch**: [current-branch]
**Status**: [Clean / X files modified / Y files staged / Z merge conflicts]
**Last Commit**: [commit message]
[If uncommitted changes: "⚠️ [X] uncommitted files"]
[If clean: "✅ Clean working directory"]

## 🎯 Recommended Action
[Clear next command Peter should run]
- Run `/prd-continue` to resume where you left off
OR
- Run `/prd-implement` to continue current sprint
OR
- Run `/prd-plan-sprint` to plan next sprint
OR
- Resolve blocker, then run `/prd-continue`
OR
- Review and commit changes, then run `/prd-status` again
```

### 4. Determine Recommended Action
Based on the analysis, provide a clear recommendation:

**If sprint in progress with no blockers**:
→ "Run `/prd-implement` to continue current sprint"

**If sprint complete and git clean**:
→ "Run `/prd-plan-sprint` to plan next sprint"

**If blocker exists**:
→ "Resolve blocker: [description], then run `/prd-continue`"

**If uncommitted changes**:
→ "Review and commit changes, then run `/prd-status` again"

**If unclear state**:
→ "Run `/prd-continue` to determine context and resume"

## Output Format
Present the dashboard exactly as shown in Step 3, with:
- Clear sections with emoji headers
- Concise bullet points
- Completion percentages
- Severity indicators for blockers
- **Bold** recommended action at the end

## Quality Checks
Before presenting dashboard:
- [ ] All completion percentages calculated correctly
- [ ] Git status reflects reality (run `git status` to verify)
- [ ] Blocker severity matches impact (blocking all work = Critical)
- [ ] Recommended action is clear and specific
- [ ] Dashboard is concise (fits on one screen if possible)

## Example Output

```markdown
📊 xTweak Project Status
=======================

## ✅ Completed
- ✅ Phase 1, Sprint 1: Infrastructure Setup (Completed 2025-10-28)
- ✅ Phase 1, Sprint 2: Core Components (Completed 2025-10-30)

**Total Progress**: 2 of 12 sprints complete (17%)

## 🚧 In Progress
**Current Sprint**: Sprint 3: Authentication & Authorization
**Current Task**: Task 2 of 5: Build login UI
**Agent Working**: frontend-design-enforcer (Sonnet)
**Started**: 2025-10-30 (2 hours ago)

**Progress**: 1 of 5 tasks in current sprint complete (20%)

## ⏳ Next Up
**Immediate Next**: Task 3: Implement password reset flow
**After That**: Task 4: Add email verification
**Phase Target**: Complete Phase 1 Foundation (5 sprints total)

## 🚫 Blockers
🎉 No blockers! Clear path forward.

## 💾 Git Status
**Branch**: feature/auth-system
**Status**: 3 files modified (LiveView templates)
**Last Commit**: "Add User resource with authentication policies"
⚠️ 3 uncommitted files (work in progress on current task)

## 🎯 Recommended Action
**Run `/prd-implement` to continue Sprint 3**

The frontend-design-enforcer agent is working on the login UI (Task 2). Once complete, uncommitted changes should be reviewed and committed before moving to Task 3.
```

## Special Cases

### Case: Planning Phase (No Sprints Started)
```markdown
📊 xTweak Project Status
=======================

## ✅ Completed
- ✅ PRD Structure Complete (All chapters written)

**Total Progress**: PRD complete, ready for implementation (0%)

## 🚧 In Progress
**Current Phase**: Planning
**Status**: Ready to start Sprint 1

## ⏳ Next Up
**Immediate Next**: Plan Sprint 1: Infrastructure Setup
**After That**: Implement Sprint 1
**Phase Target**: Complete Phase 1 Foundation (5 sprints planned)

## 🚫 Blockers
🎉 No blockers! Ready to start.

## 💾 Git Status
**Branch**: main
**Status**: Clean
**Last Commit**: "docs: Complete PRD structure and roadmap"

## 🎯 Recommended Action
**Run `/prd-plan-sprint` to create Sprint 1 plan**

All PRD documentation is complete. Next step is to plan the first sprint and begin implementation.
```

### Case: Critical Blocker
```markdown
📊 xTweak Project Status
=======================

## ✅ Completed
[... completed work ...]

## 🚧 In Progress
**Current Sprint**: Sprint 2: Core Components
**Current Task**: Task 3 of 6: Database migration
**Status**: 🚫 BLOCKED

**Progress**: 2 of 6 tasks in current sprint complete (33%)

## ⏳ Next Up
**Blocked**: Cannot proceed until blocker resolved
**After Resolution**: Continue with Task 3

## 🚫 Blockers
❌ **Critical Blocker**: Database migration failing
- **Severity**: Critical (blocks all remaining tasks)
- **Description**: ash_postgres.generate_migrations produces invalid SQL for UUID field
- **Resolution**: Need to update Ash/AshPostgres versions or modify resource definition
- **Owner**: Peter (decision needed on approach)

## 💾 Git Status
**Branch**: feature/core-components
**Status**: 5 files modified (migration attempts)
**Last Commit**: "Add Newsletter resource (partial)"

## 🎯 Recommended Action
**Resolve migration blocker first**

Options:
1. Update dependencies: `mix deps.update ash ash_postgres`
2. Modify Newsletter resource UUID field definition
3. Manually edit generated migration

After resolving, run `/prd-continue` to resume Sprint 2.
```

## Notes
- Keep dashboard concise but informative
- Use emojis for quick visual scanning
- Always provide a clear recommended next command
- If git status shows uncommitted changes, mention them explicitly
- Progress percentages help Peter see momentum
- Severity levels for blockers help prioritize
