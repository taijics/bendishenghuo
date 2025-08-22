import request from '@/utils/request'

// ******商家列表******
// 提现申请管理查询
export function withdrawalGetAll(data) {
  return request({
    url: '/withdrawal/getAll',
    method: 'post',
    data,
  })
}

// 提现申请查看
export function withdrawalGetById(data) {
  return request({
    url: '/withdrawal/getById',
    method: 'post',
    data,
  })
}

// 提现申请处理
export function withdrawalHandle(data) {
  return request({
    url: '/withdrawal/handle',
    method: 'post',
    data,
  })
}
