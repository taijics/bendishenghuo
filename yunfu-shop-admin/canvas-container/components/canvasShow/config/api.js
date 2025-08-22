// 导入api接口模块

// 获取当前环境变量 true => 生产环境 false => 开发环境
const BASEURL = process.env.VUE_APP_DOMAIN_PREFIX
// const BASEURL = (process.env.NODE_ENV === 'production') ? '/api' : '/api'

export const api = {
  // 画布模块
  fileUpload: BASEURL + '/file/upload', // 文件上传
  getClassify: BASEURL + '/canvas/getClassify', // 查询分类层级
  getProducts: BASEURL + '/canvas/getProducts', // 选择商品查询
  saveCanvas: BASEURL + '/canvas/saveCanvas', // 保存画布
  getCanvas: BASEURL + '/canvas/getCanvas', // 读取画布
  getShops: BASEURL + '/canvas/getShops', // 选择店铺查询
  getCoupons: BASEURL + '/canvas/getCoupons', // 优惠券查询
  getShopCoupons: BASEURL + '/canvas/getShopCoupons', // 优惠券查询
  takeCoupon: BASEURL + '/coupon/takeCoupon', // 领取优惠券
  selectCanvasCustomList: BASEURL + '/canvas/selectCanvasCustomList', // 自定义页面查询
  getPlatformSeckills: `${BASEURL}/canvas/getPlatformSeckills`, // 平台秒杀活动
  getSeckills: `${BASEURL}/renovation/getSeckills`, // 商家秒杀活动
  getMinDiscount: `${BASEURL}/canvas/getMinDiscount`, // 平台限时折扣
  getDiscounts: `${BASEURL}/renovation/getDiscounts`, // 商家限时折扣
  getAdminGroupWorks: `${BASEURL}/canvas/getGroupWorks`, // 平台拼团专区
  getGroupWorks: `${BASEURL}/renovation/getGroupWorks`, // 商家拼团专区
  getPrices: `${BASEURL}/canvas/getPrices`, // 商家定价捆绑
  getMemberProducts: `${BASEURL}/canvas/getMemberProducts`, // 查询会员商品数据
  getNotices: `${BASEURL}/canvas/getNotices`, // 平台获取公告数据
}
export default api
