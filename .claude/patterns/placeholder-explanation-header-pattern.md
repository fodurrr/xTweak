# Pattern: Placeholder Explanation Header

## Purpose
Teach agents about placeholder syntax BEFORE they see any code examples, preventing literal copying of "MyApp" or other generic names.

## When to Use
- **EVERY agent that shows code examples** with project-specific names
- At the VERY TOP of the agent file, right after the description
- Before any implementation patterns or examples

## Pattern Structure

```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Replace with actual project name (Blog, XTweak, Shop, etc.)
- `{YourApp}Core` → Replace with core app name (blog_core, xtweak_core, etc.)
- `{YourApp}Web` → Replace with web module (BlogWeb, XTweakWeb, etc.)
- `{YourApp}.Domain` → Replace with domain module (Blog.Domain, XTweak.Core, etc.)
- `{ResourceName}` → Replace with actual resource (User, Post, Product, etc.)

**Before [AGENT_SPECIFIC_ACTION]**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. Use detected module names in MCP tool calls

## Why Placeholders?

**Without placeholders (WRONG)**:
```elixir
# Agent shows:
defmodule MyApp.Domain.Post do
  use Ash.Resource, domain: MyApp.Domain

# User copies literally → FAILS!
defmodule MyApp.Domain.Post do  # ← Wrong! Their project is "Blog"
```

**With placeholders (CORRECT)**:
```elixir
# Agent shows pattern:
defmodule {YourApp}.Domain.{ResourceName} do
  use Ash.Resource, domain: {YourApp}.Domain

# Agent detects → Blog.Domain
# User gets:
defmodule Blog.Domain.Post do
  use Ash.Resource, domain: Blog.Domain
```
```

## Customization Points

### 1. Agent-Specific Action
Replace `[AGENT_SPECIFIC_ACTION]` with the agent's primary task:
- "implementing Cytoscape features" (cytoscape-expert)
- "conducting security review" (security-reviewer)
- "implementing code review fixes" (code-review-implement)
- "creating Ash resources" (ash-resource-architect)

### 2. Additional Placeholders
Add agent-specific placeholders if needed:
- `{GraphNode}`, `{GraphEdge}` for graph-related agents
- `{Token}`, `{Session}` for auth-related agents
- `{LiveViewName}` for frontend agents

### 3. Example Adaptation
Use examples relevant to the agent's domain:
- Cytoscape → Show graph module examples
- Security → Show security test examples
- Resource → Show Ash resource examples

## Real-World Examples

### From cytoscape-expert.md
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}.Graph` → Replace with graph domain module
- `MyApp` in examples → Generic placeholder, **NEVER** use literally

**Before implementing Cytoscape features**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. Verify graph resources exist with MCP tools
```

### From security-reviewer.md
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**Before conducting security review**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values when testing vulnerabilities
3. Use detected module names in MCP tool verification
```

## Benefits

1. **Prevents Literal Copying**: Agent understands placeholders are NOT actual code
2. **Front-Loading Context**: Explains the "why" before showing the "what"
3. **Visual Examples**: Shows both wrong and correct approaches
4. **Consistent Format**: Same structure across all agents

## Anti-Patterns to Avoid

❌ **Placing placeholder explanation AFTER code examples**
- Agent may have already copied literal "MyApp" before reading explanation

❌ **Skipping the "Why Placeholders?" section**
- Without concrete examples, agents may not understand the problem

❌ **Using vague language like "adapt this"**
- Be explicit: "Replace `{YourApp}` with detected value from Phase 0"

❌ **Omitting the header entirely for "simple" agents**
- Even simple agents can generate project-specific code

## Integration with Other Patterns

- **Pairs with**: [phase-0-detection-pattern.md](phase-0-detection-pattern.md)
  - Explanation header tells agents WHAT to do
  - Phase 0 pattern tells agents HOW to detect values

- **Pairs with**: [dual-example-pattern.md](dual-example-pattern.md)
  - Header explains placeholders conceptually
  - Dual examples show them in practice

- **Pairs with**: [self-correction-checklist-pattern.md](self-correction-checklist-pattern.md)
  - Header prevents errors proactively
  - Checklist catches errors reactively

## Checklist for Adding This Pattern

- [ ] Add immediately after agent description, before any other sections
- [ ] List ALL placeholders used in this specific agent
- [ ] Include the "Why Placeholders?" comparison section
- [ ] Customize the "Before [ACTION]" steps for this agent's purpose
- [ ] Use code fence syntax (```elixir) for all code examples
- [ ] Reference Phase 0 detection pattern

## Template for New Agents

```markdown
# [Agent Name]

[Agent description...]

## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Replace with actual project name (Blog, XTweak, Shop, etc.)
- [Add agent-specific placeholders here]

**Before [this agent's primary action]**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. [Add agent-specific requirement, e.g., "Verify resources exist with MCP tools"]

## Why Placeholders?

**Without placeholders (WRONG)**:
```[language]
# Agent shows:
[Example showing literal "MyApp" usage]

# User copies literally → FAILS!
[Show why this fails for their project]
```

**With placeholders (CORRECT)**:
```[language]
# Agent shows pattern:
[Example using {YourApp} placeholders]

# Agent detects → [Example project name]
# User gets:
[Example with detected values filled in]
```

[Rest of agent content...]
```
