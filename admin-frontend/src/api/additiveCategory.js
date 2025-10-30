import request from '@/utils/request'

/**
 * 添加剂分类API
 */

// 查询分类列表
export function getCategoryList(params) {
  return request({
    url: '/api/admin/additiveCategories',
    method: 'get',
    params
  })
}

// 查询分类详情
export function getCategoryById(id) {
  return request({
    url: `/api/admin/additiveCategories/${id}`,
    method: 'get'
  })
}

// 新增分类
export function addCategory(data) {
  return request({
    url: '/api/admin/additiveCategories',
    method: 'post',
    data
  })
}

// 更新分类
export function updateCategory(data) {
  return request({
    url: '/api/admin/additiveCategories',
    method: 'put',
    data
  })
}

// 删除分类
export function deleteCategory(id) {
  return request({
    url: `/api/admin/additiveCategories/${id}`,
    method: 'delete'
  })
}

