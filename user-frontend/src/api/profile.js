import request from '@/utils/request'

/**
 * 获取当前用户信息
 */
export function getUserProfile() {
  return request({
    url: '/profile',
    method: 'get'
  })
}

/**
 * 更新用户信息
 */
export function updateUserProfile(data) {
  return request({
    url: '/profile',
    method: 'put',
    data
  })
}

/**
 * 修改密码
 */
export function changePassword(data) {
  return request({
    url: '/profile/password',
    method: 'put',
    data
  })
}

