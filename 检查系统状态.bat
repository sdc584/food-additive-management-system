@echo off
chcp 65001
title 系统状态检查
color 0B

echo.
echo ========================================
echo   食品添加剂管理系统 - 状态检查
echo ========================================
echo.

echo 正在检查端口占用情况...
echo.

echo [用户端后端] 端口 8081:
netstat -ano | findstr ":8081" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo ✅ 用户端后端正在运行
) else (
    echo ❌ 用户端后端未运行
)
echo.

echo [管理端后端] 端口 8082:
netstat -ano | findstr ":8082" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo ✅ 管理端后端正在运行
) else (
    echo ❌ 管理端后端未运行
)
echo.

echo [用户端前端] 端口 8080:
netstat -ano | findstr ":8080" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo ✅ 用户端前端正在运行
) else (
    echo ❌ 用户端前端未运行
)
echo.

echo [管理端前端] 端口 8083:
netstat -ano | findstr ":8083" | findstr "LISTENING"
if %errorlevel% equ 0 (
    echo ✅ 管理端前端正在运行
) else (
    echo ❌ 管理端前端未运行
)
echo.

echo ========================================
echo   检查完成
echo ========================================
echo.
pause

