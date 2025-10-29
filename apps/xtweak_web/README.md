# XTweakWeb

Phoenix LiveView web interface for the xTweak infrastructure template.

## Description

This is the web app in the xTweak umbrella application. It contains:
- Phoenix Framework with LiveView
- Tailwind CSS utilities
- Cytoscape.js for graph visualizations
- Real-time user interface components

## Architecture

```
xtweak_web/
├── lib/
│   ├── xtweak_web/         # Application module
│   └── xtweak_web_web/     # Web layer
│       ├── components/     # Phoenix components
│       ├── controllers/    # HTTP controllers
│       ├── live/          # LiveView modules
│       └── router.ex      # Route definitions
├── assets/                # Frontend assets
│   ├── css/              # Stylesheets (Tailwind CSS)
│   ├── js/               # JavaScript (including Cytoscape hooks)
│   └── vendor/           # Third-party JS libraries
└── test/
    └── xtweak_web_web/   # Web layer tests
```

## Getting Started

### Prerequisites
- Elixir 1.19.1+
- Node.js 18+ (for asset compilation)
- Running `xtweak_core` app (for domain logic)

### Development Setup

1. **Install dependencies:**
   ```bash
   # From project root
   mix deps.get
   cd apps/xtweak_web/assets && npm install && cd ../../..
   ```

2. **Start Phoenix server:**
   ```bash
   # From project root
   mix phx.server
   ```

   Or inside IEx:
   ```bash
   iex -S mix phx.server
   ```

3. **Visit the application:**
   Open [`localhost:4000`](http://localhost:4000) in your browser.

## Key Features

### LiveView Components
- Real-time updates without page reloads
- Server-rendered HTML with minimal JavaScript
- Built-in form handling and validation

### Theme System
- CSS variable-based theming
- Dark/light mode support
- Semantic color tokens
- Accessible by default

### Cytoscape Integration
- Graph visualization for network diagrams
- Custom LiveView hooks for interactivity
- Layout algorithms (cola, cose-bilkent)

### Asset Pipeline
- **Tailwind CSS** - Utility-first styling
- **esbuild** - Fast JavaScript bundling
- **PostCSS** - CSS processing
- Hot reloading in development

## Configuration

### Environment Variables
```bash
PHX_HOST=localhost        # Host for URL generation
PORT=4000                # Server port
SECRET_KEY_BASE=...      # Session encryption key
```

### Endpoints
- Development: `http://localhost:4000`
- LiveDashboard: `http://localhost:4000/dev/dashboard` (dev only)

## Testing

```bash
# Run web tests only
mix test apps/xtweak_web/test

# Run with coverage
mix test apps/xtweak_web/test --cover

# Run LiveView tests
mix test apps/xtweak_web/test/xtweak_web_web/live/
```

## Asset Management

```bash
# Build assets for development
mix assets.build

# Build and minify for production
mix assets.deploy

# Watch assets during development (automatic with phx.server)
cd apps/xtweak_web/assets && npm run watch
```

## Component Library

This app uses the shared `xtweak_ui` component library:

```elixir
defmodule XTweakWeb.MyLive do
  use XTweakWeb, :live_view
  use XTweakUI.Components

  def render(assigns) do
    ~H"""
    <.button variant="primary">Click Me</.button>
    <.card>
      <:header>Card Title</:header>
      <:body>Card content goes here</:body>
    </.card>
    """
  end
end
```

## Deployment

Ready to run in production? Check the [Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Key considerations:
- Set `SECRET_KEY_BASE` environment variable
- Configure `PHX_HOST` for URL generation
- Run `mix assets.deploy` before building release
- Use a reverse proxy (nginx, caddy) for SSL/TLS

## Learn More

### Phoenix Resources
- Official website: https://www.phoenixframework.org/
- Phoenix guides: https://hexdocs.pm/phoenix/overview.html
- Phoenix docs: https://hexdocs.pm/phoenix
- LiveView docs: https://hexdocs.pm/phoenix_live_view

### Project Resources
- Tailwind docs: https://tailwindcss.com/
- Cytoscape docs: https://js.cytoscape.org/

### Community
- Elixir Forum: https://elixirforum.com/c/phoenix-forum
- Phoenix Discord: https://discord.gg/elixir
