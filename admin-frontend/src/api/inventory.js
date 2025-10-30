import request from '@/utils/request'

/**
 * 库存管理API
 */

// 查询库存列表
export function getInventoryList(params) {
  return request({
    url: '/api/admin/inventories',
    method: 'get',
    params
  })
}

// 查询库存详情
export function getInventoryById(id) {
  return request({
    url: `/api/admin/inventories/${id}`,
    method: 'get'
  })
}

// 新增库存
export function addInventory(data) {
  return request({
    url: '/api/admin/inventories',
    method: 'post',
    data
  })
}

// 更新库存
export function updateInventory(data) {
  return request({
    url: '/api/admin/inventories',
    method: 'put',
    data
  })
}

// 删除库存
export function deleteInventory(id) {
  return request({
    url: `/api/admin/inventories/${id}`,
    method: 'delete'
  })
}

