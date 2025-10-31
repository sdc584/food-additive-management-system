-- 检查检测报告表数据
USE food_additive_system;

-- 查看表结构
DESCRIBE test_report;

-- 查看所有检测报告数据
SELECT * FROM test_report;

-- 统计数据条数
SELECT COUNT(*) as total_count FROM test_report;

-- 如果没有数据，插入测试数据
INSERT INTO test_report (report_no, additive_id, test_date, test_organization, test_result, test_items, report_file) VALUES
('TEST202401001', 1, '2024-01-18', '国家食品质量监督检验中心', '合格', '纯度、重金属、微生物', '/files/reports/test_202401001.pdf'),
('TEST202401002', 2, '2024-01-22', '国家食品质量监督检验中心', '合格', '纯度、重金属、微生物', '/files/reports/test_202401002.pdf'),
('TEST202402001', 3, '2024-02-12', '上海食品检测中心', '合格', '含量、重金属', '/files/reports/test_202402001.pdf')
ON DUPLICATE KEY UPDATE report_no=report_no;

-- 再次查看数据
SELECT * FROM test_report;

