# API Test Script
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  API Testing" -ForegroundColor Cyan
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
            Write-Host "    OK" -ForegroundColor Green
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

# User Backend Tests
Write-Host "User Backend (8081)" -ForegroundColor Magenta
Write-Host ""

$userBase = "http://localhost:8081/api/user"

Test-API "Food Additives List" "$userBase/foodAdditives"
Test-API "Food Additive Detail" "$userBase/foodAdditives/1"
Test-API "Categories List" "$userBase/additiveCategories"
Test-API "Category Detail" "$userBase/additiveCategories/1"
Test-API "Inventory List" "$userBase/inventories"
Test-API "Inventory Detail" "$userBase/inventories/1"
Test-API "Suppliers List" "$userBase/suppliers"
Test-API "Supplier Detail" "$userBase/suppliers/1"
Test-API "Purchase Records List" "$userBase/purchaseRecords"
Test-API "Purchase Record Detail" "$userBase/purchaseRecords/1"
Test-API "Usage Records List" "$userBase/usageRecords"
Test-API "Usage Record Detail" "$userBase/usageRecords/1"
Test-API "Test Reports List" "$userBase/testReports"
Test-API "Test Report Detail" "$userBase/testReports/1"
Test-API "Warnings List" "$userBase/warnings"
Test-API "Warning Detail" "$userBase/warnings/1"
Test-API "Operation Logs List" "$userBase/operationLogs"
Test-API "Operation Log Detail" "$userBase/operationLogs/1"

# Admin Backend Tests
Write-Host "Admin Backend (8082)" -ForegroundColor Magenta
Write-Host ""

$adminBase = "http://localhost:8082/api/admin"

Test-API "Food Additives List" "$adminBase/foodAdditives"
Test-API "Food Additive Detail" "$adminBase/foodAdditives/1"
Test-API "Categories List" "$adminBase/additiveCategories"
Test-API "Category Detail" "$adminBase/additiveCategories/1"
Test-API "Inventory List" "$adminBase/inventories"
Test-API "Inventory Detail" "$adminBase/inventories/1"
Test-API "Suppliers List" "$adminBase/suppliers"
Test-API "Supplier Detail" "$adminBase/suppliers/1"
Test-API "Purchase Records List" "$adminBase/purchaseRecords"
Test-API "Purchase Record Detail" "$adminBase/purchaseRecords/1"
Test-API "Usage Records List" "$adminBase/usageRecords"
Test-API "Usage Record Detail" "$adminBase/usageRecords/1"
Test-API "Test Reports List" "$adminBase/testReports"
Test-API "Test Report Detail" "$adminBase/testReports/1"
Test-API "Warnings List" "$adminBase/warnings"
Test-API "Warning Detail" "$adminBase/warnings/1"
Test-API "Operation Logs List" "$adminBase/operationLogs"
Test-API "Operation Log Detail" "$adminBase/operationLogs/1"

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $failedTests" -ForegroundColor Red
Write-Host ""

if ($failedTests -eq 0) {
    Write-Host "All tests passed!" -ForegroundColor Green
} else {
    $rate = [math]::Round(($passedTests / $totalTests) * 100, 2)
    Write-Host "Success rate: $rate%" -ForegroundColor Yellow
}

Write-Host ""

