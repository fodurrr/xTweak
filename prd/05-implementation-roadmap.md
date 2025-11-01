# Implementation Roadmap: Nuxt UI → Phoenix Port

**Document Version**: 1.0.0
**Date**: 2025-10-29
**Status**: ✅ Approved
**Duration**: 24 weeks (6 months)
**Target v1.0 Release**: Q2 2026

---

## 📅 Timeline Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ Week 1-4    │ Week 5-12         │ Week 13-20        │ Week 21-24           │
│ PHASE 1     │ PHASE 2           │ PHASE 3           │ PHASE 4              │
│ Foundation  │ MVP Components    │ Extended          │ Production Ready     │
│ 5 components│ 20 components     │ 30 components     │ Polish + Hex.pm      │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Foundation (Weeks 1-4)

### Goals
- ✅ Validate technical architecture (theme system, asset pipeline)
- ✅ Deliver 5 working components with showcase
- ✅ Establish development workflow and quality gates

### Sprint 1: Infrastructure Setup (Week 1-2)

#### Objectives
1. **Theme System** (Week 1)
   - Implement `XTweakUI.Theme` module
   - CSS variables for Nuxt UI color tokens
   - Pure Tailwind utility configuration
   - Runtime theme switcher (data-attribute approach)

2. **Asset Pipeline** (Week 1)
   - Set up `apps/xtweak_ui/assets/` structure
   - esbuild configuration for component JS
   - Tailwind CSS integration
   - Hook system for LiveView

3. **Documentation Showcase** (Week 2)
   - Create live component demo in `xtweak_docs`
   - Playwright MCP integration for screenshots
   - ExDoc configuration
   - Component playground UI

#### Deliverables
- [ ] Theme module with 3 built-in themes (light, dark, custom)
- [ ] Working asset pipeline (CSS + JS)
- [ ] Showcase app with theme switcher
- [ ] Development workflow documented

#### Success Criteria
- Theme switching works without page reload
- CSS bundle < 30KB (gzipped)
- Showcase renders on `localhost:4000`
- All quality gates pass (format, credo, dialyzer)

---

### Sprint 2: Core Components (Week 3-4)

#### Objectives
1. **Enhance Button** (Week 3)
   - Port Nuxt UI's full API (color, variant, size, loading, icon)
   - Add tests (unit + visual regression)
   - Documentation with examples

2. **Implement Badge, Avatar** (Week 3)
   - Simple components to validate patterns
   - Test theming system integration

3. **Enhance Card, Alert** (Week 4)
   - Port slot patterns (:header, :footer)
   - Test complex slot scenarios

#### Deliverables
- [ ] 5 components fully documented
- [ ] 20+ unit tests
- [ ] 5+ visual regression tests (Playwright)
- [ ] Showcase pages for each component

#### Success Criteria
- All 5 components render correctly in showcase
- Test coverage > 60%
- Zero Credo warnings (strict mode)
- Dialyzer passes with zero warnings
- Playwright screenshots match design

---

### Phase 1 Milestones

| Milestone | Week | Deliverable | Success Metric |
|-----------|------|-------------|----------------|
| **M1.1: Infrastructure** | 2 | Theme + asset pipeline working | Theme switch < 100ms |
| **M1.2: Showcase** | 2 | Live component demo | Accessible at localhost:4000 |
| **M1.3: First Components** | 4 | 5 components with tests | Test coverage > 60% |
| **M1.4: Sprint Demo** | 4 | Present to stakeholders | Approval to proceed to Phase 2 |

---

## Phase 2: MVP Components (Weeks 5-12)

### Goals
- ✅ Deliver 20 essential components for internal use
- ✅ Achieve 80%+ test coverage
- ✅ Establish JS interactivity patterns (LiveView.JS, Alpine.js, Hooks)

### Sprint 3: Form Components (Week 5-6)

#### Objectives
- Implement 6 form components (Input, Textarea, Select, Checkbox, Radio, FormGroup)
- Phoenix.HTML.Form integration
- Client/server validation patterns
- Accessibility (ARIA labels, error announcements)

#### Deliverables
- [ ] 6 form components
- [ ] Form integration guide
- [ ] Validation examples (LiveView)
- [ ] 30+ tests

#### Success Criteria
- Forms work with `Phoenix.HTML.Form.form_for/4`
- Validation errors display inline
- Keyboard navigation works (Tab, Arrow keys)
- Screen reader friendly (tested with Playwright MCP)

---

### Sprint 4: Navigation & Feedback (Week 7-8)

#### Objectives
- Link, Dropdown, Tabs, Breadcrumb, Pagination (5 components)
- Modal, Toast, Tooltip, Progress, Skeleton (5 components)
- Implement Alpine.js for Dropdown
- GenServer + PubSub for Toast system

#### Deliverables
- [ ] 10 components (5 navigation + 5 feedback)
- [ ] `XTweakUI.Toast` GenServer
- [ ] Alpine.js integration guide
- [ ] 50+ tests

#### Success Criteria
- Dropdown closes on click-outside
- Toast appears in all LiveViews (PubSub broadcast)
- Modal traps focus, closes on Escape
- Tooltip positions correctly (CSS or Floating UI)

---

### Sprint 5: Layout Components (Week 9-10)

#### Objectives
- Divider, Kbd, Chip, Icon (4 components)
- Heroicons integration
- Performance optimization (minimize re-renders)

#### Deliverables
- [ ] 4 layout components
- [ ] Icon library integration (Heroicons)
- [ ] Performance benchmarks (<100ms render)

---

### Sprint 6: Testing & Documentation (Week 11-12)

#### Objectives
- Increase test coverage to 80%+
- Visual regression suite (Playwright)
- API documentation (ExDoc)
- Internal release (use in xtweak_web)

#### Deliverables
- [ ] Test coverage report (80%+)
- [ ] 50+ visual regression tests
- [ ] Complete API docs (ExDoc)
- [ ] Internal changelog

#### Success Criteria
- All components used in at least 1 xtweak_web page
- Zero critical bugs reported
- Documentation passes peer review
- Stakeholder approval for Phase 3

---

### Phase 2 Milestones

| Milestone | Week | Deliverable | Success Metric |
|-----------|------|-------------|----------------|
| **M2.1: Forms Complete** | 6 | 6 form components | Forms work in xtweak_web |
| **M2.2: Navigation Complete** | 8 | 10 more components | Dropdown + Toast tested |
| **M2.3: MVP Release** | 12 | 20 components total | 80% test coverage, internal use |
| **M2.4: Retrospective** | 12 | Team feedback | Identify improvements for Phase 3 |

---

## Phase 3: Extended Components (Weeks 13-20)

### Goals
- ✅ Add 30 advanced components
- ✅ Evaluate UnoCSS migration (POC)
- ✅ Accessibility audit (WCAG AA compliance)
- ✅ Pre-release (v0.9.0) for community feedback

### Sprint 7: Advanced Forms (Week 13-14)

#### Objectives
- SelectMenu, InputMenu, RadioGroup, Toggle, Range (5 components)
- Implement searchable dropdowns (LiveView + JS)
- Keyboard navigation (Arrow keys, Enter, Escape)

#### Deliverables
- [ ] 5 advanced form components
- [ ] Fuzzy search integration (fuse.js)
- [ ] Keyboard nav guide

---

### Sprint 8: Date/Time/Color Pickers (Week 15-16)

#### Objectives
- ColorPicker, DatePicker, TimePicker (3 components)
- JS hooks for complex interactions
- dayjs integration for date handling

#### Deliverables
- [ ] 3 picker components
- [ ] JS hook patterns documented
- [ ] Date/time formatting utils

---

### Sprint 9: Navigation & Menus (Week 17-18)

#### Objectives
- VerticalNavigation, HorizontalNavigation, NavigationMenu, ContextMenu, CommandPalette, Accordion, Carousel (7 components)
- CommandPalette (Cmd+K) with fuzzy search
- Context menu (right-click)

#### Deliverables
- [ ] 7 navigation/menu components
- [ ] CommandPalette guide (Phoenix patterns)
- [ ] Accessibility audit (keyboard nav)

---

### Sprint 10: Data Display & Overlays (Week 19-20)

#### Objectives
- Table, AvatarGroup, Meter, Timeline, Stepper, User, ContentSearch, BlogPost (8 components)
- Slideover, Popover, Dialog, Notification, Banner, Drawer (6 components)
- Floating UI integration for Popover positioning

#### Deliverables
- [ ] 14 components (8 data display + 6 overlays)
- [ ] Floating UI integration guide
- [ ] Table with sorting/pagination

---

### UnoCSS Evaluation (Sprint 10, Week 20)

#### Objectives
- POC: Port 3 components to UnoCSS (Button, Card, Input)
- Performance comparison (build time, bundle size)
- DX evaluation (tooling, HMR)
- Decision: Migrate or stay with Tailwind

#### Deliverables
- [ ] UnoCSS POC report
- [ ] Performance benchmarks (Tailwind vs UnoCSS)
- [ ] Recommendation document

#### Decision Criteria
- **Migrate to UnoCSS** if:
  - >30% build time improvement
  - >20% bundle size reduction
  - DX comparable or better
  - Phoenix integration straightforward

- **Stay with Tailwind** if:
  - Integration too complex
  - Performance gains <20%
  - Risk outweighs benefits

---

### Accessibility Audit (Week 20)

#### Objectives
- WCAG AA compliance check (Playwright MCP)
- Keyboard navigation audit (all components)
- Screen reader testing (VoiceOver, NVDA)
- Color contrast validation

#### Deliverables
- [ ] Accessibility audit report
- [ ] Remediation plan (if needed)
- [ ] WCAG AA badge (if passed)

---

### Phase 3 Milestones

| Milestone | Week | Deliverable | Success Metric |
|-----------|------|-------------|----------------|
| **M3.1: Advanced Forms** | 16 | DatePicker, ColorPicker working | Complex pickers functional |
| **M3.2: CommandPalette** | 18 | Cmd+K search implemented | Fuzzy search < 50ms |
| **M3.3: UnoCSS Decision** | 20 | POC + recommendation | Go/no-go decision |
| **M3.4: Accessibility** | 20 | WCAG AA audit passed | Zero critical a11y issues |
| **M3.5: Pre-Release** | 20 | v0.9.0 published (internal) | Community feedback collected |

---

## Phase 4: Production Ready (Weeks 21-24)

### Goals
- ✅ Polish all components
- ✅ Performance optimization
- ✅ Complete documentation for Hex.pm
- ✅ Publish v1.0.0 to Hex.pm

### Sprint 11: Layout System (Week 21)

#### Objectives
- App, Container, Page, PageHeader, PageBody, PageAside, PageCTA, Header, Footer, LayoutGrid, Dashboard components (14 components)
- Production templates (Dashboard, SaaS starter)

#### Deliverables
- [ ] 14 layout components
- [ ] 2 production templates

---

### Sprint 12: Content & Auth Components (Week 22)

#### Objectives
- 12 content components (BlogPosts, Changelog, ContentNav, etc.)
- 6 auth/onboarding components (AuthForm, OTPInput, etc.)

#### Deliverables
- [ ] 18 components
- [ ] Authentication template

---

### Sprint 13: Advanced Interactions (Week 23)

#### Objectives
- 18 advanced components (ResizablePanel, TreeView, KanbanBoard, Calendar, Charts, Editors, etc.)
- Heavy JS integration (hooks for 3rd-party libs)

#### Deliverables
- [ ] 18 advanced components
- [ ] 3rd-party lib integration guide

---

### Sprint 14: Polish & Publication (Week 24)

#### Objectives
- Performance optimization (bundle size, render times)
- Final documentation pass
- Hex.pm publication prep (README, CHANGELOG, LICENSE)
- Marketing (blog post, Twitter, Elixir Forum)

#### Deliverables
- [ ] Performance report (all benchmarks met)
- [ ] Published to Hex.pm (v1.0.0)
- [ ] Blog post announcing release
- [ ] Example apps (Dashboard, Docs site)

---

### Phase 4 Milestones

| Milestone | Week | Deliverable | Success Metric |
|-----------|------|-------------|----------------|
| **M4.1: All Components** | 23 | 105 components complete | 100% documented |
| **M4.2: Performance** | 24 | Optimization complete | <100ms render, <80KB bundle |
| **M4.3: Hex.pm Published** | 24 | v1.0.0 live | 50+ downloads in Week 1 |
| **M4.4: Community Launch** | 24 | Marketing materials | Elixir Forum post, blog |

---

## 📊 Progress Tracking

### Component Completion Dashboard

| Phase | Total | Completed | In Progress | Not Started | % Complete |
|-------|-------|-----------|-------------|-------------|------------|
| **Phase 1** | 5 | 0 | 0 | 5 | 0% |
| **Phase 2** | 20 | 0 | 0 | 20 | 0% |
| **Phase 3** | 30 | 0 | 0 | 30 | 0% |
| **Phase 4** | 50 | 0 | 0 | 50 | 0% |
| **Total** | **105** | **0** | **0** | **105** | **0%** |

### Quality Metrics

| Metric | Target | Current | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|--------|--------|---------|---------|---------|---------|---------|
| **Test Coverage** | 90%+ | 0% | 60% | 80% | 85% | 90% |
| **Components** | 105 | 0 | 5 | 25 | 55 | 105 |
| **Accessibility** | WCAG AA | N/A | N/A | WCAG A | WCAG AA | WCAG AA |
| **Bundle Size** | <80KB | N/A | <30KB | <50KB | <70KB | <80KB |
| **Render Speed** | <100ms | N/A | N/A | <120ms | <110ms | <100ms |

---

## 🛠️ Development Workflow

### Sprint Cadence (2-week sprints)

```
Week 1 (Mon)     → Sprint Planning
Week 1 (Tue-Fri) → Development
Week 2 (Mon-Thu) → Development + Testing
Week 2 (Fri)     → Sprint Review + Retrospective
Weekend          → Buffer (documentation, exploration)
```

### Daily Workflow

1. **Morning**: Review PRD, check TodoWrite list
2. **Development**: Implement component(s)
3. **Quality Gates**: `mix format`, `mix credo --strict`, `mix compile --warnings-as-errors`
4. **Testing**: Unit tests + visual regression (Playwright)
5. **Documentation**: Update `@moduledoc`, showcase examples
6. **Commit**: Follow conventional commits pattern
7. **Evening**: Update sprint progress, plan next day

### Code Review Process

1. **Self-Review**: `code-reviewer` agent (pattern: `mcp-verify-first` → `code-reviewer`)
2. **Automated**: CI/CD runs tests, linters
3. **Peer Review** (optional): Internal team review
4. **Merge**: To `main` branch (no feature branches in Phase 1-2)

---

## 📦 Release Strategy

### Versioning (Semantic Versioning)

- **v0.1.0** - Phase 1 complete (Week 4) - Internal only
- **v0.5.0** - Phase 2 complete (Week 12) - Internal release
- **v0.9.0** - Phase 3 complete (Week 20) - Pre-release (community feedback)
- **v1.0.0** - Phase 4 complete (Week 24) - **Public release on Hex.pm**

### Pre-1.0 Breaking Changes
- Allowed without major version bump
- Documented in CHANGELOG
- Migration guide provided

### Post-1.0 Stability
- Breaking changes only in major versions (v2.0.0)
- Deprecation warnings for 1 minor version before removal
- LTS support (security patches for v1.x)

---

## ⚠️ Risk Mitigation

### High-Risk Items

| Risk | Mitigation | Phase | Owner |
|------|------------|-------|-------|
| **Scope Creep** | Strict phase gates, no new components until phase complete | All | Product Lead |
| **JS Complexity** | Tiered approach (LiveView.JS → Hooks → Alpine.js), POC early | Phase 2-3 | Tech Lead |
| **UnoCSS Migration** | Separate POC, no impact on Phase 2 delivery | Phase 3 | Tech Lead |
| **Accessibility Gaps** | Playwright audits per sprint, WCAG checklist | Phase 2-3 | QA Lead |
| **Team Availability** | Flexible timeline, incremental delivery | All | Project Lead |

---

## 🎯 Success Criteria (Phase Gates)

### Phase 1 → Phase 2
- [ ] 5 components working in showcase
- [ ] Theme system functional
- [ ] Test coverage > 60%
- [ ] Stakeholder approval

### Phase 2 → Phase 3
- [ ] 20 components used in xtweak_web
- [ ] Test coverage > 80%
- [ ] Internal team satisfied with DX
- [ ] No critical bugs

### Phase 3 → Phase 4
- [ ] 50+ components complete
- [ ] WCAG AA compliance passed
- [ ] UnoCSS decision made
- [ ] Pre-release feedback positive

### Phase 4 → v1.0 Release
- [ ] 105 components documented
- [ ] Performance benchmarks met
- [ ] Hex.pm package ready (README, LICENSE)
- [ ] Marketing materials ready

---

## 📞 Communication Plan

### Weekly Updates
- **Format**: Written status report
- **Distribution**: Stakeholders, team
- **Content**: Progress, blockers, next week goals

### Sprint Reviews (Every 2 Weeks)
- **Format**: Live demo
- **Attendees**: Team + stakeholders
- **Duration**: 30-60 minutes
- **Agenda**: Demo components, discuss feedback, plan next sprint

### Retrospectives (Every 2 Weeks)
- **Format**: Team discussion
- **Attendees**: Development team only
- **Duration**: 30 minutes
- **Agenda**: What went well, what to improve, action items

---

## 📚 Dependencies & Prerequisites

### Infrastructure Dependencies
- [x] Elixir 1.19.1 installed
- [x] Phoenix 1.8+ configured
- [x] Tailwind CSS 3.4.3 working
- [x] Pure Tailwind configuration (utilities only)
- [ ] `xtweak_ui/assets/` directory structure
- [ ] ExDoc configuration
- [ ] Playwright MCP setup for testing

### External Dependencies
- Heroicons (icons)
- Alpine.js (dropdowns, tooltips)
- dayjs (date handling)
- @floating-ui/dom (popover positioning)
- fuse.js (fuzzy search)
- vanilla-picker (color picker)

### Team Dependencies
- 1 FTE developer (full 24 weeks)
- 0.5 FTE QA engineer (Phase 2-4)
- 0.5 FTE technical writer (Phase 3-4)

---

## 🔄 Continuous Improvement

### Feedback Loops

1. **Internal Team** (Phase 2+): Weekly feedback on DX
2. **Stakeholders** (Every sprint): Sprint reviews
3. **Community** (Phase 3): Pre-release feedback via GitHub Discussions
4. **Production Users** (Post-v1.0): GitHub Issues, Elixir Forum

### Metrics to Track

- Component adoption rate (which components used most)
- Bundle size growth
- Test coverage trends
- Build time (dev vs production)
- Community engagement (GitHub stars, forks, issues)

---

**Next Steps**: Proceed to Sprint 1 detailed plan (06-sprint-plans/phase-1-foundation/sprint-1-infrastructure.md)
