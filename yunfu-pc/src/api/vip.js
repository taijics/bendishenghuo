import request from '@/util/server.js'

// 会员签到
export function getSignIn () {
  return request({
      url: '/member/signIn',
      method: 'post'
  })
}

// 查询签到明细
/**
 * page  // 当前页
 * pageSize // 每页数量
 */
export function getSignInList (params) {
  return request({
      url: '/member/selectSigninHistory',
      method: 'get',
      params
  })
}

// 查询签到列表
export function getSignInTable () {
  return request({
      url: '/member/selectSigninRecordList',
      method: 'get'
  })
}
