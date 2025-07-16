#!/usr/bin/env python3
"""Test SQL Server connection"""

import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Add current directory to path to import mssql module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from mssql import MSSQLConnection
    
    print("Testing SQL Server connection...")
    print(f"Server: {os.getenv('MSSQL_SERVER', 'localhost')}")
    print(f"Port: {os.getenv('MSSQL_PORT', '1433')}")
    print(f"User: {os.getenv('MSSQL_USER', 'sa')}")
    print(f"Database: {os.getenv('MSSQL_DATABASE', 'master')}")
    
    # Create connection instance
    db_connection = MSSQLConnection()
    
    # Test connection
    with db_connection.get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT @@VERSION AS version, @@SERVERNAME AS server_name")
        result = cursor.fetchone()
        
        print("\nConnection successful!")
        print(f"SQL Server Version: {result['version']}")
        print(f"Server Name: {result['server_name']}")
        
except Exception as e:
    print(f"\nConnection failed: {str(e)}")
    print("\nPlease check your .env file configuration:")
    print("- MSSQL_SERVER (default: localhost)")
    print("- MSSQL_PORT (default: 1433)")
    print("- MSSQL_USER (default: sa)")
    print("- MSSQL_PASSWORD")
    print("- MSSQL_DATABASE (default: master)")