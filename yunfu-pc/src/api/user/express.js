import request from '@/util/server.js'

// 查看物流信息
export function getExpressData (params) {
  return request({
    url: '/order/getDilevery',
    method: 'get',
    params
  })
}

// 所有物流公司字典查询
export function getExpressCompany () {
  return request({
    url: '/order/getExpressSelect',
    method: 'get'
  })
}

// 填写退货物流
/**
"afterId": 0,
"createTime": "",
"deliverFormid": "", // 快递单号
"express": 0, // 快递公司（取数据字典）
"image": "", // 凭证图片
"orderId": 0,
"reason": "", // 说明
"updateTime": ""
*/
export function postExpress (data) {
  return request({
    url: '/order/returnExpress',
    method: 'post',
    data
  })
}

// export function returnExpress (data) {
//   return request({
//     url: '/order/returnExpress',
//     method: 'post',
//     data
//   })
// }
