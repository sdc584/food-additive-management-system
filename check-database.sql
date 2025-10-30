-- 检查数据库中的数据

USE food_additive_db;

-- 检查各表的数据量
SELECT 'food_additive' AS table_name, COUNT(*) AS count FROM food_additive
UNION ALL
SELECT 'additive_category', COUNT(*) FROM additive_category
UNION ALL
SELECT 'supplier', COUNT(*) FROM supplier
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'purchase_record', COUNT(*) FROM purchase_record
UNION ALL
SELECT 'usage_record', COUNT(*) FROM usage_record
UNION ALL
SELECT 'test_report', COUNT(*) FROM test_report
UNION ALL
SELECT 'warning', COUNT(*) FROM warning
UNION ALL
SELECT 'operation_log', COUNT(*) FROM operation_log
UNION ALL
SELECT 'sys_user', COUNT(*) FROM sys_user;

-- 查看采购记录表结构
SHOW CREATE TABLE purchase_record;

-- 查看采购记录数据
SELECT * FROM purchase_record LIMIT 5;

-- 查看使用记录表结构
SHOW CREATE TABLE usage_record;

-- 查看使用记录数据
SELECT * FROM usage_record LIMIT 5;

-- 查看预警表结构
SHOW CREATE TABLE warning;

-- 查看预警数据
SELECT * FROM warning LIMIT 5;

-- 查看操作日志表结构
SHOW CREATE TABLE operation_log;

-- 查看操作日志数据
SELECT * FROM operation_log LIMIT 5;

