import request from '@/util/server.js'

// 查询商品详情
export function getProductsById (params) {
  return request({
    url: '/product/getById',
    method: 'get',
    params
  })
}

// 查询商品
export function getProducts (params) {
  return request({
    url: '/product/getProducts',
    method: 'get',
    params
  })
}

// 查询组合捆绑商品
/**
 * @param {Object} params
 * city 所在地区
 * platformDiscountId 平台限时折扣活动id
 * platformSeckillId  秒杀活动id
 * productId 商品id
 * shopDiscountId 限时折扣活动id
 * shopGroupWorkId 拼团活动id
 * shopSeckillId 秒杀活动id
 * shopId 店铺id
 * skuId 规格id
 * terminal 访问终端 1-APP 2-微信小程序 3-H5 4-支付宝小程序
 * @returns void
 */
export function getComposePro (params) {
  return request({
    url: '/product/selectCompose',
    method: 'get',
    params
  })
}

// 查询店铺的组合捆绑信息
export function getShopComposePro (params) {
  return request({
    url: '/product/selectComposeByShopId',
    method: 'get',
    params
  })
}

// 查询画布商品
export function getCanvasProducts (params) {
  return request({
    url: '/canvas/getProducts',
    method: 'get',
    params
  })
}

// 查询搜索商品
export function getSearchProduct (params) {
  return request({
    url: '/app/getSearchProducts',
    method: 'get',
    params
  })
}

// 查询分类商品
export function getClaasifyProducts (params) {
  return request({
    url: '/classify/getClaasifyProducts',
    method: 'get',
    params
    // payload
  })
}

// 查询商品问答
export function getProductProblem (params) {
  return request({
    url: '/seckill/getProblems',
    method: 'get',
    params
  })
}

// 根据商品提问
export function askProductProblem (data) {
  return request({
    url: '/seckill/addProblem',
    method: 'post',
    data
  })
}

// 根据商品提问
export function answerProductProblem (data) {
  return request({
    url: '/seckill/addAnswer',
    method: 'post',
    data
  })
}

export function getServiceURL (params) {
  return request({
    url: '/kf/getPCKf',
    method: 'get',
    params
  })
}
