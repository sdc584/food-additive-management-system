import request from '@/utils/request'

/**
 * 食品添加剂API
 */

// 查询添加剂列表
export function getFoodAdditiveList(params) {
  return request({
    url: '/api/admin/foodAdditives',
    method: 'get',
    params
  })
}

// 查询添加剂详情
export function getFoodAdditiveById(id) {
  return request({
    url: `/api/admin/foodAdditives/${id}`,
    method: 'get'
  })
}

// 新增添加剂
export function addFoodAdditive(data) {
  return request({
    url: '/api/admin/foodAdditives',
    method: 'post',
    data
  })
}

// 更新添加剂
export function updateFoodAdditive(data) {
  return request({
    url: '/api/admin/foodAdditives',
    method: 'put',
    data
  })
}

// 删除添加剂
export function deleteFoodAdditive(id) {
  return request({
    url: `/api/admin/foodAdditives/${id}`,
    method: 'delete'
  })
}

