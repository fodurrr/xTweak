You are the continuation coordinator using the `mcp-verify-first` agent.

## Your Task
Determine where we left off (from git status, QUICK_START.md, and sprint reports) and automatically resume the appropriate workflow.

## Responsible Agents
- **Primary**: `mcp-verify-first` (Haiku - determines context and routes to appropriate agent/workflow)
- **Delegates to**: Appropriate agent or command based on last activity

## Steps

### 1. Check Git Status
Start by understanding the current git state:

```bash
# Check working directory status
git status

# Check current branch
git branch --show-current

# Get last commit
git log -1 --oneline

# Check if ahead/behind origin
git status -sb
```

**Analyze git status**:
- **Uncommitted changes?** → Files modified, staged, or untracked
- **Merge conflicts?** → Blockers that need resolution
- **Clean working directory?** → Ready for next activity
- **Last commit message** → Clue about what was last completed

### 2. Read QUICK_START.md
This is the primary source of truth for "where we left off":

**Read**: `AI_docs/prd/QUICK_START.md`

**Extract**:
- **Current Phase**: Which phase are we in?
- **Current Sprint**: Which sprint (planned, in-progress, complete)?
- **Last Action**: What was the last thing done?
- **Next Action**: What does QUICK_START recommend?
- **Status**: Planning, implementing, blocked, or complete?

**Interpretation**:
```markdown
"Last Action: Sprint plan created for Sprint 2"
→ Status: Planning complete, ready to implement

"Last Action: Sprint 2 completed successfully"
→ Status: Sprint complete, ready to plan next sprint

"Last Action: Implementing Sprint 2, Task 3 of 5"
→ Status: Implementation in progress, resume Sprint 2

"Last Action: Sprint 2 paused due to blocker"
→ Status: Blocked, need to check blocker details
```

### 3. Read Current Sprint REPORTS.md (if exists)
If QUICK_START indicates a sprint is in progress or recently completed:

**Find sprint REPORTS.md**: Path is in QUICK_START.md

**Read and extract**:
- Last completed task
- Current task (if any in progress)
- Incomplete tasks
- Any blockers noted
- Quality gate results
- Agent execution log (last agent used)

### 4. Analyze Overall Context
Combine all information sources:

**From Git**:
- Uncommitted changes → Work in progress on current task
- Clean directory → Last task was completed and committed
- Merge conflicts → Blocker
- Last commit message → What was finished

**From QUICK_START.md**:
- Current phase and sprint
- Last recorded action
- Recommended next step

**From REPORTS.md** (if exists):
- Actual task progress vs QUICK_START
- Active blockers
- Last agent execution

**Synthesize into one of these scenarios**:

1. **In planning phase** (no sprint active)
2. **Sprint plan created, not yet started implementation**
3. **Sprint implementation in progress, task incomplete**
4. **Sprint implementation in progress, task complete but not committed**
5. **Sprint complete, git clean, ready for next sprint**
6. **Blocked** (blocker documented in REPORTS.md)
7. **Unclear state** (conflicting information)

### 5. Determine Resume Strategy

Based on scenario, choose appropriate action:

#### Scenario 1: In Planning Phase
**Indicators**:
- QUICK_START.md shows "Planning phase" or "Ready to start Sprint 1"
- No active sprint REPORTS.md
- Git clean

**Action**: Run `/prd-plan-sprint` to create first sprint plan

#### Scenario 2: Sprint Plan Created, Not Started
**Indicators**:
- QUICK_START.md shows "Sprint plan created for Sprint X"
- Next action says "Run `/prd-implement`"
- Sprint REPORTS.md exists but no tasks started
- Git clean or only sprint plan files committed

**Action**: Run `/prd-implement` to start sprint execution

#### Scenario 3: Sprint In Progress, Task Incomplete
**Indicators**:
- QUICK_START.md shows "Implementing Sprint X, Task Y of Z"
- Sprint REPORTS.md shows task in progress
- Git may have uncommitted changes (work in progress)

**Action**: Continue with `/prd-implement` (it will resume from current task)

#### Scenario 4: Sprint In Progress, Task Complete But Uncommitted
**Indicators**:
- Sprint REPORTS.md shows task marked complete
- Git status shows uncommitted changes
- Quality gates passed (per REPORTS.md)

**Action**:
1. Show Peter the uncommitted changes
2. Suggest review and commit
3. Then continue with `/prd-implement`

#### Scenario 5: Sprint Complete, Ready for Next Sprint
**Indicators**:
- QUICK_START.md shows "Sprint X completed successfully"
- All tasks in sprint REPORTS.md marked complete
- Git clean
- Next action says "Plan next sprint"

**Action**: Run `/prd-plan-sprint` to plan next sprint

#### Scenario 6: Blocked
**Indicators**:
- QUICK_START.md mentions blocker
- Sprint REPORTS.md has unresolved blockers
- OR git status shows merge conflicts

**Action**:
1. Show Peter the blocker details
2. Suggest resolution steps
3. Ask Peter to resolve, then run `/prd-continue` again

#### Scenario 7: Unclear State
**Indicators**:
- Conflicting information between sources
- Missing expected files
- Can't determine clear next step

**Action**: Show `/prd-status` dashboard and ask Peter for direction

### 6. Resume Workflow
Once strategy is determined:

**Create todo list showing**:
- ✅ Where we left off (summary from all sources)
- 📊 Current state (phase, sprint, task if applicable)
- 💾 Git status (clean/uncommitted/conflicts)
- 🚫 Blockers (if any)
- 🎯 What will resume
- ⚙️ Which agent/command launching

**Then automatically launch the appropriate workflow**:
- Delegate to `/prd-plan-sprint` command
- Delegate to `/prd-implement` command
- Delegate to `/prd-status` command (if unclear)
- Or show blocker and wait for Peter's action

## Output Format
Always create a todo list showing the context analysis and what's resuming:

```markdown
📍 Resuming from Where We Left Off

## Context Analysis
✅ Git Status Checked
- **Branch**: [branch name]
- **Status**: [clean / X files modified / merge conflicts]
- **Last Commit**: [commit message]

✅ QUICK_START.md Read
- **Current Phase**: [phase]
- **Current Sprint**: [sprint or "Not started"]
- **Last Action**: [what was done]
- **Recommended Next**: [next action from QUICK_START]

✅ Sprint REPORTS.md Analyzed
[If exists:]
- **Progress**: [X] of [Y] tasks complete
- **Last Task**: [task name and status]
- **Blockers**: [None / blocker description]
[If doesn't exist:]
- No active sprint reports

## Determined State
🎯 **Status**: [Planning / Sprint Ready / In Progress / Task Complete / Sprint Complete / Blocked / Unclear]

## Where We Left Off
[Clear narrative summary combining all sources]
[Example: "Sprint 2 is in progress. Task 2 of 5 (Build login UI) was completed and quality gates passed. Changes are uncommitted. Once committed, ready to proceed to Task 3."]

## What Will Resume
[What action will be taken]
- **Command**: `/prd-implement` (continue Sprint 2)
- **Agent**: [agent name if known, or "determined by implement command"]
- **Expected**: [What will happen next]

## Next Steps
[Automatic unless blocker]
[If automatic: "Launching [command/agent] now..."]
[If needs Peter: "Please [action], then I'll continue automatically."]
```

## Quality Checks
Before resuming workflow:
- [ ] Git status checked and understood
- [ ] QUICK_START.md read and interpreted
- [ ] Sprint REPORTS.md read (if exists)
- [ ] Scenario identified correctly
- [ ] Appropriate workflow selected
- [ ] Todo list clearly shows context and next action

## Special Cases

### Case: Uncommitted Changes
```markdown
📍 Resuming from Where We Left Off

## Context Analysis
✅ Git Status Checked
- **Branch**: feature/auth-system
- **Status**: 3 files modified (uncommitted)
- **Last Commit**: "Add User resource"

✅ QUICK_START.md Read
- **Current Phase**: Phase 1 - Foundation
- **Current Sprint**: Sprint 2 - Core Components
- **Last Action**: Implementing Sprint 2, Task 2 of 5
- **Recommended Next**: Continue with /prd-implement

✅ Sprint REPORTS.md Analyzed
- **Progress**: 1 of 5 tasks complete
- **Last Task**: Task 2 (Build login UI) - Complete ✅
- **Quality Gates**: All passed
- **Blockers**: None

## Determined State
🎯 **Status**: Task Complete - Uncommitted Changes

## Where We Left Off
Task 2 (Build login UI) was successfully completed. Quality gates all passed (format, credo, compile, tests). However, 3 files remain uncommitted:
- apps/xtweak_web/lib/xtweak_web_web/live/auth_live/login.ex
- apps/xtweak_web/lib/xtweak_web_web/live/auth_live/login.html.heex
- apps/xtweak_web/test/xtweak_web_web/live/auth_live/login_test.exs

## What Will Resume
Once changes are committed, `/prd-implement` will continue with Task 3: Implement password reset flow.

## Next Steps
**Action needed**: Please review and commit the 3 modified files.

**Suggested commit message**:
```
feat: add login UI for authentication

- Create LoginLive view with email/password form
- Implement HEEx template with Tailwind styling
- Add integration tests for login flow

✅ All quality gates passed
```

**After committing**, run `/prd-continue` again and I'll automatically resume Sprint 2 implementation.
```

### Case: Blocker Present
```markdown
📍 Resuming from Where We Left Off

## Context Analysis
✅ Git Status Checked
- **Branch**: feature/database
- **Status**: 2 files modified
- **Last Commit**: "Add Newsletter resource (WIP)"

✅ QUICK_START.md Read
- **Current Phase**: Phase 1 - Foundation
- **Current Sprint**: Sprint 2 - Core Components
- **Last Action**: Sprint 2 paused on Task 3 due to blocker
- **Recommended Next**: Resolve blocker then run /prd-continue

✅ Sprint REPORTS.md Analyzed
- **Progress**: 2 of 6 tasks complete
- **Last Task**: Task 3 (Database migration) - Blocked 🚫
- **Blockers**: Migration generation failing (UUID field issue)

## Determined State
🎯 **Status**: Blocked - Cannot Proceed

## Where We Left Off
Sprint 2 implementation is blocked on Task 3 (Database migration). The `ash_postgres.generate_migrations` command produces invalid SQL for the UUID primary key field on the Newsletter resource.

**Blocker Details**:
- **Task**: Task 3 of 6 (Database migration for Newsletter)
- **Issue**: UUID field type not recognized by migration generator
- **Severity**: Critical (blocks remaining tasks in sprint)
- **Recorded**: 2025-10-30

## What Will Resume
**Cannot resume automatically** - blocker must be resolved first.

## Next Steps
**Resolution Options**:
1. **Update dependencies**: `mix deps.update ash ash_postgres` (may include fix)
2. **Modify resource**: Change Newsletter resource UUID field configuration
3. **Manual migration**: Edit generated migration file directly

**After resolving**:
1. Mark blocker as resolved in `REPORTS.md`
2. Update `QUICK_START.md` to remove blocker mention
3. Run `/prd-continue` to automatically resume Sprint 2

**Need help?**: Run `/prd-status` for full project dashboard, or ask me to help resolve the blocker.
```

### Case: Sprint Complete
```markdown
📍 Resuming from Where We Left Off

## Context Analysis
✅ Git Status Checked
- **Branch**: main
- **Status**: Clean
- **Last Commit**: "Complete Sprint 2: Core Components"

✅ QUICK_START.md Read
- **Current Phase**: Phase 1 - Foundation
- **Current Sprint**: Sprint 2 complete! ✅
- **Last Action**: Sprint 2 completed successfully
- **Recommended Next**: Run /prd-plan-sprint for Sprint 3

✅ Sprint REPORTS.md Analyzed
- **Progress**: 6 of 6 tasks complete (100%)
- **Status**: ✅ Complete
- **Quality Gates**: All passed
- **Full Test Suite**: 47 tests passing

## Determined State
🎯 **Status**: Sprint Complete - Ready for Next Sprint

## Where We Left Off
Sprint 2 (Core Components) was successfully completed on 2025-10-30. All 6 tasks finished, quality gates passed, and work committed.

**Achievements**:
- User resource created with authentication
- Newsletter resource created
- Admin policies implemented
- Database migrations generated and tested
- Integration tests written (47 passing)

## What Will Resume
Planning for Sprint 3.

## Next Steps
**Launching**: `/prd-plan-sprint` to create Sprint 3 plan

Sprint 3 will build on Sprint 2's foundation. The planning agent will analyze the roadmap, identify next priorities, and create a detailed sprint plan.

[Automatically launches /prd-plan-sprint command]
```

## Error Handling
If any file is missing or unreadable:
```markdown
⚠️ Unable to Determine Complete Context

**Issue**: Could not read [file-name]
**Impact**: Cannot determine where we left off automatically

**What I Could Determine**:
[Show whatever information was successfully gathered]

**Recommendation**: Run `/prd-status` to see current state and manually decide next action.
```
