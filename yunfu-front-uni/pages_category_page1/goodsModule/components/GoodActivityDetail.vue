<!--
    * @FileDescription: 商品信息（包括活动信息、优惠券）
    * @Author: kahu
    * @Date: 2022/11/7
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/7
-->
<template>
  <view>
    <!-- 商品详情 -->
    <swiper
        class="goodsImgswiper-box "
        :indicator-dots="true"
        :autoplay="true"
    >
      <swiper-item
          v-for="(imgItem, index) in props.productInfo.images"
          :key="index"
      >
        <image
            class="goodsImg default-img u-skeleton-fillet"
            :src="imgItem"
        ></image>
      </swiper-item>
    </swiper>
    <!-- 分享 -->
    <view
        class="share-box flex-items-plus"
        @click="shareMenuShow"
    >
      <image
          class="share-img"
          :src="`${VUE_APP_STATIC_URL}static/images/shareBut.png`"
      ></image>
      <label class="fs24 mar-left-5">分享</label>
    </view>
    <view class="goodgDes-box flex-start flex-column">
      <view
          v-if="props.skuSelect.activityType === 0"
          class="priceBuyNum-box flex-display u-skeleton-fillet flex-sp-between mar-left-30"
      >
        <view>
          <label class="fs36 font-color-C83732">¥</label>
          <label class="fs36 fs-bold font-color-C83732 mar-left-10">{{ props.skuSelect.price || 0 }}</label>
          <label class="fs24 font-color-999 discountsPriceLine mar-left-20">¥
            {{ props.skuSelect.originalPrice || 0 }}</label>
        </view>
        <label class="fs24 font-color-999">{{ props.productInfo.users || 0 }}人付款</label>
      </view>
      <view
          v-else-if="props.skuSelect.activityType === 8"
          class="sceneMarketingBox"
      >
        <view class="flex-row-plus flex-items-plus mar-left-30 mar-top-10">
          <label class="fs30 font-color-FFF">¥</label>
          <label class="fs42 mar-left-5 font-color-FFF">{{ props.skuSelect.price || 0 }}</label>
          <label class="fs28 mar-left-10 discountsPriceLine font-color-CCC">¥
            {{ props.skuSelect.originalPrice || 0 }}</label>
        </view>
        <view class="sceneNameBox">{{ props.productInfo.sceneName }}</view>
      </view>
      <view
          v-else
          class="seckill-box"
      >
        <view
            class="flex-items flex-sp-between"
            v-if="props.skuSelect.activityType === 9 "
        >
          <view class="vipImg flex-items">
            <image
                class="vip-icon"
                :src="`${VUE_APP_STATIC_URL}static/images/vipDetail.png`"
                mode=""
            >
            </image>
          </view>
          <view class="flex-row-plus flex-items-plus mar-left-30 mar-top-10">
            <label class="fs30 font-color-FFF">¥</label>
            <label class="fs42 mar-left-5 font-color-FFF">{{ props.skuSelect.price || 0 }}</label>
            <label class="fs28 mar-left-10 discountsPriceLine font-color-999">¥
              {{ props.skuSelect.originalPrice || 0 }}
            </label>
          </view>
        </view>
        <view
            v-else
            class="flex-items flex-row flex-sp-between"
        >
          <view class="flex-column-plus">
            <image
                v-if="[2,4].includes(props.skuSelect.activityType)"
                class="seckill-icon"
                :src="`${VUE_APP_STATIC_URL}static/images/seckillicon.png`"
                mode=""
            ></image>
            <image
                v-if="[3,5].includes(props.skuSelect.activityType)"
                class="discount-icon"
                :src="`${VUE_APP_STATIC_URL}static/images/discounticon.png`"
                mode=""
            ></image>
            <image
                v-if="props.skuSelect.activityType === 1"
                class="spell-icon"
                :src="`${VUE_APP_STATIC_URL}static/images/spellicon.png`"
                mode=""
            ></image>
            <view class="flex-row-plus flex-items mar-top-10">
              <label class="fs30 font-color-FFF">¥</label>
              <label class="fs42 mar-left-5 font-color-FFF">{{ props.skuSelect.price || 0 }}</label>
              <label class="fs28 mar-left-10 discountsPriceLine font-color-999">¥
                {{ props.skuSelect.originalPrice || 0 }}
              </label>
            </view>
          </view>
          <view
              v-if="[1,2,3,4,5].includes(props.skuSelect.activityType)"
              class="countdown flex-column-plus"
          >
            <view v-if="props.timeActiveType">
              <label class="fs28">距离结束剩余</label>
              <view class="flex-row-plus fs34 flex-items-plus mar-top-10">
                <view class="countdown-box flex-items-plus">{{ activeTimeObj.day }}</view>
                <view class="font-color-999">天</view>
                <view class="countdown-box flex-items-plus">{{ activeTimeObj.hour }}</view>
                <view class="font-color-999">:</view>
                <view class="countdown-box flex-items-plus">{{ activeTimeObj.min }}</view>
                <view class="font-color-999">:</view>
                <view class="countdown-box flex-items-plus">{{ activeTimeObj.sec }}</view>
              </view>
            </view>
            <view v-else>
              <label class="fs28 mar-right-20">即将开始：{{ props.skuSelect.startTime }}</label>
              <!--              <view class="fs28 mar-right-20 mar-top-20">{{productInfo.startTime}}</view>-->
            </view>
          </view>
        </view>
      </view>
      <view class="nameContainer">
        <view class="goodsName-box overflowNoDot mar-top-30 mar-left-30 u-skeleton-fillet">
          <label class="goodsName fs32 mar-left-20 ">{{ props.productInfo.productName }}</label>
        </view>
        <view
            class="collectBox "
            @click="handleCollect"
        >
          <image
              v-if="props.productInfo.ifCollect === 1"
              class="store-icon"
              :src="`${VUE_APP_STATIC_URL}static/images/shoucangActive1.png`"
          ></image>
          <image
              v-else
              class="store-icon"
              :src="`${VUE_APP_STATIC_URL}static/images/shoucang2x.png`"
          >
          </image>
          <label class="fs22">收藏</label>
        </view>
      </view>
      <view
          v-if="props.markTools.length>0 || props.shopMarkTools.length>0"
          class="activity-box mar-top-10"
          @click="couponShowClick"
      >
        <label class="fs24 font-color-999">优惠</label>
        <view class="activity-content mar-left-30 flex-items flex-sp-between flex-row">
          <view
              class="fs20 overflow"
              style="width: 500rpx;"
          >
            {{ props.productInfo.couponSplicing }}
          </view>
          <view class="flex-items">
            <label class="fs24 font-color-C5AA7B">领券</label>
            <image
                class="coupon-arrow"
                :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
            ></image>
          </view>
        </view>
      </view>
    </view>

    <!--  分享弹出  -->
    <u-action-sheet
        :list="shareObj.actionList"
        v-model="shareObj.actionShow"
        @click="handleShareSelect"
    ></u-action-sheet>

    <ShareSpell
        ref="shareSpell"
        :url="shareObj.url"
        :img="shareObj.image"
        :title="shareObj.title"
        @shareCancel="shareCancel"
    />
  </view>
</template>


<script setup>
import { ref } from "vue";
import { request } from "@/utils/request";
import API from "@/config/api";
import ShareSpell from '../../../component/share.vue'
import { TimeFormatting } from "@/utils/timeUtil";
import { onShareTimeline } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  // 商品信息
  productInfo: {
    type: Object,
    default: () => ({})
  },
  // 当前选中的sku
  skuSelect: {
    type: Object,
    default: () => ({})
  },
  timeActiveType: {
    type: Boolean,
    default: () => false
  },
  markTools: {
    type: Array,
    default: () => ([])
  },
  shopMarkTools: {
    type: Array,
    default: () => ([])
  }
})
const emit = defineEmits(['couponClick'])

// ================================= 倒计时相关 ========================================================
const timeDifference = ref(0)
const activeTimeObj = ref({
  day: '00',
  hour: '00',
  min: '00',
  sec: '00'
})
const countdownInterval = ref(null)
/**
 * 初始化活动倒计时
 * @param endTimestamp
 */
function handleGetCountDownNumber(endTimestamp) {
  endTimestamp = endTimestamp.substring(0, 19).replace(/-/g, '/');
  // 与当前时间的时间差（秒）
  const timeDifferences = (new Date(endTimestamp).getTime() - new Date().getTime()) / 1000;
  timeDifference.value = timeDifferences
  activeTimeObj.value = TimeFormatting(timeDifferences)
  handleCountDown()
}

/**
 * 开始倒计时
 */
function handleCountDown() {
  if (countdownInterval.value) {
    return
  }
  countdownInterval.value = setInterval(() => {
    if(timeDifference.value > 0){
      timeDifference.value--
      activeTimeObj.value = TimeFormatting(timeDifference.value)
      return
    }
    clearInterval(countdownInterval.value)
    uni.showToast({
      title: "活动结束",
      duration: 2000,
      icon: 'none'
    })
    emit('activityEnd', 0)
  }, 1000)
}

/**
 * 拉起父组件优惠券
 */
function couponShowClick() {
  emit('couponClick')
}

/**
 * 收藏
 */
function handleCollect() {
  const {ifCollect,productId} = props.productInfo
  if (ifCollect === 0) {
    request(API.collect, {
      productId: parseInt(productId)
    }, 'POST').then(res => {
      // todo 禁止逆向修改PROPS
      props.productInfo.ifCollect = 1
      uni.showToast({
        title: '收藏成功',
        icon: "success"
      })
    })
  } else {
    request(API.cancelCollect, {
      ids: [productId]
    }, 'PUT').then(res => {
      // todo 禁止逆向修改PROPS
      props.productInfo.ifCollect = 0
      uni.showToast({
        title: '取消收藏成功',
        icon: "success"
      })
    })
  }
}

// ====================================================== 分享相关 =======================================================
// 分享信息对象
const shareObj = ref({
  url: '',
  image: '',
  title: '好友分享了一个很棒的商品',
  actionList: [
    {text: '生成分享海报'},
    {text: '邀请好友'}
  ],
  actionShow: false
})

// 分享REF
const shareSpell = ref()

/**
 * 打开分享上拉
 */
function shareMenuShow() {
  shareObj.value.actionShow = true
}

/**
 * 关闭分享菜单
 */
function shareCancel() {
  shareSpell.value.shareShow = false
}

/**
 * 选择分享菜单后
 * @param index
 */
function handleShareSelect(index) {
  if (index === 0) {
    // 海报分享
    sharePoster()
  } else {
    shareObj.value.url = '/pages_category_page1/goodsModule/goodsDetails?shopId=' + props.productInfo.shopId + '&productId=' + props.productInfo.productId + '&skuId=' + props.skuSelect.skuId
    shareObj.value.image = props.productInfo.images[0]
    shareObj.value.title = `【cereshop】好友分享了一个好物给您！${ props.productInfo.productName } ￥${ props.productInfo.price } `
    shareSpell.value.shareShow = true
  }
}

onShareTimeline(()=>({
  title:`【cereshop】好友分享了一个好物给您！${ props.productInfo.productName } ￥${ props.productInfo.price } `,
  imageUrl: props.productInfo.images[0],
  path:'/pages_category_page1/goodsModule/goodsDetails?shopId=' + props.productInfo.shopId + '&productId=' + props.productInfo.productId + '&skuId=' + props.skuSelect.skuId
}))

/**
 * 海报分享
 */
function sharePoster() {
  let system = undefined
  // #ifdef APP-PLUS
  system = 1
  // #endif

  // #ifdef H5
  system = 3
  // #endif

  // #ifdef MP-WEIXIN
  system = 2
  // #endif

  // #ifdef MP-ALIPAY
  system = 4
  // #endif
  uni.showLoading({
    mask: true,
    title: '请稍候...'
  })
  request(API.getSharePic, {
    productId: props.productInfo.productId,
    shopId: props.productInfo.shopId,
    skuId: props.skuSelect.skuId,
    terminal: system
  }, 'GET').then(res => {
    uni.hideLoading()
    // 推广商品
    uni.navigateTo({
      url: `/pages_category_page1/distributionModule/shareProduct?shareType=2&productImage=${ props.productInfo.images[0] }&shopId=${ props.productInfo.shopId }&productId=${ props.productInfo.productId }&skuId=${ props.skuSelect.skuId }&productName=${ props.productInfo.productName }&price=${ props.productInfo.price }&headImage=${ res.data.headImage }&shareName=${ res.data.name }&shareImg=${ res.data }`
    });
  }).catch(err => {
    uni.hideLoading()
    throw Error(err)
  })
}

// ================================================== 组件相关 =======================================================
defineExpose({handleGetCountDownNumber})
</script>

<style
    lang="scss"
    scoped
>
@import "../../../style/images";
.goodsImgswiper-box {
  width: 750upx;
  height: 750upx;

  .goodsImg {
    width: 750upx;
    height: 750upx;
  }
}

.share-box {
  width: 200upx;
  height: 60upx;
  background-color: #FFFFFF;
  border-radius: 30upx 0 0 30upx;
  position: absolute;
  top: 30upx;
  right: 0;
  z-index: 99;

  .share-img {
    width: 36upx;
    height: 36upx;
  }
}

.goodgDes-box {
  background-color: #FFFFFF;
  width: 100%;
  padding-bottom: 25upx;

  .priceBuyNum-box {
    width: 677upx;
    margin-top: 30upx;
  }

  .nameContainer {
    display: flex;

    .goodsName-box {
      width: 677upx;
      height: 85upx;

      .img618-cion {
        width: 70upx;
        height: 36upx;
      }
      .goodsName {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }

    .collectBox {
      width: 80rpx;
      margin: 0 30rpx 0 15rpx;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    .store-icon {
      width: 48upx;
      height: 48upx;
    }
  }

  .discounts-box {
    margin-top: 20upx;

    .discounts-text {
      margin-left: 10upx;
      color: #FF7800;
      background-color: #FFE4CC;
      padding: 6upx 12upx;
      border-radius: 4upx;
    }
  }

  .activity-box {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: flex-end;
    border-top: 1upx solid #EDEDED;

    .activity-content {
      width: 614upx;
      padding-top: 20upx;

      .activity-text {
        color: #FF7700;
        border: 1upx solid #FF7700;
        padding: 6upx 23upx;
      }

      .coupon-arrow {
        width: 16upx;
        height: 24upx;
        margin-left: 15upx;
      }
    }
  }
}

.seckill-box {
  width: 100%;
  background: $storeTopImg no-repeat left top;
  padding: 35rpx 30rpx;

  .seckill-icon {
    width: 187rpx;
    height: 41rpx;
    background-size: contain;
  }

  .vip-icon {
    width: 187rpx;
    height: 41rpx;
    background-size: contain;
  }

  .discount-icon {
    width: 187rpx;
    height: 41rpx;
    background-size: contain;
  }

  .spell-icon {
    width: 182rpx;
    height: 37rpx;
    background-size: contain;
    margin-bottom: 20rpx;
  }

  .countdown {
    text-align: center;

    label {
      text-align: center;
      color: #CCCCCC;
    }
  }

  .countdown-box {
    padding: 0 8rpx;
    height: 48rpx;
    color: #FFEBC4;
    background-color: #525252;
    margin: 10rpx;
  }
}
.sceneMarketingBox {
  width: 100%;
  background: $sceneMarketingDetailsIcon no-repeat center;
  padding: 20rpx 30rpx;
  background-size: cover;
  display: flex;
  justify-content: space-between;
  align-items: center;
  .sceneNameBox {
    width: 220rpx;
    text-align: center;
    color: #C83732;
    font-size: 20rpx;
  }
}
</style>
