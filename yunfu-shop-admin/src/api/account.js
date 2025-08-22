import request from '@/utils/request'

//* ******************** 收款账户  *********************
// 收款账户信息查询
export function accountGetById(data) {
  return request({
    url: '/bank/getById',
    method: 'post',
    data
  })
}

// 选择所属银行查询
export function getSelect(data) {
  return request({
    url: '/dict/getSelect',
    method: 'post',
    data
  })
}
// 解绑账户
export function bankDelete(data) {
  return request({
    url: '/bank/delete',
    method: 'post',
    data
  })
}

// 更换账户
export function bankUpdate(data) {
  return request({
    url: '/bank/update',
    method: 'post',
    data
  })
}
// 绑定账户
export function bankAdd(data) {
  return request({
    url: '/bank/save',
    method: 'post',
    data
  })
}

// 获取短信验证码
export function getCode(data) {
  return request({
    url: '/business/getCode',
    method: 'post',
    data
  })
}
