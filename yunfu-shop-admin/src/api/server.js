import request from '@/utils/request'

//* ******************** 客服模块  *********************
// 查询客服列表
export function getAllList(data) {
  return request({
    url: '/customerService/getAll',
    method: 'post',
    data
  })
}
// 添加客服
export function AddService(data) {
  return request({
    url: '/customerService/save',
    method: 'post',
    data
  })
}
// 删除客服
export function delService(data) {
  return request({
    url: '/customerService/delete',
    method: 'post',
    data
  })
}

// 编辑客服
export function UpService(data) {
  return request({
    url: '/customerService/update',
    method: 'post',
    data
  })
}

// 获取客服下的接待员
export function getAllReceptionist(data) {
  return request({
    url: '/customerService/getAllReceptionist',
    method: 'post',
    data
  })
}

// // 获取接待人部门分类列表
export function getDepartmentList(data) {
  return request({
    url: '/customerService/getDepartmentList',
    method: 'post',
    data
  })
}

// // 获取接待人部门分类列表
export function getExternalUserList(data) {
  return request({
    url: '/customerService/getExternalUserList',
    method: 'post',
    data
  })
}

// // 添加接待员
export function saveReceptionist(data) {
  return request({
    url: '/customerService/saveReceptionist',
    method: 'post',
    data
  })
}
// // 添加接待员
export function deleteReceptionist(data) {
  return request({
    url: '/customerService/deleteReceptionist',
    method: 'post',
    data
  })
}

// // 获取客服配置
export function getConfig(data) {
  return request({
    url: '/customerService/getConfig',
    method: 'post',
    data
  })
}

// // 修改客服配置
export function saveOrUpdateConfig(data) {
  return request({
    url: '/customerService/saveOrUpdateConfig',
    method: 'post',
    data
  })
}

// // 查询是否授权
export function checkAuthState(data) {
  return request({
    url: '/customerService/checkAuthState',
    method: 'post',
    data
  })
}
