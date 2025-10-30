import request from '@/utils/request'

// 查询采购记录列表
export function getPurchaseRecordList(params) {
  return request({
    url: '/api/admin/purchaseRecords',
    method: 'get',
    params
  })
}

// 查询采购记录详情
export function getPurchaseRecordDetail(id) {
  return request({
    url: `/api/admin/purchaseRecords/${id}`,
    method: 'get'
  })
}

// 新增采购记录
export function addPurchaseRecord(data) {
  return request({
    url: '/api/admin/purchaseRecords',
    method: 'post',
    data
  })
}

// 更新采购记录
export function updatePurchaseRecord(data) {
  return request({
    url: '/api/admin/purchaseRecords',
    method: 'put',
    data
  })
}

// 删除采购记录
export function deletePurchaseRecord(id) {
  return request({
    url: `/api/admin/purchaseRecords/${id}`,
    method: 'delete'
  })
}

