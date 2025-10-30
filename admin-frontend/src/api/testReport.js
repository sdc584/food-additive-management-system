import request from '@/utils/request'

// 查询检测报告列表
export function getTestReportList(params) {
  return request({
    url: '/api/admin/testReports',
    method: 'get',
    params
  })
}

// 查询检测报告详情
export function getTestReportDetail(id) {
  return request({
    url: `/api/admin/testReports/${id}`,
    method: 'get'
  })
}

// 新增检测报告
export function addTestReport(data) {
  return request({
    url: '/api/admin/testReports',
    method: 'post',
    data
  })
}

// 更新检测报告
export function updateTestReport(data) {
  return request({
    url: '/api/admin/testReports',
    method: 'put',
    data
  })
}

// 删除检测报告
export function deleteTestReport(id) {
  return request({
    url: `/api/admin/testReports/${id}`,
    method: 'delete'
  })
}

