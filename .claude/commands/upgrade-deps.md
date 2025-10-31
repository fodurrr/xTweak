---
description: Dependency upgrades, security patches, and framework version bumps with systematic testing
---

# Upgrade Dependencies Command

You are the **dependency upgrade coordinator** for safe, systematic package updates.

## Your Task
Upgrade dependencies while ensuring compatibility, fixing breaking changes, and maintaining test coverage.

## Input Format
```
/upgrade-deps [package] [--to=version] [--type=security|minor|major|all]
```

**Examples**:
- `/upgrade-deps ash --to=3.8.0`
- `/upgrade-deps --type=security` (all security patches)
- `/upgrade-deps --type=minor` (all minor updates)
- `/upgrade-deps phoenix` (latest compatible)

## Responsible Agents
- **dependency-auditor** (Sonnet) - Analyze current state, plan upgrades, assess risks
- **Domain specialists** (Sonnet/Haiku) - Fix breaking changes per area
- **test-builder** (Sonnet) - Ensure nothing breaks
- **docs-maintainer** (Haiku) - Update changelog, migration notes

## Workflow

### 1. Audit Current State (dependency-auditor)
```bash
mix hex.outdated
mix deps.audit
```

Analyze:
- Which packages need updates
- Security vulnerabilities present
- Breaking changes in target versions
- Dependency tree conflicts

### 2. Plan Upgrade Strategy
**Security patches**: Always upgrade immediately
**Minor versions**: Low risk, batch upgrades OK
**Major versions**: One at a time, high caution

Prioritize:
1. Security vulnerabilities (CVEs)
2. Framework core (Ash, Phoenix, LiveView)
3. Direct dependencies
4. Transitive dependencies

### 3. Execute Upgrade
```bash
mix deps.update [package]
mix deps.get
mix compile
```

Check compilation:
- Warnings → May indicate breaking changes
- Errors → Must fix before proceeding

### 4. Fix Breaking Changes (domain specialist)
Based on package:
- **Ash/AshPostgres**: ash-resource-architect
- **Phoenix/LiveView**: frontend-design-enforcer or heex-template-expert
- **General Elixir**: code-review-implement

Common breaking changes:
- Function signature changes → Update call sites
- Deprecated APIs → Use new equivalents
- Config format changes → Update config files
- Behavior changes → Adapt code logic

### 5. Test Everything (test-builder)
```bash
mix test
mix format
mix credo --strict
mix compile --warnings-as-errors
```

**Critical**: All tests must pass. If tests fail:
1. Identify which tests broke
2. Determine if test needs update or code has bug
3. Fix issues
4. Re-run full suite

### 6. Document Changes (docs-maintainer)
Update:
- `CHANGELOG.md` - What was upgraded, why
- `mix.exs` - Version constraints if changed
- Migration notes if breaking changes affect usage
- Usage rules if patterns changed

## Upgrade Types

### Security Patches
**Always upgrade immediately**
- Run `mix deps.audit` to find vulnerabilities
- Upgrade affected packages
- Test thoroughly
- Deploy ASAP

### Minor Version Bumps
**Low risk, can batch**
- Generally backward compatible
- May add deprecation warnings
- Safe to upgrade multiple at once
- Test after all upgrades

### Major Version Bumps
**High risk, one at a time**
- Breaking changes expected
- Upgrade one package per session
- Read CHANGELOG for breaking changes
- Extensive testing required
- May need code refactoring

### Framework Upgrades (Ash, Phoenix, Elixir)
**Highest risk, maximum caution**
- Plan dedicated sprint
- Read migration guides
- Test exhaustively
- Consider beta/RC testing first
- Have rollback plan

## Quality Gates
```bash
mix deps.get
mix compile --warnings-as-errors
mix format
mix credo --strict
mix test
mix dialyzer  # if used
```

## Success Criteria
- [ ] Dependencies updated in mix.lock
- [ ] All tests pass
- [ ] No new compiler warnings
- [ ] CHANGELOG updated
- [ ] Breaking changes documented
- [ ] No security vulnerabilities remain

## Risk Management
**Before upgrading**:
- Commit current working state
- Create branch for upgrade work
- Note current dependency versions

**If upgrade fails**:
- Git reset to previous state
- Document what failed
- Research issue or defer upgrade

## Notes
- **Test first**: Ensure all tests pass before starting
- **One major at a time**: Don't compound risk
- **Read CHANGELOGs**: Know what's changing
- **Security first**: Patches trump features
- For reference, see `.claude/README.md` for dependency-auditor workflows
