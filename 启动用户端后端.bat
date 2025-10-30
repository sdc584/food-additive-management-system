@echo off
chcp 65001
title 用户端后端服务
echo ========================================
echo 正在启动用户端后端服务...
echo ========================================
echo.
cd /d "%~dp0user-backend"
call mvn spring-boot:run
pause

