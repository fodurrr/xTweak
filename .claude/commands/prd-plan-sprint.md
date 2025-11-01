You are the sprint planning coordinator using the `docs-maintainer` agent.

## Your Task
Plan the next sprint based on the PRD roadmap and create a detailed sprint plan.

## Responsible Agents
- **Primary**: `docs-maintainer` (Haiku - cost effective for documentation work)
- **Support**: `mcp-verify-first` (Haiku - context gathering)
- **Escalation**: `ash-resource-architect` (Sonnet - if architecture decisions needed)

## Steps

### 1. Gather Context
Launch `mcp-verify-first` agent to gather project context:
- Read `prd/QUICK_START.md` to understand current status (where we left off, last action)
- Read `prd/.prd-completion-status.md` to see what's already completed
- Read `prd/05-implementation-roadmap.md` to understand phase and sprint structure
- Check git status for any uncommitted work

### 2. Identify Next Sprint
Determine which sprint to plan based on:
- Last completed sprint (from QUICK_START.md and .prd-completion-status.md)
- Dependencies (can't start Sprint 2 without completing Sprint 1)
- Priority from implementation roadmap
- Current phase in the project

### 3. Create Detailed Sprint Plan
Create a new sprint plan file in the appropriate phase folder:

**Location**: `prd/06-sprint-plans/[phase-folder]/sprint-[number]-[name].md`

**Sprint Plan Structure**:
```markdown
# Sprint [Number]: [Name]

## Sprint Objectives
- [Primary objective 1]
- [Primary objective 2]
- [etc.]

## Success Criteria
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [etc.]

## Tasks

### Task 1: [Task Name]
**Agent**: [Which agent will handle this] (Haiku/Sonnet)
**Description**: [What needs to be done]
**Dependencies**: [Other tasks this depends on, or "None"]
**Estimated Complexity**: Low/Medium/High
**Success Criteria**:
- [ ] [Specific criterion]
- [ ] [etc.]

### Task 2: [Task Name]
[Same structure as above]

[... etc for all tasks ...]

## Agent Assignments Summary
- `mcp-verify-first` (Haiku): Context verification for all tasks
- `ash-resource-architect` (Sonnet): [Tasks X, Y]
- `frontend-design-enforcer` (Sonnet): [Tasks A, B]
- [etc.]

## Quality Gates
- [ ] All code formatted (`mix format`)
- [ ] No Credo violations (`mix credo --strict`)
- [ ] No compiler warnings (`mix compile --warnings-as-errors`)
- [ ] All tests passing (`mix test [relevant paths]`)
- [ ] Migrations generated (if applicable)

## Risks & Mitigation
- **Risk 1**: [Description]
  - **Mitigation**: [How to address]
- [etc.]

## Estimated Duration
[X] days / [Y] developer-days

## Related Documentation
- PRD Section: [Link to relevant PRD sections]
- Framework Rules: [Which usage-rules/ files agents should consult]
- Usage Rules: [Additional usage_rules/ files that are relevant]
```

### 4. Create REPORTS.md Template
Create a `REPORTS.md` file in the same sprint folder to track progress:

**Location**: Same folder as sprint plan

**Structure**:
```markdown
# Sprint [Number] Reports

## Sprint Status
- **Started**: [Date]
- **Target Completion**: [Date]
- **Actual Completion**: Not yet complete
- **Status**: 🚧 In Progress / ✅ Complete / 🚫 Blocked

## Task Progress

### Task 1: [Name]
**Status**: Pending / In Progress / Complete / Blocked
**Agent**: [Agent name]
**Started**: [Date or N/A]
**Completed**: [Date or N/A]
**Notes**: [Progress notes, decisions made, issues encountered]

[... for each task ...]

## Decisions Made
- [Date]: [Decision description and rationale]
- [etc.]

## Blockers Encountered
- [Date]: [Blocker description]
  - **Resolution**: [How it was resolved or current status]
- [etc.]

## Quality Gate Results
- **Format**: ✅ Pass / ❌ Fail
- **Credo**: ✅ Pass / ❌ Fail
- **Compile**: ✅ Pass / ❌ Fail
- **Tests**: ✅ Pass / ❌ Fail ([X] passing, [Y] failing)

## Agent Execution Log
- [Date/Time]: Launched `[agent-name]` for [task]
  - **Result**: Success / Escalation / Failure
  - **Notes**: [Brief summary]
- [etc.]

## Next Actions
- [ ] [Action item 1]
- [ ] [Action item 2]
```

### 5. Update Documentation
After creating the sprint plan:

**Update `QUICK_START.md`**:
```markdown
## 📍 Current Status
- **Phase**: [Phase number and name]
- **Sprint**: [Sprint number and name]
- **Last Update**: [Today's date]
- **Last Action**: Sprint plan created for Sprint [number]

## 🎯 Where We Left Off
Sprint [number] plan has been created and is ready for implementation.

**Next Action**: Run `/prd-implement` to start executing the sprint plan.

## 📂 Active Sprint
Sprint [number]: [Name]
See: `prd/06-sprint-plans/[phase]/sprint-[number]-[name].md`
```

**Update `.prd-completion-status.md`**:
Add the new sprint to the tracking file with "Planned" status.

### 6. Create Todo List for Peter
Present your results as a clear todo list showing:
- ✅ Sprint number and name determined
- ✅ Sprint plan created with [X] tasks
- ✅ Agent assignments defined
- ✅ REPORTS.md template created
- ✅ QUICK_START.md updated
- ✅ .prd-completion-status.md updated
- ⏳ **Next action**: Run `/prd-implement` to start implementation

## Output Format
Always present results as a todo list with clear next steps. Include:
- What was created (sprint plan file path)
- Number of tasks defined
- Which agents will be involved
- Estimated complexity/duration
- **Recommended next command**: `/prd-implement`

## Quality Checks
Before completing:
- [ ] Sprint plan follows the structure above
- [ ] All tasks have assigned agents (Haiku or Sonnet specified)
- [ ] Dependencies between tasks are clear
- [ ] Success criteria are measurable
- [ ] REPORTS.md template is created
- [ ] QUICK_START.md reflects new sprint status
- [ ] Todo list clearly shows next action

## Example Output
```markdown
✅ Sprint plan created successfully!

## What Was Done
- ✅ Analyzed PRD roadmap and current status
- ✅ Determined next sprint: Sprint 2 (Core Components)
- ✅ Created detailed sprint plan with 8 tasks
- ✅ Assigned agents: ash-resource-architect (4 tasks), frontend-design-enforcer (2 tasks), test-builder (2 tasks)
- ✅ Created REPORTS.md template for progress tracking
- ✅ Updated QUICK_START.md with new sprint status
- ✅ Updated .prd-completion-status.md

## Sprint Details
- **File**: `prd/06-sprint-plans/phase-1-foundation/sprint-2-core-components.md`
- **Tasks**: 8 total (4 backend, 2 frontend, 2 testing)
- **Estimated Duration**: 5-7 days
- **Complexity**: Medium

## Next Step
Run `/prd-implement` to start executing Sprint 2 tasks.
```
