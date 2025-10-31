@echo off
chcp 65001 >nul
title 管理端后端 - 端口8082
color 0B

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║              管理端后端启动中...                           ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo 端口: 8082
echo API地址: http://localhost:8082/api/admin
echo.
echo 请等待启动完成...
echo 看到 "Started Application" 表示启动成功
echo.

mvn spring-boot:run

pause

