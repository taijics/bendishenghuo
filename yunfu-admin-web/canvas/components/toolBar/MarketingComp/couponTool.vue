<template>
  <div class="couponTool">
    <h3 class="toolTit">优惠券</h3>
    <div class="toolBox">
      <tool-coupon
        v-model:selectedCoupon="activeComponent.componentContent.selectedCoupon"
        v-model:couponList="activeComponent.componentContent.couponList"
      />
    </div>
  </div>
</template>

<script setup>
import ToolCoupon from '../toolModule/tool-coupon.vue'
import { canvasStore } from '@@/store/canvas';
import { storeToRefs } from 'pinia';
const canvasStoreObj = canvasStore();
const { activeComponent } = storeToRefs(canvasStoreObj);
</script>

<style lang="scss" scoped>
.couponTool {
  padding: 20px 20px 0 20px;
  h3 {
    font-size: 18px;
    font-weight: 500;
    height: 35px;
    line-height: 35px;
    color: #333333;
    margin-bottom: 20px;
  }
  .toolBox {
    padding-bottom: 10px;
    .itemBox {
      label {
        font-size: 14px;
        color: #666666;
        height: 40px;
        line-height: 40px;
      }
      margin-bottom: 15px;
    }
  }
  .block {
    .blockTit {
      padding-top: 20px;
      span {
        margin-right: 16px;
      }
      span:last-child {
        color: $mainColor;
      }
    }
  }
  .colorBox {
    display: flex;
    justify-content: space-between;
    align-items: center;
    .blockTit {
      padding-top: 0;
    }
  }
  .topLine {
    border-top: 1px solid #eeeeee;
  }
  .composeList {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    margin-bottom: 30px;
    padding-top: 20px;
    span {
      width: 50px;
      height: 30px;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 1px solid #e8eaec;
      color: #999999;
      font-size: 18px;
      text-align: center;
      cursor: pointer;
      font-size: 24px;
    }
    span.active {
      color: $mainColor;
      border: 1px solid $mainColor;
    }
    span:hover {
      color: $mainColor;
      border: 1px solid $mainColor;
    }
  }
  .selectColor {
    display: flex;
    align-items: center;
    .colorList {
      display: flex;
      align-items: center;
      div {
        padding: 3px;
        border: 1px solid #eeeeee;
        border-radius: 50%;
        font-style: normal;
        margin-right: 10px;
        cursor: pointer;
        span {
          width: 15px;
          height: 15px;
          border-radius: 50%;
          background: #eeeeee;
          display: block;
        }
        &:nth-child(1) {
          span {
            background: #ec4b42;
          }
        }
        &:nth-child(2) {
          span {
            background: #ff7800;
          }
        }
        &:nth-child(3) {
          span {
            background: #86a7ff;
          }
        }
        &:nth-child(4) {
          span {
            background: #808080;
          }
        }
      }
      div.active {
        &:nth-child(1) {
          border-color: #ec4b42;
        }
        &:nth-child(2) {
          border-color: #ff7800;
        }
        &:nth-child(3) {
          border-color: #86a7ff;
        }
        &:nth-child(4) {
          border-color: #808080;
        }
      }
    }
  }
  .showInvBox {
    p {
      color: #999999;
      font-size: 14px;
    }
  }
  .showInvalid {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 20px 0 13px 0;
    .blockTit {
      padding-top: 0;
    }
  }
}
</style>
