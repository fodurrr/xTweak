# Component Inventory: Nuxt UI → Phoenix/Elixir Mapping

**Document Version**: 1.0.0
**Date**: 2025-10-29
**Status**: ✅ Complete
**Total Components**: 105 (Nuxt UI baseline: 100+)

---

## 📋 Component Priority Matrix

Components categorized by implementation phase based on:
- **Usage Frequency**: How often needed in typical apps
- **Complexity**: Technical implementation difficulty
- **JS Requirements**: Amount of client-side JavaScript needed
- **MVP Necessity**: Critical for Phase 2 internal release

---

## Phase 1: Foundation (5 Components) - Week 1-4

| # | Component | Nuxt UI API | Phoenix Equivalent | Complexity | JS Required | Status |
|---|-----------|-------------|-------------------|------------|-------------|--------|
| 1 | **Button** | `<UButton>` | `<.button>` | 🟢 Low | ❌ None | 🔴 Enhance |
| 2 | **Badge** | `<UBadge>` | `<.badge>` | 🟢 Low | ❌ None | 🔴 To Do |
| 3 | **Card** | `<UCard>` | `<.card>` | 🟢 Low | ❌ None | 🔴 Enhance |
| 4 | **Alert** | `<UAlert>` | `<.alert>` | 🟢 Low | ❌ None | 🔴 Enhance |
| 5 | **Avatar** | `<UAvatar>` | `<.avatar>` | 🟢 Low | ❌ None | 🔴 To Do |

### Implementation Notes
- **Purpose**: Validate infrastructure (theming, asset pipeline, showcase)
- **Approach**: Pure Tailwind utilities + Nuxt UI API layer + CSS variables
- **Testing**: Unit tests + visual regression (Playwright)
- **Deliverable**: Working showcase in xtweak_docs with theme switcher

---

## Phase 2: MVP Components (20 Components) - Week 5-12

### 2A. Form Components (6 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 6 | **Input** | `<UInput>` | `<.input>` | 🟡 Medium | ❌ None | Phoenix.HTML.Form integration |
| 7 | **Textarea** | `<UTextarea>` | `<.textarea>` | 🟡 Medium | ❌ None | Auto-resize optional (JS hook) |
| 8 | **Select** | `<USelect>` | `<.select>` | 🟡 Medium | ❌ None | Native `<select>`, no JS |
| 9 | **Checkbox** | `<UCheckbox>` | `<.checkbox>` | 🟢 Low | ❌ None | ARIA labels |
| 10 | **Radio** | `<URadio>` | `<.radio>` | 🟢 Low | ❌ None | RadioGroup wrapper |
| 11 | **FormGroup** | `<UFormGroup>` | `<.form_field>` | 🟡 Medium | ❌ None | Label + error display |

**Key Features**:
- LiveView form integration (`Phoenix.HTML.Form`)
- Client-side validation (via `phx-change`)
- Server-side error display
- Accessibility (labels, ARIA, focus management)

---

### 2B. Navigation (5 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 12 | **Link** | `<ULink>` | `<.link>` | 🟢 Low | ❌ None | `Phoenix.Component.link/1` wrapper |
| 13 | **Dropdown** | `<UDropdown>` | `<.dropdown>` | 🟠 High | ✅ Alpine.js | Click-outside, keyboard nav |
| 14 | **Tabs** | `<UTabs>` | `<.tabs>` | 🟡 Medium | ⚠️ LiveView.JS | Tab switching via assigns |
| 15 | **Breadcrumb** | `<UBreadcrumb>` | `<.breadcrumb>` | 🟢 Low | ❌ None | Simple list rendering |
| 16 | **Pagination** | `<UPagination>` | `<.pagination>` | 🟡 Medium | ❌ None | LiveView events for page change |

**Key Features**:
- **Dropdown**: Alpine.js for local state, `phx-click` for actions
- **Tabs**: LiveView assigns for active tab, optional URL sync
- **Pagination**: Server-side rendering, `phx-click` events

---

### 2C. Feedback (5 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 17 | **Modal** | `<UModal>` | `<.modal>` | 🟡 Medium | ⚠️ LiveView.JS | Focus trap, escape key, backdrop click |
| 18 | **Toast** | `useToast()` | `XTweakUI.Toast` | 🟠 High | ❌ None | PubSub + GenServer, LiveView component |
| 19 | **Tooltip** | `<UTooltip>` | `<.tooltip>` | 🟡 Medium | ⚠️ LiveView.JS | Hover state, positioning (CSS or Floating UI) |
| 20 | **Progress** | `<UProgress>` | `<.progress>` | 🟢 Low | ❌ None | CSS percentage width |
| 21 | **Skeleton** | `<USkeleton>` | `<.skeleton>` | 🟢 Low | ❌ None | Loading placeholder (CSS animation) |

**Key Features**:
- **Modal**: LiveView.JS for show/hide, ARIA dialog role
- **Toast**: GenServer for queue, PubSub broadcast to LiveViews
- **Tooltip**: CSS-only hover or Floating UI for advanced positioning

---

### 2D. Layout (4 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 22 | **Divider** | `<UDivider>` | `<.divider>` | 🟢 Low | ❌ None | Horizontal/vertical line |
| 23 | **Kbd** | `<UKbd>` | `<.kbd>` | 🟢 Low | ❌ None | Keyboard shortcut display |
| 24 | **Chip** | `<UChip>` | `<.chip>` | 🟢 Low | ❌ None | Small badge/pill |
| 25 | **Icon** | `<UIcon>` | `<.icon>` | 🟢 Low | ❌ None | Heroicons integration |

**Phase 2 Total**: 20 components (Button already exists, so 19 new)

---

## Phase 3: Extended Components (30 Components) - Week 13-20

### 3A. Advanced Forms (9 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 26 | **SelectMenu** | `<USelectMenu>` | `<.select_menu>` | 🟠 High | ✅ LiveView Hook | Searchable dropdown, keyboard nav |
| 27 | **InputMenu** | `<UInputMenu>` | `<.input_menu>` | 🟠 High | ✅ LiveView Hook | Autocomplete/combobox |
| 28 | **RadioGroup** | `<URadioGroup>` | `<.radio_group>` | 🟡 Medium | ❌ None | Accessible radio set |
| 29 | **Toggle** | `<UToggle>` | `<.toggle>` | 🟡 Medium | ⚠️ LiveView.JS | Switch/toggle component |
| 30 | **Range** | `<URange>` | `<.range>` | 🟡 Medium | ⚠️ JS Hook | Slider input |
| 31 | **ColorPicker** | `<UColorInput>` | `<.color_picker>` | 🔴 Very High | ✅ JS Hook | Color preview, HSL/RGB, vanilla-picker lib |
| 32 | **DatePicker** | `<UDatePicker>` (N/A) | `<.date_picker>` | 🔴 Very High | ✅ JS Hook | Calendar navigation, dayjs integration |
| 33 | **TimePicker** | N/A (Nuxt UI Pro) | `<.time_picker>` | 🟠 High | ✅ JS Hook | Time selection UI |
| 34 | **FileUpload** | `<UFileInput>` (N/A) | `<.file_upload>` | 🔴 Very High | ✅ LiveView Upload | Drag-and-drop, preview, Phoenix.LiveView.Uploads |

---

### 3B. Navigation & Menu (7 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 35 | **VerticalNavigation** | `<UVerticalNavigation>` | `<.vertical_nav>` | 🟡 Medium | ❌ None | Sidebar navigation |
| 36 | **HorizontalNavigation** | `<UHorizontalNavigation>` | `<.horizontal_nav>` | 🟡 Medium | ❌ None | Top navbar |
| 37 | **NavigationMenu** | `<UNavigationMenu>` | `<.navigation_menu>` | 🟠 High | ✅ Alpine.js | Multi-level menu |
| 38 | **ContextMenu** | `<UContextMenu>` | `<.context_menu>` | 🟠 High | ✅ JS Hook | Right-click menu |
| 39 | **CommandPalette** | `<UCommandPalette>` | `<.command_palette>` | 🔴 Very High | ✅ JS Hook + LiveView | Cmd+K search, fuzzy search (fuse.js) |
| 40 | **Accordion** | `<UAccordion>` | `<.accordion>` | 🟡 Medium | ⚠️ LiveView.JS | Collapsible sections |
| 41 | **Carousel** | `<UCarousel>` | `<.carousel>` | 🟠 High | ✅ JS Hook | Swipe gestures, auto-play |

---

### 3C. Data Display (8 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 42 | **Table** | `<UTable>` | `<.table>` | 🟠 High | ⚠️ LiveView | Sorting, pagination, selection |
| 43 | **AvatarGroup** | `<UAvatarGroup>` | `<.avatar_group>` | 🟡 Medium | ❌ None | Stacked avatars |
| 44 | **Meter** | `<UMeter>` | `<.meter>` | 🟢 Low | ❌ None | Progress meter/gauge |
| 45 | **Timeline** | N/A (custom) | `<.timeline>` | 🟡 Medium | ❌ None | Vertical timeline |
| 46 | **Stepper** | `<UStepper>` | `<.stepper>` | 🟡 Medium | ❌ None | Multi-step form indicator |
| 47 | **User** | `<UUser>` | `<.user>` | 🟢 Low | ❌ None | User card (avatar + name) |
| 48 | **ContentSearch** | `<UContentSearch>` | `<.content_search>` | 🟠 High | ✅ LiveView | Search input with results |
| 49 | **BlogPost** | `<UBlogPost>` | `<.blog_post>` | 🟡 Medium | ❌ None | Blog post card |

---

### 3D. Overlays (6 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 50 | **Slideover** | `<USlideover>` | `<.slideover>` | 🟡 Medium | ⚠️ LiveView.JS | Side panel (like modal) |
| 51 | **Popover** | `<UPopover>` | `<.popover>` | 🟠 High | ✅ Floating UI | Positioning library required |
| 52 | **Dialog** | `<UDialog>` | `<.dialog>` | 🟡 Medium | ⚠️ LiveView.JS | Simple confirmation dialog |
| 53 | **Notification** | `useNotifications()` | `XTweakUI.Notification` | 🟠 High | ❌ None | Notification center (PubSub) |
| 54 | **Banner** | `<UBanner>` | `<.banner>` | 🟢 Low | ❌ None | Announcement banner |
| 55 | **Drawer** | `<UDrawer>` | `<.drawer>` | 🟡 Medium | ⚠️ LiveView.JS | Mobile drawer |

**Phase 3 Total**: 30 components

---

## Phase 4: Advanced & Layout Components (50 Components) - Week 21-24

### 4A. Layout System (14 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 56 | **App** | `<UApp>` | `<.app>` | 🟡 Medium | ❌ None | Root layout wrapper |
| 57 | **Container** | `<UContainer>` | `<.container>` | 🟢 Low | ❌ None | Max-width container |
| 58 | **Page** | `<UPage>` | `<.page>` | 🟡 Medium | ❌ None | Page layout with slots |
| 59 | **PageHeader** | `<UPageHeader>` | `<.page_header>` | 🟡 Medium | ❌ None | Page title section |
| 60 | **PageBody** | `<UPageBody>` | `<.page_body>` | 🟢 Low | ❌ None | Main content area |
| 61 | **PageAside** | `<UPageAside>` | `<.page_aside>` | 🟡 Medium | ❌ None | Sidebar slot |
| 62 | **PageCTA** | `<UPageCTA>` | `<.page_cta>` | 🟢 Low | ❌ None | Call-to-action section |
| 63 | **Header** | `<UHeader>` | `<.header>` | 🟡 Medium | ⚠️ LiveView.JS | Site header |
| 64 | **Footer** | `<UFooter>` | `<.footer>` | 🟡 Medium | ❌ None | Site footer |
| 65 | **LayoutGrid** | N/A (custom) | `<.layout_grid>` | 🟡 Medium | ❌ None | CSS Grid layout |
| 66 | **Dashboard** | `<UDashboard>` | `<.dashboard>` | 🟠 High | ⚠️ LiveView.JS | Dashboard layout (sidebar, header, panels) |
| 67 | **DashboardPanel** | `<UDashboardPanel>` | `<.dashboard_panel>` | 🟡 Medium | ⚠️ JS Hook | Resizable panel |
| 68 | **DashboardToolbar** | `<UDashboardToolbar>` | `<.dashboard_toolbar>` | 🟢 Low | ❌ None | Toolbar section |
| 69 | **DashboardSidebar** | `<UDashboardSidebar>` | `<.dashboard_sidebar>` | 🟡 Medium | ⚠️ LiveView.JS | Collapsible sidebar |

---

### 4B. Content Components (12 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 70 | **BlogPosts** | `<UBlogPosts>` | `<.blog_posts>` | 🟡 Medium | ❌ None | Blog post list |
| 71 | **ChangelogVersion** | `<UChangelogVersion>` | `<.changelog_version>` | 🟡 Medium | ❌ None | Changelog entry |
| 72 | **ContentNavigation** | `<UContentNavigation>` | `<.content_nav>` | 🟡 Medium | ❌ None | Docs navigation |
| 73 | **ContentToc** | `<UContentToc>` | `<.content_toc>` | 🟡 Medium | ✅ JS Hook | Table of contents (scroll spy) |
| 74 | **ChatMessage** | `<UChatMessage>` | `<.chat_message>` | 🟡 Medium | ❌ None | Single chat message |
| 75 | **ChatMessages** | `<UChatMessages>` | `<.chat_messages>` | 🟠 High | ⚠️ LiveView Stream | Chat message list (auto-scroll) |
| 76 | **Pricing** | N/A (template) | `<.pricing_card>` | 🟡 Medium | ❌ None | Pricing tier card |
| 77 | **Feature** | N/A (template) | `<.feature>` | 🟢 Low | ❌ None | Feature description |
| 78 | **Testimonial** | N/A (template) | `<.testimonial>` | 🟢 Low | ❌ None | Customer testimonial |
| 79 | **FAQ** | N/A (template) | `<.faq>` | 🟢 Low | ❌ None | FAQ item (accordion-like) |
| 80 | **Stat** | N/A (template) | `<.stat>` | 🟢 Low | ❌ None | Statistic display |
| 81 | **Hero** | N/A (template) | `<.hero>` | 🟡 Medium | ❌ None | Hero section |

---

### 4C. Authentication & Onboarding (6 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 82 | **AuthForm** | `<UAuthForm>` | `<.auth_form>` | 🟠 High | ❌ None | Login/signup form |
| 83 | **OnboardingStep** | N/A (custom) | `<.onboarding_step>` | 🟡 Medium | ❌ None | Onboarding wizard step |
| 84 | **WelcomeScreen** | N/A (custom) | `<.welcome>` | 🟢 Low | ❌ None | Welcome message |
| 85 | **PasswordStrength** | N/A (custom) | `<.password_strength>` | 🟡 Medium | ⚠️ JS Hook | Password strength meter |
| 86 | **OTPInput** | N/A (custom) | `<.otp_input>` | 🟠 High | ✅ JS Hook | One-time password input |
| 87 | **TwoFactorSetup** | N/A (custom) | `<.two_factor_setup>` | 🟠 High | ⚠️ LiveView | 2FA setup flow |

---

### 4D. Advanced Interactions (18 components)

| # | Component | Nuxt UI API | Phoenix API | Complexity | JS Required | Notes |
|---|-----------|-------------|-------------|------------|-------------|-------|
| 88 | **ResizablePanel** | N/A (React-Resizable) | `<.resizable_panel>` | 🟠 High | ✅ JS Hook | Drag-to-resize |
| 89 | **SplitPane** | N/A (custom) | `<.split_pane>` | 🟠 High | ✅ JS Hook | Horizontal/vertical split |
| 90 | **TreeView** | N/A (custom) | `<.tree_view>` | 🟠 High | ⚠️ LiveView | Hierarchical tree |
| 91 | **KanbanBoard** | N/A (custom) | `<.kanban_board>` | 🔴 Very High | ✅ JS Hook | Drag-and-drop columns |
| 92 | **Calendar** | N/A (FullCalendar) | `<.calendar>` | 🔴 Very High | ✅ JS Hook | Full calendar UI |
| 93 | **Timeline** (Interactive) | N/A (vis.js) | `<.interactive_timeline>` | 🔴 Very High | ✅ JS Hook | Drag-and-drop events |
| 94 | **Chart** | N/A (Chart.js) | `<.chart>` | 🟠 High | ✅ JS Hook | Charts (bar, line, pie) |
| 95 | **Graph** | N/A (Cytoscape) | `<.graph>` | 🔴 Very High | ✅ Existing (xtweak_web) | Node graph visualization |
| 96 | **MarkdownEditor** | N/A (EasyMDE) | `<.markdown_editor>` | 🔴 Very High | ✅ JS Hook | WYSIWYG markdown |
| 97 | **CodeEditor** | N/A (Monaco/CodeMirror) | `<.code_editor>` | 🔴 Very High | ✅ JS Hook | Syntax highlighting |
| 98 | **ImageCropper** | N/A (Cropper.js) | `<.image_cropper>` | 🟠 High | ✅ JS Hook | Image crop tool |
| 99 | **VideoPlayer** | N/A (Video.js) | `<.video_player>` | 🟠 High | ✅ JS Hook | Custom video player |
| 100 | **AudioPlayer** | N/A (Howler.js) | `<.audio_player>` | 🟠 High | ✅ JS Hook | Audio playback |
| 101 | **VirtualScroll** | N/A (react-window) | `<.virtual_scroll>` | 🔴 Very High | ✅ LiveView Stream | Virtual scrolling for huge lists |
| 102 | **InfiniteScroll** | N/A (custom) | `<.infinite_scroll>` | 🟠 High | ⚠️ LiveView Hook | Load more on scroll |
| 103 | **Masonry** | N/A (Masonry.js) | `<.masonry>` | 🟡 Medium | ✅ JS Hook | Masonry grid layout |
| 104 | **Sortable** | N/A (SortableJS) | `<.sortable>` | 🟠 High | ✅ JS Hook | Drag-and-drop reorder |
| 105 | **Confetti** | N/A (canvas-confetti) | `<.confetti>` | 🟡 Medium | ✅ JS Hook | Celebration animation |

**Phase 4 Total**: 50 components

---

## 📊 Component Complexity Summary

| Complexity | Count | % of Total | Phase Distribution |
|------------|-------|------------|-------------------|
| 🟢 **Low** (CSS-only) | 32 | 30% | Phase 1-2: 15, Phase 3-4: 17 |
| 🟡 **Medium** (LiveView logic) | 45 | 43% | Phase 2: 10, Phase 3-4: 35 |
| 🟠 **High** (JS hooks) | 20 | 19% | Phase 3: 10, Phase 4: 10 |
| 🔴 **Very High** (Complex JS) | 8 | 8% | Phase 3: 4, Phase 4: 4 |
| **Total** | **105** | **100%** | |

---

## 🎯 API Mapping Patterns

### Pattern 1: Simple Props → Attributes

**Nuxt UI**:
```vue
<UButton color="primary" size="md" :disabled="true">
  Click me
</UButton>
```

**Phoenix**:
```elixir
<.button color="primary" size="md" disabled={true}>
  Click me
</.button>
```

---

### Pattern 2: Slots → Named Slots

**Nuxt UI**:
```vue
<UCard>
  <template #header>Title</template>
  Content
  <template #footer>Actions</template>
</UCard>
```

**Phoenix**:
```elixir
<.card>
  <:header>Title</:header>
  Content
  <:footer>Actions</:footer>
</.card>
```

---

### Pattern 3: Composables → GenServer + PubSub

**Nuxt UI**:
```javascript
const toast = useToast()
toast.add({ title: 'Success!', color: 'green' })
```

**Phoenix**:
```elixir
# In LiveView
XTweakUI.Toast.show("Success!", color: "green")

# Component renders in root layout
<.toast_container />
```

---

### Pattern 4: v-model → phx-change

**Nuxt UI**:
```vue
<UInput v-model="name" placeholder="Enter name" />
```

**Phoenix**:
```elixir
<.input
  name="name"
  value={@name}
  placeholder="Enter name"
  phx-change="update_name"
/>
```

---

### Pattern 5: Icons

**Nuxt UI** (Iconify):
```vue
<UButton icon="i-lucide-check" />
```

**Phoenix** (Heroicons):
```elixir
<.button icon="hero-check" />
# Or
<.button>
  <:icon><Heroicons.check /></:icon>
</.button>
```

---

## 🚀 Implementation Order Rationale

### Phase 1: Foundation
**Why first?** Validates infrastructure before scaling. Tests theming, asset pipeline, and showcase.

### Phase 2: MVP
**Why second?** Delivers internal value quickly. Forms + navigation cover 80% of use cases.

### Phase 3: Extended
**Why third?** Adds polish and advanced features. UnoCSS evaluation happens here (less risk).

### Phase 4: Advanced
**Why last?** High-complexity components with lower usage frequency. Can be added incrementally post-v1.0.

---

## 📈 Component Usage Heatmap (Estimated)

Based on typical Phoenix app needs:

| Component | Usage Frequency | Critical Path | Notes |
|-----------|-----------------|---------------|-------|
| Button | 🔥🔥🔥🔥🔥 | ✅ Yes | Every app needs buttons |
| Input | 🔥🔥🔥🔥🔥 | ✅ Yes | Forms are core |
| Modal | 🔥🔥🔥🔥 | ✅ Yes | Common interaction pattern |
| Table | 🔥🔥🔥🔥 | ⚠️ Sometimes | Data-heavy apps |
| Dropdown | 🔥🔥🔥🔥 | ✅ Yes | Navigation, filters |
| Toast | 🔥🔥🔥 | ✅ Yes | User feedback |
| Calendar | 🔥 | ❌ No | Specific use cases |
| Kanban | 🔥 | ❌ No | Project management apps only |

---

## 🔧 Customization Strategy

### Global Configuration (`config/config.exs`)
```elixir
config :xtweak_ui, :theme,
  primary_color: "blue",
  button_defaults: %{size: "md", variant: "solid"},
  form_defaults: %{size: "md", label_position: "top"}
```

### Component-Level Overrides
```elixir
<.button
  color="primary"
  size="lg"
  class="custom-shadow" # Tailwind utility classes
  ui={%{base: "rounded-full"}} # Deep customization
>
  Submit
</.button>
```

### Theming System
```elixir
# Runtime theme switching (LiveView assign)
<html data-theme={@theme}>

# CSS variables
:root[data-theme="light"] {
  --color-primary-500: oklch(65.7% 0.224 353.4);
}

:root[data-theme="dark"] {
  --color-primary-500: oklch(75% 0.224 353.4);
}
```

---

## 📚 Component Documentation Template

Each component will have:

1. **@moduledoc**: Description, use cases, accessibility notes
2. **Attributes**: With types, defaults, validation
3. **Slots**: Named slots with descriptions
4. **Examples**: 3+ usage examples
5. **API Reference**: Link to Nuxt UI equivalent
6. **Tests**: Unit tests + visual regression

Example:
```elixir
defmodule XTweakUI.Components.Button do
  @moduledoc """
  Button component with variants, sizes, and loading states.

  Ported from Nuxt UI's UButton component.

  ## Examples

      <.button>Click me</.button>
      <.button color="primary" size="lg" loading={true}>Submit</.button>

  ## Accessibility

  - Keyboard navigable (Tab, Enter/Space)
  - ARIA disabled state
  - Focus visible styles

  ## Nuxt UI Reference

  https://ui.nuxt.com/components/button
  """

  # ... implementation
end
```

---

**Next Steps**: Proceed to implementation roadmap (05-implementation-roadmap.md) for detailed sprint plans.
