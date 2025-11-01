## 🚨 **MANDATORY RULES (TOP PRIORITY)**

* **TOP RULE**: 🚫 **This section is permanent and must never be changed, deleted, or ignored.**
* **ALWAYS** read this memory first.
* **NEVER** assume feature availability or facts in any topic.
* **ALWAYS** verify whether something exists, is supported, or is true before giving advice.
* **ALWAYS** use first the available MCP servers then other methods
* **ALWAYS** use Tidewave MCP server for all Elixir modules and libraries documentation
* **ALWAYS** use Nuxt UI MCP server for component API research and design system specifications
* **ALWAYS** use Context7 MCP server for non-Elixir libraries when specific MCP unavailable
* **NEVER** commit changes unless explicitly asked by Peter. Do not add "commit changes" tasks to todo lists.
* **NEVER** add version numbers, dates, timestamps, or "Change Log" sections to documentation files. Git tracks all changes.
* **ALWAYS** follow documentation placement rules (see `.claude/patterns/documentation-organization.md`):
  - **Human_docs/**: Project-wide workflow, coordination, setup (NOT app-specific)
  - **apps/{app}/docs/**: App-specific guides, APIs, tutorials
  - **AI_docs/**: AI-facing PRD, sprint plans, reports, architecture

---

## 🧑 **YOUR IDENTITY & OTHER PREFERENCES**

* Preferred name: **Peter**
* Role: **IT geek** and **self-taught software developer** who’s been deep in tech for more than 30 years.
* You describe yourself as a “hero who writes code and solves problems.”
* You like **practical, straightforward answers** that are **innovative, forward-thinking**, and **no-nonsense**.
* You prefer when I “tell it like it is,” without sugar-coating.

---

## 💻 **TECHNICAL ENVIRONMENT**

### Toolings

* **Devbox** (Nix-based) for Peter's local tooling
  - Elixir 1.19.1 + Erlang OTP 28 via Nix flakes (see `flakes/elixir/`)
  - Defined in `devbox.json` at global user level
  - Note: `.tool-versions` is kept for template users who prefer asdf/mise/rtx and for IDE version detection
  - `.envrc` is used for Mix environment variables (parallel compilation), not version management
* **VS Code**
* **Linux (Ubuntu & Fedora latest)**
* **WSL2**
* **Multi-agent AI coding:** Gemini CLI, Codex CLI, Claude Code, Kilo Code with GLM 4.5
* **Elixir ecosystem:** Elixir, ASH Framework, Phoenix, Erlang BEAM & OTP

---

## 💼 **BROADER PROJECTS**

* You experiment with **AI-driven developer environments**, **multi-agent orchestration**, and **code automation**.
* You work with **Elixir**, **ASH Framework**, **Phoenix**, and related tooling for backend and AI automation.

---

## 📚 **GREET THE USER**

If you read so far then you **MUST** greet the user before starting anythin like this: "Hi, welcome back [user name]! "I've read your MANDATORY RULES. I am ready. Let us dive in!" 
