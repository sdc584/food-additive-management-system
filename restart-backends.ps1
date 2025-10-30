# Restart Backend Services
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Restarting Backend Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Stop existing services
Write-Host "[1/3] Stopping existing services..." -ForegroundColor Yellow
Write-Host ""

$port8081 = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue
if ($port8081) {
    $pid8081 = $port8081.OwningProcess
    Write-Host "Stopping user-backend (PID: $pid8081)" -ForegroundColor Gray
    Stop-Process -Id $pid8081 -Force -ErrorAction SilentlyContinue
}

$port8082 = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue
if ($port8082) {
    $pid8082 = $port8082.OwningProcess
    Write-Host "Stopping admin-backend (PID: $pid8082)" -ForegroundColor Gray
    Stop-Process -Id $pid8082 -Force -ErrorAction SilentlyContinue
}

Write-Host "Waiting 3 seconds..." -ForegroundColor Gray
Start-Sleep -Seconds 3
Write-Host ""

# Step 2: Compile backends
Write-Host "[2/3] Compiling backends..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Compiling user-backend..." -ForegroundColor Gray
Set-Location user-backend
$compileUser = Start-Process -FilePath "mvn" -ArgumentList "clean","compile","-DskipTests" -Wait -PassThru -NoNewWindow
if ($compileUser.ExitCode -ne 0) {
    Write-Host "User-backend compilation failed!" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Set-Location ..
Write-Host "User-backend compiled successfully" -ForegroundColor Green
Write-Host ""

Write-Host "Compiling admin-backend..." -ForegroundColor Gray
Set-Location admin-backend
$compileAdmin = Start-Process -FilePath "mvn" -ArgumentList "clean","compile","-DskipTests" -Wait -PassThru -NoNewWindow
if ($compileAdmin.ExitCode -ne 0) {
    Write-Host "Admin-backend compilation failed!" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Set-Location ..
Write-Host "Admin-backend compiled successfully" -ForegroundColor Green
Write-Host ""

# Step 3: Start services
Write-Host "[3/3] Starting services..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Starting user-backend on port 8081..." -ForegroundColor Gray
Start-Process -FilePath "cmd" -ArgumentList "/c","cd user-backend && mvn spring-boot:run" -WindowStyle Normal

Write-Host "Waiting 5 seconds..." -ForegroundColor Gray
Start-Sleep -Seconds 5

Write-Host "Starting admin-backend on port 8082..." -ForegroundColor Gray
Start-Process -FilePath "cmd" -ArgumentList "/c","cd admin-backend && mvn spring-boot:run" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Services are starting..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please wait 30-60 seconds for services to fully start." -ForegroundColor Yellow
Write-Host ""
Write-Host "User-backend: http://localhost:8081/api/user" -ForegroundColor Green
Write-Host "Admin-backend: http://localhost:8082/api/admin" -ForegroundColor Green
Write-Host ""

