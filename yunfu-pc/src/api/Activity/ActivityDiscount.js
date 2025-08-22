import request from '@/util/server.js'

// 平台限时折扣专区
export function getDiscountList (params) {
  return request({
      url: '/platform-discount/queryPlatformDiscount',
      method: 'get',
      params
  })
}

// 查询消息列表
export function getPlatformDiscountList (data) {
  return request({
      url: '/platform-discount/queryPlatformDiscountProductList',
      method: 'post',
      data
  })
}

// 折扣专区
export function getDiscountIndex (params) {
  return request({
      url: '/discount/getIndex',
      method: 'get',
      params
  })
}
