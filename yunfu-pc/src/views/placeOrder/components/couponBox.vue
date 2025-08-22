<template>
  <div class="couponBox" :class="{colorGlod : isSelect}" :title="couponItem.content">
    <icon-svg :icon-class="isSelect ? 'coupon-selected' : 'coupon-unselected'" />
    <div class="des">
      <div class="nums" v-if="couponItem.couponType === 1">
        ¥ <span class="money">{{ couponItem.reduceMoney || 0 }}</span>
      </div>
      <div class="nums" v-if="couponItem.couponType === 2">
        <span class="money">{{ couponItem.reduceMoney || 0 }}</span>折
      </div>
      <div class="cloumn" v-if="couponItem.couponType === 1">
        <!-- <div v-if="couponItem.type === 1">平台券</div> -->
        <!-- <div v-if="couponItem.type === 2">商家券</div> -->
        <div>{{ type }}</div>
        <span>{{couponItem.content}}</span>
      </div>
      <div class="cloumn" v-if="couponItem.couponType === 2">
        <div>{{ type }}</div>
        <span v-if="couponItem.fullMoney">满{{couponItem.fullMoney}}元打{{couponItem.reduceMoney}}折</span>
        <span v-else>{{couponItem.content}}</span>
      </div>
    </div>
    <div class="aside" @click="chooseCoupon(couponItem)">
      <icon-svg class="checkBox" :icon-class="isSelect ? 'pay-checked' : 'pay-unchecked'" />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    couponItem: {
      type: Object,
      default: () => ({})
    },
    type: String,
    isSelect: false
  },
  methods: {
    chooseCoupon (item) {
      this.$emit('couponSelect', item)
    }
  }
}
</script>

<style lang="scss" scoped>
.colorGlod{
  color: #FFEBC4;
}
.couponBox{
  width: 100%;
  height: 100%;
  display: flex;
  .svg-icon{
    width:100%;
    height:100%;
    position: absolute;
    z-index: -1;
  }
  .des{
    margin-left: 5px;
    flex: 9;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    .nums{
      flex: 5;
      text-align: right;
      .money{
        font-size: 32px;
      }
    }
    .cloumn{
      flex: 5;
      height: 35px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      margin-left: 8px;
      font-size: 12px;
      span{
        max-width: 70px;
        white-space: nowrap;
        overflow: hidden;
      }
    }
  }
  .aside{
    flex: 2;
    display: flex;
    justify-content: center;
    align-items: center;
    .checkBox{
      width: 20px;
      height: 20px;
    }
  }
  .marginR{
    margin-right: 100px;
  }
}
</style>
