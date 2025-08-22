import request from '@/util/server.js'

// 定价捆绑规则查询
/**
 * @param {Object} params
 * composeName
 * createTime
 * endTime
 * priceId
 * shopId
 * startTime
 * state
 * updateTime
 * @returns request
 */
export function getBindList (params) {
  return request({
      url: '/price/selectByShopId',
      method: 'get',
      params
  })
}

// 定价捆绑套餐查询
export function getBindProduct (params) {
  return request({
      url: '/product/selectProductListByPriceId',
      method: 'get',
      params
  })
}

// 查询定价捆绑商品
export function getBindProducts (params) {
  return request({
    url: '/canvas/getPrices',
    method: 'get',
    params
  })
}

// 商品套餐、活动查询
export function getBindDetail (params) {
  return request({
      url: '/product/getProducts',
      method: 'get',
      params
  })
}
