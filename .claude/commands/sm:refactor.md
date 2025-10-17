---
name: refactor
description: "Surgical refactoring with golden-master testing and fitness functions"
category: workflow
complexity: advanced
mcp-servers: [sequential]
personas: [architect, refactoring-expert, qa-specialist]
---

# /sm:refactor - Surgical Code Refactoring

> **Smart MCP Note**: This command invokes the `sm` MCP tool with the `refactor` shortcut, which provides a comprehensive surgical refactoring framework with golden-master testing and fitness functions.

## Triggers
- Large or complex files (>300 LOC) requiring decomposition
- Code smells and anti-patterns needing systematic remediation
- Architecture improvements requiring behavior preservation
- Technical debt reduction with strict backward compatibility requirements

## Usage
```
/sm:refactor [context]

# Examples:
/sm:refactor                           # Analyze current context
/sm:refactor authentication logic      # Focus on specific area
/sm:refactor src/core/payments.ts      # Target specific file
```

## Behavioral Flow

**GOAL**: Improve structure, clarity, testability without changing behavior

1. **Find Code Smells**: Long files/functions, deep nesting, duplication, temporal coupling
2. **Better Abstractions**: Extract pure core logic, introduce ports/interfaces
3. **Design Patterns**: Strategy, Adapter, Factory, Pipeline (only where justified)
4. **Naming & Clarity**: Intent-revealing names, remove abbreviations
5. **Reduce Complexity**: Split functions, keep side-effects in adapters
6. **Backward Compatibility**: Preserve signatures or add shims with deprecation

Key behaviors:
- Golden-master characterization: Snapshot inputs→outputs before changes
- Fitness functions: LOC gates, dependency rules, error shape validation
- Strangler pattern: Build new pure module, shim old paths, remove after parity
- Observability: Structured logs for old vs new paths with correlation IDs

## Non-Negotiables (Vibe Rules)
- ≤300 LOC/file (500 max), single responsibility per file
- Strong types + schema validation at API/IO edges
- No secrets in code/logs; env + secret manager only
- Minimal process state; durable truth in DB/object store
- Structured errors (Problem+JSON), retries/backoff, idempotency preserved

## Secret Sauce (Techniques)

### Golden-Master Characterization
Before changes, snapshot inputs→outputs for top routes/CLI. Compare byte-for-byte post-refactor.

### Fitness Functions (CI)
- **LOC gate**: Fail if any file >300 LOC
- **Dependency rule**: Forbid src/core importing from src/adapters
- **Error shape lock**: Assert Problem+JSON fields on 4xx/5xx
- **Public API snapshot**: Schema diff must be zero

### Strangler Shim
Build new pure module → route old entry points through shim → remove old code after parity passes

### Observability
Add structured logs around old vs new paths with correlationId; count mismatches during shadow runs

## MCP Integration
- **Sequential MCP**: Complex architectural analysis and pattern detection
- **Smart MCP Tool**: Retrieves comprehensive refactoring framework

## Tool Coordination
- **Read/Grep/Glob**: Code smell detection, complexity analysis
- **Edit/MultiEdit**: Surgical code modifications maintaining parity
- **Write**: Generate smells.md, decisions.md, golden-master fixtures
- **Bash**: Run tests, validate fitness functions, check parity

## Outputs
- `docs/refactor/smells.md` - Code smells & resolutions (before/after)
- `docs/refactor/decisions.md` - Patterns chosen + rationale (≤20 lines)
- `docs/refactor/golden-master/` - Fixtures & parity report
- `docs/refactor/CHANGELOG.md` - Change summary (≤20 lines)
- Minimal PR diff (refactor + tests + doc delta)

## Acceptance Criteria
- ✓ Behavioral parity: golden-master/contract tests pass
- ✓ File size limits respected; SRP improved
- ✓ Public APIs unchanged (or shims present); Problem+JSON shape intact
- ✓ Idempotency keys and retry logic preserved
- ✓ New/updated tests for extracted pure logic; ≥80% coverage on touched files
- ✓ Lint/format/typecheck/fitness functions pass

## Examples

### Authentication Module Refactor
```
/sm:refactor authentication logic

1. Detect smells: auth.ts 847 LOC, mixed concerns
2. Extract core: Business rules → src/core/auth/
3. Adapters: JWT validation, DB queries → src/adapters/
4. Golden-master: Record 50 auth scenarios before changes
5. Strangler: New AuthService, shim old validateUser()
6. Parity: 100% match on golden-master fixtures
7. Cleanup: Remove old code after shadow run success
```

### Payment Processing Cleanup
```
/sm:refactor src/core/payments.ts

Code smells identified:
- payments.ts: 612 LOC (split into 3 files)
- 8 functions >20 lines (extract helpers)
- Temporal coupling between charge() and reconcile()

Architectural improvements:
- Extract PaymentStrategy for provider-specific logic
- Move Stripe/PayPal to src/adapters/payment/
- Pure business rules in src/core/payment/

Fitness functions:
- LOC gate: All files now ≤280 LOC ✓
- Dependency rule: core/ doesn't import adapters/ ✓
- API snapshot: /charge endpoint unchanged ✓
```

## Boundaries

**Will:**
- Systematically detect and remediate code smells with evidence
- Preserve behavior through golden-master testing and fitness functions
- Apply strangler pattern for safe architectural improvements
- Generate comprehensive documentation of changes and rationale

**Will Not:**
- Change behavior without explicit golden-master validation
- Break public APIs without shims and deprecation notices
- Skip fitness function validation before declaring success
- Refactor without clear code smell evidence and justification

## Invocation
This command executes: `Use the sm tool with shortcut='refactor' and context='$ARGS'`

The MCP tool returns the full surgical refactoring framework instruction, which Claude then applies systematically.
