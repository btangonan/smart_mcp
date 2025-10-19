# Smart MCP Server

**Purpose**: Custom instruction shortcuts for reusable development workflows and quality frameworks

## Triggers
- Comprehensive code quality work: refactoring, debugging, auditing
- Surgical refactoring with golden-master testing requirements
- Systematic debugging requiring structured 7-step analysis
- Repository maturity assessment and technical debt quantification
- Custom workflow automation via shortcuts
- Project-specific development patterns needing instruction templates

## Choose When
- **Over manual instructions**: When you need consistent, repeatable development workflows
- **For quality frameworks**: Surgical refactoring, systematic debugging, comprehensive audits
- **For project patterns**: Team-specific development instructions and workflows
- **Not for one-off tasks**: Simple code changes without structured methodology

## Works Best With
- **Sequential**: Smart MCP provides framework → Sequential coordinates multi-step execution
- **Context7**: Official docs for technologies → Smart MCP provides team/project patterns
- **Serena**: Project understanding → Smart MCP applies customized workflows

## Global Architecture
- **Global shortcuts**: `~/.claude/smart_mcp/shortcuts.json` (base defaults)
- **Project shortcuts**: `$CWD/shortcuts.json` (project-specific overrides)
- **Slash commands**: `/sm:refactor`, `/sm:debug`, `/sm:audit`
- **Hierarchical loading**: Project-local overrides global (like .gitignore)

## Available Shortcuts

### /sm:refactor
Surgical code refactoring with golden-master testing and fitness functions

**Use when**:
- Files exceed 300 LOC requiring decomposition
- Code smells need systematic remediation
- Architecture improvements must preserve behavior
- Technical debt reduction requires backward compatibility

**Key features**:
- Golden-master characterization (snapshot inputs→outputs)
- Fitness functions (LOC gates, dependency rules, API shape validation)
- Strangler pattern (build new, shim old, remove after parity)
- Structured observability for old vs new code paths

### /sm:debug
World-class systematic debugging with 7-step structured process

**Use when**:
- Complex bugs require root cause analysis
- Production incidents need audit-quality resolution
- Environmental/dependency issues need thorough investigation
- Breaking changes require careful compatibility planning

**Process**:
1. Define task specifically
2. Investigate environment/dependencies
3. Anticipate issues/pitfalls
4. Plan actionable steps
5. Audit (self-critique plan)
6. Revise based on audit
7. Execute with documentation

### /sm:audit
Comprehensive repository self-assessment with maturity scoring

**Use when**:
- Pre-launch readiness assessment needed
- Technical debt quantification required
- Security posture evaluation necessary
- Architecture maturity baseline establishment

**8-stage analysis**:
- Repo probe (detect structure, languages, frameworks)
- LOC discipline (complexity hotspots, oversized files)
- Frameworks & IO edges (routes, APIs, entry points)
- Schema validation coverage
- Secrets & config hygiene
- State & persistence mapping
- Error handling, retries, idempotency
- Testing, coverage, CI/CD
- Maturity scoring (0-3 across 6 dimensions)

## Custom Shortcuts

Create custom shortcuts by editing:
- **Global**: `~/.claude/smart_mcp/shortcuts.json` (available everywhere)
- **Project**: `$CWD/shortcuts.json` (project-specific overrides)

**Example custom shortcut**:
```json
{
  "shortcuts": {
    "api-review": {
      "description": "Review API endpoint for company standards",
      "instruction": "Review this API ensuring:\n- Rate limiting implemented\n- OAuth2 authentication\n- Standard JSON response format\n- Appropriate status codes\n- Request ID logging for tracing"
    }
  }
}
```

Variable substitution supported: `{task}`, `{context}`, `{target}`, `{file}`

## Integration Patterns

**With Sequential MCP**:
```
Smart MCP provides framework → Sequential coordinates execution
Example: /sm:refactor → Sequential breaks down into phases
```

**With Context7 MCP**:
```
Context7 provides official docs → Smart MCP applies team patterns
Example: Context7 gets React patterns → Smart MCP adds company conventions
```

**With Project Memory (Chroma)**:
```
Smart MCP workflow → Log decisions to Chroma for future reference
Example: /sm:audit generates findings → Store in project_memory
```

## Installation

### 1. Global Setup (Already Done)
```bash
# Global shortcuts
~/.claude/smart_mcp/shortcuts.json

# Global slash commands
~/.claude/commands/sm/refactor.md
~/.claude/commands/sm/debug.md
~/.claude/commands/sm/audit.md
```

### 2. Claude Desktop Config
Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "smart-mcp": {
      "type": "stdio",
      "command": "python3",
      "args": ["/FULL/PATH/TO/smart_mcp.py"],
      "env": {}
    }
  }
}
```

### 3. Project-Specific Customization (Optional)
Create `shortcuts.json` in project root for custom/override shortcuts.

## Examples

### Global Refactoring
```
/sm:refactor authentication logic
# Works from ANY directory
# Uses global shortcuts
```

### Project-Specific Override
```
# Project has shortcuts.json with custom "refactor" definition
/sm:refactor
# Uses project-local version instead of global
```

### Custom Project Workflow
```
# Project shortcuts.json adds "api-review" shortcut
# Now available only in this project
Use sm tool with shortcut='api-review'
```

## Troubleshooting

**Shortcut not found**:
- Check `~/.claude/smart_mcp/shortcuts.json` exists
- For project shortcuts, check `$CWD/shortcuts.json`
- Verify JSON is valid
- Restart Claude Desktop after changes

**MCP tool not available**:
- Verify Claude Desktop config has smart-mcp server
- Check Python path in config is correct
- Ensure smart_mcp.py is executable
- Check Claude Desktop logs for errors

**Slash commands not working**:
- Verify files exist in `~/.claude/commands/sm/`
- Check YAML frontmatter is valid
- Ensure category is "gitignored"
- Restart Claude Desktop
