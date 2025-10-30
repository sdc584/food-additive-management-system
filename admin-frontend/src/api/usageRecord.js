import request from '@/utils/request'

// 查询使用记录列表
export function getUsageRecordList(params) {
  return request({
    url: '/api/admin/usageRecords',
    method: 'get',
    params
  })
}

// 查询使用记录详情
export function getUsageRecordDetail(id) {
  return request({
    url: `/api/admin/usageRecords/${id}`,
    method: 'get'
  })
}

// 新增使用记录
export function addUsageRecord(data) {
  return request({
    url: '/api/admin/usageRecords',
    method: 'post',
    data
  })
}

// 更新使用记录
export function updateUsageRecord(data) {
  return request({
    url: '/api/admin/usageRecords',
    method: 'put',
    data
  })
}

// 删除使用记录
export function deleteUsageRecord(id) {
  return request({
    url: `/api/admin/usageRecords/${id}`,
    method: 'delete'
  })
}

// 审核使用记录
export function auditUsageRecord(id, data) {
  return request({
    url: `/api/admin/usageRecords/${id}/audit`,
    method: 'put',
    data
  })
}

