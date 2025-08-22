import request from '@/utils/request'

export function getData(data) {
  return request({
    url: '',
    method: 'post',
    data,
  })
}

// 平台优惠券活动管理查询
/**
{
	"activityName": "",  // 活动名称
	"discountMode": 0, // 优惠方式 1-满减 2-优惠券
	"page": 0,
	"pageSize": 0,
	"state": 0 // 审核状态 0-待审核 1-报名成功 2-报名失败
}
*/
export function getCouponData(data) {
  return request({
    url: '/activity/getAll',
    method: 'post',
    data,
  })
}

/**
{
	"activityId": 0
}
 */
export function getCouponDetail(data) {
  return request({
    url: '/activity/getById',
    method: 'post',
    data,
  })
}

export function getCharts(data) {
  return request({
    url: '/activity/getActivityCharts',
    method: 'POST',
    data,
  })
}

export function getStats(data) {
  return request({
    url: '/activity/getActivityStats',
    method: 'get',
  })
}

export function getShopDatas(data) {
  return request({
    url: '/activity/getActivityShopDatas',
    method: 'POST',
    data,
  })
}

// export function Chartdat (data) {
//   this.cities = data.cities // 分布情况
//   this.cityPeople = data.cityPeople // 前五省份访问占比
//   this.classifies = data.classifies // 销售类别分布
//   this.newOlds = data.newOlds // 新老访客占比
//   this.productRankings = data.productRankings // 畅销商品排行榜
//   this.shopRankings = data.shopRankings // 商家成交排行榜
//   this.systems = data.systems // 系统访客占比
//   this.terminals = data.terminals // 终端访客占比
//   this.trend = data.trend // 	趋势图
//   this.describe = data.describe
// }

// 添加
export function addCoupon(data) {
  return request({
    url: '/activity/save',
    method: 'post',
    data,
  })
}

// 修改平台优惠券
/**
{
	"activityEndTime": "",
	"activityId": 0,
	"activityIntroduce": "",
	"activityName": "",
	"activityStartTime": "",
	"bondMoney": 0,
	"couponContent": 0,
	"discountMode": 0, // 优惠方式 1-满减 2-折扣
	"frequency": 0,
	"ifBond": 0,
	"number": 0,
	"promotionDetail": [
		{
			"activityId": 0,
			"couponId": 0,
			"fullMoney": 0,
			"reduceMoney": 0
		}
	],
	"receiveType": 0,
	"signEndTime": "",
	"signStartTime": "",
	"threshold": 0
}
 */
export function editCoupon(data) {
  return request({
    url: '/activity/update',
    method: 'post',
    data,
  })
}

// 结束
/**
{
	"activityId": 0
}
 */
export function endCoupon(data) {
  return request({
    url: '/activity/end',
    method: 'post',
    data,
  })
}

// 删除
/**
{
	"activityId": 0
}
 */
export function delCoupon(data) {
  return request({
    url: '/activity/delete',
    method: 'post',
    data,
  })
}

// 活动数据查询
export function getChartData(data) {
  return request({
    url: '/activity/getActivitys',
    method: 'post',
    data,
  })
}

export function getCouponShops(data) {
  return request({
    url: '/activity/getShops',
    method: 'post',
    data,
  })
}

export function exportCouponData(data) {
  return request({
    url: '/activity/excel_shop_detail',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
