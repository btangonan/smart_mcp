# Smart MCP Infrastructure - Complete Technical Guide

**Last Updated**: 2025-11-06
**Status**: Production Ready

## Overview

Smart MCP implements a **dual-interface architecture** combining Claude Code's native slash commands with a custom MCP server for global instruction framework delivery.

---

## Architecture Components

### 1. Slash Command Interface (.md files)

**Purpose**: User-facing command discovery and documentation

**Location**: `~/.claude/commands/sm/*.md`

**Responsibilities**:
- Command discovery (appears in `/help`)
- Rich documentation with examples
- Metadata (complexity, MCP servers, personas)
- Invocation logic (calls MCP tool)

**Format**:
```yaml
---
name: commandname
description: "Brief description"
category: gitignored          # Global scope
complexity: advanced
mcp-servers: [sequential, chroma]
personas: [architect, auditor]
---

# Command Documentation
[Triggers, Usage, Examples, Boundaries]

## Invocation
This command executes: `Use the sm tool with shortcut='commandname' and context='$ARGS'`
```

**Size Guidelines**: 150-250 lines for advanced concepts

---

### 2. MCP Server Implementation (smart_mcp.py)

**Purpose**: Instruction storage and hierarchical loading

**Location**: `smart_mcp.py` (configured in Claude Desktop)

**Key Functions**:

```python
def load_shortcuts() -> dict:
    """
    Hierarchical loading with merge strategy:
    1. Load global: ~/.claude/smart_mcp/shortcuts.json
    2. Load project: $CWD/shortcuts.json (if exists)
    3. Merge: project.update(global) - project overrides global
    """

@server.call_tool()
async def handle_call_tool(name: str, arguments: dict):
    """
    Tool execution:
    1. Lookup shortcut in merged dict
    2. Get instruction text
    3. Variable substitution: {task}, {context}, {target}, {file}
    4. Return full instruction framework
    """
```

**Performance**:
- JSON load: ~5ms per call
- Variable substitution: ~1ms
- No caching (loads fresh each call)
- Scales to 50-100 shortcuts easily

---

### 3. Instruction Storage (shortcuts.json)

**Purpose**: Store instruction framework text

**Locations**:
- **Global**: `~/.claude/smart_mcp/shortcuts.json` (base defaults)
- **Project**: `$CWD/shortcuts.json` (optional overrides)

**Format**:
```json
{
  "shortcuts": {
    "commandname": {
      "description": "Brief one-liner (matches .md)",
      "instruction": "Full framework text with {placeholders}"
    }
  }
}
```

**Size**:
- Current: 4 shortcuts, ~14KB
- Largest instruction: ~10KB (audit)
- No hard limit, keep under 50KB per instruction

---

## Execution Flow

```
User Action: /sm:debug fix login error
        ↓
┌─────────────────────────────────────────────┐
│ 1. Claude Code Discovery                    │
│ Reads: ~/.claude/commands/sm/debug.md      │
│ Shows: In /help listing                     │
└─────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────┐
│ 2. Claude Reads .md File                    │
│ Sees: "Use sm tool with shortcut='debug'"  │
│ Decides: Call MCP tool                      │
└─────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────┐
│ 3. MCP Tool Call                             │
│ Calls: sm(shortcut="debug", context="...")  │
│ Sends: To smart_mcp.py MCP server          │
└─────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────┐
│ 4. MCP Server Processing                    │
│ Loads: Global + Project shortcuts.json     │
│ Merges: dict.update() - project wins       │
│ Lookups: shortcuts["debug"]                │
│ Substitutes: {task} → "fix login error"    │
└─────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────┐
│ 5. Returns Instruction Framework             │
│ Content: 7-step debugging process          │
│ Claude: Executes framework systematically   │
└─────────────────────────────────────────────┘
```

**Total Latency**: ~10-20ms (dominated by JSON parse)

---

## Synchronization Requirements

### CRITICAL: Both Components Required

For a slash command to work globally, **BOTH** must be deployed:

1. ✅ `.md file` in `~/.claude/commands/sm/commandname.md`
2. ✅ Entry in `~/.claude/smart_mcp/shortcuts.json`

**Missing either component = BROKEN COMMAND**

### Common Bug Pattern

```
Symptom: Command works in repo, fails elsewhere
Root Cause:
- ✅ .md file deployed globally
- ❌ shortcuts.json entry only in project-local
- Hierarchical loading masks bug when working in repo
```

**Prevention**: Always test from outside repo (`cd /tmp && /sm:commandname test`)

---

## File Management Workflow

### Source of Truth

```
smart_mcp/global/              # Canonical version-controlled files
├── commands/sm/*.md           # Command interfaces
└── smart_mcp/shortcuts.json   # Instruction storage
```

### Active System

```
~/.claude/                     # Deployed active files
├── commands/sm/*.md
└── smart_mcp/shortcuts.json
```

### Management Scripts

| Script | Flow | Flags |
|--------|------|-------|
| `install.sh` | `global/` → `~/.claude/` | `--force` `--dry-run` |
| `backup.sh` | `~/.claude/` → `global/` | `--commit` `--dry-run` |
| `sync.sh` | Bidirectional check | `--to-global` `--to-claude` |

### Recommended Workflow

```bash
# After editing global files in ~/.claude/
./scripts/backup.sh --commit    # Saves to repo + commits
git push

# On new machine or restore
./scripts/install.sh            # Deploys global/ → ~/.claude/
```

---

## Hierarchical Override System

### Merge Strategy

```python
# In smart_mcp.py load_shortcuts()
shortcuts = load_from(~/.claude/smart_mcp/shortcuts.json)  # Global base
shortcuts.update(load_from($CWD/shortcuts.json))            # Project override
return shortcuts
```

### Use Cases

**Global**: Framework commands available everywhere
```json
// ~/.claude/smart_mcp/shortcuts.json
{
  "shortcuts": {
    "debug": { "instruction": "7-step framework..." }
  }
}
```

**Project Override**: Custom workflow for specific repo
```json
// $PROJECT/shortcuts.json
{
  "shortcuts": {
    "debug": { "instruction": "Custom 3-step for this project..." },
    "deploy": { "instruction": "Project-specific deployment..." }
  }
}
```

**Result in $PROJECT**:
- `debug` → Custom 3-step (overridden)
- `deploy` → Project-specific (new)
- `refactor`, `audit`, `introspect` → Global defaults

---

## Variable Substitution

### Supported Placeholders

| Placeholder | Usage | Example |
|-------------|-------|---------|
| `{task}` | Main task description | "fix login error" |
| `{context}` | Additional context | "auth.ts" |
| `{target}` | Target file/component | "payment-module" |
| `{file}` | File path | "src/login.js" |

**Implementation**: Simple string replace (no complex templating)

```python
if context:
    instruction = instruction.replace("{task}", context)
    instruction = instruction.replace("{context}", context)
    instruction = instruction.replace("{target}", context)
    instruction = instruction.replace("{file}", context)
```

### Usage in Instruction

```
Your [TASK] is: [{task}]

Analyze the following:
- Context: {context}
- Target: {target}
- File: {file}
```

---

## Troubleshooting Guide

### "Command not found"

**Symptoms**: `/sm:commandname` → "Unknown command"

**Diagnosis**:
```bash
ls ~/.claude/commands/sm/commandname.md    # Should exist
cat ~/.claude/commands/sm/commandname.md | head -10  # Check YAML
```

**Fixes**:
- Missing file → `./scripts/install.sh`
- Wrong category → Set `category: gitignored` in YAML
- No restart → Restart Claude Desktop completely

---

### "Unknown shortcut" Error

**Symptoms**: Command found, but MCP tool returns error

**Diagnosis**:
```bash
cat ~/.claude/smart_mcp/shortcuts.json | python3 -m json.tool
grep "commandname" ~/.claude/smart_mcp/shortcuts.json
```

**Fixes**:
- Missing entry → Add to shortcuts.json + deploy
- JSON syntax error → Validate with `python3 -m json.tool`
- Not deployed → `./scripts/install.sh --force`

---

### Hierarchical Override Not Working

**Symptoms**: Project shortcuts.json ignored

**Diagnosis**:
```bash
pwd                           # Verify in project root
cat shortcuts.json            # Verify file exists
python3 -m json.tool shortcuts.json  # Validate syntax
```

**Fixes**:
- Wrong directory → Must be in directory with shortcuts.json
- JSON error → Fix syntax and retry
- Check MCP server logs for "Loaded shortcuts from" messages

---

### MCP Server Not Responding

**Symptoms**: Tool call hangs or times out

**Diagnosis**:
```bash
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
python3 /absolute/path/to/smart_mcp.py    # Test directly
```

**Fixes**:
- Relative path in config → Use absolute path
- Python errors → Check smart_mcp.py syntax
- Missing dependency → `pip install mcp`

---

## Performance Characteristics

### Current Metrics

```
Component                 Time
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
.md file read             < 1ms (Claude Code native)
shortcuts.json load       ~5ms
Variable substitution     ~1ms
Total MCP call            ~10-20ms
```

### Scaling Limits

| Metric | Current | Tested | Limit |
|--------|---------|--------|-------|
| Shortcuts count | 4 | - | ~100 |
| JSON size | 14KB | - | ~500KB |
| Instruction size | 10KB | - | ~50KB |
| Concurrent calls | N/A | - | Unlimited |

**Bottleneck**: JSON parsing (O(n) where n = file size)

**Optimization**: None needed at current scale

---

## Security Considerations

### Code Injection via Variables

**Risk**: Malicious context could inject prompts
**Mitigation**: Simple string replace (no eval), Claude's defenses apply
**Verdict**: Low risk

### File System Access

**Risk**: User could create malicious project shortcuts.json
**Impact**: Only affects their own session
**Verdict**: Acceptable - user controls environment

### Secrets in Instructions

**Risk**: Accidentally committing credentials
**Mitigation**: Instructions are generic frameworks
**Best Practice**: Never include secrets in shortcuts.json
**Verdict**: Low risk if best practices followed

---

## Extension Patterns

### Future: Conditional Logic

```json
{
  "shortcuts": {
    "debug": {
      "instruction_variants": {
        "urgent": "if {context} contains 'urgent' use fast path",
        "default": "standard 7-step framework"
      }
    }
  }
}
```

### Future: Instruction Composition

```json
{
  "shortcuts": {
    "custom-debug": {
      "extends": "debug",
      "overrides": {
        "step3": "custom analysis..."
      }
    }
  }
}
```

### Future: MCP Resources

Expose shortcuts as MCP resources (not just tools) for discovery by other tools.

---

## Best Practices

### Creating New Commands

1. ✅ Test instruction framework as regular prompt first
2. ✅ Create both .md and shortcuts.json entry
3. ✅ Deploy with `./scripts/install.sh`
4. ✅ **Test from outside repo** (`cd /tmp && /sm:commandname test`)
5. ✅ Commit with `./scripts/backup.sh --commit`
6. ✅ Document in Chroma memory

### Maintaining Synchronization

1. ✅ Always edit global/ files, not ~/.claude/ directly
2. ✅ Deploy changes immediately after editing
3. ✅ Verify both .md and JSON updated together
4. ✅ Test from different directory before committing

### Documentation Standards

1. ✅ Keep .md files 150-250 lines (advanced concepts)
2. ✅ Match description in .md YAML and shortcuts.json
3. ✅ Include: Triggers, Usage, Examples, Boundaries
4. ✅ Add Invocation section pointing to MCP tool

---

## Changelog

### 2025-11-06
- Fixed /sm:introspect synchronization bug
- Added introspect to global shortcuts.json
- All 4 commands now fully global
- Updated documentation with synchronization requirements

### 2025-10-23
- Added Chroma MCP race condition fix
- Cleaned up documentation structure

### 2025-10-19
- Added /sm:introspect command
- Global file management scripts

### 2025-10-17
- Transformed to global SuperClaude pattern
- Hierarchical shortcuts loading
- Initial global slash commands

---

## References

- **README.md**: User-facing quick start guide
- **FOR_FUTURE_CLAUDE.md**: New agent onboarding guide
- **smart_mcp.py**: MCP server implementation
- **Chroma memory**: `smart_mcp_memory` collection
