# MCP Client Demo

A simple Node.js client to connect to MCP servers and display/invoke their tools.

## Installation

```bash
npm install
```

## Usage

1. Make sure your MCP server is properly configured
2. Update the `serverPath` in `client.js` to point to your MCP server
3. Run the client:

To use the Node.js client:
 
```bash
  cd mcp-client-node
  npm install
  npm start
'''



```bash
npm start
```

## Features

- Lists all available tools from the MCP server
- Shows tool descriptions and parameters
- Interactive tool invocation
- Displays results in formatted JSON

## Example Output

```
Starting MCP Client Demo

Connected to MCP server

Found 8 tools:

1. sql_query
    Execute SQL queries with permission controls
   Parameters:
     - query: string (required)
       SQL query to execute

2. get_database_info
 Get server version, current database, and available databases

3. show_tables
    List all tables in the current database
   Parameters:
     - schema_name: string (optional)
       Schema name to filter tables

...
```

## Requirements

- Node.js 16+
- Python environment for running the MCP server
- Properly configured `.env` file for the MCP server
