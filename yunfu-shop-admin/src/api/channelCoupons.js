import request from '@/utils/request'

//* ******************** 渠道优惠券  *********************
// 渠道优惠券列表查询
export function getList(data) {
  return request({
    url: '/channelCoupon/getAll',
    method: 'post',
    data
  })
}
// 添加渠道优惠券
export function add(data) {
  return request({
    url: '/channelCoupon/save',
    method: 'post',
    data
  })
}
// 生成渠道页链接
export function generateLink(data) {
  return request({
    url: '/channelCoupon/generateLink',
    method: 'post',
    data
  })
}
