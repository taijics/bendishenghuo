import request from '@/utils/request'

export function getData(data) {
  return request({
    url: '',
    method: 'post',
    data,
  })
}

// 支付有礼活动查询
/**
{
	"politeName": "", // 活动名称
	"page": 0,
	"pageSize": 0,
	"state": 0 // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
}
 */
export function getPoliteData(data) {
  return request({
    url: '/polite/getAll',
    method: 'post',
    data,
  })
}

// 详情
export function getPoliteDetail(data) {
  return request({
    url: '/polite/getById',
    method: 'post',
    data,
  })
}

// 查询所有优惠券
export function getPoliteCoupon(data) {
  return request({
    url: '/polite/getAllActivity',
    method: 'post',
    data,
  })
}

// 添加
export function addPoliteActivity(data) {
  return request({
    url: '/polite/save',
    method: 'post',
    data,
  })
}

// 更新
export function updatePoliteActivity(data) {
  return request({
    url: '/polite/update',
    method: 'post',
    data,
  })
}

// 结束
export function endPoliteActivity(data) {
  return request({
    url: '/polite/stop',
    method: 'post',
    data,
  })
}

// 删除
export function delPoliteActivity(data) {
  return request({
    url: '/polite/delete',
    method: 'post',
    data,
  })
}

// 获取活动图表数据
export function getChartData(data) {
  return request({
    url: '/polite/getData',
    method: 'post',
    data,
  })
}

// 统计页导出
export function exportPoliteData(data) {
  return request({
    url: '/polite/excel_shop_detail',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
