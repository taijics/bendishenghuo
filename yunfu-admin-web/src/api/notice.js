import request from '@/utils/request'

// ******消息中心******
// 历史消息查询
export function noticeGetAll(data) {
  return request({
    url: '/notice/getAll',
    method: 'post',
    data,
  })
}

// 消息详情
export function noticeGetById(data) {
  return request({
    url: '/notice/getById',
    method: 'post',
    data,
  })
}

// 消息详情
export function noticeDelete(data) {
  return request({
    url: '/notice/delete',
    method: 'post',
    data,
  })
}

// 发送消息
export function noticeSave(data) {
  return request({
    url: '/notice/save',
    method: 'post',
    data,
  })
}
