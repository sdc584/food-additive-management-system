# 数据库脚本使用说明

## 📁 文件列表

### 1. `complete-schema.sql` ⭐ 主脚本
**用途**：完整的数据库初始化脚本，包含表结构和初始数据

**使用场景**：
- 首次安装系统
- 重新初始化数据库
- 开发环境搭建

**执行方法**：
```bash
mysql -u root -p --default-character-set=utf8mb4 < database/complete-schema.sql
```

**⚠️ 警告**：此脚本会删除并重新创建 `food_additive_system` 数据库，请谨慎使用！

**包含内容**：
- 10张表的完整结构定义
- 12个外键关联关系
- 所有表的初始测试数据
- 用户、分类、添加剂、供应商、库存等数据

---

### 2. `fix-all-chinese-data.sql` 🔧 中文修复脚本
**用途**：修复已存在数据库中的中文乱码问题

**使用场景**：
- 数据库中出现中文乱码
- 字符集配置错误导致的显示问题

**执行方法**：
```bash
mysql -u root -p --default-character-set=utf8mb4 < database/fix-all-chinese-data.sql
```

**修复内容**：
- 用户表的真实姓名
- 添加剂分类名称和描述
- 食品添加剂名称和说明
- 供应商信息
- 库存仓库位置
- 使用记录的用途和部门
- 检测报告的机构和结果
- 预警内容
- 操作日志

---

### 3. `fix-supplier-data.sql` 🏢 供应商修复脚本
**用途**：单独修复供应商表的数据

**使用场景**：
- 仅需要更新供应商数据
- 供应商信息出现乱码

**执行方法**：
```bash
mysql -u root -p --default-character-set=utf8mb4 < database/fix-supplier-data.sql
```

---

### 4. `SCHEMA_CHANGES.md` 📝 变更记录
**用途**：记录数据库脚本的修复历史和变更内容

**包含信息**：
- 修复日期和内容
- 修复前后的数据对比
- 验证结果
- 使用建议

---

## 🚀 快速开始

### 首次安装
```bash
# 1. 进入项目目录
cd food-additive-system

# 2. 执行初始化脚本
mysql -u root -p --default-character-set=utf8mb4 < database/complete-schema.sql

# 3. 输入MySQL密码
# 密码：sdc1534260.0

# 4. 验证安装
mysql -u root -p -e "USE food_additive_system; SHOW TABLES;"
```

### 修复中文乱码
```bash
# 执行中文修复脚本
mysql -u root -p --default-character-set=utf8mb4 < database/fix-all-chinese-data.sql
```

---

## 📊 数据库结构

### 表列表（10张表）

| 表名 | 中文名称 | 记录数 | 说明 |
|------|----------|--------|------|
| sys_user | 系统用户表 | 3 | 管理员和普通用户 |
| additive_category | 添加剂分类表 | 6 | 防腐剂、抗氧化剂等分类 |
| food_additive | 食品添加剂表 | 7 | 添加剂详细信息 |
| supplier | 供应商表 | 3 | 供应商基本信息 |
| purchase_record | 采购记录表 | 5 | 采购历史记录 |
| inventory | 库存表 | 7 | 当前库存信息 |
| usage_record | 使用记录表 | 5 | 添加剂使用记录 |
| test_report | 检测报告表 | 3 | 质量检测报告 |
| warning | 预警表 | 2 | 库存预警信息 |
| operation_log | 操作日志表 | 4 | 系统操作日志 |

### 外键关系（12个）

```
food_additive → additive_category (分类关联)
purchase_record → food_additive (添加剂关联)
purchase_record → supplier (供应商关联)
purchase_record → sys_user (采购员关联)
inventory → food_additive (添加剂关联)
usage_record → food_additive (添加剂关联)
usage_record → sys_user (使用人关联)
test_report → food_additive (添加剂关联)
warning → food_additive (添加剂关联)
warning → inventory (库存关联)
warning → sys_user (处理人关联)
operation_log → sys_user (操作人关联)
```

---

## 🔐 默认账号

### 管理员账号
- **用户名**：admin
- **密码**：123456
- **角色**：ADMIN
- **邮箱**：admin@example.com

### 普通用户账号1
- **用户名**：user1
- **密码**：123456
- **角色**：USER
- **真实姓名**：张三

### 普通用户账号2
- **用户名**：user2
- **密码**：123456
- **角色**：USER
- **真实姓名**：李四

---

## ⚙️ 字符集配置

### 数据库字符集
```sql
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
```

### 表字符集
所有表都使用：
```sql
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
```

### 执行脚本时的字符集
务必使用 `--default-character-set=utf8mb4` 参数：
```bash
mysql -u root -p --default-character-set=utf8mb4 < script.sql
```

---

## 🛠️ 常见问题

### Q1: 中文显示乱码怎么办？
**A**: 执行 `fix-all-chinese-data.sql` 脚本修复

### Q2: 如何重置数据库？
**A**: 重新执行 `complete-schema.sql` 脚本

### Q3: 如何备份数据库？
**A**: 
```bash
mysqldump -u root -p --default-character-set=utf8mb4 food_additive_system > backup.sql
```

### Q4: 如何恢复备份？
**A**: 
```bash
mysql -u root -p --default-character-set=utf8mb4 food_additive_system < backup.sql
```

### Q5: 外键约束导致删除失败？
**A**: 
```sql
SET FOREIGN_KEY_CHECKS = 0;
-- 执行删除操作
SET FOREIGN_KEY_CHECKS = 1;
```

---

## 📞 技术支持

如有问题，请查看：
1. `SCHEMA_CHANGES.md` - 变更记录
2. 项目文档
3. 联系开发团队

---

## 📅 更新日志

### 2025-10-31
- ✅ 修复供应商表数据，使用更完整的公司名称
- ✅ 添加供应商备注字段
- ✅ 更新库存数量（ID=1 从 80.00 改为 81.00）
- ✅ 优化脚本注释，添加使用说明
- ✅ 验证所有中文数据显示正常

### 初始版本
- ✅ 创建完整的数据库结构
- ✅ 添加初始测试数据
- ✅ 配置外键关联关系

