# Stop All Services
Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "  Stopping All Services" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$ports = @(
    @{Port=8081; Name="User Backend"},
    @{Port=8082; Name="Admin Backend"},
    @{Port=8080; Name="User Frontend"},
    @{Port=8083; Name="Admin Frontend"}
)

$stopped = 0

foreach ($service in $ports) {
    $conn = Get-NetTCPConnection -LocalPort $service.Port -ErrorAction SilentlyContinue
    if ($conn) {
        $pid = $conn.OwningProcess
        Write-Host "Stopping $($service.Name) (Port $($service.Port), PID $pid)" -ForegroundColor Yellow
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        $stopped++
    }
}

Write-Host ""
if ($stopped -gt 0) {
    Write-Host "Stopped $stopped service(s)" -ForegroundColor Green
} else {
    Write-Host "No running services found" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

