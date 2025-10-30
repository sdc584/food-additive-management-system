import request from '@/utils/request'

/**
 * 获取用户列表
 */
export function getUserList(params) {
  return request({
    url: '/sysUsers',
    method: 'get',
    params
  })
}

/**
 * 根据ID获取用户详情
 */
export function getUserById(id) {
  return request({
    url: `/sysUsers/${id}`,
    method: 'get'
  })
}

/**
 * 创建用户
 */
export function createUser(data) {
  return request({
    url: '/sysUsers',
    method: 'post',
    data
  })
}

/**
 * 更新用户
 */
export function updateUser(data) {
  return request({
    url: `/sysUsers/${data.userId}`,
    method: 'put',
    data
  })
}

/**
 * 删除用户
 */
export function deleteUser(id) {
  return request({
    url: `/sysUsers/${id}`,
    method: 'delete'
  })
}

/**
 * 重置密码
 */
export function resetPassword(userId) {
  return request({
    url: `/sysUsers/${userId}/resetPassword`,
    method: 'put'
  })
}

