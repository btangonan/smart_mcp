# State & Persistence Map

## Data Flow
**MCP Tool Call** → **Load shortcuts.json** → **Return instruction text**

## Persistence
- **shortcuts.json** - Static file read on each tool call (file I/O)
- No databases
- No object stores
- No caching layers

## State Analysis
✅ **No cross-request state** - Stateless MCP server
✅ **No in-memory caches** - Loads shortcuts.json on each request
✅ **Read-only operations** - No writes, no mutations
✅ **Functional pattern** - Pure read operations

## Idempotency
✅ **Fully idempotent** - Same input always produces same output
✅ **No side effects** - Read-only file operations

## Notes
Excellent state management. The server is completely stateless:
- Reads shortcuts.json on each `sm` tool call via `load_shortcuts()`
- No cross-request memory
- No persistent connections
- No state mutations
