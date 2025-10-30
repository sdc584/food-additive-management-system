import request from '@/utils/request'

/**
 * 获取使用记录列表
 */
export function getUsageRecordList(params) {
  return request({
    url: '/usageRecords',
    method: 'get',
    params
  })
}

/**
 * 获取我的使用记录
 */
export function getMyUsageRecords(params) {
  return request({
    url: '/usageRecords/my',
    method: 'get',
    params
  })
}

/**
 * 创建使用记录
 */
export function createUsageRecord(data) {
  return request({
    url: '/usageRecords',
    method: 'post',
    data
  })
}

/**
 * 根据ID获取使用记录详情
 */
export function getUsageRecordById(id) {
  return request({
    url: `/usageRecords/${id}`,
    method: 'get'
  })
}

