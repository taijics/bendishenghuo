import request from '@/utils/request'

//* ******************** 业绩管理  *********************
// 分销订单管理查询
export function tipsdistributorGetAll(data) {
  return request({
    url: '/distributor_order/getAll',
    method: 'post',
    data
  })
}

// 标记结算
export function settlement(data) {
  return request({
    url: '/distributor_order/settlement',
    method: 'post',
    data
  })
}

// 分销员业绩管理查询
export function getAllAchievement(data) {
  return request({
    url: '/achievement/getAllAchievement',
    method: 'post',
    data
  })
}

// 订单数详情查询
export function getOrderDetail(data) {
  return request({
    url: '/achievement/getOrderDetail',
    method: 'post',
    data
  })
}

// 成交金额详情查询
export function getDealMoneyDetail(data) {
  return request({
    url: '/achievement/getDealMoneyDetail',
    method: 'post',
    data
  })
}

// 总佣金详情查询
export function getCommissionMoneyDetail(data) {
  return request({
    url: '/achievement/getCommissionMoneyDetail',
    method: 'post',
    data
  })
}

// 未结算佣金详情查询
export function getNotCommissionMoneyDetail(data) {
  return request({
    url: '/achievement/getNotCommissionMoneyDetail',
    method: 'post',
    data
  })
}

// 开启/关闭自购分佣
export function levelUpdateSelf(data) {
  return request({
    url: '/level/updateSelf',
    method: 'post',
    data
  })
}

// 分销员等级管理查询
export function levelGetAll(data) {
  return request({
    url: '/level/getAll',
    method: 'post',
    data
  })
}

// 添加分销员等级
export function levelAdd(data) {
  return request({
    url: '/level/save',
    method: 'post',
    data
  })
}

// 分销员等级修改查询
export function levelGetById(data) {
  return request({
    url: '/level/getById',
    method: 'post',
    data
  })
}

// 修改分销员等级
export function levelUpdate(data) {
  return request({
    url: '/level/update',
    method: 'post',
    data
  })
}
// 删除分销员等级
export function levelDelete(data) {
  return request({
    url: '/level/delete',
    method: 'post',
    data
  })
}

// 查询所有分销员等级
export function getAllLevel(data) {
  return request({
    url: '/distributor/getAllLevel',
    method: 'post',
    data
  })
}

// 查询所有邀请人
export function getAllInvitees(data) {
  return request({
    url: '/distributor/getAllInvitees',
    method: 'post',
    data
  })
}

// 分销员管理查询
export function distributorGetAll(data) {
  return request({
    url: '/distributor/getAll',
    method: 'post',
    data
  })
}

// 添加分销员
export function distributorAdd(data) {
  return request({
    url: '/distributor/save',
    method: 'post',
    data
  })
}

// 分销员修改查询
export function distributorGetById(data) {
  return request({
    url: '/distributor/getById',
    method: 'post',
    data
  })
}

// 修改分销员
export function distributorUpdate(data) {
  return request({
    url: '/distributor/update',
    method: 'post',
    data
  })
}

// 清退分销员
export function distributorDelete(data) {
  return request({
    url: '/distributor/delete',
    method: 'post',
    data
  })
}

// 待审核分销员管理查询
export function getStayExamineAll(data) {
  return request({
    url: '/distributor/getStayExamineAll',
    method: 'post',
    data
  })
}

// 分销员申请处理
export function handle(data) {
  return request({
    url: '/distributor/handle',
    method: 'post',
    data
  })
}

// 招募设置查询
export function getByShopId(data) {
  return request({
    url: '/recruit/getByShopId',
    method: 'post',
    data
  })
}

// 添加招募设置
export function recruitAdd(data) {
  return request({
    url: '/recruit/save',
    method: 'post',
    data
  })
}

// 修改招募设置
export function recruitUpdate(data) {
  return request({
    url: '/recruit/update',
    method: 'post',
    data
  })
}

// 关系管理查询
export function shipGetAll(data) {
  return request({
    url: '/ship/getAll',
    method: 'post',
    data
  })
}

// 绑定关系
export function shipAdd(data) {
  return request({
    url: '/ship/bind',
    method: 'post',
    data
  })
}

// 解除绑定关系
export function relieveBind(data) {
  return request({
    url: '/ship/relieveBind',
    method: 'post',
    data
  })
}

// 移除绑定关系
export function shipDelete(data) {
  return request({
    url: '/ship/delete',
    method: 'post',
    data
  })
}

// 关系设置查询
export function shipGetById(data) {
  return request({
    url: '/ship/getById',
    method: 'post',
    data
  })
}

// 添加关系设置
export function shipSave(data) {
  return request({
    url: '/ship/save',
    method: 'post',
    data
  })
}

// 修改关系设置
export function shipUpdate(data) {
  return request({
    url: '/ship/update',
    method: 'post',
    data
  })
}

// 推广设置查询
export function extensionGetAll(data) {
  return request({
    url: '/extension/getAll',
    method: 'post',
    data
  })
}

// 添加或修改推广设置
export function extensionSave(data) {
  return request({
    url: '/extension/save',
    method: 'post',
    data
  })
}
