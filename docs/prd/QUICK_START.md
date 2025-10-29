# Quick Start: Begin Sprint 1

**Created**: 2025-10-29 (Revised)
**Status**: 🟢 Ready to Begin
**First Sprint**: Sprint 1 - Infrastructure Setup (Week 1-2)

---

## 🎯 Project Goal (Crystal Clear)

**Port Nuxt UI component library to Phoenix/LiveView**

- **What**: 100+ components from https://ui.nuxt.com
- **How**: Fresh implementations using Phoenix.Component API
- **Theming**: Elixir module (like Nuxt UI's app.config.ts) + CSS variables
- **No**: Component frameworks, existing components, or shortcuts - clean slate!

---

## 🚀 Immediate Next Steps (Today!)

### 1. Review Sprint 1 Plan (30 min)

Read the complete plan:
```bash
cat docs/prd/06-sprint-plans/phase-1-foundation/sprint-1-infrastructure.md
```

Key tasks:
1. **Elixir Theme Module** - XTweakUI.Theme (like app.config.ts)
2. **CSS Variables** - Nuxt UI's semantic tokens
3. **Asset Pipeline** - Pure Tailwind, no UI frameworks
4. **Button Component** - Fresh Nuxt UI port (first component!)

### 2. Set Up Asset Directory (15 min)

```bash
cd /home/fodurrr/dev/xTweak/apps/xtweak_ui

# Create directory structure
mkdir -p assets/css assets/js priv/static/assets

# Initialize package.json
cd assets
cat > package.json << 'EOF'
{
  "name": "xtweak_ui_assets",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "build": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css",
    "watch": "tailwindcss -i css/app.css -o ../priv/static/assets/app.css --watch",
    "deploy": "NODE_ENV=production tailwindcss -i css/app.css -o ../priv/static/assets/app.css --minify"
  },
  "devDependencies": {
    "@tailwindcss/forms": "^0.5.9",
    "tailwindcss": "^3.4.3"
  }
}
EOF

# Install dependencies
npm install
```

### 3. Start First Task: Theme Module (Day 1)

Create `lib/xtweak_ui/theme.ex`:

```elixir
defmodule XTweakUI.Theme do
  @moduledoc """
  Theme configuration for xTweak UI components.

  Inspired by Nuxt UI's app.config.ts.
  """

  @default_theme %{
    primary: "blue",
    colors: %{
      primary: %{
        500: "oklch(60% 0.20 240)"
        # ... more colors
      }
    },
    components: %{
      button: %{
        default: %{variant: "solid", size: "md"}
      }
    }
  }

  def get, do: Application.get_env(:xtweak_ui, :theme, @default_theme)
  def component_config(component), do: get()[:components][component] || %{}
end
```

See full implementation in Sprint 1 plan!

---

## 📋 Sprint 1 Day-by-Day Breakdown

### Week 1: Foundation

**Day 1-2** (12 hours): Elixir Theme Module
- Create `XTweakUI.Theme` module
- CSS variables in `assets/css/theme.css`
- Tailwind config using CSS variables
- Write tests
- ✅ **Deliverable**: Theme system working

**Day 3-4** (16 hours): Asset Pipeline
- Complete `package.json` with scripts
- Tailwind configuration (pure utilities, NO component frameworks)
- Mix aliases (`mix assets.build`, `mix assets.watch`)
- Test build: `mix assets.build` → `priv/static/assets/app.css`
- ✅ **Deliverable**: Build pipeline working

**Day 5** (4 hours): Hook System Skeleton
- Create `assets/js/hooks.js` (empty for now)
- Export `XTweakUIHooks` object
- ✅ **Deliverable**: Ready for Phase 2-3 JS integration

### Week 2: First Component + Showcase

**Day 6-8** (24 hours): Button Component
- Implement full Nuxt UI Button API
  - Props: `color`, `variant`, `size`, `loading`, `icon`, `disabled`
  - Variants: solid, outline, soft, ghost, link
  - Sizes: xs, sm, md, lg, xl
- Write comprehensive tests (>80% coverage)
- ExDoc documentation
- ✅ **Deliverable**: Production-ready Button component

**Day 9-10** (28 hours): Showcase
- Create `ShowcaseLive` in xtweak_web
- Plain HTML structure (pure Tailwind utilities)
- Theme switcher (light/dark)
- Button demos (all variants, sizes, states)
- ✅ **Deliverable**: Live showcase at `localhost:4000`

---

## 💻 Command Reference

### Daily Workflow

```bash
# Start from xTweak root
cd /home/fodurrr/dev/xTweak

# Work on xtweak_ui
cd apps/xtweak_ui

# Watch CSS changes (in separate terminal)
cd assets && npm run watch

# Run tests
mix test

# Quality gates (before committing)
mix format
mix credo --strict
mix compile --warnings-as-errors

# Generate docs
mix docs
```

### First Time Setup

```bash
cd apps/xtweak_ui

# Install Elixir deps
mix deps.get

# Install Node deps
cd assets && npm install

# Build CSS
npm run build

# Check output
ls -lh ../priv/static/assets/app.css
# Should be ~25-30KB
```

---

## 🔧 Using MCP Tools

### Before Writing Code

Always verify APIs first:

```elixir
# Check Nuxt UI Button API
mcp__context7__resolve-library-id "nuxt-ui"
mcp__context7__get-library-docs "/ui.nuxt.com/llmstxt" --topic "button component"

# Check Phoenix LiveView patterns
mcp__tidewave__get_docs "Phoenix.Component"

# Evaluate Elixir code
mcp__tidewave__project_eval "Application.get_env(:xtweak_ui, :theme)"
```

### During Development

```elixir
# Check logs for errors
mcp__tidewave__get_logs --tail 50

# Get Ash usage rules (if needed for xtweak_core)
mcp__ash_ai__get_usage_rules
```

---

## ✅ Sprint 1 Success Criteria

By end of Week 2, you should have:

### Functional
- [ ] Theme switching works (light/dark) via data-theme attribute
- [ ] Button component renders with all variants
- [ ] Showcase accessible at `http://localhost:4000/showcase`

### Quality
- [ ] CSS bundle < 30KB (gzipped, Tailwind only)
- [ ] Test coverage > 80% (for Button component)
- [ ] Zero Credo warnings (strict mode)
- [ ] Zero Dialyzer warnings
- [ ] Zero compiler warnings

### Documentation
- [ ] `XTweakUI.Theme` has `@moduledoc`
- [ ] Button component has `@moduledoc` with examples
- [ ] ExDoc generates successfully

---

## 🎨 What the Final Result Looks Like

### Showcase Page (Week 2 End)

```
┌──────────────────────────────────────────┐
│ xTweak UI               [🌙 Dark Theme]  │ ← Header with theme switcher
├──────────────────────────────────────────┤
│                                          │
│  Button                                  │ ← Component title
│  Button component with variants...       │
│                                          │
│  Variants                                │
│  [Solid] [Outline] [Soft] [Ghost] [Link]│ ← Live Button demos
│                                          │
│  Colors                                  │
│  [Primary] [Success] [Warning] [Error]   │
│                                          │
│  Sizes                                   │
│  [XS] [SM] [MD] [LG] [XL]               │
│                                          │
│  States                                  │
│  [Normal] [⟳ Loading] [Disabled]        │
│                                          │
│  Code Example                            │
│  <.button color="primary">              │
│    Click me                              │
│  </.button>                              │
│                                          │
└──────────────────────────────────────────┘
```

All plain HTML + Tailwind + xTweak UI components. **Pure Tailwind utilities only!**

---

## 🚫 Common Pitfalls to Avoid

1. **Don't use existing components**
   - ❌ Enhancing Button/Card/Alert/Modal
   - ✅ Starting fresh with Nuxt UI API

2. **Use pure Tailwind utilities**
   - ❌ Component framework classes: `class="btn btn-primary"`
   - ✅ Pure Tailwind utilities: `class="bg-primary-500 text-white hover:bg-primary-600"`
   - ✅ CSS variables for theming: `rgb(var(--color-primary))`

3. **Don't skip the Theme module**
   - ❌ Hardcoding colors in components
   - ✅ Using `XTweakUI.Theme.component_config(:button)`

4. **Don't over-engineer**
   - ❌ Complex theming logic in Sprint 1
   - ✅ Simple CSS variables + Elixir config

---

## 📚 Key Resources

### Documentation
- **Nuxt UI**: https://ui.nuxt.com/
- **Nuxt UI Button**: https://ui.nuxt.com/components/button
- **Phoenix.Component**: https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html
- **Tailwind CSS**: https://tailwindcss.com/
- **OKLCH Colors**: https://oklch.com/

### Sprint 1 Plan
- **Full details**: `docs/prd/06-sprint-plans/phase-1-foundation/sprint-1-infrastructure.md`
- **Read this first** before coding!

---

## 🎯 After Sprint 1: What's Next?

**Sprint 2 (Week 3-4)**: Core Components
- Badge
- Avatar
- Card (fresh implementation)
- Alert (fresh implementation)
- Divider

All following the same pattern:
1. Study Nuxt UI API
2. Implement in Phoenix
3. Write tests
4. Add to showcase

---

## 💡 Tips for Success

### 1. Study Nuxt UI First
Before implementing any component:
```bash
# Use Context7 MCP to get exact API
mcp__context7__get-library-docs "/ui.nuxt.com/llmstxt" --topic "<component-name>"
```

### 2. Test Continuously
```bash
# Run tests on every change
mix test --stale
```

### 3. Commit Small, Commit Often
```bash
git add apps/xtweak_ui/lib/xtweak_ui/theme.ex
git commit -m "feat(theme): add XTweakUI.Theme module"
```

### 4. Use TodoWrite Tool
```elixir
# Track your progress
TodoWrite.update([
  %{content: "Create Theme module", status: "in_progress"},
  %{content: "Write theme tests", status: "pending"}
])
```

---

## 🏁 Ready to Start?

**Choose your entry point:**

### Option A: Read Full Sprint Plan
```bash
cat docs/prd/06-sprint-plans/phase-1-foundation/sprint-1-infrastructure.md
```

### Option B: Dive Right In
```bash
cd apps/xtweak_ui
mkdir -p assets/css assets/js lib/xtweak_ui/components
touch lib/xtweak_ui/theme.ex
```

### Option C: Ask Questions
If anything is unclear, ask! The goal is:
- **Clean slate** (no existing components)
- **Pure Nuxt UI port** (match their API)
- **Simple** (no over-engineering)

---

🚀 **Let's build xTweak UI - the Nuxt UI of Phoenix!**
