import request from '@/utils/request'

// ******平台活动******
// 营销活动查询
export function activeGetAll(data) {
  return request({
    url: '/activity/getAll',
    method: 'post',
    data,
  })
}
// 添加营销活动
export function activeAdd(data) {
  return request({
    url: '/activity/save',
    method: 'post',
    data,
  })
}

// 营销活动详情查询
export function activeGetById(data) {
  return request({
    url: '/activity/getById',
    method: 'post',
    data,
  })
}

// 修改营销活动
export function activeUpdate(data) {
  return request({
    url: '/activity/update',
    method: 'post',
    data,
  })
}
// 结束营销活动
export function activeEnd(data) {
  return request({
    url: '/activity/end',
    method: 'post',
    data,
  })
}
// 删除营销活动
export function activeDelete(data) {
  return request({
    url: '/activity/delete',
    method: 'post',
    data,
  })
}
// 参与店铺数据管理查询
export function activeGetShops(data) {
  return request({
    url: '/activity/getShops',
    method: 'post',
    data,
  })
}

// 查看商品
export function activeGetProducts(data) {
  return request({
    url: '/activity/getProducts',
    method: 'post',
    data,
  })
}

// 清退
/**
{
	"signId": 0
}
 */
export function activeLiquidation(data) {
  return request({
    url: '/activity/liquidation',
    method: 'post',
    data,
  })
}

// 审核
/**
{
	"remark": "",
	"signId": 0, // 报名id
	"state": 0 // 审核状态 0-待审核 1-报名成功 2-报名失败
}
 */
export function activExamine(data) {
  return request({
    url: '/activity/examine',
    method: 'post',
    data,
  })
}

// 审核记录查询
export function activeGetExamines(data) {
  return request({
    url: '/activity/getExamines',
    method: 'post',
    data,
  })
}

// 导出数据
export const excel_shop_detail = (data = {}) => {
  return request({
    url: '/activity/excel_shop_detail',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
