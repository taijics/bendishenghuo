import request from '@/util/server.js'

// 查询店铺优惠券
/**
{
ids: [], //优惠券id
page: 0, //当前页
pageSize: 10, // 每页记录数
search: '', // 搜索字段
shopId: 0
}
 */
export function getShopCoupon (params) {
  return request({
    url: '/canvas/getShopCoupons',
    method: 'get',
    params
  })
}

// 查询平台优惠券
/**
{
ids: [], //优惠券id
page: 0, //当前页
pageSize: 10, // 每页记录数
search: '', // 搜索字段
shopId: 0
}
 */
export function getCommonCoupon (params) {
  return request({
    url: '/canvas/getCoupons',
    method: 'get',
    params
  })
}

// 我的卡券列表  不带分页
/**
state 状态 0-已领取 1-已使用 2-已过期
 */
export function getCouponList (params) {
  return request({
    url: '/coupon/getCouponList',
    method: 'get',
    params
  })
}

// 领取优惠券
/**
{
  couponId: 0,
  shopCouponId: 0,
  shopId: 0
}
 */
export function tabkeTheCoupon (data) {
  return request({
    url: '/coupon/takeCoupon',
    method: 'post',
    data
  })
}

export function getCouponProducts (params) {
  return request({
    url: '/coupon/getCouponProducts',
    method: 'get',
    params
  })
}
