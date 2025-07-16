#!/usr/bin/env python3
"""Check SQL Server connectivity and configuration"""

import subprocess
import socket
import os
from dotenv import load_dotenv

load_dotenv()

print("=== SQL Server Connection Diagnostics ===\n")

# 1. Check if SQL Server service is running
print("1. Checking SQL Server services...")
try:
    result = subprocess.run(['sc', 'query', 'MSSQLSERVER'], capture_output=True, text=True, shell=True)
    if 'RUNNING' in result.stdout:
        print("✓ SQL Server (MSSQLSERVER) service is running")
    else:
        print("✗ SQL Server (MSSQLSERVER) service is not running")
        print("  Try: Start SQL Server service from Services or SQL Server Configuration Manager")
except:
    print("✗ Could not check SQL Server service status")

# 2. Check SQL Server port
print("\n2. Checking port 1433...")
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(2)
try:
    result = sock.connect_ex(('localhost', 1433))
    if result == 0:
        print("✓ Port 1433 is open")
    else:
        print("✗ Port 1433 is not accessible")
        print("  Possible issues:")
        print("  - SQL Server TCP/IP protocol disabled")
        print("  - SQL Server using different port")
        print("  - Windows Firewall blocking port")
except:
    print("✗ Could not check port 1433")
finally:
    sock.close()

# 3. Try alternative server names
print("\n3. Testing alternative server names...")
server_names = [
    'localhost',
    '127.0.0.1',
    '.',
    '(local)',
    os.environ.get('COMPUTERNAME', 'UNKNOWN'),
    'localhost\\SQLEXPRESS',  # Common SQL Express instance
    '.\\SQLEXPRESS'
]

print("Possible server names to try:")
for name in server_names:
    print(f"  - {name}")

# 4. Check SQL Server authentication mode
print("\n4. SQL Server Authentication notes:")
print("  - Ensure SQL Server is configured for 'SQL Server and Windows Authentication mode'")
print("  - This can be changed in SQL Server Management Studio:")
print("    Right-click server → Properties → Security → SQL Server and Windows Authentication mode")

# 5. Show current configuration
print("\n5. Current .env configuration:")
print(f"  MSSQL_SERVER: {os.getenv('MSSQL_SERVER', 'localhost')}")
print(f"  MSSQL_PORT: {os.getenv('MSSQL_PORT', '1433')}")
print(f"  MSSQL_USER: {os.getenv('MSSQL_USER', 'sa')}")
print(f"  MSSQL_DATABASE: {os.getenv('MSSQL_DATABASE', 'master')}")

print("\n=== Recommendations ===")
print("1. Open SQL Server Configuration Manager")
print("2. Enable TCP/IP protocol under SQL Server Network Configuration")
print("3. Check the port number in TCP/IP Properties → IP Addresses → IPAll")
print("4. Restart SQL Server service after changes")
print("5. Try using '127.0.0.1' instead of 'localhost' in your .env file")