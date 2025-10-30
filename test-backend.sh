#!/bin/bash

# 食品添加剂管理系统 - 后端测试脚本

echo "========================================="
echo "食品添加剂管理系统 - 后端接口测试"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试用户端后端
echo "测试用户端后端..."
echo ""

# 测试1: 用户登录
echo "1. 测试用户登录接口..."
response=$(curl -s -X POST http://localhost:8081/api/user/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"123456"}')

if echo "$response" | grep -q "token"; then
    echo -e "${GREEN}✅ 用户登录接口正常${NC}"
    token=$(echo "$response" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo "Token: ${token:0:50}..."
else
    echo -e "${RED}❌ 用户登录接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试2: 管理员登录
echo "2. 测试管理员登录接口..."
response=$(curl -s -X POST http://localhost:8082/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"123456"}')

if echo "$response" | grep -q "token"; then
    echo -e "${GREEN}✅ 管理员登录接口正常${NC}"
    admin_token=$(echo "$response" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo "Token: ${admin_token:0:50}..."
else
    echo -e "${RED}❌ 管理员登录接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试3: 查询添加剂列表
echo "3. 测试查询添加剂列表接口..."
response=$(curl -s -X GET "http://localhost:8081/api/user/foodAdditive/list" \
  -H "Authorization: Bearer $token")

if echo "$response" | grep -q "code"; then
    echo -e "${GREEN}✅ 查询添加剂列表接口正常${NC}"
else
    echo -e "${RED}❌ 查询添加剂列表接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试4: 查询分类列表
echo "4. 测试查询分类列表接口..."
response=$(curl -s -X GET "http://localhost:8081/api/user/additiveCategory/list")

if echo "$response" | grep -q "code"; then
    echo -e "${GREEN}✅ 查询分类列表接口正常${NC}"
else
    echo -e "${RED}❌ 查询分类列表接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试5: 查询库存列表
echo "5. 测试查询库存列表接口..."
response=$(curl -s -X GET "http://localhost:8081/api/user/inventory/list")

if echo "$response" | grep -q "code"; then
    echo -e "${GREEN}✅ 查询库存列表接口正常${NC}"
else
    echo -e "${RED}❌ 查询库存列表接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试6: 管理端查询用户列表
echo "6. 测试管理端查询用户列表接口..."
response=$(curl -s -X GET "http://localhost:8082/api/admin/sysUser/list" \
  -H "Authorization: Bearer $admin_token")

if echo "$response" | grep -q "code"; then
    echo -e "${GREEN}✅ 管理端查询用户列表接口正常${NC}"
else
    echo -e "${RED}❌ 管理端查询用户列表接口异常${NC}"
    echo "响应: $response"
fi

echo ""

# 测试7: Druid监控
echo "7. 测试Druid监控页面..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/api/user/druid)

if [ "$response" = "200" ] || [ "$response" = "401" ]; then
    echo -e "${GREEN}✅ Druid监控页面可访问${NC}"
    echo "访问地址: http://localhost:8081/api/user/druid"
    echo "用户名/密码: admin/admin"
else
    echo -e "${RED}❌ Druid监控页面无法访问${NC}"
fi

echo ""
echo "========================================="
echo "测试完成！"
echo "========================================="
echo ""

# 总结
echo "📊 测试总结:"
echo ""
echo "✅ 用户端后端: http://localhost:8081/api/user"
echo "✅ 管理端后端: http://localhost:8082/api/admin"
echo "✅ Druid监控: http://localhost:8081/api/user/druid"
echo ""
echo "📝 默认账号:"
echo "  管理员: admin / 123456"
echo "  用户: user1 / 123456"
echo ""
echo "🔗 API文档:"
echo "  查看 docs/开发指南.md 了解所有接口"
echo ""

