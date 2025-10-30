import request from '@/utils/request'

/**
 * 获取检测报告列表
 */
export function getTestReportList(params) {
  return request({
    url: '/testReports',
    method: 'get',
    params
  })
}

/**
 * 根据ID获取检测报告详情
 */
export function getTestReportById(id) {
  return request({
    url: `/testReports/${id}`,
    method: 'get'
  })
}

/**
 * 下载检测报告
 */
export function downloadTestReport(id) {
  return request({
    url: `/testReports/${id}/download`,
    method: 'get',
    responseType: 'blob'
  })
}

