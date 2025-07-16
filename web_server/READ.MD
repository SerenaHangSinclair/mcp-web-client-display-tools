# Better approach for testing MCP servers:

powershell# Install Node.js http-server (one time only)
```bash
npm install -g http-server
```

# Start local web server
```bash
http-server -p 8080
'''

# Opens automatically at http://localhost:8080
Start-Process "http://localhost:8080"
If you don't have Node.js:
powershell# Use Python (if installed)
```bash
python -m http.server 8080
Start-Process "http://localhost:8080"
```bash

# OR use PowerShell only (one-liner)
```bash
Add-Type -AssemblyName System.Net.HttpListener; $l = New-Object System.Net.HttpListener; $l.Prefixes.Add('http://localhost:8080/'); $l.Start(); Start-Process 'http://localhost:8080'; Write-Host "Server running at http://localhost:8080 - Press Ctrl+C to stop" -ForegroundColor Green; while($l.IsListening){$c=$l.GetContext();$r=$c.Response;$content=Get-Content 'mcp-testing-interface.html' -Raw;$b=[Text.Encoding]::UTF8.GetBytes($content);$r.ContentLength64=$b.Length;$r.OutputStream.Write($b,0,$b.Length);$r.OutputStream.Close()}
'''

Complete Setup:

Create the HTML file:
```bash
powershell# Create new file
New-Item "mcp-testing-interface.html" -ItemType File
'''

# Open in notepad to paste the HTML content
```bash
notepad "mcp-testing-interface.html"
'''

Run the server:
powershell# Choose your preferred method from above
```bash
npx http-server -p 8080
'''

Access the interface:

Browser opens automatically at http://localhost:8080
Start adding your MCP servers and testing!
