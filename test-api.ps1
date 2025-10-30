# 测试用户端后端接口
Write-Host "========================================" -ForegroundColor Green
Write-Host "测试用户端后端接口" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

try {
    $body = @{
        username = "admin"
        password = "123456"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8081/api/user/auth/login" -Method POST -ContentType "application/json" -Body $body
    
    Write-Host "✓ 用户端登录成功！" -ForegroundColor Green
    Write-Host "返回数据：" -ForegroundColor Yellow
    $response | ConvertTo-Json -Depth 10
    Write-Host ""
} catch {
    Write-Host "✗ 用户端登录失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# 测试管理端后端接口
Write-Host "========================================" -ForegroundColor Green
Write-Host "测试管理端后端接口" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

try {
    $body = @{
        username = "admin"
        password = "123456"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8082/api/admin/auth/login" -Method POST -ContentType "application/json" -Body $body
    
    Write-Host "✓ 管理端登录成功！" -ForegroundColor Green
    Write-Host "返回数据：" -ForegroundColor Yellow
    $response | ConvertTo-Json -Depth 10
    Write-Host ""
} catch {
    Write-Host "✗ 管理端登录失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "测试完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

