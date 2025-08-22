import request from '@/utils/request'

// 查询首页统计图表
/**
 * @param {*}
 * @returns request
 */
export function homeGetChartData() {
  return request({
    url: '/index/indexCharts',
    method: 'post',
  })
}

// 查询首页统计统计数据
/**
 * @param {*}
 * @returns request
 */
export function homeGetFormData() {
  return request({
    url: '/index/indexStats',
    method: 'post',
  })
}
