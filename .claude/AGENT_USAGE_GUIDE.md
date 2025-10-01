# Agent Usage Guide: Understanding Placeholders and Project Context Detection

## Overview

All agents in this project have been designed to be **project-agnostic**. They use placeholder syntax in examples to prevent literal copying of project-specific names like "MyApp" or "BlogWeb" into your actual codebase.

## 🎯 The Placeholder System

### What Are Placeholders?

Placeholders are standardized tokens that represent project-specific values:

| Placeholder | Represents | Examples |
|-------------|------------|----------|
| `{YourApp}` | Project name | Blog, XTweak, Shop |
| `{YourApp}Core` | Core app name | blog_core, xtweak_core, shop_core |
| `{YourApp}Web` | Web app module | BlogWeb, XTweakWeb, ShopWeb |
| `{YourApp}.Domain` | Domain module | Blog.Domain, XTweak.Core, Shop.Domain |
| `{ResourceName}` | Specific resource | User, Post, Product |

### Why Use Placeholders?

**Without placeholders (OLD WAY):**
```elixir
# Agent example:
defmodule MyAppWeb.PostLive do
  use MyAppWeb, :live_view

# User copies literally → WRONG!
defmodule MyAppWeb.PostLive do  # ← Should be BlogWeb!
  use MyAppWeb, :live_view      # ← Should be BlogWeb!
```

**With placeholders (NEW WAY):**
```elixir
# Agent pattern:
defmodule {YourApp}Web.{Resource}Live do
  use {YourApp}Web, :live_view

# Example for Blog project:
defmodule BlogWeb.PostLive do
  use BlogWeb, :live_view

# User adapts correctly:
defmodule BlogWeb.PostLive do  # ✅ Correct!
  use BlogWeb, :live_view      # ✅ Correct!
```

## Phase 0: How Agents Detect YOUR Project

Every agent that implements code follows this mandatory detection sequence:

### Step 1: Detect Umbrella Structure

```bash
ls apps/
# Example outputs:
# - blog_core, blog_web
# - xtweak_core, xtweak_web
# - shop_core, shop_web
```

### Step 2: Detect Domain Pattern

```
mcp__ash_ai__list_ash_resources
# Agent looks for domain pattern in output:
# Examples: Blog.Domain, XTweak.Core, Shop.Domain
```

### Step 3: Verify and Store Context

```
mcp__tidewave__project_eval code: "h {DetectedDomain}"
# Confirms the detected domain module exists
```

### Step 4: Use Detected Values Everywhere

Once detected, agents replace ALL placeholders:
- `{YourApp}` → `Blog`, `XTweak`, `Shop`, etc.
- `{YourApp}Web` → `BlogWeb`
- `{YourApp}.Domain` → `Blog.Domain`

## How to Read Agent Examples

### Pattern Section
Shows the **generic structure** you should adapt:

```elixir
# Generic Pattern (ADAPT THIS):
defmodule {YourApp}.Domain.{Resource} do
  use Ash.Resource,
    domain: {YourApp}.Domain,
    data_layer: AshPostgres.DataLayer
```

### Example Section
Shows a **concrete example** for reference:

```elixir
# Example for "Blog" project with User resource:
defmodule Blog.Domain.User do
  use Ash.Resource,
    domain: Blog.Domain,
    data_layer: AshPostgres.DataLayer
```

### Your Implementation
What YOU should write after detecting your project:

```elixir
# If YOUR project is "Shop":
defmodule Shop.Domain.Product do
  use Ash.Resource,
    domain: Shop.Domain,
    data_layer: AshPostgres.DataLayer
```

## Common Mistakes to Avoid

### ❌ Mistake 1: Literal Copying

```elixir
# Agent shows example:
defmodule MyApp.Domain.User do
  ...
end

# DON'T copy "MyApp" literally:
defmodule MyApp.Domain.User do  # ❌ WRONG!
  ...
end

# DO detect YOUR project name:
defmodule Blog.Domain.User do  # ✅ CORRECT!
  ...
end
```

### ❌ Mistake 2: Ignoring Phase 0

```
# DON'T assume module names:
"I think the domain is MyApp.Domain"  # ❌ Assuming

# DO detect with MCP tools:
mcp__ash_ai__list_ash_resources  # ✅ Verifying
# → Discovers actual domain: Blog.Domain
```

### ❌ Mistake 3: Mixing Placeholder Styles

```elixir
# DON'T mix detected and placeholder values:
defmodule BlogWeb.{Resource}Live do  # ❌ Inconsistent
  use {YourApp}Web, :live_view
end

# DO replace ALL placeholders:
defmodule BlogWeb.PostLive do  # ✅ Fully adapted
  use BlogWeb, :live_view
end
```

## Agent Self-Correction Checklist

Before presenting ANY code, agents ask themselves:

1. ❓ Did I complete Phase 0 to detect actual project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using ACTUAL module names (not "MyApp")?
4. ❓ Did I verify with MCP tools using detected names?
5. ❓ Are file paths using detected app names?

If ANY answer is "No" → Agent STOPS and completes Phase 0 first.

## Project-Specific Context: xTweak

For THIS infrastructure template project, agents will detect:

**Detected Values:**
- Core app: `xtweak_core`
- Web app: `xtweak_web`
- Domain: `XTweak.Core`
- Web module: `XTweakWeb`

**Pattern Replacement:**
```elixir
# Pattern:
defmodule {YourApp}.Core.{Resource} do

# Becomes (for xTweak):
defmodule XTweak.Core.User do

# Or for YOUR project (e.g., Blog):
defmodule Blog.Domain.User do
```

## How Placeholders Prevent Errors

### Real-World Scenario

**User's Question**: "Create a Post resource for my blog"

**Without Placeholders (OLD):**
```elixir
# Agent provides example:
defmodule MyApp.Domain.Post do
  use Ash.Resource, domain: MyApp.Domain

# User copies → Error!
# Their project is "Blog" not "MyApp"
# Code won't compile
```

**With Placeholders (NEW):**
```elixir
# Agent detects project first:
ls apps/  # → blog_core, blog_web
mcp__ash_ai__list_ash_resources  # → Blog.Domain

# Agent provides adapted code:
defmodule Blog.Domain.Post do
  use Ash.Resource, domain: Blog.Domain

# ✅ Compiles and works immediately!
```

## Meta-Instructions in Agents

All agents now include explicit instructions:

### Example from ash-resource-architect.md:

```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Replace with actual project name
- `{YourApp}.Domain` → Replace with detected domain module

**Before implementing ANYTHING**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. Verify adapted code matches project patterns
```

## Best Practices for Agent Usage

### 1. Trust Phase 0 Detection
Let agents detect your project structure—don't manually specify unless necessary.

### 2. Verify Agent Adaptations
After an agent provides code, quickly verify it used YOUR actual module names:
```bash
# Check that agent used correct domain:
grep "domain:" generated_file.ex
# Should show Blog.Domain (or YOUR domain), not MyApp.Domain
```

### 3. Look for Placeholder Warnings
If you see `{YourApp}` in generated code → Agent skipped Phase 0!
- Ask agent to detect project context first
- Provide actual module names explicitly

### 4. Use Examples as References
Examples show what the PATTERN looks like when adapted—use them to understand, not copy verbatim.

## Troubleshooting

### Problem: Agent used "MyApp" literally

**Solution:**
```
"Please detect the actual project structure first using Phase 0 before implementing."
```

### Problem: Placeholder not replaced

**Check:**
- Did agent run `ls apps/`?
- Did agent run `mcp__ash_ai__list_ash_resources`?
- Did agent verify detected domain with `mcp__tidewave__project_eval`?

**Fix:**
```
"You still have {YourApp} placeholders. Please replace them with the detected project name."
```

### Problem: Wrong module name detected

**Override:**
```
"The domain module is actually XTweak.Core, not XTweak.Domain. Please use XTweak.Core in all code."
```

## Summary

**Key Takeaways:**
1. Agents use `{Placeholders}` to be project-agnostic
2. Phase 0 detects YOUR actual project structure
3. ALL examples should be adapted, never copied literally
4. "MyApp" is a generic placeholder—never use it in real code
5. Agents verify and self-correct before presenting code

**Your Role:**
- Trust the detection process
- Verify adapted code uses YOUR module names
- Ask agents to re-detect if placeholders appear in output

**Agent's Role:**
- Always run Phase 0 first
- Replace ALL placeholders with detected values
- Verify with MCP tools using actual names
- Self-correct before presenting code

---

This system ensures agents can work on ANY Elixir/Ash project without hardcoding project-specific names, while still providing clear, concrete examples that work immediately after adaptation.
