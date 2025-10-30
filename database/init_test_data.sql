-- 食品添加剂管理系统 - 测试数据初始化脚本
-- 使用数据库
USE food_additive_db;

-- 清空现有数据（保留用户数据）
DELETE FROM operation_log WHERE log_id > 0;
DELETE FROM warning WHERE warning_id > 0;
DELETE FROM test_report WHERE report_id > 0;
DELETE FROM usage_record WHERE record_id > 0;
DELETE FROM purchase_record WHERE record_id > 0;
DELETE FROM inventory WHERE inventory_id > 0;
DELETE FROM food_additive WHERE additive_id > 0;
DELETE FROM supplier WHERE supplier_id > 0;
DELETE FROM additive_category WHERE category_id > 0;

-- 重置自增ID
ALTER TABLE operation_log AUTO_INCREMENT = 1;
ALTER TABLE warning AUTO_INCREMENT = 1;
ALTER TABLE test_report AUTO_INCREMENT = 1;
ALTER TABLE usage_record AUTO_INCREMENT = 1;
ALTER TABLE purchase_record AUTO_INCREMENT = 1;
ALTER TABLE inventory AUTO_INCREMENT = 1;
ALTER TABLE food_additive AUTO_INCREMENT = 1;
ALTER TABLE supplier AUTO_INCREMENT = 1;
ALTER TABLE additive_category AUTO_INCREMENT = 1;

-- ========================================
-- 1. 添加剂分类数据
-- ========================================
INSERT INTO additive_category (category_name, category_code, description, status, create_time, update_time) VALUES
('防腐剂', 'CAT001', '用于防止食品腐败变质', 1, NOW(), NOW()),
('抗氧化剂', 'CAT002', '用于防止食品氧化变质', 1, NOW(), NOW()),
('甜味剂', 'CAT003', '用于增加食品甜味', 1, NOW(), NOW()),
('着色剂', 'CAT004', '用于改善食品色泽', 1, NOW(), NOW()),
('增稠剂', 'CAT005', '用于增加食品粘稠度', 1, NOW(), NOW()),
('酸度调节剂', 'CAT006', '用于调节食品酸碱度', 1, NOW(), NOW()),
('乳化剂', 'CAT007', '用于使油水混合均匀', 1, NOW(), NOW()),
('香精香料', 'CAT008', '用于增加食品香味', 1, NOW(), NOW());

-- ========================================
-- 2. 食品添加剂数据
-- ========================================
INSERT INTO food_additive (additive_name, additive_code, cas_number, category_id, molecular_formula, purpose, max_usage, safety_level, status, remark, create_time, update_time) VALUES
('柠檬酸', 'ADD001', '77-92-9', 6, 'C6H8O7', '酸度调节剂、抗氧化剂', '5.0g/kg', 'A', 1, '广泛用于饮料、糖果等', NOW(), NOW()),
('山梨酸钾', 'ADD002', '24634-61-5', 1, 'C6H7KO2', '防腐剂', '1.0g/kg', 'A', 1, '用于肉制品、饮料等', NOW(), NOW()),
('阿斯巴甜', 'ADD003', '22839-47-0', 3, 'C14H18N2O5', '甜味剂', '0.6g/kg', 'B', 1, '用于低糖食品', NOW(), NOW()),
('胭脂红', 'ADD004', '2611-82-7', 4, 'C20H11N2Na3O10S3', '着色剂', '0.05g/kg', 'C', 1, '用于糖果、饮料', NOW(), NOW()),
('黄原胶', 'ADD005', '11138-66-2', 5, '(C35H49O29)n', '增稠剂、稳定剂', '10.0g/kg', 'A', 1, '用于调味品、饮料', NOW(), NOW()),
('苯甲酸钠', 'ADD006', '532-32-1', 1, 'C7H5NaO2', '防腐剂', '1.0g/kg', 'B', 1, '用于酱油、果酱', NOW(), NOW()),
('维生素C', 'ADD007', '50-81-7', 2, 'C6H8O6', '抗氧化剂、营养强化剂', '2.0g/kg', 'A', 1, '用于果汁、饮料', NOW(), NOW()),
('卡拉胶', 'ADD008', '9000-07-1', 5, '(C24H36O25S2)n', '增稠剂、胶凝剂', '10.0g/kg', 'A', 1, '用于果冻、布丁', NOW(), NOW()),
('柠檬黄', 'ADD009', '1934-21-0', 4, 'C16H9N4Na3O9S2', '着色剂', '0.1g/kg', 'C', 1, '用于糖果、饮料', NOW(), NOW()),
('三氯蔗糖', 'ADD010', '56038-13-2', 3, 'C12H19Cl3O8', '甜味剂', '0.3g/kg', 'A', 1, '用于无糖食品', NOW(), NOW());

-- ========================================
-- 3. 供应商数据
-- ========================================
INSERT INTO supplier (supplier_name, supplier_code, contact_person, contact_phone, contact_email, address, credit_level, business_license, status, remark, create_time, update_time) VALUES
('上海添加剂有限公司', 'SUP001', '张三', '021-12345678', 'zhangsan@sh-additive.com', '上海市浦东新区张江高科技园区', 'A', '91310000MA1FL5E73X', 1, '主营防腐剂、抗氧化剂', NOW(), NOW()),
('北京食品原料公司', 'SUP002', '李四', '010-87654321', 'lisi@bj-food.com', '北京市朝阳区CBD商务区', 'A', '91110000MA00123456', 1, '主营甜味剂、着色剂', NOW(), NOW()),
('广州化工贸易公司', 'SUP003', '王五', '020-11223344', 'wangwu@gz-chem.com', '广州市天河区科技园', 'B', '91440000MA5678901X', 1, '主营增稠剂、乳化剂', NOW(), NOW()),
('深圳进出口公司', 'SUP004', '赵六', '0755-99887766', 'zhaoliu@sz-import.com', '深圳市南山区高新技术园', 'A', '91440300MA9012345Y', 1, '进口食品添加剂', NOW(), NOW()),
('杭州生物科技公司', 'SUP005', '钱七', '0571-55667788', 'qianqi@hz-bio.com', '杭州市滨江区高新园区', 'B', '91330000MA3456789Z', 1, '主营天然添加剂', NOW(), NOW());

-- ========================================
-- 4. 库存数据
-- ========================================
INSERT INTO inventory (additive_id, current_stock, min_stock, max_stock, warehouse_location, last_purchase_date, last_usage_date, status, create_time, update_time) VALUES
(1, 500.00, 100.00, 1000.00, 'A区-01货架', '2025-10-25', '2025-10-28', 1, NOW(), NOW()),
(2, 80.00, 50.00, 500.00, 'A区-02货架', '2025-10-20', '2025-10-27', 1, NOW(), NOW()),
(3, 150.00, 50.00, 300.00, 'B区-01货架', '2025-10-22', '2025-10-26', 1, NOW(), NOW()),
(4, 30.00, 20.00, 100.00, 'B区-02货架', '2025-10-18', '2025-10-25', 1, NOW(), NOW()),
(5, 200.00, 100.00, 500.00, 'C区-01货架', '2025-10-24', '2025-10-29', 1, NOW(), NOW()),
(6, 120.00, 80.00, 400.00, 'A区-03货架', '2025-10-21', '2025-10-28', 1, NOW(), NOW()),
(7, 300.00, 150.00, 600.00, 'C区-02货架', '2025-10-26', '2025-10-29', 1, NOW(), NOW()),
(8, 180.00, 100.00, 400.00, 'C区-03货架', '2025-10-23', '2025-10-27', 1, NOW(), NOW()),
(9, 15.00, 20.00, 80.00, 'B区-03货架', '2025-10-15', '2025-10-24', 1, NOW(), NOW()),
(10, 90.00, 50.00, 200.00, 'B区-04货架', '2025-10-19', '2025-10-26', 1, NOW(), NOW());

-- ========================================
-- 5. 采购记录数据
-- ========================================
INSERT INTO purchase_record (purchase_no, additive_id, supplier_id, quantity, unit_price, total_price, purchase_date, production_date, expiry_date, batch_no, purchaser, status, remark, create_time, update_time) VALUES
('PO202510001', 1, 1, 500.00, 25.00, 12500.00, '2025-10-25', '2025-10-01', '2027-10-01', 'BATCH20251001', 1, 2, '正常采购', NOW(), NOW()),
('PO202510002', 2, 1, 100.00, 45.00, 4500.00, '2025-10-20', '2025-09-15', '2027-09-15', 'BATCH20250915', 1, 2, '正常采购', NOW(), NOW()),
('PO202510003', 3, 2, 200.00, 120.00, 24000.00, '2025-10-22', '2025-10-05', '2027-10-05', 'BATCH20251005', 1, 2, '正常采购', NOW(), NOW()),
('PO202510004', 4, 2, 50.00, 80.00, 4000.00, '2025-10-18', '2025-09-20', '2027-09-20', 'BATCH20250920', 1, 1, '待入库', NOW(), NOW()),
('PO202510005', 5, 3, 300.00, 35.00, 10500.00, '2025-10-24', '2025-10-10', '2027-10-10', 'BATCH20251010', 1, 2, '正常采购', NOW(), NOW());

-- ========================================
-- 6. 使用记录数据
-- ========================================
INSERT INTO usage_record (additive_id, usage_quantity, product_name, batch_no, usage_date, usage_purpose, operator, status, remark, create_time, update_time) VALUES
(1, 50.00, '橙汁饮料', 'PROD20251028001', '2025-10-28', '酸度调节', 1, 1, '正常使用', NOW(), NOW()),
(2, 20.00, '火腿肠', 'PROD20251027001', '2025-10-27', '防腐保鲜', 1, 1, '正常使用', NOW(), NOW()),
(3, 30.00, '无糖可乐', 'PROD20251026001', '2025-10-26', '增加甜味', 1, 1, '正常使用', NOW(), NOW()),
(5, 40.00, '番茄酱', 'PROD20251029001', '2025-10-29', '增稠', 1, 1, '正常使用', NOW(), NOW()),
(7, 60.00, '苹果汁', 'PROD20251029002', '2025-10-29', '抗氧化', 1, 1, '正常使用', NOW(), NOW());

-- ========================================
-- 7. 检测报告数据
-- ========================================
INSERT INTO test_report (additive_id, report_no, test_date, test_result, test_organization, test_person, test_items, conclusion, status, remark, create_time, update_time) VALUES
(1, 'TR202510001', '2025-10-26', '合格', '国家食品质量监督检验中心', '检验员A', '纯度、重金属、微生物', '符合GB 1886.235-2016标准', 1, '检测合格', NOW(), NOW()),
(2, 'TR202510002', '2025-10-21', '合格', '上海食品检测中心', '检验员B', '含量、杂质、pH值', '符合GB 1886.39-2015标准', 1, '检测合格', NOW(), NOW()),
(3, 'TR202510003', '2025-10-23', '合格', '北京质检院', '检验员C', '纯度、甜度、溶解度', '符合GB 1886.211-2016标准', 1, '检测合格', NOW(), NOW()),
(4, 'TR202510004', '2025-10-19', '不合格', '广州检测中心', '检验员D', '色价、纯度、重金属', '重金属超标', 0, '需要退货', NOW(), NOW()),
(5, 'TR202510005', '2025-10-25', '合格', '深圳质检所', '检验员E', '粘度、纯度、微生物', '符合GB 1886.233-2016标准', 1, '检测合格', NOW(), NOW());

-- ========================================
-- 8. 预警数据
-- ========================================
INSERT INTO warning (warning_type, additive_id, warning_level, warning_content, warning_date, handler, handle_time, status, remark, create_time, update_time) VALUES
('STOCK', 9, 'HIGH', '柠檬黄库存不足，当前库存15kg，低于最小库存20kg', '2025-10-30', NULL, NULL, 0, '需要尽快采购', NOW(), NOW()),
('STOCK', 2, 'MEDIUM', '山梨酸钾库存偏低，当前库存80kg，接近最小库存50kg', '2025-10-30', NULL, NULL, 0, '建议补货', NOW(), NOW()),
('EXPIRY', 4, 'HIGH', '胭脂红即将过期，过期日期：2027-09-20', '2025-10-30', NULL, NULL, 0, '需要加快使用', NOW(), NOW());

-- ========================================
-- 9. 操作日志数据
-- ========================================
INSERT INTO operation_log (operation_type, module_name, operation_content, operator, operation_time, ip_address, status, create_time, update_time) VALUES
('INSERT', '添加剂管理', '新增添加剂：柠檬酸', 'admin', NOW(), '192.168.1.100', 1, NOW(), NOW()),
('UPDATE', '库存管理', '更新库存：柠檬酸，数量：500kg', 'admin', NOW(), '192.168.1.100', 1, NOW(), NOW()),
('INSERT', '采购管理', '新增采购记录：PO202510001', 'admin', NOW(), '192.168.1.100', 1, NOW(), NOW()),
('INSERT', '使用记录', '新增使用记录：橙汁饮料使用柠檬酸50kg', 'admin', NOW(), '192.168.1.100', 1, NOW(), NOW()),
('INSERT', '检测报告', '新增检测报告：TR202510001', 'admin', NOW(), '192.168.1.100', 1, NOW(), NOW());

-- 提交事务
COMMIT;

-- 查询统计信息
SELECT '添加剂分类' AS 表名, COUNT(*) AS 记录数 FROM additive_category
UNION ALL
SELECT '食品添加剂', COUNT(*) FROM food_additive
UNION ALL
SELECT '供应商', COUNT(*) FROM supplier
UNION ALL
SELECT '库存', COUNT(*) FROM inventory
UNION ALL
SELECT '采购记录', COUNT(*) FROM purchase_record
UNION ALL
SELECT '使用记录', COUNT(*) FROM usage_record
UNION ALL
SELECT '检测报告', COUNT(*) FROM test_report
UNION ALL
SELECT '预警', COUNT(*) FROM warning
UNION ALL
SELECT '操作日志', COUNT(*) FROM operation_log;

SELECT '数据初始化完成！' AS 状态;

