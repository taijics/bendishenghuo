import request from '@/util/server.js'

// 查看商品评价
export function getProductEvaluate (params) {
  return request({
    url: '/comment/getProductAll',
    method: 'get',
    params
  })
}

// 查询评论列表
export function getEvaluateData (params) {
  return request({
    url: '/comment/getCommentList',
    method: 'get',
    params
  })
}

// 查询评论详情
export function getEvaluateDetail (params) {
  return request({
    url: '/comment/getById',
    method: 'get',
    params
  })
}

// 添加评论
export function addEvaluate (data) {
  return request({
    url: '/order/addComment',
    method: 'post',
    data
  })
}

// 查询评论详情
export function addMoreEvaluate (data) {
  return request({
    url: '/order/addToComment',
    method: 'put',
    data
  })
}

// 点赞
/**
 *  commentId: 0  // 评论id
 *  ifLike: 0 // 是否点赞 1-是 0-否
 */
export function likeEvaluate (data) {
  return request({
    url: '/comment/like',
    method: 'post',
    data
  })
}
