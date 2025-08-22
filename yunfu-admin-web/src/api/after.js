import request from '@/utils/request'

// ******售后处理******
// 售后管理查询
export function afterGetAll(data) {
  return request({
    url: '/after/getAll',
    method: 'post',
    data,
  })
}

// 售后详情查询
export function afterGetById(data) {
  return request({
    url: '/after/getById',
    method: 'post',
    data,
  })
}

// 物流信息查询
export function getDilevery(data) {
  return request({
    url: '/after/getDilevery',
    method: 'post',
    data,
  })
}

// 买家信息查询
export function getBuyer(data) {
  return request({
    url: '/after/getBuyer',
    method: 'post',
    data,
  })
}

// 处理
export function handles(data) {
  return request({
    url: '/after/handle',
    method: 'post',
    data,
  })
}

//导出售后订单
export function afterOrderExport(data) {
  return request({
    url: '/after/export',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
