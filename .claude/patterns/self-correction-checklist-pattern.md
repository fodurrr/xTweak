# Self-Correction Checklist Pattern

## Purpose
Standard pattern for agents to verify they've detected project context and replaced placeholders before presenting code or recommendations.

## When to Use
- **MANDATORY** for agents that generate code
- **MANDATORY** for agents that provide examples
- **RECOMMENDED** for all agents as final check before response

## Pattern Template

```markdown
## Self-Correction: Before [Implementing/Presenting/Reviewing] [Code/Design/Tests]

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using the ACTUAL [domain/module/app] name (not "MyApp")?
4. ❓ Did I verify [implementation/patterns/behavior] with MCP tools?
5. ❓ Are my [code/examples/file paths] using detected values?
6. ❓ Have I tested [functionality] with mcp__tidewave__project_eval?

If ANY answer is "No" → STOP and complete Phase 0 first.

**Additional Placeholder Check**:
- ❌ If I see "MyApp" in my [solution/code/recommendations] → STOP, detect actual name
- ❌ If I see "my_app_core" in paths → STOP, detect actual core app name
- ❌ If I haven't run `ls apps/` yet → STOP, detect structure first
- ✅ If all names came from MCP tool outputs → Proceed
```

## Variations by Agent Type

### For Implementation Agents

```markdown
## Self-Correction: Before Implementing ANY Resource

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using the ACTUAL domain module (not "MyApp.Domain")?
4. ❓ Is my resource path using the detected core app name?
5. ❓ Did I verify the pattern with similar existing resources?
6. ❓ Have I tested the domain module with mcp__tidewave__project_eval?

If ANY answer is "No" → STOP and complete Phase 0 first.
```

### For Testing Agents

```markdown
## Self-Correction: Before Writing ANY Test

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using the ACTUAL DataCase module (not "MyApp.DataCase")?
4. ❓ Am I using the ACTUAL domain module in test assertions?
5. ❓ Did I verify the implementation with mcp__tidewave__project_eval first?
6. ❓ Are my test aliases using detected module names?

If ANY answer is "No" → STOP and complete Phase 0 first.
```

### For Review Agents

```markdown
## Self-Correction: Before Presenting Review

Ask yourself:

1. ❓ Did I detect the ACTUAL project structure using Phase 0?
2. ❓ Have I replaced ALL "{YourApp}" placeholders with detected values?
3. ❓ Am I using actual module names from THIS project in recommendations?
4. ❓ Did I verify patterns with MCP tools instead of assuming?
5. ❓ Are my code suggestions using THIS project's domain/module names?

If ANY answer is "No" → STOP and complete Phase 0 first.
```

### For Frontend Agents

```markdown
## Self-Correction: Before Implementing Frontend Code

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL web app module?
2. ❓ Have I replaced ALL `{YourApp}Web` placeholders with detected values?
3. ❓ Am I using the ACTUAL web module name (not "MyAppWeb")?
4. ❓ Did I verify existing LiveView patterns in THIS project?
5. ❓ Are my component paths using the detected web app directory?
6. ❓ Have I tested the web module with mcp__tidewave__project_eval?

If ANY answer is "No" → STOP and complete Phase 0 first.
```

### For Design/Architecture Agents

```markdown
## Self-Correction: Before Finalizing Agent Configuration

Ask yourself:

1. ❓ Did I include Phase 0 for project context detection?
2. ❓ Are ALL examples using `{Placeholder}` syntax instead of literal "MyApp"?
3. ❓ Did I provide both a generic pattern AND a concrete example?
4. ❓ Have I added meta-instructions explaining how to adapt placeholders?
5. ❓ Does the agent have a self-correction checklist?
6. ❓ Will the agent verify actual project structure before implementing?

If ANY answer is "No" → REVISE the agent configuration.
```

## Enhanced Version with Placeholder Detection

For agents that work with code extensively:

```markdown
## Self-Correction: Before [Task]

### Phase 0 Verification
1. ❓ Did I run `ls apps/` to detect umbrella structure?
2. ❓ Did I run `mcp__ash_ai__list_ash_resources` to detect domain?
3. ❓ Did I store detected values for this session?

### Placeholder Replacement Verification
4. ❓ Have I replaced ALL `{YourApp}` with detected project name?
5. ❓ Have I replaced `{YourApp}.Domain` with detected domain module?
6. ❓ Have I replaced `{yourapp}_core` with detected core app name?

### Code Quality Verification
7. ❓ Did I verify implementation with `mcp__tidewave__project_eval`?
8. ❓ Are file paths using detected app names (not "my_app")?
9. ❓ Did I check for compilation errors with `mix compile`?

### Final Check
10. ❓ Can I prove this works with MCP evidence using REAL project modules?

**Placeholder Detection**:
- ❌ If I see "MyApp.Domain" in my solution → STOP, detect actual domain
- ❌ If I see "MyAppWeb" in components → STOP, detect actual web module
- ❌ If I see "my_app_core" in paths → STOP, detect actual core app name
- ❌ If I see generic placeholders unreplaced → STOP, complete detection
- ✅ If all module names came from MCP tool outputs → Proceed

If ANY ❌ condition is true → STOP and fix immediately.
```

## Integration Points

The self-correction checklist should appear:

1. **At the end of agent instructions** - just before "Remember" section
2. **After major implementation steps** - in workflow TodoWrite items
3. **In troubleshooting sections** - when debugging placeholder issues

## Example Placement in Agent

```markdown
[... rest of agent instructions ...]

## Quality Gates

Before completing:
1. Format code: `mix format`
2. Check compilation: `mix compile --warnings-as-errors`
3. Run tests: `mix test`

## Self-Correction: Before Claiming Success

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using the ACTUAL domain module (not "MyApp.Domain")?
4. ❓ Did I verify with MCP tools using detected names?
5. ❓ Have I tested functionality with mcp__tidewave__project_eval?

If ANY answer is "No" → STOP and complete Phase 0 first.

## Remember

- Phase 0 is MANDATORY
- Always use detected values, never "MyApp"
- Verify with MCP tools before claiming success
```

## Common Mistakes Prevented

### Mistake 1: Skipping Verification
```markdown
# WRONG: No self-check before presenting
Here's your User resource:
defmodule MyApp.Domain.User do
  ...
end

# RIGHT: Self-check catches the issue
Before presenting... did I detect project structure? NO!
Let me run Phase 0 first:
ls apps/  # → blog_core
mcp__ash_ai__list_ash_resources  # → Blog.Domain

Here's your User resource:
defmodule Blog.Domain.User do
  ...
end
```

### Mistake 2: Partial Placeholder Replacement
```elixir
# WRONG: Mixed placeholder and detected values
defmodule BlogWeb.{Resource}Live do
  use {YourApp}Web, :live_view

# CAUGHT BY CHECKLIST: ❓ Have I replaced ALL placeholders?
# Answer: NO - still has {Resource} and {YourApp}Web

# RIGHT: Full replacement
defmodule BlogWeb.PostLive do
  use BlogWeb, :live_view
```

### Mistake 3: Assuming Without Verification
```markdown
# WRONG: Assuming module exists
defmodule Blog.Domain.Reputation do
  # ... implementation ...
end

# CAUGHT BY CHECKLIST: ❓ Did I verify with MCP tools?
# Answer: NO

# RIGHT: Verify first
mcp__tidewave__project_eval code: "h Blog.Domain"
# Confirms Blog.Domain exists
# Now safe to implement
```

## Checklist for Adding to New Agents

When adding self-correction to a new agent:
- [ ] Identify critical decision points
- [ ] Tailor questions to agent's specific role
- [ ] Include Phase 0 verification
- [ ] Include placeholder replacement check
- [ ] Include MCP verification check
- [ ] Add placeholder detection section
- [ ] Place before final "Remember" section

## Sources

This pattern is exemplified in:
- `agent-architect.md` (lines 259-270) - comprehensive design checklist
- `code-reviewer.md` (lines 429-438) - review-specific verification
- `ash-resource-architect.md` (lines 764-774) - implementation verification
- `mcp-verify-first.md` (lines 348-365) - enhanced with placeholder checks

## Related Patterns

- `phase-0-detection-pattern.md` - What this checklist verifies was done
- `placeholder-explanation-header.md` - Context for placeholder questions
- `dual-example-pattern.md` - Shows what "correct" looks like after verification
