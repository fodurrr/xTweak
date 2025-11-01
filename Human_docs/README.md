# xTweak UI Documentation Index

**Last Updated**: November 1, 2025
**Status**: Phase 1 Complete ✅

Complete documentation index for the xTweak UI component library.

---

## Quick Navigation

### 🚀 Getting Started
- **[COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md)** - Complete guide for working with Claude Code (workflow, agents, commands)
- **[xTweak UI Documentation](../apps/xtweak_ui/docs/README.md)** - Component library documentation
  - [SHOWCASE_GUIDE.md](../apps/xtweak_ui/docs/SHOWCASE_GUIDE.md) - Interactive component showcase
  - [COMPONENT_API_REFERENCE.md](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md) - Complete API documentation
- **[QUICK_START.md](../AI_docs/prd/QUICK_START.md)** - Project quick reference

### 📊 Project Reports
- **[Sprint Reports](../AI_docs/prd/06-sprint-plans/)** - All sprint completion reports and summaries
- **[PRD Completion Status](../AI_docs/prd/.prd-completion-status.md)** - Overall project status

### 🎮 Live Demo
- **Showcase**: `http://localhost:4000/showcase` (when running `mix phx.server`)

---

## Documentation Organization

This project uses a **three-tier documentation structure** to keep docs organized by scope and audience:

### 🌐 Human_docs/ - Project-Wide Documentation
**Scope**: Cross-cutting project concerns, workflows, coordination

**What belongs here**:
- Workflow guides (how to work with Claude Code)
- Setup instructions (Claude CLI, tooling)
- Project-wide conventions
- Cross-app coordination docs

**What does NOT belong here**:
- App-specific user guides → Use `apps/{app}/docs/`
- Component API references → Use `apps/{app}/docs/`
- Sprint reports → Use `AI_docs/prd/06-sprint-plans/`

### 📦 apps/{app}/docs/ - App-Specific Documentation
**Scope**: Documentation for a specific umbrella app

**What belongs here**:
- App user guides (like xTweak UI Showcase Guide)
- App API references (like Component API Reference)
- App-specific tutorials and examples
- App feature documentation

**Current apps with docs**:
- `apps/xtweak_ui/docs/` - xTweak UI component library documentation

### 🤖 AI_docs/ - AI Documentation
**Scope**: AI-facing documentation (PRD, architecture, sprint plans)

**What belongs here**:
- PRD documents and specifications
- Architecture decisions and design docs
- Sprint plans and completion reports
- AI workflow patterns and agent instructions

**For details**: See [.claude/patterns/documentation-organization.md](../.claude/patterns/documentation-organization.md)

---

## Documentation by Purpose

### For Users/Non-Developers
1. **[SHOWCASE_GUIDE.md](../apps/xtweak_ui/docs/SHOWCASE_GUIDE.md)** - How to use the interactive showcase
   - Getting started instructions
   - Component overview
   - How to test components
   - Troubleshooting guide

2. **[COMPONENT_API_REFERENCE.md](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md)** (Props section)
   - Props and options for each component
   - Code examples
   - Common use cases

### For Developers
1. **[COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md)** - How to work with Claude Code
   - Workflow mechanics
   - Command usage
   - Agent decision tree
   - End-to-end scenarios

2. **[COMPONENT_API_REFERENCE.md](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md)** (Complete)
   - Full API reference
   - Props, slots, events
   - Code examples for every feature
   - Type references

3. **Inline Component Documentation**
   - Command: `iex> h XTweakUI.Components.Badge.badge`
   - Available for all 6 components
   - Full prop documentation
   - Code examples

4. **Test Files** (examples of usage)
   - `apps/xtweak_ui/test/xtweak_ui/components/badge_test.exs`
   - `apps/xtweak_ui/test/xtweak_ui/components/avatar_test.exs`
   - `apps/xtweak_ui/test/xtweak_ui/components/card_test.exs`
   - `apps/xtweak_ui/test/xtweak_ui/components/alert_test.exs`
   - `apps/xtweak_ui/test/xtweak_ui/components/divider_test.exs`

### For Project Managers/Stakeholders
1. **[Sprint Reports](../AI_docs/prd/06-sprint-plans/)** - Sprint completion summaries
   - What was delivered
   - Quality metrics
   - Test coverage statistics
   - Completion status

2. **[PRD Completion Status](../AI_docs/prd/.prd-completion-status.md)** - Project progress tracking

### For Architects/System Designers
1. **[Architecture Document](../AI_docs/prd/03-architecture.md)** - System design and patterns
2. **[Component Inventory](../AI_docs/prd/04-component-inventory.md)** - 105 components mapped
3. **[Implementation Roadmap](../AI_docs/prd/05-implementation-roadmap.md)** - 24-week timeline

---

## Components Reference

### 6 Total Components (1 from Sprint 1, 5 from Sprint 2)

#### Button (Sprint 1)
- **Module**: `XTweakUI.Components.Button`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/button.ex`
- **Tests**: 22+ tests in button_test.exs
- **Showcase**: Lines 40-143 in showcase_live.ex
- **Features**: 5 variants, 6 colors, 5 sizes, icons, loading/disabled states

#### Badge (Sprint 2)
- **Module**: `XTweakUI.Components.Badge`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/badge.ex`
- **Tests**: 22 tests in badge_test.exs
- **Showcase**: Lines 145-272 in showcase_live.ex
- **Features**: 4 variants, 5 colors, 4 sizes, status indicators

#### Avatar (Sprint 2)
- **Module**: `XTweakUI.Components.Avatar`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/avatar.ex`
- **Tests**: 32 tests in avatar_test.exs
- **Showcase**: Lines 274-520 in showcase_live.ex
- **Features**: Image, initials, text, icon fallbacks, 9 sizes, status chips

#### Card (Sprint 2)
- **Module**: `XTweakUI.Components.Card`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/card.ex`
- **Tests**: 35 tests in card_test.exs
- **Showcase**: Lines 522-825 in showcase_live.ex
- **Features**: Header/footer slots, 4 variants, 4 padding options

#### Alert (Sprint 2)
- **Module**: `XTweakUI.Components.Alert`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/alert.ex`
- **Tests**: 36 tests in alert_test.exs
- **Showcase**: Lines 827-1096 in showcase_live.ex
- **Features**: 4 severities, 4 variants, actions, dismissible, accessibility

#### Divider (Sprint 2)
- **Module**: `XTweakUI.Components.Divider`
- **File**: `apps/xtweak_ui/lib/xtweak_ui/components/divider.ex`
- **Tests**: 66 tests in divider_test.exs
- **Showcase**: Lines 1098-1415 in showcase_live.ex
- **Features**: Horizontal/vertical, labels, icons, 5 sizes, 3 types, 6 colors

---

## Documentation Files Location

### Root Documentation (Top Level)
```
/home/fodurrr/dev/xTweak/Human_docs/
├── README.md                       ← YOU ARE HERE
├── COMPLETE_WORKFLOW_GUIDE.md      ← Claude Code workflow guide
└── claude_cli_setup.md             ← Claude CLI setup

/home/fodurrr/dev/xTweak/apps/xtweak_ui/docs/
├── README.md                       ← xTweak UI docs index
├── SHOWCASE_GUIDE.md               ← Interactive showcase guide
└── COMPONENT_API_REFERENCE.md      ← Component API reference
```

### PRD Documentation
```
AI_docs/prd/
├── QUICK_START.md                  ← Project quick reference
├── .prd-completion-status.md       ← Overall status
├── 00-executive-summary.md
├── 01-technical-specification.md
├── 02-requirements.md
├── 03-architecture.md
├── 04-component-inventory.md
├── 05-implementation-roadmap.md
└── 06-sprint-plans/phase-1-foundation/
    ├── sprint-1-infrastructure.md
    ├── sprint-1-REPORTS.md
    ├── sprint-2-core-components.md
    └── sprint-2-REPORTS.md
```

### Component Code
```
apps/xtweak_ui/lib/xtweak_ui/components/
├── button.ex          (Sprint 1)
├── badge.ex           (Sprint 2)
├── avatar.ex          (Sprint 2)
├── card.ex            (Sprint 2)
├── alert.ex           (Sprint 2)
└── divider.ex         (Sprint 2)
```

### Component Tests
```
apps/xtweak_ui/test/xtweak_ui/components/
├── badge_test.exs     (22 tests)
├── avatar_test.exs    (32 tests)
├── card_test.exs      (35 tests)
├── alert_test.exs     (36 tests)
└── divider_test.exs   (66 tests)
```

### Showcase
```
apps/xtweak_web/lib/xtweak_web_web/live/
└── showcase_live.ex   (1,435 lines - all components)
```

---

## Documentation by Type

### How-To Guides
- [COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md) - Complete Claude Code workflow guide
- [xTweak UI Showcase Guide](../apps/xtweak_ui/docs/SHOWCASE_GUIDE.md) - How to use the interactive showcase
- Component-specific guides in [Component API Reference](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md)

### API References
- [xTweak UI Component API](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md) - Complete API for all components
- Inline moduledocs - `iex> h ComponentName.component`

### Reports & Summaries
- [Sprint Reports](../AI_docs/prd/06-sprint-plans/) - All sprint completion reports
- [PRD Completion Status](../AI_docs/prd/.prd-completion-status.md) - Project tracking

### Architecture & Design
- [03-architecture.md](../AI_docs/prd/03-architecture.md) - System design
- [01-technical-specification.md](../AI_docs/prd/01-technical-specification.md) - Technical details
- [04-component-inventory.md](../AI_docs/prd/04-component-inventory.md) - All 105 components

### Requirements & Planning
- [02-requirements.md](../AI_docs/prd/02-requirements.md) - Functional & non-functional requirements
- [05-implementation-roadmap.md](../AI_docs/prd/05-implementation-roadmap.md) - 24-week timeline
- Sprint plans in `../AI_docs/prd/06-sprint-plans/`

---

## Key Metrics

### Code Coverage
- **Total Tests**: 201+
- **Coverage**: 74.69%
- **Target**: >60% (EXCEEDED ✓)

### Components
- **Total Components**: 6 (Button + 5 new)
- **With Full Tests**: 6/6 (100%)
- **With Showcase**: 6/6 (100%)
- **With API Docs**: 6/6 (100%)

### Documentation
- **Total Documentation**: 2,900+ lines
  - apps/xtweak_ui/docs/SHOWCASE_GUIDE.md: 800+ lines
  - apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md: 900+ lines
  - Sprint reports: 700+ lines
  - Inline moduledocs: 500+ lines

### Quality Gates
- **mix format**: ✓ PASSING
- **mix credo --strict**: ✓ PASSING
- **mix compile --warnings-as-errors**: ✓ PASSING
- **mix test**: ✓ PASSING (201/201)
- **mix dialyzer**: ✓ CLEAN

---

## How to Access Documentation

### Online Resources
1. **Live Showcase**: `http://localhost:4000/showcase`
   - Start: `mix phx.server`
   - Interactive examples
   - Theme switching
   - Code snippets

2. **Component Module Docs**
   ```elixir
   iex> h XTweakUI.Components.Badge.badge
   iex> h XTweakUI.Components.Avatar.avatar
   iex> h XTweakUI.Components.Card.card
   # ... etc for all components
   ```

### Offline Resources
1. **Markdown Files** - All .md files in this repo
2. **Source Code** - Component implementations with inline docs
3. **Test Files** - Usage examples

---

## Common Questions

### Q: Where do I start?
**A**: Start with [COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md) for working with Claude Code, [xTweak UI docs](../apps/xtweak_ui/docs/README.md) for component library, or [QUICK_START.md](../AI_docs/prd/QUICK_START.md) for project overview.

### Q: How do I use a component?
**A**: Check [Component API Reference](../apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md) for the specific component, or visit the live showcase at `http://localhost:4000/showcase`.

### Q: What components are available?
**A**: 6 components total:
- Button (from Sprint 1)
- Badge, Avatar, Card, Alert, Divider (from Sprint 2)

See [Components Reference](#components-reference) above.

### Q: Is there a Phase 2?
**A**: Yes! See [Sprint Reports](../AI_docs/prd/06-sprint-plans/) for "Phase 2 Planning (Preview)" section.

### Q: How can I contribute?
**A**: See [MANDATORY_AI_RULES.md](./MANDATORY_AI_RULES.md) and [CLAUDE.md](./CLAUDE.md) for development guidelines.

### Q: Where are the tests?
**A**: In `apps/xtweak_ui/test/xtweak_ui/components/`
- Run: `mix test apps/xtweak_ui/test/xtweak_ui/components/`
- With coverage: `mix test --cover apps/xtweak_ui/test/`

### Q: How do I run the showcase?
**A**:
```bash
mix phx.server
# Visit: http://localhost:4000/showcase
```

---

## Documentation Maintenance

### How Documents Are Organized
1. **Narrative Documents** (.md files)
   - User guides
   - How-to guides
   - Reports and summaries

2. **Reference Documentation**
   - Inline moduledocs
   - API tables in markdown
   - Code examples

3. **System Documentation**
   - Architecture
   - Requirements
   - Planning

### Keeping Docs Updated
- Update inline docs when changing component APIs
- Update COMPLETE_WORKFLOW_GUIDE.md if workflow/agent mechanics change
- Update apps/xtweak_ui/docs/ when component features change
- Create new sprint reports in AI_docs/prd/06-sprint-plans/ after each sprint
- Update PRD completion status after each sprint

---

## Related Resources

### External
- **Nuxt UI** (inspiration): https://ui.nuxt.com/
- **Phoenix LiveView**: https://hexdocs.pm/phoenix_live_view/
- **Tailwind CSS**: https://tailwindcss.com/
- **Hero Icons**: https://heroicons.com/

### Internal
- **[COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md)** - Human workflow guide
- **[CLAUDE.md](../CLAUDE.md)** - Claude Code guidelines
- **[MANDATORY_AI_RULES.md](../MANDATORY_AI_RULES.md)** - Project rules
- **[usage-rules.md](../usage-rules.md)** - Framework rules
- **[.claude/](../.claude/)** - AI patterns and commands

---

## Project Status

### Phase 1: Foundation ✅ COMPLETE
- ✅ Sprint 1: Infrastructure (Button, theme system)
- ✅ Sprint 2: Core Components (5 new components + tests + docs)
- ✅ All quality gates passing
- ✅ Comprehensive documentation
- ✅ Ready for Phase 2

### Phase 2: Form Components (Planning)
- 20+ additional components
- Form inputs (input, textarea, select, checkbox, radio)
- Navigation (tabs, breadcrumb, pagination)
- Overlays (modal, popover, tooltip)

### Future Phases
- Phase 3: Advanced Components
- Phase 4: Production & Release
- Phase 5: Community & Ecosystem

---

## Quick Commands

```bash
# Start showcase
mix phx.server

# Run tests
mix test apps/xtweak_ui/test/xtweak_ui/components/

# Check coverage
mix test --cover apps/xtweak_ui/test/

# View module docs
iex -S mix
iex> h XTweakUI.Components.Badge.badge

# Quality gates
mix format && mix credo --strict && \
  mix compile --warnings-as-errors && \
  mix test && mix dialyzer
```

---

## Document Versions

| Document | Version | Last Updated | Status | Location |
|----------|---------|--------------|--------|----------|
| Human_docs/README.md | 1.2 | Nov 1, 2025 | Current | Project-wide |
| COMPLETE_WORKFLOW_GUIDE.md | 1.0 | Nov 1, 2025 | Current | Project-wide |
| xtweak_ui/docs/SHOWCASE_GUIDE.md | 1.0 | Nov 1, 2025 | Current | App-specific |
| xtweak_ui/docs/COMPONENT_API_REFERENCE.md | 1.0 | Nov 1, 2025 | Current | App-specific |
| AI_docs/prd/QUICK_START.md | 1.0 | Oct 31, 2025 | Active | AI docs |
| AI_docs/prd/.prd-completion-status.md | 1.0 | Nov 1, 2025 | Active | AI docs |

---

## Contact & Support

For questions about:
- **Workflow & Agents**: See [COMPLETE_WORKFLOW_GUIDE.md](./COMPLETE_WORKFLOW_GUIDE.md)
- **xTweak UI Components**: See [xtweak_ui/docs/](../apps/xtweak_ui/docs/README.md)
- **Project Status**: See [Sprint Reports](../AI_docs/prd/06-sprint-plans/)
- **Development**: See [CLAUDE.md](../CLAUDE.md)

---

**Welcome to xTweak UI!** 🎉

Start exploring at: `http://localhost:4000/showcase`

Happy coding! 🚀
