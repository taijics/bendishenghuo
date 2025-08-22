import request from '@/utils/request'

// ******客户管理******
// 客户管理查询
export function customerMageGetAll(data) {
  return request({
    url: '/buyer/getAll',
    method: 'post',
    data,
  })
}
// 标签查询
export function getLabels(data) {
  return request({
    url: '/buyer/getLabels',
    method: 'post',
    data,
  })
}
// 贴标签
export function customerSaveUserLabel(data) {
  return request({
    url: '/buyer/saveUserLabel',
    method: 'post',
    data,
  })
}
// 加入或取消黑名单
export function customerBlacklist(data) {
  return request({
    url: '/buyer/blacklist',
    method: 'post',
    data,
  })
}
// 更新积分
export function updateBuyerCredit(data) {
  return request({
    url: '/buyer/updateCredit',
    method: 'post',
    data,
  })
}

// 更新积分
export function exportBuyerUser(data) {
  return request({
    url: '/buyer/export',
    method: 'post',
    data,
    responseType: 'blob',
  })
}

// 客户详情查询
export function customerMageGetById(data) {
  return request({
    url: '/buyer/getById',
    method: 'post',
    data,
  })
}

// 导出标签
export const excel_platform_label = (data = {}) => {
  return request({
    url: 'label/excel_platform_label',
    method: 'post',
    data,
    responseType: 'blob',
  })
}

// ******标签管理******
// 标签管理查询
export function tipsGetAll(data) {
  return request({
    url: '/label/getAll',
    method: 'post',
    data,
  })
}
// 添加标签
export function tipsAdd(data) {
  return request({
    url: '/label/save',
    method: 'post',
    data,
  })
}
// 修改标签
export function tipsUpdate(data) {
  return request({
    url: '/label/update',
    method: 'post',
    data,
  })
}

// 删除标签
export function tipsDelete(data) {
  return request({
    url: '/label/delete',
    method: 'post',
    data,
  })
}
// 标签编辑查询
export function tipsGetById(data) {
  return request({
    url: '/label/getById',
    method: 'post',
    data,
  })
}
