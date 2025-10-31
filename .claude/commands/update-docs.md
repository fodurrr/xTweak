---
description: Update non-PRD documentation - README, migration guides, framework rules, developer guides
---

# Update Documentation Command

You are the **documentation update coordinator** using the `docs-maintainer` agent for keeping non-PRD documentation current.

## Your Task

Update documentation that isn't part of the PRD workflow: README files, framework rules after upgrades, migration guides, and developer onboarding documentation.

## Input Format

```
/update-docs [type] [scope]
```

**Examples**:
- `/update-docs framework-rules ash` (after Ash upgrade)
- `/update-docs readme --section=installation`
- `/update-docs migration-guide "Elixir 1.17 to 1.19"`
- `/update-docs onboarding` (refresh developer guide)

## Responsible Agents

- **Primary**: `docs-maintainer` (Haiku) - Documentation updates, markdown formatting
- **Support**: `mcp-verify-first` (Haiku) - Find outdated information, verify current state

## Workflow Steps

### Step 1: Assess Current State
**Agent**: `mcp-verify-first` (Haiku)

**Actions**:
- Read target documentation
- Identify outdated information (version refs, deprecated APIs, broken links)
- Check for missing sections
- Verify code examples still compile

### Step 2: Update Documentation
**Agent**: `docs-maintainer` (Haiku)

**Actions**:

**For framework-rules**:
```bash
# Sync usage rules from deps
bash scripts/setup_usage_rules.sh
# Or manually:
# mix usage_rules.sync usage-rules.md ash phoenix ash_postgres --link-to-folder usage-rules
# Read new patterns
# Update usage-rules/[framework].md with xTweak-specific patterns
```

**For README**:
- Update based on current project state
- Verify installation steps work
- Update version requirements
- Fix broken links

**For migration-guides**:
- Create structured guide from CHANGELOG
- Add before/after code examples
- Document breaking changes
- Provide upgrade steps

### Step 3: Validate
**Agent**: `docs-maintainer` (Haiku)

**Actions**:
- Check markdown formatting
- Verify code examples compile (use MCP)
- Ensure links resolve
- Run through any documented steps

## Output Format

```markdown
## Documentation Updated

📚 **Type**: [type]
📄 **Scope**: [scope]

✅ **Assessment** (mcp-verify-first)
  - Outdated information: [count] instances
  - Broken links: [count]
  - Missing sections: [list]

✅ **Updates** (docs-maintainer)
  - Files updated: [count]
    - [file1]: [what changed]
    - [file2]: [what changed]
  - Code examples: [count] updated/added
  - Links fixed: [count]

✅ **Validation** (docs-maintainer)
  - Markdown: ✅ Properly formatted
  - Code examples: ✅ [count]/[count] compile
  - Links: ✅ All resolve

📝 **Suggested Commit Message**:
```
docs: [what was updated]

- [specific change 1]
- [specific change 2]
- [rationale if not obvious]

🤖 Generated with Claude Code
```
```

## Quality Checks

- [ ] Outdated information updated
- [ ] Code examples verified (compile/work)
- [ ] Links checked and working
- [ ] Markdown properly formatted
- [ ] Version numbers current

## Remember

**Pattern Stack**: Load `mcp-tool-discipline`, `self-check-core`

**Cost Optimization**: Uses only Haiku (documentation is straightforward)
