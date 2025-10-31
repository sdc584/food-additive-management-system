@echo off
chcp 65001 >nul
title 快速重启管理端后端
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║          食品添加剂管理系统 - 快速重启管理端后端          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

echo [提示] 此脚本将执行以下操作：
echo   1. 清理旧的编译文件
echo   2. 重新编译管理端后端
echo   3. 启动管理端后端服务
echo.
echo [注意] 请先手动关闭正在运行的管理端后端窗口！
echo.
pause

cd /d "%~dp0"
cd admin-backend

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 1/3: 清理旧的编译文件
echo ════════════════════════════════════════════════════════════
echo.
call mvn clean
if %errorlevel% neq 0 (
    echo.
    echo [错误] 清理失败！请检查Maven是否正确安装。
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 2/3: 重新编译项目
echo ════════════════════════════════════════════════════════════
echo.
call mvn compile
if %errorlevel% neq 0 (
    echo.
    echo [错误] 编译失败！请检查代码是否有错误。
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo 步骤 3/3: 启动管理端后端
echo ════════════════════════════════════════════════════════════
echo.
echo [提示] 管理端后端将在新窗口中启动...
echo.
timeout /t 2 /nobreak >nul

start "管理端后端 - 端口8082" cmd /k "color 0B && echo 管理端后端启动中... && echo. && mvn spring-boot:run"

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                    重新编译完成！                          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo [成功] 管理端后端已在新窗口中启动
echo.
echo 【服务信息】
echo   - 端口: 8082
echo   - API地址: http://localhost:8082/api/admin
echo   - 新接口: http://localhost:8082/api/admin/operationLogs/recent
echo.
echo 【等待时间】
echo   请等待 30-60 秒，直到看到 "Started Application" 提示
echo.
echo 【验证方法】
echo   1. 打开浏览器访问: http://localhost:8083
echo   2. 按 F12 打开开发者工具
echo   3. 切换到 Network 标签
echo   4. 刷新页面
echo   5. 查找 operationLogs/recent 请求
echo   6. 查看响应数据是否为真实数据
echo.
echo 【测试命令】
echo   curl http://localhost:8082/api/admin/operationLogs/recent?limit=5
echo.
pause

