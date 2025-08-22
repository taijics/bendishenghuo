import request from '@/util/server.js'

// 查询支付有礼数据
export function getPoliteList (params) {
  return request({
      url: '/order/getOrderPolite',
      method: 'get',
      params
  })
}
