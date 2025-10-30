@echo off
chcp 65001
title 重启后端服务
echo ========================================
echo   重启后端服务
echo ========================================
echo.

echo [1/4] 停止现有服务...
echo.
echo 正在查找端口8081和8082的进程...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo 停止用户端后端 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8082" ^| findstr "LISTENING"') do (
    echo 停止管理端后端 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo 等待3秒...
timeout /t 3 /nobreak >nul

echo.
echo [2/4] 编译用户端后端...
cd /d "%~dp0user-backend"
call mvn clean compile -DskipTests
if errorlevel 1 (
    echo 用户端后端编译失败！
    pause
    exit /b 1
)

echo.
echo [3/4] 编译管理端后端...
cd /d "%~dp0admin-backend"
call mvn clean compile -DskipTests
if errorlevel 1 (
    echo 管理端后端编译失败！
    pause
    exit /b 1
)

echo.
echo [4/4] 启动后端服务...
echo.
echo 请在新窗口中运行以下命令启动服务：
echo.
echo   启动用户端后端.bat
echo   启动管理端后端.bat
echo.
echo 或者手动运行：
echo   cd user-backend ^&^& mvn spring-boot:run
echo   cd admin-backend ^&^& mvn spring-boot:run
echo.

pause

