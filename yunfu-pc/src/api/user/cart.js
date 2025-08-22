import request from '@/util/server.js'

// 查询购物车内容
export function getCartList () {
  return request({
    url: '/cart/getCart',
    method: 'get'
  })
}

// 选中商品
export function putProduct (data) {
  return request({
    url: '/cart/selected',
    method: 'put'
  })
}

// 添加到购物车
/**
{
  skuId: 0, // 规格id
  number: 0 // 商品数量
}
 */
export function addToCart (data) {
  return request({
    url: '/cart/addCart',
    method: 'post',
    data
  })
}

// 删除购物车商品
export function deleteCartItem (data) {
  return request({
    url: '/cart/delete',
    method: 'delete',
    data
  })
}

// 清空失效宝贝
export function clearCart () {
  return request({
    url: '/cart/clearInvalidSku',
    method: 'get'
  })
}

// 删除购物车商品
export function updateCartNum (data) {
  return request({
    url: '/cart/updateNumber',
    method: 'put',
    data
  })
}
