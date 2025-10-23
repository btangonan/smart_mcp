# Advisory Mode Update for INTEGRATED-LEAN-PLAN.md

## Date
2024-10-22

## Status
**IMPLEMENTED** - quality-gate v1.0.0 uses advisory mode by default

## Changes Required to INTEGRATED-LEAN-PLAN.md

### 1. Executive Summary (Line 23)

**OLD:**
```markdown
- 100% /sm:audit compliance (enforced by quality-gate)
```

**NEW:**
```markdown
- 100% /sm:audit awareness (tracked by quality-gate in advisory mode)
- Optional strict enforcement for critical branches (user choice)
```

### 2. Principle 1 Section (Lines 50-67)

**OLD:**
```markdown
### Principle 1: "Measure, then improve" (/sm:audit)

**Traditional approach**: Hope user remembers to audit
**Skills approach**: quality-gate ENFORCES /sm:audit ≥8.0 before commits

**Automation**:
- Every commit blocked until audit passes
- All scores logged to Chroma automatically
- Trends surfaced by context-builder
- Improvement visible over time
```

**NEW:**
```markdown
### Principle 1: "Measure, then improve" (/sm:audit)

**Traditional approach**: Hope user remembers to audit
**Skills approach**: quality-gate provides AWARENESS via advisory mode (non-blocking by default)

**Automation**:
- Every commit gets quick audit (shows score, never blocks)
- All scores logged to Chroma automatically
- Trends surfaced by context-builder
- Improvement visible over time
- Optional strict mode for critical branches (user-configured)

**User Control**:
- Default: Advisory mode (~3 sec, never blocks)
- WIP commits: Instant skip with keywords
- Critical branches: Opt-in strict mode
- Always: Override and escape hatches available
```

### 3. Skill 1: quality-gate.md Full Specification (Lines 606-751)

**REPLACE ENTIRE SECTION** with:

```yaml
---
name: quality-gate
version: 1.0.0
category: workflow
priority: medium  # Changed from "critical" - user can bypass
triggers:
  - "ready to commit"
  - "commit"
  - "committing"
  - "merge to main"
  - "merge to master"
  - "create pr"
  - "create pull request"

chroma_query: ["audit scores", "quality trends", "past issues", "improvement patterns"]
smart_mcp_integration: true
reinforces: ["/sm:audit awareness", "quality measurement", "continuous improvement"]
smart_mcp_dependencies:
  sm:audit: "^1.0.0"
version_check: automatic

configuration:
  mode: "advisory"  # advisory (default) | strict | off
  advisory:
    show_score: true
    show_trend: true
    log_to_chroma: true
  strict:
    enabled_for: []  # Branches requiring strict enforcement (e.g., ["main", "master"])
    threshold: 8.0
  skip_keywords: ["wip", "temp", "experiment", "spike", "testing"]
---

# Quality Gate - Smart Advisory Mode

## Purpose

**"Quality awareness without friction"**

Provides passive quality monitoring that builds useful data over time WITHOUT blocking your workflow. By default, runs quick audits and shows scores but NEVER prevents commits.

**What it does**:
- Runs fast quality audits (~2-3 seconds)
- Shows quality scores and trends
- Logs data to Chroma for pattern tracking
- **Never blocks commits by default** (advisory mode)
- Provides opt-in strict mode for critical branches
- Instant skip for experimental work

**What it doesn't do**:
- ❌ Block rapid iteration
- ❌ Force fixes during prototyping
- ❌ Get in the way of moving fast

## Three Modes

### 1. Advisory Mode (Default)

```
User: "commit the changes"

quality-gate: [2-second quick audit]
              "✅ Committed. Score: 7.8/10.0 ↑"

Git: [commits immediately]
Chroma: [logs score for trend tracking]

Time: ~3 seconds total
Blocked: Never
Value: Quality awareness + trend data
```

### 2. Strict Mode (Opt-In Only)

Enable for specific branches only:
```yaml
strict:
  enabled_for: ["main", "master"]
  threshold: 8.0
```

```
User: "merge to main"

quality-gate: "🛡️ Main branch - strict mode"
              [Full audit]
              "Score: 7.5/10.0 - Below threshold 8.0

              Issues found:
              - Missing error handling in auth.js
              - No input validation in api.js

              [Fix Now] [Show Details] [Override & Commit]"
```

### 3. Off Mode (Zero Overhead)

```yaml
mode: "off"
```

Completely disabled.

## Example Interactions

### Scenario 1: Regular Commit (Advisory)

```
User: "ready to commit auth changes"

quality-gate: [Quick audit runs]
              "✅ Committed. Score: 7.6/10.0 ↑ (improving)"

Behind the scenes:
- Ran /sm:audit on changed files
- Found score 7.6
- Queried Chroma: last scores were 7.2, 7.4
- Calculated trend: improving ↑
- Logged to Chroma
- Committed immediately
```

### Scenario 2: WIP Work (Skip)

```
User: "wip commit - testing an idea"

quality-gate: "✅ Committed (audit skipped)"

Behind the scenes:
- Detected "wip" keyword
- Skipped audit entirely
- Logged skip to Chroma
- Committed immediately
```

### Scenario 3: Main Branch (Strict, if enabled)

```
User: "merge to main"

quality-gate: "🛡️ Main branch - running strict audit..."
              [Full audit]
              "⚠️ Score: 7.5/10.0 - Below threshold 8.0

              Issues found:
              - Missing error handling in src/auth.js:45
              - No input validation in src/api.js:22

              [Fix Now] [Show Full Report] [Override & Commit]"
```

## Chroma Integration

### Log Format

```javascript
{
  "documents": [
    "Quality audit: score 7.8, branch feat/auth, mode advisory, improved from 7.2"
  ],
  "metadatas": {
    "type": "quality_audit",
    "score": "7.8",
    "threshold": "8.0",
    "mode": "advisory",
    "branch": "feat/auth",
    "passed": "true",
    "skipped": "false",
    "trend": "improving",
    "timestamp": "2024-10-22T14:30:00Z",
    "source": "quality-gate"
  },
  "ids": ["quality_audit_20241022_143000"]
}
```

### Query Patterns

```javascript
// Get recent scores for trend
mcp__chroma__chroma_query_documents({
  collection_name: "smart_mcp_memory",
  query_texts: ["quality audit scores recent"],
  n_results: 5
})
```

## Escape Hatches

You're **never truly blocked**:

1. **Skip keywords**: "wip", "temp", "experiment", "spike"
2. **Explicit override**: "commit --skip-quality"
3. **Change mode**: "turn off quality gate"
4. **Interactive override**: [Override & Commit] button
5. **Configuration file**: Set `mode: "off"`

## Value Without Friction

Even in non-blocking advisory mode:

- **Quality awareness**: See scores, learn patterns
- **Trend tracking**: Chroma builds history
- **Pattern detection**: smart-mcp-coach uses data
- **Team alignment**: Optional strict for shared branches
- **Learning feedback**: See recommendations

## Recommended Setup (Solo Developers)

```yaml
mode: advisory          # Never blocks
skip_keywords: true     # "wip" instantly skips
show_score: true        # See the score
show_trend: true        # See if improving
log_to_chroma: true     # Build trend data

strict:
  enabled_for: []       # No blocking on any branch
```

**Experience:**
- Regular commits: 3-second audit, commits anyway
- WIP commits: Instant skip
- Never blocked
- Builds useful data

If even 3 seconds feels like friction, set `mode: "off"`.

## Philosophy

**Quality-gate is a helpful assistant, not an enforcer.**

- **Default**: Informative, never blocking
- **Optional**: Strict mode for critical branches
- **Flexible**: Multiple escape hatches
- **Valuable**: Builds useful data over time
- **Respectful**: Your workflow, your choice

---

*For complete implementation details, see:* `~/.claude/skills/quality-gate.md` (678 lines)
```

### 4. Architecture Diagram Update (Line ~180)

**OLD:**
```
Stage 1: Session Start → context-builder surfaces past work
Stage 2: Task Planning → smart-mcp-coach prompts introspection
Stage 3: Implementation → tool-selector routes to methodology
Stage 4: Commit → quality-gate ENFORCES audit ≥8.0
Stage 5: Learning → All log to Chroma, cycle repeats
```

**NEW:**
```
Stage 1: Session Start → context-builder surfaces past work
Stage 2: Task Planning → smart-mcp-coach prompts introspection
Stage 3: Implementation → tool-selector routes to methodology
Stage 4: Commit → quality-gate TRACKS quality (advisory mode, never blocks)
Stage 5: Learning → All log to Chroma, cycle repeats
```

## Rationale for Changes

### User Feedback
> "is quality gate going to get in the way of moving fast and testing things; i dont' want blockers"

### Solution
- Changed default from "strict enforcement" to "advisory awareness"
- Maintained all quality tracking and learning loop benefits
- Made strict mode opt-in for users/teams who want it
- Preserved multiple escape hatches

### Benefits of Advisory Mode

**For Solo Developers:**
- No friction in rapid iteration
- Quality awareness without blocking
- Data collection for trends
- Option to enable strict later

**For Teams:**
- Enable strict only on main/master
- Feature branches remain fast
- Protects production without slowing development

**For All:**
- User control (advisory/strict/off)
- Skip keywords for WIP work
- Override always available
- Quality data still collected

## Implementation Status

✅ **COMPLETE**
- quality-gate v1.0.0 implemented with advisory mode
- File: `~/.claude/skills/quality-gate.md` (678 lines, 14KB)
- Documentation: `claudedocs/quality-gate-implementation.md`
- Testing guide: `claudedocs/quality-gate-testing.md`
- Chroma log: "skill_quality_gate_created_20241022"

## Next Steps

1. **Test quality-gate** in real usage scenarios
2. **Update INTEGRATED-LEAN-PLAN.md** with these changes (optional - can reference this supplement)
3. **Continue Day 2**: Implement context-builder skill
4. **Verify integration**: Ensure context-builder uses quality-gate data correctly

## Notes

- Advisory mode is MORE aligned with "80-20" philosophy (high value, low friction)
- Strict mode remains available for those who need enforcement
- Learning loop still works (Chroma logging unchanged)
- Other skills (context-builder, smart-mcp-coach) can still use quality data

## Files Modified/Created

- ✅ `~/.claude/skills/quality-gate.md` - Skill implementation
- ✅ `claudedocs/quality-gate-implementation.md` - Implementation summary
- ✅ `claudedocs/quality-gate-testing.md` - Testing guide
- ✅ `docs/ADVISORY-MODE-UPDATE.md` - This document
- ⏳ `docs/INTEGRATED-LEAN-PLAN.md` - Requires updates (optional)

**Recommendation**: Keep INTEGRATED-LEAN-PLAN.md as original design documentation, add this supplement to explain the advisory mode refinement based on user feedback.
