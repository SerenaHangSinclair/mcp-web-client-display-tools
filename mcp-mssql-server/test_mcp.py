#!/usr/bin/env python3
"""Test if the MCP server can start properly"""

import sys
import os

# Add current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from mssql import mcp
    print("Successfully imported mcp from mssql module")
    print(f"MCP server name: {mcp.name}")
    print("Starting MCP server...")
    mcp.run()
except Exception as e:
    print(f"Error: {str(e)}")
    import traceback
    traceback.print_exc()