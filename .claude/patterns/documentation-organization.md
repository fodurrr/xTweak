# Documentation Organization Pattern

**Pattern**: `documentation-organization`
**Purpose**: Enforce consistent documentation placement across the project
**Updated**: November 1, 2025

---

## Core Principle

Documentation lives closest to what it documents, organized by scope and audience.

---

## Three-Tier Documentation Structure

### Tier 1: Project-Wide Documentation (`Human_docs/`)

**Scope**: Cross-cutting project concerns, workflows, coordination

**Belongs Here**:
- Workflow guides (how to work with Claude Code)
- Setup instructions (Claude CLI, tooling)
- Project-wide conventions
- Cross-app coordination docs

**Does NOT Belong Here**:
- App-specific user guides
- Component API references
- App-specific tutorials
- Sprint reports (those go in AI_docs)

**Examples**:
✅ `Human_docs/COMPLETE_WORKFLOW_GUIDE.md` - How to work with Claude Code
✅ `Human_docs/claude_cli_setup.md` - Claude CLI setup
❌ `Human_docs/SHOWCASE_GUIDE.md` - xTweak UI specific (moved to `apps/xtweak_ui/docs/`)
❌ `Human_docs/SPRINT_2_COMPLETION_REPORT.md` - Sprint report (moved to `AI_docs/prd/06-sprint-plans/`)

---

### Tier 2: App-Specific Documentation (`apps/{app}/docs/`)

**Scope**: Documentation for a specific umbrella app

**Belongs Here**:
- App user guides
- App API references
- App-specific tutorials
- App feature documentation

**Does NOT Belong Here**:
- Project-wide workflow docs
- Cross-app coordination
- Sprint/PRD reports

**Examples**:
✅ `apps/xtweak_ui/docs/SHOWCASE_GUIDE.md` - xTweak UI showcase guide
✅ `apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md` - Component API
✅ `apps/xtweak_core/docs/DOMAIN_GUIDE.md` - Core domain documentation (if created)
❌ `apps/xtweak_ui/docs/WORKFLOW_GUIDE.md` - Project-wide (belongs in `Human_docs/`)

---

### Tier 3: AI Documentation (`AI_docs/`)

**Scope**: AI-facing documentation (PRD, architecture, sprint plans, reports)

**Belongs Here**:
- PRD documents
- Architecture decisions
- Sprint plans and reports
- AI workflow patterns
- Technical specifications

**Does NOT Belong Here**:
- Human workflow guides (those go in `Human_docs/`)
- App user guides (those go in `apps/{app}/docs/`)

**Examples**:
✅ `AI_docs/prd/QUICK_START.md` - AI quick reference
✅ `AI_docs/prd/06-sprint-plans/phase-1-foundation/sprint-2-COMPLETION-REPORT.md` - Sprint report
✅ `AI_docs/prd/03-architecture.md` - Architecture decisions
❌ `AI_docs/SHOWCASE_GUIDE.md` - User guide (belongs in `apps/xtweak_ui/docs/`)

---

## Decision Tree

When creating or placing documentation, ask:

```
Is this about a specific app's features/API?
├─ YES → apps/{app}/docs/
└─ NO → Is this for AI (PRD, sprint plans, architecture)?
    ├─ YES → AI_docs/
    └─ NO → Is this project-wide workflow/coordination?
        ├─ YES → Human_docs/
        └─ NO → Consider if documentation is needed at all
```

---

## Suggested App Docs Structure

While not enforced, we recommend this structure for `apps/{app}/docs/`:

```
apps/{app}/docs/
├── README.md           # Index of all docs for this app
├── GUIDE.md            # User guide / getting started
├── API.md              # API reference (if applicable)
├── EXAMPLES.md         # Code examples and tutorials
└── ARCHITECTURE.md     # App-specific architecture (optional)
```

**Customize as needed** - different apps have different documentation needs.

---

## Enforcement

### Mandatory Rules (MANDATORY_AI_RULES.md)
- **Hard rule**: Claude must follow documentation placement rules
- Violations should be caught in review

### Pattern Usage (This File)
- **Reusable reference**: Explains where docs belong
- **Decision tree**: Quick placement guide
- **Examples**: Clear right/wrong patterns

### Human README (Human_docs/README.md)
- **Section**: "Documentation Organization"
- **Explains**: The three-tier structure for humans
- **Links**: To this pattern for details

### Claude Guidelines (CLAUDE.md)
- **Reference**: Link to this pattern
- **Instruction**: Check pattern before creating docs

---

## Examples by Type

### User Guides
- **Component showcase**: `apps/xtweak_ui/docs/SHOWCASE_GUIDE.md` ✅
- **Domain guide**: `apps/xtweak_core/docs/DOMAIN_GUIDE.md` ✅
- **Project workflow**: `Human_docs/COMPLETE_WORKFLOW_GUIDE.md` ✅

### API References
- **Component API**: `apps/xtweak_ui/docs/COMPONENT_API_REFERENCE.md` ✅
- **Core domain API**: `apps/xtweak_core/docs/API_REFERENCE.md` ✅
- **Inline moduledocs**: In source files ✅

### Reports & Summaries
- **Sprint reports**: `AI_docs/prd/06-sprint-plans/phase-X/sprint-Y-REPORTS.md` ✅
- **Task summaries**: `AI_docs/prd/06-sprint-plans/phase-X/TASK_N_SUMMARY.md` ✅
- **PRD status**: `AI_docs/prd/.prd-completion-status.md` ✅

### Architecture & Design
- **Project architecture**: `AI_docs/prd/03-architecture.md` ✅
- **App architecture**: `apps/{app}/docs/ARCHITECTURE.md` ✅
- **Technical specs**: `AI_docs/prd/01-technical-specification.md` ✅

### Workflow & Setup
- **Claude Code workflow**: `Human_docs/COMPLETE_WORKFLOW_GUIDE.md` ✅
- **Claude CLI setup**: `Human_docs/claude_cli_setup.md` ✅
- **Renaming guide**: `Human_docs/project-renaming.md` ✅

---

## Migration Checklist

When moving existing docs to comply with this pattern:

1. ☑ Identify doc scope (project, app, AI)
2. ☑ Move to appropriate tier
3. ☑ Update all references in other docs
4. ☑ Update root README if needed
5. ☑ Update app README if needed
6. ☑ Update Human_docs/README.md index
7. ☑ Verify links work

---

## Rationale

### Why This Structure?

1. **Locality**: Docs live near what they document
2. **Portability**: App docs move with the app if extracted
3. **Clarity**: Clear separation of concerns
4. **Scalability**: Easy to add new apps without clutter
5. **Audience**: Different audiences find docs where they expect

### Benefits

- **For Developers**: Find app-specific docs in the app
- **For Claude**: Clear rules prevent misplacement
- **For Project**: Cleaner, more organized documentation
- **For Users**: Natural discovery of relevant docs

---

## Self-Check

Before creating documentation, verify:

- [ ] I know which tier this doc belongs to (project/app/AI)
- [ ] I've checked the decision tree
- [ ] I've looked at examples for this doc type
- [ ] I'll update all necessary indexes/references
- [ ] This placement makes sense for the audience

---

## Related Patterns

- `placeholder-basics.md` - How to use placeholders in examples
- `collaboration-handoff.md` - How to document task handoffs
- `phase-zero-context.md` - Context detection for docs

---

## Notes

- This pattern was established November 1, 2025
- Based on lessons learned from Human_docs reorganization
- May evolve as project grows
