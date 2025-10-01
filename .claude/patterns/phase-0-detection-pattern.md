# Phase 0: Project Context Detection Pattern

## Purpose
Standard pattern for detecting actual project structure before implementing any code, tests, or designs.

## When to Use
- **MANDATORY** for any agent that generates code
- **MANDATORY** for agents that provide code examples
- **MANDATORY** before writing tests
- **MANDATORY** before reviewing code with specific recommendations

## Pattern Template

```markdown
## Phase 0: Detect Project Context (MANDATORY FIRST STEP)

Before [implementing/reviewing/testing/designing] ANY [code/resource/feature]:

1. **Detect Umbrella Structure**:
   ```bash
   ls apps/
   # Example output: blog_core, blog_web OR xtweak_core, xtweak_web
   # Store: {detected_core_app}, {detected_web_app}
   ```

2. **Identify Domain Module Pattern**:
   ```
   mcp__ash_ai__list_ash_resources
   # Look for: Blog.Domain vs XTweak.Core vs Shop.Domain
   # Store: {detected_domain}
   ```

3. **Verify Module Exists** (using detected values):
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}"
   # Example: h Blog.Domain or h XTweak.Core
   # Use ACTUAL detected module name, not "MyApp.Domain"
   ```

4. **[Optional] Check Specific Resources/Features**:
   ```
   mcp__tidewave__project_eval code: "{DetectedDomain}.User.__ash_config__(:actions)"
   # Verify specific implementation details
   ```

5. **Store Context for Session**:
   - Core app: `{detected_core_app}` (e.g., blog_core, xtweak_core)
   - Web app: `{detected_web_app}` (e.g., blog_web, xtweak_web)
   - Domain: `{detected_domain}` (e.g., Blog.Domain, XTweak.Core)
   - Use these values in ALL [implementations/examples/tests/recommendations]
```

## Key Principles

1. **Always run BEFORE any implementation**
2. **Store detected values** for use throughout the session
3. **Verify with MCP tools** - don't assume module structure
4. **Use detected values** in ALL subsequent code/examples
5. **Never proceed** if detection fails - ask for clarification

## Examples by Agent Type

### For Implementation Agents (ash-resource-architect, frontend-design-enforcer)

```markdown
### Phase 0: Detect Project Context & Research (MANDATORY FIRST STEP)

Before designing ANY resource, detect the actual project structure:

1. **Detect Umbrella App Names**:
   ```bash
   ls apps/
   # Example output: blog_core, blog_web OR xtweak_core, xtweak_web
   # Store: {detected_core_app}, {detected_web_app}
   ```

2. **List Existing Resources & Detect Domain Pattern**:
   ```
   mcp__ash_ai__list_ash_resources
   # Look for: Blog.Domain vs XTweak.Core vs Shop.Domain
   # Store: {detected_domain}
   ```

3. **Verify Domain Module**:
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}"
   # Use ACTUAL detected domain, not "MyApp.Domain"
   ```

4. **Check for Generators**:
   ```
   mcp__ash_ai__list_generators
   ```

5. **Read Similar Existing Resources** (using detected paths):
   ```
   # Use actual detected core app name:
   Read: apps/{detected_core_app}/lib/{path}/domain/user.ex
   ```

6. **Store Context for This Session**:
   - Core app: `{detected_core_app}`
   - Domain module: `{detected_domain}`
   - Use these values in ALL examples and implementations
```

### For Testing Agents (test-builder)

```markdown
### Phase 0: Detect Project Context & Verify Implementation (MANDATORY)

Before writing ANY test, detect the actual project structure:

1. **Detect Core App Name**:
   ```bash
   ls apps/
   # Example output: blog_core, xtweak_core
   # Store: {detected_core_app}
   ```

2. **List Resources & Detect Domain**:
   ```
   mcp__ash_ai__list_ash_resources
   # Look for: Blog.Domain vs XTweak.Core
   # Store: {detected_domain}
   ```

3. **Verify Module Exists** (using detected values):
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}.User"
   # Example: h Blog.Domain.User or h XTweak.Core.User
   ```

4. **List Available Actions**:
   ```
   mcp__tidewave__project_eval code: "{DetectedDomain}.User.__ash_config__(:actions) |> Enum.map(& &1.name)"
   ```

5. **Test Actual Behavior**:
   ```
   mcp__tidewave__project_eval code: "{DetectedDomain}.create({DetectedDomain}.User, %{email: \"test@example.com\"})"
   ```

6. **Store Context for Session**:
   - Core app: `{detected_core_app}`
   - Domain: `{detected_domain}`
   - Test case module: `{detected_domain}.DataCase`
   - Use these values in ALL tests
```

### For Review Agents (code-reviewer)

```markdown
### Phase 0: Detect Project Context & Verify Patterns (MANDATORY)

Before analyzing ANY file, detect the actual project structure:

1. **Detect Umbrella App Names**:
   ```bash
   ls apps/
   # Example output: blog_core, blog_web OR xtweak_core, xtweak_web
   # Store: {detected_core_app}, {detected_web_app}
   ```

2. **Identify Domain Module Pattern**:
   ```
   mcp__ash_ai__list_ash_resources
   # Look for pattern: Blog.Domain vs XTweak.Core vs Shop.Domain
   # Store: {detected_domain}
   ```

3. **Verify Module Naming**:
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}.User"
   # Use ACTUAL detected module names, not "MyApp"
   ```

4. **Get Current Ash Best Practices**:
   ```
   mcp__ash_ai__get_usage_rules
   ```

5. **Store Context for Session**:
   - Core app: `{detected_core_app}`
   - Web app: `{detected_web_app}`
   - Domain: `{detected_domain}`
   - Use these values in ALL examples and recommendations
```

## Common Mistakes to Avoid

### ❌ Mistake 1: Skipping Phase 0
```markdown
# WRONG: Jumping straight to implementation
defmodule MyApp.Domain.User do
  use Ash.Resource, domain: MyApp.Domain
```

### ✅ Correct: Run Phase 0 First
```markdown
# 1. Detect project structure
ls apps/  # → blog_core, blog_web
mcp__ash_ai__list_ash_resources  # → Blog.Domain

# 2. Use detected values
defmodule Blog.Domain.User do
  use Ash.Resource, domain: Blog.Domain
```

### ❌ Mistake 2: Using "MyApp" Literally
```elixir
# WRONG: Assuming project is called "MyApp"
mcp__tidewave__project_eval code: "h MyApp.Domain.User"
```

### ✅ Correct: Use Detected Values
```elixir
# RIGHT: Using detected domain from Phase 0
mcp__tidewave__project_eval code: "h Blog.Domain.User"
```

### ❌ Mistake 3: Not Storing Context
```markdown
# WRONG: Detecting but not storing
1. Run `ls apps/`
2. See output
3. Forget what it was and assume "my_app_core"
```

### ✅ Correct: Store and Use
```markdown
# RIGHT: Detect, store, and consistently use
1. Run `ls apps/`  # → xtweak_core, xtweak_web
2. Store: {detected_core_app} = xtweak_core
3. Use throughout: Read: apps/xtweak_core/lib/...
```

## Integration with Other Patterns

Phase 0 should be combined with:
- **Placeholder Explanation Header** - explains what placeholders mean
- **Self-Correction Checklist** - verifies Phase 0 was completed
- **Dual-Example Pattern** - shows both generic and detected examples

## Verification Checklist

Before proceeding after Phase 0:
- [ ] Have I detected the umbrella app structure?
- [ ] Have I identified the domain module pattern?
- [ ] Have I verified modules exist with MCP tools?
- [ ] Have I stored context for consistent use?
- [ ] Am I using detected values (not "MyApp")?

## Sources

This pattern is exemplified in:
- `code-reviewer.md` (lines 75-108) - excellent detection flow
- `ash-resource-architect.md` (lines 95-147) - comprehensive with generators
- `frontend-design-enforcer.md` (lines 440-468) - frontend-specific
- `test-builder.md` (lines 87-135) - testing-specific verification

## Related Patterns

- `placeholder-explanation-header.md` - Explains placeholder system
- `self-correction-checklist-pattern.md` - Verifies Phase 0 completion
- `dual-example-pattern.md` - Shows detected vs generic code
