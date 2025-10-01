# Pattern: Dual Example (Generic + Concrete)

## Purpose
Show BOTH a generic pattern using placeholders AND a concrete example with a specific project name, so agents understand how to adapt patterns while seeing real-world application.

## When to Use
- When providing code examples that reference project-specific modules
- For complex patterns where placeholder syntax alone might be unclear
- When showing integration between multiple modules/resources
- For patterns that agents will copy and adapt frequently

## Pattern Structure

```markdown
### [Feature Name] - Generic Pattern (ADAPT THIS)
```[language]
# Generic pattern using {YourApp} placeholders
[Code with placeholder syntax]
```

### Example for "[ProjectName]" Project
```[language]
# Concrete example with actual project name
[Same code with placeholders replaced]
```

### [Optional: Example for Second Project]
```[language]
# Shows variation for different project structure
[Code adapted for different architecture]
```
```

## Key Principles

1. **Always label which is which**:
   - Generic pattern: "Generic Pattern (ADAPT THIS)"
   - Concrete example: "Example for 'Blog' Project"

2. **Keep structure identical**:
   - Same number of lines
   - Same logic flow
   - Only names change, not architecture

3. **Choose realistic project names**:
   - Blog, Shop, Forum (common, relatable)
   - NOT: "MyApp", "ExampleApp", "TestProject"

4. **Show 1-2 concrete examples max**:
   - One example: sufficient for simple patterns
   - Two examples: useful to show architectural variations

## Real-World Examples

### From cytoscape-expert.md

```markdown
#### Node Resource - Generic Pattern (ADAPT THIS)
```elixir
defmodule {YourApp}.Graph.GraphNode do
  use Ash.Resource,
    domain: {YourApp}.Graph,
    data_layer: AshPostgres.DataLayer

  relationships do
    belongs_to :owner, {YourApp}.Domain.User
  end
end
```

#### Example for "Blog" Project
```elixir
defmodule Blog.Graph.GraphNode do
  use Ash.Resource,
    domain: Blog.Graph,
    data_layer: AshPostgres.DataLayer

  relationships do
    belongs_to :owner, Blog.Domain.User
  end
end
```
```

### From security-reviewer.md

```markdown
#### Generic Pattern (ADAPT THIS - Use YOUR detected domain)
```elixir
mcp__tidewave__project_eval code: """
{YourApp}.Domain.get({YourApp}.Domain.Post, post_id, actor: nil)
# Should return {:error, _} with Ash authorization error
"""
```

#### Example for "Blog" Project
```elixir
mcp__tidewave__project_eval code: """
Blog.Domain.get(Blog.Domain.Post, post_id, actor: nil)
# Should return {:error, _} with Ash authorization error
"""
```
```

## When to Show Multiple Concrete Examples

### Single Example (Most Common)
Use when:
- Pattern is straightforward with one architectural variation
- Showing simple module name replacement
- Agent only needs one reference implementation

### Two Examples (Recommended for Variations)
Use when:
- Different domain patterns exist (Blog.Domain vs XTweak.Core)
- Showing umbrella vs non-umbrella differences
- Demonstrating different naming conventions

**Example with architectural variation**:

```markdown
#### Example #1: "Blog" Project (Standard Domain)
```elixir
defmodule Blog.Domain.User do
  use Ash.Resource, domain: Blog.Domain
end
```

#### Example #2: "XTweak" Project (Core Pattern)
```elixir
defmodule XTweak.Core.User do
  use Ash.Resource, domain: XTweak.Core
end
```
```

## Benefits

1. **Reduces Ambiguity**: Concrete example removes guesswork
2. **Shows Transformation**: Agent sees exactly how placeholders become code
3. **Validates Understanding**: If agent can't adapt pattern, they misunderstood
4. **Prevents Copying Errors**: Less likely to use "Blog" literally when they see it's an example

## Anti-Patterns to Avoid

❌ **Showing only generic pattern**
```markdown
### Resource Pattern
```elixir
defmodule {YourApp}.Domain.{ResourceName} do
end
```
```
Problem: Agent may not understand how to replace nested placeholders

❌ **Showing only concrete example**
```markdown
### Resource Pattern
```elixir
defmodule Blog.Domain.User do
end
```
```
Problem: Agent might copy "Blog" literally

❌ **Using "MyApp" as concrete example**
```markdown
### Example
```elixir
defmodule MyApp.Domain.User do
end
```
```
Problem: "MyApp" looks like placeholder, defeats the purpose

❌ **Different structure in generic vs concrete**
```markdown
### Generic
```elixir
defmodule {YourApp}.Domain.User do
  use Ash.Resource, domain: {YourApp}.Domain
end
```

### Concrete
```elixir
defmodule Blog.Domain.User do
  use Ash.Resource,
    domain: Blog.Domain,
    extensions: [AshAdmin.Resource]  # ← Extra stuff not in generic!
end
```
```
Problem: Concrete example should mirror generic structure exactly

## Integration with Other Patterns

- **Requires**: [placeholder-explanation-header-pattern.md](placeholder-explanation-header-pattern.md)
  - Header explains placeholders conceptually
  - Dual examples show them in practice

- **Works with**: [phase-0-detection-pattern.md](phase-0-detection-pattern.md)
  - Phase 0 detects which concrete example to follow
  - Dual examples show what detection should produce

- **Reinforces**: [self-correction-checklist-pattern.md](self-correction-checklist-pattern.md)
  - Examples make checklist items concrete
  - Checklist prevents copying example literally

## Template

```markdown
### [Feature/Pattern Name]

#### Generic Pattern (ADAPT THIS)
```[language]
[Code using {YourApp}, {ResourceName}, etc.]
```

#### Example for "[CommonProjectName]" Project
```[language]
[Exact same code with placeholders replaced]
# Optional: Brief comment explaining why this project uses this pattern
```

[Optional] #### Example for "[DifferentProjectName]" Project
```[language]
[Same structure, different architectural choice]
# Optional: Comment highlighting the variation
```
```

## Checklist for Adding Dual Examples

- [ ] Generic pattern clearly labeled "(ADAPT THIS)"
- [ ] Concrete example uses realistic project name (Blog, Shop, Forum)
- [ ] Structure is IDENTICAL between generic and concrete
- [ ] Placeholder → Concrete mapping is 1:1 (no extra code added)
- [ ] If showing 2+ examples, each demonstrates a real architectural variation
- [ ] Comments explain WHY variation exists, not WHAT the code does

## Measuring Success

✅ **Good dual example**: Agent can look at pattern and concrete example, then generate code for their actual project (e.g., "Marketplace") without seeing a Marketplace example

❌ **Poor dual example**: Agent needs to see a Marketplace-specific example to generate Marketplace code
