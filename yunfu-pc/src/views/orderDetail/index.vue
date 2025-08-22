<template>
  <div class="orderDetail">
    <div class="content">
      <!-- 面包屑 -->
      <div class="bread">
          <router-link :to="linkTo">
            <div class="mar-right-10">我的订单</div>
          </router-link>
        <div class='arrow'></div>
        <div class="mar-right-10">订单详情</div>
      </div>
      <!-- 条件渲染 -->
      <OrderId
        class="commInfo"
        :data="orderIdInfo"
        :type="orderType"
        @closeOrder="closeOrder"
        @cancel="cancelOrder"
        @revoke="revokeOrder"
        @invite="inviteFriends"
        @pin="again"
      />
      <!-- 条件渲染 -->
      <OrderStatus
        class="commInfo"
        :data="orderStatusInfo"
      />
      <!-- 拼单信息 -->
      <div class="groupBuying" v-if="orderDetail.collageId!=0 && orderDetail.state!=1 && $route.query.type !== '3'">
        <div class="groupBuyTit">拼团信息</div>
        <div class="groupBuyBox">
          <div class="result" v-if="groupData.state==0">付款成功，待成团</div>
          <div class="result" v-if="groupData.state==1">恭喜您拼团成功</div>
          <div class="result0 mar-bot-20 fs18" v-if="groupData.state==2">未能按时成团，拼团失败</div>
          <p v-if="groupData.state ===0 || groupData.state ===2">
            {{ groupData.person }}人团，离拼团成功还差<span>{{ groupData.people }}</span>人
          </p>
          <p v-if="groupData.state ===2">
            拼团失败后，已付金额会原路退回！
          </p>
          <div class="surplusTime"
          v-if="groupData.state==0"
          >
          剩余时间：<span class="day time">{{groupData.time | formatHours}}</span>时<span class="time">{{groupData.time | formatMinutes}}</span>分<span class="time">{{groupData.time | formatSeconds}}</span>秒
          </div>
          <div class="userList">
            <span v-for="(item,index) of groupData.personList" :key="item.id">
              <i v-if="index === 0">团长</i>
              <img :src="item.headImage" alt="">
            </span>
            <span class="noPeople iconfont" v-for="index of groupData.people" :key="index + 'n'" @click="inviteFriends">
              &#xe64b;
            </span>
          </div>
        </div>
      </div>
      <!-- 录入退货物流 -->
      <RebackExpress
        v-if="orderType === 3 && orderDetail.afterState === 10 && orderDetail.afterType === 2"
        @submit="submitRebackExpress"
      />
      <div class="failAfter" v-if="orderDetail.afterType === 1">
        <div class="top">
          <h1>拒绝原因：</h1>
          <p>{{ orderDetail.reason }}</p>
        </div>
        <div class="btn">
          <el-button @click="platReq">申请平台介入</el-button>
        </div>
      </div>
      <ExpressInfo class="commInfo"
        :data="orderExpressInfo"
      />
      <OrderInfo class="commInfo"
        :data="orderInfos"
      />
      <!-- 售后原因 -->
      <ReasonInfo v-if="orderDetail.afterId"
        :data="orderASInfo"
      />

      <!-- 商品列表 -->
      <div class="desc">
          <!-- 商品信息 -->
          <div class="productInfo">
              <div class="top">
                  <p class="big"><span>宝贝</span></p>
                  <p>宝贝属性</p>
                  <p>状态</p>
                  <p>数量</p>
                  <p>单价</p>
              </div>
              <div class="bottom" v-for="(pro, idx) in orderDetail.skus" :key="idx">
                  <div class="big">
                      <img :src="pro.image" alt="">
                      <p>{{pro.productName}}</p>
                  </div>
                  <div style="flex-direction: column;">
                      <p v-for="(text, ins) in pro.values" :key="ins">{{text}}</p>
                  </div>
                  <div class="colorRed" v-if="orderDetail.state==1">待付款</div>
                  <div class="colorRed" v-if="orderDetail.state==2">待发货</div>
                  <div class="colorRed" v-if="orderDetail.state==3">待收货</div>
                  <div class="colorRed" v-if="orderDetail.state==4">已完成</div>
                  <div class="colorRed" v-if="orderDetail.state==5">已关闭</div>
                  <div class="colorRed" v-if="orderDetail.state==6">待成团</div>
                  <div>{{pro.number}}</div>
                  <div class="fs-bold">¥{{pro.price}}</div>
              </div>
          </div>
      </div>
      <!-- 条件渲染 -->
      <OrderPay class="commInfo"
        :data="orderPayInfo"
        :type="orderType"
      />
      <!-- 物流信息 -->
      <div class="logistics"
      v-if="orderDetail.state >= 3 && orderDetail.express && orderDetail.deliverFormid"
      >
          <p class="fs16 font-color-333"></p>
          <div class="content">
              <div class="top">
                <p class="title">物流信息</p>
                <p class="com">发货方式：快递</p>
                <p class="com">物流公司：{{orderDetail.express || '查询失败'}}</p>
                <p class="com">运单号码：{{orderDetail.deliverFormid || '暂无物流单号'}}</p>
              </div>
              <div class="bottom">
                <div class="title">物流跟踪：</div>
                <div class="dilevery">
                    <el-steps
                      direction="vertical"
                      :active="1"
                      space="100"
                    >
                      <el-step
                        :title="item.time+'：'+item.reason"
                        v-for="(item, index) in dilevery"
                        :key="index"
                      >
                        <template slot="icon">
                          {{ dilevery.length - index }}
                        </template>
                      </el-step>
                    </el-steps>
                </div>
              </div>
          </div>
      </div>
    </div>
    <!-- 取消订单 -->
    <el-dialog
      title="提示"
      :visible.sync="closeOrderDialog"
      width="30%"
      :before-close="closeOrderBtn">
      <span>是否取消该订单?</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeOrderDialog = false">取 消</el-button>
        <el-button type="primary" @click="cancelOrder">确 定</el-button>
      </span>
    </el-dialog>
    <!-- 邀请好友 -->
    <el-dialog
      :visible.sync="inviteDialog"
      width="30%"
      :before-close="inviteDialogClose">
      <div class="inviteDialog">
        <div class="inviteTit">邀请好友</div>
        <div class="imgCode">
          <img :src="share.qrcode" alt="">
        </div>
        <!-- <p>扫描下方二维码或复制链接分享给好友吧</p>
        <div class="linkBox">
          <span class="linkAddress">www.1234567.com</span>
          <span class="copyBtn">复制</span>
        </div> -->
      </div>
    </el-dialog>
    <!-- 微信支付 -->
    <el-dialog
      class="weChat"
      :title="`请使用微信扫一扫支付￥${payInfo.money}`"
      :visible.sync="weChatDialog"
      :before-close="handleClose"
      center
      width="30%">
      <div class="weChatBox">
        <div class="qCode">
          <img :src="payInfo.url" alt="">
          <img src="../../assets/images/weiXintit.png" alt="">
        </div>
        <div class="weChatInfo">
          <img src="../../assets/images/imgPay.png" alt="">
        </div>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import { mapMutations } from 'vuex'

import OrderId from '@/views/orderDetail/components/orderid.vue'
import OrderStatus from '@/views/orderDetail/components/status.vue'
import ExpressInfo from '@/views/orderDetail/components/expressInfo.vue'
import OrderInfo from '@/views/orderDetail/components/orderInfo.vue'
import ReasonInfo from '@/views/orderDetail/components/reasonInfo.vue'
import RebackExpress from '@/views/orderDetail/components/rebackExpress.vue'
// import ProductList from '@/views/orderDetail/components/prodcutlist.vue'
import OrderPay from '@/views/orderDetail/components/payInfo.vue'

// 格式化响应数据为组件所需数据
import {
  formateIdInfo,
  formateStatusInfo,
  formateOrderInfo,
  formatePayInfo,
  formateExpressInfo,
  formateASInfo
} from '@/views/orderDetail/data-formate.js'

import {
  getUserInfo
} from '@/api/user/user.js'
import {
  getOrderDetail,
  orderCancel,
  // orderPayPut,
  orderPayCode,
  checkOrderResult
} from '@/api/user/order.js'
import {
  getAfterSaleDetail,
  postRefund,
  postReGoods
} from '@/api/user/afterSale.js'
import {
  getExpressData,
  postExpress,
  getExpressCompany
} from '@/api/user/express.js'
import {
  inviteGroup
} from '@/api/Activity/ActivityGroup.js'
export default {
    components: {
        OrderId,
        OrderStatus,
        RebackExpress,
        ExpressInfo,
        OrderInfo,
        ReasonInfo,
        // ProductList,
        OrderPay
    },
    data () {
        return {
          linkTo: '/myOrder',
          orderDetail: {},
          value: '',
          values: '',
          textarea: '',
          textarea1: '',
          text: '',
          dialogImageUrl: '',
          dialogVisible: false,
          disabled: false,
          orderId: '',
          dilevery: [],
          endTime: '',
          closeOrderDialog: false,
          inviteDialog: false,
          share: {},
          groupData: {},
          setTime: null,
          endTime1: '',
          noticeId: '',
          weChatDialog: false,
          payInfo: {},
          chatTimer: null,
          orderType: 0, // 订单类型
          orderState: null,
          isPay: false,
          orderIdInfo: {},
          orderStatusInfo: {},
          orderPinInfo: {},
          orderExpressInfo: {},
          orderExpressStatus: {}, // 物流进度
          orderAddressInfo: {},
          orderInfos: {},
          productTitle: [
            {
              value: 0,
              prop: '',
              label: '宝贝'
            },
            {
              value: 0,
              prop: '',
              label: '宝贝属性'
            },
            {
              value: 0,
              prop: '',
              label: '状态'
            },
            {
              value: 0,
              prop: '',
              label: '数量'
            },
            {
              value: 0,
              prop: '',
              label: '单价'
            }
          ],
          orderProductInfo: {},
          orderPayInfo: {},
          orderASInfo: {},
          orderASReasonInfo: {},
          orderASExpress: {}
        }
    },
    filters: {
      formatHours: function (value) {
        let hours = Math.floor(value / (1000 * 60 * 60))
        if (hours < 10 && hours > 0) {
          return '0' + hours
        } else if (hours > 10) {
          return hours
        } else {
          return '00'
        }
      },
      formatMinutes: function (value) {
        let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
        if (minutes < 10 && minutes > 0) {
          return '0' + minutes
        } else if (minutes > 10) {
          return minutes
        } else {
          return '00'
        }
      },
      formatSeconds: function (value) {
        let seconds = Math.round((value % (1000 * 60)) / 1000)
        if (seconds < 10 && seconds > 0) {
          return '0' + seconds
        } else if (seconds > 10) {
          return seconds
        } else {
          return '00'
        }
      }
    },
    created () {
      this.orderId = this.$route.query.orderId
      if (this.$route.query.noticeId) {
        this.noticeId = this.$route.query.noticeId
      }
    },
    mounted () {
      if (this.$route.query.type === '3') {
        this.getAfterSaleDetail()
      } else {
        this.getOrderDetail()
      }
    },
    destroyed () {
      clearInterval(this.setTime)
    },
    methods: {
      ...mapMutations({
        setUserInfo: 'SET_USERINFO'
      }),
      // 获取用户信息
      async getUserInfoData () {
        const response = await getUserInfo()
        const res = response.data
        if (res.code === '200') {
          this.setUserInfo(res.data)
        }
      },
      // 倒计时
      countDown () {
        clearInterval(this.setTime)
        this.setTime = setInterval(() => {
          if (this.groupData.time >= 1000) {
            this.groupData.time -= 1000
          } else {
            this.groupData.time = 0
            clearInterval(this.setTime)
            window.location.reload()
          }
        }, 1000)
      },
      // 时间戳转分秒
      toHHmmss (date) {
        var timer = ''
        var minutes = parseInt((date % (1000 * 60 * 60)) / (1000 * 60))
        // var seconds = (date % (1000 * 60)) / 1000
        timer = (minutes < 10 ? ('0' + minutes) : minutes) + '分'
        return timer
      },
      // 获取订单详情
      async getOrderDetail () {
        this.linkTo = '/myOrder'
        const rLoading = this.openLoading()
        const response = await getOrderDetail({
          orderId: this.orderId,
          noticeId: this.noticeId
        })
        const res = response.data
        if (res.code === '200') {
          this.orderState = res.data.state
          if (res.data.collageId) {
            this.orderType = 1 // 拼团
            this.orderState = res.data.collageDetail.state
          }
          if (res.data.afterState) {
            this.orderType = 3 // 售后
            this.orderState = res.data.afterState
          }
          this.formateData(res)
          this.orderDetail = res.data
          this.groupData = res.data.collageDetail
          this.endTime = res.data.time
          this.getDilevery()
          if (this.groupData.time) {
            this.endTime1 = this.groupData.time
          }
          if (this.groupData.time >= 1000 && res.data.state === 6 && this.groupData.state === 0) {
            this.countDown()
          }
          this.getUserInfoData()
          rLoading.close()
        } else {
          this.$message.warning(res.message)
        }
      },
      // 获取售后订单详情
      async getAfterSaleDetail () {
        this.linkTo = '/orderAfterSale'
        const rLoading = this.openLoading()
        const response = await getAfterSaleDetail({
          afterId: this.$route.query.afterId,
          orderId: this.$route.query.orderId
        })
        const res = response.data
        if (res.code === '200') {
          this.orderType = 3 // 设置订单详情类型
          this.formateData(res)
          this.orderDetail = res.data
          if (res.data.orderState) {
            this.orderDetail.state = res.data.orderState
          }
          this.getDilevery()
          this.getExpressCom()
          this.image = res.data.image.split(',')
          rLoading.close()
        } else {
          this.$message({
              message: res.message,
              type: 'warning'
          })
        }
      },
      // 提交退货物流信息
      async submitRebackExpress (data) {
        const response = await postExpress({
          orderId: this.orderDetail.orderId,
          afterId: this.orderDetail.afterId,
          deliverFormid: data.deliverFormid,
          express: data.express
        })
        const res = response.data
        if (res.code === '200') {
          this.$message.success('提交成功！')
          location.reload()
        } else {
          this.$message.warning(res.message)
        }
      },
      // 查询物流信息
      async getDilevery () {
        if (!this.orderDetail.express || !this.orderDetail.deliverFormid) {
          return
        }
        const response = await getExpressData({
          express: this.orderDetail.express,
          deliverFormid: this.orderDetail.deliverFormid
        })
        const res = response.data
        if (res.code === '200') {
          this.dilevery = res.data
        } else {
          this.$message.warning(res.message)
        }
      },
      // 查询物流公司字典
      async getExpressCom () {
        if (!this.orderDetail.express || !this.orderDetail.deliverFormid) {
          return
        }
        const response = await getExpressCompany()
        const res = response.data
        res.data.forEach(item => {
          if (item.dictId === this.orderDetail.express) {
            this.orderDetail.expressCompany = item.dictName
          }
        })
        console.log(res, this.orderDetail)
      },
      // 取消订单
      async cancelOrder () {
        const response = await orderCancel({
          orderId: this.orderDetail.orderId
        })
        const res = response.data
        if (res.code === '200') {
          this.closeOrderDialog = false
          this.getOrderDetail()
        } else {
          this.$message.warning(res.message)
        }
      },
      // 去付款
      // async pay () {
      //   const response = await orderPayPut({
      //     orderId: this.orderDetail.orderId,
      //     type: 2,
      //     money: this.orderDetail.price
      //   })
      //   const res = response.data
      //   if (res.code === '200') {
      //     this.getOrderDetail()
      //   } else {
      //     this.$message.warning(res.message)
      //   }
      // },
      handlePictureCardPreview (file) {
        this.dialogImageUrl = file.url
        this.dialogVisible = true
      },
      // 取消订单
      closeOrder () {
        this.closeOrderDialog = true
      },
      // 邀请好友
      async inviteFriends () {
        const response = await inviteGroup({
          collageId: this.orderDetail.collageId,
          orderId: this.orderDetail.orderId,
          productId: this.orderDetail.skus[0].productId,
          skuId: this.orderDetail.skus[0].skuId,
          shopGroupWorkId: this.orderDetail.shopGroupWorkId,
          type: 0
        })
        const res = response.data
        if (res.code === '200') {
          this.share = res.data
        }
        this.inviteDialog = true
      },
      closeOrderBtn () {
        this.closeOrderDialog = false
      },
      inviteDialogClose () {
        this.inviteDialog = false
      },
      // 再次开团
      again () {
        let data = {
          shopId: this.orderDetail.shopId,
          productId: this.orderDetail.skus[0].productId,
          skuId: this.orderDetail.skus[0].skuId
        }
        this.$router.push({
          path: '/productDetail',
          query: {
            proData: JSON.stringify(data)
          }
        })
      },
      // 撤销申请
      async revokeOrder () {
        if (!this.orderDetail.afterType) {
          return
        }
        let params = {
          afterId: this.orderDetail.afterId,
          orderId: this.orderDetail.orderId
        }
        let response
        if (this.orderDetail.afterType === 1) {
          response = await postRefund(params)
        }
        if (this.orderDetail.afterType === 2) {
          response = await postReGoods(params)
        }
        const res = response.data
        if (res.code === '200') {
          this.$message.success('撤销成功！')
          location.reload()
        } else {
          this.$message.error(res.message)
        }
      },
      // 申请平台介入
      async platReq () {
        console.log('申请平台介入')
        this.$message.warning('暂未接入')
        // const response = await requestPlatform({
        //   afterId: 0,
        //   image: '',
        //   orderId: 0,
        //   reason: ''
        // })
      },
      // 付款
      async getUrl () {
        // 获取支付二维码
        const response = await orderPayCode({ orderId: this.orderDetail.orderId })
        const res = response.data
        if (res.code === '200') {
          this.payInfo = res.data
          this.weChatDialog = true
          this.chatTimer = setInterval(() => {
            this.checkPay(res.data)
          }, 3000)
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      },
      // 取消支付
      handleClose () {
        this.$confirm('确认取消支付？')
          .then(_ => {
            clearInterval(this.chatTimer)
            this.weChatDialog = false
          })
          .catch(_ => {})
      },
      // 确认支付结果
      checkPay (data) {
        setTimeout(() => {
          // 确认支付结果
          checkOrderResult({
            collageId: data.collageId,
            money: data.money,
            orderId: data.orderId,
            type: 2
          }).then(response => {
            const res = response.data
            if (res.code === '200') {
              if (res.data.code === 'SUCCESS') {
                this.$message({
                  message: '支付成功！',
                  type: 'success'
                })
                clearInterval(this.chatTimer)
                this.weChatDialog = false
                this.getOrderDetail()
              }
            } else {
              clearInterval(this.chatTimer)
              this.$message({
                message: res.message,
                type: 'error'
              })
              this.weChatDialog = false
            }
          })
        }, 0)
      },
      // 格式化数据
      formateData (res) {
        this.orderIdInfo = formateIdInfo(res.data) // 订单号
        this.orderStatusInfo = formateStatusInfo(res.data) // 订单状态
        this.orderInfos = formateOrderInfo(res.data) // 订单信息
        this.orderPayInfo = formatePayInfo(res.data) // 结算信息
        console.log(this.orderInfos, 'order')
        this.orderExpressInfo = formateExpressInfo(res.data) // 收货信息
        if (res.data.afterId) {
          this.orderASInfo = formateASInfo(res.data)
        }
      }
    }
}
</script>
<style lang="scss">
.orderDetail{
  width: 100%;
  .content{
    width: 1252px;
    margin: 0 auto;
    .bread {
        width: 100%;
        height: 50px;
        line-height: 50px;
        font-size: 16px;
        display: flex;
        align-items: center;
        .arrow {
            background-image: url('../../../static/image/xiangyou@2x.png');
            width: 5px;
            height: 10px;
            margin-right: 10px;
        }
    }
    .commInfo{
      margin: 10px 0;
    }
    .failAfter{
      width: 100%;
      min-height: 200px;
      margin: 20px 0;
      .top{
        min-height: 110px;
        padding: 20px 30px;
        background-color: #F5F5F5;
        h1{
          font-size: 16px;
          color: #C83732;
        }
        p{
          font-size: 14px;
          color: #333333;
          margin-top: 20px;
        }
      }
      .el-button{
        display: block;
        width: 200px;
        height: 50px;
        margin: 20px auto 0;
        color: #FFEBC4;
        background-color: #333333;
        border-radius: 0px;
      }
    }
    .status{
      width: 100%;
      height: 325px;
      border: 1px solid #E5E5E5;
      box-sizing: border-box;
      padding: 15px;
      display: flex;
      margin-bottom: 20px;
    }
    // 物流快递
    .logistics{
        width: 100%;
        box-sizing: border-box;
        margin-bottom: 20px;
        background-color: #FAFAFA;
        .content{
            .top{
              height: 80px;
              padding: 0 30px;
              display: flex;
              align-items: center;
              border-bottom: 1px solid #E5E5E5;
              .title{
                flex: 1;
              }
              .com{
                margin: 0 8px;
              }
              p{
                font-size: 16px;
                color: #666666;
              }
            }
            .bottom{
                padding: 25px 30px;
                box-sizing: border-box;
                display: flex;
                .dilevery{
                    flex: 1;
                    height: 280px;
                    overflow-x: auto;
                    padding: 20px;
                    box-sizing: border-box;
                    .el-step{
                      .el-step__head{
                        height: 100%;
                      }
                    }
                }
            }
        }
    }
    // 商品
    .desc{
        width: 100%;
        border: 1px solid #E5E5E5;
        margin: 20px 0;
        .receivingInfo,.storeInfo,.orderInfo{
            padding: 25px;
            border-bottom: 1px solid #E5E5E5;
            .title{
                font-size: 16px;
                margin-bottom: 25px;
            }
            .info{
                display: flex;
                margin-left: 75px;
                flex-wrap: wrap;
                p{
                    line-height: 30px;
                    width: 50%;
                    font-size: 14px;
                }
            }
        }
        .orderInfo,.receivingInfo{
            .info{
                p{
                    width: 33.33%;
                }
            }
        }
        .productInfo{
            width: 100%;
            .top{
                height: 40px;
                width: 100%;
                color: #FFFFFF;
                background-color: #333333;
                display: flex;
                align-items: center;
                text-align: center;
                p{
                    flex: 1;
                    font-size: 12px;
                }
                .big{
                    flex: 2;
                    text-align: left;
                    span{
                      margin-left: 20px;
                    }
                }
            }
            .bottom{
                width: 100%;
                padding: 20px 0;
                box-sizing: border-box;
                text-align: center;
                display: flex;
                border-bottom: 1px solid #E5E5E5;
                div{
                    flex: 1;
                    font-size: 14px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    p{
                        font-size: 14px;
                        line-height: 20px;
                    }
                }
                .colorRed{
                  color: #C83732;
                }
                .big{
                    text-align: left;
                    flex: 2;
                    display: flex;
                    box-sizing: border-box;
                    justify-content: flex-start;
                    align-items: center;
                    img{
                        width: 80px;
                        height: 80px;
                        margin: 0 20px;
                    }
                    p{
                        width: 50%;
                    }
                }
            }
        }
    }
  }
  .groupBuying {
    border: 1px solid #F3F4F5;
    height: 325px;
    padding: 20px;
    margin-bottom: 20px;
    .groupBuyTit {
      font-size: 16px;
      color: #333333;
      font-weight: bold;
    }
    .groupBuyBox {
      text-align: center;
      margin-top: 30px;
      .result {
        font-size: 18px;
        margin-bottom: 20px;
      }
      .result0 {
        color: #C83732;
      }
      p {
        font-size: 14px;
        color: #333333;
        margin-bottom: 20px;
        span {
          color: $mainGlod;
          font-size: 14px;
          font-weight: normal;
        }
      }
      .surplusTime {
        margin-bottom: 30px;
        font-size: 16px;
        color: #666666;
        display: flex;
        justify-content: center;
        align-items: center;
        .day {
          margin-left: 10px;
        }
        .time {
          color: $mainGlod;
          background-color: #333;
        }
        span {
          border: 1px solid #E5E5E5;
          border-radius: 2px;
          display: block;
          width: 24px;
          height: 24px;
          text-align: center;
          line-height: 24px;
          margin:0 8px;
        }
      }
      .userList {
        display: flex;
        justify-content: center;
        align-items: center;
        span {
          display: block;
          width: 76px;
          height: 76px;
          position: relative;
          margin: 0 13px;
          border-radius: 50%;
          box-sizing: border-box;
          img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
          }
          i {
            position: absolute;
            left: 8px;
            bottom: -10px;
            width: 60px;
            height: 24px;
            background: linear-gradient(88deg, #C5AA7B 0%, #FFEBC4 100%);
            border-radius: 12px;
            font-style: normal;
            text-align: center;
            line-height: 24px;
            color: #FFFFFF;
            font-size: 14px;
          }
        }
        .noPeople {
          border: 1px dashed #E5E5E5;
          color: #DBDBDB;
          font-size: 28px;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
        }
        span:first-child {
          border: 1px solid $mainGlod;
        }
      }
    }
  }
  .inviteDialog {
    text-align: center;
    .inviteTit {
      font-size: 22px;
      color: #444444;
    }
    .imgCode {
      width: 200px;
      height: 200px;
      margin: 0 auto;
      img {
        width: 100%;
        height: 100%;
      }
    }
    p {
      margin: 25px 0;
    }
    .linkBox {
      display: flex;
      justify-content: center;
      .linkAddress {
        height: 40px;
        line-height: 40px;
        padding: 0 20px;
        display: block;
        width: 220px;
        text-align: left;
        border: 1px solid #E5E5E5;
      }
      .copyBtn {
        width: 100px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        background: #FFFFFF;
        border: 1px solid $mainGlod;
        color: $mainGlod;
        margin-left: 20px;
        cursor: pointer;
      }
    }
  }
  .weChatBox {
    display: flex;
    img {
      width: 100%;
    }
    .qCode {
      width: 50%;
      text-align: center;
      img {
        width: 80%;
      }
    }
    .weChatInfo {
      width: 50%;
    }
  }
  .weChat {
    >>> .el-dialog__body {
      background: #FFFFFF;
    }
  }
}
</style>
