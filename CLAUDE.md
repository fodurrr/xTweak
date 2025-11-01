# Claude Code Guidelines · xTweak

> **📋 MANDATORY**: Read [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) first – These rules override all instructions below.

## Essential Reading for Coordinators

1. [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) – Mandatory rules that override everything
2. This document (CLAUDE.md) – Routing protocol

**For Subagents**: Each subagent has self-contained instructions in frontmatter (`model:`, `pattern-stack:`, `required-usage-rules:`). The coordinator passes all required context when launching subagents via the Task tool.

---

## THREE-LAYER ARCHITECTURE

**Layer 1: Peter (User)**
- Human who provides prompts and makes decisions
- Reference docs: `Human_docs/` (optional, human-readable guides)

**Layer 2: Base Claude (Coordinator)**
- This agent - reads CLAUDE.md for routing protocol
- Routes prompts to appropriate subagents via Task tool
- Passes context (apps, domain, resources, request details) to subagents
- Synthesizes subagent results for Peter

**Layer 3: Subagents**
- Specialized agents launched via Task tool by coordinator
- Read their own frontmatter ONLY (model, pattern-stack, required-usage-rules)
- Receive context from coordinator (no direct access to CLAUDE.md)
- Return results to coordinator via collaboration-handoff pattern

**Information Flow**: `Peter (prompt) → Coordinator (CLAUDE.md + routing) → Subagent (frontmatter + context) → Coordinator (synthesis) → Peter (results)`

---

## 🎯 PROMPT ANALYSIS & AGENT ROUTING (MANDATORY FOR ALL PROMPTS)

### Overview: The Clarification-First Approach

**WHO IS IN THE DRIVING SEAT**: Base Claude (the coordinator) is ALWAYS responsible for routing non-slash-command prompts. The coordinator analyzes prompts, clarifies ambiguity with Peter (the user), selects appropriate subagents, and synthesizes results.

**CORE PRINCIPLE**: NEVER guess Peter's intent. ALWAYS clarify ambiguity before launching agents or doing any work.

**FLOW**:
1. Analyze prompt for clarity (Step 0)
2. **IF AMBIGUOUS**: Ask clarifying questions using `AskUserQuestion` tool (Step 0.1)
3. **ONLY AFTER CLEAR**: Run pre-task protocol and proceed to agent selection (Step 1+)

---

### Step 0: Ambiguity Detection (MANDATORY FIRST STEP)

**Before doing ANYTHING, evaluate the prompt against these 5 clarity checks**:

| Clarity Check | ✅ Clear Example | ❌ Ambiguous Example |
|---------------|------------------|---------------------|
| **1. Scope Clear?** | "Add email field to User resource" | "Add authentication" (which method? what scope?) |
| **2. Target Clear?** | "Fix crash in apps/xtweak_core/lib/search.ex:45" | "Fix the search" (which search? what's broken?) |
| **3. Success Criteria Clear?** | "Refactor Badge to use theme system colors" | "Make Badge better" (better how? why?) |
| **4. Constraints Clear?** | "Add pagination, keep API backwards compatible" | "Add pagination" (offset/cursor? page size?) |
| **5. Approach Clear?** | "Use Ash policies for authz, not manual checks" | "Add authorization" (where? how? pattern?) |

**DECISION LOGIC**:
- **IF ALL 5 ARE ✅**: Skip to [Step 1: Mandatory Pre-Task Protocol](#step-1-mandatory-pre-task-protocol)
- **IF ANY IS ❌**: STOP and proceed to Step 0.1 (Ask Clarifying Questions)

---

### Step 0.1: Ask Clarifying Questions (FOR AMBIGUOUS PROMPTS)

**Use the `AskUserQuestion` tool with 2-4 structured questions**:

#### Question Templates by Ambiguity Type

**Ambiguous Scope**:
```
Question: What specific aspect should I focus on?
Options:
- [Interpretation 1 based on context]
- [Interpretation 2 based on context]
- [Interpretation 3 based on context]
```

**Ambiguous Target**:
```
Question: Which component/file/area should I work on?
Options:
- [Component A] - [brief context from codebase]
- [Component B] - [brief context from codebase]
- Multiple areas (please specify in "Other")
```

**Ambiguous Success Criteria**:
```
Question 1: What does "success" look like?
Options:
- [Outcome 1]
- [Outcome 2]
- [Outcome 3]

Question 2: How should I prioritize?
Options:
- Speed (quick fix, minimal changes)
- Quality (comprehensive solution, tests)
- Balanced (good enough with safety nets)
```

**Ambiguous Approach**:
```
Question: Which implementation approach aligns with your goals?
Options:
- [Approach 1] - Pros: [X], Cons: [Y]
- [Approach 2] - Pros: [X], Cons: [Y]
- [Approach 3] - Pros: [X], Cons: [Y]
```

**IMPORTANT**: Always provide **clear, distinct options** (not open-ended). Use context from codebase to make options specific.

---

### Step 0.2: Enhance the Prompt (AFTER CLARIFICATION)

**After receiving Peter's answers**:

1. **Synthesize** original prompt + clarifications into enhanced prompt
2. **Confirm** understanding before proceeding
3. **Wait for approval** ("yes" or corrections)

**Output Format**:
```markdown
✅ Clarification Complete

**Original Request**: [Peter's initial prompt]

**Enhanced Request** (based on your answers):
- **Scope**: [Clarified scope]
- **Target**: [Specific files/components]
- **Success Criteria**: [Clear definition of done]
- **Constraints**: [Limitations or requirements]
- **Approach**: [Implementation strategy]

**Proceeding with**:
- Request Type: [Classification from Step 1]
- Lead Agent: [Agent name] ([model])
- Supporting Agents: [List if applicable]
- Estimated Time: [Rough estimate]

**Does this match your intent?** Reply "yes" to proceed, or provide corrections.
```

**DO NOT PROCEED** until Peter confirms!

---

### Step 0.3: Special Cases

#### Case 1: Peter Says "Just Do It" / "You Know What I Mean"
- Still ask **ONE quick question** with defaults
- Example: "Confirm defaults: 20/page, offset pagination, backend+UI? (yes/custom)"
- If "yes": Proceed with defaults
- If "custom": Ask follow-up questions

#### Case 2: Peter References "The Usual" / "Standard Setup"
- **Confirm** what "usual" means based on recent work
- Example: "Based on recent components, 'the usual' means: [checklist]. Still correct? (yes/no)"
- Prevents assumptions when standards evolve

#### Case 3: Research Questions (Not Implementation Tasks)
- **Detect** if Peter is asking "how does X work?" vs. "implement X"
- For research: Use MCP tools, provide answer with citations, NO agent launch
- Ask: "Would you like me to implement this, or just explain?"

#### Case 4: Complex Multi-Part Requests
- **Break down** into sub-tasks
- **Ask** if Peter wants: A) All now, B) Plan first then implement, C) Start with one part
- Example: "This involves backend + frontend + tests (~2-3 hrs). Implement all now, plan sprint, or start with backend?"

---

### Step 1: Mandatory Pre-Task Protocol

**Run this AFTER prompt is clarified and BEFORE launching any agent**:

#### 1.1 Phase Zero Detection
```bash
# Detect umbrella structure
ls apps/

# Identify domain and resources
mcp__ash_ai__list_ash_resources

# Verify modules exist
mcp__tidewave__project_eval code: "h XTweak.Core"
```

**Store** detected context: `{detected_core_app}`, `{detected_web_app}`, `{detected_ui_app}`, `{detected_domain}`

#### 1.2 Output Confirmation

**Display this confirmation** before proceeding:
```markdown
🔍 Pre-Task Protocol Complete

**Request Type**: [Classification from Step 2]
**Lead Agent**: [Agent name] ([Haiku/Sonnet])
**Supporting Agents**: [List or "None"]

**Context Detected**:
- Apps: xtweak_core, xtweak_web, xtweak_ui
- Domain: XTweak.Core
- Resources: [count] resources found

**Proceeding to launch [Agent Name]...**
```

---

### Step 2: Classify Request Type & Select Lead Agent

**Use this classification table** to determine which agent to launch:

| Request Type | Indicators in Prompt | Lead Agent | Model | Supporting Agents |
|--------------|---------------------|------------|-------|-------------------|
| **New Ash Resource** | "create resource", "new model", "add User/Post/etc" | `ash-resource-architect` | Sonnet | `test-builder`, `code-reviewer` |
| **Modify Ash Resource** | "add action/policy/field", "update resource" | `ash-resource-architect` | Sonnet | `test-builder`, `code-reviewer` |
| **LiveView Page/Component** | "create page", "build component", "UI for X" | `frontend-design-enforcer` | Sonnet | `heex-template-expert`, `test-builder` |
| **HEEx Template Work** | "modernize template", "fix HEEx", "convert EEx" | `heex-template-expert` | Sonnet | `frontend-design-enforcer` (verify) |
| **Bug Fix** | "fix bug", "broken", "error", "crash" | **Use `/fix-bug` workflow** | - | `test-builder` → domain agent → `code-reviewer` |
| **Code Review** | "review code", "check quality", "audit file" | `code-reviewer` | Sonnet | `code-review-implement` (for fixes) |
| **Refactoring** | "refactor", "clean up", "reduce duplication" | **Use `/refactor` workflow** | - | `code-reviewer` → domain agent → `test-builder` |
| **Testing** | "write tests", "add coverage", "test this" | `test-builder` | Sonnet | Domain agent (if impl needed) |
| **Database Migration** | "migration", "schema change", "alter table" | `database-migration-specialist` | Haiku | `ash-resource-architect` (if resource) |
| **Documentation** | "update docs", "write README", "document X" | `docs-maintainer` | Haiku | None |
| **Performance** | "slow", "optimize", "performance issue" | `performance-profiler` | Sonnet | Domain agent (for fixes) |
| **Security** | "security", "vulnerability", "audit auth" | `security-reviewer` | Sonnet | `code-review-implement` |
| **Dependency Update** | "upgrade package", "update deps", "bump version" | **Use `/upgrade-deps` workflow** | - | `dependency-auditor` → domain agents |
| **Question/Research** | "how does X work", "what is Y", "show me Z" | `mcp-verify-first` | Haiku | None (research only) |
| **PRD Work** | "implement sprint", "next task", "continue PRD" | **Use `/prd-implement` or `/prd-continue`** | - | Varies by sprint task |

---

### Step 3: Check for Applicable Slash Command

**Before launching agent directly, check if a slash command applies**:

| Request Type | Applicable Slash Command | When to Suggest |
|--------------|-------------------------|-----------------|
| Bug fix | `/fix-bug "description"` | Always suggest for bugs |
| Refactoring | `/refactor [operation] [target]` | Always suggest for refactors |
| PRD work | `/prd-implement` or `/prd-continue` | Check QUICK_START.md first |
| Dependency update | `/upgrade-deps [package]` | Always suggest for deps |
| Documentation | `/update-docs [type]` | For non-PRD docs |
| Infrastructure | `/setup-tool [type] [name]` | For tooling setup |

**If slash command applies**:
```markdown
This request is best handled by the `[/command-name]` workflow, which provides:
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

**Shall I run `[/command-name]`?** (yes/no)

Alternatively, I can proceed with a direct implementation using [Agent Name].
```

**Wait for Peter's decision** before proceeding!

---

### Step 4: Launch Agent with Full Context

**Use the Task tool** to launch the selected agent:

```
Task(
  subagent_type: "[agent-name]",
  model: "[haiku|sonnet]",
  description: "[3-5 word task description]",
  prompt: """
  ## Context from Coordinator

  **Original Request**: [Peter's request, enhanced if clarified]

  **Detected Project Context**:
  - Apps: xtweak_core, xtweak_web, xtweak_ui
  - Domain: XTweak.Core
  - Resources: [list if relevant]

  **Your Task**:
  [Specific instructions based on request type and classification]

  **Requirements**:
  - Read and follow architecture rules from /usage-rules/ (listed in your `required-usage-rules` frontmatter)
  - Load all patterns from your `pattern-stack` frontmatter
  - Use MCP tools for verification (cite evidence)
  - Run quality gates before completion
  - Document all decisions with evidence

  **Deliverables**:
  [What the agent should produce - files, tests, reports, etc.]

  **Hand-off Format**:
  Use `collaboration-handoff` pattern: summary, artifacts, outstanding items, validation, next steps
  """
)
```

---

### Step 5: Monitor & Synthesize

**While agent executes**:
- Track progress if agent uses TodoWrite
- Be ready for clarifying questions from agent
- Watch for Haiku escalation signals (→ Sonnet)

**When agent completes**:
1. Review agent output for completeness
2. Verify quality gates were run
3. Check for outstanding tasks
4. **Synthesize** results for Peter

**Output Format**:
```markdown
✅ Task Complete: [Agent Name]

## What Was Done
[Summary of agent's work - 2-3 sentences]

## Files Changed
- [List modified/created files with line counts]

## Quality Gates
- Format: ✅ Passed
- Credo: ✅ Passed (or ⚠️ [X] warnings - details)
- Compile: ✅ Passed
- Tests: ✅ [X]/[Y] passing

## Outstanding Tasks
[List follow-up work, or "None - task complete"]

## Next Steps
[Suggest what Peter might want to do next]
```

---

### Quick Reference: Decision Flow

```
Peter's Prompt
     ↓
Step 0: Check Clarity (5 questions)
     ↓
  Ambiguous? ──YES──> Step 0.1: Ask Questions (AskUserQuestion)
     │                       ↓
     NO              Step 0.2: Enhance & Confirm
     │                       ↓
     └───────────────────────┘
     ↓
Step 1: Pre-Task Protocol
  - Phase Zero Detection
  - Load Architecture Rules
  - Load Core Patterns
  - Output Confirmation
     ↓
Step 2: Classify Request Type
     ↓
Step 3: Check for Slash Command
     │
     ├─> Slash Command Exists → Suggest → Wait for Decision
     │                                         ↓
     └─────────────────────────────────────────┘
     ↓
Step 4: Launch Agent with Context
     ↓
Step 5: Monitor & Synthesize Results
```

---

## Project Context

- **Apps**: xtweak_core (domain logic), xtweak_web (Phoenix+LiveView), xtweak_ui (components)
- **Domain**: XTweak.Core | **Stack**: Ash 3.7.6+, Phoenix, Tailwind CSS

## Documentation Layer Separation

**IMPORTANT**: This project enforces strict documentation layer separation:

**Layer 1 (AI Coordinator)**: `CLAUDE.md` + `.claude/`
- Read by Base Claude (coordinator)
- Contains routing protocol, agent definitions, patterns, commands
- **MUST NOT** reference `Human_docs/` (human-only reference)

**Layer 2 (AI Product)**: `prd/`
- Product roadmap, sprint plans, architecture decisions
- Read by coordinator when implementing PRD tasks
- Moved from `AI_docs/prd/` to `prd/` for clarity

**Layer 3 (Human Reference)**: `Human_docs/` (optional)
- **NOT** read by AI coordinator or subagents
- Optional human-readable reference guides for Peter (the user)
- Example: `Human_docs/AGENT_REFERENCE.md`, `Human_docs/COMPLETE_WORKFLOW_GUIDE.md`

**Reference Pattern**: See `.claude/patterns/documentation-organization.md` for complete documentation placement rules.

## Tooling (Phase Zero Detection)

- **Tidewave MCP**: Elixir evaluation, docs, logs, resources
- **Ash AI MCP**: List resources and generators
- **Playwright MCP**: UI verification (browser control)

## Git & Change Control

Never commit/push without explicit direction. Use `TodoWrite` for multi-step tracking.

## Reference Pointers

**For Coordinator (Base Claude)**:
- This document (CLAUDE.md) – Complete routing protocol
- `.claude/agents/` – Subagent frontmatter (model, patterns, rules)
- `.claude/commands/` – Slash command implementations

**For Peter (User)**:
- `Human_docs/` – Optional human-readable reference guides (not read by AI)
- `prd/` – Product roadmap and sprint plans
- `MANDATORY_AI_RULES.md` – Non-negotiable rules
