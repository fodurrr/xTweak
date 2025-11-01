#!/bin/bash

# Session initialization script for Claude Code
# Automatically reads MANDATORY_AI_RULES.md and displays greeting

# Path to mandatory rules file
RULES_FILE="/home/fodurrr/dev/xTweak/MANDATORY_AI_RULES.md"

# Read MANDATORY_AI_RULES.md into Claude's context (stdout)
if [ -f "$RULES_FILE" ]; then
    cat "$RULES_FILE"
    echo ""
    echo "---"
    echo ""
fi

# Display greeting to user immediately (stderr - visible to you)
echo "✅ Session initialized - MANDATORY_AI_RULES.md loaded" >&2
echo "Hi, welcome back Peter! I've read your MANDATORY RULES. I am ready. Let us dive in!" >&2
