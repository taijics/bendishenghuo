import request from '@/utils/request'

//* ******************** 活动管理  *********************
// 营销活动管理查询
export function activityGetAll(data) {
  return request({
    url: '/activity/getAll',
    method: 'post',
    data
  })
}

// 选择商品分组查询
export function getGroups(data) {
  return request({
    url: '/activity/getGroups',
    method: 'post',
    data
  })
}
// 选择商品查询
export function getProducts(data) {
  return request({
    url: '/activity/getProducts',
    method: 'post',
    data
  })
}
// 报名
export function activitySave(data) {
  return request({
    url: '/activity/save',
    method: 'post',
    data
  })
}

// 查询付款结果
export function checkPay(data) {
  return request({
    url: '/activity/checkPay',
    method: 'post',
    data
  })
}

// 查询报名详情
export function getActivitySignDetail(data) {
  return request({
    url: '/activity/getActivitySignDetail',
    method: 'post',
    data
  })
}

// 活动数据查询
export function getDatas(data) {
  return request({
    url: '/activity/getDatas',
    method: 'post',
    data
  })
}
