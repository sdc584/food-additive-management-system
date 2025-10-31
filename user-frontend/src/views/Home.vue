<template>
  <div class="home-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="header-content">
        <div class="logo">
          <i class="el-icon-s-shop"></i>
          <span>食品添加剂管理系统</span>
        </div>
        <div class="user-info" v-if="userInfo.username">
          <el-dropdown @command="handleCommand">
            <span class="user-name">
              <i class="el-icon-user"></i>
              {{ userInfo.realName || userInfo.username }}
              <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人信息</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
        <div class="login-btn" v-else>
          <el-button type="primary" size="small" @click="$router.push('/login')">登录</el-button>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 侧边栏 -->
      <div class="sidebar">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          @select="handleMenuSelect">
          <el-menu-item index="dashboard">
            <i class="el-icon-s-home"></i>
            <span>工作台</span>
          </el-menu-item>
          <el-menu-item index="additives">
            <i class="el-icon-s-goods"></i>
            <span>添加剂查询</span>
          </el-menu-item>
          <el-menu-item index="inventory">
            <i class="el-icon-s-data"></i>
            <span>库存查看</span>
          </el-menu-item>
          <el-menu-item index="usage">
            <i class="el-icon-s-order"></i>
            <span>使用记录</span>
          </el-menu-item>
          <el-menu-item index="warnings">
            <i class="el-icon-warning"></i>
            <span>预警信息</span>
          </el-menu-item>
        </el-menu>
      </div>

      <!-- 内容区域 -->
      <div class="content-area">
        <!-- 欢迎卡片 -->
        <div class="welcome-card">
          <div class="welcome-text">
            <h2>欢迎使用食品添加剂管理系统</h2>
            <p>智能化管理，让食品安全更有保障</p>
          </div>
          <div class="welcome-image">
            <i class="el-icon-s-marketing"></i>
          </div>
        </div>

        <!-- 统计卡片 -->
        <el-row :gutter="20" class="stats-row">
          <el-col :xs="12" :sm="12" :md="6">
            <div class="stat-card stat-card-1">
              <div class="stat-icon">
                <i class="el-icon-s-goods"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.additiveCount }}</div>
                <div class="stat-label">添加剂种类</div>
              </div>
            </div>
          </el-col>
          <el-col :xs="12" :sm="12" :md="6">
            <div class="stat-card stat-card-2">
              <div class="stat-icon">
                <i class="el-icon-s-data"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ formatNumber(stats.inventoryTotal) }}</div>
                <div class="stat-label">库存总量(kg)</div>
              </div>
            </div>
          </el-col>
          <el-col :xs="12" :sm="12" :md="6">
            <div class="stat-card stat-card-3">
              <div class="stat-icon">
                <i class="el-icon-warning"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.warningCount }}</div>
                <div class="stat-label">预警信息</div>
              </div>
            </div>
          </el-col>
          <el-col :xs="12" :sm="12" :md="6">
            <div class="stat-card stat-card-4">
              <div class="stat-icon">
                <i class="el-icon-s-order"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.usageCount }}</div>
                <div class="stat-label">本月使用</div>
              </div>
            </div>
          </el-col>
        </el-row>

        <!-- 快捷功能 -->
        <div class="quick-actions">
          <h3 class="section-title">快捷功能</h3>
          <el-row :gutter="20">
            <el-col :xs="12" :sm="6" :md="6">
              <div class="action-card" @click="handleAction('search')">
                <div class="action-icon action-icon-1">
                  <i class="el-icon-search"></i>
                </div>
                <p>添加剂查询</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="6" :md="6">
              <div class="action-card" @click="handleAction('inventory')">
                <div class="action-icon action-icon-2">
                  <i class="el-icon-s-data"></i>
                </div>
                <p>库存查看</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="6" :md="6">
              <div class="action-card" @click="handleAction('record')">
                <div class="action-icon action-icon-3">
                  <i class="el-icon-document"></i>
                </div>
                <p>使用登记</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="6" :md="6">
              <div class="action-card" @click="handleAction('report')">
                <div class="action-icon action-icon-4">
                  <i class="el-icon-s-marketing"></i>
                </div>
                <p>检测报告</p>
              </div>
            </el-col>
          </el-row>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getDashboardStats } from '@/api/dashboard'

export default {
  name: 'Home',
  data() {
    return {
      activeMenu: 'dashboard',
      stats: {
        additiveCount: 0,
        inventoryTotal: 0,
        warningCount: 0,
        usageCount: 0
      }
    }
  },
  computed: {
    userInfo() {
      return this.$store.state.userInfo || {}
    }
  },
  mounted() {
    this.loadStats()
  },
  methods: {
    // 加载统计数据
    async loadStats() {
      try {
        const res = await getDashboardStats()
        if (res.code === 200) {
          this.stats = res.data
        }
      } catch (error) {
        console.error('加载统计数据失败', error)
        this.$message.error('加载统计数据失败')
      }
    },
    // 格式化数字（添加千分位）
    formatNumber(num) {
      if (num === null || num === undefined) return '0'
      return num.toLocaleString('zh-CN', { maximumFractionDigits: 2 })
    },
    handleMenuSelect(index) {
      this.activeMenu = index
      const routeMap = {
        'dashboard': '/home',
        'additives': '/additive-query',
        'inventory': '/inventory-query',
        'usage': '/usage-register',
        'warnings': '/warning'
      }
      if (routeMap[index]) {
        // 避免重复导航到当前路由
        if (this.$route.path !== routeMap[index]) {
          this.$router.push(routeMap[index]).catch(err => {
            // 忽略导航重复错误
            if (err.name !== 'NavigationDuplicated') {
              console.error(err)
            }
          })
        }
      } else {
        this.$message.info(`功能开发中: ${index}`)
      }
    },
    handleCommand(command) {
      if (command === 'logout') {
        this.$confirm('确定要退出登录吗?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$store.dispatch('logout')
          this.$router.push('/login')
          this.$message.success('已退出登录')
        })
      } else if (command === 'profile') {
        this.$router.push('/profile')
      }
    },
    handleAction(action) {
      const actionMap = {
        'search': '/additive-query',
        'inventory': '/inventory-query',
        'record': '/usage-register'
      }
      if (actionMap[action]) {
        this.$router.push(actionMap[action])
      } else {
        this.$message.info(`${action} 功能开发中`)
      }
    }
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  background: #f0f2f5;
}

/* 顶部导航栏 */
.header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
  font-size: 20px;
  font-weight: bold;
  color: #667eea;
}

.logo i {
  font-size: 28px;
  margin-right: 10px;
}

.user-name {
  cursor: pointer;
  color: #333;
  font-size: 14px;
}

.user-name:hover {
  color: #667eea;
}

/* 主要内容区域 */
.main-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  gap: 20px;
}

/* 侧边栏 */
.sidebar {
  width: 200px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  height: fit-content;
}

.sidebar-menu {
  border: none;
}

.sidebar-menu .el-menu-item {
  height: 50px;
  line-height: 50px;
}

.sidebar-menu .el-menu-item i {
  margin-right: 8px;
  font-size: 18px;
}

/* 内容区域 */
.content-area {
  flex: 1;
}

/* 欢迎卡片 */
.welcome-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 40px;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.welcome-text h2 {
  font-size: 28px;
  margin-bottom: 10px;
}

.welcome-text p {
  font-size: 16px;
  opacity: 0.9;
}

.welcome-image i {
  font-size: 100px;
  opacity: 0.3;
}

/* 统计卡片 */
.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30px;
  margin-right: 15px;
}

.stat-card-1 .stat-icon {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.stat-card-2 .stat-icon {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.stat-card-3 .stat-icon {
  background: linear-gradient(135deg, #ffa751 0%, #ffe259 100%);
  color: white;
}

.stat-card-4 .stat-icon {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #999;
}

/* 快捷功能 */
.quick-actions {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.quick-actions .section-title {
  margin: 0 0 20px 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.action-card {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 30px 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  border: 2px solid transparent;
  margin-bottom: 20px;
}

.action-card:hover {
  background: white;
  border-color: #667eea;
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.action-card .action-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 15px;
  color: white;
}

.action-card .action-icon i {
  font-size: 30px;
}

.action-card .action-icon-1 {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.action-card .action-icon-2 {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.action-card .action-icon-3 {
  background: linear-gradient(135deg, #ffa751 0%, #ffe259 100%);
}

.action-card .action-icon-4 {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.action-card p {
  margin: 0;
  color: #333;
  font-size: 14px;
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .main-content {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
    margin-bottom: 20px;
  }

  .welcome-card {
    padding: 30px 20px;
  }

  .welcome-image {
    display: none;
  }

  .stat-card {
    margin-bottom: 15px;
  }
}
</style>

