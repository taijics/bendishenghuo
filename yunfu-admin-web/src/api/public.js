import request from '@/utils/request'

// 查询分类层级
export function getClassify(params) {
  return request({
    url: '/canvas/getClassify',
    method: 'get',
    params,
  })
}
// 查询平台优惠券
export function getCoupons(params) {
  return request({
    url: '/canvas/getCoupons',
    method: 'get',
    params,
  })
}
// 查询平台商品
export function getProducts(params) {
  return request({
    url: '/canvas/getProducts',
    method: 'get',
    params,
  })
}
