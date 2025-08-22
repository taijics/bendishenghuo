import request from '@/utils/request'

//* ******************** 待处理订单  *********************
// 订单管理查询
export function orderGetAll(data) {
  return request({
    url: '/order/getAll',
    method: 'post',
    data,
  })
}
// 订单详情
export function orderGetById(data) {
  return request({
    url: '/order/getById',
    method: 'post',
    data,
  })
}

// 选择快递公司查询
export function orderGetSelect(data) {
  return request({
    url: '/express/getExpressSelect',
    method: 'post',
    data,
  })
}

// 发货
export function orderDilevery(data) {
  return request({
    url: '/order/dilevery',
    method: 'post',
    data,
  })
}

// 导出订单
export function orderExport(data) {
  return request({
    url: '/order/export',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
