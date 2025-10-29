---
title: Error Recovery (Haiku)
version: 1.0.0
updated: 2025-10-29
tags:
  - core
  - haiku
  - error-handling
---

# Error Recovery (Haiku)

**Pattern ID**: `error-recovery-haiku`
**Version**: 1.0.0
**Category**: Quality / Error Handling
**Applies To**: Haiku agents only
**Related**: `error-recovery-loop`, `self-check-core`, `mcp-tool-discipline`

---

## Purpose

Provides Haiku agents with structured error detection and escalation guidance. When Haiku encounters complexity beyond its capabilities, it outputs clear escalation recommendations rather than producing low-quality results.

## When to Use

**Required for**:
- All agents with `model: haiku` in frontmatter
- Tasks with bounded scope but potential for complexity spikes
- High-frequency operations where cost optimization matters

**Loaded by**:
- `mcp-verify-first` (Haiku)
- `docs-maintainer` (Haiku)
- `code-review-implement` (Haiku)
- `database-migration-specialist` (Haiku)
- `pattern-librarian` (Haiku)
- `monitoring-setup` (Haiku)

---

## Pattern Definition

### Core Principle

**Fail explicitly, not silently.**

Haiku agents must:
1. Detect when output quality may be compromised
2. Stop and flag for escalation rather than guess
3. Provide actionable escalation guidance
4. Document what was attempted and why it failed

---

## Escalation Triggers

### 1. Compile Errors

**When to trigger**:
- Generated code produces compiler errors or warnings
- Type mismatches, missing imports, syntax errors
- Phoenix/Elixir/Ash compilation failures

**Example**:
```elixir
# Haiku generates:
def create_user(params) do
  User.create(params)  # Missing Ash.create call
end

# Compiler error:
** (CompileError) undefined function create/1
```

**Escalation needed**: YES - Requires understanding of Ash API patterns

### 2. Test Failures

**When to trigger**:
- Generated tests don't compile
- Tests fail when they should pass
- Test logic doesn't match component behavior

**Example**:
```elixir
# Haiku generates:
test "creates newsletter subscription" do
  assert {:ok, sub} = Newsletter.subscribe("test@example.com")
end

# Test fails:
** (FunctionClauseError) no function clause matching in Newsletter.subscribe/1
```

**Escalation needed**: YES - Requires understanding of subscription flow

### 3. MCP Tool Failures

**When to trigger**:
- MCP server returns error responses
- Timeout waiting for MCP tool
- Incomplete or malformed MCP data
- Cannot verify context with MCP tools

**Example**:
```
mcp__tidewave__project_eval → Timeout after 30s
mcp__ash_ai__list_resources → Empty list (expected resources)
```

**Escalation needed**: YES - Requires MCP debugging expertise

### 4. Pattern Violations

**When to trigger**:
- Output doesn't follow required patterns from pattern-stack
- Missing `phase-zero-context` detection
- Placeholders like `{YourApp}` remain in output
- No MCP evidence cited

**Example**:
```elixir
# Haiku generates:
defmodule {YourApp}Web.NewsletterLive do
  use Phoenix.LiveView
  ...
end
```

**Escalation needed**: YES - Missed placeholder replacement

### 5. Uncertainty or Ambiguity

**When to trigger**:
- Multiple valid approaches exist, unclear which to choose
- Business logic requires interpretation
- Architectural decisions needed
- User requirements are ambiguous

**Example**:
User: "Add newsletter feature"
Haiku: "Should this be a separate resource or embedded in User? Requires domain modeling decision."

**Escalation needed**: YES - Requires architectural judgment

---

## Escalation Output Format

When escalation trigger detected, Haiku agent outputs:

```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: [Compile Error | Test Failure | MCP Error | Pattern Violation | Uncertainty]

**Details**:
[Specific error message, stack trace, or description of the issue]

**What I Attempted**:
[Brief summary of the approach taken]

**Why Escalation Needed**:
[Explanation of what's beyond Haiku's current capabilities]

**Suggested Action**:
Re-run this task with Sonnet model for enhanced analysis.

**How to Escalate**:
Invoke the same agent with Sonnet (agents default to Sonnet unless explicitly set to Haiku):
- Read agent file and temporarily change `model: haiku` to `model: sonnet`
- Or use Codex CLI with Sonnet provider
- Rerun with same prompt

**Context for Sonnet**:
[Any relevant context, partial work, or insights from Haiku's attempt]
```

---

## Implementation Guidance

### For Agent Prompts

Add this section to all Haiku agent definitions:

```markdown
## Error Recovery Protocol

This agent uses Haiku for cost-effective execution. If you encounter:

1. **Compile Errors** → Output escalation message
2. **Test Failures** → Output escalation message
3. **MCP Errors** → Retry once, then escalate if persists
4. **Pattern Violations** → Self-correct if possible, escalate if uncertain
5. **Uncertainty** → Don't guess, output escalation message

**Before outputting escalation**:
- [ ] Attempted reasonable fix/workaround?
- [ ] Documented what was tried?
- [ ] Provided context for Sonnet?
- [ ] Specified exact escalation steps?
```

### Self-Check Integration

Add to self-check-core checklist for Haiku agents:

```markdown
## Haiku-Specific Checks

- [ ] Did I encounter any escalation triggers?
- [ ] If yes, did I output proper escalation message?
- [ ] If no errors, is my output high-quality enough?
- [ ] Am I uncertain about any aspect? (escalate if yes)
```

---

## Example Scenarios

### Scenario 1: Compile Error (Correct Handling)

**Task**: Implement `Newsletter.subscribe/1` function

**Haiku Attempt**:
```elixir
defmodule XTweak.Core.Newsletter do
  def subscribe(email) do
    %Subscription{email: email}
    |> Repo.insert()
  end
end
```

**Compile Error**:
```
** (CompileError) undefined module Repo
```

**Haiku Output**:
```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: Compile Error

**Details**:
Generated code produces compile error: `undefined module Repo`

**What I Attempted**:
Created `Newsletter.subscribe/1` using direct Repo.insert call.

**Why Escalation Needed**:
This project uses Ash Framework, not direct Ecto Repo. Requires understanding of Ash.create patterns and proper resource definition.

**Suggested Action**:
Re-run with Sonnet to properly implement Ash resource pattern.

**How to Escalate**:
1. Temporarily change this agent's model to Sonnet
2. Rerun with prompt: "Implement Newsletter.subscribe/1 using Ash Framework patterns"

**Context for Sonnet**:
Project uses Ash 3.7.6+. Resources defined in `apps/xtweak_core/lib/xtweak/core/`.
```

✅ **Correct**: Detected error, provided context, clear escalation path.

### Scenario 2: Pattern Violation (Correct Handling)

**Task**: Create LiveView component for newsletter signup

**Haiku Attempt**:
```elixir
defmodule {YourApp}Web.NewsletterLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <form phx-submit="subscribe">
      <input type="email" name="email" />
    </form>
    """
  end
end
```

**Self-Check Result**:
- ❌ Placeholders remain (`{YourApp}`)
- ❌ Phase-zero-context not applied

**Haiku Output**:
```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: Pattern Violation

**Details**:
Output contains placeholder `{YourApp}` instead of detected project name.

**What I Attempted**:
Created LiveView component but failed to apply phase-zero-context pattern.

**Why Escalation Needed**:
Placeholder detection and replacement requires careful project structure analysis. Haiku missed this during generation.

**Suggested Action**:
Re-run with Sonnet to ensure proper placeholder resolution.

**How to Escalate**:
Change model to Sonnet and rerun with same prompt.

**Context for Sonnet**:
Detected project structure: XTweak (web app: xtweak_web, core: xtweak_core)
```

✅ **Correct**: Caught pattern violation in self-check, escalated.

### Scenario 3: Successful Completion (No Escalation)

**Task**: Update CHANGELOG.md with new feature entry

**Haiku Output**:
```markdown
# Changelog

## [Unreleased]

### Added
- Newsletter subscription feature with email validation

## [1.0.0] - 2025-10-15
...
```

**Self-Check**:
- ✅ No compile errors (markdown)
- ✅ No placeholders
- ✅ Follows changelog format
- ✅ Clear, concise entry

✅ **Correct**: No escalation needed, high-quality output.

---

## Anti-Patterns

### ❌ Wrong: Silent Failure

**Bad**:
```elixir
# Haiku knows this might be wrong but outputs anyway:
def subscribe(email) do
  {:ok, email}  # This doesn't actually save anything
end
```

**Why Wrong**: Produces incorrect code that may pass initial inspection but fails in production.

**Fix**: Escalate when uncertain about implementation correctness.

### ❌ Wrong: Vague Escalation

**Bad**:
```markdown
⚠️ This might need Sonnet.

I'm not sure if this is correct. Maybe try Sonnet?
```

**Why Wrong**: Doesn't specify error type, no context, unclear escalation steps.

**Fix**: Use structured escalation format with all required fields.

### ❌ Wrong: Over-Escalation

**Bad**:
```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: Uncertainty

**Details**: Not 100% confident in variable naming choices.
```

**Why Wrong**: Minor stylistic concerns don't warrant escalation.

**Fix**: Reserve escalation for functional/correctness issues, not style preferences.

---

## Integration with Other Patterns

### With `error-recovery-loop`

Haiku agents should still attempt recovery before escalating:

```
1. Attempt initial implementation
2. Detect error (compile, test, MCP)
3. Attempt reasonable fix (e.g., add missing import)
4. If fix unsuccessful → Escalate
5. If fix successful → Continue
```

**Balance**: Try fixing obvious issues (missing import) but escalate for deeper problems (wrong Ash pattern).

### With `self-check-core`

Add escalation check to self-check:

```markdown
## Self-Check (Haiku Agent)

Before completing:
- [ ] Phase-zero-context applied?
- [ ] MCP evidence gathered?
- [ ] Placeholders replaced?
- [ ] Quality gates documented?
- [ ] **Any escalation triggers detected?** ← Haiku-specific
- [ ] If escalation needed, proper message formatted?
```

### With `mcp-tool-discipline`

MCP failures are common escalation triggers:

```markdown
1. Attempt MCP tool call
2. If timeout/error → Retry once
3. If retry fails → Escalate (MCP expertise needed)
4. Document MCP issue in escalation message
```

---

## Pattern Adoption Checklist

For converting existing Sonnet agent to Haiku:

- [ ] Change frontmatter: `model: sonnet` → `model: haiku`
- [ ] Add `error-recovery-haiku` to pattern-stack
- [ ] Add "Error Recovery Protocol" section to agent prompt
- [ ] Update self-check to include escalation trigger check
- [ ] Test with 10 typical scenarios
- [ ] Verify escalation rate <10%
- [ ] Document in MODEL_SELECTION_STRATEGY.md
- [ ] Note in CHANGELOG.md

---

## Monitoring & Tuning

### Track Escalation Rates

**Weekly**:
- Count Haiku executions with escalation output
- Calculate rate: `(escalations / total executions) * 100`
- Target: <10%

**If >15% escalation rate**:
- Review common escalation types
- Update agent prompt to handle edge cases
- Consider moving agent back to Sonnet

### Improve Over Time

**Monthly**:
- Review escalation messages from all Haiku agents
- Identify patterns in failures
- Update agent prompts with additional guidance
- Add common pitfalls to agent docs
- Update this pattern with new scenarios

---

## Version History

- **v1.0.0** (2025-10-29) - Initial Haiku error recovery pattern with 5 escalation triggers
