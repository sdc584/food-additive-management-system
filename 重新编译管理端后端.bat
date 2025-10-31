@echo off
chcp 65001 >nul
echo ========================================
echo 重新编译管理端后端
echo ========================================
echo.
echo 正在停止管理端后端服务...
echo 请手动关闭管理端后端的运行窗口（如果有的话）
echo.
pause
echo.
echo ========================================
echo 开始清理和编译...
echo ========================================
cd admin-backend

echo.
echo [1/3] 清理旧的编译文件...
call mvn clean

echo.
echo [2/3] 重新编译项目...
call mvn compile

echo.
echo [3/3] 启动管理端后端...
echo.
echo 管理端后端正在启动，请等待...
echo 看到 "Started Application" 表示启动成功
echo.
start "管理端后端 - 端口8082" cmd /k "mvn spring-boot:run"

echo.
echo ========================================
echo 重新编译完成！
echo ========================================
echo.
echo 管理端后端已在新窗口中启动
echo 端口: 8082
echo 访问地址: http://localhost:8082/api/admin
echo.
echo 请等待30-60秒，直到看到 "Started Application" 提示
echo.
echo 然后可以测试新接口:
echo http://localhost:8082/api/admin/operationLogs/recent?limit=5
echo.
pause

