# Sprint 2: Core Components

**Phase**: 1 (Foundation)
**Duration**: Weeks 3-4
**Target Completion**: November 14, 2025
**Status**: 🚧 Planned

---

## Sprint Objectives

- Implement 4 additional core components (Badge, Avatar, Card, Alert, Divider)
- Validate component patterns established in Sprint 1
- Demonstrate slot patterns (:header, :footer) with Card and Alert
- Achieve >60% test coverage milestone
- Create comprehensive showcase pages for all components

---

## Success Criteria

- [ ] All 5 components (Button + 4 new) fully functional in showcase
- [ ] Test coverage exceeds 60% (currently at 53 passing tests)
- [ ] 20+ unit tests added for new components
- [ ] 5+ visual regression tests (Playwright) added
- [ ] All components properly themed (light/dark mode support)
- [ ] Zero Credo warnings (`mix credo --strict`)
- [ ] Zero Dialyzer warnings
- [ ] All quality gates passing
- [ ] Documentation complete for each component

---

## Tasks

### Task 1: Implement Badge Component
**Agent**: `frontend-design-enforcer` (Sonnet)
**Description**: Create Badge component with full Nuxt UI API support (color, variant, size)
**Dependencies**: None (foundation ready from Sprint 1)
**Estimated Complexity**: Low
**Success Criteria**:
- [ ] Badge component renders with all color variants (gray, primary, success, warning, error)
- [ ] Supports all size variants (xs, sm, md, lg)
- [ ] Supports variant styles (solid, outline, soft, subtle)
- [ ] Proper theme integration (OKLCH colors)
- [ ] Unit tests cover all props and variants
- [ ] Showcase page with interactive examples
- [ ] Documentation with API reference

**Files to Create/Modify**:
- `apps/xtweak_ui/lib/xtweak_ui/components/badge.ex`
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/badge_live.ex`
- `apps/xtweak_ui/test/xtweak_ui/components/badge_test.exs`

---

### Task 2: Implement Avatar Component
**Agent**: `frontend-design-enforcer` (Sonnet)
**Description**: Create Avatar component with image fallback, initials, and size variants
**Dependencies**: None
**Estimated Complexity**: Low
**Success Criteria**:
- [ ] Avatar displays image with proper aspect ratio
- [ ] Fallback to initials when no image provided
- [ ] Supports size variants (xs, sm, md, lg, xl)
- [ ] Optional status indicator (online, offline, away)
- [ ] Proper theme integration
- [ ] Unit tests for all display modes
- [ ] Showcase page with examples
- [ ] Documentation with API reference

**Files to Create/Modify**:
- `apps/xtweak_ui/lib/xtweak_ui/components/avatar.ex`
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/avatar_live.ex`
- `apps/xtweak_ui/test/xtweak_ui/components/avatar_test.exs`

---

### Task 3: Implement Card Component
**Agent**: `frontend-design-enforcer` (Sonnet)
**Description**: Create Card component with slot patterns (:header, :footer, default)
**Dependencies**: None
**Estimated Complexity**: Medium
**Success Criteria**:
- [ ] Card component supports :header slot
- [ ] Card component supports :footer slot
- [ ] Card component supports default slot (body content)
- [ ] Optional padding variants (none, sm, md, lg)
- [ ] Optional border and shadow variants
- [ ] Proper theme integration
- [ ] Unit tests for all slot combinations
- [ ] Showcase page demonstrating complex slot scenarios
- [ ] Documentation with slot pattern examples

**Files to Create/Modify**:
- `apps/xtweak_ui/lib/xtweak_ui/components/card.ex`
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/card_live.ex`
- `apps/xtweak_ui/test/xtweak_ui/components/card_test.exs`

---

### Task 4: Implement Alert Component
**Agent**: `frontend-design-enforcer` (Sonnet)
**Description**: Create Alert component with severity variants and optional slots
**Dependencies**: None
**Estimated Complexity**: Medium
**Success Criteria**:
- [ ] Alert component supports severity types (info, success, warning, error)
- [ ] Supports :title slot for alert heading
- [ ] Supports :actions slot for buttons/links
- [ ] Optional close button with dismiss callback
- [ ] Proper ARIA attributes for accessibility
- [ ] Icon integration (default icons per severity)
- [ ] Proper theme integration
- [ ] Unit tests for all severity types and slots
- [ ] Showcase page with interactive examples
- [ ] Documentation with accessibility notes

**Files to Create/Modify**:
- `apps/xtweak_ui/lib/xtweak_ui/components/alert.ex`
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/alert_live.ex`
- `apps/xtweak_ui/test/xtweak_ui/components/alert_test.exs`

---

### Task 5: Implement Divider Component
**Agent**: `frontend-design-enforcer` (Sonnet)
**Description**: Create Divider component for layout separation (horizontal/vertical)
**Dependencies**: None
**Estimated Complexity**: Low
**Success Criteria**:
- [ ] Divider supports horizontal and vertical orientation
- [ ] Optional label/text in center of divider
- [ ] Customizable thickness and color
- [ ] Proper theme integration (uses border colors)
- [ ] Unit tests for all orientations
- [ ] Showcase page with layout examples
- [ ] Documentation with usage patterns

**Files to Create/Modify**:
- `apps/xtweak_ui/lib/xtweak_ui/components/divider.ex`
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/divider_live.ex`
- `apps/xtweak_ui/test/xtweak_ui/components/divider_test.exs`

---

### Task 6: Visual Regression Testing (Playwright)
**Agent**: `test-builder` (Sonnet)
**Description**: Add Playwright visual regression tests for all 5 components
**Dependencies**: Tasks 1-5 (components must be implemented first)
**Estimated Complexity**: Medium
**Success Criteria**:
- [ ] Playwright tests capture screenshots of each component in light mode
- [ ] Playwright tests capture screenshots of each component in dark mode
- [ ] Screenshots cover all major variants per component
- [ ] Baseline screenshots saved for future regression testing
- [ ] Tests verify theme switching works correctly
- [ ] Test suite runs in CI (if applicable)
- [ ] Documentation on running Playwright tests

**Files to Create/Modify**:
- `apps/xtweak_web/test/xtweak_web_web/playwright/components/badge_test.exs` (or similar structure)
- Playwright test scripts (location TBD based on existing test structure)
- Update test documentation

---

### Task 7: Component Unit Test Suite
**Agent**: `test-builder` (Sonnet)
**Description**: Ensure comprehensive unit test coverage for all components
**Dependencies**: Tasks 1-5 (components must be implemented first)
**Estimated Complexity**: Medium
**Success Criteria**:
- [ ] Badge: 5+ tests (variants, colors, sizes)
- [ ] Avatar: 6+ tests (image, initials, fallback, sizes, status)
- [ ] Card: 8+ tests (slots, padding, borders, shadows, combinations)
- [ ] Alert: 8+ tests (severity, slots, close, accessibility)
- [ ] Divider: 3+ tests (orientations, labels)
- [ ] All tests passing
- [ ] Test coverage >60% overall
- [ ] Documentation on running test suite

**Files to Verify/Enhance**:
- All `*_test.exs` files created in Tasks 1-5
- Coverage report generation
- CI integration (if applicable)

---

### Task 8: Showcase Documentation & Polish
**Agent**: `docs-maintainer` (Haiku)
**Description**: Create comprehensive showcase pages and documentation for all components
**Dependencies**: Tasks 1-7 (all components and tests complete)
**Estimated Complexity**: Low
**Success Criteria**:
- [ ] Each component has dedicated showcase page at `/showcase/{component}`
- [ ] Showcase demonstrates all variants and use cases
- [ ] Interactive examples allow testing different props
- [ ] Code examples visible for each demo
- [ ] API reference table for each component
- [ ] Accessibility notes included
- [ ] Theme switching works on all pages
- [ ] Navigation updated to include all components

**Files to Create/Modify**:
- All showcase LiveView files from Tasks 1-5
- `apps/xtweak_web/lib/xtweak_web_web/live/showcase/showcase_live.ex` (navigation)
- Component documentation (inline or separate markdown)

---

## Agent Assignments Summary

- **`mcp-verify-first`** (Haiku): Context verification before each task (always first step)
- **`frontend-design-enforcer`** (Sonnet): Tasks 1-5 (all component implementations)
- **`test-builder`** (Sonnet): Tasks 6-7 (visual regression and unit tests)
- **`docs-maintainer`** (Haiku): Task 8 (showcase documentation and polish)
- **`code-reviewer`** (Sonnet): Final review after all tasks complete

---

## Quality Gates

All gates must pass before declaring sprint complete:

- [ ] All code formatted (`mix format`)
- [ ] No Credo violations (`mix credo --strict`)
- [ ] No compiler warnings (`mix compile --warnings-as-errors`)
- [ ] All tests passing (`mix test`)
  - [ ] Unit tests: 20+ new tests
  - [ ] Total tests: 73+ passing (53 existing + 20 new)
  - [ ] Coverage: >60%
- [ ] Playwright tests passing (5+ visual regression tests)
- [ ] Zero Dialyzer warnings (`mix dialyzer`)
- [ ] All components render correctly in showcase at `localhost:4000/showcase`
- [ ] Theme switching works (light/dark) on all components
- [ ] No migrations needed (no Ash resources in this sprint)

---

## Risks & Mitigation

### Risk 1: Slot Pattern Complexity (Card, Alert)
**Description**: HEEx slot patterns may have edge cases or rendering issues
**Mitigation**:
- Reference Sprint 1 Button implementation as pattern baseline
- Use `mcp-verify-first` to check existing slot usage in codebase
- Consult `/usage-rules/heex.md` for HEEx best practices
- Test slot combinations thoroughly (empty slots, multiple slots, nested content)

### Risk 2: Theme Integration Issues
**Description**: New components may not properly inherit theme colors
**Mitigation**:
- Follow established CSS variable patterns from Sprint 1
- Verify OKLCH color usage matches theme system
- Test both light and dark modes during development
- Use Playwright to catch visual regressions

### Risk 3: Test Coverage Target (>60%)
**Description**: May be challenging to reach 60% coverage with only 20 new tests
**Mitigation**:
- Prioritize high-value test cases (common use cases, edge cases)
- Use parameterized tests where applicable (test multiple variants in one test)
- Focus on critical paths (rendering, prop handling, slots)
- Track coverage incrementally with each component

### Risk 4: Playwright Test Setup
**Description**: Visual regression testing may require additional setup or tooling
**Mitigation**:
- Leverage existing Playwright MCP tools (already available)
- Start with basic screenshot tests, enhance iteratively
- Document baseline screenshot generation process
- Accept that initial baselines may need refinement

---

## Estimated Duration

**Total**: 5-7 developer-days

**Breakdown**:
- Task 1 (Badge): 0.5 days
- Task 2 (Avatar): 0.5 days
- Task 3 (Card): 1 day
- Task 4 (Alert): 1 day
- Task 5 (Divider): 0.5 days
- Task 6 (Playwright): 1.5 days
- Task 7 (Unit Tests): 1 day
- Task 8 (Showcase/Docs): 1 day

**Parallelization Opportunities**:
- Tasks 1-5 can be done sequentially but rapidly (3.5 days total)
- Tasks 6-7 can overlap partially (both testing-focused)
- Task 8 can begin as soon as showcase pages exist (Tasks 1-5 complete)

**Target Completion**: November 14, 2025 (end of Week 4)

---

## Related Documentation

### PRD Sections
- [05-implementation-roadmap.md](../05-implementation-roadmap.md) - Phase 1 Sprint 2 details
- [QUICK_START.md](../QUICK_START.md) - Current status tracking
- [.prd-completion-status.md](../.prd-completion-status.md) - Completion tracking

### Framework Rules (Usage Rules)
Agents should consult these files from `/usage-rules/`:
- `heex.md` - HEEx template conventions (slot patterns critical for Card/Alert)
- `phoenix.md` - Phoenix/LiveView conventions
- `ash_phoenix.md` - Ash + Phoenix integration (minimal for this sprint)

### Usage Rules (Framework-Specific)
No additional usage rules required for this sprint (no Ash resources, pure UI components).

### Patterns (`.claude/patterns/`)
- `mcp-verify-first.md` - Always run before starting each task
- `frontend-design-enforcer.md` - Component implementation patterns
- `self-check-core.md` - Quality validation before handoff
- `collaboration-handoff.md` - Sprint completion summary format

### Previous Sprint
- [sprint-1-infrastructure.md](./sprint-1-infrastructure.md) - Sprint 1 reference (Button implementation, theme system)
- [sprint-1-REPORTS.md](./sprint-1-REPORTS.md) - Sprint 1 execution log

---

## Notes

### Lessons from Sprint 1
- Button implementation went smoothly, validates component patterns
- Theme system (OKLCH + CSS variables) works well
- Asset pipeline is performant (26KB bundle, under 30KB target)
- Showcase app at `localhost:4000/showcase` is effective for demos
- Quality gates (Credo, Dialyzer, tests) caught issues early

### Sprint 2 Focus Areas
- **Slot patterns**: Card and Alert will validate more complex slot usage
- **Accessibility**: Alert component requires proper ARIA attributes
- **Visual testing**: Playwright integration is new, document setup clearly
- **Test coverage**: Reaching >60% is a key milestone for Phase 1 completion

### Post-Sprint 2 (Phase 1 Gate)
After Sprint 2 completion, Phase 1 should be ready for stakeholder demo (M1.4):
- 5 components working in live showcase
- Theme system proven across multiple components
- Test coverage >60%
- All quality gates established and passing

**Phase 2** will expand to 20 additional components (form inputs, navigation, overlays, etc.).
