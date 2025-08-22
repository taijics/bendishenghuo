import request from '@/utils/request'

//* ******************** 添加商品  *********************
// 店铺信息查询
export function shopSysGetById(data) {
  return request({
    url: '/shop/getById',
    method: 'post',
    data
  })
}

// 修改店铺信息
export function shopSysUpdate(data) {
  return request({
    url: '/shop/update',
    method: 'post',
    data
  })
}

//* ******************** 物流方案  *********************
// 物流方案查询
export function logisticsGetAll(data) {
  return request({
    url: '/logistics/getAll',
    method: 'post',
    data
  })
}

// 物流方案详情
export function logisticsGetById(data) {
  return request({
    url: '/logistics/getById',
    method: 'post',
    data
  })
}

// 添加物流方案
export function logisticsAdd(data) {
  return request({
    url: '/logistics/save',
    method: 'post',
    data
  })
}

// 修改物流方案
export function logisticsUpdate(data) {
  return request({
    url: '/logistics/update',
    method: 'post',
    data
  })
}

// 删除物流方案
export function logisticsDelete(data) {
  return request({
    url: '/logistics/delete',
    method: 'post',
    data
  })
}
