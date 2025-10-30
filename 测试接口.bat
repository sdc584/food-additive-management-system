@echo off
chcp 65001
echo ========================================
echo 测试用户端后端接口
echo ========================================
echo.

echo 1. 测试用户登录接口...
powershell -Command "$body = '{\"username\":\"admin\",\"password\":\"123456\"}'; try { $response = Invoke-RestMethod -Uri 'http://localhost:8081/api/user/auth/login' -Method POST -ContentType 'application/json' -Body $body; Write-Host '登录成功！'; $response | ConvertTo-Json -Depth 10 } catch { Write-Host '登录失败：' $_.Exception.Message }"
echo.

echo 2. 测试管理端登录接口...
powershell -Command "$body = '{\"username\":\"admin\",\"password\":\"123456\"}'; try { $response = Invoke-RestMethod -Uri 'http://localhost:8082/api/admin/auth/login' -Method POST -ContentType 'application/json' -Body $body; Write-Host '登录成功！'; $response | ConvertTo-Json -Depth 10 } catch { Write-Host '登录失败：' $_.Exception.Message }"
echo.

echo ========================================
echo 测试完成
echo ========================================
pause

