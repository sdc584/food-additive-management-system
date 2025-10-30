import request from '@/utils/request'

/**
 * 获取库存列表
 */
export function getInventoryList(params) {
  return request({
    url: '/inventories',
    method: 'get',
    params
  })
}

/**
 * 根据ID获取库存详情
 */
export function getInventoryById(id) {
  return request({
    url: `/inventories/${id}`,
    method: 'get'
  })
}

/**
 * 根据添加剂ID获取库存信息
 */
export function getInventoryByAdditiveId(additiveId) {
  return request({
    url: `/inventories/additive/${additiveId}`,
    method: 'get'
  })
}

