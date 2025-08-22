import request from '@/util/server.js'

// 收货地址查询
export function getAllAddressList (params) {
  return request({
    url: '/receive/getAll',
    method: 'get',
    params
  })
}

// 新增地址
export function addAddress (data) {
  return request({
    url: '/receive/save',
    method: 'post',
    data
  })
}

// 修改地址
export function updateAddress (data) {
  return request({
    url: '/receive/update',
    method: 'put',
    data
  })
}

// 修改地址
export function deleteAddress (data) {
  return request({
    url: '/receive/delete',
    method: 'delete',
    data
  })
}
