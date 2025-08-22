import request from '@/util/server.js'

// 查询个人信息
export function getUserInfo () {
    return request({
        url: '/user/getUser',
        method: 'get'
    })
}

// 修改个人信息
export function changeUserInfo (data) {
    return request({
        url: '/user/update',
        method: 'put',
        data
    })
}

// 修改密码
export function updateLoginPWD (data) {
    return request({
        url: '/user/updatePassword',
        method: 'put',
        data
    })
}

// 解除绑定手机号
export function freedPhone (data) {
    return request({
        url: '/user/relievePhone',
        method: 'put',
        data
    })
}

// 修改手机号
export function changePhone (data) {
    return request({
        url: '/user/updatePhone',
        method: 'put',
        data
    })
}

// 身份验证
export function checkUser (params) {
    return request({
        url: '/user/checkUser',
        method: 'get',
        params
    })
}

// 查询我的提问
export function getMyProblems (params) {
    return request({
        url: '/user/getSelfProblems',
        method: 'get',
        params
    })
}

// 批量删除我的提问
export function delMyProblem (data) {
    return request({
        url: '/seckill/deleteProblem',
        method: 'delete',
        data
    })
}

// 查询我的回答
export function getMyAnswers (params) {
    return request({
        url: '/user/getSelfAnswers',
        method: 'get',
        params
    })
}

// 批量删除我的回答
export function delMyAnswers (data) {
    return request({
        url: '/seckill/deleteAnswer',
        method: 'delete',
        data
    })
}

// 查询我的足迹
export function getFoots (params) {
    return request({
        url: '/footprint/getAll',
        method: 'get',
        params
    })
}

// 查询我的足迹
export function deleteFoots (data) {
    return request({
        url: '/footprint/delete',
        method: 'delete',
        data
    })
}

// 查询我的收藏店铺
export function getCollectShop (params) {
    return request({
        url: '/collect/getAllShop',
        method: 'get',
        params
    })
}

// 查询我的收藏商品
export function getCollectProduct (params) {
    return request({
        url: '/collect/getAllProduct',
        method: 'get',
        params
    })
}

// 收藏商品/店铺
export function postCollect (data) {
    return request({
        url: '/collect/collect',
        method: 'post',
        data
    })
}

export function cancelCollect (data) {
    return request({
        url: '/collect/cancel',
        method: 'put',
        data
    })
}
