---
description: Set up infrastructure tools - MCP servers, CI checks, dev tools, GitHub actions
---

# Setup Tool Command

You are the **infrastructure setup coordinator** using specialized agents for tool integration.

## Your Task

Add and configure development tools, CI checks, MCP servers, or GitHub Actions to improve developer experience and code quality.

## Input Format

```
/setup-tool [tool-type] [name]
```

**Examples**:
- `/setup-tool mcp-server playwright`
- `/setup-tool ci-check sobelow`
- `/setup-tool dev-dependency mix_audit`
- `/setup-tool github-action codecov`

## Responsible Agents

- **Primary**: `tools-config-guardian` (Haiku) - Verify config, test integration
- **Implementation**: `ci-cd-optimizer` (Sonnet) - Configure CI/tooling
- **Documentation**: `docs-maintainer` (Haiku) - Update docs

## Workflow Steps

### Step 1: Verify Prerequisites
**Agent**: `tools-config-guardian` (Haiku)

**Actions**:
- Check current tool configuration
- Identify conflicts or missing prerequisites
- Validate tool versions/compatibility

### Step 2: Configure Tool
**Agent**: `ci-cd-optimizer` (Sonnet) or `tools-config-guardian` (Haiku)

**Actions**:

**For MCP servers**:
- Update `.claude/settings.json`
- Test connection
- Document usage in CLAUDE.md

**For CI checks**:
- Update `.github/workflows/ci.yml`
- Add to quality gates
- Configure appropriate job

**For dev tools**:
- Update mix.exs deps
- Add to mix aliases
- Configure in config/config.exs if needed

### Step 3: Test Integration
**Agent**: `tools-config-guardian` (Haiku)

**Actions**:
- Run tool to verify it works
- Check integration with existing workflow
- Ensure no conflicts

### Step 4: Document
**Agent**: `docs-maintainer` (Haiku)

**Actions**:
- Update MANDATORY_AI_RULES.md or CLAUDE.md
- Add to Human_docs/WORKFLOW_GUIDE.md if user-facing
- Update quality gates documentation

## Output Format

```markdown
## Tool Setup Complete

🔧 **Tool**: [name] ([description])
📦 **Type**: [mcp-server | ci-check | dev-dependency | github-action]

✅ **Verification** (tools-config-guardian)
  - Prerequisites: ✅ All met
  - Conflicts: None detected

✅ **Configuration** ([agent])
  - Files modified:
    - [file1]: [what changed]
    - [file2]: [what changed]
  - Commands added: [list if any]

✅ **Testing** (tools-config-guardian)
  - Tool runs: ✅ Successfully
  - Integration: ✅ Works with existing workflow
  - CI pipeline: ✅ Passes (if applicable)

✅ **Documentation** (docs-maintainer)
  - Updated: [list of docs files]
  - Usage documented: ✅

📝 **Suggested Commit Message**:
```
chore: add [tool] to [where]

- [what it does]
- [how to use it]
- [any configuration notes]

🤖 Generated with Claude Code
```
```

## Quality Checks

- [ ] Tool runs successfully
- [ ] No conflicts with existing tools
- [ ] CI passes (if CI tool)
- [ ] Usage documented
- [ ] Quality gates updated (if applicable)

## Remember

**Pattern Stack**: Load `mcp-tool-discipline`, `self-check-core`

**Cost Optimization**: Use Haiku for verification/docs, Sonnet only for complex CI configuration
