import config from '@@/components/canvasShow/config/config'
const state = {
  terminal: config.terminal, // 画布设备 1 小程序，2 H5，3 App 4 电脑
  activeComponent: {}, // 选中模板数据
  componentsData: [], // 模板组件数据
  typeId: config.typeId, // 页面类型 1 平台画布，2 自定义页面，3 商家店铺装修
  couponNum: 0,
  discountNum: 0,
  groupNum: 0,
  newProductNum: 0,
  priceNum: 0,
  productNum: 0,
  spikeNum: 0
}
export default state
