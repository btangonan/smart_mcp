# Smart MCP

SuperClaude-style global MCP framework for custom instruction shortcuts. Create reusable command shortcuts that work from ANY directory.

## What is Smart MCP?

Smart MCP is a Model Context Protocol (MCP) server that provides:

1. **Slash Commands** - Global `/sm:*` commands accessible from any directory
2. **Smart Tool** - `sm` MCP tool for executing custom instruction shortcuts
3. **Hierarchical Configuration** - Global defaults with project-specific overrides

## Current Implementation

| Component | Status | Lines | Description |
|-----------|--------|-------|-------------|
| **MCP Server** | ✅ Production | ~100 | Python server with hierarchical shortcuts loading |
| **/sm:refactor** | ✅ Ready | 183 lines | Surgical refactoring with golden-master testing |
| **/sm:debug** | ✅ Ready | 129 lines | 7-step systematic debugging process |
| **/sm:audit** | ✅ Ready | 204 lines | 8-stage repository assessment |
| **/sm:introspect** | ✅ Ready | 247 lines | Meta-cognitive solution analysis |

**Latest Update**: Fixed /sm:introspect synchronization bug - all 4 commands now fully global (2025-11-06)

## Features

- **Global Architecture**: Works from any directory once configured
- **Hierarchical Shortcuts**: Global defaults + project-specific overrides
- **Single Tool Interface**: All shortcuts accessible via one `sm` tool
- **Slash Commands**: `/sm:refactor`, `/sm:debug`, `/sm:audit`, `/sm:introspect` work everywhere
- **JSON-Based Storage**: Easy to read and edit shortcut definitions
- **Variable Substitution**: Use `{task}`, `{file}`, `{context}`, or `{target}` placeholders
- **Extensible**: Add global or project-specific shortcuts

## Architecture

### Dual-Interface System

Smart MCP uses a **two-stage architecture** combining Claude Code slash commands with an MCP server:

```
┌─────────────────────────────────────────────┐
│ Stage 1: Slash Commands (.md files)         │
│ Location: ~/.claude/commands/sm/*.md       │
│ Purpose: Discovery, documentation, metadata │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│ Stage 2: MCP Server (shortcuts.json)        │
│ Location: ~/.claude/smart_mcp/shortcuts.json│
│ Purpose: Instruction storage, variables     │
└─────────────────────────────────────────────┘
```

### File Structure

```
~/.claude/                           # Global SuperClaude configuration
├── smart_mcp/
│   └── shortcuts.json              # Global instruction storage (REQUIRED)
├── commands/sm/
│   ├── refactor.md                 # /sm:refactor interface (REQUIRED)
│   ├── debug.md                    # /sm:debug interface (REQUIRED)
│   ├── audit.md                    # /sm:audit interface (REQUIRED)
│   └── introspect.md               # /sm:introspect interface (REQUIRED)
├── MCP_SmartMCP.md                 # Integration documentation
└── CLAUDE.md                       # Global working contract

Project (Optional Override):
$CWD/shortcuts.json                 # Project-specific shortcuts
```

### Synchronization Requirement

**CRITICAL**: Both components must be deployed together:
- ✅ `.md file` in `~/.claude/commands/sm/` (interface)
- ✅ Entry in `~/.claude/smart_mcp/shortcuts.json` (implementation)

Missing either component will cause the command to fail.

**Merge Strategy**: Project-local shortcuts override global (like .gitignore)

## Quick Start

### Installation

1. **Install the MCP server**:
```bash
git clone https://github.com/btangonan/smart_mcp.git
cd smart_mcp
./scripts/install.sh
```

2. **Configure Claude Desktop**:
```json
{
  "mcpServers": {
    "smart-mcp": {
      "type": "stdio",
      "command": "python3",
      "args": ["/absolute/path/to/smart_mcp/smart_mcp.py"],
      "env": {}
    }
  }
}
```

3. **Restart Claude Desktop**

### Usage

#### Slash Commands (Global)
```
/sm:refactor auth.ts           # Surgical refactoring with testing
/sm:debug login-error          # 7-step debugging process
/sm:audit                      # Repository assessment
/sm:introspect                 # Meta-cognitive analysis
```

#### Smart Tool (Via MCP)
```javascript
// In Claude Code conversations
sm { "shortcut": "refactor", "context": "auth.ts" }
sm { "shortcut": "debug", "context": "login-error" }
```

## Available Commands

### /sm:refactor
**Purpose**: Surgical refactoring with golden-master testing and fitness functions

**Use When**:
- Need to improve code quality without changing behavior
- Want systematic refactoring with safety validation
- Reducing technical debt methodically

**Key Features**:
- Pre/post behavior capture for safety
- Fitness functions for quality metrics
- Incremental improvements with validation

### /sm:debug
**Purpose**: 7-step systematic debugging process

**Use When**:
- Facing complex bugs or unexpected behavior
- Need structured approach to problem-solving
- Want to avoid debugging anti-patterns

**Key Features**:
- Evidence-based hypothesis generation
- Systematic root cause analysis
- Solution validation framework

### /sm:audit
**Purpose**: 8-stage comprehensive repository assessment

**Use When**:
- Need to assess codebase health
- Preparing for technical debt reduction
- Evaluating project maturity

**Key Features**:
- LOC discipline analysis
- Validation coverage assessment
- Secrets hygiene scanning
- Maturity scoring (0-3 scale)

### /sm:introspect
**Purpose**: Meta-cognitive analysis for solution soundness evaluation

**Use When**:
- Unsure if solving the RIGHT problem
- Need to validate approach before implementation
- Want to detect cognitive biases

**Key Features**:
- Naive-agent perspective reset
- Alternative hypothesis generation (min 3)
- Cognitive bias detection
- Soundness scoring with recommendations

## Configuration

### Global Shortcuts

Located at `~/.claude/smart_mcp/shortcuts.json`:

```json
{
  "shortcuts": {
    "refactor": {
      "description": "Surgical refactoring with golden-master testing",
      "instruction": "..."
    },
    "debug": {
      "description": "7-step debugging process",
      "instruction": "..."
    },
    "audit": {
      "description": "Repository assessment",
      "instruction": "..."
    },
    "introspect": {
      "description": "Meta-cognitive analysis",
      "instruction": "..."
    }
  }
}
```

### Project-Specific Shortcuts

Create `shortcuts.json` in your project directory:

```json
{
  "shortcuts": {
    "deploy": {
      "description": "Deploy to staging",
      "instruction": "Deploy {target} to staging environment with pre-flight checks"
    },
    "refactor": {
      "description": "Custom refactor for this project",
      "instruction": "Project-specific refactoring rules..."
    }
  }
}
```

**Merge Behavior**:
- `deploy` - Available only in this project (new shortcut)
- `refactor` - Uses project version (overrides global)
- `debug`, `audit`, `introspect` - Use global versions (no override)

## Management Scripts

### Backup Global Files
```bash
./scripts/backup.sh              # Copy ~/.claude/ → global/
./scripts/backup.sh --commit     # Backup and auto-commit
./scripts/backup.sh --dry-run    # Preview changes
```

### Install Global Files
```bash
./scripts/install.sh             # Copy global/ → ~/.claude/
./scripts/install.sh --force     # Overwrite without prompt
./scripts/install.sh --dry-run   # Preview installation
```

### Sync and Check Status
```bash
./scripts/sync.sh                # Check sync status
./scripts/sync.sh --to-global    # Force ~/.claude/ → global/
./scripts/sync.sh --to-claude    # Force global/ → ~/.claude/
```

## Documentation

- **[FOR_FUTURE_CLAUDE.md](docs/FOR_FUTURE_CLAUDE.md)** - Complete system overview for new agents
- **[GLOBAL_SETUP.md](docs/GLOBAL_SETUP.md)** - Detailed installation and setup guide
- **[IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Technical architecture details

## Troubleshooting

### Slash commands not appearing

**Problem**: `/sm:refactor` shows "command not found"

**Solution**:
```bash
# Verify files exist
ls ~/.claude/commands/sm/

# Should show: audit.md, debug.md, introspect.md, refactor.md
# If missing, run: ./scripts/install.sh
```

### MCP tool not available

**Problem**: `sm` tool returns "No such tool available"

**Solution**:
1. Check Claude Desktop config has correct absolute path to `smart_mcp.py`
2. Restart Claude Desktop completely
3. Start new Claude Code session
4. If still failing, check MCP server logs

### Shortcuts not loading

**Problem**: `sm` tool works but returns empty or old shortcuts

**Solution**:
```bash
# Verify shortcuts.json exists
cat ~/.claude/smart_mcp/shortcuts.json

# Check for JSON syntax errors
python3 -m json.tool ~/.claude/smart_mcp/shortcuts.json

# If corrupted, restore from repo
./scripts/install.sh --force
```

### Chroma MCP race condition

**Problem**: First Chroma call fails with "No such tool available"

**Solution**: This is handled automatically by global CLAUDE.md Session Lifecycle rules - waits 2 seconds and retries once. If persists, verify Chroma MCP server is configured in Claude Desktop.

## Development

### Project Structure

```
smart_mcp/
├── smart_mcp.py               # MCP server with hierarchical loading
├── shortcuts.json             # Example/override shortcuts
├── CLAUDE.md                  # Project-specific contract
├── README.md                  # This file
├── .claude/
│   └── commands/sm/           # Reference commands (deprecated)
├── global/                    # Version-controlled global files
│   ├── CLAUDE.md              # Global SuperClaude framework
│   ├── commands/sm/           # Canonical slash commands
│   ├── smart_mcp/shortcuts.json
│   └── MCP_SmartMCP.md
├── scripts/                   # Management scripts
│   ├── install.sh
│   ├── backup.sh
│   └── sync.sh
├── docs/                      # Documentation
└── archive/                   # Obsolete planning documents
```

### Adding New Slash Commands

**IMPORTANT**: Both `.md` file AND `shortcuts.json` entry are required. Missing either breaks the command.

**Step-by-Step Process**:

1. **Create .md file**: `global/commands/sm/commandname.md`
   ```yaml
   ---
   name: commandname
   description: "Brief one-line description"
   category: gitignored
   complexity: basic|intermediate|advanced
   mcp-servers: [sequential, chroma]
   personas: [architect, auditor]
   ---

   # Documentation sections
   # See existing commands for template

   ## Invocation
   This command executes: `Use the sm tool with shortcut='commandname' and context='$ARGS'`
   ```

2. **Add to shortcuts.json**: `global/smart_mcp/shortcuts.json`
   ```json
   {
     "shortcuts": {
       "commandname": {
         "description": "Same as .md description",
         "instruction": "Full instruction framework with {task} {context} placeholders"
       }
     }
   }
   ```

3. **Deploy**: `./scripts/install.sh` (copies to ~/.claude/)

4. **Verify**:
   ```bash
   ls ~/.claude/commands/sm/commandname.md
   grep "commandname" ~/.claude/smart_mcp/shortcuts.json

   # CRITICAL: Test from outside repo to verify global deployment
   cd /tmp && /sm:commandname test
   ```

5. **Commit**: `./scripts/backup.sh --commit`

**Project-Local Shortcut** (override global):
1. Create `shortcuts.json` in project directory
2. Add shortcuts (same format as global)
3. Project shortcuts override global (hierarchical merge)

### Creating Slash Commands

1. Create markdown file in `~/.claude/commands/sm/`
2. Add YAML frontmatter:
```yaml
---
tags: project, gitignored
---
```
3. Write command instructions
4. Optionally add to shortcuts.json for `sm` tool access

## Benefits

✅ **Global Accessibility** - Commands work from ANY directory
✅ **SuperClaude Integration** - Follows `/sc:*` command pattern
✅ **Hierarchical Config** - Global defaults + project overrides
✅ **Version Controlled** - Global files backed up in repo
✅ **Zero Duplication** - No copying commands to every project
✅ **Extensible** - Easy to add custom shortcuts
✅ **Maintainable** - Clear separation of global vs project config

## Limitations

1. **Absolute Paths Required** - Claude Desktop config needs absolute path to `smart_mcp.py`
2. **Restart Required** - Claude Desktop restart needed for config/shortcut changes
3. **JSON Validation** - Invalid JSON in shortcuts.json fails silently
4. **No Hot Reload** - Shortcut changes require new Claude Code session

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test with `./scripts/install.sh --dry-run`
5. Backup and commit: `./scripts/backup.sh --commit`
6. Submit pull request

## License

MIT License - See LICENSE file for details

## Credits

Built with the SuperClaude framework pattern for global Claude Code configuration.

## Changelog

### 2025-10-23
- Added Chroma MCP race condition fix to global CLAUDE.md
- Cleaned up documentation structure
- Archived obsolete planning documents
- Updated README to reflect actual implementation

### 2025-10-19
- Added `/sm:introspect` command for meta-cognitive analysis
- Enhanced global file management with backup/sync scripts

### 2025-10-17
- Transformed to global SuperClaude-style framework
- Implemented hierarchical shortcuts loading
- Created global slash commands (/sm:refactor, /sm:debug, /sm:audit)
- Added comprehensive documentation

### 2025-10-16
- Initial project creation
- Basic MCP server implementation
- Project-local slash commands
