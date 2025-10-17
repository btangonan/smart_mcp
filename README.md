# Smart MCP

SuperClaude-style global MCP framework for custom instruction shortcuts. Create reusable command shortcuts that work from ANY directory.

## Features

- **Global Architecture**: Works from any directory once configured (SuperClaude-style)
- **Hierarchical Shortcuts**: Global defaults + project-specific overrides
- **Single Tool Interface**: All shortcuts accessible via one `sm` tool
- **Slash Commands**: `/sm:refactor`, `/sm:debug`, `/sm:audit` work everywhere
- **JSON-Based Storage**: Easy to read and edit shortcut definitions
- **Variable Substitution**: Use `{task}`, `{file}`, `{context}`, or `{target}` placeholders
- **Extensible**: Add global or project-specific shortcuts

## Global Architecture

```
~/.claude/
├── smart_mcp/
│   └── shortcuts.json           # Global shortcuts (work everywhere)
├── commands/sm/
│   ├── refactor.md              # /sm:refactor command
│   ├── debug.md                 # /sm:debug command
│   └── audit.md                 # /sm:audit command
└── MCP_SmartMCP.md              # Integration documentation

Project (Optional Override):
$CWD/shortcuts.json              # Project-specific shortcuts
```

**Merge Strategy**: Project-local shortcuts override global (like .gitignore)

## Quick Start

### Prerequisites

```bash
pip install mcp
```

### Installation

1. **Global Setup** (Already Done if you're reading this):
   ```bash
   # Files should exist at:
   ~/.claude/smart_mcp/shortcuts.json
   ~/.claude/commands/sm/refactor.md
   ~/.claude/commands/sm/debug.md
   ~/.claude/commands/sm/audit.md
   ~/.claude/MCP_SmartMCP.md
   ```

2. **Configure Claude Desktop**:

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

   **Important**: Update the path to wherever you cloned this repo.

3. **Restart Claude Desktop**

4. **Verify Installation**:
   ```
   # From ANY directory
   /sm:audit
   ```

See **[docs/GLOBAL_SETUP.md](docs/GLOBAL_SETUP.md)** for detailed setup instructions.

## Usage

### Global Slash Commands (Work Everywhere)

Use from ANY directory after setup:

```bash
# Surgical refactoring with golden-master testing
/sm:refactor authentication logic

# Systematic debugging (7-step process)
/sm:debug fix authentication timeout in login.py

# Repository assessment (8-stage audit)
/sm:audit
```

**Note**: These commands appear as "gitignored" in `/help`, indicating they're global.

### Method 2: Direct Tool Invocation

Smart MCP provides a single tool called `sm` that executes predefined instruction shortcuts.

**Example conversations:**

```
You: "Use the sm tool with shortcut 'debug' and context 'fix authentication timeout'"

You: "Run the 'refactor' shortcut on authentication logic"
```

### Available Shortcuts

- **refactor** - Surgical refactoring with golden-master testing, fitness functions, and strangler patterns
- **debug** - World-class codebase auditor with 7-step structured process (supports `{task}` variable)
- **audit** - Comprehensive repository self-assessment sweep with maturity scoring (8-stage analysis)

## Variable Substitution

Shortcuts support variable placeholders that get replaced with the `context` parameter:

**Supported placeholders:**
- `{task}` - Replaced with context value
- `{file}` - Replaced with context value
- `{context}` - Replaced with context value
- `{target}` - Replaced with context value

**Example usage:**

```
You: "Use the sm tool with shortcut='debug' and context='fix authentication timeout in login.py'"
```

This replaces `{task}` in the debug instruction with "fix authentication timeout in login.py".

**Example shortcut with variable:**

```json
{
  "shortcuts": {
    "analyze": {
      "description": "Analyze specific code aspect",
      "instruction": "Perform a detailed analysis of {task}. Focus on edge cases, potential bugs, and optimization opportunities."
    }
  }
}
```

When invoked: `sm tool with shortcut='analyze' and context='error handling in database queries'`

Result: "Perform a detailed analysis of error handling in database queries. Focus on edge cases, potential bugs, and optimization opportunities."

## Customizing Shortcuts

Edit `shortcuts.json` to add your own shortcuts:

```json
{
  "shortcuts": {
    "your-shortcut": {
      "description": "Brief description shown in tool listing",
      "instruction": "Detailed instruction text that Claude will receive when this shortcut is invoked.\n\nCan be multi-line with formatting."
    }
  }
}
```

**Example - Project-Specific Shortcut:**

```json
{
  "shortcuts": {
    "api-review": {
      "description": "Review API endpoint for our company standards",
      "instruction": "Review this API endpoint ensuring:\n- Rate limiting is implemented\n- Authentication uses our OAuth2 flow\n- Response follows our standard JSON format\n- Error handling returns appropriate status codes\n- Logging includes request ID for tracing"
    }
  }
}
```

## How It Works

1. **Tool Registration**: Smart MCP registers a single tool `sm` with Claude
2. **Hierarchical Loading**:
   - First loads `~/.claude/smart_mcp/shortcuts.json` (global defaults)
   - Then loads `$CWD/shortcuts.json` (project overrides, if exists)
   - Merges with project-local taking precedence
3. **Execution**: When invoked, returns the instruction text for the requested shortcut
4. **Claude Processing**: Claude uses the instruction as context for the conversation

## Hierarchical Shortcuts

**Global Shortcuts** (`~/.claude/smart_mcp/shortcuts.json`):
- Work from ANY directory
- Shared across all projects
- Default shortcuts: `refactor`, `debug`, `audit`

**Project Shortcuts** (`$CWD/shortcuts.json`):
- Optional, only in specific projects
- Override global shortcuts with same name
- Add new project-specific shortcuts

**Example**:
```bash
# Global has: refactor, debug, audit
# Project adds: deploy
# Project overrides: refactor (custom version)

# Available in project:
/sm:refactor   # Uses project version
/sm:debug      # Uses global version
/sm:audit      # Uses global version
/sm:deploy     # Project-only (via tool invocation)
```

## File Structure

```
smart_mcp/
├── smart_mcp.py       # Main MCP server implementation
├── shortcuts.json     # Shortcut definitions (customize this!)
├── pyproject.toml     # Python project configuration
├── .mcp.json          # Local MCP server configuration
├── README.md          # This file
└── CLAUDE.md          # Project memory contract
```

## Development

### Adding New Shortcuts

1. Edit `shortcuts.json`
2. Add your shortcut with `description` and `instruction` fields
3. Save the file
4. Restart Claude Desktop (if already loaded)

### Testing Shortcuts

After adding a shortcut, test it in Claude:

```
You: "What shortcuts are available in the sm tool?"
[Claude will list all shortcuts from shortcuts.json]

You: "Use the sm tool with shortcut 'your-new-shortcut'"
```

## Troubleshooting

**MCP server not loading:**
- Verify Python 3.10+ is installed: `python3 --version`
- Check MCP SDK is installed: `pip show mcp`
- Verify file paths in configuration are absolute paths
- Check Claude Desktop logs for errors

**Shortcut not found:**
- Verify shortcut name matches exactly (case-sensitive)
- Check `shortcuts.json` is valid JSON (use `python3 -m json.tool shortcuts.json`)
- Restart Claude Desktop after editing shortcuts

**Tool not appearing:**
- Restart Claude Desktop completely
- Verify `.mcp.json` or global config has correct configuration
- Check server name is "smart-mcp" in config

## Future Enhancements

Potential additions (keeping it dead simple):

- ✅ ~~Variable substitution: `{file}`, `{project}` placeholders~~ (implemented!)
- Shortcut categories/tags for organization
- Import/export shortcut collections
- Shortcut validation and testing
- Multiple variable support: `{task}`, `{file}`, `{context}` in same shortcut

## License

MIT License - Use freely for personal or commercial projects.

## Contributing

This is a personal productivity tool. Fork and customize for your needs!
