import request from '@/util/server.js'

// 售后列表
export function getAfterSaleList (params) {
  return request({
    url: '/after/getAll',
    method: 'get',
    params
  })
}

// 售后详情
export function getAfterSaleDetail (params) {
  return request({
    url: '/after/getById',
    method: 'get',
    params
  })
}

// 提交退款
export function submitAfter (data) {
  return request({
    url: '/after/submit',
    method: 'post',
    data
  })
}

// 退款原因查询
export function getReasons () {
  return request({
    url: '/after/getReasonSelect',
    method: 'get'
  })
}

// 撤销退款
export function returnRefund (data) {
  return request({
    url: '/after/returnRefund',
    method: 'put',
    data
  })
}

// 撤销退款
export function postRefund (data) {
  return request({
    url: '/after/returnRefund',
    method: 'post',
    data
  })
}

// 撤销退货
export function returnGoods (data) {
  return request({
    url: '/after/returnGoods',
    method: 'put',
    data
  })
}

// 撤销退货
export function postReGoods (data) {
  return request({
    url: '/after/returnGoods',
    method: 'post',
    data
  })
}

// 申请平台介入
/**
"afterId": 0,
"image": "", // 图片地址（多个以逗号隔开）
"orderId": 0,
"reason": "" // 问题描述
 */
export function requestPlatform (data) {
  return request({
    url: '/after/platform',
    method: 'post',
    data
  })
}
