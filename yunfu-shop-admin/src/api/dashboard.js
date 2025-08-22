import request from '@/utils/request'

//* ******************** 财务统计  *********************
// 财务统计数据查询
export function dashIndex(data) {
  return request({
    url: '/index/index',
    method: 'post',
    data
  })
}

// 用户访问数据导出
export function userVisitExport(data) {
  return request({
    url: '/index/exportUserVisit',
    method: 'post',
    data,
    responseType: 'blob'
  })
}

// 订单转换导出
export function orderConvertExport(data) {
  return request({
    url: '/index/exportOrderConvert',
    method: 'post',
    data,
    responseType: 'blob'
  })
}

// 热卖商品导出
export function hotProductsExport(data) {
  return request({
    url: '/index/exportHotProducts',
    method: 'post',
    data,
    responseType: 'blob'
  })
}
