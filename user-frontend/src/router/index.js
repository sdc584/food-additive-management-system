import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/additive-query',
    name: 'AdditiveQuery',
    component: () => import('@/views/AdditiveQuery.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/inventory-query',
    name: 'InventoryQuery',
    component: () => import('@/views/InventoryQuery.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/usage-register',
    name: 'UsageRegister',
    component: () => import('@/views/UsageRegister.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/test-report',
    name: 'TestReportView',
    component: () => import('@/views/TestReportView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/warning',
    name: 'WarningView',
    component: () => import('@/views/WarningView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile.vue'),
    meta: { requiresAuth: true }
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

  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router

