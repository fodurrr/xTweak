You are the PRD maintainer using the `docs-maintainer` agent.

## Your Task
Update a specified PRD section with new information, decisions, or changes while maintaining structure and accuracy.

## Responsible Agents
- **Primary**: `docs-maintainer` (Haiku - documentation updates)
- **Support**: `mcp-verify-first` (Haiku - verify accuracy)

## Command Format
```
/prd-update [section]
```

**Examples**:
- `/prd-update 03-architecture` - Update architecture chapter
- `/prd-update sprint-1` - Update Sprint 1 plan
- `/prd-update QUICK_START` - Update quick start guide
- `/prd-update component-inventory` - Update component list

## Steps

### 1. Parse Section Argument
Identify which PRD section to update:

**PRD Chapters** (in `AI_docs/prd/`):
- `00-executive-summary` or `executive-summary` → `00-executive-summary.md`
- `01-technical-specification` or `technical-specification` or `tech-spec` → `01-technical-specification.md`
- `02-requirements` or `requirements` → `02-requirements.md`
- `03-architecture` or `architecture` or `arch` → `03-architecture.md`
- `04-component-inventory` or `component-inventory` or `components` → `04-component-inventory.md`
- `05-implementation-roadmap` or `roadmap` → `05-implementation-roadmap.md`

**Sprint Plans** (in `AI_docs/prd/06-sprint-plans/[phase]/`):
- `sprint-1`, `sprint-2`, etc. → Find in appropriate phase folder
- `phase-1-sprint-1` → Specify both phase and sprint

**Status Files**:
- `QUICK_START` or `quick-start` → `AI_docs/prd/QUICK_START.md`
- `completion-status` or `status` → `AI_docs/prd/.prd-completion-status.md`

**If no argument provided**: Ask Peter which section to update.

### 2. Read Current Content
Launch `mcp-verify-first` to read the specified section:

**Read the target file**:
- Load current content to understand structure
- Note last update date
- Identify sections that may need updating

**Verify current state** (if updating technical content):
- Use MCP tools to check current implementation:
  - `mcp__ash_ai__list_ash_resources` - Check current resources
  - `mcp__tidewave__project_eval` - Verify module structure
  - `mcp__tidewave__get_ecto_schemas` - Check database schemas
  - Git log: `git log --oneline [file-path]` - See recent changes

**Check related files**:
- If updating architecture: Check current app structure (`ls apps/`)
- If updating roadmap: Check sprint REPORTS.md for actual progress
- If updating component inventory: Check actual component implementations

### 3. Gather New Information
Determine what needs to be updated:

**From Peter** (if interactive):
- Ask: "What new information should be added to [section]?"
- Ask: "What changed from the current version?"

**From codebase** (if updating technical sections):
- Verify current architecture matches documented architecture
- Check if new resources/modules have been added
- Identify completed features from sprint reports

**From sprint reports** (if updating roadmap/status):
- Read recent sprint REPORTS.md files
- Check completion status of planned items
- Identify new decisions or changes in approach

### 4. Update PRD Section
Make updates while preserving structure:

**Maintain formatting**:
- Keep existing heading hierarchy
- Preserve table structures
- Maintain lists and numbering
- Keep consistent style (Markdown conventions)

**Add date stamp**:
```markdown
**Last Updated**: [Today's date]
**Changes**: [Brief description of what changed]
```

**Update content**:
- Add new information in appropriate sections
- Update outdated information with current facts
- Mark deprecated/removed items (don't delete history, mark as "Deprecated as of [date]")
- Add links to related documentation if new sections added

**Common updates by section**:

**Architecture (03-architecture.md)**:
- Update umbrella app structure if apps added/removed
- Update module organization if refactored
- Add new integration points
- Update dependency relationships

**Roadmap (05-implementation-roadmap.md)**:
- Update sprint completion status
- Adjust timeline if schedule changed
- Add newly identified requirements
- Update phase estimates based on actual velocity

**Component Inventory (04-component-inventory.md)**:
- Mark components as implemented/in-progress/planned
- Add implementation notes for completed components
- Update component priorities if changed

**Requirements (02-requirements.md)**:
- Add newly discovered requirements
- Update requirement status (planned/in-progress/complete)
- Add acceptance criteria if refined

**QUICK_START.md**:
- Update current status
- Update "where we left off" narrative
- Update next action
- Update completion stats

### 5. Verify Accuracy
Before saving changes:

**Cross-reference** with:
- Current codebase state (use MCP tools)
- Recent sprint reports
- Git history

**Check for**:
- Contradictions with other PRD sections
- Outdated information still present
- Broken links to other docs
- Missing context for new additions

### 6. Update Related Documentation
If the update affects other files:

**If architecture changed**:
- Update `QUICK_START.md` if major change
- Note in `.prd-completion-status.md` if implementation affected
- Update `usage-rules/` if patterns changed

**If roadmap changed**:
- Update `.prd-completion-status.md` with new timeline
- Update `QUICK_START.md` if current sprint affected
- Update affected sprint plans if priorities shifted

**If requirements changed**:
- Review sprint plans for affected tasks
- Note in current sprint REPORTS.md if in-progress work affected
- Update `QUICK_START.md` if immediate action needed

### 7. Create Todo List for Peter
Present results showing:
- ✅ Section identified and read
- ✅ Current state verified (if applicable)
- ✅ Updates applied
- ✅ Related docs updated (if any)
- 📄 File(s) modified
- 📝 Summary of changes
- ⏳ Next recommended action

## Output Format
Always create a todo list with clear summary of changes:

```markdown
✅ PRD Section Updated

## What Was Updated
- **Section**: [section name]
- **File**: [file path]
- **Last Updated**: [Today's date]

## Changes Made
- [Change 1: Description]
- [Change 2: Description]
- [etc.]

## Verification
- ✅ Current codebase state verified with MCP tools
- ✅ Cross-referenced with sprint reports
- ✅ No contradictions with other PRD sections
- ✅ All links working

## Related Documentation Updated
[If any related files were updated, list them. Otherwise: "None needed."]
- `QUICK_START.md` - Updated current status
- [etc.]

## Next Action
[Recommended next command based on what was updated]
- Continue with `/prd-implement` to resume current sprint
OR
- Run `/prd-status` to see updated status
OR
- No immediate action needed - PRD documentation synchronized
```

## Quality Checks
Before completing:
- [ ] Section updated maintains original structure
- [ ] Date stamp added with change description
- [ ] New information is factually accurate (verified with MCP tools if technical)
- [ ] No broken links or references
- [ ] Related documentation updated if needed
- [ ] Changes don't contradict other PRD sections
- [ ] Markdown formatting correct

## Example Output

```markdown
✅ Architecture Documentation Updated

## What Was Updated
- **Section**: Architecture (Chapter 03)
- **File**: `AI_docs/prd/03-architecture.md`
- **Last Updated**: 2025-10-30

## Changes Made
- Added new `xtweak_ui` umbrella app to architecture diagram
- Updated module dependency graph to show UI component library
- Added section on component isolation strategy
- Updated data flow diagram to include UI ↔ Web ↔ Core flow
- Marked old "single web app" approach as deprecated (2025-10-28)

## Verification
- ✅ Verified `xtweak_ui` app exists: `ls apps/` confirmed
- ✅ Checked current umbrella structure matches updated diagram
- ✅ Cross-referenced with Sprint 2 reports (UI library creation)
- ✅ All internal links working

## Related Documentation Updated
- `QUICK_START.md` - Updated to reflect new app in current architecture
- `04-component-inventory.md` - Added note about UI app location

## Next Action
No immediate action needed - architecture documentation now synchronized with current implementation.

**Optional**: Run `/prd-status` to see overall project status.
```

## Special Cases

### Updating QUICK_START.md
Focus on:
- Current phase and sprint
- "Where we left off" narrative (most important)
- Next action recommendation
- Keep it concise (~50 lines max)

### Updating Sprint Plans
If updating an existing sprint plan:
- Mark completed tasks with ✅
- Update estimated vs actual duration
- Add lessons learned
- Don't remove original plan, show evolution

### Updating Completion Status
- Recalculate percentages
- Update sprint status (planned/in-progress/complete)
- Add completion dates
- Update next milestone

## Error Handling
If section not found:
```markdown
❌ Section Not Found

**Attempted**: [section argument provided]
**Error**: Could not locate PRD section matching "[argument]"

## Available Sections
[List valid section names]

**Action**: Please run `/prd-update [valid-section]` with a valid section name.
```

If MCP verification fails:
```markdown
⚠️ Could not verify current state

**Section**: [section name]
**Issue**: MCP tools unavailable or returned errors

**Action**: Proceeding with update based on user input, but unable to verify against codebase. Manual verification recommended.
```
