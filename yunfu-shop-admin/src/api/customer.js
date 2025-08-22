import request from '@/utils/request'

//* ******************** 客户管理  *********************
// 添加标签
export function addLabel(data) {
  return request({
    url: '/user_label/save',
    method: 'post',
    data
  })
}
// 标签管理查询
export function getLabels(data) {
  return request({
    url: '/user_label/getAll',
    method: 'post',
    data
  })
}
// 修改标签
export function labelUpdate(data) {
  return request({
    url: '/user_label/update',
    method: 'post',
    data
  })
}
// 删除标签
export function deleteLabel(data) {
  return request({
    url: '/user_label/delete',
    method: 'post',
    data
  })
}
// 标签编辑查询
export function labelEdit(data) {
  return request({
    url: '/user_label/getById',
    method: 'post',
    data
  })
}
// 商家标签列表
export function getLabelData() {
  return request({
    url: '/buyer/getLabels',
    method: 'post'
  })
}
// 客户列表
export function getCustomerList(data) {
  return request({
    url: '/buyer/getAll',
    method: 'post',
    data
  })
}
// 客户详情
export function getCustomerDetail(data) {
  return request({
    url: '/buyer/getById',
    method: 'post',
    data
  })
}
// 添加客户
export function addCustomer(data) {
  return request({
    url: '/buyer/save',
    method: 'post',
    data
  })
}
// 修改客户信息
export function updateCustomer(data) {
  return request({
    url: '/buyer/update',
    method: 'post',
    data
  })
}
// 客户分群
// 人群列表查询
export function getCrowd(data) {
  return request({
    url: '/crowd/getAll',
    method: 'post',
    data
  })
}
// 添加人群
export function addCrowd(data) {
  return request({
    url: '/crowd/save',
    method: 'post',
    data
  })
}
// 删除人群
export function deleteCrowd(data) {
  return request({
    url: '/crowd/delete',
    method: 'post',
    data
  })
}
// 查看客户
export function getUsers(data) {
  return request({
    url: '/crowd/getUsers',
    method: 'post',
    data
  })
}
// 人群详情查询
export function getCrowdDetail(data) {
  return request({
    url: '/crowd/getById',
    method: 'post',
    data
  })
}
// 修改人群
export function crowdUpdate(data) {
  return request({
    url: '/crowd/update',
    method: 'post',
    data
  })
}
// 添加分组
export function groupSave(data) {
  return request({
    url: '/group/save',
    method: 'post',
    data
  })
}
// 选择人群查询
export function selectCrowdData(data) {
  return request({
    url: '/operate/selectCrowd',
    method: 'post',
    data
  })
}
// 选择优惠券查询
export function getSelectCoupon(data) {
  return request({
    url: '/operate/selectCoupon',
    method: 'post',
    data
  })
}
// 新增运营计划
export function saveOperate(data) {
  return request({
    url: '/operate/saveOperate',
    method: 'post',
    data
  })
}
// 修改运营计划
export function operateUpdate(data) {
  return request({
    url: '/operate/update',
    method: 'post',
    data
  })
}
// 运营计划列表查询
export function getOperateList(data) {
  return request({
    url: '/operate/getAll',
    method: 'post',
    data
  })
}
// 运营计划详情查询
export function getOperateDetail(data) {
  return request({
    url: '/operate/getById',
    method: 'post',
    data
  })
}
// 运营计划数据查询
export function getDatasInfo(data) {
  return request({
    url: '/operate/getDatas',
    method: 'post',
    data
  })
}
// 删除运营计划
export function deleteOperate(data) {
  return request({
    url: '/operate/delete',
    method: 'post',
    data
  })
}
// 加标签
export function buyerSaveLabel(data) {
  return request({
    url: '/buyer/saveLabel',
    method: 'post',
    data
  })
}
// 导出
export function userExport(data) {
  return request({
    url: '/buyer/export',
    method: 'post',
    data,
    responseType: 'blob'
  })
}
