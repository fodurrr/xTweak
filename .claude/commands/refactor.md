---
description: Code health improvements - extract logic, reduce duplication, modernize patterns without changing behavior
---

# Refactor Command

You are the **code refactoring coordinator** using specialized agents for systematic code quality improvements.

## Your Task

Improve code quality, structure, or maintainability **without changing external behavior**. This command handles extraction, deduplication, modernization, and reorganization work that doesn't fit into PRD feature sprints.

## Input Format

```
/refactor [operation] [target] [--scope=file|module|app] [--to=destination]
```

**Examples**:
- `/refactor extract-ash-preparation apps/xtweak_core/lib/xtweak/core/user.ex`
- `/refactor modernize-heex apps/xtweak_web/lib/xtweak_web_web/live/`
- `/refactor move-module XTweak.Core.Email --to=xtweak_ui`
- `/refactor simplify-conditionals apps/xtweak_web/lib/xtweak_web_web/live/dashboard_live.ex`
- `/refactor remove-duplication apps/xtweak_core/lib/xtweak/core/`

## Responsible Agents

### Primary Agents
- **mcp-verify-first** (Haiku) - Context gathering, impact analysis
- **code-reviewer** (Sonnet) - Refactoring strategy, safety analysis
- **test-builder** (Sonnet) - Ensure behavior unchanged via tests

### Domain Specialists (for implementation)
- **ash-resource-architect** (Sonnet) - Ash resource/action/policy refactoring
- **heex-template-expert** (Sonnet) - LiveView/HEEx template improvements
- **code-review-implement** (Haiku) - Simple Elixir refactoring
- **frontend-design-enforcer** (Sonnet) - LiveView component extraction
- **database-migration-specialist** (Haiku) - Schema reorganization

### Support
- **pattern-librarian** (Haiku) - Document new patterns discovered

## Common Refactoring Operations

### 1. Extract Function/Module/Preparation
**Goal**: Pull out duplicated or complex logic into reusable unit

**Use when**:
- Same logic appears 3+ times
- Function is too long (>50 lines)
- Ash action has complex validation logic

**Example**: Extract repeated validation into Ash preparation

### 2. Simplify Conditionals
**Goal**: Reduce nested if/case/cond complexity

**Use when**:
- Cyclomatic complexity > 10
- Nested conditionals 3+ levels deep
- Pattern matching can replace if/else chains

**Example**: Replace nested if with pattern matching

### 3. Modernize Patterns
**Goal**: Update code to use newer framework idioms

**Use when**:
- Using deprecated APIs
- Old Phoenix/Ash patterns (pre-LiveView, pre-3.0)
- Can leverage new framework features

**Example**: Modernize Phoenix templates to HEEx

### 4. Remove Duplication
**Goal**: DRY up repeated code across modules

**Use when**:
- Copy-paste code detected
- Similar logic in multiple resources
- Shared behavior not abstracted

**Example**: Create shared Ash preparation for common validations

### 5. Move Module
**Goal**: Reorganize code across umbrella apps

**Use when**:
- Module in wrong app (boundary violation)
- Circular dependencies detected
- Better cohesion needed

**Example**: Move UI components from web app to ui app

## Workflow Steps

### Step 1: Context Gathering & Impact Analysis
**Agent**: `mcp-verify-first` (Haiku)

**Actions**:
1. Read target file(s) to understand current structure
2. Identify code smells using MCP tools:
   - Duplication: grep for similar patterns
   - Complexity: count conditional nesting
   - Dependencies: what calls this? what does it call?
3. Check test coverage:
   ```elixir
   # Use MCP to run with coverage
   mcp__tidewave__project_eval("
     Mix.Task.run(\"test\", [\"--cover\", \"#{target_file}\"])
   ")
   ```
4. Assess refactoring safety:
   - High test coverage (>80%) = safe
   - Low coverage (<50%) = risky, add tests first
   - No tests = add tests BEFORE refactoring

**Output**:
- List of code smells found
- Current test coverage %
- Dependency map (callers & callees)
- Safety assessment (safe/risky/needs-tests)

### Step 2: Refactoring Strategy
**Agent**: `code-reviewer` (Sonnet)

**Actions**:
1. Propose refactoring approach with before/after examples
2. Identify risks and mitigation strategies
3. Break down into smallest safe steps
4. Suggest any tests needed before refactoring

**Example Strategy**:
```markdown
## Proposed Refactoring

**Operation**: Extract Ash preparation from User resource

**Before**:
```elixir
# apps/xtweak_core/lib/xtweak/core/user.ex
action :create do
  validate fn changeset, _context ->
    email = Ash.Changeset.get_attribute(changeset, :email)
    if String.contains?(email, "@") do
      :ok
    else
      {:error, "Invalid email"}
    end
  end
end

action :update do
  # Same validation duplicated here!
  validate fn changeset, _context ->
    email = Ash.Changeset.get_attribute(changeset, :email)
    if String.contains?(email, "@") do
      :ok
    else
      {:error, "Invalid email"}
    end
  end
end
```

**After**:
```elixir
# apps/xtweak_core/lib/xtweak/core/preparations/validate_email.ex
defmodule XTweak.Core.Preparations.ValidateEmail do
  use Ash.Resource.Preparation

  def prepare(query, _, _) do
    Ash.Query.after_action(query, fn query, results ->
      # Validation logic extracted and reusable
      {:ok, results}
    end)
  end
end

# apps/xtweak_core/lib/xtweak/core/user.ex
action :create do
  prepare XTweak.Core.Preparations.ValidateEmail
end

action :update do
  prepare XTweak.Core.Preparations.ValidateEmail
end
```

**Risks**:
- Preparation behavior different from inline validation
- Need to ensure error messages match

**Mitigation**:
1. Add tests for ValidateEmail preparation first
2. Keep inline validation until tests pass
3. Replace one action at a time
4. Run full test suite after each step

**Steps**:
1. Create ValidateEmail preparation module
2. Add comprehensive tests
3. Update :create action to use preparation
4. Verify tests still pass
5. Update :update action to use preparation
6. Remove old inline validations
```

**Output**: Detailed refactoring plan with risks and steps

### Step 3: Implementation
**Agent**: Domain specialist (Sonnet) or `code-review-implement` (Haiku) for simple cases

**Selection Logic**:
```elixir
case refactoring_type do
  :ash_extraction | :ash_simplification -> "ash-resource-architect"
  :heex_modernization | :component_extraction -> "heex-template-expert"
  :liveview_refactor -> "frontend-design-enforcer"
  :module_move -> "code-review-implement" (+ manual file moves)
  :simple_elixir -> "code-review-implement"
end
```

**Actions**:
1. Follow strategy from Step 2 **exactly**
2. Make changes incrementally (one step at a time)
3. Run tests after each step:
   ```bash
   mix format
   mix test [relevant_test_file]
   ```
4. If any test fails, **stop immediately** and investigate
5. Document each change with inline comments if complex

**Output**: Refactored code with unchanged external behavior

### Step 4: Validation & Regression Prevention
**Agent**: `test-builder` (Sonnet) + `code-reviewer` (Sonnet)

**Actions by test-builder**:
1. Ensure test coverage maintained or improved
2. Add regression tests for any edge cases discovered
3. Run full test suite:
   ```bash
   mix test
   ```
4. Check code metrics improved:
   - Cyclomatic complexity decreased
   - Duplication reduced
   - Lines of code per function lower

**Actions by code-reviewer**:
1. Verify refactoring goals achieved:
   - Duplication removed? (grep for patterns)
   - Complexity reduced? (count conditionals)
   - Structure improved? (module boundaries clearer)
2. Check no behavior changes:
   - All tests pass
   - No new warnings
   - Performance not degraded
3. Run quality gates:
   ```bash
   mix format --check-formatted
   mix credo --strict
   mix compile --warnings-as-errors
   mix dialyzer  # If time permits
   ```

**Output**: Confirmation that refactoring is safe and successful

## Output Format

Create a todo list tracking each step, then provide this summary:

```markdown
## Refactoring Complete

🔧 **Operation**: [refactoring type]
📁 **Target**: [file/module/app]

✅ **Analysis** (mcp-verify-first)
  - Code smells found: [count] [list]
  - Test coverage: [%] (before) → [%] (after)
  - Dependencies: [count callers], [count callees]
  - Safety: [safe/risky/needs-tests]

✅ **Strategy** (code-reviewer)
  - Approach: [brief description]
  - Steps: [count]
  - Risks identified: [count]
  - Mitigations applied: [list]

✅ **Implementation** ([domain-agent])
  - Files modified: [count]
    - [file1] ([lines changed])
    - [file2] ([lines changed])
  - Files created: [count]
    - [file1]
  - Complexity reduced: [metric before] → [metric after]
  - Duplication removed: [lines eliminated]

✅ **Validation** (test-builder + code-reviewer)
  - Tests: ✅ [passed]/[total] passing
  - Coverage: [%] (maintained/improved)
  - Regression tests added: [count]
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass ([improvement note])
    - Compile: ✅ Pass (no warnings)
    - Dialyzer: ✅ Pass (if run)

📊 **Metrics**:
  - Cyclomatic complexity: [before] → [after]
  - Lines of code: [before] → [after]
  - Duplicate code: [before] → [after]

📝 **Suggested Commit Message**:
```
refactor: [concise description of what was refactored]

- [specific improvement made]
- [measurable benefit - e.g., reduced duplication by X lines]
- [any API changes or migration notes]

Improved code quality metrics:
- Complexity: [before] → [after]
- Test coverage: [before]% → [after]%

🤖 Generated with Claude Code
```
```

## Example Output

```markdown
## Refactoring Complete

🔧 **Operation**: Extract Ash preparation
📁 **Target**: apps/xtweak_core/lib/xtweak/core/user.ex

✅ **Analysis** (mcp-verify-first)
  - Code smells found: 2 (duplication, complexity)
  - Test coverage: 78% (before) → 85% (after)
  - Dependencies: 3 callers (controllers), 0 callees
  - Safety: Safe (high test coverage)

✅ **Strategy** (code-reviewer)
  - Approach: Extract duplicated email validation into reusable preparation
  - Steps: 5
  - Risks identified: 1 (preparation behavior differs from inline validation)
  - Mitigations applied: Added tests first, incremental migration

✅ **Implementation** (ash-resource-architect)
  - Files modified: 2
    - apps/xtweak_core/lib/xtweak/core/user.ex (12 lines removed)
    - apps/xtweak_core/lib/xtweak/core/newsletter.ex (8 lines removed)
  - Files created: 2
    - apps/xtweak_core/lib/xtweak/core/preparations/validate_email.ex
    - test/xtweak/core/preparations/validate_email_test.exs
  - Complexity reduced: CCN 8 → CCN 3
  - Duplication removed: 20 lines

✅ **Validation** (test-builder + code-reviewer)
  - Tests: ✅ 56/56 passing
  - Coverage: 85% (improved from 78%)
  - Regression tests added: 4 (edge cases for email validation)
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass (removed 1 duplication warning)
    - Compile: ✅ Pass (no warnings)
    - Dialyzer: ✅ Pass

📊 **Metrics**:
  - Cyclomatic complexity: 8 → 3 (User resource)
  - Lines of code: 145 → 125 (User resource)
  - Duplicate code: 20 lines → 0 lines

📝 **Suggested Commit Message**:
```
refactor: extract email validation into reusable Ash preparation

- Created ValidateEmail preparation module
- Removed 20 lines of duplicated validation logic
- Applied to User and Newsletter resources
- Improved test coverage from 78% to 85%

Improved code quality metrics:
- Complexity: 8 → 3 (CCN)
- Duplication: 20 lines eliminated

🤖 Generated with Claude Code
```
```

## Quality Checks

- [ ] Analysis identified specific code smells
- [ ] Strategy proposed with before/after examples
- [ ] Implementation followed strategy exactly
- [ ] **NO behavior changes** (all tests pass)
- [ ] Test coverage maintained or improved
- [ ] Metrics improved (complexity, duplication, LOC)
- [ ] Quality gates pass (format, credo, compile)
- [ ] Commit message documents improvements

## Special Cases

### Low Test Coverage
If target has <50% test coverage:
1. **STOP refactoring immediately**
2. Use `/fix-bug` or manual workflow to add tests first
3. Get coverage >70% before refactoring
4. Resume refactoring with confidence

### Breaking API Changes
If refactoring requires changing public APIs:
1. Alert Peter immediately
2. Consider deprecation path instead
3. Document migration in CHANGELOG.md
4. May need to become a PRD task instead

### Performance Impact
If refactoring may affect performance:
1. Benchmark before/after using `:timer.tc/1`
2. Run with MCP: `mcp__tidewave__project_eval`
3. Document performance change in commit
4. If degraded, revert and try different approach

### Large Scope
If refactoring touches >10 files:
1. Break into smaller refactorings
2. Each should be independently committable
3. Consider creating refactoring checklist as PRD task
4. Coordinate with Peter on approach

## Integration with PRD Workflow

**When to use `/refactor` instead of `/prd-implement`**:
- ✅ Improving code quality (no new features)
- ✅ Reducing technical debt
- ✅ Modernizing old patterns
- ✅ Reorganizing structure
- ✅ Preparing codebase for future PRD features

**When to create PRD task instead**:
- ❌ Refactoring requires architectural changes
- ❌ Multiple refactorings needed (batch as sprint)
- ❌ Refactoring enables future features (plan together)
- ❌ Large scope (>20 files, >1 day)

**After refactoring**:
- Update usage-rules/ if new patterns established
- Document in CHANGELOG.md if public API changed
- Consider if pattern should be added to .claude/patterns/

## Remember

**MANDATORY_AI_RULES.md applies**:
- Never commit without Peter's permission
- Run all quality gates
- Use MCP tools for verification
- Document decisions clearly

**Pattern Stack** (load these patterns):
- `placeholder-basics@1.0.0`
- `phase-zero-context@1.0.0`
- `mcp-tool-discipline@1.0.0`
- `self-check-core@1.1.0`
- `dual-example-bridge@1.0.0`
- `collaboration-handoff@1.0.0`

**Golden Rule of Refactoring**:
> "Refactoring changes the structure of code without changing its behavior. If tests fail after refactoring, **you broke something** - revert and try again."

**Cost optimization**:
- Use Haiku for simple refactorings (rename, extract function)
- Use Sonnet for complex refactorings (extract module, architectural)
- Always use Sonnet for strategy phase (safety critical)
