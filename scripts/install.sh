#!/bin/bash
# Smart MCP Global Installation Script
# Copies canonical global/ files to ~/.claude/

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
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Smart MCP Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force, -f       Overwrite existing files without prompting"
            echo "  --dry-run, -n     Show what would be installed without making changes"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "This script copies global Smart MCP files from the repo to ~/.claude/"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Smart MCP Global Installation${NC}"
echo "=============================="
echo ""
echo "Source: $GLOBAL_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

# Check if global directory exists
if [ ! -d "$GLOBAL_DIR" ]; then
    echo -e "${RED}Error: global/ directory not found in repo${NC}"
    exit 1
fi

# Create target directories
DIRS=(
    "$CLAUDE_DIR/commands/sm"
    "$CLAUDE_DIR/smart_mcp"
)

for dir in "${DIRS[@]}"; do
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$dir"
        echo -e "${GREEN}✓${NC} Created directory: $dir"
    else
        echo -e "${BLUE}[DRY RUN]${NC} Would create: $dir"
    fi
done

echo ""

# Copy slash commands
echo "Installing slash commands..."
for cmd_file in "$GLOBAL_DIR/commands/sm"/*.md; do
    if [ -f "$cmd_file" ]; then
        filename=$(basename "$cmd_file")
        target="$CLAUDE_DIR/commands/sm/$filename"

        if [ -f "$target" ] && [ "$FORCE" = false ]; then
            echo -e "${YELLOW}⚠${NC}  $filename already exists, skipping (use --force to overwrite)"
        else
            if [ "$DRY_RUN" = false ]; then
                cp "$cmd_file" "$target"
                echo -e "${GREEN}✓${NC} Installed: $filename"
            else
                echo -e "${BLUE}[DRY RUN]${NC} Would install: $filename"
            fi
        fi
    fi
done

echo ""

# Copy shortcuts.json
echo "Installing shortcuts configuration..."
if [ -f "$GLOBAL_DIR/smart_mcp/shortcuts.json" ]; then
    target="$CLAUDE_DIR/smart_mcp/shortcuts.json"

    if [ -f "$target" ] && [ "$FORCE" = false ]; then
        echo -e "${YELLOW}⚠${NC}  shortcuts.json already exists, skipping (use --force to overwrite)"
    else
        if [ "$DRY_RUN" = false ]; then
            cp "$GLOBAL_DIR/smart_mcp/shortcuts.json" "$target"
            echo -e "${GREEN}✓${NC} Installed: shortcuts.json"
        else
            echo -e "${BLUE}[DRY RUN]${NC} Would install: shortcuts.json"
        fi
    fi
fi

echo ""

# Copy MCP documentation
echo "Installing MCP documentation..."
if [ -f "$GLOBAL_DIR/MCP_SmartMCP.md" ]; then
    target="$CLAUDE_DIR/MCP_SmartMCP.md"

    if [ -f "$target" ] && [ "$FORCE" = false ]; then
        echo -e "${YELLOW}⚠${NC}  MCP_SmartMCP.md already exists, skipping (use --force to overwrite)"
    else
        if [ "$DRY_RUN" = false ]; then
            cp "$GLOBAL_DIR/MCP_SmartMCP.md" "$target"
            echo -e "${GREEN}✓${NC} Installed: MCP_SmartMCP.md"
        else
            echo -e "${BLUE}[DRY RUN]${NC} Would install: MCP_SmartMCP.md"
        fi
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Smart MCP global files are now installed in ~/.claude/"
echo ""
echo "Available commands:"
echo "  /sm:refactor   - Surgical refactoring with golden-master testing"
echo "  /sm:debug      - World-class codebase auditor and debugger"
echo "  /sm:audit      - Comprehensive repository self-assessment"
echo "  /sm:introspect - Meta-cognitive solution soundness analysis"
echo ""
echo "Note: You may need to restart Claude Code for changes to take effect."
