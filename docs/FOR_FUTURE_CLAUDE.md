# For Future Claude: Smart MCP Quick Start Guide

This document helps a naive Claude agent understand and work with the Smart MCP system.

## What Is Smart MCP?

Smart MCP is a **global command framework** for Claude Code that provides reusable instruction shortcuts accessible from ANY directory. Think of it as custom slash commands (like `/sm:refactor`, `/sm:debug`) that work everywhere.

## Key Concepts

1. **Global Scope**: Commands work from any directory (not project-specific)
2. **Slash Commands**: `/sm:refactor`, `/sm:debug`, `/sm:audit`, `/sm:introspect`
3. **MCP Tool**: Direct tool invocation via `sm tool with shortcut='name' and context='args'`
4. **Version Controlled**: All global files tracked in this repo under `global/`
5. **Sync Scripts**: `install.sh`, `backup.sh`, `sync.sh` manage global files

## File Architecture

```
~/.claude/ (Active System)               smart_mcp/ (This Repo - Source of Truth)
├── commands/sm/                         ├── global/
│   ├── refactor.md    ←────────────────┤   ├── commands/sm/
│   ├── debug.md       ←────────────────┤   │   ├── refactor.md
│   ├── audit.md       ←────────────────┤   │   ├── debug.md
│   └── introspect.md  ←────────────────┤   │   ├── audit.md
├── smart_mcp/                           │   │   └── introspect.md
│   └── shortcuts.json ←────────────────┤   ├── smart_mcp/
└── MCP_SmartMCP.md    ←────────────────┤   │   └── shortcuts.json
                                         │   └── MCP_SmartMCP.md
                                         ├── scripts/
                                         │   ├── install.sh  (repo → ~/.claude/)
                                         │   ├── backup.sh   (~/.claude/ → repo)
                                         │   └── sync.sh     (bidirectional)
                                         ├── smart_mcp.py    (MCP server)
                                         └── shortcuts.json  (project example)
```

**Flow**: `global/` (canonical) → `install.sh` → `~/.claude/` (active) → `backup.sh` → `global/` → git

## Quick Reference

### If User Asks to Create New Slash Command

**CRITICAL**: Both .md file AND shortcuts.json entry REQUIRED. Missing either = broken command.

1. **Create .md file**: `global/commands/sm/newcommand.md`
   ```yaml
   ---
   name: newcommand
   description: "Brief one-liner"
   category: gitignored
   complexity: basic|intermediate|advanced
   mcp-servers: [sequential, chroma]
   personas: [architect, qa-specialist]
   ---
   ```

2. **Standard sections**: Triggers, Usage, Behavioral Flow, MCP Integration, Examples, Boundaries

3. **Add Invocation section**:
   ```
   ## Invocation
   This command executes: `Use the sm tool with shortcut='newcommand' and context='$ARGS'`
   ```

4. **Update shortcuts.json**: `global/smart_mcp/shortcuts.json`
   ```json
   {
     "shortcuts": {
       "newcommand": {
         "description": "Same as .md description",
         "instruction": "Full framework with {task} {context} placeholders"
       }
     }
   }
   ```

5. **Deploy**: `./scripts/install.sh`

6. **VERIFY DEPLOYMENT** (prevents synchronization bugs):
   ```bash
   # Test from outside repo to verify global availability
   cd /tmp
   python3 -c "import json; print('newcommand' in json.load(open('/Users/bradleytangonan/.claude/smart_mcp/shortcuts.json'))['shortcuts'])"
   ```

7. **Backup**: `./scripts/backup.sh --commit`

8. **Restart Claude Desktop** (only if changing MCP server config, not for shortcuts)

### If User Asks About Existing Commands

Query Chroma memory first:
```
mcp__chroma__chroma_query_documents with collection_name="smart_mcp_memory"
```

**Available commands**:
- `/sm:refactor` - Surgical refactoring (148 lines)
- `/sm:debug` - 7-step debugging (105 lines)
- `/sm:audit` - 8-stage repo assessment (200 lines)
- `/sm:introspect` - Meta-cognitive solution soundness (212 lines)

### If User Reports Commands Not Working

**Troubleshooting checklist**:
1. ✓ Check `~/.claude/commands/sm/*.md` exist
2. ✓ Validate `shortcuts.json`: `python3 -m json.tool ~/.claude/smart_mcp/shortcuts.json`
3. ✓ **CRITICAL**: Verify BOTH .md AND shortcuts.json entry exist
   ```bash
   ls ~/.claude/commands/sm/commandname.md
   grep "commandname" ~/.claude/smart_mcp/shortcuts.json
   ```
4. ✓ Test from outside repo: `cd /tmp && /sm:commandname test`
5. ✓ Verify MCP config has **absolute path** to `smart_mcp.py`
6. ✓ Restart Claude Desktop **completely**
7. ✓ Test with `/help` - should show `/sm:*` commands under "gitignored"
8. ✓ Run `./scripts/sync.sh` to check file sync status

**Common Bug**: Command .md exists but shortcuts.json entry missing
- **Symptom**: Works in smart_mcp repo, fails elsewhere
- **Cause**: Project-local shortcuts.json masks missing global entry
- **Fix**: Add to global shortcuts.json + redeploy

### If User Wants to Backup Changes

After editing files in `~/.claude/commands/sm/`:
```bash
./scripts/backup.sh --commit
git push
```

### If User Needs to Install/Restore

On new machine or after corruption:
```bash
git clone https://github.com/btangonan/smart_mcp.git
cd smart_mcp
./scripts/install.sh
# Configure Claude Desktop MCP config
# Restart Claude Desktop
```

## Command Sizing Guidelines

- **SuperClaude /sc:*** commands: ~90-100 lines
- **Smart MCP /sm:*** commands: 150-250 lines (advanced concepts)
- **Pattern**: Trust Claude intelligence, provide framework not tutorials
- **Sections**: YAML + Triggers + Usage + Flow + Integration + Examples + Boundaries

**Example sizes**:
- `/sm:debug`: 105 lines ✅
- `/sm:refactor`: 148 lines ✅
- `/sm:audit`: 200 lines ✅
- `/sm:introspect`: 212 lines ✅ (complex concept)

## Common Mistakes to Avoid

❌ **Don't**: Use colons in filenames (`sm:debug.md`)
✅ **Do**: Use subdirectory structure (`sm/debug.md`)

❌ **Don't**: Use relative paths in MCP config
✅ **Do**: Use absolute paths (`/Users/.../smart_mcp.py`)

❌ **Don't**: Edit both `~/.claude/` and `global/` without syncing
✅ **Do**: Edit one, then sync with scripts

❌ **Don't**: Forget to restart Claude Desktop after changes
✅ **Do**: Always restart after modifying commands or config

❌ **Don't**: Commit without validating JSON syntax
✅ **Do**: Run `python3 -m json.tool shortcuts.json` first

## Project Memory (Chroma)

**Collection**: `smart_mcp_memory`

**Always query before**:
- Creating new commands
- Modifying architecture
- Troubleshooting issues
- Making design decisions

**Add memories after**:
- Major changes (`type: "decision"`)
- Bug fixes (`type: "fix"`)
- Learning lessons (`type: "tip"`)

## Script Reference

| Script | Purpose | Common Flags |
|--------|---------|--------------|
| `install.sh` | Install `global/` → `~/.claude/` | `--force` `--dry-run` |
| `backup.sh` | Backup `~/.claude/` → `global/` | `--commit` `--dry-run` |
| `sync.sh` | Bidirectional sync + conflicts | `--to-global` `--to-claude` `--force` |

All scripts support `--help` for detailed usage.

## MCP Server Config

Location: `~/Library/Application Support/Claude/claude_desktop_config.json`

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

**Critical**: Path must be **absolute**, not relative.

## Testing Installation

After setup, verify:
1. Type `/help` in Claude chat
2. Look for `/sm:refactor`, `/sm:debug`, `/sm:audit`, `/sm:introspect` under "gitignored"
3. Test: `/sm:debug test installation`
4. Should receive 7-step debugging framework

## When Things Break

1. **Query Chroma memory**: `mcp__chroma__chroma_query_documents`
2. **Check file sync**: `./scripts/sync.sh`
3. **Validate JSON**: `python3 -m json.tool shortcuts.json`
4. **Verify paths**: Ensure MCP config has absolute path
5. **Restart Claude**: Complete restart of Claude Desktop app
6. **Check logs**: Claude Desktop logs for MCP errors

## Smart MCP vs SuperClaude

- **Smart MCP**: `/sm:*` prefix, custom shortcut system
- **SuperClaude**: `/sc:*` prefix, workflow commands
- **Both**: Use `category: gitignored` for global scope
- **Both**: Store in `~/.claude/commands/<namespace>/`
- **Compatible**: Can coexist, different namespaces

## Summary

**What Smart MCP Does**:
- Provides global `/sm:*` slash commands
- Works from ANY directory
- Version controls global configuration
- Offers management scripts for sync/backup

**What You Should Do**:
1. Query Chroma memory first (institutional knowledge)
2. Follow command sizing guidelines (150-250 lines)
3. Use standard sections (Triggers, Usage, Flow, etc.)
4. Backup changes with `./scripts/backup.sh --commit`
5. Validate before committing (`python3 -m json.tool`)
6. Test thoroughly after changes

**Key Files**:
- `global/` - Source of truth (version controlled)
- `~/.claude/` - Active system (deployed)
- `scripts/` - Management tools
- `smart_mcp.py` - MCP server
- `CLAUDE.md` - Project contract

**Remember**: This repo IS the Smart MCP system. Everything in `global/` is the canonical version. Use scripts to sync with `~/.claude/`.

---

**Last Updated**: 2025-11-06
**Version**: 1.2.0 (all 4 commands fully global, synchronization bug fixed)
