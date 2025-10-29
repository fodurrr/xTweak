# Working With Claude’s Agent Workflow

This guide is written for developers using Claude Code on **xTweak**. You don’t need to micro-manage every agent, but knowing how the workflow is wired will help you give Claude the right prompts and understand what to expect.

---

## Why the Workflow Matters

- Claude now has a pattern-first setup: every agent shares the same rules about placeholders, verification, and hand-offs. When your prompt matches this structure you get higher-quality results with fewer clarifications.
- Certain steps (context detection, tool usage, quality gates) are enforced automatically by the agents. If you see Claude pause to “spin up context,” that’s the system doing the mandated checks.
- When you understand the sequence, you can steer Claude (“please start with a review”, “run the UI pass”) and interpret the output (“this summary came from the hand-off pattern, I know what to do next”).

---

## What You Do vs. What Claude Does

| Stage | Your Role (Developer) | Claude’s Role (Agents) |
| --- | --- | --- |
| Kickoff | Describe the task, mention if it’s backend/frontend/test/security, share relevant files or goals. | `mcp-verify-first` auto-detects project context (apps, domain, resources, generators) before anything else. |
| Implementation Planning | Optional: ask Claude to sketch a Todo list or confirm the plan. | Agents load the core pattern stack (placeholder handling, evidence gathering, self-check) behind the scenes. |
| Execution | Review Claude’s proposals. Approve, tweak, or ask for alternatives. | Domain-specific agents do the work (e.g., `ash-resource-architect`, `frontend-design-enforcer`) and log evidence. |
| Validation | Ask for tests, screenshots, or quality gates if they’re not already included, or simply review the checklist Claude provides. | `test-builder`, Playwright commands, and quality-gate steps run as part of each agent’s script. |
| Wrap-up | Decide the next human action: merge, run locally, or open a follow-up task. | Agents output a structured hand-off (summary, artifacts, outstanding items, next steps) via the collaboration pattern. |

You never run MCP commands manually; Claude does it. Your job is to give clear intent and react to the outputs.

---

## Prompting Tips for Developers

1. **Be explicit about the kind of work.** Phrases like “implement a new Ash resource,” “build a LiveView page,” or “write tests” help Claude pick the right agent chain.
2. **Mention constraints or priorities.** Example: "Use Tailwind utilities," "focus on authorization," or "keep the API backward compatible."
3. **Ask for the artifacts you care about.** If you want code diffs, UI screenshots, or a test plan, say so—agents already know how to fetch them.
4. **Let Claude know the next step.** When Claude hands off a summary, tell it whether you want to proceed to the next agent (“okay, run the UI pass”) or wrap up.

---

## Quick Agent Cheat Sheet

| Need | Agent |
| --- | --- |
| Verified ground truth | `mcp-verify-first` |
| Ash resource design | `ash-resource-architect` |
| LiveView / Tailwind implementation | `frontend-design-enforcer` |
| Cytoscape graph work | `cytoscape-expert` |
| Documentation & changelog updates | `docs-maintainer` |
| Release readiness | `release-coordinator` |
| Dependency audits & upgrades | `dependency-auditor` |
| Complex migrations/backfills | `database-migration-specialist` |
| Performance investigations | `performance-profiler` |
| API contract protection | `api-contract-guardian` |
| CI/CD tuning | `ci-cd-optimizer` |
| Observability setup | `monitoring-setup` |
| Test writing / TDD | `test-builder` |
| Code audit (no edits) | `code-reviewer` |
| Apply review fixes | `code-review-implement` |
| Security assessment | `security-reviewer` |
| Pattern compliance audit | `pattern-librarian` |
| Author new agents | `agent-architect` |

---

## Typical End-to-End Scenarios

### A. New Feature Slice (Backend + Frontend)
1. Request: “Implement a reputation leaderboard page with Ash resource changes and LiveView UI.”
2. Claude runs `mcp-verify-first`, proposes a plan, and begins with `ash-resource-architect` if backend changes are needed.
3. You approve the plan. Claude executes backend updates, then moves to `frontend-design-enforcer` (pulling utility strategy from `tailwind-strategist`), followed by `test-builder` and `code-reviewer`/`code-review-implement` as required.
4. Each stage ends with a hand-off summary so you can stop, adjust, or continue.

### B. Pure Frontend Tweak
1. Request: “Tighten spacing on the dashboard card and make it responsive.”
2. Claude still runs the context detection automatically, then `frontend-design-enforcer` handles the change, pulling DaisyUI docs and Playwright screenshots.
3. You review the screenshot/results and either accept or ask for more iterations.

### C. Debug/Test Fix
1. Request: “Tests failing in `user_live_test.exs`, please diagnose and fix.”
2. `mcp-verify-first` gathers context; `test-builder` reproduces the failure, creates Todo items, and works through fixes. If code edits are needed, the relevant implementation agent takes over.
3. Final summary shows which failures were fixed, remaining issues (if any), and which commands were run.

### D. Preparing a Release
1. Request: “Cut a release candidate for the latest sprint.”
2. Claude runs `dependency-auditor` if necessary, executes focused checks with `test-builder`, then `release-coordinator` compiles readiness notes and changelog drafts.
3. `docs-maintainer` finalizes developer-facing documentation before handoff.

### E. Pattern or Documentation Overhaul
1. Request: “Update the placeholder pattern and ensure all agents reference it.”
2. `pattern-librarian` audits pattern files, bumps versions, and flags agents needing updates.
3. `docs-maintainer` mirrors the changes in developer guides.

### F. Observability Upgrade
1. Request: “Add telemetry for the new reputation leaderboard.”
2. `monitoring-setup` proposes logging/metrics changes and TODOs.
3. The relevant implementation agent applies instrumentation, then `docs-maintainer` records new dashboards and runbooks.

### G. API Contract Review
1. Request: “Ensure the new endpoint doesn’t break our customers.”
2. `api-contract-guardian` regenerates specs, runs contract tests, and flags breaking changes with mitigation steps.
3. Coordinate with `docs-maintainer` and `release-coordinator` for comms and release notes.

---

## Understanding the Outputs

- **Evidence Blocks** – Expect commands, logs, or doc excerpts because `mcp-tool-discipline` requires proof. This is confirmation that Claude didn’t guess.
- **Dual Examples** – When Claude shows code, you’ll see generic + XTweak versions. This is normal; copy the XTweak example into your code reviews.
- **Self-Check Confirmation** – At the end of a run you may see a line like “Self-check complete.” That means the agent verified placeholders, context, evidence, and outstanding actions.
- **Handoff Summary** – Always includes: summary, artifact list, outstanding tasks, validation status, suggested next steps. Use this to decide if you need more work from Claude or if you’re ready to run local commands yourself.

---

## Troubleshooting

- **Claude says it’s missing context** – Provide additional clues (file paths, business rules) and rerun; it will redo Phase 0 automatically.
- **Agent chain stops early** – Ask Claude to continue or run the next step (“Please proceed with the UI implementation”).
- **Need a new agent** – Prompt `agent-architect` with the requirements; it will produce a new agent spec that follows the same pattern stack.

Knowing the workflow lets you collaborate with Claude effectively. You set direction, Claude executes the checklist, and the shared pattern stack keeps everything consistent.
