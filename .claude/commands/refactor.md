---
description: Code health improvements - extract logic, reduce duplication, modernize patterns without changing behavior
---

# Refactor Command

You are the **code refactoring coordinator** for systematic code quality improvements.

## Your Task
Improve code quality without changing external behavior. Handle extraction, deduplication, modernization, and reorganization work.

## Input Format
```
/refactor [operation] [target] [--scope=file|module|app]
```

**Examples**:
- `/refactor extract-function apps/xtweak_core/lib/xtweak/core/user.ex`
- `/refactor modernize-heex apps/xtweak_web/lib/xtweak_web_web/live/`
- `/refactor remove-duplication apps/xtweak_core/lib/xtweak/core/`

## Responsible Agents
- **mcp-verify-first** (Haiku) - Context gathering, impact analysis
- **code-reviewer** (Sonnet) - Refactoring strategy, safety analysis
- **test-builder** (Sonnet) - Ensure behavior unchanged
- **Domain specialists** (Sonnet/Haiku) - Implementation per area

## Common Operations

### Extract (Function/Module/Preparation)
Pull out duplicated or complex logic into reusable unit
- Same logic appears 3+ times → Extract to function
- Function >50 lines → Break into smaller functions
- Ash actions share logic → Extract to preparation

### Modernize (Syntax/Patterns)
Update to current framework/language patterns
- Old EEx `<%= if %>` → Modern HEEx `:if` attribute
- Legacy Ecto → Ash resources
- Deprecated APIs → Current equivalents

### Simplify (Conditionals/Logic)
Reduce complexity without changing behavior
- Nested conditionals → Guard clauses or with statements
- Complex boolean logic → Named functions
- Pattern matching opportunities → Use patterns

### Remove Duplication
DRY violations across codebase
- Copy-pasted logic → Shared functions
- Similar resources → Shared concerns/preparations
- Repeated validation → Custom validations

### Move/Reorganize
Improve module boundaries
- Misplaced functions → Correct modules
- Cross-boundary deps → Cleaner separation
- Umbrella app violations → Respect boundaries

## Workflow

### 1. Context Gathering (mcp-verify-first)
- Run Phase Zero detection
- Identify refactor target and scope
- List affected files/modules/tests
- Check for dependencies on target code

### 2. Safety Analysis (code-reviewer)
- Review existing tests (must pass before refactoring)
- Identify behavior contracts to preserve
- Flag risky changes (public APIs, used by multiple modules)
- Plan refactoring steps with rollback points

### 3. Implementation (domain specialist)
Based on code area:
- **Ash**: ash-resource-architect
- **LiveView/HEEx**: heex-template-expert or frontend-design-enforcer
- **Simple Elixir**: code-review-implement
- **Database**: database-migration-specialist

### 4. Validation (test-builder)
- Run existing tests (must still pass)
- Add new tests if behavior was implicit
- Run full quality gates
- Confirm no behavioral changes

### 5. Documentation (if new patterns)
- Document extracted patterns if reusable
- Update inline docs if signatures changed
- Note any API changes for team

## Quality Gates
**Critical**: All existing tests must pass before AND after
```bash
mix test [affected test files]
mix format
mix credo --strict
mix compile --warnings-as-errors
```

## Success Criteria
- [ ] No behavior changes (tests prove it)
- [ ] Code is more maintainable
- [ ] Duplication reduced or eliminated
- [ ] Patterns modernized where applicable
- [ ] Quality gates pass
- [ ] Git commit shows clear refactor intent

## Notes
- **Tests first**: If no tests exist, write them before refactoring
- **Small steps**: Commit frequently, one refactor at a time
- **Verify constantly**: Run tests after each step
- **Document why**: Commit messages explain the improvement
- For reference, see `.claude/README.md` agent workflows section
