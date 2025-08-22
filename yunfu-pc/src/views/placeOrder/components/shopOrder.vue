<template>
  <div class="shopOrder">
    <div class="shopName flexCom">
      <div class="flex1 itemShop">店铺：{{shopsData.shopName}}</div>
      <div class="flex3 itemName">宝贝</div>
      <div class="flex1">宝贝属性</div>
      <div class="flex1">单价</div>
      <div class="flex1">数量</div>
      <div class="flex2">优惠方式</div>
      <div class="flex1">小计</div>
    </div>
    <div class="orderList">
      <div class="orderItem flexCom" v-for="order of shopsData.skus" :key="order.skuId">
        <div class="itemImg flex1">
          <img :src="order.image" :alt="order.productName">
        </div>
        <div class="itemName flex3">
          <span>{{order.productName}}</span>
        </div>
        <div class="itemSku flex1">
          <span>{{order.sku}}</span>
          <span>{{order.value}}</span>
        </div>
        <div class="itemPrice flex1">￥{{order.price}}</div>
        <div class="itemNum flex1">{{order.number}}</div>
        <div class="activityBox flex2">
          {{
            type == 1
              ?'拼团':(order.platformSeckillId || order.shopSeckillId)
              ?'秒杀' : (order.platformDiscountId || order.shopDiscountId)
              ?'折扣' : order.priceId
              ?'定价捆绑' : order.composeId
              ?'组合捆绑' : order.sceneId
              ? '场景营销': order.useMember
              ? '会员价' : '无'
          }}
        </div>
        <div class="totalBox flex1">￥{{order.total}}</div>
      </div>
    </div>
    <div v-if="shopsData.receiveNotMatch" class="adressTips">当前地址不支持配送，，可更换其他地址试试</div>
    <slot name="coupon"></slot>
    <div class="remarksBox">
      <div class="remarksInfo">
        <el-input
          type="textarea"
          :rows="2"
          resize="none"
          placeholder="如有其他要求，请备注。"
          v-model="shopsData.remark">
        </el-input>
      </div>
    </div>
    <div class="orderTotalBox">
      <div class="discount" v-if="shopsData.skuDiscountInfoMap">
        <div class="shippingBox"
          v-for="item in Object.keys(shopsData.skuDiscountInfoMap)"
          :key="item"
        >
          {{ shopsData.skuDiscountInfoMap[item][0] }}
          <span>{{ shopsData.skuDiscountInfoMap[item][1].replace('优惠', '-') }}</span>
        </div>
      </div>
      <div class="shippingBox">运费：<span>￥{{ shopsData.distribution.distributionPrice || 0 }}</span></div>
      <div class="orderTotalBox">店铺合计：<b>￥{{ (shopsData.total + (shopsData.distribution.distributionPrice || 0)).toFixed(2) }}</b></div>
    </div>
  </div>
</template>

<script>
import CouponBox from '@/views/placeOrder/components/couponBox.vue'
export default {
  name: 'shopOrder',
  components: {
    CouponBox
  },
  props: {
    shopsData: {
      type: Object,
      default: () => ({})
    },
    type: Number
  },
  data () {
    return {
      index: 0
    }
  },
  methods: {
    couponSelect (item) {
      this.$emit('couponSelect', item)
    }
  }
}
</script>

<style lang="scss" scoped>
.shopOrder {
  margin-bottom: 50px;
  .orderTotalBox {
    margin-top: 20px;
    text-align: right;
    font-size: 16px;
    .shippingBox {
      margin: 16px 0;
      color: #333333;
    }
    .orderTotalBox {
      color: #333333;
    }
    b {
      color: $mainGlod;
    }
    span {
      color: #C83732;
    }
  }

  .shopName {
    height: 50px;
    padding: 0 15px;
    color: #FFF;
    background-color: #333;
    font-size: 16px;
    .itemShop{
      white-space: nowrap;
    }
  }
  .flexCom{
    display: flex;
    align-items: center;
    text-align: center;
    .flex1{
      flex: 1;
    }
    .flex2{
      flex: 2;
    }
    .flex3{
      flex: 3;
    }
    .flex4{
      flex: 4;
    }
    .flex5{
      flex: 5;
    }
  }
  .orderList {
    width: 100%;
    margin-bottom: 30px;
    .orderItem {
      color: #333;
      border: 1px solid #E5E5E5;
      border-bottom: none;
      padding: 15px;
      img{
        width: 100px;
        height: 100px;
      }
      .itemName{
        text-align: center;
      }
      .activityBox {
        width: 10%;
        text-align: center;
        font-size: 16px;
      }
      .discountBox {
        width: 20%;
        display: flex;
        justify-content: center;
        color: #666666;
        >>> .el-select {
          width: 200px;
          .el-input__inner {
            height: 34px;
            line-height: 34px;
          }
        }
      }
      .totalBox {
        width: 10%;
        text-align: center;
        color: $mainGlod;
        font-weight: bold;
      }
    }
    .orderItem:last-child {
      border-bottom: 1px solid #E5E5E5;
    }
  }
  .adressTips{
    color: #C83732;
  }
  .remarksBox {
    display: flex;
    background: #F7F7F7;
    padding: 25px 35px;
    .remarksInfo {
      width: 100%;
      >>> .el-textarea__inner {
        width: 100%;
        height: 84px;
      }
    }
    .selectBox {
      margin-left: 70px;
      label {
        color: #666666;
        font-size: 16px;
        font-weight: normal;
      }
    }
    .shopTotal {
      color: $mainGlod;
      flex: 1;
      text-align: right;
    }
  }
}
</style>
