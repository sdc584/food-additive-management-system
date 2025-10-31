@echo off
echo ========================================
echo 临时修复后端启动问题
echo ========================================
echo.
echo 步骤1: 备份OperationLog相关文件
echo.

cd /d "%~dp0\admin-backend"

mkdir backup 2>nul
copy src\main\java\com\foodadditive\admin\entity\OperationLog.java backup\ 2>nul
copy src\main\java\com\foodadditive\admin\service\OperationLogService.java backup\ 2>nul
copy src\main\java\com\foodadditive\admin\service\impl\OperationLogServiceImpl.java backup\ 2>nul
copy src\main\java\com\foodadditive\admin\mapper\OperationLogMapper.java backup\ 2>nul
copy src\main\java\com\foodadditive\admin\aspect\OperationLogAspect.java backup\ 2>nul
copy src\main\java\com\foodadditive\admin\annotation\OperationLog.java backup\ 2>nul

echo.
echo 步骤2: 临时删除OperationLog相关文件
echo.

del src\main\java\com\foodadditive\admin\entity\OperationLog.java 2>nul
del src\main\java\com\foodadditive\admin\service\OperationLogService.java 2>nul
del src\main\java\com\foodadditive\admin\service\impl\OperationLogServiceImpl.java 2>nul
del src\main\java\com\foodadditive\admin\mapper\OperationLogMapper.java 2>nul
del src\main\java\com\foodadditive\admin\aspect\OperationLogAspect.java 2>nul
del src\main\java\com\foodadditive\admin\annotation\OperationLog.java 2>nul

echo.
echo 步骤3: 清理并重新编译
echo.

rmdir /s /q target 2>nul
call mvn clean package -DskipTests

echo.
echo ========================================
echo 修复完成！
echo 备份文件在 admin-backend\backup 目录
echo 现在可以启动后端服务器了
echo ========================================
pause

