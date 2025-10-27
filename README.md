# xTweak - Elixir Umbrella Template

A minimal, clean Elixir umbrella project template with Phoenix LiveView, Ash Framework, and DaisyUI. Perfect for starting new projects with a solid foundation.

## 🏗️ Architecture

xTweak is built as an **Elixir umbrella application** with four independent apps:

- **`xtweak_core`** - Business logic with Ash Framework (User authentication, Newsletter)
- **`xtweak_web`** - Phoenix LiveView web interface with DaisyUI styling
- **`xtweak_docs`** - Documentation app with markdown rendering
- **`xtweak_ui`** - Reusable UI component library for Phoenix applications

## 🚀 Quick Start

### Prerequisites

- **Elixir** 1.18.1+
- **Erlang/OTP** 27.2+
- **PostgreSQL** 14+ (tested with 16)
- **Node.js** 18+ (for asset compilation)

### Development Setup

1. **Clone the template:**
   ```bash
   git clone <your_repository_url>
   cd xtweak
   ```

2. **Install dependencies:**
   ```bash
   mix deps.get
   cd apps/xtweak_web/assets && npm install && cd ../../..
   ```

3. **Setup database:**
   ```bash
   mix ash.setup
   ```

4. **Start the development server:**
   ```bash
   mix phx.server
   ```

Visit [`localhost:4000`](http://localhost:4000) to see the application.

### Testing

Run the test suite:
```bash
# Run all tests
mix test

# Run specific app tests
mix test apps/xtweak_core/test
mix test apps/xtweak_web/test
```

### Code Quality

```bash
# Format code
mix format

# Run static analysis
mix credo --strict

# Type checking
mix dialyzer
```

## 📦 What's Included

### Core Features

- **User Authentication**: Built with Ash Authentication
- **Newsletter Subscription**: Simple example with Ash resources
- **Weather Demo Page**: Sample functionality to demonstrate structure
- **Theme Switching**: Dark/light mode with DaisyUI
- **Component Library**: Reusable UI components (Button, Card, Modal, Alert)

### Tech Stack

- **Elixir** 1.18.1+ - Functional programming language
- **Phoenix** 1.8+ with **LiveView** 1.1+ - Real-time web applications
- **Ash Framework** 3.7+ - Resource-based application framework
- **AshPostgres** 2.6+ - PostgreSQL data layer
- **PostgreSQL** 14+ - Primary database
- **DaisyUI** 4+ - Semantic CSS component library
- **Tailwind CSS** 3+ - Utility-first CSS framework

## 🗄️ Database Schema

The template includes minimal Ash resources:

```bash
# Generate and run migrations
mix ash_postgres.generate_migrations
mix ash.setup
```

Core resources:
- `users` - User authentication with roles
- `newsletter_subscriptions` - Email subscriptions

## 📁 Project Structure

```
xtweak/
├── apps/
│   ├── xtweak_core/           # Business logic & Ash resources
│   │   ├── lib/xtweak/core/   # User, Newsletter resources
│   │   └── test/              # Resource tests
│   ├── xtweak_web/            # Phoenix web interface
│   │   ├── lib/xtweak_web_web/
│   │   │   ├── controllers/   # Page controller
│   │   │   ├── components/    # LiveView components
│   │   │   └── live/          # LiveView modules (if needed)
│   │   └── assets/            # CSS/JS assets
│   ├── xtweak_docs/           # Documentation app
│   │   └── lib/               # Markdown rendering utilities
│   └── xtweak_ui/             # UI component library
│       └── lib/xtweak_ui/     # Reusable Phoenix components
├── config/                    # Application configuration
├── docs/                      # Project documentation
└── .claude/                   # AI coding assistance setup
```

## 🔧 Configuration

### Environment Variables

The template is pre-configured for development. For production, set:

```bash
DATABASE_URL=your_database_url
SECRET_KEY_BASE=your_secret_key
PHX_HOST=your_domain.com
```

## 🛠️ Customization

### Adding New Resources

1. **Create new Ash resource:**
   ```bash
   # Navigate to core app
   cd apps/xtweak_core

   # Add new resource file
   # lib/xtweak/core/your_resource.ex
   ```

2. **Add to domain:**
   ```elixir
   # lib/xtweak/core.ex
   resources do
     resource(XTweak.Core.User)
     resource(XTweak.Core.Newsletter)
     resource(XTweak.Core.YourResource)  # Add here
   end
   ```

3. **Generate migrations:**
   ```bash
   mix ash_postgres.generate_migrations
   mix ash.setup
   ```

### Using UI Components

Import the component library in your LiveViews:

```elixir
defmodule YourAppWeb.YourLive do
  use YourAppWeb, :live_view
  use XTweakUI.Components

  def render(assigns) do
    ~H"""
    <.card>
      <:header>Welcome</:header>
      <:body>
        <.button variant="primary">Get Started</.button>
      </:body>
    </.card>
    """
  end
end
```

## 📋 Available Mix Commands

```bash
# Development
mix setup                 # Set up the project
mix phx.server           # Start Phoenix server

# Database (Ash commands)
mix ash.setup            # Setup database with Ash
mix ash_postgres.generate_migrations  # Generate migrations

# Testing
mix test                 # Run all tests
mix test --cover        # Run with coverage

# Code Quality
mix format              # Format code
mix credo --strict      # Static analysis
mix dialyzer           # Type checking

# Assets
mix assets.build        # Build assets for development
mix assets.deploy       # Build assets for production
```

## 🤖 AI Development Ready

This template is pre-configured for AI-assisted development with Claude Code:

### MCP Server Integration
- **Ash AI** (`mcp__ash_ai__*`) - Ash Framework assistance, resource listings, generators
- **TideWave** (`mcp__tidewave__*`) - Elixir development tools, project evaluation, docs
- **Context7** (`mcp__context7__*`) - Library documentation (DaisyUI, Cytoscape, etc.)
- **Playwright** (`mcp__playwright__*`) - Browser automation for UI verification

### Pattern-Based Development
- Comprehensive pattern library in `.claude/patterns/`
- Specialized agents for different tasks (see `.claude/AGENT_USAGE_GUIDE.md`)
- Enforced quality gates and verification workflows
- See `CLAUDE.md` for complete guidelines

## 🎨 Theming & Styling

The template uses DaisyUI with multiple built-in themes:
- Automatic dark/light mode switching
- Pre-configured theme switcher component
- Semantic component classes
- Responsive design utilities

## 📄 License

This project template is licensed under the MIT License.

## 🤝 Getting Help

- Check the `docs/` directory for detailed documentation
- Review existing code patterns in each app
- Use the AI coding assistance tools pre-configured in the project

---

**Ready to build something amazing?** 🚀

This template gives you a clean, minimal starting point with modern Elixir best practices. Customize it to fit your project's needs!