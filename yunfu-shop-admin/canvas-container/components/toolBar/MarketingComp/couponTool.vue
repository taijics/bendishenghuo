<template>
  <div class="couponTool">
    <h3 class="toolTit">优惠券</h3>
    <div class="toolBox">
      <tool-coupon :selectedCoupon.sync='activeComponent.componentContent.selectedCoupon' :couponList.sync='activeComponent.componentContent.couponList'></tool-coupon>
<!--      <div class="block colorBox">-->
<!--        <div class="blockTit">-->
<!--          <span>颜色</span>-->
<!--          <span>{{colorList[activeComponent.componentContent.colorActiveIndex].name}}</span>-->
<!--        </div>-->
<!--        <div class="selectColor">-->
<!--          <div class="selectColor">-->
<!--            <div class="colorList">-->
<!--              <div :class="{active: activeComponent.componentContent.colorActiveIndex === index}" v-for="(item, index) of colorList" :key="item.value" @click="selectColor(item, index)"><span></span></div>-->
<!--            </div>-->
<!--          </div>-->
<!--        </div>-->
<!--      </div>-->
<!--      <div class="block showInvBox">-->
<!--        <div class="showInvalid">-->
<!--          <div class="blockTit">-->
<!--            <span>隐藏已抢完及失效的券</span>-->
<!--            <span v-text="isHideCoupon ? '隐藏' : '显示'"></span>-->
<!--          </div>-->
<!--          <div class="showHideBtn">-->
<!--            <el-checkbox v-model="isHideCoupon"></el-checkbox>-->
<!--          </div>-->
<!--        </div>-->
<!--        <p>当前无可显示的优惠券时，优惠券区块将隐藏</p>-->
<!--      </div>-->
    </div>
  </div>
</template>

<script>
  import {toolMixin} from '@@/config/mixin'
  import ToolCoupon from '../toolModule/tool-coupon'
  export default {
    name: 'couponTool',
    mixins: [toolMixin],
    components: {
      ToolCoupon
    },
    data () {
      return {
        title: '', // 标题内容
        colorList: [
          {
            name: '红色',
            value: 'red'
          },
          {
            name: '橘黄色',
            value: 'orange'
          },
          {
            name: '蓝色',
            value: 'blue'
          }
        ],
        // colorActiveIndex: 0,
        dialogVisible: false,
        isHideCoupon: true
      }
    },
    computed: {
    },
    methods: {
      selectCompose (item, index) {
        this.activeComponent.componentContent.arrangeActiveIndex = index
      },
      // 选择卡片样式
      selectCard (item, index) {
        this.activeComponent.componentContent.cardActiveIndex = index
      },
      selectColor (item, index) {
        this.activeComponent.componentContent.colorActiveIndex = index
      }
    }
  }
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
        border: 1px solid #E8EAEC;
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
              background: #EC4B42;
            }
          }
          &:nth-child(2) {
            span {
              background: #FF7800;
            }
          }
          &:nth-child(3) {
            span {
              background: #86A7FF;
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
            border-color: #EC4B42;
          }
          &:nth-child(2) {
            border-color: #FF7800;
          }
          &:nth-child(3) {
            border-color: #86A7FF;
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
