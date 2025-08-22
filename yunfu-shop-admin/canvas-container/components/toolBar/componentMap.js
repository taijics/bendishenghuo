export const componentMap = new Map([
  ['banner', () => import('./BasicsComp/bannerTool')], // 轮播图
  ['text', () => import('./BasicsComp/textTool')], // 文本
  ['videoBox', () => import('./BasicsComp/videoTool')], // 视频控件
  ['imageText', () => import('./BasicsComp/imageText')], // 图文控件
  ['imageTextNav', () => import('./BasicsComp/imageTextNav')], // 图文导航
  ['assistDiv', () => import('./BasicsComp/assistDiv')], // 铺助分割
  ['custom', () => import('./BasicsComp/customTool')], // 自定义控件
  ['brandList', () => import('./BasicsComp/brandList')], // 品牌列表
  ['imageTextList', () => import('./BasicsComp/imageTextList')], // 图文列表
  ['notice', () => import('./BasicsComp/noticeTool')], // 公告
  ['coupon', () => import('./MarketingComp/couponTool')], // 优惠券
  ['categoryList', () => import('./goodsComp/categoryTool')], // 类别列表
  ['productList', () => import('./goodsComp/productList')], // 商品列表
  ['groupList', () => import('./shopComp/groupTool')], // 拼团专区
  ['spikeList', () => import('./shopComp/spikeTool')], // 秒杀专区
  ['priceList', () => import('./shopComp/priceTool')], // 定价捆绑
  ['discountList', () => import('./shopComp/discountTool')], // 折扣列表
  ['vip', () => import('./shopComp/vipTool')], // 会员专区
  ['newProduct', () => import('./shopComp/newProductTool')], // 会员专区
  ['live', () => import('./shopComp/liveTool')], // 直播
  ['shop', () => import('./shopComp/shopTool')] // 每日好店
])
export default componentMap
