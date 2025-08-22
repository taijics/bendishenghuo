export const componentMap = [
  // 小程序
  new Map([
    // ['shopHeader', () => import('./cereshop/app/shopHeader')], // 首页头部
    ['banner', () => import('./basics/banner')], // 轮播图
    ['text', () => import('./basics/text')], // 文本
    ['imageText', () => import('./basics/imageText')], // 图文
    ['brandList', () => import('./basics/brandList')], // 品牌列表
    ['categoryList', () => import('./basics/categoryList')], // 品牌列表
    ['imageTextList', () => import('./basics/imageTextList')], // 图文列表
    ['assistDiv', () => import('./basics/assistDiv')], // 铺助分割
    ['imageTextNav', () => import('./basics/imageTextNav')], // 图文导航
    ['productList', () => import('./basics/product/app')], // 商品列表
    ['videoBox', () => import('./basics/video')], // 视频
    ['coupon', () => import('./basics/coupon/app')], // 优惠券
    ['custom', () => import('./basics/custom')], // 自定义
    ['notice', () => import('./basics/notice')], // 公告
    ['vip', () => import('./basics/vip/app')], // 会员专区
    // ['shopHead', () => import('./basics/shopHead')], // 店铺头部
    ['groupList', () => import('./basics/group/app')], // 拼团专区
    ['spikeList', () => import('./basics/spike/app')], // 秒杀专区
    ['priceList', () => import('./basics/price/app')], // 定价捆绑
    ['discountList', () => import('./basics/discount/app')], // 限时折扣
    ['newProduct', () => import('./basics/newProduct/app')], // 每日上新
    ['shop', () => import('./basics/shop')] // 每日好店
  ]),
  // H5
  new Map([
    // ['shopHeader', () => import('./cereshop/app/shopHeader')], // 首页头部
    ['banner', () => import('./basics/banner')], // 轮播图
    ['text', () => import('./basics/text')], // 文本
    ['imageText', () => import('./basics/imageText')], // 图文
    ['brandList', () => import('./basics/brandList')], // 品牌列表
    ['categoryList', () => import('./basics/categoryList')], // 品牌列表
    ['imageTextList', () => import('./basics/imageTextList')], // 图文列表
    ['assistDiv', () => import('./basics/assistDiv')], // 铺助分割
    ['imageTextNav', () => import('./basics/imageTextNav')], // 图文导航
    ['productList', () => import('./basics/product/app')], // 商品列表
    ['videoBox', () => import('./basics/video')], // 视频
    ['coupon', () => import('./basics/coupon/app')], // 优惠券
    ['custom', () => import('./basics/custom')], // 自定义
    ['notice', () => import('./basics/notice')], // 公告
    ['vip', () => import('./basics/vip/app')], // 会员专区
    // ['shopHead', () => import('./basics/shopHead')], // 店铺头部
    ['groupList', () => import('./basics/group/app')], // 拼团专区
    ['spikeList', () => import('./basics/spike/app')], // 秒杀专区
    ['priceList', () => import('./basics/price/app')], // 定价捆绑
    ['discountList', () => import('./basics/discount/app')], // 限时折扣
    ['newProduct', () => import('./basics/newProduct/app')], // 每日上新
    ['shop', () => import('./basics/shop')] // 每日好店
  ]),
  // APP
  new Map([
    // ['shopHeader', () => import('./cereshop/app/shopHeader')], // 首页头部
    ['banner', () => import('./basics/banner')], // 轮播图
    ['text', () => import('./basics/text')], // 文本
    ['imageText', () => import('./basics/imageText')], // 图文
    ['brandList', () => import('./basics/brandList')], // 品牌列表
    ['categoryList', () => import('./basics/categoryList')], // 品牌列表
    ['imageTextList', () => import('./basics/imageTextList')], // 图文列表
    ['assistDiv', () => import('./basics/assistDiv')], // 铺助分割
    ['imageTextNav', () => import('./basics/imageTextNav')], // 图文导航
    ['productList', () => import('./basics/product/app')], // 商品列表
    ['videoBox', () => import('./basics/video')], // 视频
    ['coupon', () => import('./basics/coupon/app')], // 优惠券
    ['custom', () => import('./basics/custom')], // 自定义
    ['notice', () => import('./basics/notice')], // 公告
    ['vip', () => import('./basics/vip/app')], // 会员专区
    // ['shopHead', () => import('./basics/shopHead')], // 店铺头部
    ['groupList', () => import('./basics/group/app')], // 拼团专区
    ['spikeList', () => import('./basics/spike/app')], // 秒杀专区
    ['priceList', () => import('./basics/price/app')], // 定价捆绑
    ['discountList', () => import('./basics/discount/app')], // 限时折扣
    ['newProduct', () => import('./basics/newProduct/app')], // 每日上新
    ['shop', () => import('./basics/shop')] // 每日好店
  ]),
  // PC
  new Map([
    // ['shopHeader', () => import('./cereshop/pc/shopHeader')], // 首页头部
    ['banner', () => import('./basics/banner')], // 轮播图
    ['text', () => import('./basics/text')], // 文本
    ['imageText', () => import('./basics/imageText')], // 图文
    ['brandList', () => import('./basics/brandList')], // 品牌列表
    ['categoryList', () => import('./basics/categoryList')], // 品牌列表
    ['imageTextList', () => import('./basics/imageTextList')], // 图文列表
    ['assistDiv', () => import('./basics/assistDiv')], // 铺助分割
    ['imageTextNav', () => import('./basics/imageTextNav')], // 图文导航
    ['productList', () => import('./basics/product/pc')], // 商品列表
    ['videoBox', () => import('./basics/video')], // 视频
    ['coupon', () => import('./basics/coupon/pc')], // 优惠券
    ['custom', () => import('./basics/custom')], // 自定义
    ['notice', () => import('./basics/notice')], // 公告
    ['vip', () => import('./basics/vip/pc')], // 会员专区
    // ['shopHead', () => import('./basics/shopHead')], // 店铺头部
    ['groupList', () => import('./basics/group/pc')], // 拼团专区
    ['spikeList', () => import('./basics/spike/pc')], // 秒杀专区
    ['priceList', () => import('./basics/price/pc')], // 定价捆绑
    ['discountList', () => import('./basics/discount/pc')], // 限时折扣
    ['newProduct', () => import('./basics/newProduct/app')], // 每日上新
    ['shop', () => import('./basics/shop')] // 每日好店
  ])
]
export default componentMap
