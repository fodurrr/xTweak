---
description: Emergency bug fixes, production hotfixes, and critical issues outside normal sprint workflow
---

# Fix Bug Command

You are the **emergency bug fix coordinator** using specialized agents for rapid issue resolution.

## Your Task

Fix a critical bug, production issue, or urgent problem that cannot wait for sprint planning. This command provides a systematic TDD approach: reproduce, analyze, fix, verify.

## Input Format

```
/fix-bug "description of the issue"
```

**Examples**:
- `/fix-bug "emoji crashes search LiveView"`
- `/fix-bug "N+1 queries in dashboard loading all users"`
- `/fix-bug "Auth timeout too short for mobile networks"`
- `/fix-bug "Credo violations after upgrading to 1.7.10"`

## Responsible Agents

### Primary Agents
- **test-builder** (Sonnet) - Creates failing reproduction test, adds regression tests
- **code-review-implement** (Haiku) - Applies minimal fix for straightforward bugs
- **code-reviewer** (Sonnet) - Verifies fix resolves issue without side effects

### Domain Specialists (escalate when needed)
- **ash-resource-architect** (Sonnet) - For Ash query/policy/action bugs
- **frontend-design-enforcer** (Sonnet) - For LiveView/HEEx rendering bugs
- **beam-runtime-specialist** (Sonnet) - For BEAM/OTP/concurrency bugs
- **database-migration-specialist** (Haiku) - For Postgres/migration issues

### Support
- **mcp-verify-first** (Haiku) - Context gathering if bug unclear

## Workflow Steps

### Step 1: Context Gathering (if needed)
**When**: Bug description is vague or location unknown
**Agent**: `mcp-verify-first` (Haiku)

**Actions**:
- Search codebase for likely bug location
- Identify affected modules/resources
- Check recent git history for related changes
- Gather error logs via MCP (`mcp__tidewave__get_logs`)

**Output**: Clear understanding of where bug likely exists

### Step 2: Reproduce Issue
**Agent**: `test-builder` (Sonnet)

**Actions**:
1. Create failing test that reproduces the bug
   - For LiveView: integration test in `test/*_web/live/`
   - For Ash resources: unit test in `test/xtweak/core/`
   - For general Elixir: appropriate test file
2. Document expected vs actual behavior
3. Run test to confirm it fails
4. Identify exact error message/stack trace

**Output**: Failing test that will pass when bug is fixed

### Step 3: Root Cause Analysis
**Agent**: Domain specialist (Sonnet) based on bug type

**Selection Logic**:
```elixir
case bug_domain do
  :ash_query | :ash_policy | :ash_action -> "ash-resource-architect"
  :liveview | :heex | :phoenix -> "frontend-design-enforcer"
  :beam | :genserver | :supervisor -> "beam-runtime-specialist"
  :postgres | :migration | :ecto -> "database-migration-specialist"
  _ -> "code-reviewer"  # General Elixir bugs
end
```

**Actions**:
1. Read failing test
2. Examine affected code paths
3. Use MCP tools to verify behavior:
   - `mcp__tidewave__project_eval` - Test code in REPL
   - `mcp__tidewave__get_docs` - Check API documentation
   - `mcp__ash_ai__list_ash_resources` - For Ash bugs
4. Pinpoint exact root cause with evidence

**Output**: Clear diagnosis with evidence (line numbers, function calls, data flow)

### Step 4: Implement Fix
**Agent**: `code-review-implement` (Haiku) for simple fixes, domain specialist (Sonnet) for complex

**Escalation criteria** (use Sonnet specialist):
- Fix requires understanding framework internals
- Multiple files need changes
- Performance or security implications
- Architectural decision needed

**Actions**:
1. Apply **minimal** fix (no scope creep!)
2. Ensure reproduction test now passes
3. Add regression test with edge cases
4. Run `mix format`

**Output**: Code changes that make test pass

### Step 5: Verification
**Agent**: `code-reviewer` (Sonnet)

**Actions**:
1. Verify fix resolves original issue
2. Check for unintended side effects:
   - Run full test suite
   - Check related functionality still works
   - Verify no new warnings introduced
3. Run quality gates:
   ```bash
   mix format --check-formatted
   mix credo --strict
   mix compile --warnings-as-errors
   mix test
   ```

**Output**: Confirmation that fix is safe and complete

## Output Format

Create a todo list tracking each step, then provide this summary:

```markdown
## Bug Fix Complete

🐛 **Issue**: [description]

✅ **Reproduction** (test-builder)
  - Created failing test: [path]
  - Confirmed failure: [error message]

✅ **Root Cause** ([domain-agent])
  - Location: [file:line]
  - Problem: [what was wrong]
  - Evidence: [how we verified this]

✅ **Fix** ([implementation-agent])
  - Applied fix: [what changed]
  - Modified files:
    - [file1]
    - [file2]

✅ **Verification** (code-reviewer)
  - Original test: ✅ Now passing
  - Regression tests: ✅ [count] added
  - Full suite: ✅ [passed]/[total] passing
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass
    - Compile: ✅ Pass (no warnings)

📝 **Suggested Commit Message**:
```
fix: [concise description of what was broken]

- [specific change made]
- [why this fixes the issue]
- Added [count] regression tests

[Optional: reference to issue/ticket]

🤖 Generated with Claude Code
```
```

## Example Output

```markdown
## Bug Fix Complete

🐛 **Issue**: Emoji crashes search LiveView

✅ **Reproduction** (test-builder)
  - Created failing test: test/xtweak_web_web/live/search_live_test.exs:45
  - Confirmed crash with input "🔍 search term"

✅ **Root Cause** (frontend-design-enforcer)
  - Location: apps/xtweak_core/lib/xtweak/core/search.ex:23
  - Problem: Regex ~r/^[a-zA-Z0-9\s]+$/ doesn't handle Unicode
  - Evidence: LiveView crashes with ArgumentError when validate_query/1 receives emoji

✅ **Fix** (code-review-implement)
  - Applied fix: Updated regex to ~r/^[\p{L}\p{N}\p{P}\p{S}\s]+$/u
  - Modified files:
    - apps/xtweak_core/lib/xtweak/core/search.ex

✅ **Verification** (code-reviewer)
  - Original test: ✅ Now passing
  - Regression tests: ✅ 3 added (emoji, zalgo text, mixed scripts)
  - Full suite: ✅ 159/159 passing
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass
    - Compile: ✅ Pass (no warnings)

📝 **Suggested Commit Message**:
```
fix: support Unicode emoji in search queries

- Updated validation regex to allow Unicode emoji and symbols
- Prevents LiveView crash when users enter non-ASCII search
- Added test coverage for emoji, mixed scripts, special characters

Fixes production crash reported by support team.

🤖 Generated with Claude Code
```
```

## Quality Checks

- [ ] Reproduction test created and fails initially
- [ ] Root cause identified with specific evidence
- [ ] Fix is **minimal** (only what's needed, no extras)
- [ ] Regression tests added (at least 1)
- [ ] Full test suite passes
- [ ] No new warnings (compile, credo)
- [ ] Code formatted (mix format)
- [ ] Commit message follows convention (fix: ...)

## Special Cases

### Hot fix for Production
If this is a production emergency:
1. After fix is verified, ask Peter if immediate deploy needed
2. Suggest creating follow-up PRD task for permanent solution if fix is temporary
3. Document workaround in commit message if architectural fix needed later

### No Clear Reproduction
If bug is intermittent or hard to reproduce:
1. Use `test-builder` to create best-effort test
2. Document reproduction steps in test comments
3. Consider using property-based testing (StreamData) if applicable
4. Mark test as `@tag :flaky` if cannot reliably reproduce

### Breaking Change Required
If fix requires breaking API changes:
1. Alert Peter immediately
2. Propose deprecation path instead of immediate break
3. Consider creating `/refactor` task for proper solution
4. Document migration path in commit message

## Integration with PRD Workflow

**When to use `/fix-bug` instead of `/prd-implement`**:
- ✅ Production is broken NOW
- ✅ Security vulnerability discovered
- ✅ Can't wait for next sprint planning
- ✅ Single focused issue, not a feature

**When to use `/prd-implement` instead**:
- ❌ Feature request disguised as bug
- ❌ Enhancement or improvement (not broken)
- ❌ Can wait for sprint planning
- ❌ Requires multiple subsystems (use sprint)

**After fixing the bug**:
- Consider if root cause indicates larger issue
- If yes: Create PRD task for systematic fix
- Document in REPORTS.md if bug revealed technical debt

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
- `error-recovery-loop@1.0.0`

**Cost optimization**:
- Use Haiku for simple fixes (typos, obvious logic errors)
- Use Sonnet for complex debugging (race conditions, framework internals)
- Escalate to domain specialists when general approach unclear
