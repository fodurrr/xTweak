# XPando → XTweak Migration Status

## Overview

This document tracks the status of renaming XPando references to XTweak throughout the project.

## ✅ Documentation Files - COMPLETED

### Fully Updated Files:
1. **CLAUDE.md** - Template with placeholders, XTweak as example
2. **AGENTS.md** - Updated to xtweak_core, xtweak_web
3. **.claude/AGENT_USAGE_GUIDE.md** - All XPando examples → XTweak/Blog/Shop
4. **.claude/patterns/ash-resource-pattern.md** - XPando examples removed
5. **6 core agent files** in `.claude/agents/`:
   - agent-architect.md
   - code-reviewer.md
   - ash-resource-architect.md
   - frontend-design-enforcer.md
   - test-builder.md
   - mcp-verify-first.md

All use placeholder `{YourApp}` pattern with XTweak as example where appropriate.

## ⚠️ FILES NEEDING ATTENTION

### Documentation Files (Can be updated safely):

#### High Priority:
- [ ] `.claude/AGENT_REFACTORING_REPORT.md` - Old report with XPando references
- [ ] `apps/xtweak_core/README.md` - May have old XPando refs
- [ ] `apps/xtweak_docs/README.md` - May have old XPando refs
- [ ] `dev_docs/*.md` files - Check for XPando references
- [ ] `docs/frontend_design_principles/frontend-design-principles.md` - Has XPando examples

#### Medium Priority:
- [ ] `.claude/agent-workflows.md` - May have XPando references
- [ ] `.claude/settings.local.json` - Check paths

### Code Files (REQUIRES CAREFUL MIGRATION):

**⚠️ WARNING**: These are REAL application code files. Changing them requires:
1. Updating module definitions
2. Updating all references throughout codebase
3. Running tests after changes
4. Potentially updating database references

#### Application Code:
- `config/prod.exs` - References `XpandoWebWeb.Endpoint`
- `config/runtime.exs` - Multiple XPando config references
- `apps/xtweak_web/lib/xpando_web_web.ex` - **Old module file still exists!**
- `apps/xtweak_web/lib/xpando_web.ex` - **Old module file still exists!**

#### Resource Snapshots:
- `apps/xtweak_core/priv/resource_snapshots/**/*.json` - Database migration files
  - **DO NOT** blindly update - these are historical records

#### Generated/Lock Files:
- `package-lock.json`, `node_modules/.package-lock.json` - Generated, safe to ignore
- Test support files - May have XPando in test data

## 🎯 Recommended Action Plan

### Phase 1: Documentation Only (SAFE - Can do now)
```bash
# Update remaining documentation files
# This is safe and doesn't affect running code

1. Update .claude/AGENT_REFACTORING_REPORT.md
2. Update apps/xtweak_*/README.md files
3. Update dev_docs/*.md files
4. Update docs/frontend_design_principles/
```

### Phase 2: Code Migration (REQUIRES TESTING)
```bash
# This changes actual application code!
# Requires comprehensive testing

1. Rename module files:
   - xpando_web_web.ex → xtweak_web_web.ex
   - xpando_web.ex → xtweak_web.ex

2. Update module definitions inside files:
   - defmodule XpandoWebWeb → XTweakWebWeb
   - defmodule XpandoWeb → XTweakWeb

3. Update all references in:
   - config/prod.exs
   - config/runtime.exs
   - All importing files

4. Run full test suite:
   - mix test
   - mix compile --warnings-as-errors

5. Test application startup:
   - mix phx.server
   - Verify all pages load
```

### Phase 3: Historical Files (LEAVE AS-IS)
```bash
# DO NOT update these:
- priv/resource_snapshots/**/*.json - Historical migration records
- Generated package-lock.json files
```

## Current State Summary

**What's Done:**
- ✅ All agent instruction files use placeholders
- ✅ CLAUDE.md is a template
- ✅ AGENTS.md updated to xtweak
- ✅ Documentation patterns are project-agnostic

**What's Partially Done:**
- ⚠️ Code has BOTH xpando and xtweak files
- ⚠️ Some docs still reference XPando

**What Needs Doing:**
- 📝 Finish updating remaining markdown docs
- 🔧 Complete module renaming in actual code (separate careful task)

## Detection Behavior

When agents run Phase 0 detection NOW, they will find:
```bash
ls apps/
# Output: xtweak_core, xtweak_web, xtweak_ui, xtweak_docs

mcp__ash_ai__list_ash_resources
# Should show: XTweak.Core (if modules are fully migrated)
# Currently might show mixed results due to transition state
```

## Notes

1. **This is an infrastructure template project** - XTweak, not the XPando application
2. **Placeholders are working** - Documentation is reusable
3. **Code migration is separate** - Requires systematic module renaming with tests
4. **Resource snapshots are historical** - Leave them as-is (they're migration records)

## Next Steps

**For Documentation (Safe):**
Run focused grep to find remaining doc files:
```bash
grep -r "xpando\|XPando" \
  --include="*.md" \
  --exclude-dir=node_modules \
  --exclude-dir=deps \
  --exclude-dir=_build \
  .
```

**For Code (Careful):**
Create a separate migration plan with:
1. Module rename checklist
2. Test verification steps
3. Rollback plan if issues arise

---

**Status as of**: 2025-10-01
**Documentation**: 80% complete
**Code Migration**: Needs separate careful task
