# Smart MCP Slash Commands

SuperClaude-enhanced slash command wrappers for Smart MCP shortcuts. Each command provides comprehensive behavioral guidance with YAML frontmatter, detailed documentation, and concrete examples.

After restarting Claude Code, these commands will be available.

## Available Commands

### `/debug [task]`
**Description**: World-class codebase auditor with 7-step structured debugging process
**Namespace**: Smart MCP (shows as "project:sm" in help)

**Usage**:
```
/debug fix authentication timeout in login.py
/debug resolve memory leak in data processor
```

### `/refactor [context]`
**Description**: Surgical refactoring with golden-master testing and fitness functions
**Namespace**: Smart MCP (shows as "project:sm" in help)

**Usage**:
```
/refactor
/refactor authentication logic
```

**What it does**:
- Code smell detection: Long files/functions, deep nesting, duplication, temporal coupling
- Architectural layering: Move business logic to core/, I/O to adapters/, composition to app/
- Golden-master characterization: Snapshot inputs→outputs before changes, compare after
- Fitness functions: LOC limits, dependency rules, error shape validation, API snapshots
- Strangler pattern: Build new pure modules, shim old paths, remove after parity
- Outputs: docs/refactor/smells.md, decisions.md, golden-master/ fixtures

### `/audit`
**Description**: Comprehensive repository self-assessment sweep with maturity scoring
**Namespace**: Smart MCP (shows as "project:sm" in help)

**Usage**:
```
/audit
```

**What it does**:
- 8-stage analysis: Repo probe, LOC discipline, frameworks/routes, validation coverage, secrets hygiene, state management, error handling, testing/CI
- Generates evidence artifacts in `docs/preaudit/`
- Produces maturity scores (0-3) across 6 dimensions
- Creates PRE_AUDIT_SUMMARY.md with top risks and strengths
- No code modifications, evidence-based findings only

## How They Work

Each slash command is an enhanced markdown file with:
- **YAML Frontmatter**: Metadata including personas, MCP servers, complexity level
- **Comprehensive Documentation**: Triggers, usage, behavioral flow, examples
- **Tool Coordination**: Which Claude Code tools to use for each step
- **Clear Boundaries**: What the command will and won't do
- **MCP Tool Integration**: Invokes the `sm` MCP tool to retrieve the full instruction framework

This structure mirrors SuperClaude's command format for consistency and clarity.

## Adding New Commands

To add a new slash command:
1. Add the shortcut to `shortcuts.json` in the project root
2. Create a new `.md` file in the `sm/` subdirectory: `sm/yourcommand.md`
3. Add the instruction: `Use the sm tool with shortcut='yourcommand' and context='$ARGS'`
4. Restart Claude Code

**Note**: Commands are organized in the `sm/` subdirectory for namespace clarity. They appear in help text as "(project:sm)" to distinguish them from global commands.

## Location
`/Users/bradleytangonan/Desktop/my apps/smart_mcp/.claude/commands/sm/`
