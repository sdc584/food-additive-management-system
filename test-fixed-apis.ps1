# Test Fixed APIs
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Testing Fixed APIs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$totalTests = 0
$passedTests = 0
$failedTests = 0

function Test-API {
    param(
        [string]$Name,
        [string]$Url
    )
    
    $global:totalTests++
    Write-Host "[$global:totalTests] $Name" -ForegroundColor Yellow
    Write-Host "    $Url" -ForegroundColor Gray
    
    try {
        $response = Invoke-RestMethod -Uri $Url -Method GET -ContentType "application/json" -TimeoutSec 5
        
        if ($response.code -eq 200 -or $response.code -eq 0) {
            Write-Host "    OK - Data count: $($response.data.Count)" -ForegroundColor Green
            $global:passedTests++
        } else {
            Write-Host "    FAIL: $($response.msg)" -ForegroundColor Red
            $global:failedTests++
        }
    } catch {
        Write-Host "    ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $global:failedTests++
    }
    Write-Host ""
}

Write-Host "Testing Fixed Path Mappings (404 -> 200)" -ForegroundColor Magenta
Write-Host ""

# Admin Backend - Fixed paths
$adminBase = "http://localhost:8082/api/admin"

Test-API "Admin - Categories List (FIXED)" "$adminBase/additiveCategories"
Test-API "Admin - Category Detail (FIXED)" "$adminBase/additiveCategories/1"
Test-API "Admin - Inventory List (FIXED)" "$adminBase/inventories"
Test-API "Admin - Inventory Detail (FIXED)" "$adminBase/inventories/1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $failedTests" -ForegroundColor Red
Write-Host ""

if ($failedTests -eq 0) {
    Write-Host "All fixed APIs are working!" -ForegroundColor Green
} else {
    Write-Host "Some APIs still have issues. Need to restart backend." -ForegroundColor Yellow
}

Write-Host ""

