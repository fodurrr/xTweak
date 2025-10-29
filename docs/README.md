# xTweak Documentation Index

Complete index of all project documentation, guides, and references.

---

## 📖 Documentation by Category

### Claude Code
- [.claude/README.md](../.claude/README.md) – Configuration overview
- [.claude/AGENT_USAGE_GUIDE.md](../.claude/AGENT_USAGE_GUIDE.md) – Agent selection matrix
- [.claude/agent-workflows.md](../.claude/agent-workflows.md) – Multi-agent sequences
- [.claude/patterns/README.md](../.claude/patterns/README.md) – Pattern library (10 patterns)
- [.claude/CHANGELOG.md](../.claude/CHANGELOG.md) – Pattern & agent changes
- [Quick Reference](./claude/quick-reference.md) – One-minute checklist
- [Pattern Guide](./claude/pattern-guide.md) – Pattern combinations

### Codex CLI
- [Codex Profiles](./codex_profiles.md) – 21 agent profiles
- [Migration Guide](../scripts/codex/MIGRATION.md) – Migration history

### Frontend Development
- [Frontend Design Principles](./frontend_design_principles/frontend-design-principles.md) – DaisyUI + Tailwind workflows

### Template Usage & Setup
- [Template Initialization Guide](./guides/template-initialization.md) – How to use xTweak as a project template
- [Project Renaming Guide](./guides/project-renaming.md) – Rename xTweak to your project name

### Elixir/Ash Framework

**Usage Rules** - Package-specific AI guidance (auto-discovered via MCP):
- [Ash Framework](./elixir_rules/ash.md) – Core rules & patterns
- [AshPostgres](./elixir_rules/ash_postgres.md) – Database layer
- [AshOban](./elixir_rules/ash_oban.md) – Background jobs
- [AshPhoenix](./elixir_rules/ash_phoenix.md) – Web integration
- [AshAI](./elixir_rules/ash_ai.md) – AI capabilities
- [Igniter](./elixir_rules/igniter.md) – Code generation
- [Usage Rules Guide](./elixir_rules/README.md) – How usage rules work

**Note:** These files are synced from package usage rules. Update with `mix docs.rules` after dependency changes.

**Additional available rules** (auto-discovered, not yet synced to docs):
- Phoenix sub-rules: ecto, elixir, html, liveview, phoenix
- General: usage_rules (elixir/otp), spark, reactor
- Auth: ash_authentication, ash_json_api

---

## 📂 Documentation Structure

```
docs/
├── README.md (this file)       ← Documentation index
├── claude/
│   ├── pattern-guide.md        ← Pattern combinations
│   └── quick-reference.md      ← One-minute checklist
├── elixir_rules/
│   ├── ash.md                  ← Core Ash rules
│   ├── ash_postgres.md         ← Database layer
│   ├── ash_oban.md             ← Background jobs
│   ├── ash_phoenix.md          ← Web integration
│   ├── ash_ai.md               ← AI integration
│   └── igniter.md              ← Code generation
├── frontend_design_principles/
│   └── frontend-design-principles.md
├── guides/
│   ├── template-initialization.md  ← Template setup guide
│   └── project-renaming.md         ← Renaming guide
└── codex_profiles.md           ← 21 Codex CLI profiles

.claude/
├── README.md                   ← Configuration guide
├── AGENT_USAGE_GUIDE.md        ← Agent selection matrix
├── agent-workflows.md          ← Multi-agent sequences
├── CHANGELOG.md                ← Pattern & agent changes
├── patterns/                   ← 10 reusable patterns
├── agents/                     ← 21 agent definitions
└── agent-reports/              ← Execution reports

scripts/codex/
└── MIGRATION.md                ← Codex migration history
```

---

## 🔍 Quick Links by Topic

**Configuration**:
- Claude Code config → [.claude/README.md](../.claude/README.md)
- Codex CLI profiles → [codex_profiles.md](./codex_profiles.md)

**Patterns & Workflows**:
- Pattern library → [.claude/patterns/README.md](../.claude/patterns/README.md)
- Pattern combinations → [pattern-guide.md](./claude/pattern-guide.md)
- Agent workflows → [.claude/agent-workflows.md](../.claude/agent-workflows.md)

**Quick References**:
- One-minute checklist → [quick-reference.md](./claude/quick-reference.md)
- Agent matrix → [.claude/AGENT_USAGE_GUIDE.md](../.claude/AGENT_USAGE_GUIDE.md)

**Frontend**:
- Design principles → [frontend-design-principles.md](./frontend_design_principles/frontend-design-principles.md)

**Elixir/Ash Framework**:
- Core rules → [elixir_rules/ash.md](./elixir_rules/ash.md)
- Database → [elixir_rules/ash_postgres.md](./elixir_rules/ash_postgres.md)
- Code generation → [elixir_rules/igniter.md](./elixir_rules/igniter.md)
