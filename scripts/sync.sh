#!/bin/bash
# Smart MCP Sync Script
# Bidirectional sync between ~/.claude/ and global/ with conflict detection

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
GLOBAL_DIR="$REPO_ROOT/global"
CLAUDE_DIR="$HOME/.claude"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
DIRECTION=""
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --to-global)
            DIRECTION="to-global"
            shift
            ;;
        --to-claude)
            DIRECTION="to-claude"
            shift
            ;;
        --force|-f)
            FORCE=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Smart MCP Sync Script"
            echo ""
            echo "Usage: $0 [DIRECTION] [OPTIONS]"
            echo ""
            echo "Direction:"
            echo "  --to-global       Sync from ~/.claude/ to global/ (backup)"
            echo "  --to-claude       Sync from global/ to ~/.claude/ (install)"
            echo ""
            echo "Options:"
            echo "  --force, -f       Overwrite conflicts without prompting"
            echo "  --dry-run, -n     Show what would be synced without making changes"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "If no direction is specified, the script will detect conflicts"
            echo "and prompt you to choose the sync direction."
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Smart MCP Sync${NC}"
echo "=============="
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

# Function to compare and sync a file
sync_file() {
    local source=$1
    local target=$2
    local filename=$3
    local direction=$4

    if [ ! -f "$source" ]; then
        return
    fi

    if [ ! -f "$target" ]; then
        # Target doesn't exist, just copy
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$(dirname "$target")"
            cp "$source" "$target"
            echo -e "${GREEN}✓${NC} $direction: $filename (new file)"
        else
            echo -e "${BLUE}[DRY RUN]${NC} Would sync $direction: $filename (new file)"
        fi
    elif ! diff -q "$source" "$target" > /dev/null 2>&1; then
        # Files differ - conflict!
        if [ "$FORCE" = true ]; then
            if [ "$DRY_RUN" = false ]; then
                cp "$source" "$target"
                echo -e "${GREEN}✓${NC} $direction: $filename (overwritten)"
            else
                echo -e "${BLUE}[DRY RUN]${NC} Would sync $direction: $filename (overwritten)"
            fi
        else
            echo -e "${YELLOW}⚠${NC}  CONFLICT: $filename has changes in both locations"
            return 1
        fi
    fi
    return 0
}

# Detect conflicts if no direction specified
if [ -z "$DIRECTION" ]; then
    echo "Checking for conflicts..."
    echo ""

    CONFLICTS=false

    # Check command files
    if [ -d "$CLAUDE_DIR/commands/sm" ] && [ -d "$GLOBAL_DIR/commands/sm" ]; then
        for cmd_file in "$CLAUDE_DIR/commands/sm"/*.md; do
            if [ -f "$cmd_file" ]; then
                filename=$(basename "$cmd_file")
                global_file="$GLOBAL_DIR/commands/sm/$filename"

                if [ -f "$global_file" ] && ! diff -q "$cmd_file" "$global_file" > /dev/null 2>&1; then
                    CONFLICTS=true
                    echo -e "${YELLOW}⚠${NC}  Conflict detected: $filename"
                fi
            fi
        done
    fi

    # Check shortcuts.json
    if [ -f "$CLAUDE_DIR/smart_mcp/shortcuts.json" ] && [ -f "$GLOBAL_DIR/smart_mcp/shortcuts.json" ]; then
        if ! diff -q "$CLAUDE_DIR/smart_mcp/shortcuts.json" "$GLOBAL_DIR/smart_mcp/shortcuts.json" > /dev/null 2>&1; then
            CONFLICTS=true
            echo -e "${YELLOW}⚠${NC}  Conflict detected: shortcuts.json"
        fi
    fi

    # Check MCP docs
    if [ -f "$CLAUDE_DIR/MCP_SmartMCP.md" ] && [ -f "$GLOBAL_DIR/MCP_SmartMCP.md" ]; then
        if ! diff -q "$CLAUDE_DIR/MCP_SmartMCP.md" "$GLOBAL_DIR/MCP_SmartMCP.md" > /dev/null 2>&1; then
            CONFLICTS=true
            echo -e "${YELLOW}⚠${NC}  Conflict detected: MCP_SmartMCP.md"
        fi
    fi

    if [ "$CONFLICTS" = true ]; then
        echo ""
        echo -e "${RED}Conflicts detected!${NC}"
        echo ""
        echo "Please specify sync direction:"
        echo "  $0 --to-global   (use ~/.claude/ version)"
        echo "  $0 --to-claude   (use global/ version)"
        echo ""
        echo "Or use --force to overwrite in the specified direction"
        exit 1
    else
        echo -e "${GREEN}No conflicts detected.${NC}"
        echo "Files are in sync."
        exit 0
    fi
fi

# Perform sync based on direction
if [ "$DIRECTION" = "to-global" ]; then
    echo "Syncing: ~/.claude/ → global/"
    echo ""

    # Sync command files
    if [ -d "$CLAUDE_DIR/commands/sm" ]; then
        mkdir -p "$GLOBAL_DIR/commands/sm"
        for cmd_file in "$CLAUDE_DIR/commands/sm"/*.md; do
            if [ -f "$cmd_file" ]; then
                filename=$(basename "$cmd_file")
                sync_file "$cmd_file" "$GLOBAL_DIR/commands/sm/$filename" "$filename" "→ global"
            fi
        done
    fi

    # Sync shortcuts.json
    if [ -f "$CLAUDE_DIR/smart_mcp/shortcuts.json" ]; then
        mkdir -p "$GLOBAL_DIR/smart_mcp"
        sync_file "$CLAUDE_DIR/smart_mcp/shortcuts.json" "$GLOBAL_DIR/smart_mcp/shortcuts.json" "shortcuts.json" "→ global"
    fi

    # Sync MCP docs
    if [ -f "$CLAUDE_DIR/MCP_SmartMCP.md" ]; then
        sync_file "$CLAUDE_DIR/MCP_SmartMCP.md" "$GLOBAL_DIR/MCP_SmartMCP.md" "MCP_SmartMCP.md" "→ global"
    fi

elif [ "$DIRECTION" = "to-claude" ]; then
    echo "Syncing: global/ → ~/.claude/"
    echo ""

    # Sync command files
    if [ -d "$GLOBAL_DIR/commands/sm" ]; then
        mkdir -p "$CLAUDE_DIR/commands/sm"
        for cmd_file in "$GLOBAL_DIR/commands/sm"/*.md; do
            if [ -f "$cmd_file" ]; then
                filename=$(basename "$cmd_file")
                sync_file "$cmd_file" "$CLAUDE_DIR/commands/sm/$filename" "$filename" "→ ~/.claude"
            fi
        done
    fi

    # Sync shortcuts.json
    if [ -f "$GLOBAL_DIR/smart_mcp/shortcuts.json" ]; then
        mkdir -p "$CLAUDE_DIR/smart_mcp"
        sync_file "$GLOBAL_DIR/smart_mcp/shortcuts.json" "$CLAUDE_DIR/smart_mcp/shortcuts.json" "shortcuts.json" "→ ~/.claude"
    fi

    # Sync MCP docs
    if [ -f "$GLOBAL_DIR/MCP_SmartMCP.md" ]; then
        sync_file "$GLOBAL_DIR/MCP_SmartMCP.md" "$CLAUDE_DIR/MCP_SmartMCP.md" "MCP_SmartMCP.md" "→ ~/.claude"
    fi
fi

echo ""
echo -e "${GREEN}Sync complete!${NC}"
