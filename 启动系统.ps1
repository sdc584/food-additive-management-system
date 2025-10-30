# Food Additive Management System - Startup Script
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop existing services
Write-Host "Stopping old services..." -ForegroundColor Yellow

$ports = @(8081, 8082, 8080, 8083)
foreach ($port in $ports) {
    $conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conn) {
        $pid = $conn.OwningProcess
        Write-Host "  Stopping port $port (PID: $pid)" -ForegroundColor Gray
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    }
}

Start-Sleep -Seconds 2
Write-Host ""

# Start services
Write-Host "Starting services..." -ForegroundColor Yellow
Write-Host ""

Write-Host "[1/4] User Backend (8081)" -ForegroundColor White
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd user-backend && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 1

Write-Host "[2/4] Admin Backend (8082)" -ForegroundColor White
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd admin-backend && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 1

Write-Host "[3/4] User Frontend (8080)" -ForegroundColor White
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd user-frontend && npm run serve" -WindowStyle Normal
Start-Sleep -Seconds 1

Write-Host "[4/4] Admin Frontend (8083)" -ForegroundColor White
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd admin-frontend && npm run serve" -WindowStyle Normal

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Service URLs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  User Frontend:   http://localhost:8080" -ForegroundColor White
Write-Host "  Admin Frontend:  http://localhost:8083" -ForegroundColor White
Write-Host ""
Write-Host "  User Backend:    http://localhost:8081/api/user" -ForegroundColor Gray
Write-Host "  Admin Backend:   http://localhost:8082/api/admin" -ForegroundColor Gray
Write-Host ""
Write-Host "  Account: admin / 123456" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Wait 30-60 seconds for services to start" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to open status check page..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Start-Process "系统状态检查.html"

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""

