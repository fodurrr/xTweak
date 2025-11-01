# xTweak UI Component Library Documentation

**Last Updated**: November 1, 2025

Complete documentation for the xTweak UI component library - a Phoenix LiveView component library with Tailwind CSS styling.

---

## 📚 Available Documentation

### [SHOWCASE_GUIDE.md](./SHOWCASE_GUIDE.md)
**Interactive Component Showcase Guide**

Learn how to use the live component showcase to explore all components, test theme switching, and copy code examples.

**Covers:**
- Getting started with the showcase
- Component overview and features
- Theme switching and responsive design
- Testing and troubleshooting

**Audience**: End users, designers, testers

---

### [COMPONENT_API_REFERENCE.md](./COMPONENT_API_REFERENCE.md)
**Complete Component API Reference**

Comprehensive API documentation for all components with props, slots, events, and code examples.

**Components Documented** (6 total):
1. **Button** - Interactive buttons with variants, colors, sizes, icons
2. **Badge** - Labels and status indicators
3. **Avatar** - User profile images with fallbacks
4. **Card** - Container component with header/footer
5. **Alert** - Contextual feedback messages
6. **Divider** - Visual content separators

**Audience**: Developers, implementers

---

## 🚀 Quick Start

### View the Live Showcase
```bash
mix phx.server
# Visit: http://localhost:4000/showcase
```

### Use a Component
```elixir
# In your LiveView template
<.badge variant="solid" color="primary" size="md">
  New
</.badge>
```

### Get Component Help
```elixir
iex> h XTweakUI.Components.Badge.badge
# Shows all props, slots, and examples
```

---

## 📊 Component Library Stats

- **Total Components**: 6 (1 from Sprint 1, 5 from Sprint 2)
- **Test Coverage**: 74.69% (201+ tests)
- **Documentation**: 1,700+ lines
- **Quality Gates**: All passing ✅

---

## 🎨 Design System

### Theme Support
- **Light Mode**: Light backgrounds, dark text
- **Dark Mode**: Dark backgrounds, light text
- **CSS Variables**: Centralized theming system
- **OKLCH Colors**: Modern color space for better perceptual uniformity

### Color Palette
- Primary, Secondary, Success, Warning, Error, Neutral
- Semantic colors for status and feedback
- Accessible contrast ratios (WCAG 2.1 AA)

### Size System
- **Compact**: xs, sm (dense layouts)
- **Standard**: md (default)
- **Spacious**: lg, xl, 2xl, 3xl (emphasis)

---

## 📖 Documentation Organization

### For This App (xtweak_ui)
- **docs/** - App-specific documentation (you are here!)
- **lib/xtweak_ui/components/** - Component source code with inline docs
- **test/xtweak_ui/components/** - Component tests (usage examples)

### For the Project
- **Human_docs/** - Project-wide workflow and coordination docs
- **AI_docs/** - AI-facing PRD, sprint plans, architecture docs

---

## 🔗 Related Documentation

### Project Documentation
- [Human_docs/README.md](../../../Human_docs/README.md) - Main documentation index
- [Human_docs/COMPLETE_WORKFLOW_GUIDE.md](../../../Human_docs/COMPLETE_WORKFLOW_GUIDE.md) - Claude Code workflow

### Framework Documentation
- **Phoenix LiveView**: https://hexdocs.pm/phoenix_live_view/
- **Tailwind CSS**: https://tailwindcss.com/
- **Hero Icons**: https://heroicons.com/

### Design Inspiration
- **Nuxt UI**: https://ui.nuxt.com/ (design reference)

---

## 💡 Common Questions

### Q: How do I add a new component?
1. Create component file in `lib/xtweak_ui/components/`
2. Create test file in `test/xtweak_ui/components/`
3. Add to showcase in `apps/xtweak_web/lib/xtweak_web_web/live/showcase_live.ex`
4. Document in `COMPONENT_API_REFERENCE.md`

### Q: How do I customize component styles?
Components use Tailwind CSS utilities and CSS variables from the theme system. See `lib/xtweak_ui/theme.ex` for color definitions.

### Q: Where are the component tests?
All component tests are in `test/xtweak_ui/components/`. Run with:
```bash
mix test apps/xtweak_ui/test/xtweak_ui/components/
```

### Q: How do I contribute?
See [CLAUDE.md](../../../CLAUDE.md) for development guidelines and [MANDATORY_AI_RULES.md](../../../MANDATORY_AI_RULES.md) for project rules.

---

## 📝 Keeping Docs Updated

When making changes to components:
- Update inline moduledocs in component files
- Update COMPONENT_API_REFERENCE.md if props/slots change
- Update SHOWCASE_GUIDE.md if showcase features change
- Add/update tests in component test files
- Update showcase examples if behavior changes

---

## 🎯 Next Steps

1. **Explore**: Visit the [showcase](http://localhost:4000/showcase) to see all components in action
2. **Learn**: Read [SHOWCASE_GUIDE.md](./SHOWCASE_GUIDE.md) for interactive guide
3. **Implement**: Use [COMPONENT_API_REFERENCE.md](./COMPONENT_API_REFERENCE.md) for API details
4. **Test**: Check component tests for usage examples

---

**Happy building!** 🚀

For project-wide documentation, see [Human_docs/README.md](../../../Human_docs/README.md)
