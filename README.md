# Smart MCP

Dead simple MCP server for custom instruction shortcuts. Create reusable command shortcuts for Claude using a single tool.

## Features

- **Single Tool Interface**: All shortcuts accessible via one `sm` tool
- **JSON-Based Storage**: Easy to read and edit shortcut definitions
- **Variable Substitution**: Use `{task}`, `{file}`, `{context}`, or `{target}` placeholders
- **Zero Configuration**: Works out of the box with example shortcuts
- **Extensible**: Add your own shortcuts by editing `shortcuts.json`

## Installation

### 1. Install Python MCP SDK

```bash
pip install mcp
```

### 2. Configure Claude Desktop

Add to your Claude Desktop MCP configuration:

**For this project** (already configured in `.mcp.json`):
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

**For global Claude Desktop config** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
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

### 3. Restart Claude Desktop

Restart Claude Desktop for the MCP server to be loaded.

## Usage

### Method 1: Slash Commands (Recommended)

After restarting Claude Code, use slash commands for quick access:

```
/sm:debug fix authentication timeout in login.py
/sm:refactor authentication logic
/sm:audit
```

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
2. **Shortcut Loading**: Reads `shortcuts.json` to populate available shortcuts
3. **Execution**: When invoked, returns the instruction text for the requested shortcut
4. **Claude Processing**: Claude uses the instruction as context for the conversation

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
