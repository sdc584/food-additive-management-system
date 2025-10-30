@echo off
chcp 65001 >nul
echo ========================================
echo 食品添加剂管理系统 - 系统测试
echo ========================================
echo.

echo 正在测试后端API...
echo.

echo [1/10] 测试管理端后端 (8082)...
curl -s http://localhost:8082/api/admin/foodAdditives > nul 2>&1
if %errorlevel% == 0 (
    echo ✅ 管理端后端正常运行
) else (
    echo ❌ 管理端后端未启动或无响应
)

echo [2/10] 测试用户端后端 (8081)...
curl -s http://localhost:8081/api/user/foodAdditives > nul 2>&1
if %errorlevel% == 0 (
    echo ✅ 用户端后端正常运行
) else (
    echo ❌ 用户端后端未启动或无响应
)

echo [3/10] 测试管理端前端 (8083)...
curl -s http://localhost:8083 > nul 2>&1
if %errorlevel% == 0 (
    echo ✅ 管理端前端正常运行
) else (
    echo ❌ 管理端前端未启动或无响应
)

echo [4/10] 测试用户端前端 (8080)...
curl -s http://localhost:8080 > nul 2>&1
if %errorlevel% == 0 (
    echo ✅ 用户端前端正常运行
) else (
    echo ❌ 用户端前端未启动或无响应
)

echo.
echo 正在测试核心API接口...
echo.

echo [5/10] 测试添加剂分类API...
curl -s http://localhost:8082/api/admin/additiveCategories | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 添加剂分类API正常
) else (
    echo ❌ 添加剂分类API异常
)

echo [6/10] 测试食品添加剂API...
curl -s http://localhost:8082/api/admin/foodAdditives | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 食品添加剂API正常
) else (
    echo ❌ 食品添加剂API异常
)

echo [7/10] 测试库存API...
curl -s http://localhost:8082/api/admin/inventories | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 库存API正常
) else (
    echo ❌ 库存API异常
)

echo [8/10] 测试供应商API...
curl -s http://localhost:8082/api/admin/suppliers | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 供应商API正常
) else (
    echo ❌ 供应商API异常
)

echo [9/10] 测试采购记录API...
curl -s http://localhost:8082/api/admin/purchaseRecords | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 采购记录API正常
) else (
    echo ❌ 采购记录API异常
)

echo [10/10] 测试预警API...
curl -s http://localhost:8082/api/admin/warnings | findstr "code" > nul
if %errorlevel% == 0 (
    echo ✅ 预警API正常
) else (
    echo ❌ 预警API异常
)

echo.
echo ========================================
echo 测试完成！
echo ========================================
echo.
echo 访问地址：
echo 管理端: http://localhost:8083
echo 用户端: http://localhost:8080
echo.
echo 登录账号: admin / 123456
echo.

pause

