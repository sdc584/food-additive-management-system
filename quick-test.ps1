Write-Host "Testing backends..." -ForegroundColor Cyan

try {
    $r1 = Invoke-WebRequest -Uri "http://localhost:8081/api/user/foodAdditives" -Method GET -TimeoutSec 3
    Write-Host "User-backend (8081): RUNNING" -ForegroundColor Green
} catch {
    Write-Host "User-backend (8081): NOT RUNNING" -ForegroundColor Red
}

try {
    $r2 = Invoke-WebRequest -Uri "http://localhost:8082/api/admin/foodAdditives" -Method GET -TimeoutSec 3
    Write-Host "Admin-backend (8082): RUNNING" -ForegroundColor Green
} catch {
    Write-Host "Admin-backend (8082): NOT RUNNING" -ForegroundColor Red
}

