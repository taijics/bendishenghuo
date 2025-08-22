import request from '@/utils/request'

// 评论
// 敏感词查询
export function sensitiveGetAll(data) {
  return request({
    url: '/sensitive/get',
    method: 'post',
    data,
  })
}

// 添加敏感词设置
export function sensitiveAdd(data) {
  return request({
    url: '/sensitive/save',
    method: 'post',
    data,
  })
}
// 添加敏感词设置
export function sensitiveUpdate(data) {
  return request({
    url: '/sensitive/update',
    method: 'post',
    data,
  })
}

// 评论管理
// 评论管理查询
export function commentSysGetall(data) {
  return request({
    url: '/comment/getAll',
    method: 'post',
    data,
  })
}

// 评论详情查询
export function commentSysGetById(data) {
  return request({
    url: '/comment/getById',
    method: 'post',
    data,
  })
}

// 修改评论
export function commentSysUpdate(data) {
  return request({
    url: '/comment/update',
    method: 'post',
    data,
  })
}

// 删除评论
export function commentSysDelete(data) {
  return request({
    url: '/comment/delete',
    method: 'post',
    data,
  })
}
// 允许展示评论
export function commentAllow(data) {
  return request({
    url: '/comment/allow',
    method: 'post',
    data,
  })
}
