import request from '@/utils/request'

// 查询预警列表
export function getWarningList(params) {
  return request({
    url: '/api/admin/warnings',
    method: 'get',
    params
  })
}

// 查询预警详情
export function getWarningDetail(id) {
  return request({
    url: `/api/admin/warnings/${id}`,
    method: 'get'
  })
}

// 新增预警
export function addWarning(data) {
  return request({
    url: '/api/admin/warnings',
    method: 'post',
    data
  })
}

// 更新预警
export function updateWarning(data) {
  return request({
    url: '/api/admin/warnings',
    method: 'put',
    data
  })
}

// 删除预警
export function deleteWarning(id) {
  return request({
    url: `/api/admin/warnings/${id}`,
    method: 'delete'
  })
}

