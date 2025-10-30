@echo off
chcp 65001
title 管理端后端服务
echo ========================================
echo 正在启动管理端后端服务...
echo ========================================
echo.
cd /d "%~dp0admin-backend"
call mvn spring-boot:run
pause

