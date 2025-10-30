@echo off
chcp 65001
title 用户端前端服务
echo ========================================
echo 正在启动用户端前端服务...
echo ========================================
echo.
cd /d "%~dp0user-frontend"
call npm run dev
pause

