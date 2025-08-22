<template>
  <div class="couponListSlot" v-if="data">
    <icon-svg v-if="isUse === 1" class="couponType" style="font-size: 180px;" icon-class="coupon-used" />
    <icon-svg v-if="isUse === 2" class="couponType" style="font-size: 180px;" icon-class="coupon-useless" />
    <div class="edge" :class="{edgeRed : false, edgeDefault : disable}">
      <div class="type" v-if="data.shopCouponId !== 0">商家券</div>
      <div class="type" v-if="data.couponId !== 0 ">平台券</div>
    </div>
    <div class="content">
      <div
        class="isRmb leftTop"
        :class="{colorDefault : disable}">
        <span v-if="data.couponType === 1">RMB</span>
        <span>&nbsp;</span>
      </div>
      <div
        class="discount"
        :class="{colorDefault : disable}"
      >
        {{ data.reduceMoney || 0 }}<span v-if="data.couponType === 2" class="isRmb">折</span>
      </div>
      <div class="time">{{ data.endTime }}</div>
      <div class="size" v-if="data.couponType === 1">{{ data.content || 0 }}</div>
      <div class="size" v-else>满{{ data.fullmoney || 0 }}打{{ data.reduceMoney || 0 }}折</div>
    </div>
    <button class="couponBtn"
      :class="{btnDefault : disable}"
      :disabled="disable"
      @click="useCoupon(data)">立即使用</button>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => {}
    },
    // type: {
    //   type: Number,
    //   default: 1 // 左上角角标 1商家券 2平台券  3折扣券
    // },
    isUse: {
      type: Number,
      default: 0 // 右上角状态角标 0正常 1已使用 2已失效
    },
    disable: {
      type: Boolean,
      default: false // 组件是否处于禁用状态
    }
  },
  methods: {
    // 使用优惠券
    useCoupon (item) {
      this.$router.push({
        name: 'couponProList',
        query: {
          // activityId: id, // data.activityId
          // shopCouponId: shopCouponId || null, // shopCouponId
          coupon: JSON.stringify(item)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
$defaultColor: #999;
.couponListSlot{
  display: inline-block;
  width: 220px;
  height: 335px;
  margin-bottom: 5px;
  background: #FAFAFA;
  position: relative;
  .couponType{
    position: absolute;
    right: 0;
    top: -10px;
  }
  .edge{
    width: 0;
    height: 0;
    border: 35px solid;
    border-color: $mainGlod transparent transparent $mainGlod;
    position: relative;
    .type{
      display: block;
      width: 45px;
      color: #FFF;
      transform: rotate(-45deg);
      font-size: 14px;
      font-family: Microsoft YaHei;
      position: absolute;
      top: -15px;
      left: -30px;
    }
  }
  .edgeDefault{
    border-color: #999999 transparent transparent $defaultColor;
  }
  .edgeRed{
    border-color: #C83732 transparent transparent #C83732;
  }
  .content{
    height: 185px;
    text-align: center;
    position: relative;
    .leftTop{
      position: absolute;
      top: -15px;
      left: 0;
      right: 0;
    }
    .isRmb{
      color: $mainGlod;
      font-size: 14px;
      font-family: Microsoft YaHei;
    }
    .discount{
      font-size: 70px;
      font-family: DIN;
      color: $mainGlod;
      margin-bottom: 20px;
    }
    .colorDefault{
      color: $defaultColor;
    }
    .time{
      color: $defaultColor;
      font-size: 12px;
      font-family: Microsoft YaHei;
      margin-bottom: 10px;
    }
    .size{
      color: $defaultColor;
      font-size: 12px;
      font-family: Microsoft YaHei;
    }
  }
  .couponBtn{
    width: 130px;
    height: 40px;
    display: block;
    margin: 0 auto;
    color: $mainGlod;
    background: #333333;
    cursor: pointer;
  }
  .btnDefault{
    color: #FFF;
    background: $defaultColor;
  }
}
</style>
