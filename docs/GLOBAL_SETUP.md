# Smart MCP Global Setup Guide

This guide explains how to set up Smart MCP to work globally across all directories (SuperClaude-style).

## Architecture Overview

Smart MCP now uses a hierarchical configuration system:

```
Global Layer (Base Defaults)
└── ~/.claude/smart_mcp/shortcuts.json
└── ~/.claude/commands/sm/{refactor,debug,audit}.md
└── ~/.claude/MCP_SmartMCP.md

Project Layer (Optional Overrides)
└── $CWD/shortcuts.json
```

**Merge Strategy**: Project-local shortcuts override global shortcuts (like .gitignore behavior).

## Installation Steps

### 1. Verify Global Files Exist

Check that these files were created:

```bash
# Global shortcuts
ls -la ~/.claude/smart_mcp/shortcuts.json

# Global slash commands
ls -la ~/.claude/commands/sm/

# Global documentation
ls -la ~/.claude/MCP_SmartMCP.md
```

### 2. Update Claude Desktop Config

Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "smart-mcp": {
      "type": "stdio",
      "command": "python3",
      "args": ["/Users/bradleytangonan/Desktop/my apps/smart_mcp/smart_mcp.py"],
      "env": {}
    }
  }
}
```

**Important**: Use the absolute path to `smart_mcp.py` in your setup.

### 3. Restart Claude Desktop

Completely quit and restart Claude Desktop for changes to take effect.

### 4. Verify Installation

In any Claude Code session from ANY directory:

```
# Check MCP tool is available
What tools are available?

# Test a slash command
/sm:audit

# Test direct tool invocation
Use the sm tool with shortcut='refactor'
```

## Usage Patterns

### Global Commands (Work Everywhere)

```bash
# From ~/Desktop
/sm:refactor authentication logic

# From ~/projects/myapp
/sm:debug fix memory leak

# From /tmp
/sm:audit
```

All work because shortcuts are loaded from `~/.claude/smart_mcp/shortcuts.json`.

### Project-Specific Overrides

Create `shortcuts.json` in any project root:

```json
{
  "shortcuts": {
    "refactor": {
      "description": "Custom refactor for this project",
      "instruction": "Apply our team's specific refactoring guidelines..."
    },
    "deploy": {
      "description": "Deploy to staging",
      "instruction": "Deploy following our deployment checklist..."
    }
  }
}
```

**Behavior**:
- `refactor` shortcut uses project version (overrides global)
- `debug` and `audit` use global versions (no override)
- `deploy` is project-only (new shortcut)

## Hierarchical Loading

The MCP server loads shortcuts in this order:

1. **Load global**: `~/.claude/smart_mcp/shortcuts.json`
2. **Load project**: `$CWD/shortcuts.json` (if exists)
3. **Merge**: Project overrides global for conflicting names

This allows:
- ✅ Global defaults work everywhere
- ✅ Projects can customize/override
- ✅ Projects can add new shortcuts
- ✅ No duplication of common shortcuts

## Slash Command Naming

Smart MCP uses `/sm:*` prefix to match SuperClaude's `/sc:*` pattern:

- `/sm:refactor` - Surgical refactoring framework
- `/sm:debug` - Systematic debugging (7 steps)
- `/sm:audit` - Repository assessment (8 stages)

These appear as **gitignored** commands (not project-local).

## Customization

### Add Global Shortcuts

Edit `~/.claude/smart_mcp/shortcuts.json`:

```json
{
  "shortcuts": {
    "refactor": { ... },
    "debug": { ... },
    "audit": { ... },
    "your-shortcut": {
      "description": "Your custom global shortcut",
      "instruction": "Your instruction text here..."
    }
  }
}
```

Restart Claude Desktop after changes.

### Add Project Shortcuts

Create `shortcuts.json` in project root (no restart needed):

```json
{
  "shortcuts": {
    "test": {
      "description": "Run project tests",
      "instruction": "Run the test suite with: npm test..."
    }
  }
}
```

## Troubleshooting

### Shortcuts Not Loading

```bash
# Check global file exists and is valid JSON
cat ~/.claude/smart_mcp/shortcuts.json | python3 -m json.tool

# Check project file if using one
cat shortcuts.json | python3 -m json.tool
```

### MCP Server Not Found

```bash
# Verify server in Claude Desktop config
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Check Python can run the server
python3 /path/to/smart_mcp.py
```

### Slash Commands Not Appearing

```bash
# Verify files exist
ls -la ~/.claude/commands/sm/

# Check YAML frontmatter
head -10 ~/.claude/commands/sm/refactor.md
```

## Benefits

**Before** (Project-Local):
- ❌ Commands only work in smart_mcp directory
- ❌ Must copy .claude/commands/ to every project
- ❌ Updates require changing multiple projects

**After** (Global):
- ✅ Commands work from ANY directory
- ✅ Single source of truth for global shortcuts
- ✅ Projects can override/extend as needed
- ✅ Updates propagate everywhere automatically

## Advanced: Variable Substitution

Shortcuts support variable placeholders:

```json
{
  "shortcuts": {
    "analyze": {
      "description": "Analyze specific aspect",
      "instruction": "Analyze {task} focusing on performance and security."
    }
  }
}
```

Usage:
```
/sm:analyze database queries
# Expands to: "Analyze database queries focusing on performance and security."
```

Supported variables: `{task}`, `{context}`, `{target}`, `{file}`

## Next Steps

1. Test global commands from different directories
2. Create project-specific shortcuts as needed
3. Add custom global shortcuts for your workflows
4. Document team conventions in project shortcuts

## See Also

- `README.md` - Project overview
- `~/.claude/MCP_SmartMCP.md` - MCP integration guide
- `.claude/commands/sm/` - Slash command documentation
