import request from '@/utils/request'

// ******广告模块******
// 会员权益列表
export function getList(data) {
  return request({
    url: '/advert/getAll',
    method: 'post',
    data,
  })
}

// 添加会员权益
export function add(data) {
  return request({
    url: '/advert/save',
    method: 'post',
    data,
  })
}

// 编辑会员权益
export function update(data) {
  return request({
    url: '/advert/update',
    method: 'post',
    data,
  })
}
// 删除会员权益
export function del(data) {
  return request({
    url: '/advert/delete',
    method: 'post',
    data,
  })
}
// 会员等级列表查询
export function toggle(data) {
  return request({
    url: '/advert/toggle',
    method: 'post',
    data,
  })
}
