# MCP MS SQL Server

A Model Context Protocol (MCP) server for Microsoft SQL Server that provides tools for database operations, data analysis, and visualization generation.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Tools Overview](#tools-overview)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Development](#development)
- [License](#license)

## Features

 **8 Powerful Database Tools** - Query execution, schema exploration, and data analysis  
 **Interactive Visualizations** - Bar charts, scatter plots, heatmaps, and more  
 **Jupyter Notebook Generation** - Automated analysis code creation  
 **Power BI Integration** - Export data in Power BI compatible formats  
 **Security Controls** - Granular permissions for write operations  
 **Connection Pooling** - Optimized performance with configurable pools

## Quick Start

1. **Install the package**
   ```bash
   pip install mcp-mssql-server
   ```

2. **Create configuration**
   ```bash
   # Create .env file
   DB_TYPE=mssql
   MSSQL_SERVER=tcp:your-server.database.windows.net
   MSSQL_USER=your-username
   MSSQL_PASSWORD=your-password
   MSSQL_DATABASE=your-database
   ```

3. **Run the server**
   ```bash
   uv run python mssql.py
   or
   uv run python main.py
   ```

## Installation

### Option 1: Using pip
```bash
pip install mcp-mssql-server
```

### Option 2: Using uv
```bash
uv pip install mcp-mssql-server
```

### Option 3: From source
```bash
git clone https://github.com/SerenaHangSinclair/mcp-mssql-server.git
cd mcp-mssql-server
pip install -e .
```

## Configuration

Create a `.env` file in your project root with the basic required settings:

```bash
# Database Connection (Required)
DB_TYPE=mssql
MSSQL_SERVER=tcp:your-server.database.windows.net
MSSQL_PORT=1433
MSSQL_USER=your-username
MSSQL_PASSWORD=your-password
MSSQL_DATABASE=your-database

# Security (Recommended)
ALLOW_WRITE_OPERATIONS=false
```

<details>
<summary> View complete configuration options</summary>

```bash
# Database Type (mssql)
DB_TYPE=mssql

# SQL Server Configuration
MSSQL_SERVER=tcp:your-server.database.windows.net
MSSQL_PORT=1433
MSSQL_USER=your-username
MSSQL_PASSWORD=your-password
MSSQL_DATABASE=your-database
MSSQL_ENCRYPT=true
MSSQL_TRUST_SERVER_CERTIFICATE=true

# Security Settings
ALLOW_WRITE_OPERATIONS=false
ALLOW_INSERT_OPERATION=false
ALLOW_UPDATE_OPERATION=false
ALLOW_DELETE_OPERATION=false

# Performance Settings
CONNECTION_POOL_MIN=1
CONNECTION_POOL_MAX=10
QUERY_TIMEOUT=30000
```

</details>

## Usage

### Running the MCP Server

suggest to use uv to create a sperate virtual environment for the MCP construction
```bash
    uv venv
'''

**Basic usage:**
```bash
uv run python main.py or uv run python mssql.py 

```

**With logging enabled:**
```bash
uv run python main.py --log
```

### Using with Claude Desktop

Add this configuration to your Claude Desktop settings:

```json
{
  "mcp-mssql-server": {
    "command": "uv",
    "args": ["run", "python", "/path/to/mcp-mssql-server/main.py"]
  }
}
```

## Tools Overview

| Tool | Purpose | Output |
|------|---------|--------|
| **sql_query** | Execute SQL queries with permission controls | Query results |
| **get_database_info** | Get server and database information | Server details |
| **show_tables** | List all tables in the database | Table list |
| **describe_table** | Get detailed table structure information | Column details |
| **show_indexes** | Display table indexes | Index information |
| **generate_analysis_notebook** | Create Jupyter notebooks for data analysis | `.ipynb` file |
| **generate_visualization** | Create interactive visualizations | `.html` file |
| **generate_powerbi_visualization** | Generate Power BI compatible exports | `.csv/.json` files |

<details>
<summary> View detailed tool examples</summary>

### sql_query
Execute any SQL query on the database:
```json
{
  "query": "SELECT TOP 10 * FROM users WHERE status = 'active'"
}
```

### show_tables
List tables, optionally filtered by schema:
```json
{
  "schema": "dbo"
}
```

### describe_table
Get detailed table structure:
```json
{
  "table_name": "users",
  "schema": "dbo"
}
```

### generate_visualization
Create interactive charts from query results:
```json
{
  "query": "SELECT category, SUM(amount) as total FROM sales GROUP BY category",
  "viz_type": "bar",
  "title": "Sales by Category"
}
```

**Supported visualization types:** `auto`, `bar`, `scatter`, `pie`, `line`, `heatmap`, `table`

### generate_analysis_notebook
Create Jupyter notebook with automated analysis:
```json
{
  "query": "SELECT * FROM sales_data WHERE date >= '2024-01-01'",
  "output_file": "sales_analysis.ipynb"
}
```

</details>

## Security

🔒 **Built-in Security Features:**

- **Write operations disabled by default** - All INSERT, UPDATE, DELETE operations are blocked
- **Granular permissions** - Enable specific operations via environment variables
- **Encrypted connections** - Uses TLS encryption by default
- **Credential protection** - Database credentials stored in `.env` file (excluded from git)

**To enable write operations:**
```bash
# Enable specific operations as needed
ALLOW_INSERT_OPERATION=true
ALLOW_UPDATE_OPERATION=true
ALLOW_DELETE_OPERATION=true
```

## Troubleshooting

### Connection Issues

**Problem:** Cannot connect to SQL Server
```bash
#  Check server address format
MSSQL_SERVER=tcp:your-server.database.windows.net  # For Azure SQL

#  Verify firewall settings allow your IP
#  Ensure SQL Server authentication is enabled
#  Double-check credentials in .env file
```

### Permission Errors

**Problem:** Access denied or operation not allowed
```bash
#  Check security settings
ALLOW_WRITE_OPERATIONS=true  # If you need write access

#  Verify database user permissions
#  Ensure user has appropriate SQL Server roles
```

### Visualization Errors

**Problem:** Charts not generating correctly

- Ensure query returns data suitable for the visualization type
- Bar/pie charts need categorical columns
- Scatter/line charts need numeric columns
- Check that query returns at least one row

### Common Error Messages

<details>
<summary>Click to view common errors and solutions</summary>

**Error: "Login failed for user"**
- Check username and password in `.env`
- Verify SQL Server authentication is enabled

**Error: "Cannot open database"**
- Verify database name is correct
- Check user has access to the specified database

**Error: "Connection timeout"**
- Increase `QUERY_TIMEOUT` in `.env`
- Check network connectivity to SQL Server

</details>

## Development

### Extending the Server

**File Structure:**
- `mssql.py` - Database tools implementation
- `main.py` - MCP server interface
- `.env` - Configuration file

**Adding New Tools:**

1. **Create method** in `MSSQLTools` class
2. **Add tool definition** in `list_tools()`
3. **Add handler** in `call_tool()`

### Output Files

The tools generate various output files in your working directory:

- **Jupyter Notebooks:** `.ipynb` files with analysis code
- **Visualizations:** `.html` files with interactive charts  
- **Power BI Data:** `.csv` and `.json` files for import

## License

MIT License - see the [LICENSE](LICENSE) file for details.
