#!/bin/bash
# Smart MCP Backup Script
# Copies ~/.claude/ files back to global/ directory for version control

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
AUTO_COMMIT=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --commit|-c)
            AUTO_COMMIT=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Smart MCP Backup Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --commit, -c      Automatically commit changes after backup"
            echo "  --dry-run, -n     Show what would be backed up without making changes"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "This script copies global Smart MCP files from ~/.claude/ back to the repo"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Smart MCP Backup${NC}"
echo "================"
echo ""
echo "Source: $CLAUDE_DIR"
echo "Target: $GLOBAL_DIR"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}Error: ~/.claude/ directory not found${NC}"
    exit 1
fi

# Create global directories if they don't exist
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$GLOBAL_DIR/commands/sm"
    mkdir -p "$GLOBAL_DIR/smart_mcp"
fi

# Track if any files were changed
CHANGES=false

# Backup slash commands
echo "Backing up slash commands..."
if [ -d "$CLAUDE_DIR/commands/sm" ]; then
    for cmd_file in "$CLAUDE_DIR/commands/sm"/*.md; do
        if [ -f "$cmd_file" ]; then
            filename=$(basename "$cmd_file")
            target="$GLOBAL_DIR/commands/sm/$filename"

            # Check if file has changed
            if [ -f "$target" ]; then
                if ! diff -q "$cmd_file" "$target" > /dev/null 2>&1; then
                    CHANGES=true
                    if [ "$DRY_RUN" = false ]; then
                        cp "$cmd_file" "$target"
                        echo -e "${GREEN}✓${NC} Updated: $filename"
                    else
                        echo -e "${BLUE}[DRY RUN]${NC} Would update: $filename"
                    fi
                else
                    echo -e "  $filename (no changes)"
                fi
            else
                CHANGES=true
                if [ "$DRY_RUN" = false ]; then
                    cp "$cmd_file" "$target"
                    echo -e "${GREEN}✓${NC} Backed up: $filename"
                else
                    echo -e "${BLUE}[DRY RUN]${NC} Would backup: $filename"
                fi
            fi
        fi
    done
else
    echo -e "${YELLOW}⚠${NC}  No slash commands found in ~/.claude/commands/sm/"
fi

echo ""

# Backup shortcuts.json
echo "Backing up shortcuts configuration..."
if [ -f "$CLAUDE_DIR/smart_mcp/shortcuts.json" ]; then
    target="$GLOBAL_DIR/smart_mcp/shortcuts.json"

    if [ -f "$target" ]; then
        if ! diff -q "$CLAUDE_DIR/smart_mcp/shortcuts.json" "$target" > /dev/null 2>&1; then
            CHANGES=true
            if [ "$DRY_RUN" = false ]; then
                cp "$CLAUDE_DIR/smart_mcp/shortcuts.json" "$target"
                echo -e "${GREEN}✓${NC} Updated: shortcuts.json"
            else
                echo -e "${BLUE}[DRY RUN]${NC} Would update: shortcuts.json"
            fi
        else
            echo "  shortcuts.json (no changes)"
        fi
    else
        CHANGES=true
        if [ "$DRY_RUN" = false ]; then
            cp "$CLAUDE_DIR/smart_mcp/shortcuts.json" "$target"
            echo -e "${GREEN}✓${NC} Backed up: shortcuts.json"
        else
            echo -e "${BLUE}[DRY RUN]${NC} Would backup: shortcuts.json"
        fi
    fi
else
    echo -e "${YELLOW}⚠${NC}  shortcuts.json not found in ~/.claude/smart_mcp/"
fi

echo ""

# Backup MCP documentation
echo "Backing up MCP documentation..."
if [ -f "$CLAUDE_DIR/MCP_SmartMCP.md" ]; then
    target="$GLOBAL_DIR/MCP_SmartMCP.md"

    if [ -f "$target" ]; then
        if ! diff -q "$CLAUDE_DIR/MCP_SmartMCP.md" "$target" > /dev/null 2>&1; then
            CHANGES=true
            if [ "$DRY_RUN" = false ]; then
                cp "$CLAUDE_DIR/MCP_SmartMCP.md" "$target"
                echo -e "${GREEN}✓${NC} Updated: MCP_SmartMCP.md"
            else
                echo -e "${BLUE}[DRY RUN]${NC} Would update: MCP_SmartMCP.md"
            fi
        else
            echo "  MCP_SmartMCP.md (no changes)"
        fi
    else
        CHANGES=true
        if [ "$DRY_RUN" = false ]; then
            cp "$CLAUDE_DIR/MCP_SmartMCP.md" "$target"
            echo -e "${GREEN}✓${NC} Backed up: MCP_SmartMCP.md"
        else
            echo -e "${BLUE}[DRY RUN]${NC} Would backup: MCP_SmartMCP.md"
        fi
    fi
else
    echo -e "${YELLOW}⚠${NC}  MCP_SmartMCP.md not found in ~/.claude/"
fi

echo ""

# Show git status
if [ "$CHANGES" = true ] && [ "$DRY_RUN" = false ]; then
    echo -e "${BLUE}Git Status:${NC}"
    cd "$REPO_ROOT"
    git status --short global/

    echo ""

    # Auto-commit if requested
    if [ "$AUTO_COMMIT" = true ]; then
        echo -e "${BLUE}Auto-committing changes...${NC}"
        git add global/
        git commit -m "Backup Smart MCP global files from ~/.claude/

Updated global configuration files with latest changes.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        echo -e "${GREEN}✓${NC} Changes committed"
    else
        echo -e "${YELLOW}Tip:${NC} Use --commit flag to automatically commit changes"
        echo "Or manually run:"
        echo "  git add global/"
        echo "  git commit -m 'Backup Smart MCP global files'"
    fi
else
    echo -e "${GREEN}Backup complete!${NC} No changes detected."
fi
