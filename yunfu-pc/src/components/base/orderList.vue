<template>
  <div class="orderList">
    <div class="head">
      <div style="flex: 9; padding-left: 20px">
        <span style="flex: 5">宝贝</span>
        <span style="flex: 2">单价</span>
        <span style="flex: 2">数量</span>
      </div>
      <div style="flex: 8; padding-right: 20px">
        <span style="flex: 1">实付款</span>
        <span style="flex: 1">收货人</span>
        <span style="flex: 1">状态</span>
        <span style="flex: 1">操作</span>
      </div>
    </div>
    <div v-if="flag">
      <div class="content" v-for="(item, index) in orderList" :key="index">
        <div class="top">
          <div class="left">
            <span class="shopName" @click="toStore(item.shopId)"
              ><img :src="item.shopLogo" alt="" />{{ item.shopName }}</span
            >
            <span class="time">{{ item.createTime }}</span>
            <span class="orderCode">订单号：{{ item.orderFormid }}</span>
          </div>
          <div class="right">
          <div @click="$emit('isDelete', item.orderId)">
            <icon-svg
              v-if="item.state == 5"
              style="font-size: 24px; cursor: pointer;" icon-class="del"
            />
          </div>
          </div>
        </div>
        <div class="productBox">
          <div class="product">
            <div class="left fs13">
              <div
                class="box"
                v-for="(items, indexs) in item.skus"
                :key="indexs"
              >
                <div
                  class="desc cur-poi"
                  @click="toProductDetail(item.shopId, items)"
                >
                  <img :src="items.image" alt="" />
                  <div>
                    <p class="name">{{ items.productName }}</p>
                    <p class="size font-color-999">
                      <span v-for="(val, idx) in items.values" :key="idx">{{
                        val
                      }}</span>
                    </p>
                  </div>
                </div>
                <div class="price">¥{{ items.price }}</div>
                <div class="num">
                  <p class="fs14">{{ items.number }}</p>
                  <!-- <p v-if="items.afterState === 1" class="fs14" style="color: #c83732;">
                    (售后审核中)
                  </p>
                  <p v-if="items.afterState === 2" class="fs14" style="color: #c83732;">
                    (退款中)
                  </p>
                  <p v-if="items.afterState === 3" class="fs14" style="color: #c83732;">
                    (退货中)
                  </p>
                  <p v-if="items.afterState === 4" class="fs14" style="color: #c83732;">
                    (退款成功)
                  </p>
                  <p v-if="items.afterState === 5" class="fs14" style="color: #c83732;">
                    (退款失败)
                  </p>
                  <p v-if="items.afterState === 6" class="fs14" style="color: #c83732;">
                    (审核不通过)
                  </p>
                  <p v-if="items.afterState === 7" class="fs14" style="color: #c83732;">
                    (售后评审中)
                  </p>
                  <p v-if="items.afterState === 8" class="fs14" style="color: #c83732;">
                    (退货完成，拒绝退款)
                  </p>
                  <p v-if="items.afterState === 10" class="fs14" style="color: #c83732;">
                    (售后审核通过)
                  </p> -->
                </div>
              </div>
            </div>
            <div
              class="right"
              :class="item.skus.length > 1 ? 'right_line' : ''"
            >
              <div class="actualPay">
                <div>
                  <p class="fs13 mar-bot-5">
                    ¥{{ (item.orderPrice - item.discountPrice).toFixed(2) }}
                  </p>
                  <p class="fs13 colorRed">(含运费：¥{{ item.logisticsPrice }})</p>
                </div>
              </div>
              <div class="consignee">{{ item.receiveName }}</div>
              <div class="status">
                <div>
                  <p
                    class="fs13 mar-bot-5 colorRed"
                    v-if="item.state == 1"
                  >
                    待付款
                  </p>
                  <div v-if="item.state == 1">
                    <p class="time fs12 mar-bot-10 font-color-999 flex-items">
                      <img
                        style="width: 13px; height: 13px; margin-right: 5px"
                        src="../../../static/image/alarm_clock@2x.png"
                        alt=""
                      />
                      剩余时间{{ item.time | formatMinutes }}分
                    </p>
                  </div>
                  <p
                    class="fs13 mar-bot-5 colorGlod"
                    v-if="item.state == 2"
                  >
                    待发货
                  </p>
                  <p
                    class="fs13 mar-bot-5 colorGlod"
                    v-if="item.state == 3"
                  >
                    待收货
                  </p>
                  <p
                    class="fs13 mar-bot-5 font-color-999"
                    v-if="item.state == 4"
                  >
                    已完成
                  </p>
                  <p
                    class="fs13 mar-bot-5 font-color-999"
                    v-if="item.state == 5"
                  >
                    已关闭
                  </p>
                  <p
                    class="fs13 mar-bot-5 colorRed"
                    v-if="item.state == 6"
                  >
                    待成团
                  </p>
                  <p class="fs13 cur-poi" @click="toOrderDetail(item.orderId)">
                    订单详情
                  </p>
                </div>
              </div>
              <div class="operate">
                <div class="btnContainer">
                  <el-button
                    class="btn btnBlack"
                    size="small"
                    v-if="
                      item.state == 1 ||
                      (item.paymentState == 0 && item.state == 6)
                    "
                    @click="getUrl(item.orderId)"
                    v-throttle
                    >去付款</el-button>
                  <el-button
                    class="btn btnBlack"
                    size="small"
                    v-if="item.state == 2"
                    @click="remind(item.orderId)"
                    v-throttle
                    >提醒发货</el-button>
                  <el-button
                    class="btn btnBlack"
                    size="small"
                    v-if="item.state == 3 && item.ifAfter == 1"
                    @click="$emit('isConfirm', item.orderId)"
                    v-throttle
                    >确认收货</el-button>
                  <el-button
                    class="btn btnBlack"
                    size="small"
                    v-if="item.state == 4 || item.state == 5"
                    @click="buyAgain(item)"
                    v-throttle
                    >再次购买</el-button>
                  <p
                    class="btn"
                    @click="$emit('isCancel', item.orderId)"
                    v-if="item.state == 1 || item.state == 6"
                    v-throttle
                  >
                    取消订单
                  </p>
                  <p
                    class="btn"
                    @click="toAfterSale(item)"
                    v-if="item.state == 2 && !item.afterState"
                    v-throttle
                  >
                    退货/退款
                  </p>
                  <p
                    class="btn"
                    @click="$emit('isRefund', item)"
                    v-if="
                      ((item.state == 3 && item.ifAfter)
                      || (item.state == 4 && item.ifAfter))
                      && !item.afterState
                    "
                    v-throttle
                  >
                    退货/退款
                  </p>
                  <p
                    class="btn"
                    v-if="item.state == 4 && item.ifNotComment === 1"
                    @click="toEvaluate(item)"
                    v-throttle
                  >
                    评价
                  </p>
                  <p
                    class="btn"
                    v-if="item.state == 3"
                    @click="toOrderDetail(item.orderId)"
                    v-throttle
                  >
                    查看物流
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <el-pagination
        :current-page="page"
        :page-size="5"
        @current-change="handleCurrentChange"
        background
        layout="prev, pager, next"
        :total="total"
      ></el-pagination>
    </div>
    <div class="noorder" v-else>
      <icon-svg
        style="width: 240px; height: 240px; margin-bottom: 20px"
        icon-class="user-order-nodata"
      />
      <p class="fs20 font-color-999">你还没有订单哦～</p>
      <router-link to="/">
        <el-button>去首页看看</el-button>
      </router-link>
    </div>
    <el-dialog
      class="weChat"
      title="微信支付"
      :visible.sync="weChatDialog"
      :before-close="handleClose"
      width="300px"
    >
      <div class="qCode">
        <div class="wechatTitle">
            <div class="tips">
              <p>请使用微信扫一扫</p>
              <p>扫描二维码支付</p>
            </div>
            <div>￥{{ payInfo.money }}</div>
          </div>
          <img class="code" :src="payInfo.url" alt="">
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapMutations } from 'vuex'

import {
  buyItAgain,
  checkOrderResult,
  orderPayCode
} from '@/api/user/order.js'
import {
  getCartList
} from '@/api/user/cart.js'

export default {
  props: ['orderList', 'total', 'page', 'flag'],
  data () {
    return {
      payInfo: {},
      weChatDialog: false,
      chatTimer: '',
      endTime: '',
      endTime1: ''
    }
  },
  filters: {
    formatMinutes: function (value) {
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      if (minutes < 10) {
        return '0' + minutes
      } else {
        return minutes
      }
    }
  },
  methods: {
    ...mapMutations({
      setCartNumber: 'SET_CARTNUMBER',
      setShoppingCart: 'SET_SHOPPINGCART'
    }),
    // 跳转到商品详情
    toProductDetail (id, item) {
      let data = {
        shopId: id,
        productId: item.productId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.$emit('handleCurrentChange', val)
    },
    // 提醒发货
    remind (id) {
      this.$message({
        message: '已提醒卖家发货',
        type: 'success'
      })
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store',
        query: {
          shopId: id
        }
      })
    },
    // 跳转到订单详情
    toOrderDetail (id) {
      this.$router.push({
        path: '/orderDetail',
        query: {
          orderId: id
        }
      })
    },
    // 再次购买
    async buyAgain (item) {
      if (item.shopDiscountId !== 0 || item.shopGroupWorkId !== 0 || item.shopSeckillId !== 0) {
        this.$message.warning('活动商品无法再次购买')
        return
      }
      const response = await buyItAgain({ orderId: item.orderId })
      const res = response.data
      if (res.code === '200') {
        this.$router.push('/shopping-trolley')
      } else {
        this.$message({
          message: res.message,
          type: 'warning'
        })
      }
    },
    // 跳转到评价
    toEvaluate (data) {
      console.log(data)
      this.$router.push({
        path: '/evaluate',
        query: {
          product: JSON.stringify(data)
        }
      })
    },
    // 申请售后
    toAfterSale (item) {
      this.$router.push({
        path: '/afterSale',
        query: {
          orderData: JSON.stringify(item),
          state: 1
        }
      })
    },
    // 去支付
    checkPay (data) {
      setTimeout(() => {
        checkOrderResult({
          collageId: data.collageId,
          money: data.money,
          orderId: data.orderId,
          type: 2
        }).then(response => {
          const res = response.data
          if (res.code === '200') {
            if (res.data.code === 'SUCCESS') {
              this.$message.success('支付成功！')
              clearInterval(this.chatTimer)
              this.getTrolleyList()
              this.weChatDialog = false
              this.toOrderDetail(data.orderId)
            }
          } else {
            clearInterval(this.chatTimer)
            this.$message.error(res.message)
            this.weChatDialog = false
          }
        })
      }, 0)
    },
    // 购物车列表
    async getTrolleyList () {
      const response = await getCartList()
      const res = response.data
      let cartNumber = 0
      if (res.data.length) {
        res.data.forEach((j) => {
          cartNumber = cartNumber + j.skus.length
        })
      }
      this.setShoppingCart(res.data)
      this.setCartNumber(cartNumber)
    },
    // 去支付
    async getUrl (id) {
      const response = await orderPayCode({ orderId: id })
      const res = response.data
      if (res.code === '200') {
        this.payInfo = res.data
        this.weChatDialog = true
        this.chatTimer = setInterval(() => {
          this.checkPay(res.data)
        }, 3000)
      } else {
        this.$message.error(res.message)
      }
    },
    handleClose () {
      this.$confirm('确认取消支付？')
        .then((_) => {
          clearInterval(this.chatTimer)
          this.weChatDialog = false
        })
        .catch((_) => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.orderList {
  width: 100%;
  .colorRed{
    color: #C83732;
  }
  .colorGlod{
    color: #C5AA7B;
  }
  .noorder {
    width: 100%;
    text-align: center;
    padding: 100px 0;
    p {
      margin-bottom: 20px;
    }
    .el-button {
      width: 200px;
      height: 50px;
      padding: 0;
      background-color: #333;
      color: $mainGlod;
      font-size: 14px;
      font-family: Microsoft YaHei;
      border-radius: 0;
    }
  }
  .head {
    box-sizing: border-box;
    width: 100%;
    height: 50px;
    // background-color: #F1F2F7;
    background: #ffffff;
    border: 2px solid #f3f4f5;
    display: flex;
    align-items: center;
    text-align: center;
    margin-bottom: 10px;
    div {
      display: flex;
    }
  }
  .content {
    width: 100%;
    margin-bottom: 20px;
    border: 1px solid #e5e5e5;
    // border-bottom: 0;
    box-sizing: border-box;
    &:hover{
      border-color: $mainGlod;
      .top{
        background-color: $mainGlod;
      }
    }
    .top {
      width: 100%;
      font-size: 13px;
      height: 40px;
      color: #fff;
      background-color: #333333;
      display: flex;
      justify-content: space-between;
      align-items: center;
      .left {
        flex: 15;
        height: 100%;
        display: flex;
        align-items: center;
        .shopName {
          display: inline-block;
          margin-left: 20px;
          min-width: 150px;
          cursor: pointer;
          overflow: hidden;
          white-space: nowrap;
          text-overflow: ellipsis;
          img {
            width: 16px;
            height: 16px;
            vertical-align: middle;
            margin-right: 5px;
          }
        }
        .time {
          margin-right: 60px;
        }
      }
      .right {
        flex: 2;
        display: flex;
        align-items: center;
        justify-content: center;
        // padding-right: 20px;
      }
    }
    .productBox {
      width: 100%;
      box-sizing: border-box;
      .product {
        width: 100%;
        display: flex;
        .left {
          flex: 9;
          .box {
            padding: 20px 0 20px 20px;
            display: flex;
            border-bottom: 1px solid #e5e5e5;
            .desc {
              flex: 5;
              display: flex;
              img {
                width: 100px;
                height: 100px;
                margin-right: 10px;
              }
              div {
                width: 100%;
                margin-bottom: 10px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                .name {
                  font-size: 14px;
                  overflow: hidden;
                  white-space: nowrap;
                  text-overflow: ellipsis;
                }
                .size {
                  font-size: 13px;
                  span {
                    margin-right: 10px;
                  }
                  span:last-child {
                    margin-right: 0;
                  }
                }
              }
            }
            .price,
            .num {
              flex: 2;
              display: flex;
              flex-direction: column;
              align-items: center;
              justify-content: center;
            }
          }
        }
        .right {
          flex: 8;
          display: flex;
          border-bottom: 1px solid #e5e5e5;
          .actualPay,
          .consignee,
          .status{
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            div {
              text-align: center;
              .el-button {
                border: 1px solid $mainGlod;
                color: $mainGlod;
                border-radius: 0;
              }
            }
          }
          .operate{
            flex: 1;
            .btnContainer{
              height: 100%;
              display: flex;
              flex-direction: column;
              align-items: center;
              justify-content: center;
              .btn{
                width: 70px;
                height: 30px;
                margin: 2px;
                padding: 0;
                line-height: 30px;
                text-align: center;
                color: $mainGlod;
                border: 1px solid #F3F4F5;
                font-size: 12px;
                font-family: Microsoft YaHei;
                cursor: pointer;
              }
              .btnBlack{
                color: #FFEBC4 !important;
                background: #333333;
                box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.16);
              }
            }
          }
        }
        .right_line {
          border-left: 1px solid #e5e5e5;
        }
      }
    }
  }
  >>> .el-pagination {
    margin-top: 40px;
    text-align: right;
    .el-pager {
      li:not(.disabled):hover {
        color: $mainGlod;
      }
      li:not(.disabled).active {
        background-color: $mainGlod;
      }
      li:not(.disabled).active:hover {
        color: #f4f4f5;
      }
    }
  }
  .qCode {
    .wechatTitle{
      width: 280px;
      margin: auto;
      padding: 10px 15px;
      color: #333;
      border: 2px solid #F3F4F5;
      display: flex;
      justify-content: space-around;
      align-items: center;
      .tips{
        flex: 1;
      }
    }
    .code{
      width: 280px;
      height: 280px;
      display: block;
      margin: 10px auto;
      border: 2px solid #F3F4F5;
    }
  }
  .weChat {
    >>> .el-dialog__body {
      background: #ffffff;
    }
  }
  >>> .el-dialog {
    width: 33% !important;
    .el-dialog__body {
      background: #f8f8f8;
    }
    .el-dialog__header {
      text-align: center;
    }
    .el-dialog__footer {
      text-align: center;
      .dialog-footer {
        text-align: center;
        button {
          height: 45px;
          width: 160px;
        }
      }
    }
  }
}
</style>
