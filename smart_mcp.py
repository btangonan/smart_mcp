#!/usr/bin/env python3
"""
Smart MCP - Dead Simple MCP Server for Custom Shortcuts
Provides reusable instruction shortcuts via a single MCP tool
"""

import json
import sys
from pathlib import Path
from typing import Any

from mcp.server.models import InitializationOptions
import mcp.types as types
from mcp.server import NotificationOptions, Server
import mcp.server.stdio


# Initialize the MCP server
server = Server("smart-mcp")

# Load shortcuts from JSON file
SHORTCUTS_FILE = Path(__file__).parent / "shortcuts.json"


def load_shortcuts() -> dict[str, dict[str, str]]:
    """Load shortcuts from JSON file."""
    try:
        with open(SHORTCUTS_FILE, 'r') as f:
            data = json.load(f)
            return data.get("shortcuts", {})
    except FileNotFoundError:
        print(f"Error: shortcuts.json not found at {SHORTCUTS_FILE}", file=sys.stderr)
        return {}
    except json.JSONDecodeError as e:
        print(f"Error parsing shortcuts.json: {e}", file=sys.stderr)
        return {}


@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    """
    List available tools.
    Returns a single 'sm' tool that handles all shortcuts.
    """
    shortcuts = load_shortcuts()

    # Build description with available shortcuts
    shortcut_list = "\n".join([
        f"- {name}: {info['description']}"
        for name, info in shortcuts.items()
    ])

    return [
        types.Tool(
            name="sm",
            description=f"""Smart MCP shortcut tool. Execute predefined instruction shortcuts.

Available shortcuts:
{shortcut_list}

Usage: Provide the shortcut name and optional context/target.""",
            inputSchema={
                "type": "object",
                "properties": {
                    "shortcut": {
                        "type": "string",
                        "description": f"Shortcut name to execute. Available: {', '.join(shortcuts.keys())}"
                    },
                    "context": {
                        "type": "string",
                        "description": "Optional context or target for the shortcut (e.g., file path, code snippet, specific area to focus on)"
                    }
                },
                "required": ["shortcut"]
            }
        )
    ]


@server.call_tool()
async def handle_call_tool(
    name: str, arguments: dict[str, Any] | None
) -> list[types.TextContent | types.ImageContent | types.EmbeddedResource]:
    """
    Handle tool execution.
    """
    if name != "sm":
        raise ValueError(f"Unknown tool: {name}")

    if not arguments:
        raise ValueError("Missing arguments")

    shortcut_name = arguments.get("shortcut")
    context = arguments.get("context", "")

    if not shortcut_name:
        raise ValueError("Missing required argument: shortcut")

    # Load shortcuts
    shortcuts = load_shortcuts()

    if shortcut_name not in shortcuts:
        available = ", ".join(shortcuts.keys())
        raise ValueError(
            f"Unknown shortcut: '{shortcut_name}'. Available shortcuts: {available}"
        )

    # Get the instruction
    shortcut_info = shortcuts[shortcut_name]
    instruction = shortcut_info["instruction"]

    # Variable substitution support
    # Replace placeholders: {task}, {context}, {target}, {file}
    if context:
        instruction = instruction.replace("{task}", context)
        instruction = instruction.replace("{context}", context)
        instruction = instruction.replace("{target}", context)
        instruction = instruction.replace("{file}", context)

    # Build the response
    response = instruction

    return [types.TextContent(type="text", text=response)]


async def main():
    """Run the server using stdin/stdout streams."""
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="smart-mcp",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
