# Agent Compliance Report

**Date**: 2025-10-01
**Purpose**: Verify all agents follow placeholder patterns and Phase 0 detection principles from AGENT_USAGE_GUIDE.md

---

## Executive Summary

**Total Agents Reviewed**: 9
**Fully Compliant**: ✅ 6
**Partially Compliant**: ⚠️ 2
**Non-Compliant**: ❌ 1

### Key Findings

1. **Most agents (6/9) already implement Phase 0 detection** and use placeholder syntax correctly
2. **Three agents need updates**: security-reviewer, cytoscape-expert, code-review-implement
3. **Strong patterns identified**: ash-resource-architect, code-reviewer, frontend-design-enforcer, test-builder, mcp-verify-first, agent-architect
4. **New pattern extracted**: Self-correction checklist pattern (from multiple agents)

---

## Detailed Agent Analysis

### ✅ COMPLIANT AGENTS

---

#### 1. agent-architect.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Includes comprehensive Phase 0 detection instructions
- ✅ Uses `{YourApp}`, `{ResourceName}` placeholder syntax throughout
- ✅ Includes explicit meta-instructions about placeholders
- ✅ Has self-correction checklist for placeholder usage
- ✅ Provides both generic pattern AND concrete examples
- ✅ Never uses literal "MyApp" as if it's standard

**Example of Good Practice**:
```markdown
## 🎯 CRITICAL: Understanding Placeholders in Agent Design

**ALL code examples and patterns in agent design use PLACEHOLDER SYNTAX**:
- `{YourApp}Core` → The actual core app name in the target project
- `{YourApp}Web` → The actual web app name in the target project
```

**Pattern Worth Reusing**:
- **Pre-Design Research Phase** structure is excellent
- **Self-Correction Checklist** is comprehensive and should be template for other agents

---

#### 2. code-reviewer.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Phase 0 detection as mandatory step (lines 75-108)
- ✅ Consistent use of `{YourApp}`, `{YourApp}.Domain` placeholders
- ✅ Explicit warning: "NEVER judge code against general knowledge. ALWAYS verify current project patterns"
- ✅ Self-correction checklist at end (lines 429-438)
- ✅ Detects actual domain pattern: "Blog.Domain vs XTweak.Core vs Shop.Domain"
- ✅ Provides both generic patterns and concrete examples

**Example of Excellent Phase 0**:
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
```

**Pattern Worth Reusing**:
- **Detection + Storage + Usage** workflow is exemplary
- Shows BEFORE detection and AFTER detection examples

---

#### 3. ash-resource-architect.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Comprehensive Phase 0 detection (lines 95-147)
- ✅ Extensive use of placeholders with explanations
- ✅ Provides 3+ concrete examples (Blog, XTweak, Shop patterns)
- ✅ Self-correction checklist (lines 764-774)
- ✅ Meta-instructions about placeholder usage (lines 60-72)
- ✅ Shows actual vs placeholder side-by-side in examples

**Outstanding Example**:
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Replace with actual project name (Blog, Shop, XTweak, etc.)
- `{ResourceName}` → The specific resource you're implementing (User, Post, Product, etc.)

**Before implementing ANYTHING**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. Verify adapted code matches project patterns
```

**Pattern Worth Reusing**:
- **Resource Template Pattern** section shows generic, then Blog example, then Shop example
- **Mandatory Workflow** with explicit Phase 0 as first step

---

#### 4. frontend-design-enforcer.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Phase 0 detection (lines 440-468)
- ✅ Consistent placeholder usage: `{YourApp}Web`, `{YourApp}.Domain`
- ✅ Self-correction checklist (lines 617-627)
- ✅ Explicit warning never to use "MyAppWeb" literally
- ✅ Component patterns show both generic and concrete examples

**Example**:
```markdown
### Phase 0: Detect Project Context (MANDATORY FIRST STEP)

Before implementing ANY frontend code, detect the actual project structure:

1. **Detect Web App Name**:
   ```bash
   ls apps/
   # Example output: blog_web, xtweak_web
   # Store: {detected_web_app}
   ```
```

**Pattern Worth Reusing**:
- Stores both `{detected_web_app}` AND `{detected_web_module}` for different use cases

---

#### 5. test-builder.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Phase 0 with verification steps (lines 87-135)
- ✅ Uses `{YourApp}.DataCase`, `{YourApp}.Domain` consistently
- ✅ Provides Blog.Domain and XTweak.Core examples
- ✅ Self-correction checklist (lines 618-628)
- ✅ Emphasizes "NEVER write tests based on assumptions"

**Outstanding Feature**:
```markdown
**Rule**: NEVER write tests based on assumptions. Verify behavior first with MCP tools using ACTUAL detected module names.
```

**Pattern Worth Reusing**:
- Test structure template with side-by-side generic/concrete examples

---

#### 6. mcp-verify-first.md
**Status**: ✅ Fully Compliant
**Compliance Score**: 100%

**Strengths**:
- ✅ Entire agent is about verification - models Phase 0 perfectly
- ✅ Comprehensive placeholder explanation (lines 58-76)
- ✅ Shows actual project structure examples (Blog, XTweak, Shop)
- ✅ Self-correction with placeholder check (lines 348-365)
- ✅ "Quick Reference Card" for detection patterns (lines 251-296)

**Excellent Pattern**:
```markdown
**Additional Placeholder Check**:
- ❌ If I see "MyApp.Domain" in my solution → STOP, detect actual domain
- ❌ If I see "my_app_core" in file paths → STOP, detect actual core app name
- ❌ If I haven't run `ls apps/` yet → STOP, detect structure first
- ✅ If all module names came from MCP tool outputs → Proceed
```

**Pattern Worth Reusing**:
- **Decision Framework Table** (line 240) showing when to use which tool
- **Quick Reference Card** for most common patterns

---

### ⚠️ PARTIALLY COMPLIANT AGENTS

---

#### 7. security-reviewer.md
**Status**: ⚠️ Partially Compliant
**Compliance Score**: 60%

**Issues Found**:
1. ❌ **NO Phase 0 detection section**
2. ⚠️ **Limited placeholder usage** - uses "MyApp" in some examples without detection
3. ⚠️ **No self-correction checklist**
4. ✅ Has some placeholder usage in examples (lines 296-329)
5. ❌ Missing meta-instructions about placeholders

**Examples of Issues**:

Line 50: Uses literal "my_app_core" without detection
```markdown
4. **RESPECT PROJECT CONTEXT**: This is an Elixir umbrella application using Ash Framework. Understand the multi-app architecture (my_app_core, my_app_web, and optional additional apps)
```

Lines 296-320: Uses "MyApp" without clarifying it's a placeholder
```elixir
mcp__tidewave__project_eval code: """
MyApp.Domain.get(MyApp.Domain.Post, post_id, actor: nil)
```

**What Needs to Be Added**:
1. Add Phase 0 detection section BEFORE "Review Methodology"
2. Add placeholder explanation section at top
3. Update all examples to use `{YourApp}` syntax
4. Add self-correction checklist
5. Add meta-instructions explaining placeholder replacement

**Recommended Structure Addition**:
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Your actual project name (Blog, XTweak, Shop)
- `{YourApp}.Domain` → Your domain module pattern

**Before reviewing security**:
1. Detect actual project structure (Phase 0)
2. Replace placeholders in security checks
3. Use detected module names in MCP tool verification

## Phase 0: Detect Project Context (MANDATORY)

Before security review, detect actual project structure:
1. List apps: `ls apps/`
2. Detect domain: `mcp__ash_ai__list_ash_resources`
3. Store context for security verification

[Rest of methodology...]
```

---

#### 8. code-review-implement.md
**Status**: ⚠️ Partially Compliant
**Compliance Score**: 70%

**Issues Found**:
1. ⚠️ **No explicit Phase 0 section** (though mentions MyApp AI rules)
2. ⚠️ Uses "MyApp" without clear placeholder syntax in some places
3. ✅ Has TodoWrite usage for tracking
4. ✅ Has quality verification steps
5. ❌ No self-correction checklist for placeholders
6. ❌ Missing meta-instructions about detecting project structure

**Examples of Issues**:

Line 260-273: "MyApp AI Specific Rules" uses literal "MyApp"
```markdown
## 🏗️ MyApp AI Specific Rules

### For Ash Resources:
- Maintain action/validation/policy structure
```

Should be:
```markdown
## 🏗️ Project-Specific Rules (Detect Your Project First)

**Before implementing**:
1. Detect actual project structure with Phase 0
2. Replace `{YourApp}` with detected values

### For Ash Resources (using detected domain):
```

**What Needs to Be Added**:
1. Add Phase 0 detection as first step in workflow
2. Add placeholder explanation section
3. Update "MyApp AI Specific Rules" to use placeholders
4. Add self-correction checklist
5. Ensure all code examples use `{YourApp}` syntax

---

### ❌ NON-COMPLIANT AGENTS

---

#### 9. cytoscape-expert.md
**Status**: ❌ Non-Compliant
**Compliance Score**: 30%

**Critical Issues**:
1. ❌ **NO Phase 0 detection section**
2. ❌ **Extensive use of literal "MyApp" throughout** (lines 128-551)
3. ❌ **No placeholder syntax** - uses "MyApp" as if it's the actual project name
4. ❌ **No self-correction checklist**
5. ❌ **No meta-instructions about placeholders**
6. ❌ Uses literal paths: "MyApp.Graph.GraphNode" without explaining it's an example

**Examples of Critical Issues**:

Lines 128-173: Uses "MyApp" extensively as if it's standard
```elixir
defmodule MyApp.Graph.GraphNode do
  use Ash.Resource,
    domain: MyApp.Graph,
    data_layer: AshPostgres.DataLayer,
```

Lines 176-214: More literal "MyApp" usage
```elixir
defmodule MyAppWeb.Live.GraphComponent do
  use MyAppWeb, :live_component
  alias MyApp.Graph
```

Lines 246-271: Continues pattern
```elixir
defmodule MyApp.Graph.GraphOperations do
  alias MyApp.Graph
```

**This is a MAJOR issue** because:
- Users will copy "MyApp" literally into their code
- No guidance on detecting actual project structure
- No indication these are placeholder patterns
- Will cause immediate compilation failures

**Complete Refactoring Required**:

1. **Add at beginning**:
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `MyApp` → Replace with YOUR project name (Blog, XTweak, Shop)
- `MyAppWeb` → Replace with YOUR web module
- `MyApp.Graph` → Replace with YOUR graph domain module

**Before implementing Cytoscape features**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL "MyApp" references with detected values
3. Verify graph resources exist with MCP tools
```

2. **Add Phase 0**:
```markdown
## Phase 0: Detect Project Context (MANDATORY)

Before implementing ANY Cytoscape integration:

1. **Detect Core App**:
   ```bash
   ls apps/
   # Example: blog_core, xtweak_core
   ```

2. **Detect Domain Pattern**:
   ```
   mcp__ash_ai__list_ash_resources
   # Look for: Blog.Domain, XTweak.Core, etc.
   ```

3. **Store Context**:
   - Replace MyApp → {DetectedProjectName}
   - Replace MyAppWeb → {DetectedProjectName}Web
   - Replace MyApp.Graph → {DetectedProjectName}.Graph
```

3. **Update ALL code examples** to use placeholders:
```elixir
# BEFORE (NON-COMPLIANT):
defmodule MyApp.Graph.GraphNode do
  use Ash.Resource,
    domain: MyApp.Graph,

# AFTER (COMPLIANT):
# Generic Pattern (ADAPT THIS):
defmodule {YourApp}.Graph.GraphNode do
  use Ash.Resource,
    domain: {YourApp}.Graph,

# Example for "Blog" project:
defmodule Blog.Graph.GraphNode do
  use Ash.Resource,
    domain: Blog.Graph,
```

4. **Add Self-Correction Checklist**:
```markdown
## Self-Correction: Before Implementing Cytoscape Features

1. ❓ Did I detect the ACTUAL project structure?
2. ❓ Have I replaced ALL "MyApp" with detected values?
3. ❓ Am I using ACTUAL module names from THIS project?
4. ❓ Did I verify graph resources exist with MCP tools?

If ANY answer is "No" → STOP and complete Phase 0.
```

---

## Compliance Matrix

| Agent | Phase 0 | Placeholders | Meta-Instructions | Self-Correction | Examples | Score |
|-------|---------|--------------|-------------------|-----------------|----------|-------|
| agent-architect | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| code-reviewer | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| ash-resource-architect | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| frontend-design-enforcer | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| test-builder | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| mcp-verify-first | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| security-reviewer | ❌ | ⚠️ | ❌ | ❌ | ⚠️ | 60% |
| code-review-implement | ⚠️ | ⚠️ | ❌ | ❌ | ✅ | 70% |
| cytoscape-expert | ❌ | ❌ | ❌ | ❌ | ❌ | 30% |

---

## Patterns Identified for Extraction

### Pattern 1: Phase 0 Detection Template
**Source**: code-reviewer, ash-resource-architect, frontend-design-enforcer

**Pattern Structure**:
```markdown
## Phase 0: Detect Project Context (MANDATORY FIRST STEP)

Before [implementing/reviewing/testing] ANY [code/resource/feature]:

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

3. **Verify Module Exists**:
   ```
   mcp__tidewave__project_eval code: "h {DetectedDomain}"
   ```

4. **Store Context for Session**:
   - Core app: `{detected_core_app}`
   - Domain: `{detected_domain}`
   - Use these values in ALL [implementations/examples/tests]
```

**Should be extracted to**: `.claude/patterns/phase-0-detection-pattern.md`

---

### Pattern 2: Self-Correction Checklist Template
**Source**: agent-architect, code-reviewer, ash-resource-architect, test-builder

**Pattern Structure**:
```markdown
## Self-Correction: Before [Implementing/Presenting] [Code/Design/Tests]

Ask yourself:

1. ❓ Did I complete Phase 0 to detect the ACTUAL project structure?
2. ❓ Have I replaced ALL `{YourApp}` placeholders with detected values?
3. ❓ Am I using the ACTUAL [domain/module/app] name (not "MyApp")?
4. ❓ Did I verify [implementation/patterns/behavior] with MCP tools?
5. ❓ Are my [code/examples/file paths] using detected values?
6. ❓ Have I tested [functionality] with mcp__tidewave__project_eval?

If ANY answer is "No" → STOP and complete Phase 0 first.

**Additional Placeholder Check**:
- ❌ If I see "MyApp" in my [solution/code] → STOP, detect actual project name
- ❌ If I see "my_app_core" in paths → STOP, detect actual core app name
- ❌ If I haven't run `ls apps/` yet → STOP, detect structure first
- ✅ If all names came from MCP tool outputs → Proceed
```

**Should be extracted to**: `.claude/patterns/self-correction-checklist-pattern.md`

---

### Pattern 3: Placeholder Explanation Header
**Source**: agent-architect, code-reviewer, ash-resource-architect, frontend-design-enforcer

**Pattern Structure**:
```markdown
## 🎯 CRITICAL: Understanding Placeholders

**ALL code examples use PLACEHOLDER SYNTAX**:
- `{YourApp}` → Replace with actual project name (Blog, XTweak, Shop, etc.)
- `{YourApp}Core` → Replace with core app name (blog_core, xtweak_core, etc.)
- `{YourApp}Web` → Replace with web module (BlogWeb, XTweakWeb, etc.)
- `{YourApp}.Domain` → Replace with domain module (Blog.Domain, XTweak.Core, etc.)
- `{ResourceName}` → Replace with specific resource (User, Post, Product, etc.)
- `MyApp` in examples → Generic placeholder, NEVER use literally

**Before [implementing/designing/testing] ANYTHING**:
1. Complete Phase 0 to detect actual project structure
2. Replace ALL placeholders with detected values
3. Verify adapted code matches project patterns

## Why Placeholders?

**Without placeholders (WRONG)**:
```elixir
# Agent shows:
defmodule MyApp.Domain.User do
  use Ash.Resource, domain: MyApp.Domain

# User copies literally → FAILS!
defmodule MyApp.Domain.User do  # ← Wrong! Their project is "Blog"
```

**With placeholders (CORRECT)**:
```elixir
# Agent shows pattern:
defmodule {YourApp}.Domain.User do
  use Ash.Resource, domain: {YourApp}.Domain

# Agent detects → Blog
# User gets:
defmodule Blog.Domain.User do
  use Ash.Resource, domain: Blog.Domain
```
```

**Should be extracted to**: `.claude/patterns/placeholder-explanation-header.md`

---

### Pattern 4: Dual-Example Pattern (Generic + Concrete)
**Source**: ash-resource-architect, code-reviewer, frontend-design-enforcer

**Pattern Structure**:
```markdown
## [Feature] Pattern

### Generic Pattern (ADAPT THIS)
```elixir
# This shows the STRUCTURE - replace placeholders:
defmodule {YourApp}.{Domain}.{Resource} do
  use Ash.Resource,
    domain: {YourApp}.{Domain}

  # ... implementation ...
end
```

### Example 1: Blog Project
```elixir
# Concrete example for "Blog" project with User resource:
defmodule Blog.Domain.User do
  use Ash.Resource,
    domain: Blog.Domain

  # ... implementation ...
end
```

### Example 2: Shop Project
```elixir
# Concrete example for "Shop" project with Product resource:
defmodule Shop.Domain.Product do
  use Ash.Resource,
    domain: Shop.Domain

  # ... implementation ...
end
```

### Your Implementation
After Phase 0 detection, YOUR code should be:
```elixir
# If YOUR project is "XTweak" with User resource:
defmodule XTweak.Core.User do
  use Ash.Resource,
    domain: XTweak.Core
end
```
```

**Should be extracted to**: `.claude/patterns/dual-example-pattern.md`

---

## Recommended Actions

### Immediate Priority (Critical)

1. **Refactor cytoscape-expert.md** (❌ 30% compliance)
   - Add Phase 0 detection section
   - Replace ALL "MyApp" with `{YourApp}` placeholders
   - Add placeholder explanation header
   - Add self-correction checklist
   - Provide dual examples (generic + concrete)
   - **Estimated effort**: 2-3 hours

2. **Update security-reviewer.md** (⚠️ 60% compliance)
   - Add Phase 0 detection section before methodology
   - Add placeholder explanation header
   - Update examples to use placeholders
   - Add self-correction checklist
   - **Estimated effort**: 1-2 hours

3. **Update code-review-implement.md** (⚠️ 70% compliance)
   - Add Phase 0 detection as first workflow step
   - Add placeholder explanation header
   - Update "MyApp AI Specific Rules" to use placeholders
   - Add self-correction checklist
   - **Estimated effort**: 1 hour

### Secondary Priority (Pattern Extraction)

4. **Extract patterns to `.claude/patterns/` directory**:
   - `phase-0-detection-pattern.md`
   - `self-correction-checklist-pattern.md`
   - `placeholder-explanation-header.md`
   - `dual-example-pattern.md`
   - **Estimated effort**: 30 minutes

5. **Create pattern index**: `.claude/patterns/README.md`
   - Document each pattern
   - Show when to use each pattern
   - Link to agents that use the pattern
   - **Estimated effort**: 15 minutes

### Long-term Improvements

6. **Create agent template**: `.claude/patterns/agent-template.md`
   - Standardized structure for all agents
   - Built-in Phase 0 section
   - Placeholder explanation header
   - Self-correction checklist
   - **Estimated effort**: 30 minutes

7. **Add validation script**: `.claude/scripts/validate-agent-compliance.sh`
   - Check for Phase 0 presence
   - Verify placeholder usage
   - Ensure self-correction checklist exists
   - Flag "MyApp" usage without explanation
   - **Estimated effort**: 1 hour

---

## Success Metrics

### Compliance Targets
- **Current state**: 6 fully compliant, 2 partial, 1 non-compliant
- **Target state**: 9 fully compliant (100%)
- **Immediate goal**: Bring all agents to minimum 80% compliance

### Quality Indicators
- ✅ All agents have Phase 0 detection
- ✅ No literal "MyApp" usage without placeholder explanation
- ✅ All code examples show generic + concrete patterns
- ✅ All agents have self-correction checklists
- ✅ Consistent pattern usage across all agents

---

## Conclusion

**Overall Assessment**: The agent ecosystem is in good shape with 67% (6/9) fully compliant agents. The compliant agents demonstrate excellent patterns that should be replicated.

**Key Strengths**:
- Strong foundational patterns in place (Phase 0, placeholders, self-correction)
- Excellent examples in agent-architect, code-reviewer, and ash-resource-architect
- Consistent MCP-first methodology across agents

**Key Weaknesses**:
- cytoscape-expert needs complete refactoring
- security-reviewer and code-review-implement need Phase 0 additions
- Missing centralized pattern documentation

**Recommendation**:
1. **Immediately** refactor the 3 non-compliant/partial agents
2. **Extract patterns** for reuse in future agents
3. **Create validation tooling** to prevent regression

**Estimated Total Effort**: 5-6 hours for all improvements

---

## Appendix: Pattern Locations

### Agents with Excellent Patterns

**Best Phase 0 Implementation**:
- `code-reviewer.md` (lines 75-108)
- `ash-resource-architect.md` (lines 95-147)

**Best Placeholder Explanation**:
- `agent-architect.md` (lines 80-93)
- `ash-resource-architect.md` (lines 60-72)

**Best Self-Correction Checklist**:
- `agent-architect.md` (lines 259-270)
- `mcp-verify-first.md` (lines 348-365)

**Best Dual-Example Pattern**:
- `ash-resource-architect.md` (lines 254-426)
- `frontend-design-enforcer.md` (lines 276-324)

---

**Report Generated**: 2025-10-01
**Reviewed By**: Agent Architect Analysis System
**Next Review Date**: After implementing recommended changes
