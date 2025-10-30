import request from '@/utils/request'

/**
 * 获取预警列表
 */
export function getWarningList(params) {
  return request({
    url: '/warnings',
    method: 'get',
    params
  })
}

/**
 * 获取预警统计
 */
export function getWarningStats() {
  return request({
    url: '/warnings/stats',
    method: 'get'
  })
}

/**
 * 根据ID获取预警详情
 */
export function getWarningById(id) {
  return request({
    url: `/warnings/${id}`,
    method: 'get'
  })
}

