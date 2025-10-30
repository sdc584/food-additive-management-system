# 食品添加剂管理系统 - API接口文档

## 📋 系统概述

本系统包含两个后端服务：
- **用户端后端**: http://localhost:8081/api/user
- **管理端后端**: http://localhost:8082/api/admin

## 🔍 API测试结果

### ✅ 正常工作的API (12个)

#### 用户端 (6个)
1. ✅ 食品添加剂列表: `GET /api/user/foodAdditives`
2. ✅ 食品添加剂详情: `GET /api/user/foodAdditives/{id}`
3. ✅ 供应商列表: `GET /api/user/suppliers`
4. ✅ 供应商详情: `GET /api/user/suppliers/{id}`
5. ✅ 检测报告列表: `GET /api/user/testReports`
6. ✅ 检测报告详情: `GET /api/user/testReports/{id}`

#### 管理端 (6个)
1. ✅ 食品添加剂列表: `GET /api/admin/foodAdditives`
2. ✅ 食品添加剂详情: `GET /api/admin/foodAdditives/{id}`
3. ✅ 供应商列表: `GET /api/admin/suppliers`
4. ✅ 供应商详情: `GET /api/admin/suppliers/{id}`
5. ✅ 检测报告列表: `GET /api/admin/testReports`
6. ✅ 检测报告详情: `GET /api/admin/testReports/{id}`

### ❌ 404错误 - 路径映射问题 (8个)

这些API的Controller使用了错误的复数形式：

#### 用户端
1. ❌ 添加剂分类: `/additiveCategories` → 应该是 `/additiveCategorys`
2. ❌ 库存: `/inventories` → 应该是 `/inventorys`

#### 管理端
1. ❌ 添加剂分类: `/additiveCategories` → 应该是 `/additiveCategorys`
2. ❌ 库存: `/inventories` → 应该是 `/inventorys`

### ❌ 500错误 - 数据库或业务逻辑问题 (16个)

这些API可能存在数据库查询错误或业务逻辑问题：

#### 用户端
1. ❌ 采购记录列表: `GET /api/user/purchaseRecords`
2. ❌ 采购记录详情: `GET /api/user/purchaseRecords/{id}`
3. ❌ 使用记录列表: `GET /api/user/usageRecords`
4. ❌ 使用记录详情: `GET /api/user/usageRecords/{id}`
5. ❌ 预警列表: `GET /api/user/warnings`
6. ❌ 预警详情: `GET /api/user/warnings/{id}`
7. ❌ 操作日志列表: `GET /api/user/operationLogs`
8. ❌ 操作日志详情: `GET /api/user/operationLogs/{id}`

#### 管理端
1. ❌ 采购记录列表: `GET /api/admin/purchaseRecords`
2. ❌ 采购记录详情: `GET /api/admin/purchaseRecords/{id}`
3. ❌ 使用记录列表: `GET /api/admin/usageRecords`
4. ❌ 使用记录详情: `GET /api/admin/usageRecords/{id}`
5. ❌ 预警列表: `GET /api/admin/warnings`
6. ❌ 预警详情: `GET /api/admin/warnings/{id}`
7. ❌ 操作日志列表: `GET /api/admin/operationLogs`
8. ❌ 操作日志详情: `GET /api/admin/operationLogs/{id}`

## 📊 完整API列表

### 用户端API (http://localhost:8081/api/user)

#### 1. 认证接口
- `POST /auth/login` - 用户登录
- `GET /auth/userInfo` - 获取用户信息

#### 2. 食品添加剂接口
- `GET /foodAdditives` - 查询列表 ✅
- `GET /foodAdditives/{id}` - 查询详情 ✅

#### 3. 添加剂分类接口
- `GET /additiveCategorys` - 查询列表 (注意:复数形式)
- `GET /additiveCategorys/{id}` - 查询详情

#### 4. 库存接口
- `GET /inventorys` - 查询列表 (注意:复数形式)
- `GET /inventorys/{id}` - 查询详情

#### 5. 供应商接口
- `GET /suppliers` - 查询列表 ✅
- `GET /suppliers/{id}` - 查询详情 ✅

#### 6. 采购记录接口
- `GET /purchaseRecords` - 查询列表 ❌
- `GET /purchaseRecords/{id}` - 查询详情 ❌

#### 7. 使用记录接口
- `GET /usageRecords` - 查询列表 ❌
- `GET /usageRecords/{id}` - 查询详情 ❌

#### 8. 检测报告接口
- `GET /testReports` - 查询列表 ✅
- `GET /testReports/{id}` - 查询详情 ✅

#### 9. 预警接口
- `GET /warnings` - 查询列表 ❌
- `GET /warnings/{id}` - 查询详情 ❌

#### 10. 操作日志接口
- `GET /operationLogs` - 查询列表 ❌
- `GET /operationLogs/{id}` - 查询详情 ❌

### 管理端API (http://localhost:8082/api/admin)

#### 1. 认证接口
- `POST /auth/login` - 管理员登录
- `GET /auth/userInfo` - 获取管理员信息

#### 2. 食品添加剂接口 (完整CRUD)
- `GET /foodAdditives` - 查询列表 ✅
- `GET /foodAdditives/{id}` - 查询详情 ✅
- `POST /foodAdditives` - 新增
- `PUT /foodAdditives` - 更新
- `DELETE /foodAdditives/{id}` - 删除

#### 3. 添加剂分类接口 (完整CRUD)
- `GET /additiveCategorys` - 查询列表 (注意:复数形式)
- `GET /additiveCategorys/{id}` - 查询详情
- `POST /additiveCategorys` - 新增
- `PUT /additiveCategorys` - 更新
- `DELETE /additiveCategorys/{id}` - 删除

#### 4. 库存接口 (完整CRUD)
- `GET /inventorys` - 查询列表 (注意:复数形式)
- `GET /inventorys/{id}` - 查询详情
- `POST /inventorys` - 新增
- `PUT /inventorys` - 更新
- `DELETE /inventorys/{id}` - 删除

#### 5. 供应商接口 (完整CRUD)
- `GET /suppliers` - 查询列表 ✅
- `GET /suppliers/{id}` - 查询详情 ✅
- `POST /suppliers` - 新增
- `PUT /suppliers` - 更新
- `DELETE /suppliers/{id}` - 删除

#### 6. 采购记录接口 (完整CRUD)
- `GET /purchaseRecords` - 查询列表 ❌
- `GET /purchaseRecords/{id}` - 查询详情 ❌
- `POST /purchaseRecords` - 新增
- `PUT /purchaseRecords` - 更新
- `DELETE /purchaseRecords/{id}` - 删除

#### 7. 使用记录接口 (完整CRUD)
- `GET /usageRecords` - 查询列表 ❌
- `GET /usageRecords/{id}` - 查询详情 ❌
- `POST /usageRecords` - 新增
- `PUT /usageRecords` - 更新
- `DELETE /usageRecords/{id}` - 删除

#### 8. 检测报告接口 (完整CRUD)
- `GET /testReports` - 查询列表 ✅
- `GET /testReports/{id}` - 查询详情 ✅
- `POST /testReports` - 新增
- `PUT /testReports` - 更新
- `DELETE /testReports/{id}` - 删除

#### 9. 预警接口 (完整CRUD)
- `GET /warnings` - 查询列表 ❌
- `GET /warnings/{id}` - 查询详情 ❌
- `POST /warnings` - 新增
- `PUT /warnings` - 更新
- `DELETE /warnings/{id}` - 删除

#### 10. 操作日志接口 (完整CRUD)
- `GET /operationLogs` - 查询列表 ❌
- `GET /operationLogs/{id}` - 查询详情 ❌
- `POST /operationLogs` - 新增
- `PUT /operationLogs` - 更新
- `DELETE /operationLogs/{id}` - 删除

## 🔧 修复进度

### ✅ 已修复：路径映射问题 (404错误)

已修改以下Controller的`@RequestMapping`注解：

**用户端后端**:
- ✅ `AdditiveCategoryController`: `/additiveCategorys` → `/additiveCategories`
- ✅ `InventoryController`: `/inventorys` → `/inventories`

**管理端后端**:
- ✅ `AdditiveCategoryController`: `/additiveCategorys` → `/additiveCategories`
- ✅ `InventoryController`: `/inventorys` → `/inventories`

**修复文件**:
- `user-backend/src/main/java/com/foodadditive/user/controller/AdditiveCategoryController.java`
- `user-backend/src/main/java/com/foodadditive/user/controller/InventoryController.java`
- `admin-backend/src/main/java/com/foodadditive/admin/controller/AdditiveCategoryController.java`
- `admin-backend/src/main/java/com/foodadditive/admin/controller/InventoryController.java`

**注意**: 需要重启后端服务才能生效！

### ⏳ 待修复：500错误问题

需要检查以下Controller的数据库查询和业务逻辑：
- `PurchaseRecordController`
- `UsageRecordController`
- `WarningController`
- `OperationLogController`

可能的原因：
- 数据库表中没有数据
- SQL查询语句错误
- 实体类字段映射错误
- 外键关联查询失败
- MyBatis Plus配置问题

## 📈 测试统计

- **总测试数**: 36
- **通过**: 12 (33.33%)
- **失败**: 24 (66.67%)
  - 404错误: 8个
  - 500错误: 16个

## 🎯 建议

1. **立即修复**: 路径映射问题（简单，影响大）
2. **优先修复**: 500错误的API（需要调试）
3. **测试验证**: 修复后重新运行测试脚本

---

**测试时间**: 2025-10-31  
**测试工具**: PowerShell + Invoke-RestMethod

