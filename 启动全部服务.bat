@echo off
chcp 65001
title 食品添加剂管理系统 - 一键启动
color 0A

echo.
echo ========================================
echo   食品添加剂管理系统 - 一键启动
echo ========================================
echo.
echo 正在启动所有服务...
echo.

:: 启动用户端后端
echo [1/4] 启动用户端后端 (端口: 8081)...
start "用户端后端" cmd /k "cd /d %~dp0user-backend && mvn spring-boot:run"
timeout /t 3 /nobreak >nul

:: 启动管理端后端
echo [2/4] 启动管理端后端 (端口: 8082)...
start "管理端后端" cmd /k "cd /d %~dp0admin-backend && mvn spring-boot:run"
timeout /t 3 /nobreak >nul

:: 启动用户端前端
echo [3/4] 启动用户端前端 (端口: 8080)...
start "用户端前端" cmd /k "cd /d %~dp0user-frontend && npm run dev"
timeout /t 3 /nobreak >nul

:: 启动管理端前端
echo [4/4] 启动管理端前端 (端口: 8083)...
start "管理端前端" cmd /k "cd /d %~dp0admin-frontend && npm run dev"

echo.
echo ========================================
echo   所有服务启动命令已执行！
echo ========================================
echo.
echo 请等待各服务启动完成（约30-60秒）
echo.
echo 服务地址：
echo   用户端前端: http://localhost:8080
echo   管理端前端: http://localhost:8083
echo   用户端后端: http://localhost:8081/api/user
echo   管理端后端: http://localhost:8082/api/admin
echo.
echo 默认账号：admin / 123456
echo.
echo 按任意键打开测试页面...
pause >nul

:: 打开测试页面
start http://localhost:8080
start http://localhost:8083

echo.
echo 系统已启动完成！
echo.
pause

