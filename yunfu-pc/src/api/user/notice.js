import request from '@/util/server.js'

// 查询消息列表
export function getNoticeAll (params) {
    return request({
        url: '/notice/getAll',
        method: 'get',
        params
    })
}

// 查询消息详情
export function getNoticeDetail (params) {
    return request({
        url: '/notice/getById',
        method: 'get',
        params
    })
}

// 读取消息
export function readNotice (data) {
    return request({
        url: '/notice/readNotice',
        method: 'post',
        data
    })
}

// 查询消息详情
export function noticeDel (data) {
    return request({
        url: '/notice/removeById',
        method: 'post',
        data
    })
}

// 查询消息详情
export function getGongGaoAll (params) {
    return request({
        url: '/notice/getGongGaoAll',
        method: 'get',
        params
    })
}
