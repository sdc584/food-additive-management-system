-- ============================================
-- 食品添加剂管理系统 - 完整数据库脚本
-- 包含表结构创建和初始数据导入
-- 所有表都有外键关联，无孤表
-- ============================================
-- 注意：此脚本会删除并重新创建数据库，请谨慎使用！
-- 使用方法：mysql -u root -p --default-character-set=utf8mb4 < complete-schema.sql
-- ============================================

-- 删除并重新创建数据库
DROP DATABASE IF EXISTS food_additive_system;
CREATE DATABASE food_additive_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE food_additive_system;

-- 临时禁用外键检查和strict mode
SET FOREIGN_KEY_CHECKS = 0;
SET SESSION sql_mode = '';

-- ============================================
-- 表1: 用户表 (sys_user)
-- 关联: operation_log, purchase_record, usage_record, warning
-- ============================================
CREATE TABLE sys_user (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(200) NOT NULL COMMENT '密码(BCrypt加密)',
    real_name VARCHAR(100) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    role VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色: ADMIN-管理员, USER-普通用户',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-启用, 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================
-- 表2: 添加剂分类表 (additive_category)
-- 关联: food_additive (自关联parent_id)
-- ============================================
CREATE TABLE additive_category (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',
    category_code VARCHAR(50) NOT NULL UNIQUE COMMENT '分类编码',
    parent_id BIGINT DEFAULT 0 COMMENT '父分类ID, 0表示顶级分类',
    description TEXT COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序号',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-启用, 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_category_code (category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='添加剂分类表';

-- ============================================
-- 表3: 食品添加剂信息表 (food_additive)
-- 关联: additive_category, inventory, purchase_record, usage_record, test_report, warning
-- ============================================
CREATE TABLE food_additive (
    additive_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '添加剂ID',
    additive_name VARCHAR(100) NOT NULL COMMENT '添加剂名称',
    additive_code VARCHAR(50) NOT NULL UNIQUE COMMENT '添加剂编码',
    category_id BIGINT NOT NULL COMMENT '分类ID',
    cas_number VARCHAR(50) COMMENT 'CAS号',
    molecular_formula VARCHAR(100) COMMENT '分子式',
    specification VARCHAR(50) COMMENT '规格',
    unit VARCHAR(20) DEFAULT 'kg' COMMENT '单位',
    max_usage DECIMAL(10,2) COMMENT '最大使用量',
    safety_level VARCHAR(10) COMMENT '安全等级: A-安全, B-较安全, C-谨慎使用',
    description TEXT COMMENT '描述',
    usage_scope TEXT COMMENT '使用范围',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-启用, 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (category_id) REFERENCES additive_category(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_category_id (category_id),
    INDEX idx_additive_code (additive_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='食品添加剂信息表';

-- ============================================
-- 表4: 供应商表 (supplier)
-- 关联: purchase_record
-- ============================================
CREATE TABLE supplier (
    supplier_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '供应商ID',
    supplier_name VARCHAR(100) NOT NULL COMMENT '供应商名称',
    supplier_code VARCHAR(50) NOT NULL UNIQUE COMMENT '供应商编码',
    contact_person VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    contact_email VARCHAR(100) COMMENT '联系邮箱',
    address VARCHAR(200) COMMENT '地址',
    credit_level VARCHAR(10) COMMENT '信用等级: AAA, AA, A, B, C',
    business_license VARCHAR(50) COMMENT '营业执照号',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-启用, 0-禁用',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_supplier_code (supplier_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- ============================================
-- 表5: 采购记录表 (purchase_record)
-- 关联: food_additive, supplier, sys_user
-- ============================================
CREATE TABLE purchase_record (
    purchase_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '采购ID',
    purchase_no VARCHAR(50) NOT NULL UNIQUE COMMENT '采购单号',
    additive_id BIGINT NOT NULL COMMENT '添加剂ID',
    supplier_id BIGINT NOT NULL COMMENT '供应商ID',
    quantity DECIMAL(10,2) NOT NULL COMMENT '采购数量',
    unit_price DECIMAL(10,2) NOT NULL COMMENT '单价',
    total_price DECIMAL(12,2) NOT NULL COMMENT '总价',
    purchase_date DATE NOT NULL COMMENT '采购日期',
    production_date DATE COMMENT '生产日期',
    expiry_date DATE COMMENT '过期日期',
    batch_number VARCHAR(50) COMMENT '批次号',
    purchaser_id BIGINT NOT NULL COMMENT '采购员ID',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-待审核, APPROVED-已审核, COMPLETED-已完成, CANCELLED-已取消',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (additive_id) REFERENCES food_additive(additive_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (purchaser_id) REFERENCES sys_user(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_purchase_no (purchase_no),
    INDEX idx_additive_id (additive_id),
    INDEX idx_supplier_id (supplier_id),
    INDEX idx_purchaser_id (purchaser_id),
    INDEX idx_purchase_date (purchase_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购记录表';

-- ============================================
-- 表6: 库存表 (inventory)
-- 关联: food_additive, warning
-- ============================================
CREATE TABLE inventory (
    inventory_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '库存ID',
    additive_id BIGINT NOT NULL UNIQUE COMMENT '添加剂ID',
    current_stock DECIMAL(10,2) DEFAULT 0 COMMENT '当前库存',
    min_stock DECIMAL(10,2) DEFAULT 0 COMMENT '最小库存(预警线)',
    max_stock DECIMAL(10,2) DEFAULT 0 COMMENT '最大库存',
    warehouse_location VARCHAR(100) COMMENT '仓库位置',
    last_purchase_date DATE COMMENT '最后采购日期',
    last_usage_date DATE COMMENT '最后使用日期',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-停用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (additive_id) REFERENCES food_additive(additive_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_additive_id (additive_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

-- ============================================
-- 表7: 使用记录表 (usage_record)
-- 关联: food_additive, sys_user
-- ============================================
CREATE TABLE usage_record (
    usage_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '使用记录ID',
    usage_no VARCHAR(50) NOT NULL UNIQUE COMMENT '使用单号',
    additive_id BIGINT NOT NULL COMMENT '添加剂ID',
    quantity DECIMAL(10,2) NOT NULL COMMENT '使用数量',
    usage_date DATE NOT NULL COMMENT '使用日期',
    usage_purpose VARCHAR(200) COMMENT '使用目的',
    product_batch VARCHAR(50) COMMENT '产品批次',
    user_id BIGINT NOT NULL COMMENT '操作员ID',
    department VARCHAR(100) COMMENT '使用部门',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (additive_id) REFERENCES food_additive(additive_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_usage_no (usage_no),
    INDEX idx_additive_id (additive_id),
    INDEX idx_user_id (user_id),
    INDEX idx_usage_date (usage_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='使用记录表';

-- ============================================
-- 表8: 检测报告表 (test_report)
-- 关联: food_additive
-- ============================================
CREATE TABLE test_report (
    report_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '报告ID',
    report_no VARCHAR(50) NOT NULL UNIQUE COMMENT '报告编号',
    additive_id BIGINT NOT NULL COMMENT '添加剂ID',
    test_date DATE NOT NULL COMMENT '检测日期',
    test_organization VARCHAR(200) COMMENT '检测机构',
    test_result VARCHAR(20) COMMENT '检测结果: 合格, 不合格',
    test_items TEXT COMMENT '检测项目',
    report_file VARCHAR(200) COMMENT '报告文件路径',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (additive_id) REFERENCES food_additive(additive_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_report_no (report_no),
    INDEX idx_additive_id (additive_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检测报告表';

-- ============================================
-- 表9: 预警表 (warning)
-- 关联: food_additive, inventory, sys_user
-- ============================================
CREATE TABLE warning (
    warning_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '预警ID',
    warning_type VARCHAR(20) NOT NULL COMMENT '预警类型: STOCK_LOW-库存不足, EXPIRY-即将过期, QUALITY-质量问题',
    additive_id BIGINT COMMENT '添加剂ID',
    inventory_id BIGINT COMMENT '库存ID',
    warning_level VARCHAR(20) NOT NULL COMMENT '预警级别: HIGH-高, MEDIUM-中, LOW-低',
    warning_content TEXT NOT NULL COMMENT '预警内容',
    warning_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预警时间',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-待处理, PROCESSING-处理中, RESOLVED-已解决, IGNORED-已忽略',
    handler_id BIGINT COMMENT '处理人ID',
    handle_time DATETIME COMMENT '处理时间',
    handle_remark TEXT COMMENT '处理备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (additive_id) REFERENCES food_additive(additive_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (handler_id) REFERENCES sys_user(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_warning_type (warning_type),
    INDEX idx_additive_id (additive_id),
    INDEX idx_inventory_id (inventory_id),
    INDEX idx_handler_id (handler_id),
    INDEX idx_warning_date (warning_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警表';

-- ============================================
-- 表10: 操作日志表 (operation_log)
-- 关联: sys_user
-- ============================================
CREATE TABLE operation_log (
    log_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id BIGINT COMMENT '用户ID',
    username VARCHAR(50) COMMENT '用户名',
    operation VARCHAR(50) NOT NULL COMMENT '操作类型',
    method VARCHAR(200) COMMENT '请求方法',
    params TEXT COMMENT '请求参数',
    ip VARCHAR(50) COMMENT 'IP地址',
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    execution_time BIGINT COMMENT '执行时长(毫秒)',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-成功, 0-失败',
    error_msg TEXT COMMENT '错误信息',
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- ============================================
-- 插入初始数据
-- ============================================

-- 1. 插入用户数据 (密码: 123456)
INSERT INTO sys_user (username, password, real_name, phone, email, role, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '管理员', '13800138000', 'admin@example.com', 'ADMIN', 1),
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', '13800138001', 'user1@example.com', 'USER', 1),
('user2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', '13800138002', 'user2@example.com', 'USER', 1);

-- 2. 插入添加剂分类
INSERT INTO additive_category (category_name, category_code, parent_id, description, sort_order) VALUES
('防腐剂', 'FFC', 0, '用于防止食品腐败变质', 1),
('抗氧化剂', 'KYH', 0, '用于防止或延缓食品氧化变质', 2),
('着色剂', 'ZSJ', 0, '用于改善食品色泽', 3),
('甜味剂', 'TWJ', 0, '用于赋予食品甜味', 4),
('增稠剂', 'ZCJ', 0, '用于改善食品质构', 5),
('乳化剂', 'RHJ', 0, '用于使油水混合均匀', 6);

-- 3. 插入食品添加剂信息
INSERT INTO food_additive (additive_name, additive_code, category_id, cas_number, molecular_formula, specification, unit, max_usage, safety_level, description, usage_scope, status) VALUES
('山梨酸钾', 'FA001', 1, '24634-61-5', 'C6H7KO2', '99%', 'kg', 1.0, 'A', '防腐剂，广泛用于食品保鲜', '肉制品、饮料、糕点', 1),
('苯甲酸钠', 'FA002', 1, '532-32-1', 'C7H5NaO2', '99%', 'kg', 1.0, 'A', '防腐剂，用于酸性食品', '饮料、酱油、果酱', 1),
('维生素E', 'FA003', 2, '10191-41-0', 'C29H50O2', '50%', 'kg', 0.3, 'A', '抗氧化剂，营养强化剂', '油脂、乳制品', 1),
('柠檬黄', 'FA004', 3, '1934-21-0', 'C16H9N4Na3O9S2', '85%', 'kg', 0.1, 'B', '着色剂，黄色', '饮料、糖果', 1),
('阿斯巴甜', 'FA005', 4, '22839-47-0', 'C14H18N2O5', '99%', 'kg', 0.6, 'A', '甜味剂，低热量', '饮料、口香糖', 1),
('黄原胶', 'FA006', 5, '11138-66-2', 'C35H49O29', '80%', 'kg', 10.0, 'A', '增稠剂，稳定剂', '饮料、调味品', 1),
('卵磷脂', 'FA007', 6, '8002-43-5', 'C42H80NO8P', '60%', 'kg', 10.0, 'A', '乳化剂，营养强化剂', '巧克力、烘焙食品', 1);

-- 4. 插入供应商
INSERT INTO supplier (supplier_name, supplier_code, contact_person, contact_phone, contact_email, address, credit_level, business_license, status, remark) VALUES
('上海添加剂供应有限公司', 'SUP001', '张经理', '021-12345678', 'zhang@supplier1.com', '上海市浦东新区张江高科技园区', 'AAA', '91310000MA1K12345A', 1, '主要供应食品级柠檬酸、山梨酸钾等'),
('维他命供应商(北京)有限公司', 'SUP002', '李经理', '010-87654321', 'li@supplier2.com', '北京市朝阳区CBD中心', 'AA', '91110000MA1K67890B', 1, '专业维生素类添加剂供应商'),
('粤港食品添加剂贸易公司', 'SUP003', '黄经理', '020-98765432', 'huang@supplier3.com', '广州市天河区珠江新城', 'AAA', '91440000MA1K11111C', 1, '华南地区最大的食品添加剂供应商');

-- 5. 插入采购记录
INSERT INTO purchase_record (purchase_no, additive_id, supplier_id, quantity, unit_price, total_price, purchase_date, production_date, expiry_date, batch_number, purchaser_id, status) VALUES
('PO202401001', 1, 1, 100.00, 45.00, 4500.00, '2024-01-15', '2023-12-01', '2025-12-01', 'BATCH001', 1, 'COMPLETED'),
('PO202401002', 2, 1, 50.00, 38.00, 1900.00, '2024-01-20', '2023-12-05', '2025-12-05', 'BATCH002', 1, 'COMPLETED'),
('PO202402001', 3, 1, 30.00, 120.00, 3600.00, '2024-02-10', '2024-01-01', '2026-01-01', 'BATCH003', 1, 'COMPLETED'),
('PO202402002', 4, 2, 20.00, 85.00, 1700.00, '2024-02-15', '2024-01-10', '2026-01-10', 'BATCH004', 1, 'COMPLETED'),
('PO202403001', 5, 2, 40.00, 95.00, 3800.00, '2024-03-01', '2024-02-01', '2026-02-01', 'BATCH005', 1, 'COMPLETED');

-- 6. 插入库存记录
INSERT INTO inventory (additive_id, current_stock, min_stock, max_stock, warehouse_location, last_purchase_date, last_usage_date, status) VALUES
(1, 81.00, 20.00, 200.00, 'A区-01货架', '2024-01-15', '2024-03-10', 1),
(2, 45.00, 15.00, 150.00, 'A区-02货架', '2024-01-20', '2024-03-12', 1),
(3, 28.00, 10.00, 100.00, 'B区-01货架', '2024-02-10', '2024-03-15', 1),
(4, 18.00, 5.00, 50.00, 'B区-02货架', '2024-02-15', '2024-03-18', 1),
(5, 35.00, 10.00, 100.00, 'C区-01货架', '2024-03-01', '2024-03-20', 1),
(6, 5.00, 20.00, 200.00, 'C区-02货架', NULL, NULL, 1),
(7, 8.00, 15.00, 150.00, 'C区-03货架', NULL, NULL, 1);

-- 7. 插入使用记录
INSERT INTO usage_record (usage_no, additive_id, quantity, usage_date, usage_purpose, product_batch, user_id, department) VALUES
('USE202403001', 1, 20.00, '2024-03-10', '肉制品生产', 'PROD20240310001', 2, '生产部'),
('USE202403002', 2, 5.00, '2024-03-12', '饮料生产', 'PROD20240312001', 2, '生产部'),
('USE202403003', 3, 2.00, '2024-03-15', '油脂生产', 'PROD20240315001', 2, '生产部'),
('USE202403004', 4, 2.00, '2024-03-18', '糖果生产', 'PROD20240318001', 3, '生产部'),
('USE202403005', 5, 5.00, '2024-03-20', '饮料生产', 'PROD20240320001', 3, '生产部');

-- 8. 插入检测报告
INSERT INTO test_report (report_no, additive_id, test_date, test_organization, test_result, test_items, report_file) VALUES
('TEST202401001', 1, '2024-01-18', '国家食品质量监督检验中心', '合格', '纯度、重金属、微生物', '/files/reports/test_202401001.pdf'),
('TEST202401002', 2, '2024-01-22', '国家食品质量监督检验中心', '合格', '纯度、重金属、微生物', '/files/reports/test_202401002.pdf'),
('TEST202402001', 3, '2024-02-12', '上海食品检测中心', '合格', '含量、重金属', '/files/reports/test_202402001.pdf');

-- 9. 插入预警记录
INSERT INTO warning (warning_type, additive_id, inventory_id, warning_level, warning_content, status) VALUES
('STOCK_LOW', 6, 6, 'HIGH', '黄原胶库存为5kg，低于最小库存20kg，请及时采购', 'PENDING'),
('STOCK_LOW', 7, 7, 'MEDIUM', '卵磷脂库存为8kg，低于最小库存15kg，请及时采购', 'PENDING');

-- 10. 插入操作日志
INSERT INTO operation_log (user_id, username, operation, method, params, ip, operation_time, execution_time, status) VALUES
(1, 'admin', '用户登录', 'POST /api/admin/auth/login', '{"username":"admin"}', '192.168.1.100', '2024-03-25 09:00:00', 125, 1),
(1, 'admin', '查询添加剂列表', 'GET /api/admin/foodAdditive/list', NULL, '192.168.1.100', '2024-03-25 09:05:00', 45, 1),
(2, 'user1', '用户登录', 'POST /api/user/auth/login', '{"username":"user1"}', '192.168.1.101', '2024-03-25 10:00:00', 98, 1),
(2, 'user1', '提交使用记录', 'POST /api/user/usageRecord', '{"additive_id":1,"quantity":20}', '192.168.1.101', '2024-03-25 10:15:00', 156, 1);

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 验证表关联关系
-- ============================================
SELECT 
    '数据库创建完成！' AS message,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'food_additive_system') AS total_tables,
    (SELECT COUNT(*) FROM information_schema.key_column_usage WHERE table_schema = 'food_additive_system' AND referenced_table_name IS NOT NULL) AS total_foreign_keys;

-- 显示所有表
SHOW TABLES;

