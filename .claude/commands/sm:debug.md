---
name: debug
description: "World-class codebase auditor and debugger with structured 7-step process"
category: workflow
complexity: advanced
mcp-servers: [sequential]
personas: [auditor, architect, security]
---

# /sm:debug - Systematic Debugging & Root Cause Analysis

> **Smart MCP Note**: This command invokes the `sm` MCP tool with the `debug` shortcut, which provides a comprehensive 7-step debugging framework for systematic problem resolution.

## Triggers
- Complex bugs requiring root cause analysis and systematic investigation
- Critical issues needing thorough environmental and dependency assessment
- Breaking changes or compatibility problems requiring careful planning
- Production incidents requiring audit-quality resolution documentation

## Usage
```
/sm:debug [task description]

# Examples:
/sm:debug fix authentication timeout in login.py
/sm:debug resolve memory leak in data processor
/sm:debug investigate why API returns 500 on large payloads
```

## Behavioral Flow (7-Step Process)

1. **Define Task**: Articulate the problem specifically and concretely
2. **Investigate**: List all steps required including environment, dependencies, compatibility
3. **Anticipate Issues**: Identify likely bugs, pitfalls, breaking changes
4. **Plan**: Break down exact steps into clear, actionable plan
5. **Audit (Self-Critique)**: Independent critical evaluation of the plan
6. **Revise**: Improve plan based on audit feedback
7. **Execute**: Implement final revised plan with code and commands

Key behaviors:
- Systematic investigation before action (no premature fixes)
- Self-critique and revision before execution
- Environment and dependency awareness throughout
- Audit-quality documentation of decisions and rationale

## MCP Integration
- **Sequential MCP**: Multi-step reasoning for complex debugging scenarios
- **Smart MCP Tool**: Retrieves comprehensive debugging instruction framework

## Tool Coordination
- **Read/Grep/Glob**: Code investigation and pattern analysis
- **Bash**: Environment validation, dependency checks, test execution
- **Edit/Write**: Implementation of fixes after thorough planning
- **TodoWrite**: Track multi-step debugging progress

## Key Patterns
- **Systematic Investigation**: Gather evidence → form hypothesis → test → revise
- **Self-Audit**: Independent critical review before execution prevents rework
- **Environment Awareness**: Dependencies, compatibility, breaking changes considered upfront
- **Documentation**: Each step labeled clearly for audit trail

## Examples

### Authentication Timeout Debug
```
/sm:debug fix authentication timeout in login.py

Step 1 - Define: JWT token validation timing out after 30s in production
Step 2 - Investigate: Check token expiry, network latency, DB query times
Step 3 - Anticipate: Clock skew, timezone issues, DB connection pooling
Step 4 - Plan: [detailed 5-step fix plan]
Step 5 - Audit: [critique identifying missing retry logic]
Step 6 - Revise: [updated plan with exponential backoff]
Step 7 - Execute: [implementation with tests]
```

### Memory Leak Investigation
```
/sm:debug resolve memory leak in data processor

Systematic investigation of heap growth patterns
Environment checks: Node version, V8 flags, container limits
Hypothesis testing: Event listener cleanup, cache unbounded growth
Audit reveals missing WeakMap usage for cache
Revised plan includes proper cleanup and monitoring
```

## Boundaries

**Will:**
- Perform systematic root cause analysis with audit-quality rigor
- Consider environment, dependencies, and compatibility impacts
- Self-critique plan before execution to prevent rework
- Document each step clearly for audit trail and learning

**Will Not:**
- Jump to solutions without thorough investigation
- Skip self-audit step (plan must be critiqued before execution)
- Ignore environmental factors or breaking change risks
- Execute without clear, revised plan

## Invocation
This command executes: `Use the sm tool with shortcut='debug' and context='$ARGS'`

The MCP tool returns the full 7-step debugging framework instruction, which Claude then follows systematically.
