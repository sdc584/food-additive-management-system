#!/bin/bash

# 食品添加剂管理系统 - 项目结构初始化脚本

echo "开始创建项目结构..."

# 创建用户端后端目录结构
mkdir -p user-backend/src/main/java/com/foodadditive/user/{entity,mapper,service,controller,config,common,interceptor,aspect}
mkdir -p user-backend/src/main/resources/{mapper,static,templates}
mkdir -p user-backend/src/test/java/com/foodadditive/user

# 创建管理端后端目录结构
mkdir -p admin-backend/src/main/java/com/foodadditive/admin/{entity,mapper,service,controller,config,common,interceptor,aspect}
mkdir -p admin-backend/src/main/resources/{mapper,static,templates}
mkdir -p admin-backend/src/test/java/com/foodadditive/admin

# 创建用户端前端目录结构
mkdir -p user-frontend/src/{views,components,router,store,api,utils,assets}
mkdir -p user-frontend/public

# 创建管理端前端目录结构
mkdir -p admin-frontend/src/{views,components,router,store,api,utils,assets}
mkdir -p admin-frontend/public

echo "项目结构创建完成！"
echo ""
echo "项目结构："
echo "food-additive-system/"
echo "├── user-backend/          # 用户端后端 (端口: 8081)"
echo "├── admin-backend/         # 管理端后端 (端口: 8082)"
echo "├── user-frontend/         # 用户端前端 (端口: 8080)"
echo "├── admin-frontend/        # 管理端前端 (端口: 8083)"
echo "├── database/              # 数据库脚本"
echo "└── docs/                  # 文档资料"
echo ""
echo "下一步："
echo "1. 导入数据库: mysql -u root -p < database/schema.sql"
echo "2. 配置后端数据库连接"
echo "3. 启动后端服务"
echo "4. 启动前端服务"

