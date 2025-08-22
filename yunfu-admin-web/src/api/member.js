import request from '@/utils/request'

// ******会员权益******
// 添加会员权益
export function addMembership(data) {
  return request({
    url: '/membership/save',
    method: 'post',
    data,
  })
}
// 会员权益列表
export function getMembership(data) {
  return request({
    url: '/membership/getAll',
    method: 'post',
    data,
  })
}
// 编辑会员权益
export function changeMembership(data) {
  return request({
    url: '/membership/update',
    method: 'post',
    data,
  })
}
// 会员权益详情查询
export function getMembershipInfo(data) {
  return request({
    url: '/membership/getById',
    method: 'post',
    data,
  })
}
// 删除会员权益
export function delMembership(data) {
  return request({
    url: '/membership/delete',
    method: 'post',
    data,
  })
}
// 会员等级列表查询
export function getMemberlevel(data) {
  return request({
    url: '/memberlevel/getAll',
    method: 'post',
    data,
  })
}
// 编辑会员等级
export function updateLevel(data) {
  return request({
    url: '/memberlevel/update',
    method: 'post',
    data,
  })
}
// 会员等级详情查询
export function getLevelInfo(data) {
  return request({
    url: '/memberlevel/getById',
    method: 'post',
    data,
  })
}
// 会员等级详情查询
export function addLevel(data) {
  return request({
    url: '/memberlevel/save',
    method: 'post',
    data,
  })
}
// 删除会员等级
export function deleteLevel(data) {
  return request({
    url: '/memberlevel/delete',
    method: 'post',
    data,
  })
}
