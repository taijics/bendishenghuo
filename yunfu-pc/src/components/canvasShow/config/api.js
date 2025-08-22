import request from '@/util/server.js'

// 读取画布
export function getCanvas (params) {
  return request({
    url: '/canvas/getCanvas',
    method: 'get',
    params
  })
}

// 查询分类层级
export function getClassify () {
  return request({
    url: '/canvas/getClassify',
    method: 'get'
  })
}

// 选择商品查询
export function getProducts (params) {
  return request({
    url: '/canvas/getProducts',
    method: 'get',
    params
  })
}

// 查询优惠券
export function getCoupons (params) {
  return request({
    url: '/canvas/getCoupons',
    method: 'get',
    params
  })
}

// 查询优惠券
export function getShopCoupons (params) {
  return request({
    url: '/canvas/getShopCoupons',
    method: 'get',
    params
  })
}

// 领取优惠券
export function takeCoupon (data) {
  return request({
    url: '/coupon/takeCoupon',
    method: 'post',
    data
  })
}

// 平台秒杀活动
export function getPlatformSeckills (params) {
  return request({
    url: '/canvas/getPlatformSeckills',
    method: 'get',
    params
  })
}

// 商家秒杀活动
export function getSeckills (params) {
  return request({
    url: '/renovation/getSeckills',
    method: 'get',
    params
  })
}

// 平台限时折扣
export function getDiscount (params) {
  return request({
    url: '/canvas/getMinDiscount',
    method: 'get',
    params
  })
}

// 商家限时折扣
export function getShopDiscounts (params) {
  return request({
    url: '/renovation/getDiscounts',
    method: 'get',
    params
  })
}

// 平台拼团专区
export function getGroupWorks (params) {
  return request({
    url: '/canvas/getGroupWorks',
    method: 'get',
    params
  })
}

// 商家拼团专区
export function getShopGroupWorks (params) {
  return request({
    url: '/renovation/getGroupWorks',
    method: 'get',
    params
  })
}

// 商家定价捆绑
export function getFixedPrices (params) {
  return request({
    url: '/canvas/getPrices',
    method: 'get',
    params
  })
}

// 查询会员商品数据
export function getVipProducts (params) {
  return request({
    url: '/canvas/getMemberProducts',
    method: 'get',
    params
  })
}

// 获取平台公告
export function getNotices () {
  return request({
    url: '/canvas/getNotices',
    method: 'get'
  })
}
