import request from '@/util/server.js'
// 登录模块

// 获取验证码
export function getTheCode (params) {
  return request({
    url: '/app/getCode',
    method: 'get',
    params
  })
}

// 登录
export function login (data) {
  return request({
    url: '/app/login',
    method: 'post',
    data
  })
}
// getFirstClassify: '/classify/getFirstClassify',
