import request from '@/util/server.js'

// 优惠券列表
export function getCoupons (params) {
  return request({
    url: '/coupon/getCoupons',
    method: 'get',
    params
  })
}

// 优惠券列表
export function getCouponList (params) {
  return request({
    url: '/coupon/getCouponList',
    method: 'get',
    params
  })
}
