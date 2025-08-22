<template>
  <div class="orderDetail">
    <div class="content">
        <div class="head">
            <router-link to="/orderAfterSale">
                <div class="mar-right-10">售后订单</div>
            </router-link>
            <div class='arrow'></div>
            <div class="mar-right-10" v-if="state==='2'">售后详情</div>
            <div class="mar-right-10" v-if="state==='1'">申请售后</div>
        </div>
        <div class="orderTitle">
            <p class="fs16 fw-blod" v-if="state==='2'">售后编号：{{orderData.afterFormid}}</p>
            <p class="fs16 fw-blod" v-if="state==='1'">订单号：{{orderData.orderFormid}}</p>
        </div>
        <div class="status">
            <div class="top">
                <div class="state text-align">
                    <p class="fs30 fw-blod" v-if="state==='1'">申请售后</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===1">审核中</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===2">退款中</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===3">退货中</p>
                    <p class="fs24 fw-blod font-color-71B" v-if="orderData.afterState===4">退款成功</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===5">退款失败<br><span class="font-color-999">(如有问题，请联系商家)</span></p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===6">审核不通过</p>
                    <p class="fs16 fw-blod" v-if="orderData.afterState===6">拒绝理由：{{orderData.reason}}</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===7">评审中</p>
                    <p class="fs24 fw-blod font-color-999" v-if="orderData.afterState===8">退货完成，拒绝退款</p>
                    <p class="fs24 fw-blod font-color-999" v-if="orderData.afterState===9">已关闭</p>
                    <p class="fs24 fw-blod" v-if="orderData.afterState===10">审核通过</p>
                    <el-button plain
                      v-if="orderData.afterState===6 || orderData.afterState===8"
                      class="intervention mar-top-10"
                      @click="platform"
                    >申请平台介入</el-button>
                    <el-button plain
                      v-if="(orderData.afterState===1 && orderData.afterType===1)
                      || (orderData.afterState===6 && orderData.afterType===1)
                      || (orderData.afterState===10 && orderData.afterType===1)"
                      class="intervention mar-top-10"
                      @click="returnRefund"
                    >撤销申请</el-button>
                    <el-button plain
                      v-if="orderData.afterState===1 && orderData.afterType===2
                      || orderData.afterState===6 && orderData.afterType===2"
                      class="intervention mar-top-10"
                      @click="returnGoods"
                    >撤销退货</el-button>
                </div>
            </div>
            <div class="bottom">
                <AfterSaleState v-if="state==='1'" :state="''"></AfterSaleState>
                <AfterSaleState v-else :state="orderData.afterState"></AfterSaleState>
            </div>
        </div>
        <div class="desc">
            <div class="storeInfo">
                <p class="title">卖家信息</p>
                <div class="info">
                    <p>店铺名称：{{orderData.shopName}}</p>
                    <p>联系电话：{{orderData.chargePersonPhone || orderData.shopPhone}}</p>
                </div>
            </div>
            <div class="orderInfo">
                <p class="title">订单信息</p>
                <div class="info">
                    <p>订单号：{{orderData.orderFormid}}</p>
                    <p>支付渠道：{{orderData.paymentMode}}</p>
                    <p>交易号：{{orderData.transactionId}}</p>
                    <p>创建时间：{{orderData.createTime}}</p>
                    <p>付款时间：{{orderData.paymentTime}}</p>
                    <p v-if="orderData.receiveTime">成交时间：{{orderData.receiveTime}}</p>
                </div>
            </div>
            <div class="productInfo">
                <div class="top">
                    <p class="big"><span>宝贝</span></p>
                    <p>宝贝属性</p>
                    <p>状态</p>
                    <p>数量</p>
                    <p>单价</p>
                </div>
                <div class="bottom" v-for="(pro, idx) in orderData.skus" :key="idx">
                    <div class="big">
                        <img :src="pro.image" alt="">
                        <p>{{pro.productName}}</p>
                    </div>
                    <div style="flex-direction: column;">
                        <p v-for="(text, ins) in pro.values" :key="ins">{{text}}</p>
                    </div>
                    <div v-if="orderData.state==1 || orderData.orderState==1">待付款</div>
                    <div v-if="orderData.state==2 || orderData.orderState==2">待发货</div>
                    <div v-if="orderData.state==3 || orderData.orderState==3">待收货</div>
                    <div v-if="orderData.state==4 || orderData.orderState==4">已完成</div>
                    <div v-if="orderData.state==5 || orderData.orderState==5">已关闭</div>
                    <div>{{pro.number}}</div>
                    <div class="fs-bold" style="color: #C83732;">¥{{pro.price}}</div>
                </div>
            </div>
            <div class="returnPrice" v-if="orderData.afterState===4">
                <div>
                    <span class="mar-right-40">退款金额：</span>
                    <span style="color: #C83732;">¥{{orderData.price}}</span>
                </div>
            </div>
            <div class="apply" v-if="state==='1'">
                <div class="submitAS">
                    <div class="itemBox">
                        <div class="title">售后方式：</div>
                        <el-select
                        v-model="mode"
                        placeholder="请选择售后方式"
                        style="width:500px;"
                        >
                            <el-option
                            v-for="item in modes"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                            </el-option>
                        </el-select>
                    </div>
                    <div class="itemBox">
                        <div class="title">货物状态：</div>
                        <el-select
                        v-model="goodsState"
                        placeholder="请选择货物状态"
                        style="width:500px;"
                        >
                            <el-option
                            v-for="item in goodsStatus"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                            </el-option>
                        </el-select>
                    </div>
                    <div class="itemBox">
                        <div class="title">售后理由：</div>
                        <el-select
                        v-model="reason"
                        placeholder="请选择售后理由"
                        style="width:500px;"
                        >
                            <el-option
                            v-for="item in reasons"
                            :key="item"
                            :label="item"
                            :value="item">
                            </el-option>
                        </el-select>
                    </div>
                    <div class="itemBox reason">
                        <div class="title">原因描述：</div>
                        <el-input
                            type="textarea"
                            :rows="6"
                            placeholder="输入申请退货原因描述"
                            v-model="textarea"
                            style="width:500px;">
                        </el-input>
                    </div>
                    <div class="itemBox upload">
                        <div class="title">上传凭证：</div>
                        <el-upload
                            :action="action"
                            list-type="picture-card"
                            :limit="3"
                            :on-success="handleSuccess"
                            :on-remove="handleRemove">
                            <i class="el-icon-camera"></i>
                            <span
                            style="
                                display: block;
                                height: 0px;
                                line-height: 0px;
                                margin-top: -30px;
                            ">最多上传3张</span>
                        </el-upload>
                    </div>
                    <div class="submit">
                        <el-button plain @click="submit" v-throttle>提交申请</el-button>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </div>
</template>
<script>
import AfterSaleState from '@/components/base/afterSaleState'
import {
  upload
} from '@/api/upload.js'
import {
  getOrderDetail
} from '@/api/user/order.js'
import {
  submitAfter,
  getAfterSaleDetail,
  returnRefund,
  returnGoods,
  getReasons,
    requestPlatform
} from '@/api/user/afterSale.js'
export default {
  components: {
    AfterSaleState
  },
  data () {
    return {
      state: 0,
      orderData: {},
      modes: [{
        value: 1,
        label: '仅退款'
      }, {
        value: 2,
        label: '退货退款'
      }],
      reasons: [],
      goodsStatus: [{
        value: 1,
        label: '已收到货'
      }, {
        value: 0,
        label: '未收到货'
      }],
      exp: '',
      mode: '',
      reason: '',
      goodsState: '',
      textarea: '',
      textarea1: '',
      text: '',
      dialogImageUrl: '',
      dialogVisible: false,
      disabled: false,
      skus: [],
      productPrice: 0,
      urls: [],
      orderId: '',
      afterId: '',
      afterSaleDetail: {},
      action: upload,
      image: []
    }
  },
  created () {
    this.state = this.$route.query.state
    if (this.$route.query.state === '2') {
      this.orderId = this.$route.query.orderId
      this.afterId = this.$route.query.afterId
    }
  },
  mounted () {
      if (this.state === '1') {
          this.getReasonSelect()
          this.getOrderDetail()
      } else if (this.state === '2' || this.state === '3') {
          this.getASDetail()
          // this.getExpressSelect()
      }
  },
  methods: {
      // 获取订单详情
      async getOrderDetail () {
        const rLoading = this.openLoading()
        const response = await getOrderDetail({
          orderId: JSON.parse(this.$route.query.orderData).orderId
        })
        const res = response.data
        if (res.code === '200') {
          this.orderData = res.data
          this.orderData.skus = JSON.parse(this.$route.query.orderData).skus
        } else {
          this.$message.warning(res.message)
        }
        rLoading.close()
      },
      // 获取售后订单详情
      async getASDetail () {
        const rLoading = this.openLoading()
        const response = await getAfterSaleDetail({
          afterId: this.afterId,
          orderId: this.orderId
        })
        const res = response.data
        if (res.code === '200') {
          this.orderData = res.data
          this.image = res.data.image.split(',')
        } else {
          this.$message.warning(res.message)
        }
        rLoading.close()
      },
      // 撤销申请
      async returnRefund () {
        const response = await returnRefund({
            afterId: this.orderData.afterId,
            orderId: this.orderData.orderId
        })
        const res = response.data
        if (res.code === '200') {
          this.$message.success('撤销申请成功')
          this.getASDetail()
        } else {
          this.$message.warning(res.message)
        }
      },
      // 撤销退货
      async returnGoods () {
        const response = await returnGoods({
          afterId: this.orderData.afterId,
          orderId: this.orderData.orderId
        })
        const res = response.data
        if (res.code === '200') {
            this.$message.success('撤销退货成功')
            this.getASDetail()
        } else {
          this.$message.warning(res.message)
        }
      },
      // 申请平台介入
      async platform () {
        const response = await requestPlatform({
            afterId: this.orderData.afterId,
            orderId: this.orderData.orderId,
            image: '',
            reason: ''
        })
        const res = response.data
        if (res.code === '200') {
            this.$message.success('申请平台介入成功')
            this.getASDetail()
        } else {
          this.$message(res.message)
        }
      },
      // 选择退款原因查询
      async getReasonSelect () {
        const response = await getReasons()
        const res = response.data
        if (res.code === '200') {
          this.reasons = res.data
        } else {
          this.$message.warning(res.message)
        }
      },
      // 申请售后
      async submit () {
        let errMsg = ''
        if (this.mode === '') {
          errMsg += ' 请选择售后方式 '
        }
        if (this.goodsState === '') {
          errMsg += ' 请选择货物状态 '
        }
        if (this.reason === '') {
          errMsg += ' 请选择售后理由 '
        }
        if (errMsg.length !== 0) {
          this.$message.warning(errMsg)
          return
        }
        this.productPrice = 0
        for (var i in this.orderData.skus) {
            this.skus[i] = {
              number: this.orderData.skus[i].number,
              skuId: this.orderData.skus[i].skuId
            }
            this.productPrice += this.orderData.skus[i].actualPrice
            if (parseInt(this.goodsState) === 0) {
              this.productPrice += this.orderData.skus[i].logisticsPrice
            }
        }
        const response = await submitAfter({
          afterType: this.mode,
          explain: this.textarea,
          goodsState: this.goodsState,
          image: this.urls.join(','),
          orderId: this.orderData.orderId,
          price: this.productPrice.toFixed(2),
          returnReason: this.reason,
          isAllSelect: 1,
          skus: this.skus
        })
        const res = response.data
        if (res.code === '200') {
          this.$message.success({
            message: '售后申请成功',
            type: 'success'
          })
          setTimeout(() => {
              this.$router.push('/orderAfterSale')
          }, 1000)
        } else {
          this.$message.warning(res.message)
        }
      },
      handleSuccess (res) {
          this.urls.push(res.data.url)
      },
      handleRemove (file, fileList) {
        this.urls = []
        for (var i in fileList) {
          this.urls.push(fileList[i].response.data.url)
        }
      }
  }
}
</script>
<style lang="scss">
.orderDetail{
  width: 100%;
  .content{
    width: 1250px;
    margin: 0 auto;
    .head {
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
    .orderTitle{
      width: 100%;
      max-width: 1250px;
      height: 80px;
      margin: 20px 0;
      padding: 0 30px;
      font-size: 16px;
      font-family: Microsoft YaHei;
      color: #333333;
      background: #FAFAFA;
      display: flex;
      align-items: center;
    }
    .status{
      width: 100%;
      height: 325px;
      border: 1px solid #E5E5E5;
      box-sizing: border-box;
      padding: 15px;
      display: flex;
      flex-direction: column;
      margin-bottom: 20px;
      .top{
        flex: 1;
        display: flex;
        align-items: center;
        flex-direction: column;
        position: relative;
        color: $mainGlod;
        .state{
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%,-50%);
        }
        .cancel{
          width: 100px;
        }
        .intervention{
          border-color: $mainGlod;
          color: $mainGlod;
          margin-left: 0;
        }
        .intervention:hover{
          background-color: rgba($color: $mainGlod, $alpha: 0.3);
        }
        .box{
          display: flex;
          flex-direction: column;
          justify-content: center;
        }
      }
      .bottom{
        flex: 3;
        // padding: 20px;
        box-sizing: border-box;
      }
    }
    .desc{
      width: 100%;
      border: 1px solid #E5E5E5;
      margin-bottom: 140px;
      .storeInfo,.orderInfo{
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
            margin-bottom: 10px;
          }
          .long{
            width: 100%;
          }
          .pic{
            margin-top: 10px;
            width: 100%;
            font-size: 14px;
            span{
              vertical-align: top;
              margin-right: 10px;
            }
            .el-image{
              img{
                margin-right: 10px;
              }
            }
          }
        }
      }
      .orderInfo{
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
          color: #FFF;
          background-color: #333;
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
      .settlement{
        width: 100%;
        display: flex;
        padding: 25px;
        box-sizing: border-box;
        justify-content: flex-end;
        .box{
          display: flex;
          .left{
            text-align: right;
            p{
              width: 250px;
              display: flex;
              justify-content: space-between;
              font-size: 20px;
              color: #666666;
              line-height: 30px;
            }
            .right{
              text-align: right;
              margin-left: 40px;
            }
          }
        }
      }
      .returnPrice{
        width: 100%;
        padding: 50px 50px;
        font-size: 20px;
        box-sizing: border-box;
        text-align: right;
        border-bottom: 1px solid #E5E5E5;
      }
      .apply{
        width: 100%;
        padding: 25px;
        box-sizing: border-box;
        .submitAS{
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          position: relative;
          .itemBox{
            width: 580px;
            display: flex;
            margin: 10px;
            .title{
              min-width: 80px;
              line-height: 40px;
              text-align: right;
            }
            >>> .el-input__icon{
              color: $mainGlod;
            }
          }
          .reason{
            position: relative;
          }
          .upload{
            display: flex;
            .title{
              line-height: 40px;
            }
            >>> .el-upload--picture-card{
              height: 140px;
              background-color: #FFF;
              display: flex;
              flex-direction: column;
              justify-content: center;
              align-items: center;
              i{
                font-size: 32px;
              }
              &:hover{
                i{
                color: $mainGlod;
                }
              }
            }
          }
          .submit{
            margin: 30px 0;
            .el-button{
            width: 200px;
            height: 50px;
            color: #FFF;
            background-color: #333333;
            border-radius: 0px;
            }
          }
          >>> .el-select-dropdown__item{
            &:hover{
              background: $mainGlod;
            }
          }
        }
      }
    }
  }
}
</style>
