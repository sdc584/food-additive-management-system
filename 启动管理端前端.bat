@echo off
chcp 65001
title 管理端前端服务
echo ========================================
echo 正在启动管理端前端服务...
echo ========================================
echo.
cd /d "%~dp0admin-frontend"
call npm run dev
pause

