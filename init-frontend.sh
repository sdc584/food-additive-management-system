#!/bin/bash

# 食品添加剂管理系统 - 前端初始化脚本

echo "========================================="
echo "食品添加剂管理系统 - 前端初始化"
echo "========================================="
echo ""

# 检查Node.js是否安装
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未检测到Node.js，请先安装Node.js"
    echo "下载地址: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js版本: $(node -v)"
echo "✅ npm版本: $(npm -v)"
echo ""

# 检查Vue CLI是否安装
if ! command -v vue &> /dev/null; then
    echo "⚠️  未检测到Vue CLI，正在安装..."
    npm install -g @vue/cli
    echo "✅ Vue CLI安装完成"
fi

echo "✅ Vue CLI版本: $(vue --version)"
echo ""

# 选择要初始化的项目
echo "请选择要初始化的项目:"
echo "1. 用户端前端 (user-frontend)"
echo "2. 管理端前端 (admin-frontend)"
echo "3. 全部初始化"
read -p "请输入选项 (1-3): " choice

init_user_frontend() {
    echo ""
    echo "========================================="
    echo "初始化用户端前端..."
    echo "========================================="
    
    cd user-frontend
    
    # 创建package.json
    cat > package.json << 'EOF'
{
  "name": "user-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve --port 8080",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "core-js": "^3.8.3",
    "element-ui": "^2.15.14",
    "js-cookie": "^3.0.5",
    "vue": "^2.6.14",
    "vue-router": "^3.5.1",
    "vuex": "^3.6.2"
  },
  "devDependencies": {
    "@vue/cli-plugin-babel": "~5.0.0",
    "@vue/cli-plugin-eslint": "~5.0.0",
    "@vue/cli-plugin-router": "~5.0.0",
    "@vue/cli-plugin-vuex": "~5.0.0",
    "@vue/cli-service": "~5.0.0",
    "babel-eslint": "^10.1.0",
    "eslint": "^7.32.0",
    "eslint-plugin-vue": "^8.0.3",
    "sass": "^1.32.7",
    "sass-loader": "^12.0.0",
    "vue-template-compiler": "^2.6.14"
  }
}
EOF

    # 创建vue.config.js
    cat > vue.config.js << 'EOF'
module.exports = {
  devServer: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true
      }
    }
  },
  lintOnSave: false
}
EOF

    # 创建.env文件
    cat > .env.development << 'EOF'
VUE_APP_BASE_API = 'http://localhost:8081/api/user'
EOF

    cat > .env.production << 'EOF'
VUE_APP_BASE_API = '/api/user'
EOF

    echo "✅ 用户端前端配置文件创建完成"
    echo "正在安装依赖..."
    npm install
    
    cd ..
    echo "✅ 用户端前端初始化完成！"
}

init_admin_frontend() {
    echo ""
    echo "========================================="
    echo "初始化管理端前端..."
    echo "========================================="
    
    cd admin-frontend
    
    # 创建package.json
    cat > package.json << 'EOF'
{
  "name": "admin-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve --port 8083",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "core-js": "^3.8.3",
    "element-ui": "^2.15.14",
    "js-cookie": "^3.0.5",
    "vue": "^2.6.14",
    "vue-router": "^3.5.1",
    "vuex": "^3.6.2",
    "echarts": "^5.4.3"
  },
  "devDependencies": {
    "@vue/cli-plugin-babel": "~5.0.0",
    "@vue/cli-plugin-eslint": "~5.0.0",
    "@vue/cli-plugin-router": "~5.0.0",
    "@vue/cli-plugin-vuex": "~5.0.0",
    "@vue/cli-service": "~5.0.0",
    "babel-eslint": "^10.1.0",
    "eslint": "^7.32.0",
    "eslint-plugin-vue": "^8.0.3",
    "sass": "^1.32.7",
    "sass-loader": "^12.0.0",
    "vue-template-compiler": "^2.6.14"
  }
}
EOF

    # 创建vue.config.js
    cat > vue.config.js << 'EOF'
module.exports = {
  devServer: {
    port: 8083,
    proxy: {
      '/api': {
        target: 'http://localhost:8082',
        changeOrigin: true
      }
    }
  },
  lintOnSave: false
}
EOF

    # 创建.env文件
    cat > .env.development << 'EOF'
VUE_APP_BASE_API = 'http://localhost:8082/api/admin'
EOF

    cat > .env.production << 'EOF'
VUE_APP_BASE_API = '/api/admin'
EOF

    echo "✅ 管理端前端配置文件创建完成"
    echo "正在安装依赖..."
    npm install
    
    cd ..
    echo "✅ 管理端前端初始化完成！"
}

# 根据选择执行
case $choice in
    1)
        init_user_frontend
        ;;
    2)
        init_admin_frontend
        ;;
    3)
        init_user_frontend
        init_admin_frontend
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "✅ 前端初始化完成！"
echo "========================================="
echo ""
echo "下一步:"
echo "1. 开发前端页面"
echo "2. 启动开发服务器:"
echo "   - 用户端: cd user-frontend && npm run serve"
echo "   - 管理端: cd admin-frontend && npm run serve"
echo ""

