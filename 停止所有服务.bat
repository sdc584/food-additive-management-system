@echo off
chcp 65001 >nul
title 停止所有服务
color 0C

echo.
echo ========================================
echo   停止所有服务
echo ========================================
echo.

set stopped=0

echo 正在查找并停止服务...
echo.

:: 停止端口8081 (用户端后端)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo [√] 停止用户端后端 (端口8081, PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a stopped+=1
)

:: 停止端口8082 (管理端后端)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8082" ^| findstr "LISTENING"') do (
    echo [√] 停止管理端后端 (端口8082, PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a stopped+=1
)

:: 停止端口8080 (用户端前端)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo [√] 停止用户端前端 (端口8080, PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a stopped+=1
)

:: 停止端口8083 (管理端前端)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8083" ^| findstr "LISTENING"') do (
    echo [√] 停止管理端前端 (端口8083, PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a stopped+=1
)

echo.
if %stopped% gtr 0 (
    echo 已停止 %stopped% 个服务
) else (
    echo 没有发现正在运行的服务
)

echo.
echo ========================================
echo.
pause

