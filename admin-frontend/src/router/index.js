import Vue from 'vue'
import VueRouter from 'vue-router'
import Layout from '@/layout/index.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '首页', icon: 'el-icon-s-home' }
      },
      // 添加剂管理
      {
        path: 'additive/list',
        name: 'AdditiveList',
        component: () => import('@/views/additive/AdditiveList.vue'),
        meta: { title: '添加剂列表', icon: 'el-icon-s-goods' }
      },
      {
        path: 'additive/category',
        name: 'CategoryManage',
        component: () => import('@/views/additive/CategoryManage.vue'),
        meta: { title: '分类管理', icon: 'el-icon-s-operation' }
      },
      // 库存管理
      {
        path: 'inventory/list',
        name: 'InventoryList',
        component: () => import('@/views/inventory/InventoryList.vue'),
        meta: { title: '库存列表', icon: 'el-icon-s-data' }
      },
      {
        path: 'inventory/warning',
        name: 'WarningManage',
        component: () => import('@/views/inventory/WarningManage.vue'),
        meta: { title: '预警管理', icon: 'el-icon-warning' }
      },
      // 供应商管理
      {
        path: 'supplier/list',
        name: 'SupplierList',
        component: () => import('@/views/supplier/SupplierList.vue'),
        meta: { title: '供应商列表', icon: 'el-icon-s-shop' }
      },
      {
        path: 'supplier/purchase',
        name: 'PurchaseRecord',
        component: () => import('@/views/supplier/PurchaseRecord.vue'),
        meta: { title: '采购记录', icon: 'el-icon-s-order' }
      },
      // 使用记录
      {
        path: 'usage',
        name: 'UsageRecord',
        component: () => import('@/views/UsageRecord.vue'),
        meta: { title: '使用记录', icon: 'el-icon-document' }
      },
      // 检测报告
      {
        path: 'test-report',
        name: 'TestReport',
        component: () => import('@/views/TestReport.vue'),
        meta: { title: '检测报告', icon: 'el-icon-document-checked' }
      },
      // 操作日志
      {
        path: 'operation-log',
        name: 'OperationLog',
        component: () => import('@/views/OperationLog.vue'),
        meta: { title: '操作日志', icon: 'el-icon-tickets' }
      },
      // 用户管理
      {
        path: 'user-manage',
        name: 'UserManage',
        component: () => import('@/views/UserManage.vue'),
        meta: { title: '用户管理', icon: 'el-icon-user' }
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'hash',
  base: process.env.BASE_URL,
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')

  if (to.path !== '/login' && !token) {
    // 未登录，重定向到登录页
    next('/login')
  } else if (to.path === '/login' && token) {
    // 已登录用户访问登录页，重定向到首页
    next('/dashboard')
  } else {
    next()
  }
})

// 解决 NavigationDuplicated 错误
const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => {
    if (err.name !== 'NavigationDuplicated') {
      throw err
    }
  })
}

export default router

