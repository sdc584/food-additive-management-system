import request from '@/utils/request'

/**
 * 供应商管理API
 */

// 查询供应商列表
export function getSupplierList(params) {
  return request({
    url: '/api/admin/suppliers',
    method: 'get',
    params
  })
}

// 查询供应商详情
export function getSupplierById(id) {
  return request({
    url: `/api/admin/suppliers/${id}`,
    method: 'get'
  })
}

// 新增供应商
export function addSupplier(data) {
  return request({
    url: '/api/admin/suppliers',
    method: 'post',
    data
  })
}

// 更新供应商
export function updateSupplier(data) {
  return request({
    url: '/api/admin/suppliers',
    method: 'put',
    data
  })
}

// 删除供应商
export function deleteSupplier(id) {
  return request({
    url: `/api/admin/suppliers/${id}`,
    method: 'delete'
  })
}

