---
name: audit
description: "Comprehensive repository self-assessment sweep with maturity scoring"
category: analysis
complexity: advanced
mcp-servers: [sequential]
personas: [analyzer, architect, security]
---

# /sm:audit - Repository Self-Assessment

> **Smart MCP Note**: This command invokes the `sm` MCP tool with the `audit` shortcut, which provides an 8-stage repository analysis framework with evidence-based findings and maturity scoring.

## Triggers
- Pre-launch readiness assessment and production deployment validation
- Technical debt quantification and improvement roadmap creation
- Security posture evaluation and compliance validation
- Architecture review and maturity baseline establishment

## Usage
```
/sm:audit

# This is a standalone command requiring no arguments
# Analyzes the entire repository across 8 dimensions
```

## Behavioral Flow (8-Stage Analysis)

### STAGE 0: Repo Probe
Auto-detect monorepo/polyrepo, languages, frameworks, infrastructure presence

### STAGE 1: Inventory & LOC Discipline
Identify files >300 LOC, calculate complexity hotspots, track technical debt

### STAGE 2: Frameworks, Routes, IO Edges
Detect web frameworks, exposed routes, RPC/gRPC, CLI entry points

### STAGE 3: Schema & Validation Coverage
Check request/response schema enforcement, type safety from adapters inward

### STAGE 4: Secrets & Config Hygiene
Scan for hardcoded secrets, check .env patterns, validate secret loading

### STAGE 5: State & Persistence Map
Identify DBs, object stores, cross-request memory, idempotency keys

### STAGE 6: Errors, Retries, Idempotency
Check error standardization (Problem+JSON), retry/backoff, DLQ usage

### STAGE 7: Tests, Coverage, CI/CD
Detect test frameworks, coverage gates, CI workflows, quality automation

### STAGE 8: Maturity Scoring & Summary
Compute 0-3 maturity scores across 6 dimensions with evidence-based rationale

## Non-Negotiables (Vibe Rules)
- ≤300 LOC per file; SRP per file
- Typed + validated at API/IO edges (Zod/JSON Schema/Pydantic)
- Secrets never in code/logs/images; env + secret manager only
- Minimal process state; durable truth in DB/object store
- Fail fast/loud/recover: structured errors, retries/backoff, idempotency

## Operating Constraints
- **Make no edits to source** - evidence gathering only
- **Prefer evidence artifacts** (JSON/MD) over prose
- **Self-call /sc: commands** where indicated for deeper analysis
- **Cap total artifacts ≤12 files** - keep in `docs/preaudit/`

## Maturity Dimensions (0-3 Scale)

**LOC Discipline**
- 0: Frequent >500 LOC files
- 1: Many >300 LOC files
- 2: Few >300 LOC files
- 3: All ≤300 LOC

**Validation Coverage**
- 0: No schema validation
- 1: <33% routes with schemas
- 2: 33-80% coverage
- 3: ≥80% coverage

**Secrets Hygiene**
- 0: Raw secrets in code
- 1: Weak env usage
- 2: Env + lint
- 3: Env + secret manager + scans

**State & Persistence**
- 0: Cross-request in-memory state
- 1: Mixed ad-hoc persistence
- 2: Durable with gaps
- 3: Durable + idempotent

**Errors/Retry/Idempotency**
- 0: Ad-hoc error handling
- 1: Some try/catch
- 2: Structured or retries
- 3: Problem+JSON + retries + idempotency

**Testing/CI**
- 0: No tests
- 1: Some unit tests
- 2: Units + basic CI
- 3: Units + integration + coverage gate

## MCP Integration
- **Sequential MCP**: Multi-stage analysis coordination and pattern detection
- **Smart MCP Tool**: Retrieves comprehensive audit framework

## Tool Coordination
- **Glob/Grep**: File discovery, pattern matching, evidence gathering
- **Read**: Configuration analysis, code inspection, secret scanning
- **Write**: Artifact generation in `docs/preaudit/`
- **Bash**: External analysis tools, coverage reports, CI workflow inspection

## Outputs (docs/preaudit/)
- `repo-shape.json` - Repo type, languages, frameworks, infra
- `file-inventory.json` - All files with LOC counts
- `oversized-files.json` - Files >300 LOC
- `hotspots.md` - Top 20 files by LOC
- `frameworks.json` - Web frameworks, routes, validators
- `api-validation.json` - Schema coverage analysis
- `secrets-findings.json` - Secret scan results
- `config-sources.md` - Env/config loading patterns
- `state-map.md` - Persistence architecture
- `error-surface.md` - Error handling analysis
- `test-landscape.md` - Test framework presence
- `ci-signals.json` - CI/CD workflow analysis
- `maturity.json` - Maturity scores (0-3)
- `PRE_AUDIT_SUMMARY.md` - Executive summary with top risks/strengths

## Examples

### Startup Readiness Assessment
```
/sm:audit

Repo Shape: Single repo, TypeScript/Python, Fastify + Flask
LOC Discipline: Score 2 (8 files >300 LOC, largest 487 LOC)
Validation: Score 2 (67% routes with Zod schemas)
Secrets: Score 3 (No secrets found, .env.example present)
State: Score 1 (In-memory job queue, no idempotency keys)
Errors: Score 2 (Structured errors, no retries)
Testing: Score 2 (78% coverage, no integration tests)

Top 3 Risks:
1. Cross-request job Map causes lost jobs on restart
2. No retry logic for external API calls
3. 8 oversized files violate SRP

Top 3 Strengths:
1. Strong secret hygiene with env + linting
2. Good validation coverage (67%)
3. CI gates on tests + typecheck
```

### Enterprise Migration Baseline
```
/sm:audit

Establishes maturity baseline before modernization:
- 247 files, 89 >300 LOC (LOC score: 0)
- Validation: 12% (Score: 0)
- Tests: Units only, no CI (Score: 1)

Generates 2-PR minimum fix plan:
- PR1: Split 20 largest files (>500 LOC)
- PR2: Add Zod validation to top 10 routes
```

## Boundaries

**Will:**
- Perform comprehensive evidence-based repository analysis
- Generate maturity scores with supporting evidence and file references
- Produce actionable 2-PR minimum improvement plan
- Document top risks and strengths with evidence links

**Will Not:**
- Modify any source code (evidence gathering only)
- Make assumptions without evidence from code/config
- Skip stages or compress analysis for speed
- Generate fixes or implementations (audit only)

## Next Step (Post-Audit)
After generating `PRE_AUDIT_SUMMARY.md`, proceed with:
```
--audit VIBE_AUDIT_REPORT + FIX_PLAN
```

Use maturity scores and top risks to create 2-PR minimum plan (≤2 files/PR unless justified).

Each PR: explicit acceptance criteria, tiny diffs, tests, docs deltas (README/env, GUARDRAILS.md, QC_CHECKLIST.md).

## Invocation
This command executes: `Use the sm tool with shortcut='audit'`

The MCP tool returns the full 8-stage audit framework instruction, which Claude then executes systematically.
