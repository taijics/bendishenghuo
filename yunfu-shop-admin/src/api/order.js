import request from '@/utils/request'

//* ******************** 待处理订单  *********************
// 订单管理查询
export function orderGetAll(data) {
  return request({
    url: '/order/getAll',
    method: 'post',
    data
  })
}
// 订单详情
export function orderGetById(data) {
  return request({
    url: '/order/getById',
    method: 'post',
    data
  })
}

// 选择快递公司查询
export function orderGetSelect(data) {
  return request({
    url: '/express/getExpressSelect',
    method: 'post',
    data
  })
}

// 发货
export function orderDilevery(data) {
  return request({
    url: '/order/dilevery',
    method: 'post',
    data
  })
}

//* ******************** 售后订单  *********************
// 售后管理查询
export function aftersaleGetAll(data) {
  return request({
    url: '/after/getAll',
    method: 'post',
    data
  })
}
// 售后详情查询
export function aftersaleGetById(data) {
  return request({
    url: '/after/getById',
    method: 'post',
    data
  })
}
// 退货退款货物有损拒绝退款
export function damaging(data) {
  return request({
    url: '/after/damaging',
    method: 'post',
    data
  })
}
// 退货退款确认收货且退款
export function confirmAndRefund(data) {
  return request({
    url: '/after/confirmAndRefund',
    method: 'post',
    data
  })
}

// 退货退款拒绝
export function refuse(data) {
  return request({
    url: '/after/refuse',
    method: 'post',
    data
  })
}
// 退货退款同意
export function success(data) {
  return request({
    url: '/after/success',
    method: 'post',
    data
  })
}
// 仅退款发货
export function refundDilevery(data) {
  return request({
    url: '/after/refundDilevery',
    method: 'post',
    data
  })
}

// 仅退款拒绝退款申请
export function refundRefuse(data) {
  return request({
    url: '/after/refundRefuse',
    method: 'post',
    data
  })
}
// 仅退款同意退款申请
export function refundSuccess(data) {
  return request({
    url: '/after/refundSuccess',
    method: 'post',
    data
  })
}

//导出订单
export function orderExport(data) {
  return request({
    url: '/order/export',
    method: 'post',
    data,
    responseType: 'blob'
  })
}

//导出售后订单
export function afterOrderExport(data) {
  return request({
    url: '/after/export',
    method: 'post',
    data,
    responseType: 'blob'
  })
}

export function updateOrderPrice(data) {
  return request({
    url: '/order/updateOrderPrice',
    method: 'post',
    data,
  })
}
