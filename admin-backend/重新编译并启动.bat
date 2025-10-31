@echo off
chcp 65001 >nul
title 重新编译并启动管理端后端
color 0E

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║          重新编译并启动管理端后端                          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

echo [警告] 请先手动停止旧的管理端后端服务！
echo.
echo 如果管理端后端正在运行，请：
echo   1. 找到管理端后端的运行窗口
echo   2. 按 Ctrl+C 停止服务
echo   3. 或者直接关闭该窗口
echo.
echo 按任意键继续（确认已停止旧服务）...
pause >nul

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 1/3: 清理旧的编译文件
echo ════════════════════════════════════════════════════════════
call mvn clean
if %errorlevel% neq 0 (
    echo [错误] 清理失败！
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 2/3: 重新编译项目
echo ════════════════════════════════════════════════════════════
call mvn compile
if %errorlevel% neq 0 (
    echo [错误] 编译失败！
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 3/3: 启动管理端后端
echo ════════════════════════════════════════════════════════════
echo.
echo [提示] 管理端后端正在启动...
echo 端口: 8082
echo API地址: http://localhost:8082/api/admin
echo 新接口: http://localhost:8082/api/admin/operationLogs/recent
echo.
echo 请等待启动完成（约30-60秒）...
echo 看到 "Started Application" 表示启动成功
echo.

call mvn spring-boot:run

