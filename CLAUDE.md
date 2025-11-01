# Claude Code Guidelines · xTweak

> **📋 MANDATORY**: Read [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) first – These rules override all instructions below.

## Essential Reading (in order)

1. [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) – Mandatory rules that override everything
2. [.claude/README.md](./.claude/README.md) – Agent matrix, workflows, model strategy, patterns
3. [AI_docs/README.md](./AI_docs/README.md) – Complete AI documentation index
4. [AI_docs/prd/QUICK_START.md](./AI_docs/prd/QUICK_START.md) – Current PRD status
5. [Current sprint plan] – Auto-loaded based on PRD phase
6. [/usage-rules.md](./usage-rules.md) – Framework overview index
7. [/usage-rules/](./usage-rules/) – Framework rules and xTweak-specific patterns
8. [.claude/patterns/](.//.claude/patterns/) – Reusable execution patterns

## Additional References

- [.claude/patterns/README.md](./.claude/patterns/README.md) – Pattern library details
- [.claude/commands/](./.claude/commands/) – PRD-centric slash commands

## How to Use This Playbook

- Treat this document as the high-level contract; detailed instructions live in `.claude/README.md` and pattern library (`.claude/patterns/README.md`).
- Read `.claude/README.md` for agent matrix, workflows, and model selection strategy.
- Load the **Core Pattern Stack** (`placeholder-basics`, `phase-zero-context`, `mcp-tool-discipline`, `self-check-core`, `dual-example-bridge`) before implementing anything.

---

## 🎯 PROMPT ANALYSIS & AGENT ROUTING (MANDATORY FOR ALL PROMPTS)

### Overview: The Clarification-First Approach

**WHO IS IN THE DRIVING SEAT**: Base Claude is ALWAYS the coordinator for non-slash-command prompts. You analyze prompts, clarify ambiguity, select agents, and synthesize results.

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

#### 1.2 Load Architecture Rules

**Based on request classification** (see Step 2), read applicable files:

| Request Type | Required Usage Rules |
|--------------|---------------------|
| Backend/Ash Resource | `/usage-rules/ash.md`, `/usage-rules/ash_postgres.md` |
| LiveView/Frontend | `/usage-rules/heex.md`, `/usage-rules/ash_phoenix.md` |
| Template Work | `/usage-rules/heex.md` |
| Generators | `/usage-rules/igniter.md` |
| All Requests | `/usage-rules.md` (overview) |

#### 1.3 Load Core Patterns

**Read these patterns** (in order):
1. `.claude/patterns/placeholder-basics.md`
2. `.claude/patterns/phase-zero-context.md`
3. `.claude/patterns/mcp-tool-discipline.md`
4. `.claude/patterns/self-check-core.md`
5. `.claude/patterns/dual-example-bridge.md`

#### 1.4 Output Confirmation

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

**Architecture Rules Loaded**:
- [List files read, e.g., ash.md, heex.md]

**Patterns Loaded**:
- placeholder-basics, phase-zero-context, mcp-tool-discipline, self-check-core, dual-example-bridge

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

  **Architecture Rules Available**:
  You have access to these loaded rules:
  - [List files that were read in Step 1.2]

  **Your Task**:
  [Specific instructions based on request type and classification]

  **Requirements**:
  - Follow all loaded architecture rules from /usage-rules/
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

## 🚨 MANDATORY PRE-TASK PROTOCOL (ALL TASKS)

**This section applies AFTER Step 0-1 (clarification) and IS Step 1 above**

See Step 1 in "Prompt Analysis & Agent Routing" section for full details.

**Quick Checklist**:
- [ ] Phase Zero detection complete (apps, domain, resources detected)
- [ ] Architecture rules loaded (based on request type)
- [ ] Core patterns loaded (5 patterns)
- [ ] Confirmation output displayed

**If any step fails**: STOP and request clarification or escalate.

---

## Project Snapshot (October 30, 2025)

- **Umbrella apps**: `xtweak_core` (Ash domain logic), `xtweak_web` (Phoenix + LiveView), `xtweak_docs` (documentation), `xtweak_ui` (component library).
- **Domain module**: `XTweak.Core`.
- **Web namespace**: `XTweakWeb`.
- **Frontend stack**: Tailwind CSS (no component framework), validated with Playwright MCP tools.
- **Data layer**: Ash Framework 3.7.6+ over Postgres—no direct Ecto schemas or Repo calls.
- **Recent updates**: AI workflow refactor complete (2025-10-30) - PRD-centric commands, consolidated documentation, usage_rules integration.

## 5 Critical Principles (Read Before Every Session)

1. **MCP first** – Verification beats assumption. Use Tidewave/Ash/Context7 MCP tools before writing or editing code.
2. **Ash everywhere** – Model data with Ash resources/actions/policies. Generators + `ash-resource-template` pattern are mandatory starting points.
3. **Respect umbrella boundaries** – Core has no web deps; web depends on core only. Keep interfaces clean.
4. **Generator-first, customize second** – Check `mcp__ash_ai__list_generators`, run scaffold with `--yes`, then extend safely.
5. **Quality gates** – Run `mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`, and targeted `mix test` before declaring success.

## Placeholder Discipline

- All shared examples use `{Placeholder}` tokens. See `placeholder-basics.md` for the canonical explanation and wrong/right examples.
- Always perform `phase-zero-context` to detect real module names, then replace every token before responding.

## Recommended Workflow (per task)

- **Implementation**: `mcp-verify-first` → domain-specific agent (e.g., `ash-resource-architect`, `frontend-design-enforcer`) → `code-reviewer`/`code-review-implement` for validation.
- **Reviews**: `mcp-verify-first` → `code-reviewer` (analysis) → `code-review-implement` (fixes) → rerun `code-reviewer`.
- **Testing**: `mcp-verify-first` → `test-builder` → targeted `mix test` commands → document with `collaboration-handoff`.
- **Security**: `mcp-verify-first` → `security-reviewer` → follow up with owners.

See [.claude/README.md](./.claude/README.md) for complete workflows.

## Tooling Cheat Sheet

- **Tidewave MCP**: `project_eval`, `get_docs`, `get_logs`, `search_package_docs`, `get_ecto_schemas`, `execute_sql_query` (debug only).
- **Ash AI MCP**: `list_ash_resources`, `list_generators`, `get_usage_rules` (discovers usage rules from deps).
- **Context7 MCP**: `resolve-library-id`, `get-library-docs` (fallback for non-Elixir libraries when specific MCP unavailable).
- **Nuxt UI MCP**: `list_components`, `get_component`, `get_component_metadata`, `search_components_by_category` (component API research, design system specs).
- **Playwright MCP**: browser navigation, screenshots, console capture for UI verification.

## Elixir/Ash Framework Rules

**All framework rules are now in `/usage-rules/`** at project root:
- [/usage-rules.md](./usage-rules.md) – Overview and index of all framework rules
- [/usage-rules/](./usage-rules/) – Individual framework rule files

**Core Files**:
- **Core**: [usage-rules/ash.md](./usage-rules/ash.md) – Ash framework patterns
- **Data Layer**: [usage-rules/ash_postgres.md](./usage-rules/ash_postgres.md) – Database patterns
- **Web Integration**: [usage-rules/ash_phoenix.md](./usage-rules/ash_phoenix.md) – Phoenix/LiveView patterns
- **AI Integration**: [usage-rules/ash_ai.md](./usage-rules/ash_ai.md) – AI integration patterns
- **Authentication**: [usage-rules/ash_authentication.md](./usage-rules/ash_authentication.md) – Auth patterns
- **Templates**: [usage-rules/heex.md](./usage-rules/heex.md) – HEEx template conventions
- **Code Generation**: [usage-rules/igniter.md](./usage-rules/igniter.md) – Generator patterns

**Agents should**: Read relevant files from `/usage-rules/` for all framework guidance

## Usage Rules (Automatic Discovery)

Package usage rules are **automatically discovered** via the Ash AI MCP server (`mcp__ash_ai__get_usage_rules`). No manual sync required!

**How it works**:
- MCP server scans `deps/` for `usage-rules.md` files
- Currently available: 17 rule files from ash, phoenix, igniter, and more
- Agents read relevant rules on-demand based on task context
- Always current with installed package versions

**Human-readable copies** maintained in `/usage-rules/` for reference.

## Quality Gates & Commands

```bash
mix format
mix credo --strict
mix compile --warnings-as-errors
mix test --only <tag>
mix test apps/xtweak_core/test/xtweak/core/<resource>_test.exs
mix ash_postgres.generate_migrations
```

## Git & Change Control

- Never commit/push without explicit direction.
- Use `TodoWrite` to manage multi-step edits; clear tasks before handing off.
- Summaries for handoffs should follow `collaboration-handoff` pattern (summary, artifacts, outstanding items, validation, next steps).

## Reference Material

- `.claude/README.md` – **Single reference** for agents (matrix, workflows, model strategy, patterns)
- `.claude/patterns/README.md` – Pattern library index
- `.claude/patterns/documentation-organization.md` – **Documentation placement rules** (where docs belong: project/app/AI)
- `.claude/patterns/mcp-tool-discipline.md` – Pattern change log tracked in individual pattern files
- `.claude/commands/` – PRD-centric slash commands (5 commands)
- `AI_docs/prd/06-sprint-plans/` – Sprint plans with REPORTS.md (agent execution logs)
- `/usage-rules.md` and `/usage-rules/` – Framework rules and xTweak-specific patterns
- [AI_docs/README.md](./AI_docs/README.md) – Complete AI documentation index

**Documentation Organization**: Before creating/placing documentation, check `.claude/patterns/documentation-organization.md` for three-tier structure (Human_docs/ for project-wide, apps/{app}/docs/ for app-specific, AI_docs/ for AI-facing).

Stay pattern-first, cite MCP evidence, and keep responses sharp and scannable.
