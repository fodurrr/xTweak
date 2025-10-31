---
description: Dependency upgrades, security patches, and framework version bumps with systematic testing and code adaptation
---

# Upgrade Dependencies Command

You are the **dependency upgrade coordinator** using specialized agents for safe, systematic package updates.

## Your Task

Upgrade project dependencies (Elixir packages, npm packages) while handling breaking changes, adapting code, running tests, and updating documentation. This command provides a systematic approach: audit → update → adapt → verify → document.

## Input Format

```
/upgrade-deps [package] [--to=version] [--flags]
```

**Examples**:
- `/upgrade-deps ash --to=3.8.0`
- `/upgrade-deps phoenix_live_view --major`
- `/upgrade-deps --security` (all security patches)
- `/upgrade-deps --all --patch` (all patch updates)
- `/upgrade-deps tailwindcss --to=3.4.0` (npm package)

**Flags**:
- `--to=X.Y.Z` - Specific version
- `--major` - Latest major version
- `--minor` - Latest minor version
- `--patch` - Latest patch version
- `--security` - Only security updates
- `--all` - All outdated packages

## Responsible Agents

### Primary Agents
- **dependency-auditor** (Sonnet) - Audit CHANGELOG, identify breaking changes
- **docs-maintainer** (Haiku) - Update mix.exs, package.json, docs
- **code-reviewer** (Sonnet) - Verify upgrade safety, no regressions

### Domain Specialists (for code adaptation)
- **ash-resource-architect** (Sonnet) - Adapt to Ash framework changes
- **frontend-design-enforcer** (Sonnet) - Adapt to Phoenix/LiveView changes
- **test-builder** (Sonnet) - Update tests for new APIs
- **database-migration-specialist** (Haiku) - Handle schema changes

### Support
- **mcp-verify-first** (Haiku) - Find affected code, check compatibility

## Workflow Steps

### Step 1: Audit Package & Identify Impact
**Agent**: `dependency-auditor` (Sonnet)

**Actions**:
1. Fetch package information:
   ```bash
   # For Hex packages
   mix hex.info <package>

   # For npm packages
   npm view <package> versions --json
   ```

2. Read CHANGELOG/release notes (use WebFetch):
   - Find breaking changes
   - Identify deprecations
   - Note new features
   - Check migration guides

3. Search codebase for affected code:
   ```bash
   # Use Grep to find deprecated API usage
   grep -r "deprecated_function" apps/
   ```

4. Check transitive dependencies:
   ```bash
   mix deps.tree | grep <package>
   ```

5. Assess impact:
   - **Low**: Patch update, no breaking changes
   - **Medium**: Minor update, deprecations only
   - **High**: Major update, breaking changes detected
   - **Critical**: Security vulnerability

**Output**:
```markdown
## Audit Report: [package] [old_version] → [new_version]

**Impact Level**: [Low/Medium/High/Critical]

**Breaking Changes** ([count]):
1. [API change description]
   - Affected files: [count]
   - Migration: [what needs to change]

**Deprecations** ([count]):
1. [Deprecated API]
   - Used in: [file:line]
   - Replacement: [new API]

**New Features**:
- [Feature 1] (optional to adopt)

**Dependencies Affected**:
- [dep1] (requires update to X.Y.Z)
- [dep2] (compatible)
```

### Step 2: Update Dependency File
**Agent**: `docs-maintainer` (Haiku)

**Actions**:
1. Update version constraint:
   - **mix.exs**: `{:ash, "~> 3.8.0"}`
   - **package.json**: `"tailwindcss": "^3.4.0"`

2. Fetch new version:
   ```bash
   mix deps.get
   # or
   npm install
   ```

3. Check for new transitive deps or conflicts:
   ```bash
   mix deps.tree
   mix deps.unlock --check-unused
   ```

4. Document in CHANGELOG.md:
   ```markdown
   ### Dependencies
   - Upgraded [package] from [old] to [new]
     - Breaking changes: [if any]
     - See migration notes below
   ```

**Output**: Updated dependency files, deps fetched

### Step 3: Adapt Code to Breaking Changes
**Agent**: Domain specialist (Sonnet) based on package type

**Selection Logic**:
```elixir
case package_domain do
  :ash | :ash_postgres | :ash_phoenix -> "ash-resource-architect"
  :phoenix | :phoenix_live_view | :phoenix_html -> "frontend-design-enforcer"
  :ecto | :postgrex -> "database-migration-specialist"
  :test_framework -> "test-builder"
  _ -> "code-review-implement"
end
```

**Actions**:
1. For each breaking change from audit:
   - Read affected file(s)
   - Apply migration as documented in CHANGELOG
   - Update to new API
   - Preserve behavior

2. For deprecations:
   - Replace deprecated calls with new API
   - Add TODO if deprecation deadline approaching
   - Document any behavior differences

3. Run format and quick check:
   ```bash
   mix format
   mix compile
   ```

4. If compilation fails, investigate and fix

**Example - Ash 3.7 → 3.8 Policy DSL change**:
```elixir
# Before (Ash 3.7)
policies do
  policy action_type(:read) do
    allow actor_attribute_equals(:role, :admin)
  end
end

# After (Ash 3.8)
policies do
  policy action_type(:read) do
    authorize_if actor_attribute_equals(:role, :admin)  # allow → authorize_if
  end
end
```

**Output**: Code adapted to new APIs, compiles successfully

### Step 4: Update Tests
**Agent**: `test-builder` (Sonnet)

**Actions**:
1. Check for test-related breaking changes:
   - New test setup required?
   - Test helpers changed?
   - Assertion macros updated?

2. Update tests to match new APIs:
   - Use MCP to run tests:
     ```bash
     mix test
     ```
   - Fix failures one by one

3. Add tests for new features (if adopting them)

4. Ensure full suite passes:
   ```bash
   mix test --cover
   ```

**Output**: All tests passing

### Step 5: Verify Quality & Compatibility
**Agent**: `code-reviewer` (Sonnet)

**Actions**:
1. Run full quality gate:
   ```bash
   mix format --check-formatted
   mix credo --strict
   mix compile --warnings-as-errors
   mix test
   ```

2. Check for new warnings:
   - Deprecation warnings?
   - New credo rules triggered?
   - Dialyzer issues?

3. Run app in dev mode (if possible):
   ```bash
   # Use MCP to start server briefly
   timeout 10 mix phx.server
   ```

4. Smoke test critical paths:
   - App starts without crashes
   - Database connections work
   - LiveView mounts successfully

5. Check bundle sizes (for frontend deps):
   ```bash
   mix assets.deploy
   ls -lh apps/*/priv/static/assets/
   ```

**Output**: All quality gates ✅, no regressions detected

### Step 6: Update Documentation
**Agent**: `docs-maintainer` (Haiku)

**Actions**:
1. Update usage_rules (if framework upgraded):
   ```bash
   mix usage_rules.sync
   ```

2. Update usage-rules/ if patterns changed:
   - Read new usage rules
   - Update xTweak-specific patterns
   - Add examples for new APIs

3. Update CHANGELOG.md with upgrade notes:
   ```markdown
   ## [Version] - [Date]

   ### Dependencies
   - **BREAKING**: Upgraded [package] [old] → [new]
     - Migration required: [describe]
     - See upgrade guide: [link if exists]

   ### Migration Notes
   - [Step 1]
   - [Step 2]
   ```

4. Update README.md if minimum versions changed:
   - Prerequisites section
   - Installation instructions

**Output**: Documentation current with new version

## Output Format

Create a todo list tracking each step, then provide this summary:

```markdown
## Dependency Upgrade Complete

📦 **Package**: [name] [old_version] → [new_version]
⚠️ **Impact**: [Low/Medium/High/Critical]

✅ **Audit** (dependency-auditor)
  - Breaking changes: [count]
    - [change 1]: [description]
  - Deprecations: [count]
    - [deprecation 1]: [description]
  - Affected files: [count]
  - Transitive deps: [list if any require updates]

✅ **Update** (docs-maintainer)
  - Updated: [mix.exs | package.json]
  - New transitive deps: [count]
  - CHANGELOG.md: ✅ Updated

✅ **Code Adaptation** ([domain-agent])
  - Files modified: [count]
    - [file1]: [what changed]
    - [file2]: [what changed]
  - Breaking changes addressed: [count]/[count]
  - Deprecations fixed: [count]/[count]

✅ **Tests** (test-builder)
  - Test updates needed: [yes/no]
  - Tests modified: [count files]
  - Test suite: ✅ [passed]/[total] passing
  - Coverage: [%] (maintained/improved)

✅ **Verification** (code-reviewer)
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass ([note if new warnings addressed])
    - Compile: ✅ Pass (no warnings)
    - Tests: ✅ Pass
    - Dialyzer: ✅ Pass (if run)
  - Smoke test: ✅ App starts successfully
  - Bundle size: [size] ([+/- X KB from before])

✅ **Documentation** (docs-maintainer)
  - usage_rules: ✅ Synced
  - usage-rules/: ✅ Updated ([count] files)
  - CHANGELOG.md: ✅ Migration notes added
  - README.md: ✅ Updated (if needed)

📝 **Suggested Commit Message**:
```
chore: upgrade [package] from [old] to [new]

- Updated all resources to use new [API pattern]
- Addressed breaking changes: [list]
- Fixed deprecations: [list]
- Updated usage_rules and framework documentation

[If breaking changes]:
Breaking changes addressed:
- [change 1]
- [change 2]

Migration required:
- [step 1]
- [step 2]

🤖 Generated with Claude Code
```
```

## Example Output

```markdown
## Dependency Upgrade Complete

📦 **Package**: ash 3.7.6 → 3.8.0
⚠️ **Impact**: High (breaking changes in policy DSL)

✅ **Audit** (dependency-auditor)
  - Breaking changes: 2
    - Policy DSL: `allow` renamed to `authorize_if`
    - Action validations: new `validate_query` callback required for query-based actions
  - Deprecations: 1
    - `use Ash.Resource` without `domain:` option
  - Affected files: 8 resources in xtweak_core
  - Transitive deps: ash_postgres requires 2.6.0+ (already compatible)

✅ **Update** (docs-maintainer)
  - Updated: mix.exs
  - New transitive deps: 0
  - CHANGELOG.md: ✅ Updated

✅ **Code Adaptation** (ash-resource-architect)
  - Files modified: 8
    - apps/xtweak_core/lib/xtweak/core/user.ex: allow → authorize_if (5 policies)
    - apps/xtweak_core/lib/xtweak/core/newsletter.ex: allow → authorize_if (3 policies)
    - [... 6 more files ...]
  - Breaking changes addressed: 2/2
  - Deprecations fixed: 8/8 (added domain: XTweak.Core to all resources)

✅ **Tests** (test-builder)
  - Test updates needed: no
  - Tests modified: 0 files
  - Test suite: ✅ 156/156 passing
  - Coverage: 82% (maintained)

✅ **Verification** (code-reviewer)
  - Quality gates:
    - Format: ✅ Pass
    - Credo: ✅ Pass (removed 1 deprecation warning)
    - Compile: ✅ Pass (no warnings)
    - Tests: ✅ Pass
    - Dialyzer: ✅ Pass
  - Smoke test: ✅ App starts, all resources load correctly
  - Bundle size: N/A (backend only)

✅ **Documentation** (docs-maintainer)
  - usage_rules: ✅ Synced (ash.md updated with new policy DSL)
  - usage-rules/: ✅ Updated (1 file: usage-rules/ash.md)
  - CHANGELOG.md: ✅ Migration notes added
  - README.md: ✅ No changes needed

📝 **Suggested Commit Message**:
```
chore: upgrade ash from 3.7.6 to 3.8.0

- Updated all resources to use new policy DSL (allow → authorize_if)
- Added `domain:` option to all `use Ash.Resource` calls
- Synced usage_rules and updated framework patterns

Breaking changes addressed:
- Policy authorization DSL updated across 8 resources
- All deprecation warnings resolved

🤖 Generated with Claude Code
```
```

## Quality Checks

- [ ] CHANGELOG/release notes reviewed
- [ ] Breaking changes identified and documented
- [ ] All affected code updated
- [ ] Tests pass (full suite)
- [ ] No new warnings (compile, credo, dialyzer)
- [ ] App starts successfully (smoke test)
- [ ] usage_rules synced (if framework)
- [ ] CHANGELOG.md updated with migration notes

## Special Cases

### Security Update (Urgent)
If upgrade fixes security vulnerability:
1. Mark in commit message: `security: upgrade [package] to fix CVE-XXXX`
2. Prioritize over all other work
3. Test thoroughly but move quickly
4. Document vulnerability impact in CHANGELOG
5. Consider if hotfix deploy needed

### Major Version Upgrade
If crossing major version boundary (e.g., Phoenix 1.7 → 2.0):
1. Allocate more time (likely >4 hours)
2. Read migration guide thoroughly
3. Consider creating PRD task instead if massive changes
4. Upgrade in steps if possible (1.7 → 1.8 → 2.0)
5. Test extensively in dev before committing

### Multiple Dependent Upgrades
If upgrading one package requires upgrading others:
1. Identify dependency chain
2. Upgrade in dependency order (deepest first)
3. Use `--all` flag to upgrade together
4. Or run multiple `/upgrade-deps` commands
5. Create single commit with all upgrades

### Upgrade Breaks Tests
If tests fail after upgrade:
1. Check if test framework APIs changed
2. Use `test-builder` to adapt tests
3. Verify behavior unchanged (may need manual check)
4. If behavior changed, document in CHANGELOG
5. If cannot fix, revert upgrade and investigate

### Bundle Size Impact
If frontend dependency increases bundle significantly (>10%):
1. Alert Peter before committing
2. Check if tree-shaking configured
3. Look for optimization options
4. Consider if upgrade worth the cost
5. Document size impact in commit message

## Integration with PRD Workflow

**When to use `/upgrade-deps` vs `/prd-implement`**:
- ✅ Dependency update required (security, compatibility)
- ✅ Framework staying current (quarterly upgrades)
- ✅ Package has breaking changes to handle
- ✅ React to Dependabot PR or security advisory

**When to create PRD task instead**:
- ❌ Upgrade enables new features you want to adopt
- ❌ Massive migration (Phoenix 1.x → 2.x)
- ❌ Multiple dependencies need coordinated upgrade
- ❌ Upgrade requires architectural changes

**After upgrade**:
- If new framework features discovered, consider PRD tasks to adopt them
- Update usage-rules/ if new patterns available
- Share knowledge in CHANGELOG for future reference

## Remember

**MANDATORY_AI_RULES.md applies**:
- Never commit without Peter's permission
- Run all quality gates
- Use MCP tools for verification
- Document decisions clearly

**Pattern Stack** (load these patterns):
- `placeholder-basics@1.0.0`
- `phase-zero-context@1.0.0`
- `mcp-tool-discipline@1.0.0`
- `self-check-core@1.1.0`
- `dual-example-bridge@1.0.0`
- `error-recovery-loop@1.0.0`

**Upgrade Safety Rules**:
1. **Read CHANGELOG first** - Don't guess at breaking changes
2. **Test before committing** - Full suite must pass
3. **Document migrations** - Future you will thank present you
4. **Security takes priority** - CVE fixes can't wait

**Cost optimization**:
- Use Sonnet for audit (critical to find all breaking changes)
- Use Haiku for simple updates (package.json, mix.exs)
- Use Sonnet for code adaptation (framework APIs complex)
- Use Haiku for docs (straightforward updates)
