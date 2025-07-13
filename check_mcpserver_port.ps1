# Check MCPSERVER instance port configuration

Write-Host "=== Checking MCPSERVER Port Configuration ===" -ForegroundColor Green

# Method 1: Check SQL Server Browser for named instance port
Write-Host "`n1. Checking SQL Server Browser for MCPSERVER port..." -ForegroundColor Yellow
try {
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect("127.0.0.1", 1434)
    $request = [System.Text.Encoding]::ASCII.GetBytes([char]0x02)
    $udpClient.Send($request, $request.Length) | Out-Null
    $udpClient.Client.ReceiveTimeout = 5000
    $endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
    $response = $udpClient.Receive([ref]$endpoint)
    $responseText = [System.Text.Encoding]::ASCII.GetString($response)
    
    if ($responseText -match "MCPSERVER.*?tcp,(\d+)") {
        $port = $matches[1]
        Write-Host "   Found MCPSERVER on port: $port" -ForegroundColor Green
    } else {
        Write-Host "   MCPSERVER not found in browser response" -ForegroundColor Yellow
        Write-Host "   Full response: $responseText" -ForegroundColor Cyan
    }
    $udpClient.Close()
} catch {
    Write-Host "   SQL Browser query failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 2: Check registry for port configuration
Write-Host "`n2. Checking registry for MCPSERVER port..." -ForegroundColor Yellow
try {
    $tcpPort = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" -Name "TcpPort" -ErrorAction SilentlyContinue
    $dynamicPort = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" -Name "TcpDynamicPorts" -ErrorAction SilentlyContinue
    
    if ($tcpPort -and $tcpPort.TcpPort) {
        Write-Host "   Static TCP Port: $($tcpPort.TcpPort)" -ForegroundColor Green
    }
    if ($dynamicPort -and $dynamicPort.TcpDynamicPorts) {
        Write-Host "   Dynamic TCP Port: $($dynamicPort.TcpDynamicPorts)" -ForegroundColor Green
    }
    if ((-not $tcpPort -or -not $tcpPort.TcpPort) -and (-not $dynamicPort -or -not $dynamicPort.TcpDynamicPorts)) {
        Write-Host "   No port information found in registry" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Registry check failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 3: Check which ports SQL Server is listening on
Write-Host "`n3. Checking active SQL Server connections..." -ForegroundColor Yellow
try {
    $sqlPorts = Get-NetTCPConnection -State Listen | Where-Object {$_.OwningProcess -in (Get-Process -Name "sqlservr" -ErrorAction SilentlyContinue).Id} | Select-Object LocalPort -Unique
    if ($sqlPorts) {
        Write-Host "   SQL Server is listening on ports:" -ForegroundColor Green
        $sqlPorts | ForEach-Object { Write-Host "     Port: $($_.LocalPort)" -ForegroundColor Cyan }
    } else {
        Write-Host "   No SQL Server listening ports found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Network connection check failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 4: Check SQL Server Configuration Manager info (if available)
Write-Host "`n4. Recommended connection strings to try:" -ForegroundColor Yellow
Write-Host "   For named instance with dynamic port:" -ForegroundColor Cyan
Write-Host "     MSSQL_SERVER=DESKTOP-6D3SN7U\MCPSERVER" -ForegroundColor White
Write-Host "     MSSQL_PORT=  # Leave empty or remove this line" -ForegroundColor White
Write-Host ""
Write-Host "   Alternative server names to try:" -ForegroundColor Cyan
Write-Host "     .\MCPSERVER" -ForegroundColor White
Write-Host "     localhost\MCPSERVER" -ForegroundColor White
Write-Host "     127.0.0.1\MCPSERVER" -ForegroundColor White