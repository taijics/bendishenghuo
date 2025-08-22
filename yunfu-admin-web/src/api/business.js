import request from '@/utils/request'

// ******商家列表******
// 商家管理查询
export function businessListGetAll(data) {
  return request({
    url: '/shop/getAll',
    method: 'post',
    data,
  })
}

// 新增商家
export function businessListSave(data) {
  return request({
    url: '/shop/save',
    method: 'post',
    data,
  })
}

// 商家编辑查询
export function businessListGetById(data) {
  return request({
    url: '/shop/getById',
    method: 'post',
    data,
  })
}

//   修改商家
export function businessListUpdate(data) {
  return request({
    url: '/shop/update',
    method: 'post',
    data,
  })
}

// 启停用商家
export function businessListStart(data) {
  return request({
    url: '/shop/start',
    method: 'post',
    data,
  })
}

export function delBusinessById(data) {
  return request({
    url: '/shop/cleanShop',
    method: 'post',
    data,
  })
}

// 入驻申请
// 入驻申请管理查询
export function settlementGetAll(data) {
  return request({
    url: '/check/getAll',
    method: 'post',
    data,
  })
}

// 入驻申请详情
export function settlementGetById(data) {
  return request({
    url: '/check/getById',
    method: 'post',
    data,
  })
}

// 处理
export function settlementHandle(data) {
  return request({
    url: '/check/handle',
    method: 'post',
    data,
  })
}

// 删除
export function settlementDelete(data) {
  return request({
    url: '/check/delete',
    method: 'post',
    data,
  })
}

// **********************关键词**********************
// 启停用
export function wordStart(data) {
  return request({
    url: '/word/start',
    method: 'post',
    data,
  })
}

// 启停用
export function wordGetAll(data) {
  return request({
    url: '/word/getAll',
    method: 'post',
    data,
  })
}

// 添加关键词
export function wordAdd(data) {
  return request({
    url: '/word/save',
    method: 'post',
    data,
  })
}

// 修改关键词查询
export function wordGetById(data) {
  return request({
    url: '/word/getById',
    method: 'post',
    data,
  })
}

// 修改关键词
export function wordUpdate(data) {
  return request({
    url: '/word/update',
    method: 'post',
    data,
  })
}

// 删除关键词
export function wordDelete(data) {
  return request({
    url: '/word/delete',
    method: 'post',
    data,
  })
}
