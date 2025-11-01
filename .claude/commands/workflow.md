---
description: Review, validate, and propose improvements to workflow infrastructure (agents, patterns, commands, documentation)
---

# Workflow Command

You are the **workflow infrastructure coordinator** using the workflow-expert agent for systematic workflow management.

## Your Task

Manage Claude Code's workflow infrastructure through structured audits, validations, and proposals. This includes reviewing agents, patterns, commands, and documentation for consistency, proposing new components, and ensuring workflow quality.

**All changes operate in PROPOSAL-ONLY mode** - workflow-expert never directly edits files, only generates structured proposals for Peter's approval.

## 🚨 MANDATORY: Pre-Task Protocol

**BEFORE invoking workflow-expert, you MUST run the Mandatory Pre-Task Protocol from CLAUDE.md**:

1. ✅ **Phase Zero Detection**
   - `ls apps/` → detect umbrella structure
   - `mcp__ash_ai__list_ash_resources` → identify domain
   - `mcp__tidewave__project_eval` → verify modules
   - Store context for session

2. ✅ **Load Workflow Context**
   - Read `.claude/README.md` (agent matrix, workflows)
   - Read `CLAUDE.md` (prompt analysis protocol)
   - Read `.claude/patterns/README.md` (pattern library)
   - Glob `.claude/agents/*.md`, `.claude/commands/*.md`, `.claude/patterns/*.md`

3. ✅ **Load Core Patterns**
   Read: `placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`, `documentation-organization`, `context-handling`, `collaboration-handoff`

4. ✅ **Verify Boundaries**
   - Confirm MANDATORY_AI_RULES.md read-only
   - Confirm usage-rules/ package-owned
   - Confirm AI_docs/prd/ off-limits

5. ✅ **Output Confirmation**
   ```markdown
   🔍 Pre-Task Protocol Complete (/workflow)
   - Action: [review|validate|add|update|self-check]
   - Apps: xtweak_core, xtweak_web, xtweak_ui
   - Domain: XTweak.Core
   - Workflow Files: [X] agents, [Y] patterns, [Z] commands
   - Patterns Loaded: 8 patterns
   - Boundaries Verified: PRD/MANDATORY/usage-rules OFF-LIMITS
   - Proceeding to launch workflow-expert (Sonnet)...
   ```

**If any step fails**: STOP and request clarification.

---

## Input Format

```
/workflow [action] [target]
```

### Actions

**1. review** - Full audit or scoped review
```
/workflow review                # Audit all workflow files
/workflow review agents         # Audit only agents
/workflow review patterns       # Audit only patterns
/workflow review commands       # Audit only commands
```

**2. validate** - Check specific component compliance
```
/workflow validate agent:code-reviewer
/workflow validate pattern:placeholder-basics
/workflow validate command:fix-bug
/workflow validate all          # Validate all components
```

**3. add** - Propose new component
```
/workflow add agent [name]
/workflow add pattern [name]
/workflow add command [name]

# With description for better context
/workflow add agent security-scanner --description "Scans for vulnerabilities"
```

**4. update** - Propose improvements to existing component
```
/workflow update agent:ash-resource-architect
/workflow update pattern:mcp-tool-discipline
/workflow update command:refactor
/workflow update README         # Update .claude/README.md
/workflow update CLAUDE          # Update CLAUDE.md
```

**5. self-check** - Validate workflow-expert itself (meta-capability)
```
/workflow self-check
```

---

## Examples

### Example 1: Full Audit
```
User: /workflow review

Coordinator:
1. Runs Pre-Task Protocol (phase-zero, load context, load patterns)
2. Launches workflow-expert (Sonnet) with context
3. workflow-expert:
   - Inventories: 24 agents, 17 patterns, 11 commands
   - Validates frontmatter, structure, cross-references
   - Detects 3 issues (1 critical, 2 medium)
   - Generates audit report with proposals

Output:
# Workflow Audit Report - [Date]

## Summary
- **Agents**: 24 found, 22 valid, 2 issues
- **Patterns**: 17 found, 17 valid, 0 issues
- **Commands**: 11 found, 10 valid, 1 issue

## Issues Detected

### Critical
- ❌ Agent `analyzer` references missing pattern `x-pattern`

### Medium
- ⚠️ Command `old-cmd` not referenced in CLAUDE.md

## Proposals
[Structured proposals for each issue]

**Awaiting Peter's approval for fixes**
```

### Example 2: Add New Agent
```
User: /workflow add agent security-scanner --description "Reviews dependency security"

Coordinator:
1. Runs Pre-Task Protocol
2. Launches workflow-expert (Sonnet)
3. workflow-expert:
   - Researches similar agents (grep for "security", "dependency")
   - Determines model: Sonnet (complex analysis)
   - Identifies pattern stack: Core 5 + error-recovery-loop
   - Maps to category: Infrastructure
   - Drafts complete agent file
   - Identifies integration: README.md updates needed
   - Generates proposal

Output:
# Proposal: New Agent - security-scanner

**Type**: New Agent
**Priority**: Medium
**Risk Level**: Low

## Summary
Creates new security-scanner agent for dependency vulnerability and licensing review.

## Proposed Changes

### Component 1: .claude/agents/security-scanner.md
**Action**: Create

[Complete file contents with frontmatter, structure, workflow]

### Component 2: .claude/README.md
**Action**: Update

```diff
# Agent matrix
@@ -X,Y +X,Z @@
 | dependency-auditor | Haiku | ... |
+| security-scanner | Sonnet | Reviews dependency security and licensing | ... |
```

## Risk Assessment
**Breaking Changes**: No
**Affected Workflows**: None (new capability)
**Testing**: Run `/workflow validate agent:security-scanner` after creation

## Approval Checklist
- [x] Frontmatter follows conventions
- [x] Pattern stack starts with Core 5
- [x] Integration points identified
- [x] No conflicts with existing agents

**Ready for Peter's Approval**: Yes

## Next Steps
**If Approved**:
1. Write to `.claude/agents/security-scanner.md`
2. Edit `.claude/README.md` (add row to agent matrix)
3. Run `/workflow validate agent:security-scanner`
```

### Example 3: Validate Specific Agent
```
User: /workflow validate agent:code-reviewer

Coordinator:
1. Runs Pre-Task Protocol
2. Launches workflow-expert (Sonnet)
3. workflow-expert:
   - Reads `.claude/agents/code-reviewer.md`
   - Validates frontmatter (all fields present, types correct)
   - Checks pattern stack (Core 5 first, ordered)
   - Verifies structure (sections present, ordered)
   - Checks references (patterns exist, tools valid)
   - Tests placeholder usage

Output:
# Validation Report: code-reviewer

**Date**: 2025-11-01T15:30:00Z
**Target**: .claude/agents/code-reviewer.md
**Type**: Agent

## Validation Results

### Frontmatter
- ✅ All required fields present
- ✅ YAML valid
- ✅ Model: sonnet (correct)
- ✅ Tags: 2 tags present

### Pattern Stack
- ✅ Core 5 present in correct order
- ✅ 7 patterns total
- ✅ All patterns exist in .claude/patterns/

### Structure
- ✅ All required sections present
- ✅ Sections in correct order
- ✅ Pre-Flight Checklist included

### References
- ✅ All patterns exist
- ✅ All MCP tools valid
- ✅ Usage rules exist

### Conventions
- ✅ Placeholder tokens used correctly
- ✅ MCP evidence cited
- ⚠️ Minor: Could add more examples for edge cases

## Overall Status: PASS WITH WARNINGS

**Issue Count**: 0 critical, 0 medium, 1 low

**Recommendation**: Optional improvement - add 1-2 more examples
```

### Example 4: Self-Check
```
User: /workflow self-check

Coordinator:
1. Runs Pre-Task Protocol
2. Launches workflow-expert (Sonnet)
3. workflow-expert:
   - Validates own agent file (.claude/agents/workflow-expert.md)
   - Validates own command file (.claude/commands/workflow.md)
   - Performs meta-analysis (capability gaps)
   - Proposes self-improvements if needed

Output:
# Workflow-Expert Self-Validation Report

## Agent File Validation: PASS
[Detailed validation of workflow-expert.md]

## Command File Validation: PASS
[Detailed validation of workflow.md]

## Meta-Analysis

**Current Capabilities**:
- ✅ Validate agent frontmatter (14+ rules)
- ✅ Check pattern stack ordering
- ✅ Cross-reference validation
- ✅ Proposal generation

**Gaps Detected**:
- ⚠️ No validation for duplicate tags across agents
- ℹ️ Could add metrics tracking (component count over time)

## Self-Improvement Proposal
[Structured proposal to enhance workflow-expert capabilities]
```

---

## Responsible Agents

### Primary
- **workflow-expert** (Sonnet) - Handles all /workflow actions
  - Full audits and validation
  - Proposal generation
  - Meta-analysis and self-improvement
  - Operating mode: Proposal-only (Read/Grep/Glob only)

### Supporting
- None (workflow-expert operates independently)

### Escalation
- If workflow-expert detects issues it cannot propose solutions for, escalates to Peter with detailed analysis

---

## Workflow Steps

### For `/workflow review [scope]`

**Step 1: Inventory Phase** (workflow-expert):
- Glob all files in scope (`.claude/agents/`, `.claude/patterns/`, `.claude/commands/`)
- Count components (agents: ~24, patterns: ~17, commands: ~11)
- Read `.claude/README.md`, `CLAUDE.md` for references

**Step 2: Validation Phase** (workflow-expert):
- For each component:
  - Parse frontmatter (YAML validation)
  - Check structure (sections present and ordered)
  - Validate references (patterns exist, agents exist, links work)
  - Check conventions (placeholder usage, MCP evidence)
- Build issue list (Critical/Medium/Low severity)

**Step 3: Analysis Phase** (workflow-expert):
- Cross-reference validation:
  - Agents in README matrix exist
  - Patterns in agent stacks exist
  - Commands in CLAUDE.md exist
- Detect orphans (files not referenced anywhere)
- Identify gaps (missing documentation, incomplete workflows)

**Step 4: Proposal Phase** (workflow-expert):
- For each issue:
  - Generate structured proposal (fix, rationale, risk, rollback)
- Prioritize by severity (Critical → Medium → Low)
- Group related proposals

**Step 5: Handoff** (coordinator):
- Receive audit report from workflow-expert
- Present to Peter with proposals
- Await approval/rejection/iteration

---

### For `/workflow validate [target]`

**Step 1: Target Resolution** (coordinator):
- Parse target (format: `type:name` or `all`)
- Resolve to file path(s)

**Step 2: Validation** (workflow-expert):
- Read target file(s)
- Run applicable validation rules (agent/pattern/command specific)
- Generate compliance report (pass/fail for each rule)

**Step 3: Handoff** (coordinator):
- Present validation report to Peter
- If fails, offer to generate fix proposal via `/workflow update [target]`

---

### For `/workflow add [type] [name]`

**Step 1: Research Phase** (workflow-expert):
- Grep existing components for similar functionality
- Read related patterns/agents
- Determine requirements:
  - Model (Haiku vs Sonnet based on complexity)
  - Pattern stack (Core 5 + specialized patterns)
  - Category (for agent matrix)
  - Integration points (README, CLAUDE.md updates)

**Step 2: Design Phase** (workflow-expert):
- Draft frontmatter (all required fields)
- Outline sections (follow established structure for type)
- Identify integration updates needed
- Define validation rules (how to check compliance)

**Step 3: Proposal Generation** (workflow-expert):
- Complete file contents (ready to Write)
- Integration diffs (README.md, CLAUDE.md if needed)
- Rationale with MCP evidence
- Risk assessment and rollback plan

**Step 4: Handoff** (coordinator):
- Present proposal to Peter
- Await approval
- **If approved**: Provide exact Edit/Write commands for Peter to execute
- **If rejected**: Iterate based on feedback

---

### For `/workflow update [target]`

**Step 1: Analysis Phase** (workflow-expert):
- Read current state of target
- Identify issues/gaps (if Peter didn't specify what to update)
- Research alternatives (check similar components)

**Step 2: Design Phase** (workflow-expert):
- Draft changes (unified diff format: `- old` / `+ new`)
- Check backward compatibility
- Update cross-references (if names/signatures change)

**Step 3: Proposal Generation** (workflow-expert):
- Before/after diffs
- Rationale with MCP evidence
- Impact analysis (which workflows affected)
- Migration plan (if breaking changes)
- Rollback plan

**Step 4: Handoff** (coordinator):
- Present proposal to Peter
- Await approval
- **If approved**: Provide exact Edit commands
- **If rejected**: Iterate based on feedback

---

### For `/workflow self-check`

**Step 1: Self-Validation** (workflow-expert):
- Run `/workflow validate agent:workflow-expert` (internal)
- Run `/workflow validate command:workflow` (internal)
- Check own capabilities against current workflow needs

**Step 2: Meta-Analysis** (workflow-expert):
- "Am I missing validation rules I should have?"
- "Are my proposals clear and actionable?"
- "Do I follow my own conventions?"
- Identify capability gaps

**Step 3: Proposal** (workflow-expert):
- Generate self-improvement proposal if gaps found
- Example: "I should add validation for orphaned patterns I currently miss"

**Step 4: Handoff** (coordinator):
- Present self-validation report
- Present self-improvement proposal if applicable
- Demonstrates meta-capability

---

## Output Format

All `/workflow` commands produce one of these output types:

### Audit Report
```markdown
# Workflow Audit Report

**Date**: [ISO 8601]
**Scope**: [Full | Agents | Patterns | Commands]
**Duration**: [X minutes]

## Summary Statistics
- **Total Components**: X
- **Valid**: Y (Z%)
- **Issues Detected**: N (Critical: A, Medium: B, Low: C)

## Components Reviewed
[Table with Type, Name, Status, Issues columns]

## Issues Detected
[Grouped by severity: Critical → Medium → Low]

## Detailed Proposals
[Link/reference to structured proposals for each issue]

## Recommendations
[High-level process improvements]

**Next Steps**: Review proposals, approve/reject/iterate
```

### Validation Report
```markdown
# Validation Report: [Target]

**Date**: [ISO 8601]
**Target**: [File path]
**Type**: [Agent | Pattern | Command]

## Validation Results
[Sections: Frontmatter, Structure, References, Conventions]

## Overall Status: [PASS | PASS WITH WARNINGS | FAIL]

**Issue Count**: [Breakdown by severity]

**Proposal**: [If fails, reference to fix proposal]
```

### Proposal (New/Update Component)
```markdown
# Workflow Proposal: [Title]

**Type**: [New/Update] [Agent|Pattern|Command|Other]
**Priority**: [High|Medium|Low]
**Risk Level**: [Low|Medium|High]

## Summary
[2-3 sentences: What, Why, Impact]

## Current State Analysis
[Evidence from MCP/Grep, Issues detected]

## Proposed Changes
[Diffs or complete file contents for each component]

## Integration Updates
[Changes needed to README.md, CLAUDE.md, etc.]

## Risk Assessment
[Breaking changes?, Affected workflows, Dependencies, Testing]

## Rollback Plan
[Steps to undo if issues, Files to backup]

## Approval Checklist
[Validation checks before approval]

## Next Steps
**If Approved**: [Exact tool commands]
**If Rejected**: [Iteration approach]
```

---

## Quality Checks

Before completing `/workflow` command:

**Coordinator Checks**:
- [ ] Pre-Task Protocol completed (phase-zero, context loaded, patterns loaded)
- [ ] workflow-expert launched successfully with Sonnet model
- [ ] All required context loaded (README, CLAUDE.md, pattern files)
- [ ] Boundaries verified (PRD/MANDATORY/usage-rules off-limits)
- [ ] Proposal(s) received from workflow-expert

**Workflow-Expert Checks** (delegated):
- [ ] All MCP evidence cited (no unsupported claims)
- [ ] Diffs use unified diff format (`- old`, `+ new`)
- [ ] File paths absolute where required
- [ ] Placeholder tokens in examples (`{Placeholder}`)
- [ ] Proposal complete (rationale, risk, rollback)
- [ ] No Edit/Write executed (proposal-only mode maintained)

**Output Checks**:
- [ ] Report/proposal formatted correctly
- [ ] Peter can approve/reject without additional research
- [ ] Next steps clear and actionable
- [ ] Success criteria defined

**Meta-Check** (for self-check):
- [ ] workflow-expert validated itself using own rules
- [ ] Self-improvement proposal demonstrates meta-capability (if gaps found)

---

## Remember

- **Proposal-Only Mode**: workflow-expert NEVER executes Edit/Write/NotebookEdit tools
- **Evidence-Based**: All proposals cite MCP tool output or file reads
- **Rollback Plans**: Every proposal includes how to undo changes
- **Boundaries**: PRD, MANDATORY_AI_RULES, usage-rules are OFF-LIMITS
- **Cost Optimization**: Use Sonnet for complex analysis (workflow infrastructure is complex)
- **Read MANDATORY_AI_RULES.md**: Applies to all workflow work (no commits without permission)
