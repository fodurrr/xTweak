# xTweak Template Makefile
# Convenient commands for development workflow

.PHONY: help setup quality test clean install server assets codex-setup codex-validate

# Default target
help:
	@echo "🚀 xTweak Template Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make install     Install dependencies (mix deps + npm)"
	@echo "  make setup       Setup database and compile assets"
	@echo "  make assets      Build CSS and JS assets"
	@echo ""
	@echo "Development:"
	@echo "  make server      Start Phoenix server"
	@echo "  make test        Run all tests"
	@echo "  make quality     Run quality checks (format, credo, compile)"
	@echo "  make format      Format all code"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean       Clean build artifacts"
	@echo "  make codex-setup Install Codex CLI include + profiles"
	@echo "  make codex-validate Validate Codex configuration"
	@echo "  (use) CODE_CONFIG_HOME=$$(pwd)/scripts/codex/local codex --profile xtweak-mcp-verify-first \"PLAN\""
	@echo ""

# Project setup
install:
	@echo "📦 Installing dependencies..."
	mix deps.get
	cd apps/xtweak_web/assets && npm install

setup: install assets
	@echo "🏗️  Setting up database..."
	mix ash.setup

assets:
	@echo "🎨 Building assets..."
	mix esbuild xtweak_web
	mix tailwind xtweak_web

# Development
server:
	@echo "🌐 Starting Phoenix server..."
	mix phx.server

test:
	@echo "🧪 Running tests..."
	mix test

quality:
	@echo "✨ Running quality checks..."
	mix format
	mix credo --strict
	mix compile --warnings-as-errors

format:
	@echo "📝 Formatting code..."
	mix format

# Maintenance
clean:
	@echo "🧹 Cleaning build artifacts..."
	mix clean
	rm -rf _build deps
	cd apps/xtweak_web/assets && rm -rf node_modules

# Optional quality checks
dialyzer:
	@echo "🔬 Running Dialyzer analysis..."
	mix dialyzer

codex-setup:
	@echo "🛠️  Installing Codex CLI configuration..."
	bash scripts/codex/setup.sh

codex-validate:
	@echo "🧾 Validating Codex CLI configuration..."
	bash scripts/codex/validate.sh
