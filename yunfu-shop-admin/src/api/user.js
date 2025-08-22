import request from '@/utils/request'

export function login(data) {
  return request({
    url: 'business/login',
    method: 'post',
    data
  })
}

export function adminBuild(data) {
  return request({
    url: 'business/build',
    method: 'post',
    data
  })
}

export function logout() {
  return request({
    url: '/vue-admin-template/user/logout',
    method: 'post'
  })
}

export function forgetPassword(data) {
  return request({
    url: '/business/forgetPassword',
    method: 'post',
    data
  })
}

export function updatePassword(data) {
  return request({
    url: '/business/updatePassword',
    method: 'post',
    data
  })
}

export function updateAvatar(data) {
  return request({
    url: '/business/updateAvatar',
    method: 'post',
    data
  })
}
