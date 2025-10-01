# Agent Patterns Library

This directory contains reusable patterns for building project-agnostic agents that work across different Elixir/Phoenix/Ash projects.

## 📋 Pattern Index

### Core Patterns

1. **[phase-0-detection-pattern.md](phase-0-detection-pattern.md)** ⭐ CRITICAL
   - **Purpose**: Detect actual project structure before implementing features
   - **When to use**: Every agent that generates project-specific code
   - **Key benefit**: Prevents hardcoding "MyApp" or other placeholder names

2. **[placeholder-explanation-header-pattern.md](placeholder-explanation-header-pattern.md)** ⭐ CRITICAL
   - **Purpose**: Teach agents about placeholder syntax upfront
   - **When to use**: Top of every agent file with code examples
   - **Key benefit**: Prevents agents from copying "MyApp" literally

3. **[self-correction-checklist-pattern.md](self-correction-checklist-pattern.md)** ⭐ CRITICAL
   - **Purpose**: Agent self-verification before executing tasks
   - **When to use**: Before any implementation section in agents
   - **Key benefit**: Catches placeholder/detection errors before they cause failures

4. **[dual-example-pattern.md](dual-example-pattern.md)**
   - **Purpose**: Show both generic pattern + concrete example
   - **When to use**: Complex code patterns where placeholders alone are unclear
   - **Key benefit**: Reduces ambiguity, shows transformation visually

5. **[ash-resource-pattern.md](ash-resource-pattern.md)**
   - **Purpose**: Standard structure for Ash resource creation agents
   - **When to use**: Building agents that create/modify Ash resources
   - **Key benefit**: Consistent resource generation following best practices

## 🎯 Quick Start: Adding Patterns to a New Agent

### Minimum Viable Agent (3 Required Patterns)

Every new agent should include:

1. **Placeholder Explanation Header** (at top, after description)
2. **Phase 0 Detection Section** (before any implementation)
3. **Self-Correction Checklist** (before "Remember" or final sections)

```markdown
---
name: my-new-agent
description: Does something awesome
---

# My New Agent

[Brief description]

## 🎯 CRITICAL: Understanding Placeholders
[Use: placeholder-explanation-header-pattern.md]

## Phase 0: Detect Project Context (MANDATORY FIRST STEP)
[Use: phase-0-detection-pattern.md]

## [Agent-specific implementation sections...]

## Self-Correction: Before [Agent Action]
[Use: self-correction-checklist-pattern.md]

## Remember
[Final guidelines]
```

### Full-Featured Agent (All 5 Patterns)

For agents with complex code examples:

1. Add **Dual Example Pattern** to code sections
2. Follow **Ash Resource Pattern** if working with resources

## 📊 Pattern Compliance by Agent

| Agent | Phase 0 | Placeholder Header | Self-Correction | Dual Example | Compliance |
|-------|---------|-------------------|----------------|--------------|------------|
| agent-architect | ✅ | ✅ | ✅ | ✅ | 100% |
| code-reviewer | ✅ | ✅ | ✅ | ✅ | 100% |
| ash-resource-architect | ✅ | ✅ | ✅ | ✅ | 100% |
| frontend-design-enforcer | ✅ | ✅ | ✅ | ✅ | 100% |
| test-builder | ✅ | ✅ | ✅ | ✅ | 100% |
| mcp-verify-first | ✅ | ✅ | ✅ | ✅ | 100% |
| cytoscape-expert | ✅ | ✅ | ✅ | ✅ | 100% ⬆️ |
| security-reviewer | ✅ | ✅ | ✅ | ✅ | 100% ⬆️ |
| code-review-implement | ✅ | ✅ | ✅ | ✅ | 100% ⬆️ |

**Legend**: ⬆️ = Recently refactored to compliance

## 🔄 Pattern Relationships

```
┌─────────────────────────────────────┐
│  Placeholder Explanation Header     │ ← First: Explains placeholders conceptually
│  (Top of agent file)                │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  Phase 0 Detection                  │ ← Second: HOW to detect actual values
│  (Before implementation)            │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  Dual Example Pattern               │ ← During: Show pattern + concrete example
│  (In code sections)                 │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  Self-Correction Checklist          │ ← Before execution: Verify no errors
│  (Before implementation begins)     │
└─────────────────────────────────────┘
```

## 🎨 Pattern Variations

### By Agent Type

**Resource-Creating Agents** (ash-resource-architect, test-builder):
- MUST use: All 5 patterns
- Special emphasis on: Ash Resource Pattern

**Code-Reviewing Agents** (security-reviewer, code-reviewer):
- MUST use: Phase 0, Placeholder Header, Self-Correction
- Optional: Dual Example (for showing fix patterns)

**Integration Agents** (cytoscape-expert, frontend-design-enforcer):
- MUST use: All 5 patterns
- Heavy use of: Dual Example (showing multiple module interactions)

**Meta-Agents** (agent-architect):
- MUST use: All 5 patterns
- Extra responsibility: Ensure NEW agents use patterns correctly

## 📚 Pattern Details

### Phase 0 Detection Pattern

**4-Step Process**:
1. Detect umbrella structure (`ls apps/`)
2. Identify domain pattern (`mcp__ash_ai__list_ash_resources`)
3. Verify module exists (`mcp__tidewave__project_eval`)
4. Store context for session

**Variations**:
- Standard: xtweak_core, xtweak_web → XTweak.Core
- Alternative: blog_core, blog_web → Blog.Domain
- Non-umbrella: Adapt step 1 detection

### Self-Correction Checklist Pattern

**6 Core Questions** (adapt for your agent):
1. ❓ Did I complete Phase 0?
2. ❓ Have I replaced ALL placeholders?
3. ❓ Am I using ACTUAL module names (not "MyApp")?
4. ❓ Did I verify resources exist?
5. ❓ Are file paths using detected names?
6. ❓ [Agent-specific verification]

**Additional Checks** (placeholder-specific):
- ❌ If I see "MyApp" → STOP
- ❌ If I see "my_app_core" → STOP
- ✅ If all names from MCP tools → Proceed

## 🚨 Common Anti-Patterns

### ❌ Anti-Pattern: Skipping Phase 0

**Wrong**:
```markdown
## Implementation

Create the resource:
```elixir
defmodule MyApp.Domain.User do
end
```
```

**Right**:
```markdown
## Phase 0: Detect Project Context (MANDATORY FIRST STEP)
[Detection steps...]

## Implementation

#### Generic Pattern (ADAPT THIS)
```elixir
defmodule {YourApp}.Domain.User do
end
```
```

### ❌ Anti-Pattern: Placeholders Without Explanation

**Wrong** (placeholders appear suddenly):
```markdown
## Create Resource

Use this pattern:
```elixir
defmodule {YourApp}.Domain.{ResourceName} do
end
```
```

**Right** (explanation first):
```markdown
## 🎯 CRITICAL: Understanding Placeholders
[Explanation of placeholder syntax...]

## Create Resource

#### Generic Pattern (ADAPT THIS)
```elixir
defmodule {YourApp}.Domain.{ResourceName} do
end
```
```

### ❌ Anti-Pattern: Self-Correction After Implementation

**Wrong** (checklist at end):
```markdown
## Implementation
[Does work...]

## Self-Correction Checklist
[Checks...]
```

**Right** (checklist before):
```markdown
## Self-Correction: Before Implementing
[Checks...]

## Implementation
[Does work...]
```

## 🧪 Testing Pattern Compliance

### Manual Review Checklist

For each agent file:

- [ ] Has placeholder explanation header at top?
- [ ] Has Phase 0 section before implementation?
- [ ] Has self-correction checklist before execution?
- [ ] All code examples use `{YourApp}` not "MyApp"?
- [ ] Complex examples have dual (generic + concrete) format?
- [ ] Ash resource agents follow ash-resource-pattern.md?

### Automated Detection

Run Agent Architect to check compliance:
```bash
# Check all agents
/agent-architect check-compliance

# Check specific agent
/agent-architect check-compliance --agent=my-agent
```

## 📝 Contributing New Patterns

### When to Create a New Pattern

Create a new pattern if:
1. **Reused 3+ times** across different agents
2. **Solves common problem** (like placeholder detection)
3. **Non-obvious** (requires explanation beyond code comments)
4. **Has clear boundaries** (distinct start/end, single responsibility)

### Pattern Creation Template

```markdown
# Pattern: [Name]

## Purpose
[1-2 sentences: what problem does this solve?]

## When to Use
- [Specific scenario 1]
- [Specific scenario 2]

## Pattern Structure
```[language or markdown]
[Template showing the pattern]
```

## Real-World Examples
[2-3 examples from actual agents]

## Benefits
[Numbered list of advantages]

## Anti-Patterns to Avoid
[What NOT to do, with examples]

## Integration with Other Patterns
[How this pattern relates to others]

## Checklist for Adding This Pattern
[Step-by-step guide]
```

### Submitting a New Pattern

1. Create pattern file in `.claude/patterns/`
2. Add entry to this README's Pattern Index
3. Update 1-2 agents to use the pattern (as examples)
4. Run agent compliance check
5. Document in AGENT_USAGE_GUIDE.md if it changes agent authoring workflow

## 🔗 Related Documentation

- **[AGENT_USAGE_GUIDE.md](../ AGENT_USAGE_GUIDE.md)**: High-level guide to agent authoring principles
- **[AGENT_COMPLIANCE_REPORT.md](../AGENT_COMPLIANCE_REPORT.md)**: Detailed compliance analysis
- **[agents/](../agents/)**: Directory of all agents using these patterns

## 📊 Pattern Evolution

### Version History

- **v1.0** (2025-01-10): Initial 5 patterns extracted from compliant agents
  - phase-0-detection-pattern.md
  - placeholder-explanation-header-pattern.md
  - self-correction-checklist-pattern.md
  - dual-example-pattern.md
  - ash-resource-pattern.md

### Future Pattern Candidates

Patterns under consideration for extraction:
- **MCP-First Detection**: Standardize MCP tool usage for detection
- **Error-Recovery Pattern**: How agents should handle detection failures
- **Multi-Project Example Pattern**: Showing 3+ project variations
- **Nested Placeholder Pattern**: Handling `{YourApp}.{SubDomain}.{Resource}`

---

**Last Updated**: 2025-01-10
**Pattern Count**: 5
**Agent Compliance Rate**: 100% (9/9 agents)
