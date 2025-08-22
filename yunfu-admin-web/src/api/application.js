import request from '@/utils/request'

// 用户提现申请查询
export function applicationGetAll(data) {
  return request({
    url: '/buyer_withdrawal/getAll',
    method: 'post',
    data,
  })
}
// 用户提现申请详情查询
export function applicationGetById(data) {
  return request({
    url: '/buyer_withdrawal/getById',
    method: 'post',
    data,
  })
}

// 用户提现申请处理
export function applicationHandle(data) {
  return request({
    url: '/buyer_withdrawal/handle',
    method: 'post',
    data,
  })
}
