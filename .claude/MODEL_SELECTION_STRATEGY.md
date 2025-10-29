# Model Selection Strategy

**Version**: 1.0.0
**Date**: 2025-10-29
**Status**: Active

---

## Philosophy

xTweak uses a **cost-optimized model selection strategy** that balances quality, speed, and API costs:

- **Haiku 4.5** for bounded implementation tasks with clear patterns
- **Sonnet 4.5** for analysis, judgment, coordination, and complex reasoning
- **Manual escalation** when Haiku encounters complexity beyond its capabilities

This approach delivers **30-40% cost savings** on API calls while maintaining high quality through clear escalation paths.

---

## Agent Model Assignments

### Haiku Agents (6 agents - 26% of fleet)

Fast, cost-effective execution for bounded tasks:

| Agent | Rationale | Escalation Trigger |
|-------|-----------|-------------------|
| **mcp-verify-first** | Structured MCP queries with clear output format. High-frequency usage. | MCP server errors, incomplete context |
| **docs-maintainer** | Straightforward markdown editing, changelog sync. Pattern-driven. | Complex formatting issues, merge conflicts |
| **code-review-implement** | Applies structured feedback from code-reviewer reports. Clear input/output. | Compile errors, test failures, uncertain fixes |
| **database-migration-specialist** | Schema-focused SQL generation following Ash/Ecto patterns. | Complex data transformations, backfill logic |
| **pattern-librarian** | Read-only pattern compliance verification. Structured checklist output. | Pattern interpretation ambiguity |
| **monitoring-setup** | Configuration-focused telemetry setup. Clear patterns from docs. | Complex observability requirements |

**Cost Savings**: These 6 agents handle ~40-50% of execution volume (high-frequency tasks).

### Sonnet Agents (17 agents - 74% of fleet)

Quality reasoning for analysis, judgment, and coordination:

#### Research & Analysis (7 agents)
- **nuxt-ui-expert** - Component API research requires accurate extraction
- **cytoscape-expert** - Graph integration needs precise understanding
- **tailwind-component-expert** - Component design requires judgment
- **tailwind-strategist** - Layout strategy requires architectural thinking
- **code-reviewer** - Code analysis requires deep reasoning
- **security-reviewer** - Security assessment cannot tolerate errors
- **performance-profiler** - Bottleneck analysis requires profiling expertise

#### Architecture & Design (4 agents)
- **ash-resource-architect** - Domain modeling requires business logic understanding
- **frontend-design-enforcer** - UX orchestration requires coordination
- **agent-architect** - Meta-level agent design requires strategic thinking
- **api-contract-guardian** - API contracts require compatibility analysis

#### Implementation & Coordination (6 agents)
- **test-builder** - Test design can be complex, requires judgment
- **release-coordinator** - Release readiness requires comprehensive checks
- **dependency-auditor** - Dependency analysis requires security expertise
- **ci-cd-optimizer** - CI/CD optimization requires workflow understanding
- **beam-runtime-specialist** - BEAM runtime debugging requires deep OTP knowledge
- **beam-runtime-specialist** - Complex infrastructure debugging

---

## Decision Tree: When to Use Haiku vs Sonnet

### Use Haiku When:
- ✅ Task has clear, documented patterns to follow
- ✅ Input is structured (e.g., review report, MCP response)
- ✅ Output is well-defined (e.g., context packet, changelog)
- ✅ Task is high-frequency (cost savings add up)
- ✅ Failure is easily detectable (compile errors, test failures)

### Use Sonnet When:
- ✅ Task requires judgment calls or interpretation
- ✅ Multiple approaches are valid, need to choose best
- ✅ Analysis or reasoning is the primary deliverable
- ✅ Coordination across multiple concerns
- ✅ High-stakes work (security, architecture, production)
- ✅ Unsure which model to use (Sonnet is safer default)

### Example Workflows:

**Cost-Optimized Feature Implementation:**
```
1. mcp-verify-first (Haiku) → Gather project context
2. ash-resource-architect (Sonnet) → Design domain model
3. code-review-implement (Haiku) → Apply any patterns
4. test-builder (Sonnet) → Design test strategy
5. code-reviewer (Sonnet) → Validate implementation
```

**Quality-First Security Review:**
```
1. mcp-verify-first (Haiku) → Gather context
2. security-reviewer (Sonnet) → Comprehensive analysis
3. code-review-implement (Haiku) → Apply security fixes
4. security-reviewer (Sonnet) → Re-validate
```

---

## Escalation Strategy

### When to Escalate from Haiku to Sonnet

**Automatic Escalation Signals** (Haiku agent will flag these):

1. **Compile Errors**
   - Haiku's fix produces compiler warnings/errors
   - Type mismatches, missing imports, syntax errors
   - **Action**: Re-run with Sonnet for deeper analysis

2. **Test Failures**
   - Haiku's implementation fails existing tests
   - New tests don't pass
   - **Action**: Re-run with Sonnet for test debugging

3. **MCP Tool Failures**
   - MCP server returns errors or incomplete data
   - Context gathering hits timeouts
   - **Action**: Re-run with Sonnet for robust error handling

4. **Pattern Violations**
   - Output doesn't follow required patterns
   - Missing core pattern stack references
   - **Action**: Re-run with Sonnet for pattern compliance

5. **Uncertain Outcomes**
   - Haiku expresses uncertainty in output
   - Multiple valid approaches, unclear which to choose
   - **Action**: Re-run with Sonnet for judgment

### Escalation Output Format

When Haiku agents encounter escalation triggers, they output:

```markdown
⚠️ HAIKU ESCALATION RECOMMENDED

**Error Type**: [Compile Error/Test Failure/MCP Error/Pattern Violation/Uncertainty]

**Details**:
[Specific error message, stack trace, or description]

**Analysis**:
[Why this requires Sonnet's enhanced reasoning]

**Suggested Action**:
Re-run this task with Sonnet model for enhanced analysis.

**How to Escalate**:
[Exact agent invocation or command to retry with Sonnet]
```

### Manual Escalation

User can always choose Sonnet over Haiku:
- Complex tasks that benefit from deeper reasoning
- Time-sensitive work where retries are costly
- High-stakes changes (production, security)
- Learning scenarios (observe Sonnet's approach)

**How to Manually Escalate**:
Simply invoke the Sonnet version of the agent (all agents have Sonnet mode) with the same prompt.

---

## Cost/Quality Tradeoffs

### Expected Cost Savings

| Scenario | Haiku First | Sonnet Only | Savings |
|----------|-------------|-------------|---------|
| Simple context gathering | $0.02 | $0.20 | 90% |
| Doc update (no escalation) | $0.05 | $0.50 | 90% |
| Code fix (no escalation) | $0.10 | $1.00 | 90% |
| Code fix (with escalation) | $0.10 + $1.00 = $1.10 | $1.00 | -10% |

**Key Insight**: Even if 20% of Haiku tasks escalate, overall savings are 70%+.

**Target Escalation Rate**: <10% (1 in 10 Haiku executions requires Sonnet retry)

### Quality Guarantees

1. **Pattern Compliance**: All agents (Haiku + Sonnet) use core pattern stack
2. **Self-Check**: Haiku agents run same self-check-core validation as Sonnet
3. **MCP-First**: Both models require evidence-based reasoning
4. **User Control**: Manual escalation preserves quality when needed

### When Cost Savings Don't Matter

Use Sonnet directly for:
- Critical path work (blocking releases)
- Security assessments (cannot tolerate false negatives)
- Architecture decisions (expensive to reverse)
- Complex debugging (Haiku won't solve it anyway)

---

## Model Specifications

### Haiku 4.5
- **Model ID**: `claude-3-5-haiku-20241022`
- **Context**: 200K tokens
- **Speed**: ~2-3x faster than Sonnet
- **Cost**: ~90% cheaper than Sonnet
- **Best For**: Bounded implementation, pattern following

### Sonnet 4.5
- **Model ID**: `claude-sonnet-4-5-20250929`
- **Context**: 200K tokens
- **Speed**: Baseline
- **Cost**: Baseline
- **Best For**: Analysis, judgment, coordination, complex reasoning

---

## Validation & Monitoring

### Success Metrics

**Target Metrics** (after 2 weeks):
- Haiku escalation rate: <10%
- Compile success rate (Haiku): >90%
- Test pass rate (Haiku): >85%
- Pattern compliance: 100% (both models)
- User satisfaction: >4/5 with escalation clarity

**Cost Metrics**:
- Total API cost reduction: 30-40%
- Average cost per task: 60% of Sonnet-only baseline

### Monitoring

**Weekly Review**:
- Track escalation rates per Haiku agent
- Identify agents with >15% escalation → Consider moving back to Sonnet
- Document common escalation patterns
- Update agent prompts to reduce false escalations

**Monthly Review**:
- Validate cost savings against targets
- Review user feedback on model selection
- Adjust agent assignments if needed
- Update this strategy document

---

## Adjustment Protocol

### Moving Agent from Haiku → Sonnet

**Criteria**:
- Escalation rate >15% for 2+ weeks
- User feedback: "Always needs Sonnet"
- Pattern emerges: Haiku can't handle typical cases

**Process**:
1. Update agent frontmatter: `model: haiku` → `model: sonnet`
2. Remove escalation guidance from agent docs
3. Update this strategy document
4. Note in CHANGELOG.md

### Moving Agent from Sonnet → Haiku

**Criteria**:
- Task is high-frequency and well-bounded
- Existing pattern docs cover >90% of cases
- Risk is low (easy to detect failures)

**Process**:
1. Test with 10 typical scenarios
2. Measure success rate (target: >90%)
3. Update agent frontmatter: `model: sonnet` → `model: haiku`
4. Add escalation guidance to agent docs
5. Update this strategy document
6. Note in CHANGELOG.md
7. Monitor for 2 weeks

---

## FAQ

### Q: Why not make all agents Haiku?
**A**: Many tasks require judgment, interpretation, or deep reasoning that Haiku struggles with. Using Sonnet for these ensures quality while Haiku handles the bounded tasks.

### Q: Why not automatic escalation?
**A**: Claude Code's architecture doesn't support agents invoking other agents or changing models at runtime. Manual escalation gives users control and prevents unnecessary cost escalation for transient errors.

### Q: What if Haiku keeps failing for my use case?
**A**: Skip Haiku and invoke the Sonnet version directly. Not all tasks fit Haiku's capabilities, and that's expected.

### Q: Can I override model selection per invocation?
**A**: Currently, model is set in agent frontmatter. To use different model, you'd invoke a different agent variant (if exists) or manually edit the agent file temporarily.

### Q: How do I know if escalation was worth it?
**A**: Escalation is worth it if Haiku produced errors and Sonnet fixed them. If Sonnet also struggled, the task was inherently complex (not a model issue).

### Q: Will this strategy change over time?
**A**: Yes! As models improve, we'll adjust assignments. Haiku may become capable of more complex tasks, or new models may emerge. Review quarterly.

---

## Version History

- **v1.0.0** (2025-10-29) - Initial strategy with 6 Haiku agents, manual escalation approach
