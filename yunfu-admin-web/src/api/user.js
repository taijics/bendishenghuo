import request from '@/utils/request'

export function login(data) {
  return request({
    url: 'admin/login',
    method: 'post',
    data,
  })
}

export function resetPassword(data) {
  return request({
    url: 'admin/forgetPassword',
    method: 'post',
    data,
  })
}

export function adminBuild(data) {
  return request({
    url: 'admin/build',
    method: 'post',
    data,
  })
}

export function logout() {
  return request({
    url: '/vue-admin-template/user/logout',
    method: 'post',
  })
}

// 获取短信验证码
export function getCode(data) {
  return request({
    url: 'admin/getCode',
    method: 'post',
    data,
  })
}

// 修改密码
export function changePwd(data) {
  return request({
    url: '/platform_user/updatePassword',
    method: 'post',
    data,
  })
}

// 修改头像
export function changeHeader(data) {
  return request({
    url: '/platform_user/updateAvatar',
    method: 'post',
    data,
  })
}
