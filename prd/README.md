# Product Requirements Document: Nuxt UI → Phoenix/Elixir Port

**Project**: xTweak UI Component Library
**Version**: 1.0.0-alpha
**Created**: 2025-10-29
**Status**: 🟡 In Planning → Phase 1 Foundation
**Target Release**: v1.0.0 on Hex.pm (Q2 2026)

---

## 📋 Document Index

### Core Documentation

1. **[Executive Summary](./00-executive-summary.md)** 🎯
   Business case, goals, stakeholders, and high-level overview

2. **[Technical Specification](./01-technical-specification.md)** 🔧
   Complete research findings: Nuxt UI analysis, CSS framework comparison, Phoenix architecture patterns, gap analysis

3. **[Requirements](./02-requirements.md)** 📝
   Functional and non-functional requirements with acceptance criteria

4. **[Architecture](./03-architecture.md)** 🏗️
   System design, umbrella app structure, asset pipeline, theming system

5. **[Component Inventory](./04-component-inventory.md)** 📦
   Complete component mapping: Nuxt UI → Phoenix Component API

6. **[Implementation Roadmap](./05-implementation-roadmap.md)** 🗓️
   Phased timeline with milestones and dependencies

7. **[Testing Strategy](./07-testing-strategy.md)** ✅
   Quality assurance, accessibility testing, CI/CD integration

8. **[Open Source Plan](./08-open-source-plan.md)** 🌍
   Publication strategy for Hex.pm, documentation, community engagement

9. **[Risk Register](./09-risk-register.md)** ⚠️
   Identified risks, mitigations, dependencies, and contingencies

### Sprint Plans

#### Phase 1: Foundation (Weeks 1-4)
- **[Sprint 1: Infrastructure Setup](./06-sprint-plans/phase-1-foundation/sprint-1-infrastructure.md)** (Week 1-2)
  Theme system, asset pipeline, documentation showcase

- **[Sprint 2: Core Components](./06-sprint-plans/phase-1-foundation/sprint-2-core-components.md)** (Week 3-4)
  Button, Badge, Card, Alert, Avatar

#### Phase 2: MVP Components (Weeks 5-12)
- **[Sprint 3: Form Components](./06-sprint-plans/phase-2-mvp/sprint-3-forms.md)** (Week 5-6)
  Input, Textarea, Select, Checkbox, Radio

- **[Sprint 4: Navigation & Feedback](./06-sprint-plans/phase-2-mvp/sprint-4-navigation.md)** (Week 7-8)
  Modal, Dropdown, Tabs, Tooltip, Notification

- **Sprint 5-6**: Extended forms, data display (detailed plans TBD)

#### Phase 3: Extended Components (Weeks 13-20)
- UnoCSS evaluation
- Advanced overlays and interactions
- Accessibility audits
- _(Detailed sprint plans in phase-3-extended/)_

#### Phase 4: Production Ready (Weeks 21-24)
- Performance optimization
- Documentation finalization
- Hex.pm publication preparation
- _(Detailed sprint plans in phase-4-advanced/)_

---

## 🎯 Project Goals

### Primary Objectives
1. **Port Nuxt UI's component library** to Phoenix/LiveView with idiomatic Elixir patterns
2. **Create reusable `xtweak_ui` Hex package** for the Elixir community
3. **Maintain API compatibility** with Nuxt UI where possible (familiar DX for Vue developers)
4. **Ensure accessibility** (WCAG AA compliance) and production-readiness

### Success Criteria
- ✅ **Phase 1**: 5 core components with theming system (Week 4)
- ✅ **Phase 2**: 20 MVP components, 80%+ test coverage (Week 12)
- ✅ **Phase 3**: 50+ components, accessibility audits passed (Week 20)
- ✅ **Phase 4**: 100+ components, published to Hex.pm (Week 24)

---

## 🔑 Key Decisions (User-Approved)

| Decision Area | Choice | Rationale |
|---------------|--------|-----------|
| **CSS Framework** | Tailwind CSS → UnoCSS (Phase 3 evaluation) | Start with proven Tailwind integration, evaluate UnoCSS for performance gains later |
| **Component Scope** | Phased: MVP (20) → Extended (30) → Advanced (50+) | Deliver usable library early, iterate based on real needs |
| **Component Approach** | Fresh Nuxt UI ports (no existing component reuse) | Clean slate, pure Nuxt UI API implementation |
| **Theming System** | Elixir Theme module + CSS variables | Inspired by Nuxt UI's app.config.ts, runtime theme switching |
| **Open Source** | Internal dev → v1.0 stabilization → Hex.pm | Polish before public release, higher quality standards |

---

## 📊 Current Status

### Phase 1: Foundation (In Progress)
| Task | Status | Owner | Due Date |
|------|--------|-------|----------|
| PRD Documentation | 🟡 In Progress | Claude | 2025-10-30 |
| Theme System Setup | 🔴 Not Started | TBD | Week 1 |
| Asset Pipeline Config | 🔴 Not Started | TBD | Week 1 |
| Button Component (Enhanced) | 🔴 Not Started | TBD | Week 2 |
| Showcase in xtweak_docs | 🔴 Not Started | TBD | Week 2 |

### Component Progress
| Category | Total | Completed | In Progress | Not Started |
|----------|-------|-----------|-------------|-------------|
| **Phase 1 (Core)** | 5 | 0 | 0 | 5 |
| **Phase 2 (MVP)** | 20 | 0 | 0 | 20 |
| **Phase 3 (Extended)** | 30 | 0 | 0 | 30 |
| **Phase 4 (Advanced)** | 50+ | 0 | 0 | 50+ |
| **Total** | **105+** | **0** | **0** | **105+** |

---

## 🛠️ Technology Stack

### Core Technologies
- **Elixir**: 1.19.1
- **Phoenix**: 1.8+
- **Phoenix LiveView**: 1.1+
- **Ash Framework**: 3.7.6+ (data layer in xtweak_core)
- **Tailwind CSS**: 3.4.3+
- **UnoCSS**: TBD (Phase 3 evaluation)

### Tooling
- **Tidewave MCP**: Elixir project analysis
- **Ash AI MCP**: Ash generators
- **Context7 MCP**: Library documentation (Tailwind, Phoenix, Vue/Nuxt)
- **Playwright MCP**: Visual testing, accessibility audits
- **ExDoc**: API documentation generation
- **Credo**: Code quality (strict mode)
- **Dialyzer**: Static type analysis

### JavaScript (Minimal)
- **Alpine.js**: Local interactivity (dropdowns, tooltips)
- **Phoenix.LiveView.JS**: Server-driven UI commands
- **@floating-ui/dom**: Popover/tooltip positioning
- **dayjs**: Date handling (lightweight)

---

## 👥 Team & Roles

| Role | Responsibilities | Tools/Agents |
|------|------------------|--------------|
| **Architect** | System design, API decisions | mcp-verify-first, ash-resource-architect |
| **Component Developer** | Phoenix Component implementation | frontend-design-enforcer, code-reviewer |
| **QA Engineer** | Testing, accessibility audits | test-builder, Playwright MCP |
| **Documentation Lead** | PRD, API docs, guides | docs-maintainer |
| **DevOps** | CI/CD, Hex.pm publication | release-coordinator |

---

## 📚 Related Documentation

- **[Project Root CLAUDE.md](../../CLAUDE.md)**: Main project guidelines
- **[Mandatory AI Rules](../../MANDATORY_AI_RULES.md)**: Mandatory AI rules that override everything
- **[Elixir Rules: Ash Framework](../elixir_rules/ash.md)**: Ash fundamentals
- **[Elixir Rules: Phoenix](../elixir_rules/ash_phoenix.md)**: Phoenix LiveView patterns
- **[Agent Reference](../../.claude/README.md)**: Agent matrix, workflows, and selection guide
- **[Pattern Library](../../.claude/patterns/README.md)**: Reusable implementation patterns

---

## 🔄 Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-10-29 | 0.1.0 | Initial PRD structure created | Claude (Sonnet 4.5) |
| TBD | 0.2.0 | Executive summary, technical spec completed | TBD |
| TBD | 1.0.0 | All PRD documents finalized, Phase 1 started | TBD |

---

## 📞 Questions or Feedback?

- **Project Lead**: Peter (fodurrr@gmail.com)
- **GitHub Issues**: TBD (will be public after Hex.pm release)
- **Internal Slack**: TBD

---

**Last Updated**: 2025-10-29
**Next Review**: End of Phase 1 (Week 4)
