# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **BREAKING:** Upgraded to Elixir 1.19.1 and Erlang/OTP 28.1
  - All mix.exs files now require `elixir: "~> 1.19"`
  - CI updated to use Elixir 1.19.1 and OTP 28.1
  - Added `.tool-versions` for asdf version management
- Updated ash_ai from 0.2.14 to 0.3.0 (dev dependency)
- Updated CI configuration with parallel dependency compilation (`MIX_OS_DEPS_COMPILE_PARTITION_COUNT`)
- Enhanced IEx configuration with improved pretty printing (limit increased to 100)
- Created `.envrc` for local development parallel compilation support

### Added
- Elixir 1.19.1 enhanced type checking (zero issues detected in codebase)
- Parallel dependency compilation support (17% faster builds locally)
- `.tool-versions` file for asdf version manager
- `.envrc` file for direnv/environment variable management
- Comprehensive upgrade documentation in `.upgrade/` directory

### Performance
- Compilation speed improved by ~17% with parallel compilation enabled
- Enhanced type checking with zero performance overhead
- OTP 28 JIT improvements active

### Documentation
- Updated README.md with new Elixir/OTP version requirements
- Created comprehensive upgrade report with performance metrics
- Documented Elixir 1.19.1 features and modernization steps

### Security
- All dependencies audited: zero vulnerabilities found
- Sobelow security scan: one pre-existing finding (CSP policy)
- Enhanced type safety from Elixir 1.19.1 compiler

### Quality
- All tests passing (14/14 - 100%)
- Credo strict mode: zero issues
- Code formatting: all files compliant
- Dialyzer PLT rebuilt for OTP 28

### Deferred
- gettext 1.0.0 upgrade (requires breaking change review)
- tailwind 0.4.1 upgrade (requires breaking change review)

## [0.1.0] - 2025-10-29

### Initial Release
- Elixir umbrella application with 4 apps
  - xtweak_core: Business logic with Ash Framework
  - xtweak_web: Phoenix LiveView web interface
  - xtweak_docs: Documentation app
  - xtweak_ui: Reusable UI components
- User authentication with AshAuthentication
- Newsletter resource with authorization policies
- DaisyUI + Tailwind CSS styling
- PostgreSQL database with Ash resources
- Comprehensive AI development guides (Claude Code, Codex, etc.)
