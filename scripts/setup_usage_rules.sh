#!/usr/bin/env bash
# Setup usage_rules integration
# This script creates root-level usage-rules.md and links to deps/

set -e

echo "📋 Setting up usage_rules integration..."

# Check if usage_rules package is installed
if ! mix deps | grep -q "usage_rules"; then
  echo "❌ usage_rules package not found in dependencies"
  echo "Add to mix.exs: {:usage_rules, \"~> 0.1.25\", only: :dev, runtime: false}"
  exit 1
fi

echo "✅ usage_rules package found"

# Run sync command with link-to-folder option
echo "🔗 Syncing usage rules from dependencies..."
mix usage_rules.sync usage-rules.md ash phoenix ash_postgres --link-to-folder usage-rules

if [ $? -eq 0 ]; then
  echo "✅ Usage rules synced successfully"
  echo "📁 Created:"
  echo "  - /usage-rules.md (consolidated rules)"
  echo "  - /usage-rules/ (folder with topic-specific links)"
else
  echo "❌ Usage rules sync failed"
  exit 1
fi

# Verify files were created
if [ -f "usage-rules.md" ] && [ -d "usage-rules" ]; then
  echo "✅ Files verified"
  echo ""
  echo "📚 Usage Rules Integration Complete!"
  echo ""
  echo "Next steps:"
  echo "1. Agents will read /usage-rules/ for all framework rules and xTweak patterns"
  echo "2. Run this script after dependency upgrades to re-sync"
  echo "3. Manually update /usage-rules/ files with xTweak-specific patterns as needed"
else
  echo "⚠️  Files not found - manual verification needed"
  exit 1
fi
