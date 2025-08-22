function Form() {
  this.activityName = '' // 活动名称
  this.activityIntroduce = '' // 活动介绍
  this.ifBond = 0 // 活动保证金
  this.bondMoney = '' // 保证金金额
  this.activityLabel = '' // 活动标签
  this.discountMode = 1 // 优惠方式
  this.discountProgramme = 1 // 优惠方案
  this.couponContent = 0
  this.number = null // 发放数量
  this.receiveType = 1
  this.frequency = null
  this.ifCredit = 0
  this.credit = null
  this.applyType = 1 // 可用范围
  // 卡券
  this.syncCard = 0 // 是否同步卡券
  this.cardColor = ''
  this.cardNotice = '' // 使用须知
  this.cardTitle = '' // 卡券标题
  // this.appletAppId = '' // 卡券跳转配置ID
  // this.shopIdList = [] // 商户ID 列表
}

export default Form
