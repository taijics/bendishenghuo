import request from '@/util/server.js'

// 拼团专区
export function getVipList (params) {
  return request({
      url: '/canvas/getMemberProducts',
      method: 'get',
      params
  })
}
