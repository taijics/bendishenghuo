<script>
// // #ifdef MP-WEIXIN
// const miniShopPlugin = requirePlugin('mini-shop-plugin');
// // #endif
import { request } from './utils/request'
import API from "@/config/api";

export default {
  onLaunch: function (options) {
    if (options && options.path === 'pages_category_page1/goodsModule/goodsDetails' && options.query) {
      this.globalData.productShareItem = options.query
    }
    if (options && options.path === 'pages_category_page1/store/index' && options.query) {
      this.globalData.shopShareItem = options.query
    }
    if (options && options.path === 'pages_category_page1/distributionModule/recruit' && options.query) {
      this.globalData.distributeRecruitItem = options.query
    }
    if (options && options.path === 'pages_category_page1/goodsModule/inviteSpell' && options.query) {
      this.globalData.inviteSpellShareItem = options.query
    }
    //判断设备是否为 iPhone
    const self = this
    uni.getSystemInfo({
      success: function (res) {
        console.log(res, '检查机型')
        // 根据 model 进行判断
        // const iphoneModels = [
        // 	'iPhone X',
        // 	'iPhone XR',
        // 	'iPhone XS Max',
        // 	'iPhone 11',
        // 	'iPhone 11 Pro',
        // 	'iPhone 11 Pro Max',
        // 	'iPhone 12/13 (Pro)',
        // 	'iPhone 12/13 mini',
        // 	'iPhone 12/13 Pro Max'
        // ]
        if (res.safeArea.top > 20 && res.model.indexOf('iPhone') !== -1) {
          self.globalData.isIphone = true
        }
      }
    })
    // 购物车右上角数量
		if(uni.getStorageSync('storage_key')){
      request(API.ShoppingCart, {}, 'GET').then(resCart => {
			  let cartNum = 0
			  resCart.data.forEach(shopItem=>{
			    shopItem.skus.forEach(goodsItem=>{
			      cartNum += goodsItem.number
			    })
			  })
			  uni.setStorageSync('allCartNum', cartNum)
			  if (cartNum > 0) {
			    uni.setTabBarBadge({
			      index: 3,
			      text: cartNum.toString()
			    })
			  }
			})
		}
  }
  ,
  globalData: {
    isIphone: false,
  }
  ,
}
;
</script>

<style lang="scss">

@keyframes loading {
  0%{
    background: #e7e7e7;
  }
  50%{
    background: #f8f8f8;
  }
  100%{
    background: #e7e7e7;
  }
}
// 自定义骨架屏
.ske-loading{
  .child-loading{
    animation: loading 2s linear 0s infinite alternate;
  }
}

.ske-loading-box{
  padding: 5rpx 20rpx;
  box-sizing: border-box;
  .ske-loading-item{
    margin: 20rpx 0;
  }
}
/*每个页面公共css */
@import "./uni_modules/vk-uview-ui/index.scss";

uni-rich-text img {
  max-width: 100% !important;
}
// 图片占位图
.pic-img{
	width: 100%;
	height: 100%;
}
.default-img {
	background: url(./static/images/default.png) no-repeat center;
	background-size: 100% 100%;
}

.line1 {
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

.wid {
  width: 100%;
}

.fs4 {
  font-size: 4upx;
}

.fs18 {
  font-size: 18upx;
}

.fs20 {
  font-size: 20upx;
}

.fs22 {
  font-size: 22upx;
}

.fs24 {
  font-size: 24upx;
}

.fs26 {
  font-size: 26upx;
}

.fs28 {
  font-size: 28upx;
}

.fs30 {
  font-size: 30upx;
}

.fs32 {
  font-size: 32upx;
}

.fs34 {
  font-size: 34upx;
}

.fs36 {
  font-size: 36upx;
}

.fs38 {
  font-size: 38upx;
}

.fs40 {
  font-size: 40upx;
}

.fs42 {
  font-size: 42upx;
}

.fs44 {
  font-size: 44upx;
}

.fs46 {
  font-size: 46upx;
}

.fs48 {
  font-size: 46upx;
}

.fs50 {
  font-size: 50upx;
}

.fs60 {
  font-size: 60upx;
}

.fs-bold {
  font-weight: bold;
}

.fs-weight-300 {
  font-weight: 300;
}

.fs-weight-200 {
  font-weight: 200;
}

.fs-weight-400 {
  font-weight: 400;
}


.flex-display {
  display: flex;
}

.flex-center {
  display: flex;
  justify-content: center;
}

.flex-items {
  display: flex;
  align-items: center;
}

.flex-items-plus {
  display: flex;
  justify-content: center;
  align-items: center;
}

.flex-start {
  display: flex;
  justify-content: flex-start;
}

.flex-end {
  display: flex;
  justify-content: flex-end;
}

.flex-end-plus {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.flex-column {
  flex-direction: column
}

.flex-column-plus {
  display: flex;
  flex-direction: column
}

.flex-row {
  flex-direction: row
}

.flex-row-plus {
  display: flex;
  flex-direction: row
}

.flex-sp-around {
  justify-content: space-around;
}

.flex-sp-between {
  justify-content: space-between;
}

.text-align {
  text-align: center;
}

.flex-wrap-1 {
  display: flex;
  flex-wrap: wrap
}

.flex-nowrap-1 {
  display: flex;
  flex-wrap: nowrap
}

.align-end {
  display: flex;
  align-items: flex-end;
}

.align-sp-between {
  align-content: space-between;
}


.mar-top-5 {
  margin-top: 5upx;
}

.mar-top-10 {
  margin-top: 10upx;
}

.mar-top-20 {
  margin-top: 20upx;
}

.mar-top-30 {
  margin-top: 30upx;
}

.mar-top-32 {
  margin-top: 32upx;
}

.mar-top-36 {
  margin-top: 36upx;
}

.mar-top-40 {
  margin-top: 40upx;
}

.mar-top-50 {
  margin-top: 50upx;
}

.mar-top-60 {
  margin-top: 60upx;
}

.mar-top-70 {
  margin-top: 70upx;
}

.mar-top-100 {
  margin-top: 100upx;
}

.mar-top-percent40 {
  margin-top: 40%;
}

.mar-top-half {
  margin-top: 50%;
}

.mar-left-6 {
  margin-left: 6upx;
}

.mar-left-5 {
  margin-left: 5upx;
}

.mar-left-10 {
  margin-left: 10upx;
}

.mar-left-20 {
  margin-left: 20upx;
}

.mar-left-30 {
  margin-left: 30upx;
}

.mar-left-35 {
  margin-left: 35upx;
}

.mar-left-40 {
  margin-left: 40upx;
}

.mar-left-50 {
  margin-left: 50upx;
}

.mar-left-60 {
  margin-left: 60upx;
}

.mar-left-70 {
  margin-left: 70upx;
}

.mar-right-10 {
  margin-right: 10upx;
}

.mar-right-20 {
  margin-right: 20upx;
}

.mar-right-25 {
  margin-right: 25upx;
}

.mar-right-30 {
  margin-right: 30upx;
}

.mar-right-35 {
  margin-right: 35upx;
}

.mar-right-40 {
  margin-right: 40upx;
}

.mar-right-50 {
  margin-right: 50upx;
}

.pad-left-10 {
  padding-left: 10upx;
}

.pad-left-20 {
  padding-left: 20upx;
}

.pad-left-40 {
  padding-left: 40upx;
}

.pad-right-20 {
  padding-right: 20upx;
}

.pad-top-20 {
  padding-top: 20upx;
}

.pad-top-40 {
  padding-top: 40upx;
}

.pad-bot-20 {
  padding-bottom: 20upx;
}

.pad-topbot-20 {
  padding: 20upx 0upx;
}

.pad-topbot-5 {
  padding: 0upx 5upx;
}

.pad-topbot-10 {
  padding: 0upx 10upx;
}

.pad-topbot-50 {
  padding: 50upx 0upx;
}

.pad-bot-20 {
  padding-bottom: 20upx;
}

.pad-bot-30 {
  padding-bottom: 30upx;
}

.pad-bot-40 {
  padding-bottom: 40upx;
}

.pad-bot-100 {
  padding-bottom: 100upx;
}

.pad-bot-140 {
  padding-bottom: 140upx;
}

.bor-rad-30 {
  border-radius: 30upx;
}

.bor-rad-45 {
  border-radius: 45upx;
}

.bor-rad-half {
  border-radius: 50%;
}

.backColor {
  background-color: #009688;
}

.backColorFFF {
  background-color: #FFFFFF;
}

.pos-abs {
  position: absolute;
}

.bor-bot-line {
  border-bottom: #C8C7CC 1upx solid;
}

.bor-line-F7F7F7 {
  border-bottom: #F7F7F7 1upx solid;
}

.bor-line-E5E5E5 {
  border-bottom: #E5E5E5 1upx solid;
}

.borRig-line-E5E5E5 {
  border-right: #DDDDDD 2upx solid;
}

.borRig-line-20 {
  border-bottom: #F7F7F7 20upx solid;
}

.font-color-red {
  color: red;
}

.font-color-FFF {
  color: #FFFFFF;
}

.font-color-8A734A {
  color: #8A734A;
}

.font-color-71521B {
  color: #71521B;
}

.font-color-222 {
  color: #222222;
}

.font-color-333 {
  color: #333333;
}

.font-color-666 {
  color: #666666;
}

.font-color-999 {
  color: #999999;
}

.font-color-656 {
  color: #656565;
}

.font-color-DDD {
  color: #DDDDDD;
}

.font-color-CCC {
  color: #CCCCCC;
}

.font-color-FFEBC4 {
  color: #FFEBC4;
}

.font-color-1CC363 {
  color: #1CC363;
}

.font-color-47A7EE {
  color: #47A7EE;
}

.font-color-C5AA7B {
  color: #C5AA7B;
}

.font-color-FF7700 {
  color: #FF7700;
}

.font-color-FF7911 {
  color: #FF7911;
}

.font-color-80 {
  color: #808080;
}

.font-color-DD {
  color: #DD524D;
}

.font-color-C83732 {
  color: #C83732;
}

.font-color-3F {
  color: #3F536E;
}

.font-color-009 {
  color: #009688;
}

.font-weight-500 {
  font-weight: 500;
}

.font-weight-bold {
  font-weight: bold;
}

.overflow {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.overflowNoDot {
  display: block;
  overflow: hidden;
}

.discountsPriceLine {
  text-decoration: line-through;
}

.border-bottom-Line {
  border-bottom: 1upx solid #EDEDED;
}

.decoration {
  text-decoration: line-through;
}

.anonymous {
  margin-top: 25upx;

  .uni-checkbox-input {
    border-color: #C5AA7B !important;
    width: 30upx;
    height: 30upx;
  }

  .uni-checkbox-input-checked:before {
    font-size: 30upx !important;
  }

  .uni-checkbox-input-checked {
    background: #C5AA7B;
  }
}

.footprint {
  .itemList {
    .uni-checkbox-input {
      border-color: #C5AA7B !important;
      width: 36upx;
      height: 36upx;
      border-radius: 50%;
      margin-right: 20upx;
    }

    .uni-checkbox-input-checked:before {
      font-size: 36upx !important;
    }

    .uni-checkbox-input-checked {
      background: #C5AA7B;
    }
  }
}

.itemInfo {
  uni-slider {
    margin: 0;

    .uni-slider-thumb {
      display: none;
    }

    .uni-slider-handle-wrapper {
      height: 18upx;
      border-radius: 0;
      border: 1upx solid #FF736C;
    }

    .uni-slider-track {
      border-radius: 0;
    }

    .uni-slider-tap-area {
      flex: 0 0 70%;
      padding: 0;
    }
  }
}

.uni-modal {
  padding: 20rpx;
  box-sizing: border-box;
}

uni-modal .uni-modal__ft:after {
  border-top: none;
}

uni-modal .uni-modal__btn {
  color: #333333;
  border: 2rpx solid #333333;
  font-weight: 400;
  margin: 0 10rpx;
  font-size: 28rpx;
}

.uni-tabbar .uni-tabbar__reddot {
  background: #C5AA7B;
  color: #FFFFFF;
}

uni-checkbox:not([disabled]) .uni-checkbox-input:hover {
  border-color: #C5AA7B !important;
}

.u-arrow {
  display: inline-block;
  width: 20rpx;
  height: 20rpx;
  border-top: 1rpx solid #999;
  border-right: 1rpx solid #999;
}

.u-arrow-up {
  transform: rotate(-45deg);
}

.u-arrow-down {
  transform: rotate(135deg);
}

.u-arrow-left {
  transform: rotate(-135deg);
}

.u-arrow-right {
  transform: rotate(45deg);
}

.uni-picker-container .uni-picker-action.uni-picker-action-confirm {
  color: #C5AA7B;
}

.u-drawer-content {
  //border-radius: 0 !important;
}
// 触底样式
.reachBottom {
  margin-top: 30rpx;
  display: flex;
  flex-direction: column;
  align-items: center;

  .reach-icon {
    width: 150rpx;
    height: 150rpx;
  }

  .reach-text {
    margin: 20rpx 0;
    color: #CCCCCC;
  }
}
</style>
<style>
.uni-modal__btn_primary {
  background: #333333;
  color: #FFEBC4 !important;
}
</style>
