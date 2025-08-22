import request from '@/util/server.js'

// 搜索店铺
export function searchShop (params) {
  return request({
    url: '/shop/getShops',
    method: 'get',
    params
  })
}

// 擦寻店铺首页
export function getShopIndex (params) {
  return request({
    url: '/shop/getIndex',
    method: 'get',
    params
  })
}

// 查询店铺分类
export function getShopClassify (params) {
  return request({
    url: '/shop/getShopClassify',
    method: 'get',
    params
  })
}

// 查询店铺商品
export function getShopProducts (params) {
  return request({
    url: '/shop/getShopProducts',
    method: 'get',
    params
  })
}

// 查询店铺banner
export function getShopBanner (params) {
  return request({
    url: '/shop/getShopBanner',
    method: 'get',
    params
  })
}
