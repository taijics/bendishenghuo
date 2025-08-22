import request from '@/utils/request'

//* ******************** 待处理订单  *********************
// 订单管理查询
export function getCoupon(data) {
  return request({
    url: '/coupon/getAll',
    method: 'post',
    data
  })
}
// 新增优惠券
export function addCoupon(data) {
  return request({
    url: '/coupon/save',
    method: 'post',
    data
  })
}
// 优惠券数据效果查询
export function getCouponData(data) {
  return request({
    url: '/coupon/getData',
    method: 'post',
    data
  })
}
// 获取可选中商品
export function getProducts(data) {
  return request({
    url: '/coupon/getProducts',
    method: 'post',
    data
  })
}
// 删除满减券
export function delCoupon(data) {
  return request({
    url: '/coupon/delete',
    method: 'post',
    data
  })
}
// 修改满减券/折扣券
export function updateCoupon(data) {
  return request({
    url: '/coupon/update',
    method: 'post',
    data
  })
}
// 获取优惠券详情
export function couponDetail(data) {
  return request({
    url: '/coupon/getById',
    method: 'post',
    data
  })
}
// 停止优惠券
export function stopCoupon(data) {
  return request({
    url: '/coupon/stop',
    method: 'post',
    data
  })
}
// 拼团数据查询
export function groupBuyList(data) {
  return request({
    url: '/work/getAll',
    method: 'post',
    data
  })
}
// 拼团数据删除
export function deleteGroup(data) {
  return request({
    url: '/work/delete',
    method: 'post',
    data
  })
}
// 拼团活动详情查询
export function groupDetail(data) {
  return request({
    url: '/work/getById',
    method: 'post',
    data
  })
}
// 拼团数据效果查询
export function getGroupData(data) {
  return request({
    url: '/work/getData',
    method: 'post',
    data
  })
}
// 拼团选择商品查询
export function getGroupButPro(data) {
  return request({
    url: '/work/getProducts',
    method: 'post',
    data
  })
}
// 新增拼团活动
export function addGroupBuy(data) {
  return request({
    url: '/work/save',
    method: 'post',
    data
  })
}
// 停止拼团活动
export function stopGroupBuy(data) {
  return request({
    url: '/work/stop',
    method: 'post',
    data
  })
}
// 修改拼团活动
export function groupUpdate(data) {
  return request({
    url: '/work/update',
    method: 'post',
    data
  })
}
// 秒杀活动管理查询
export function getSeckillList(data) {
  return request({
    url: '/seckill/getAll',
    method: 'post',
    data
  })
}
// 新增秒杀活动
export function addSeckill(data) {
  return request({
    url: '/seckill/save',
    method: 'post',
    data
  })
}
// 修改秒杀活动
export function seckillUpdate(data) {
  return request({
    url: '/seckill/update',
    method: 'post',
    data
  })
}
// 删除秒杀活动
export function deleteSeckill(data) {
  return request({
    url: '/seckill/delete',
    method: 'post',
    data
  })
}
// 秒杀数据效果查询
export function getSeckillData(data) {
  return request({
    url: '/seckill/getData',
    method: 'post',
    data
  })
}
// 秒杀选择商品查询
export function getSpikeList(data) {
  return request({
    url: '/seckill/getProducts',
    method: 'post',
    data
  })
}
// 秒杀商品详情
export function seckillDetail(data) {
  return request({
    url: '/seckill/getById',
    method: 'post',
    data
  })
}
// 秒杀商品停止活动
export function seckillStop(data) {
  return request({
    url: '/seckill/stop',
    method: 'post',
    data
  })
}
// 限时折扣活动详情查询
export function getSeckillDetail(data) {
  return request({
    url: '/seckill/getById',
    method: 'post',
    data
  })
}
// 限时折扣活动管理查询
export function getDiscountData(data) {
  return request({
    url: '/discount/getAll',
    method: 'post',
    data
  })
}
// 删除限时折扣活动
export function deleteDiscount(data) {
  return request({
    url: '/discount/delete',
    method: 'post',
    data
  })
}
// 限时折扣活动详情查询
export function getDiscountDetail(data) {
  return request({
    url: '/discount/getById',
    method: 'post',
    data
  })
}
// 限时折扣效果数据查询
export function getDiscountInfo(data) {
  return request({
    url: '/discount/getData',
    method: 'post',
    data
  })
}
// 选择商品查询
export function getDisProList(data) {
  return request({
    url: '/discount/getProducts',
    method: 'post',
    data
  })
}
// 新增限时折扣活动
export function addDiscount(data) {
  return request({
    url: '/discount/save',
    method: 'post',
    data
  })
}
// 停止限时折扣活动
export function stopDiscount(data) {
  return request({
    url: '/discount/stop',
    method: 'post',
    data
  })
}
// 修改限时折扣活动
export function discountUpdate(data) {
  return request({
    url: '/discount/update',
    method: 'post',
    data
  })
}

// 场景营销列表查询
export function getSceneInfo(data) {
  return request({
    url: '/scene/getAll',
    method: 'post',
    data
  })
}
// 添加场景营销
export function sceneAdd(data) {
  return request({
    url: '/scene/save',
    method: 'post',
    data
  })
}
// 启动场景营销
export function sceneStart(data) {
  return request({
    url: '/scene/start',
    method: 'post',
    data
  })
}
// 停止场景营销
export function sceneStop(data) {
  return request({
    url: '/scene/stop',
    method: 'post',
    data
  })
}
// 删除场景营销
export function sceneDelete(data) {
  return request({
    url: '/scene/delete',
    method: 'post',
    data
  })
}
// 编辑场景营销
export function sceneUpate(data) {
  return request({
    url: '/scene/update',
    method: 'post',
    data
  })
}
// 场景营销详情查询
export function getSceneDetail(data) {
  return request({
    url: '/scene/getById',
    method: 'post',
    data
  })
}
// 查询会员等级数据
export function getMemberLevels(data) {
  return request({
    url: '/scene/getMemberLevels',
    method: 'post',
    data
  })
}

// 定价捆绑列表查询
export function getPriceList(data) {
  return request({
    url: '/price/getAll',
    method: 'post',
    data
  })
}
// 添加定价捆绑
export function priceAdd(data) {
  return request({
    url: '/price/save',
    method: 'post',
    data
  })
}
// 启停用定价捆绑
export function priceStart(data) {
  return request({
    url: '/price/start',
    method: 'post',
    data
  })
}
// 删除定价捆绑
export function priceDelete(data) {
  return request({
    url: '/price/delete',
    method: 'post',
    data
  })
}
// 编辑定价捆绑
export function priceUpate(data) {
  return request({
    url: '/price/update',
    method: 'post',
    data
  })
}
// 定价捆绑详情查询
export function getPriceDetail(data) {
  return request({
    url: '/price/getById',
    method: 'post',
    data
  })
}

// 组合捆绑列表查询
export function getComposeList(data) {
  return request({
    url: '/compose/getAll',
    method: 'post',
    data
  })
}
// 添加组合捆绑
export function composeAdd(data) {
  return request({
    url: '/compose/save',
    method: 'post',
    data
  })
}
// 启停用组合捆绑
export function composeStart(data) {
  return request({
    url: '/compose/start',
    method: 'post',
    data
  })
}
// 删除组合捆绑
export function composeDelete(data) {
  return request({
    url: '/compose/delete',
    method: 'post',
    data
  })
}
// 编辑组合捆绑
export function composeUpate(data) {
  return request({
    url: '/compose/update',
    method: 'post',
    data
  })
}
// 组合捆绑详情查询
export function getComposeDetail(data) {
  return request({
    url: '/compose/getById',
    method: 'post',
    data
  })
}
// 定价捆绑和组合捆绑选择商品查询
export function getComposeSelectProduct(data) {
  return request({
    url: '/compose/selectProduct',
    method: 'post',
    data
  })
}


// //* ******************** 售后订单  *********************
// // 售后管理查询
// export function aftersaleGetAll(data) {
//   return request({
//     url: '/after/getAll',
//     method: 'post',
//     data
//   })
// }
