# Claude Agent Workflows

This document describes recommended agent sequences and workflows for common development tasks in your Elixir/Ash/Phoenix project.

## Table of Contents

- [Code Quality Pipeline](#code-quality-pipeline)
- [Frontend Development](#frontend-development)
- [Backend Resource Development](#backend-resource-development)
- [Feature Implementation](#feature-implementation)
- [Bug Fixing](#bug-fixing)
- [Security Review](#security-review)
- [Testing Workflow](#testing-workflow)

---

## Code Quality Pipeline

**Objective**: Review and improve code quality for existing files.

### Workflow Sequence

```
mcp-verify-first → code-reviewer → code-review-implement → code-reviewer (re-verify)
```

### Step-by-Step

1. **mcp-verify-first**: Verify current implementation and patterns
   - Check module existence
   - Verify actions and structure
   - Understand current behavior

2. **code-reviewer**: Analyze code quality
   - Single-file focus
   - Generate structured report with scores
   - Identify critical issues, recommendations, quick wins

3. **code-review-implement**: Apply improvements
   - Implement critical fixes first
   - Apply recommendations systematically
   - Use TodoWrite to track progress
   - Run quality gates after each change

4. **code-reviewer (re-verify)**: Confirm improvements
   - Re-analyze the file
   - Verify issues were resolved
   - Confirm quality score improved

### Example Usage

```bash
# User request: "Review and improve User resource"

# Step 1: Verify implementation
Launch mcp-verify-first agent
→ Returns: Current User resource structure, actions, relationships

# Step 2: Review quality
Launch code-reviewer agent with User.ex
→ Returns: Quality score 6.8/10, 3 critical issues, 5 recommendations

# Step 3: Implement fixes
Launch code-review-implement with review report
→ Fixes all critical issues, applies recommendations

# Step 4: Re-verify
Launch code-reviewer again
→ Returns: Quality score 9.2/10, all critical issues resolved
```

---

## Frontend Development

**Objective**: Implement new LiveView pages or components with proper design standards.

### Workflow Sequence

```
mcp-verify-first → ash-resource-architect (if needed) → frontend-design-enforcer → test-builder → security-reviewer (if auth/sensitive)
```

### Step-by-Step

1. **mcp-verify-first**: Research existing patterns
   - Find similar LiveView components
   - Verify Ash resources available
   - Check for existing forms/patterns

2. **ash-resource-architect** (if creating new resource): Design backend first
   - Create Ash resource for data
   - Define actions and policies
   - Generate migrations

3. **frontend-design-enforcer**: Implement UI
   - Component-first with DaisyUI
   - Ash forms integration
   - Responsive design
   - Accessibility compliance
   - Playwright testing

4. **test-builder**: Write LiveView tests
   - Mount/render tests
   - Event handler tests
   - Form submission tests
   - Integration tests

5. **security-reviewer** (if authentication/sensitive data): Security check
   - XSS prevention
   - CSRF protection
   - Authorization checks

### Example Usage

```bash
# User request: "Add a reputation leaderboard page"

# Step 1: Verify resources
Launch mcp-verify-first
→ Finds: Reputation resource exists, User resource exists

# Step 2: Implement frontend
Launch frontend-design-enforcer
→ Creates: LeaderboardLive with DaisyUI table, responsive design, Playwright tests

# Step 3: Write tests
Launch test-builder
→ Creates: leaderboard_live_test.exs with mount, rendering, sorting tests

# Step 4: Security review
Launch security-reviewer
→ Verifies: Proper authorization, no data leaks
```

---

## Backend Resource Development

**Objective**: Create or modify Ash resources with proper domain modeling.

### Workflow Sequence

```
mcp-verify-first → ash-resource-architect → test-builder → code-reviewer
```

### Step-by-Step

1. **mcp-verify-first**: Research existing resources
   - List all current resources
   - Check for similar patterns
   - Verify relationships
   - Check available generators

2. **ash-resource-architect**: Design and implement
   - Design attributes, relationships, actions
   - Use generators where possible
   - Implement policies and calculations
   - Generate migrations

3. **test-builder**: Write comprehensive tests
   - Test all CRUD actions
   - Test relationships
   - Test policies
   - Test edge cases

4. **code-reviewer**: Final quality check
   - Verify best practices
   - Check policy coverage
   - Validate structure

### Example Usage

```bash
# User request: "Create Reputation resource to track user contributions"

# Step 1: Research
Launch mcp-verify-first
→ Finds: User resource, Contribution resource, no Reputation resource exists

# Step 2: Design and implement
Launch ash-resource-architect
→ Creates: Reputation resource with score, last_calculated, relationships, policies
→ Generates: Migration for reputations table

# Step 3: Write tests
Launch test-builder
→ Creates: reputation_test.exs with CRUD, relationship, calculation tests

# Step 4: Quality check
Launch code-reviewer
→ Verifies: 9.5/10 quality score, all patterns correct
```

---

## Feature Implementation

**Objective**: Implement complete feature across backend and frontend.

### Workflow Sequence

```
mcp-verify-first → ash-resource-architect → test-builder → frontend-design-enforcer → test-builder → security-reviewer → code-reviewer
```

### Step-by-Step

1. **mcp-verify-first**: Understand requirements and existing code
2. **ash-resource-architect**: Build backend resources
3. **test-builder**: Test backend thoroughly
4. **frontend-design-enforcer**: Build frontend UI
5. **test-builder**: Test frontend interactions
6. **security-reviewer**: Security audit
7. **code-reviewer**: Final quality check

### Example Usage

```bash
# User request: "Implement token transfer feature"

# Backend Phase
Launch mcp-verify-first → ash-resource-architect → test-builder
→ Creates: TokenTransaction resource with transfer action
→ Tests: All transaction scenarios

# Frontend Phase
Launch mcp-verify-first → frontend-design-enforcer → test-builder
→ Creates: TransferLive with form, validation, real-time updates
→ Tests: Form submission, validation, success/error states

# Verification Phase
Launch security-reviewer → code-reviewer
→ Verifies: No vulnerabilities, high quality code
```

---

## Bug Fixing

**Objective**: Diagnose and fix bugs systematically.

### Workflow Sequence

```
mcp-verify-first → test-builder (add reproduction test) → code-review-implement → test-builder (verify fix)
```

### Step-by-Step

1. **mcp-verify-first**: Reproduce and understand bug
   - Check logs for errors
   - Reproduce with project_eval
   - Identify root cause

2. **test-builder**: Write failing test
   - Test should reproduce the bug
   - Test should fail before fix

3. **code-review-implement** or direct fix: Fix the issue
   - Implement fix based on root cause
   - Verify with MCP tools

4. **test-builder**: Verify fix
   - Test should now pass
   - Add edge case tests

### Example Usage

```bash
# User request: "Token creation fails with negative amount"

# Step 1: Diagnose
Launch mcp-verify-first
→ Finds: No validation on Token.amount attribute

# Step 2: Write reproduction test
Launch test-builder
→ Creates: Test that attempts to create token with negative amount

# Step 3: Fix
Launch code-review-implement or manual fix
→ Adds: Constraint to Token.amount: min: 0

# Step 4: Verify
Run tests
→ Result: Previously failing test now passes
```

---

## Security Review

**Objective**: Audit codebase for security vulnerabilities.

### Workflow Sequence (Local Changes)

```
security-reviewer → code-review-implement (fix issues) → security-reviewer (re-verify)
```

### Workflow Sequence (Full Codebase)

```
security-reviewer --full → code-review-implement (fix by priority) → test-builder (add security tests)
```

### Step-by-Step

1. **security-reviewer**: Identify vulnerabilities
   - High confidence only (8+/10)
   - Concrete exploit paths
   - Prioritize by severity

2. **code-review-implement**: Fix vulnerabilities
   - Start with HIGH severity
   - Then MEDIUM severity
   - Document fixes

3. **test-builder** (optional): Add security regression tests
   - Test authorization
   - Test input validation
   - Test XSS/CSRF protection

4. **security-reviewer** (re-verify): Confirm fixes

### Example Usage

```bash
# User request: "Run security audit before release"

# Step 1: Full codebase review
Launch security-reviewer with --full
→ Finds: 2 HIGH, 5 MEDIUM vulnerabilities
→ Saves: security_reviews/20250110_143022_main_full_review.md

# Step 2: Fix HIGH severity issues
Launch code-review-implement for each HIGH issue
→ Fixes: Missing authorization policies, XSS in user input

# Step 3: Add regression tests
Launch test-builder
→ Creates: Security tests for authorization bypass, XSS

# Step 4: Re-verify
Launch security-reviewer
→ Result: 0 HIGH, 2 MEDIUM remaining (acceptable for release)
```

---

## Testing Workflow

**Objective**: Achieve comprehensive test coverage for features.

### Workflow Sequence

```
mcp-verify-first → test-builder → mcp-verify-first (verify tests pass)
```

### Step-by-Step

1. **mcp-verify-first**: Understand implementation
   - Verify module structure
   - Test behavior with project_eval
   - Identify all actions/functions to test

2. **test-builder**: Write comprehensive tests
   - Happy path tests
   - Validation failure tests
   - Edge case tests
   - Relationship tests
   - Authorization tests

3. **mcp-verify-first**: Verify tests work
   - Run tests
   - Check logs for errors
   - Verify coverage

### Example Usage

```bash
# User request: "Write tests for Knowledge resource"

# Step 1: Understand implementation
Launch mcp-verify-first
→ Finds: Knowledge resource with create, read, update, destroy actions
→ Finds: Relationships to User (owner), Contributions

# Step 2: Write tests
Launch test-builder
→ Creates: knowledge_test.exs with:
  - CRUD action tests
  - Validation tests (title required, content length)
  - Relationship tests (owner, contributions)
  - Authorization tests (owner-only update/delete)

# Step 3: Verify
Launch mcp-verify-first
→ Runs: mix test test/{yourapp}/core/knowledge_test.exs
→ Result: 24 tests, 0 failures
```

---

## Specialized Workflows

### Cytoscape Graph Feature

```
mcp-verify-first → cytoscape-expert → frontend-design-enforcer (verify design) → test-builder
```

Use `cytoscape-expert` for any graph visualization work, then verify design compliance and add tests.

---

## Agent Selection Quick Reference

| Task | Primary Agent | Supporting Agents |
|------|---------------|-------------------|
| Code review | code-reviewer | mcp-verify-first, code-review-implement |
| Frontend UI | frontend-design-enforcer | mcp-verify-first, test-builder |
| Backend resource | ash-resource-architect | mcp-verify-first, test-builder |
| Testing | test-builder | mcp-verify-first |
| Bug fix | mcp-verify-first | test-builder, code-review-implement |
| Security audit | security-reviewer | code-review-implement, test-builder |
| Graph viz | cytoscape-expert | frontend-design-enforcer, test-builder |
| Verification | mcp-verify-first | (used before most other agents) |
| Design new agent | agent-architect | - |

---

## General Principles

1. **Always start with mcp-verify-first** for implementation tasks
2. **Use TodoWrite** for complex multi-agent workflows
3. **Run quality gates** between agent handoffs
4. **Verify with MCP tools** before claiming task complete
5. **Security review** for auth/sensitive features
6. **Test after implementation** - use test-builder
7. **Re-verify after fixes** - run agents again to confirm

---

## Workflow Examples

### Example 1: Complete Feature (Reputation System)

```
User: "Implement reputation system based on contributions"

Sequence:
1. mcp-verify-first
   → Verify: User, Contribution resources exist
   → Check: No Reputation resource

2. ash-resource-architect
   → Create: Reputation resource
   → Design: score, last_calculated, user relationship
   → Add: Recalculate action, rank calculation

3. test-builder
   → Test: Create, read, update, recalculate actions
   → Test: Rank calculation (Beginner/Intermediate/Advanced/Expert)
   → Test: Authorization (user can recalculate own)

4. frontend-design-enforcer
   → Create: ReputationLive page
   → Display: User reputation with rank badge
   → Add: Recalculate button

5. test-builder
   → Test: LiveView mount, reputation display
   → Test: Recalculate button triggers action

6. security-reviewer
   → Verify: Authorization on recalculate action
   → Verify: No data leaks in display

7. code-reviewer
   → Final check: Code quality 9+/10
```

### Example 2: Bug Fix (Token Balance)

```
User: "Token balance showing wrong amount after transfer"

Sequence:
1. mcp-verify-first
   → Check logs: No errors
   → Test: project_eval reproduces issue
   → Identify: Calculation doesn't include pending transfers

2. test-builder
   → Write failing test: Token balance with pending transfer
   → Test fails ✗

3. Direct fix or code-review-implement
   → Update: Token.balance calculation to filter pending
   → Verify with project_eval

4. Run tests
   → Test now passes ✓

5. mcp-verify-first
   → Verify fix in production code
   → Check logs: No errors
```

---

## Best Practices

✅ **Start with verification**: Use mcp-verify-first to understand existing code
✅ **Use specialized agents**: Each agent is optimized for specific tasks
✅ **Chain agents systematically**: Follow recommended sequences
✅ **Track progress**: Use TodoWrite for multi-step workflows
✅ **Verify between steps**: Run MCP tools to confirm each phase
✅ **Run quality gates**: Format, compile, test between agents
✅ **Document workflows**: Update this file with new patterns

❌ **Don't skip verification**: Assumptions lead to errors
❌ **Don't use wrong agent**: Each has specific expertise
❌ **Don't skip testing**: Always write tests for new code
❌ **Don't skip security**: Review auth/sensitive features
❌ **Don't batch agent runs**: Verify results between each

---

## Contributing

When you discover new effective agent sequences, add them to this document following the template:

```markdown
### Workflow Name

**Objective**: What this workflow achieves

### Workflow Sequence
```
agent1 → agent2 → agent3
```

### Step-by-Step
1. **agent1**: What it does
2. **agent2**: What it does
3. **agent3**: What it does

### Example Usage
[Concrete example with commands and results]
```

---

Last updated: 2025-01-10
Version: 1.0
Agents: 9 (7 original + 2 new: test-builder, ash-resource-architect)