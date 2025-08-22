import request from '@/util/server.js'

// 结算、提交订单
export function orderSubmit (data) {
  return request({
    url: '/order/submit',
    method: 'post',
    data
  })
}
// 确认订单
export function orderConfirm (data) {
  return request({
    url: '/order/confirm',
    method: 'put',
    data
  })
}

// 取消订单
export function orderCancel (data) {
  return request({
    url: '/order/cancel',
    method: 'put',
    data
  })
}

// 删除订单
export function orderDelete (data) {
  return request({
    url: '/order/delete',
    method: 'delete',
    data
  })
}

// 查询订单列表
export function getOrderList (params) {
  return request({
    url: '/order/getAll',
    method: 'get',
    params
  })
}

// 查询订单详情
export function getOrderDetail (params) {
  return request({
    url: '/order/getById',
    method: 'get',
    params
  })
}

// 结算查询
/**
 * @param {Object} data
 * ifWork 是否拼团商品单独购买 1-是 0-否
 * receiveId 收货地址id
 * shopDiscountId
 * @returns request
 */
export function getSettlement (data) {
  return request({
    url: '/order/getSettlement',
    method: 'post',
    data
  })
}

// 再次购买
export function buyItAgain (data) {
  return request({
    url: '/cart/buyAgain',
    method: 'put',
    data
  })
}

// 拼团单结算查询
export function getGroupSettle (data) {
  return request({
    url: '/work/getSettlement',
    method: 'post',
    data
  })
}

// 校验当前订单是否支付成功
export function checkOrderResult (params) {
  return request({
    url: '/order/checkPay',
    method: 'get',
    params
  })
}

// 支付
export function orderPayPost (data) {
  return request({
    url: '/order/pay',
    method: 'post',
    data
  })
}

// 支付
export function orderPayPut (data) {
  return request({
    url: '/order/pay',
    method: 'put',
    data
  })
}

// 获取支付二维码码
export function orderPayCode (params) {
  return request({
    url: '/order/getUrl',
    method: 'get',
    params
  })
}
