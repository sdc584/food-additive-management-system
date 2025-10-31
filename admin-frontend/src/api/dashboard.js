import request from '@/utils/request'

/**
 * 获取仪表盘统计数据
 */
export function getDashboardStats() {
  return request({
    url: '/api/admin/dashboard/stats',
    method: 'get'
  })
}

/**
 * 获取最近的操作日志
 */
export function getRecentLogs(limit = 5) {
  return request({
    url: '/api/admin/dashboard/recent-logs',
    method: 'get',
    params: { limit }
  })
}

/**
 * 获取添加剂分类统计数据
 */
export function getCategoryStats() {
  return request({
    url: '/api/admin/dashboard/category-stats',
    method: 'get'
  })
}

