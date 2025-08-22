import request from '@/utils/request'

// 查询商家优惠券
export function getCoupons(params) {
  return request({
    url: '/canvas/getShopCoupons',
    method: 'get',
    params
  })
}
// 查询商家商品
export function getProducts(params) {
  return request({
    url: '/canvas/getProducts',
    method: 'get',
    params
  })
}
