/**
 * 个人中心API模块
 * 提供用户个人信息管理相关接口
 *
 * @author 系统
 * @since 2025-01-01
 */
import request from '@/utils/request'

/**
 * 获取当前用户信息
 * @returns {Promise} 返回用户详细信息
 */
export function getUserProfile() {
  return request({
    url: '/profile',
    method: 'get'
  })
}

/**
 * 更新用户信息
 * @param {Object} data - 用户信息对象
 * @param {String} data.realName - 真实姓名
 * @param {String} data.phone - 联系电话
 * @param {String} data.email - 邮箱地址
 * @param {String} data.department - 部门
 * @returns {Promise} 返回更新结果
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
 * @param {Object} data - 密码信息对象
 * @param {String} data.oldPassword - 原密码
 * @param {String} data.newPassword - 新密码
 * @returns {Promise} 返回修改结果
 */
export function changePassword(data) {
  return request({
    url: '/profile/password',
    method: 'put',
    data
  })
}

