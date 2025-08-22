import request from '@/utils/request'

// 修改关键词查询
export function initializationRedis(data) {
  return request({
    url: '/admin/initializationRedis',
    method: 'post',
    data,
  })
}
