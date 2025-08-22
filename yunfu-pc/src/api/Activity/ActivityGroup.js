import request from '@/util/server.js'

// 拼团专区
export function getGroupList (params) {
  return request({
      url: '/work/getIndex',
      method: 'get',
      params
  })
}

// 邀请拼团
export function inviteGroup (params) {
  return request({
      url: '/work/getShare',
      method: 'get',
      params
  })
}
