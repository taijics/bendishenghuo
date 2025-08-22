import request from '@/utils/request'

//* ******************** 添加商品  *********************
// 选择商品分组查询
export function getGroupSelect(data) {
  return request({
    url: '/product/getGroupSelect',
    method: 'post',
    data,
  })
}

// 商品分类
export function getClassifySelect(data) {
  return request({
    url: '/product/getClassifySelect',
    method: 'post',
    data,
  })
}

// 商品管理查询
export function getClassifyGetAll(data) {
  return request({
    url: '/canvas/getAll',
    method: 'post',
    data,
  })
}

// 修改商品查询
export function getClassifyGetById(data) {
  return request({
    url: '/product/getById',
    method: 'post',
    data,
  })
}

// 查询商品详情
export function getProductById(data) {
  return request({
    url: '/canvas/getById',
    method: 'post',
    data,
  })
}

// 修改商品
export function getClassifyUpdate(data) {
  return request({
    url: '/product/update',
    method: 'post',
    data,
  })
}

// 新增商品
export function getClassifyAdd(data) {
  return request({
    url: '/product/save',
    method: 'post',
    data,
  })
}
// 商品上下架
export function getClassifyStart(data) {
  return request({
    url: '/product/start',
    method: 'post',
    data,
  })
}

// 强制下架
export function Forced(data) {
  return request({
    url: '/canvas/forced',
    method: 'post',
    data,
  })
}

// 设置虚拟销量
export function setFictitious(data) {
  return request({
    url: '/canvas/setFictitious',
    method: 'post',
    data,
  })
}

// 商品审核
export function examine(data) {
  return request({
    url: '/canvas/examine',
    method: 'post',
    data,
  })
}

// 商品分类
export function getClassify(data) {
  return request({
    url: '/canvas/getClassify',
    method: 'post',
    data,
  })
}

// 删除商品
export function getClassifyDelete(data) {
  return request({
    url: '/product/delete',
    method: 'post',
    data,
  })
}

// 导入商品模板表下载
export const downloadTemplate = (data = {}) => {
  return request({
    url: 'product/downloadTemplate',
    method: 'post',
    data,
    responseType: 'blob',
    // type:"application/vnd.ms-excel;charset=utf-8"
  })
}

// 上传商品模板
export const importProduct = (data = {}) => {
  return request({
    url: 'product/importProduct',
    method: 'post',
    data,
    headers: {
      'Content-type': 'multipart/form-data',
    },
  })
}

//* ******************** 商品分组  *********************
// 分组查询getClassifyGetById
export function commodityListGetAll(data) {
  return request({
    url: '/group/getAll',
    method: 'post',
    data,
  })
}

// 分组详情查询
export function commodityListGetById(data) {
  return request({
    url: '/group/getById',
    method: 'post',
    data,
  })
}
// 分组删除
export function commodityListDelete(data) {
  return request({
    url: '/group/delete',
    method: 'post',
    data,
  })
}
// 修改分组
export function commodityListUpdate(data) {
  return request({
    url: '/group/update',
    method: 'post',
    data,
  })
}
// 添加分组
export function commodityListAdd(data) {
  return request({
    url: '/group/save',
    method: 'post',
    data,
  })
}
// 分组商品查询
export function getGroupList(data) {
  return request({
    url: '/group/getProducts',
    method: 'post',
    data,
  })
}

//* ******************** 设置会员价格  *********************

// 商品会员价格数据查询
export function getProductMembers(data) {
  return request({
    url: '/product/getProductMembers',
    method: 'post',
    data,
  })
}

// 商品设置会员价
export function setProductMember(data) {
  return request({
    url: '/product/setProductMember',
    method: 'post',
    data,
  })
}

// 导出商品
export function productExport(data) {
  return request({
    url: '/canvas/exportAll',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
