<template>
  <div
    class="couponBox warp"
    :class="[
      'terminal' + terminal,
      'arrange' + (componentContent.arrangeActiveIndex + 1),
      'color' + (componentContent.colorActiveIndex + 1),
    ]"
  >
    <div v-if="componentContent.selectedCoupon" class="couponListBox">
      <div
        v-for="(item, index) in couponsData"
        :key="index"
        class="listItemBox"
        :class="item.state && item.state !== 3 && 'isReceive'"
      >
        <div class="listItemBoxInner">
          <div class="itemInfo">
            <i class="flag" :class="'flag' + item.couponType" />
            <div class="amount">
              <b v-if="item.couponType !== 2">￥</b>
              <span v-if="typeId !== 1">
                {{ item.couponContent }}
              </span>
              <span v-else>
                {{ item.reduceMoney }}
              </span>
              <b v-if="item.couponType == 2">折</b>
            </div>
            <div class="couponInfo">
              <p>{{ item.content }}</p>
            </div>
          </div>
          <!--            <div class="itemInfo" v-else>-->
          <!--              <div class="amount">-->
          <!--                <b>￥</b><span>{{item.reduceMoney}}<i>满减券</i></span>-->
          <!--              </div>-->
          <!--              <div class="couponInfo">-->
          <!--                <p>{{item.content}}</p>-->
          <!--              </div>-->
          <!--            </div>-->
          <div v-if="item.state === 0" class="receiveBtn">
            <span>己领取</span>
          </div>
          <div v-else-if="item.state === 1" class="receiveBtn">
            <span>已使用</span>
          </div>
          <div v-else-if="item.state === 2" class="receiveBtn">
            <span>已过期</span>
          </div>
          <div v-else class="receiveBtn" @click="receiveCoupon(item)">
            <span>立即领取</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import commonMixin from '../mixin';
import { toRefs } from 'vue';
const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
  typeId: {
    type: Number,
    default: 1,
  },
  shopId: {
    type: Number,
    default: 0,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    },
  },
});
const { terminal, typeId, shopId, componentContent } = toRefs(props);
const { couponsData, receiveCoupon, jumpStore } = commonMixin(componentContent, typeId, shopId);
</script>

<style lang="scss" scoped>
.couponBox {
  min-height: 177px;
  margin: 0 auto;
  padding: 20px 0;
  .couponListBox {
    flex-wrap: wrap;
    /**默认**/
    .listItemBox {
      //background-image:url('../../../static/images/coupon/border_L1.png'), url('../../../static/images/coupon/border_R1.png');
      //background-repeat: no-repeat, no-repeat;
      //background-position: left top, right top;
      box-sizing: border-box;
      .listItemBoxInner {
        width: 100%;
        height: 150px;
        display: flex;
        background-color: #fafafa;
        align-items: center;
        justify-content: space-between;
        position: relative;
        .flag {
          display: block;
          width: 71px;
          height: 71px;
          background-repeat: no-repeat;
          position: absolute;
          top: 0;
          left: 0;
          &.flag1 {
            background-image: url("../../../static/images/coupon/flag-coupon.png");
          }
          &.flag2 {
            background-image: url("../../../static/images/coupon/flag-coupon2.png");
          }
        }
        .itemInfo {
          flex: 1;
        }
        .amount {
          max-width: 90%;
          margin: 0 auto;
          display: flex;
          align-items: baseline;
          justify-content: center;
          line-height: 60px;
          b {
            font-size: 30px;
          }
          span {
            font-size: 60px;
            font-weight: bold;
          }
          i {
            font-style: normal;
            font-size: 18px;
            margin-left: 5px;
          }
        }
        .couponInfo {
          text-align: center;
          p {
            display: inline-block;
            padding: 0 42px;
            text-align: center;
            font-size: 18px;
            line-height: 40px;
            color: #c83732;
            background: #f5e5e5;
          }
        }
      }
      .receiveBtn {
        width: 72px;
        margin-right: 5px;
        background: #c5aa7b;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        position: relative;
        &:before,
        &:after {
          content: "";
          display: block;
          width: 25px;
          height: 25px;
          background-color: #fff;
          position: absolute;
          left: -12.5px;
          border-radius: 50%;
        }
        &:before {
          top: -12.5px;
        }
        &:after {
          bottom: -12.5px;
        }
        span {
          color: #ffffff !important;
          writing-mode: vertical-lr;
          font-size: 19px;
        }
      }
      &.isReceive {
        //background-image:url('../../../static/images/coupon/border_L4.png'), url('../../../static/images/coupon/border_R4.png');
        .listItemBoxInner {
          .flag {
            &.flag1 {
              background-image: url("../../../static/images/coupon/flag-coupon-r.png");
            }
            &.flag2 {
              background-image: url("../../../static/images/coupon/flag-coupon2-r.png");
            }
          }
          .itemInfo {
            color: #999;
            .couponInfo {
              p {
                color: #999;
                background: #f1f1f1;
              }
            }
          }
          .receiveBtn {
            cursor: auto;
            background: #999;
          }
        }
      }
    }
  }

  @mixin cardColor($bgColor: #ff3737, $fontColor: #fff) {
    .couponListBox {
      .listItemBox {
        .listItemBoxInner {
          background: $bgColor;
        }
        .itemInfo {
          .amount {
            b {
              color: #ec4b42;
            }
            span {
              color: #ec4b42;
              i {
                color: #ec4b42;
              }
            }
          }
          .couponInfo {
            color: #ec4b42;
          }
        }
        .receiveBtn {
          span {
            color: #ec4b42;
          }
        }
        &.cardStyle3 {
          .itemInfo {
            .amount {
              span {
                color: $bgColor;
                i {
                  color: $bgColor;
                }
              }
            }
            .couponInfo {
              color: $bgColor;
            }
          }
        }
        &.cardStyle4 {
          border: 2px solid $bgColor;
          padding: 5px;
          .listItemBoxInner {
            padding: 20px 15px;
            height: 85px;
            border: 1px solid $bgColor;
          }
          .itemInfo {
            .amount {
              span {
                color: $bgColor;
                i {
                  color: $bgColor;
                }
              }
            }
            .couponInfo {
              color: $bgColor;
            }
          }
          .receiveBtn {
            border-left: 1px $bgColor dashed;
            span {
              color: $bgColor;
            }
          }
        }
      }
    }
  }
  &.arrange2 {
    max-width: 100%;
    .couponListBox {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      .listItemBox {
        width: 48%;
      }
    }
  }
  &.arrange3 {
    max-width: 100%;
    .couponListBox {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      .listItemBox {
        width: 32%;
      }
    }
  }
  &.arrange4 {
    max-width: 100%;
    .couponListBox {
      display: flex;
      overflow: hidden;
      .listItemBox {
        width: 268px;
        flex: 0 0 268px;
        margin: 0 25px 25px 0;
        &:nth-child(4n) {
          margin-right: 0;
        }
      }
    }
  }
  //&.color1{
  //  .listItemBox {
  //    background-image:url('../../../static/images/coupon/border_L1.png'), url('../../../static/images/coupon/border_R1.png');
  //    .listItemBoxInner {
  //      border-top: 1px solid #EC4B42;
  //      border-bottom: 1px solid #EC4B42;
  //      .itemInfo {
  //        color: #EC4B42;
  //        .amount {
  //          border-bottom: 1px solid #EC4B42;
  //        }
  //        .couponInfo {
  //          p {
  //            color: #EC4B42;
  //          }
  //        }
  //      }
  //      .receiveBtn {
  //        background: #EC4B42;
  //      }
  //    }
  //  }
  //}

  &.color2 {
    .listItemBox {
      background-image: url("../../../static/images/coupon/border_L2.png"),
        url("../../../static/images/coupon/border_R2.png");
      .listItemBoxInner {
        border-top: 1px solid #ff7800;
        border-bottom: 1px solid #ff7800;
        .itemInfo {
          color: #ff7800;
          .amount {
            border-bottom: 1px solid #ff7800;
          }
          .couponInfo {
            p {
              color: #ff7800;
            }
          }
        }
        .receiveBtn {
          background: #ff7800;
        }
      }
    }
  }

  &.color3 {
    .listItemBox {
      background-image: url("../../../static/images/coupon/border_L3.png"),
        url("../../../static/images/coupon/border_R3.png");
      .listItemBoxInner {
        border-top: 1px solid #86a7ff;
        border-bottom: 1px solid #86a7ff;
        .itemInfo {
          color: #86a7ff;
          .amount {
            border-bottom: 1px solid #86a7ff;
          }
          .couponInfo {
            p {
              color: #86a7ff;
            }
          }
        }
        .receiveBtn {
          background: #86a7ff;
        }
      }
    }
  }
}
</style>
