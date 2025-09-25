# Tech Stack - xTweak Template

## Technology Stack Overview

xTweak is a minimal Elixir umbrella template designed for modern web applications. The tech stack focuses on developer productivity, maintainability, and AI-assisted development.

## Core Technologies

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Backend Language** | Elixir | 1.18.1+ | Core application logic | Functional programming, fault tolerance, concurrency |
| **Backend Framework** | Phoenix | 1.8.0+ | Web framework foundation | Mature framework with excellent LiveView integration |
| **Domain Framework** | Ash Framework | 3.5+ | Resource management and APIs | Declarative resources, built-in authentication |
| **Frontend** | Phoenix LiveView | 1.1+ | Real-time server-rendered UI | Eliminates API complexity, maintains real-time updates |
| **UI Framework** | DaisyUI | 4.12+ | Component library | Beautiful Tailwind-based components |
| **CSS Framework** | Tailwind CSS | 3.4+ | Utility-first styling | Rapid UI development with excellent DaisyUI integration |
| **Database** | PostgreSQL | 16+ | Primary data store | ACID compliance, excellent Ash integration |
| **Authentication** | Ash Authentication | 4.9+ | User authentication | Integrated auth with Ash resources |

## Development Tools

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| **Build Tool** | Mix | Built-in | Elixir build and task runner |
| **Asset Bundler** | ESBuild | 0.17+ | JavaScript/CSS bundling |
| **Package Manager** | npm | Latest | Frontend package management |
| **Testing** | ExUnit | Built-in | Unit and integration testing |
| **Code Quality** | Credo | 1.7+ | Static code analysis |
| **Type Checking** | Dialyzer | 1.4+ | Static type analysis |

## AI Development Stack

| Tool | Purpose |
|------|---------|
| **Claude Code** | AI-powered development assistance |
| **MCP Servers** | Model Context Protocol integration |
| **Ash AI** | Ash Framework specific assistance |
| **TideWave** | Elixir development MCP server |

## App-Specific Technologies

### xtweak_core (Business Logic)
- **Ash Framework** - Resource definitions and domain logic
- **Ash Postgres** - Database integration
- **Ash Authentication** - User authentication system

### xtweak_web (Web Interface)
- **Phoenix LiveView** - Interactive web components
- **DaisyUI Components** - Pre-built UI elements
- **Theme Switching** - Dark/light mode support

### xtweak_docs (Documentation)
- **Earmark** - Markdown to HTML conversion
- **Makeup** - Syntax highlighting

### xtweak_ui (Component Library)
- **Phoenix Components** - Reusable LiveView components
- **DaisyUI Classes** - Consistent styling system

## Development Environment

### Required Tools
- **Elixir** 1.18.1+
- **Erlang/OTP** 27.2+
- **PostgreSQL** 16+
- **Node.js** 18+

### Optional (Recommended)
- **DevBox** - Reproducible development environments
- **Docker** - Container support
- **VS Code + ElixirLS** - Enhanced development experience

## Architecture Benefits

### For Template Users
- **Minimal Setup** - Ready to use with basic authentication
- **Modern Stack** - Latest versions of core technologies
- **AI Ready** - Pre-configured for AI-assisted development
- **Extensible** - Easy to add new features and resources

### For Development
- **Type Safety** - Dialyzer for compile-time type checking
- **Hot Reloading** - LiveView automatic updates during development
- **Consistent Styling** - DaisyUI component system
- **Test Coverage** - ExUnit with comprehensive testing utilities

## Deployment Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Runtime** | Elixir Release | Production deployment |
| **Database** | PostgreSQL | Persistent data storage |
| **Assets** | Static Files | Pre-compiled CSS/JS assets |
| **Secrets** | Environment Variables | Configuration management |

This stack provides a solid foundation for building modern Elixir web applications with minimal configuration overhead.