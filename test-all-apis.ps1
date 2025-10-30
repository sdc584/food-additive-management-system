# 食品添加剂管理系统 - API测试脚本
# 测试所有后端API接口

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  食品添加剂管理系统 - API测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 测试结果统计
$totalTests = 0
$passedTests = 0
$failedTests = 0

# 测试函数
function Test-API {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Method = "GET",
        [string]$Body = $null,
        [hashtable]$Headers = @{}
    )
    
    $global:totalTests++
    Write-Host "[$global:totalTests] 测试: $Name" -ForegroundColor Yellow
    Write-Host "    URL: $Url" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ContentType = "application/json"
            Headers = $Headers
            TimeoutSec = 5
        }
        
        if ($Body) {
            $params.Body = $Body
        }
        
        $response = Invoke-RestMethod @params
        
        if ($response.code -eq 200 -or $response.code -eq 0) {
            Write-Host "    ✅ 成功" -ForegroundColor Green
            $global:passedTests++
            return $true
        } else {
            Write-Host "    ❌ 失败: $($response.msg)" -ForegroundColor Red
            $global:failedTests++
            return $false
        }
    } catch {
        Write-Host "    ❌ 错误: $($_.Exception.Message)" -ForegroundColor Red
        $global:failedTests++
        return $false
    }
    Write-Host ""
}

Write-Host "开始测试..." -ForegroundColor Cyan
Write-Host ""

# ========================================
# 用户端API测试 (http://localhost:8081/api/user)
# ========================================
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  用户端API测试 (端口: 8081)" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

$userBaseUrl = "http://localhost:8081/api/user"
$userToken = ""

# 1. 认证接口
Write-Host "【认证接口】" -ForegroundColor Cyan
$loginBody = @{
    username = "admin"
    password = "123456"
} | ConvertTo-Json

$loginResult = Test-API -Name "用户登录" -Url "$userBaseUrl/auth/login" -Method "POST" -Body $loginBody

if ($loginResult) {
    try {
        $loginResponse = Invoke-RestMethod -Uri "$userBaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody
        $userToken = $loginResponse.data.token
        Write-Host "    Token: $userToken" -ForegroundColor Gray
    } catch {}
}

$headers = @{}
if ($userToken) {
    $headers["Authorization"] = "Bearer $userToken"
}

Test-API -Name "获取用户信息" -Url "$userBaseUrl/auth/userInfo" -Headers $headers
Write-Host ""

# 2. 食品添加剂接口
Write-Host "【食品添加剂接口】" -ForegroundColor Cyan
Test-API -Name "查询添加剂列表" -Url "$userBaseUrl/foodAdditives"
Test-API -Name "查询添加剂详情" -Url "$userBaseUrl/foodAdditives/1"
Write-Host ""

# 3. 添加剂分类接口
Write-Host "【添加剂分类接口】" -ForegroundColor Cyan
Test-API -Name "查询分类列表" -Url "$userBaseUrl/additiveCategories"
Test-API -Name "查询分类详情" -Url "$userBaseUrl/additiveCategories/1"
Write-Host ""

# 4. 库存接口
Write-Host "【库存接口】" -ForegroundColor Cyan
Test-API -Name "查询库存列表" -Url "$userBaseUrl/inventories"
Test-API -Name "查询库存详情" -Url "$userBaseUrl/inventories/1"
Write-Host ""

# 5. 供应商接口
Write-Host "【供应商接口】" -ForegroundColor Cyan
Test-API -Name "查询供应商列表" -Url "$userBaseUrl/suppliers"
Test-API -Name "查询供应商详情" -Url "$userBaseUrl/suppliers/1"
Write-Host ""

# 6. 采购记录接口
Write-Host "【采购记录接口】" -ForegroundColor Cyan
Test-API -Name "查询采购记录列表" -Url "$userBaseUrl/purchaseRecords"
Test-API -Name "查询采购记录详情" -Url "$userBaseUrl/purchaseRecords/1"
Write-Host ""

# 7. 使用记录接口
Write-Host "【使用记录接口】" -ForegroundColor Cyan
Test-API -Name "查询使用记录列表" -Url "$userBaseUrl/usageRecords"
Test-API -Name "查询使用记录详情" -Url "$userBaseUrl/usageRecords/1"
Write-Host ""

# 8. 检测报告接口
Write-Host "【检测报告接口】" -ForegroundColor Cyan
Test-API -Name "查询检测报告列表" -Url "$userBaseUrl/testReports"
Test-API -Name "查询检测报告详情" -Url "$userBaseUrl/testReports/1"
Write-Host ""

# 9. 预警接口
Write-Host "【预警接口】" -ForegroundColor Cyan
Test-API -Name "查询预警列表" -Url "$userBaseUrl/warnings"
Test-API -Name "查询预警详情" -Url "$userBaseUrl/warnings/1"
Write-Host ""

# 10. 操作日志接口
Write-Host "【操作日志接口】" -ForegroundColor Cyan
Test-API -Name "查询操作日志列表" -Url "$userBaseUrl/operationLogs"
Test-API -Name "查询操作日志详情" -Url "$userBaseUrl/operationLogs/1"
Write-Host ""

# ========================================
# 管理端API测试 (http://localhost:8082/api/admin)
# ========================================
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  管理端API测试 (端口: 8082)" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

$adminBaseUrl = "http://localhost:8082/api/admin"
$adminToken = ""

# 1. 认证接口
Write-Host "【认证接口】" -ForegroundColor Cyan
$adminLoginResult = Test-API -Name "管理员登录" -Url "$adminBaseUrl/auth/login" -Method "POST" -Body $loginBody

if ($adminLoginResult) {
    try {
        $adminLoginResponse = Invoke-RestMethod -Uri "$adminBaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody
        $adminToken = $adminLoginResponse.data.token
        Write-Host "    Token: $adminToken" -ForegroundColor Gray
    } catch {}
}

$adminHeaders = @{}
if ($adminToken) {
    $adminHeaders["Authorization"] = "Bearer $adminToken"
}

Test-API -Name "获取管理员信息" -Url "$adminBaseUrl/auth/userInfo" -Headers $adminHeaders
Write-Host ""

# 2. 食品添加剂接口 (完整CRUD)
Write-Host "【食品添加剂接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询添加剂列表" -Url "$adminBaseUrl/foodAdditives"
Test-API -Name "查询添加剂详情" -Url "$adminBaseUrl/foodAdditives/1"

$newAdditiveData = @{
    additiveName = "测试添加剂"
    categoryId = 1
    casNumber = "TEST001"
    maxUsage = 100.0
    unit = "g"
    status = 1
}
$newAdditive = $newAdditiveData | ConvertTo-Json

Test-API -Name "新增添加剂" -Url "$adminBaseUrl/foodAdditives" -Method "POST" -Body $newAdditive
Write-Host ""

# 3. 添加剂分类接口
Write-Host "【添加剂分类接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询分类列表" -Url "$adminBaseUrl/additiveCategories"
Test-API -Name "查询分类详情" -Url "$adminBaseUrl/additiveCategories/1"
Write-Host ""

# 4. 库存接口
Write-Host "【库存接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询库存列表" -Url "$adminBaseUrl/inventories"
Test-API -Name "查询库存详情" -Url "$adminBaseUrl/inventories/1"
Write-Host ""

# 5. 供应商接口
Write-Host "【供应商接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询供应商列表" -Url "$adminBaseUrl/suppliers"
Test-API -Name "查询供应商详情" -Url "$adminBaseUrl/suppliers/1"
Write-Host ""

# 6. 采购记录接口
Write-Host "【采购记录接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询采购记录列表" -Url "$adminBaseUrl/purchaseRecords"
Test-API -Name "查询采购记录详情" -Url "$adminBaseUrl/purchaseRecords/1"
Write-Host ""

# 7. 使用记录接口
Write-Host "【使用记录接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询使用记录列表" -Url "$adminBaseUrl/usageRecords"
Test-API -Name "查询使用记录详情" -Url "$adminBaseUrl/usageRecords/1"
Write-Host ""

# 8. 检测报告接口
Write-Host "【检测报告接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询检测报告列表" -Url "$adminBaseUrl/testReports"
Test-API -Name "查询检测报告详情" -Url "$adminBaseUrl/testReports/1"
Write-Host ""

# 9. 预警接口
Write-Host "【预警接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询预警列表" -Url "$adminBaseUrl/warnings"
Test-API -Name "查询预警详情" -Url "$adminBaseUrl/warnings/1"
Write-Host ""

# 10. 操作日志接口
Write-Host "【操作日志接口 - CRUD】" -ForegroundColor Cyan
Test-API -Name "查询操作日志列表" -Url "$adminBaseUrl/operationLogs"
Test-API -Name "查询操作日志详情" -Url "$adminBaseUrl/operationLogs/1"
Write-Host ""

# ========================================
# 测试结果汇总
# ========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  测试结果汇总" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "总测试数: $totalTests" -ForegroundColor White
Write-Host "通过: $passedTests" -ForegroundColor Green
Write-Host "失败: $failedTests" -ForegroundColor Red
Write-Host ""

if ($failedTests -eq 0) {
    Write-Host "🎉 所有API测试通过！" -ForegroundColor Green
} else {
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 2)
    Write-Host "⚠️  成功率: $successRate%" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

