<template>
  <div class="app-wrapper">
    <!-- 侧边栏 -->
    <div :class="['sidebar-container', { 'is-collapse': isCollapse }]">
      <div class="logo-container">
        <custom-logo class="logo" />
        <h1 v-if="!isCollapse" class="logo-title">食品添加剂管理</h1>
      </div>
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :unique-opened="true"
        background-color="#001529"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
        router
      >
        <el-menu-item index="/dashboard">
          <i class="el-icon-s-home"></i>
          <span slot="title">首页</span>
        </el-menu-item>
        <el-submenu index="additive">
          <template slot="title">
            <i class="el-icon-s-goods"></i>
            <span>添加剂管理</span>
          </template>
          <el-menu-item index="/additive/list">添加剂列表</el-menu-item>
          <el-menu-item index="/additive/category">分类管理</el-menu-item>
        </el-submenu>
        <el-submenu index="inventory">
          <template slot="title">
            <i class="el-icon-s-order"></i>
            <span>库存管理</span>
          </template>
          <el-menu-item index="/inventory/list">库存列表</el-menu-item>
          <el-menu-item index="/inventory/warning">预警管理</el-menu-item>
        </el-submenu>
        <el-submenu index="supplier">
          <template slot="title">
            <i class="el-icon-s-shop"></i>
            <span>供应商管理</span>
          </template>
          <el-menu-item index="/supplier/list">供应商列表</el-menu-item>
          <el-menu-item index="/supplier/purchase">采购记录</el-menu-item>
        </el-submenu>
        <el-menu-item index="/usage">
          <i class="el-icon-s-data"></i>
          <span slot="title">使用记录</span>
        </el-menu-item>
        <el-menu-item index="/test-report">
          <i class="el-icon-document-checked"></i>
          <span slot="title">检测报告</span>
        </el-menu-item>
        <el-menu-item index="/operation-log">
          <i class="el-icon-tickets"></i>
          <span slot="title">操作日志</span>
        </el-menu-item>
      </el-menu>
    </div>

    <!-- 主内容区 -->
    <div class="main-container">
      <!-- 顶部导航栏 -->
      <div class="navbar">
        <div class="navbar-left">
          <i :class="isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold'" @click="toggleSidebar"></i>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-if="$route.meta.title">{{ $route.meta.title }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="navbar-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32" src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"></el-avatar>
              <span class="username">{{ username }}</span>
              <i class="el-icon-arrow-down"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">
                <i class="el-icon-user"></i> 个人中心
              </el-dropdown-item>
              <el-dropdown-item command="settings">
                <i class="el-icon-setting"></i> 系统设置
              </el-dropdown-item>
              <el-dropdown-item divided command="logout">
                <i class="el-icon-switch-button"></i> 退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>

      <!-- 内容区域 -->
      <div class="app-main">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script>
import CustomLogo from '@/components/Logo.vue'

export default {
  name: 'Layout',
  components: {
    CustomLogo
  },
  data() {
    return {
      isCollapse: false
    }
  },
  computed: {
    activeMenu() {
      return this.$route.path
    },
    username() {
      const userInfo = this.$store.state.userInfo || {}
      return userInfo.realName || userInfo.username || 'Admin'
    }
  },
  methods: {
    toggleSidebar() {
      this.isCollapse = !this.isCollapse
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
          this.$message.success('退出成功')
        })
      } else if (command === 'profile') {
        this.$message.info('个人中心功能开发中...')
      } else if (command === 'settings') {
        this.$message.info('系统设置功能开发中...')
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.app-wrapper {
  display: flex;
  height: 100vh;
  width: 100%;
  overflow: hidden;
}

.sidebar-container {
  width: 210px;
  height: 100%;
  background-color: #001529;
  transition: width 0.28s;
  overflow-x: hidden;
  overflow-y: auto;

  &.is-collapse {
    width: 64px;
  }

  .logo-container {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    height: 64px;
    padding: 0 16px;
    background: rgba(255, 255, 255, 0.05);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);

    .logo {
      width: 32px;
      height: 32px;
      flex-shrink: 0;
    }

    .logo-title {
      margin-left: 12px;
      font-size: 16px;
      font-weight: 600;
      color: #fff;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }

  .el-menu {
    border-right: none;
  }
}

.main-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: #f0f2f5;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
  padding: 0 20px;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  z-index: 10;

  .navbar-left {
    display: flex;
    align-items: center;
    gap: 20px;

    i {
      font-size: 20px;
      cursor: pointer;
      transition: color 0.3s;

      &:hover {
        color: #409EFF;
      }
    }
  }

  .navbar-right {
    .user-info {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      padding: 8px 12px;
      border-radius: 4px;
      transition: background-color 0.3s;

      &:hover {
        background-color: #f5f7fa;
      }

      .username {
        font-size: 14px;
        color: #303133;
      }
    }
  }
}

.app-main {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

/* 滚动条样式 */
.sidebar-container::-webkit-scrollbar {
  width: 6px;
}

.sidebar-container::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.sidebar-container::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>

