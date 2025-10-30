@echo off
chcp 65001 >nul
echo ========================================
echo   检查后端服务状态
echo ========================================
echo.

echo 检查端口8081 (用户端后端)...
netstat -ano | findstr ":8081" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo [√] 用户端后端正在运行
) else (
    echo [×] 用户端后端未运行
)

echo.
echo 检查端口8082 (管理端后端)...
netstat -ano | findstr ":8082" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo [√] 管理端后端正在运行
) else (
    echo [×] 管理端后端未运行
)

echo.
echo ========================================
echo   测试API连接
echo ========================================
echo.

echo 测试用户端API...
curl -s http://localhost:8081/api/user/foodAdditives >nul 2>&1
if %errorlevel% equ 0 (
    echo [√] 用户端API可访问
) else (
    echo [×] 用户端API不可访问
)

echo.
echo 测试管理端API...
curl -s http://localhost:8082/api/admin/foodAdditives >nul 2>&1
if %errorlevel% equ 0 (
    echo [√] 管理端API可访问
) else (
    echo [×] 管理端API不可访问
)

echo.
echo ========================================
echo.
pause

