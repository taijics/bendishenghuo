import request from '@/utils/request'

export function getData(data) {
  return request({
    url: '',
    method: 'post',
    data,
  })
}

// 秒杀活动查询
/**
{
	"seckillName": "", // 活动名称
	"page": 0,
	"pageSize": 0,
	"state": 0 // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
}
 */
export function getSeckillData(data) {
  return request({
    url: '/seckill/getAll',
    method: 'post',
    data,
  })
}

// 查询秒杀详情
/**
{
	"seckillId": 0 // 平台秒杀活动id
}
 */
export function getSeckillDetail(data) {
  return request({
    url: '/seckill/getById',
    method: 'post',
    data,
  })
}

// 添加秒杀活动
/**
{
	"bondMoney": 0, // 保证金金额
	"endTime": "", // 活动结束时间
	"ifAdd": 0, // 优惠券是否叠加 1-是 0-否
	"ifBond": 0, // 是否需要保证金 1-是 0-否
	"ifLimit": 0, // 商品限购 1-不限购 2-限购
	"limitNumber": 0, // 	限购几件/人
	"remark": "",
	"seckillMoney": 0, // 直降多少元
	"seckillName": "", // 活动名称
	"signEndTime": "", // 报名结束时间
	"signStartTime": "", // 报名开始时间
	"startTime": "" // 活动开始时间
}
 */
export function addSeckillData(data) {
  return request({
    url: '/seckill/save',
    method: 'post',
    data,
  })
}

// 删除秒杀数据
/**
{
	"seckillId": 0
}
 */
export function delSeckillData(data) {
  return request({
    url: '/seckill/delete',
    method: 'post',
    data,
  })
}

// 修改秒杀数据
/**
{
	"bondMoney": 0, // 保证金金额
	"endTime": "", // 活动结束时间
	"ifAdd": 0, // 优惠券是否叠加 1-是 0-否
	"ifBond": 0, // 是否需要保证金 1-是 0-否
	"ifLimit": 0, // 商品限购 1-不限购 2-限购
	"limitNumber": 0, // 限购几件/人
	"remark": "",
	"seckillId": 0, // 平台秒杀活动id
	"seckillMoney": 0, // 直降多少元
	"seckillName": "", // 活动名称
	"shopId": 0, // 店铺id
	"signEndTime": "", // 报名结束时间
	"signStartTime": "", // 报名开始时间
	"startTime": "" // 活动开始时间
}
 */
export function editSeckillData(data) {
  return request({
    url: '/seckill/update',
    method: 'post',
    data,
  })
}

// 停止秒杀活动
/**
{
	"seckillId": 0
}
 */
export function endSeckillData(data) {
  return request({
    url: '/seckill/stop',
    method: 'post',
    data,
  })
}

// 秒杀活动数据查询
/**
{
	"seckillId": 0
}
 */
export function getSeckillChart(data) {
  return request({
    url: '/seckill/getData',
    method: 'post',
    data,
  })
}

// 参与店铺查询
/**
{
	"page": 0,
	"pageSize": 0,
	"seckillId": 0, // 平台秒杀活动id
	"shopCode": "", // 店铺编码
	"shopName": "", // 店铺名称
	"state": 0 // 审核状态 0-待审核 1-报名成功 2-报名失败 3-报名进行中(未支付)
}
 */
export function getSeckillShop(data) {
  return request({
    url: '/seckill/getShops',
    method: 'post',
    data,
  })
}

// 查看商品
/**
{
	"page": 0,
	"pageSize": 0,
	"signId": 0 // 报名id
}
 */
export function getSeckillProduct(data) {
  return request({
    url: '/seckill/getProducts',
    method: 'post',
    data,
  })
}

export function exportSeckillData(data) {
  return request({
    url: '/seckill/excel_shop_detail',
    method: 'post',
    data,
    responseType: 'blob',
  })
}
