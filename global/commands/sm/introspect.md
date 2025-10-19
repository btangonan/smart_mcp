---
name: introspect
description: "Meta-cognitive analysis with naive-agent perspective for evaluating solution soundness"
category: gitignored
complexity: advanced
mcp-servers: [sequential, chroma]
personas: [root-cause-analyst, socratic-mentor, quality-engineer]
---

# /sm:introspect - Meta-Cognitive Solution Soundness Analysis

> **Smart MCP Note**: This command invokes the `sm` MCP tool with the `introspect` shortcut, applying naive-agent perspective to evaluate whether debugging or feature work addresses the right problem in the right way.

## Triggers
- Debugging efforts stalled or producing unexpected results
- Feature implementations that feel overly complex or misaligned
- Need for fresh-eyes review without situational bias
- Suspicion of solving the wrong problem or addressing symptoms vs root cause
- Complex issues where multiple attempted solutions have failed
- Before committing to significant architectural changes

## Philosophy

**Core Principle**: Act as naive agent with ZERO situational context. Rebuild understanding from evidence alone to expose assumptions, cognitive biases, and logical gaps that familiarity obscures.

**Key Distinction**:
- `/sm:debug` → Find and fix problems in code
- `/sm:introspect` → Evaluate whether solving the RIGHT problem in the RIGHT way

## Usage
```
/sm:introspect [context]

# Examples:
/sm:introspect                                    # Analyze current work
/sm:introspect authentication bug                 # Evaluate debugging effort
/sm:introspect src/payments/refund-flow.ts        # Assess feature soundness
```

## Behavioral Flow

### 1. Context Reset (Meta-Reset)
Deliberately forget all prior assumptions. Treat current understanding as hypothesis, not fact. Question everything, even "obvious" truths.

### 2. Evidence Reconstruction
Rebuild from verifiable evidence only:
- **Hard Evidence**: Error messages, stack traces, test results, code as written, logs, metrics
- **Soft Evidence**: Developer explanations, assumptions about behavior, theories about causes

### 3. Assumption Identification
Surface all implicit assumptions using Socratic questioning:
- How do we KNOW this? (vs believing it)
- What evidence would disprove this?
- What are we taking for granted?
- What "obvious" truths might be wrong?

### 4. Alternative Hypothesis Generation
Generate competing explanations (minimum 3):
- Include simple explanation (Occam's Razor)
- Include "this isn't actually a problem" hypothesis
- Consider system-level vs code-level causes
- Weight by probability and required evidence

### 5. Cognitive Bias Detection
Identify biases affecting judgment:
- Confirmation bias (seeking only supporting evidence)
- Anchoring bias (stuck on first explanation)
- Sunk cost fallacy (continuing due to invested effort)
- Availability bias (overweighting recent similar issues)

### 6. Soundness Evaluation
Quantitative scoring (0-10) across criteria:

**For Debugging**:
- Root cause clarity (symptom vs cause distinction)
- Fix validation (addresses cause, not symptom)
- Hypothesis strength (evidence quality)
- Completeness (edge cases considered)

**For Features**:
- Problem-solution fit (stated vs assumed problem)
- Approach justification (vs simpler alternatives)
- User impact analysis (workflows, personas, edge cases)
- Risk assessment (security, performance, rollback plan)

Generate soundness score, confidence level, and recommendation: CONTINUE | PIVOT | INVESTIGATE

### 7. Blind Spot Analysis
Identify uninvestigated areas:
- Environmental factors (dev vs prod, load conditions)
- Temporal factors (race conditions, timing)
- Integration points (external services, APIs)
- User scenarios (different types, edge cases)

### 8. Institutional Knowledge Integration
Query project memory (Chroma) for similar issues, historical solutions, and lessons learned. Compare current approach vs historical patterns.

## MCP Integration

- **Sequential MCP**: Complex reasoning chains, hypothesis testing, multi-step analysis
- **Chroma MCP**: Query institutional knowledge for similar issues and their resolutions

## Tool Coordination

- **Read/Grep/Glob**: Evidence gathering (code, tests, logs, errors)
- **Sequential**: Hypothesis generation, bias detection, soundness reasoning
- **Chroma**: Historical context and pattern matching
- **Write**: Generate introspection reports in `docs/introspection/`
- **Bash**: Test validation, runtime state inspection

## Key Patterns

- **Evidence-First**: Verifiable facts → assumptions clearly labeled → hypothesis generation
- **Bias Detection**: Systematic check for confirmation, anchoring, availability, sunk cost biases
- **Alternative Thinking**: Multiple competing explanations → probability weighting → falsification tests
- **Soundness Scoring**: Quantitative evaluation → confidence assessment → actionable recommendation

## Examples

### Debugging Soundness

```
/sm:introspect authentication error

Output Summary:
---
Soundness Score: 3/10 (LOW)
Recommendation: INVESTIGATE

Evidence:
✓ Hard: Error "undefined user" at auth.ts:142, fails with expired tokens
⚠️ Soft: Assumed token expiry is root cause (UNVERIFIED)

Assumptions:
1. Token expiry causes error (Gap: haven't tested with valid tokens)
2. Moving validation fixes it (Gap: fix not tested, might move error)

Alternative Hypotheses:
- H1: Token expiry (40% probability)
- H2: Middleware order issue (35%)
- H3: Null user in database (15%)
- H4: Race condition (10%)

Biases Detected:
⚠️ Confirmation bias: Only tested expired token scenarios
⚠️ Anchoring bias: Stuck on "expiry" from error message

Blind Spots:
❌ Not tested: valid tokens, concurrent requests, DB state
❌ Not checked: middleware execution order

Recommendation: Test with valid token first, verify middleware order
---
```

### Feature Soundness

```
/sm:introspect src/search/advanced-filter.ts

Output Summary:
---
Soundness Score: 6/10 (MEDIUM)
Recommendation: PIVOT

Problem-Solution Fit: 5/10
⚠️ Stated Problem: "Users want faster search"
⚠️ Solution: Advanced filtering with 12 options
⚠️ Gap: Complexity doesn't address speed

Assumptions:
1. "Better search" = "more filter options" (User research needed)
2. 12 filters improve UX (Not user-tested, could overwhelm)

Alternative Approaches:
- H1: Optimize search backend for speed (addresses stated problem)
- H2: User research to validate filter needs (validates assumptions)
- H3: Improve existing 3 filters UI (simpler path)

Recommendation: PIVOT - Address performance first, validate filter needs with users
Justification: Stated problem is speed, but solution adds complexity
---
```

## Outputs

Generate in `docs/introspection/[timestamp]/`:
- **introspection-report.md** - Full analysis with evidence, assumptions, hypotheses, biases, soundness score
- **recommendations.md** - Actionable next steps with priorities and expected outcomes

## Boundaries

**Will:**
- Force context reset and rebuild understanding from evidence alone
- Surface assumptions and cognitive biases systematically
- Generate multiple alternative hypotheses with probability weights
- Provide quantitative soundness evaluation with clear criteria
- Query institutional knowledge for historical patterns
- Deliver actionable recommendations with risk assessment

**Will Not:**
- Accept stated problem/solution at face value without evidence
- Proceed with incomplete evidence or unverified assumptions
- Give binary "right/wrong" judgments without nuanced analysis
- Skip bias detection or alternative hypothesis generation
- Recommend actions without considering risks and trade-offs

## Invocation

This command executes: `Use the sm tool with shortcut='introspect' and context='$ARGS'`

The MCP tool returns the meta-cognitive introspection framework, which Claude applies systematically as a naive agent rebuilding understanding from evidence.
