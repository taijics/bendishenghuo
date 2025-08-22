import request from '@/utils/request'

// ******直播间模块接口******
// 获取直播间列表
export function liveGetList(data) {
  return request({
    url: '/live/getAll',
    method: 'post',
    data,
  })
}

// 获取直播间详情
export function liveGetById(data) {
  return request({
    url: '/live/getById',
    method: 'post',
    data,
  })
}

// 审核直播间
export function livePutAudit(data) {
  return request({
    url: '/live/audit',
    method: 'post',
    data,
  })
}

// 直播间相关产品
export function liveGetProduct(data) {
  return request({
    url: '/live/getLiveProductRelPageByLiveId',
    method: 'post',
    data,
  })
}

// 直播间商品列表查询
export function liveProGetAll(data) {
  return request({
    url: '/liveProduct/getAll',
    method: 'post',
    data,
  })
}

// 获取直播间商品详情
export function proGetById(data) {
  return request({
    url: '/liveProduct/getById',
    method: 'post',
    data,
  })
}

// 审核直播间商品
export function liveProAudit(data) {
  return request({
    url: '/liveProduct/audit',
    method: 'post',
    data,
  })
}
