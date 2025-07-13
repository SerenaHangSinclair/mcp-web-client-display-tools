# SQL Server MCPSERVER Fix Script

Write-Host "=== Starting SQL Server MCPSERVER Fix ===" -ForegroundColor Green

# 1. Check and start SQL Server service
Write-Host "`n1. Checking SQL Server (MCPSERVER) service..." -ForegroundColor Yellow
$service = Get-Service -Name "MSSQL`$MCPSERVER" -ErrorAction SilentlyContinue

if ($service) {
    Write-Host "   Service found: $($service.Name)"
    Write-Host "   Status: $($service.Status)"
    
    if ($service.Status -ne 'Running') {
        Write-Host "   Starting service..." -ForegroundColor Cyan
        Start-Service -Name "MSSQL`$MCPSERVER"
        Start-Sleep -Seconds 5
        $service = Get-Service -Name "MSSQL`$MCPSERVER"
        Write-Host "   New Status: $($service.Status)" -ForegroundColor Green
    } else {
        Write-Host "   Service is already running!" -ForegroundColor Green
    }
} else {
    Write-Host "   ERROR: Service MSSQL`$MCPSERVER not found!" -ForegroundColor Red
    Write-Host "   Looking for other SQL Server services..."
    Get-Service | Where-Object {$_.Name -like '*SQL*'} | Select-Object Name, Status | Format-Table
}

# 2. Check SQL Server Browser service
Write-Host "`n2. Checking SQL Server Browser service..." -ForegroundColor Yellow
$browser = Get-Service -Name "SQLBrowser" -ErrorAction SilentlyContinue
if ($browser) {
    Write-Host "   Browser Status: $($browser.Status)"
    if ($browser.Status -ne 'Running') {
        Write-Host "   Starting SQL Server Browser..." -ForegroundColor Cyan
        Start-Service -Name "SQLBrowser" -ErrorAction SilentlyContinue
    }
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Green
Write-Host "1. Open SQL Server Configuration Manager"
Write-Host "2. Navigate to SQL Server Network Configuration > Protocols for MCPSERVER"
Write-Host "3. Enable TCP/IP protocol"
Write-Host "4. Double-click TCP/IP, go to IP Addresses tab"
Write-Host "5. Scroll to IPAll section and check TCP Port (should be 1433)"
Write-Host "6. Restart SQL Server service after changes"

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")