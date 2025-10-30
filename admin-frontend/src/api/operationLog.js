import request from '@/utils/request'

// 查询操作日志列表
export function getOperationLogList(params) {
  return request({
    url: '/api/admin/operationLogs',
    method: 'get',
    params
  })
}

// 查询操作日志详情
export function getOperationLogDetail(id) {
  return request({
    url: `/api/admin/operationLogs/${id}`,
    method: 'get'
  })
}

// 导出操作日志
export function exportOperationLog(params) {
  return request({
    url: '/api/admin/operationLogs/export',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

