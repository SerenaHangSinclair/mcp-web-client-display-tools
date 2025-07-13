# Enable TCP/IP for SQL Server MCPSERVER

Write-Host "=== Checking SQL Server TCP/IP Configuration ===" -ForegroundColor Green

# Load SQL Server SMO assemblies
try {
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | Out-Null
} catch {
    Write-Host "SQL Server SMO assemblies not found. Using registry approach..." -ForegroundColor Yellow
}

# Check TCP/IP via registry
Write-Host "`nChecking TCP/IP protocol status via registry..." -ForegroundColor Yellow
$tcpEnabled = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp" -Name "Enabled" -ErrorAction SilentlyContinue

if ($tcpEnabled) {
    if ($tcpEnabled.Enabled -eq 1) {
        Write-Host "TCP/IP is already ENABLED!" -ForegroundColor Green
    } else {
        Write-Host "TCP/IP is DISABLED. Enabling..." -ForegroundColor Yellow
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp" -Name "Enabled" -Value 1
        Write-Host "TCP/IP has been ENABLED!" -ForegroundColor Green
        Write-Host "You need to restart SQL Server service for changes to take effect." -ForegroundColor Yellow
    }
} else {
    Write-Host "Could not find TCP/IP registry key. Please use SQL Server Configuration Manager." -ForegroundColor Red
}

# Check port configuration
Write-Host "`nChecking port configuration..." -ForegroundColor Yellow
$tcpPort = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" -Name "TcpPort" -ErrorAction SilentlyContinue
$tcpDynamicPorts = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MCPSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" -Name "TcpDynamicPorts" -ErrorAction SilentlyContinue

if ($tcpPort) {
    Write-Host "Static TCP Port: $($tcpPort.TcpPort)" -ForegroundColor Cyan
}
if ($tcpDynamicPorts -and $tcpDynamicPorts.TcpDynamicPorts) {
    Write-Host "Dynamic TCP Port: $($tcpDynamicPorts.TcpDynamicPorts)" -ForegroundColor Cyan
}

# Check firewall rule
Write-Host "`nChecking Windows Firewall rules..." -ForegroundColor Yellow
$firewallRule = Get-NetFirewallRule -DisplayName "*SQL*" -ErrorAction SilentlyContinue | Where-Object {$_.Enabled -eq $true}
if ($firewallRule) {
    Write-Host "Found SQL Server firewall rules:" -ForegroundColor Green
    $firewallRule | Select-Object DisplayName, Enabled | Format-Table
} else {
    Write-Host "No SQL Server firewall rules found. Creating one..." -ForegroundColor Yellow
    New-NetFirewallRule -DisplayName "SQL Server (MCPSERVER)" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow -ErrorAction SilentlyContinue
    Write-Host "Firewall rule created for port 1433" -ForegroundColor Green
}

Write-Host "`n=== Summary ===" -ForegroundColor Green
Write-Host "1. If TCP/IP was disabled, restart SQL Server service"
Write-Host "2. Use DESKTOP-6D3SN7U\MCPSERVER as server name"
Write-Host "3. Make sure to use SQL Server Authentication with sa account"