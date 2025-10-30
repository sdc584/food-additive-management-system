@echo off
chcp 65001 >nul
echo ========================================
echo 食品添加剂管理系统 - 数据初始化
echo ========================================
echo.

echo 正在初始化测试数据...
mysql -u root -p123456 food_additive_db < init_test_data.sql

if %errorlevel% == 0 (
    echo.
    echo ✅ 数据初始化成功！
    echo.
    echo 已初始化以下数据：
    echo - 8个添加剂分类
    echo - 10个食品添加剂
    echo - 5个供应商
    echo - 10条库存记录
    echo - 5条采购记录
    echo - 5条使用记录
    echo - 5条检测报告
    echo - 3条预警信息
    echo - 5条操作日志
    echo.
) else (
    echo.
    echo ❌ 数据初始化失败！
    echo 请检查MySQL服务是否启动，数据库是否存在。
    echo.
)

pause

