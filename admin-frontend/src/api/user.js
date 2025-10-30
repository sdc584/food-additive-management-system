/**
 * 用户管理API模块
 * 提供用户CRUD、密码重置等功能接口
 *
 * @author 系统
 * @since 2025-01-01
 */
import request from '@/utils/request'

/**
 * 获取用户列表
 * @param {Object} params - 查询参数
 * @param {String} params.username - 用户名（模糊查询）
 * @param {String} params.realName - 真实姓名（模糊查询）
 * @param {String} params.role - 角色（admin/user）
 * @param {Number} params.status - 状态（1-启用，0-禁用）
 * @param {Number} params.currentPage - 当前页码
 * @param {Number} params.pageSize - 每页条数
 * @returns {Promise} 返回用户列表和分页信息
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
 * @param {Number} id - 用户ID
 * @returns {Promise} 返回用户详细信息
 */
export function getUserById(id) {
  return request({
    url: `/sysUsers/${id}`,
    method: 'get'
  })
}

/**
 * 创建用户
 * @param {Object} data - 用户信息对象
 * @param {String} data.username - 用户名（必填，3-20字符）
 * @param {String} data.realName - 真实姓名（必填）
 * @param {String} data.password - 密码（必填，6-20字符）
 * @param {String} data.role - 角色（必填，admin/user）
 * @param {String} data.phone - 联系电话
 * @param {String} data.email - 邮箱地址
 * @param {String} data.department - 部门
 * @param {Number} data.status - 状态（1-启用，0-禁用）
 * @returns {Promise} 返回创建结果
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
 * @param {Object} data - 用户信息对象
 * @param {Number} data.userId - 用户ID（必填）
 * @param {String} data.realName - 真实姓名
 * @param {String} data.role - 角色
 * @param {String} data.phone - 联系电话
 * @param {String} data.email - 邮箱地址
 * @param {String} data.department - 部门
 * @param {Number} data.status - 状态
 * @returns {Promise} 返回更新结果
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
 * @param {Number} id - 用户ID
 * @returns {Promise} 返回删除结果
 */
export function deleteUser(id) {
  return request({
    url: `/sysUsers/${id}`,
    method: 'delete'
  })
}

/**
 * 重置用户密码
 * 将用户密码重置为默认密码（123456）
 * @param {Number} userId - 用户ID
 * @returns {Promise} 返回重置结果
 */
export function resetPassword(userId) {
  return request({
    url: `/sysUsers/${userId}/resetPassword`,
    method: 'put'
  })
}

