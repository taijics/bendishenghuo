import request from '@/utils/request'

export function getData(data) {
  return request({
    url: '',
    method: 'post',
    data,
  })
}

// 限时折扣查询
/**
{
	"DiscountName": "", // 活动名称
	"page": 0,
	"pageSize": 0,
	"state": 0 // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
}
 */
// 查询限时折扣列表
export function getDiscountData(data) {
  return request({
    url: '/discount/getAll',
    method: 'post',
    data,
  })
}

// 查询限时折扣详情
export function getDiscountDetail(data) {
  return request({
    url: '/discount/getById',
    method: 'post',
    data,
  })
}

// 添加限时折扣
export function addDiscountData(data) {
  return request({
    url: '/discount/save',
    method: 'post',
    data,
  })
}

// 删除限时折扣
export function delDiscountData(data) {
  return request({
    url: '/discount/delete',
    method: 'post',
    data,
  })
}

// 修改限时折扣
export function editDiscountData(data) {
  return request({
    url: '/discount/update',
    method: 'post',
    data,
  })
}

// 停止限时折扣
export function stopDiscountData(data) {
  return request({
    url: '/discount/stop',
    method: 'post',
    data,
  })
}

// 秒杀活动数据查询
export function getDiscountChart(data) {
  return request({
    url: '/discount/getData',
    method: 'post',
    data,
  })
}

// 参与店铺查询
export function getDiscountShop(data) {
  return request({
    url: '/discount/getShops',
    method: 'post',
    data,
  })
}

// 查看商品
export function getDiscountProduct(data) {
  return request({
    url: '/discount/getProducts',
    method: 'post',
    data,
  })
}

// 导出商家明细
/**
{
	"discountId": 0
}
 */
export function exportDiscountData(data) {
  return request({
    url: '/discount/excel_shop_detail',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
