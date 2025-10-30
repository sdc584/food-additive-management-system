Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Checking Service Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$services = @(
    @{Name="User Backend (8081)"; Url="http://localhost:8081/api/user/foodAdditives"},
    @{Name="Admin Backend (8082)"; Url="http://localhost:8082/api/admin/foodAdditives"},
    @{Name="User Frontend (8080)"; Url="http://localhost:8080"},
    @{Name="Admin Frontend (8083)"; Url="http://localhost:8083"}
)

$running = 0
$total = $services.Count

foreach ($service in $services) {
    Write-Host "$($service.Name): " -NoNewline
    try {
        $response = Invoke-WebRequest -Uri $service.Url -Method GET -TimeoutSec 3 -ErrorAction Stop
        Write-Host "RUNNING" -ForegroundColor Green
        $running++
    } catch {
        Write-Host "NOT RUNNING" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary: $running/$total services running" -ForegroundColor $(if($running -eq $total){"Green"}else{"Yellow"})
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($running -eq $total) {
    Write-Host "All services are running!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now:" -ForegroundColor Cyan
    Write-Host "  1. Open http://localhost:8080 (User Frontend)" -ForegroundColor White
    Write-Host "  2. Open http://localhost:8083 (Admin Frontend)" -ForegroundColor White
    Write-Host "  3. Run test-fixed-apis.html to test APIs" -ForegroundColor White
} else {
    Write-Host "Some services are not running yet." -ForegroundColor Yellow
    Write-Host "Please wait and run this script again." -ForegroundColor Yellow
}

Write-Host ""

