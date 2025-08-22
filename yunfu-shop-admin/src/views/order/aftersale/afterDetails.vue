<template>
  <el-dialog :close-on-click-modal="false" title="详情" width="80%" :visible.sync="visible">
    <div v-loading="loading" class="order_details">
      <!-- <el-button plain @click="close">关闭</el-button> -->
      <!-- 关闭 -->
      <!-- <el-button icon="el-icon-close" class="close" @click="close" />-->
      <div class="cotent">
        <div class="left_part">
          <div class="order_info">
            <h2>售后信息</h2>
            <ul>
              <li>
                <p>
                  <span>售后单号:</span>
                  <span>{{ order.afterFormid }}</span>
                </p>
                <p>
                  <span>订单ID:</span>
                  <span>{{ order.orderId }}</span>
                </p>
              </li>
              <li>
                <p>
                  <span>订单状态:</span>
                  <span v-if="order.state === 1">待付款</span>
                  <span v-if="order.state === 2">待发货</span>
                  <span v-if="order.state === 3">待收货</span>
                  <span v-if="order.state === 4">已完成</span>
                  <span v-if="order.state === 5">已取消</span>
                </p>
                <p>
                  <span>售后类型:</span>
                  <span v-if="order.afterType === 1">仅退款</span>
                  <span v-if="order.afterType === 2">退货退款</span>
                </p>
              </li>
              <li>
                <p>
                  <span>退款金额:</span>
                  <span>{{ order.price }}</span>
                </p>
                <p>
                  <span>买家账户:</span>
                  <span>{{ order.customerName }}</span>
                </p>
              </li>
              <li>
                <p>
                  <span>申请时间:</span>
                  <span>{{ order.createTime }}</span>
                </p>
                <p>
                  <span>最近处理时间:</span>
                  <span>{{ order.updateTime }}</span>
                </p>
              </li>
              <li>
                <span>备注:</span>
                <span>{{ order.remark }}</span>
              </li>
            </ul>
          </div>
          <div class="goods_info">
            <h2>商品信息</h2>
            <div
              v-for="(item, index) in order.products"
              :key="index"
              class="goods_list"
            >
              <!-- <div class="good_price">
              <ul>
                <li>
                  <p>商品总价: ¥{{ item.total }}</p>
                  <p>支付金额: ¥{{ order.price }}</p>
                </li>
                <li>
                  <p>物流费用: ￥{{ order.logisticsPrice }}</p>
                </li>
              </ul>
            </div> -->
              <div class="good_details">
                <ul>
                  <li>
                    <img :src="item.image">
                    <div class="details">
                      <p>{{ item.productName }}</p>
                      <div class="skuDetails">
                        <p
                          v-for="(detailsItem, detailsindex) of item.skuDetails"
                          :key="detailsindex"
                        >
                          {{ detailsItem.skuValue }}
                        </p>
                      </div>
                      <p>SKU: {{ item.skuId }}</p>
                    </div>
                  </li>
                  <li class="cen">
                    <p>¥{{ `${item.productPrice} * ${item.number}` }}</p>
                  </li>
                  <li>
                    <p v-if="order.afterType === 1">仅退款</p>
                    <p v-if="order.afterType === 2">退货退款</p>
                  </li>
                  <li>
                    <p class="fontWeight">¥{{ item.total }}</p>
                  </li>
                </ul>
                <div class="totalRefund">
                  运费金额：
                  <span class="fontWeight">¥{{ order.logisticsPrice }}</span>
                </div>
                <div class="totalRefund">
                  退款总金额：
                  <span class="fontWeight">¥{{ order.price }}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="logistics_info">
            <h2>售后记录</h2>
            <div class="after_sales_record">
              <div
                v-for="(item, index) in order.afterHistory"
                :key="index"
                class="record_list"
              >
                <div class="record_list_title">
                  <p>{{ item.title }}</p>
                  <div>
                    <p>买家名称：{{ item.name }}</p>
                    <p>申请时间：{{ item.time }}</p>
                  </div>
                  <p>留言：{{ item.reason }}</p>
                </div>
              </div>
              <div class="record_list_content">
                <!--              <p>-->
                <!--                &lt;!&ndash; <span>{{ item.type }}:</span> &ndash;&gt;-->
                <!--                <span>{{ item.actionNote }}</span>-->
                <!--              </p>-->
                <div v-if="order.images && order.images.length != 0" class="proofBox">
                  <h3>买家举证图片:</h3>
                  <div class="imgBox">
                    <el-image v-for="(item, index) of order.images" :key="index" :src="item" :preview-src-list="order.images" alt />
                  </div>
                </div>
              </div>
            </div>
            <div v-if="order.afterType !== 1" class="logistics_content">
              <p class="logistics_title">
                <span>物流公司: {{ order.express }}</span>
                <span>运单号: {{ order.deliverFormid }}</span>
              </p>
            </div>
          </div>
        </div>
        <div class="right_part">
          <div v-if="showOne || showTwo" class="preO">
            <div class="topTips">
              <div class="leftImg">
                <img src="../../../assets/images/tips.png" alt>
              </div>
              <div class="rTitle">
                <b>等待商家处理</b>
                <p>买家已发起售后申请，请尽快处理</p>
              </div>
            </div>
            <div class="buyerR">买家说明:{{ order.explain }}</div>
          </div>
          <div v-if="showThree" class="preO">
            <div class="topTips">
              <div class="leftImg">
                <img src="../../../assets/images/tips.png" alt>
              </div>
              <div class="rTitle">
                <b>买家已退回</b>
                <p>请注意检查货物是否达到退款标准，如未达到，请联系买家协商</p>
              </div>
            </div>
            <div class="buyerR">物流公司:{{ order.express }}</div>
            <div class="buyerR">物流单号:{{ order.deliverFormid }}</div>
          </div>
          <div class="btnList">
            <div v-if="showOne" class="lists">
              <div class="btns" @click="agree(5)">同意退款申请</div>
              <div class="btns" @click="agree(2)">拒绝退款申请</div>
            </div>
            <div v-if="showTwo" class="lists">
              <div class="btns" @click="agree(1)">同意申请</div>
              <div class="btns" @click="agree(2)">拒绝申请</div>
            </div>
            <div v-if="showThree" class="lists">
              <div class="btns" @click="agree(3)">确认收货且退款</div>
              <div class="btns" @click="agree(4)">货物有损拒绝退款</div>
            </div>
          </div>
        </div>
      </div>
      <!-- *********************************弹框开始********************************* -->
      <!-- 申请弹框 -->
      <el-dialog
        :visible.sync="isVisible"
        :title="title"
        width="30%"
        top="32vh"
        center
        :append-to-body="true"
        :close-on-click-modal="false"
      >
        <div v-if="title === '同意申请'" class="agreeTitle">
          同意申请后，系统将自动发送你的退款地址给买家
        </div>
        <div v-if="title === '拒绝退款申请'" class="agreeTitle2">
          <div class="tiTop">
            请与买家协商好后再操作，拒绝后买家仍可以再次申请
          </div>
          <el-input
            v-model="textarea"
            maxlength="200"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 4 }"
            placeholder="请输入留言"
          />
        </div>
        <div v-if="title === '确认收货且退款'" class="agreeTitle2">
          <div class="tiTop">已确认商品无误，退款给买家</div>
        </div>
        <div v-if="title === '货物有损拒绝退款'" class="agreeTitle2">
          <div class="tiTop">我已确认货物有损，不予退款</div>
          <el-input
            v-model="textarea"
            maxlength="200"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 4 }"
            placeholder="请输入留言"
          />
        </div>
        <div v-if="title === '同意退款申请'" class="agreeTitle2">
          <div class="tiTop">同意退款申请后，退款金额将返还至买家的支付渠道</div>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button
            v-if="title === '同意申请'"
            type="primary"
            @click="agreeEn(1)"
          >同意申请</el-button>
          <el-button
            v-if="title === '拒绝退款申请'"
            type="primary"
            @click="agreeEn(2)"
          >拒绝申请</el-button>
          <el-button
            v-if="title === '确认收货且退款'"
            type="primary"
            @click="agreeEn(3)"
          >确认退款</el-button>
          <el-button
            v-if="title === '货物有损拒绝退款'"
            type="primary"
            @click="agreeEn(4)"
          >确 定</el-button>
          <el-button
            v-if="title === '同意退款申请'"
            type="primary"
            @click="agreeEn(5)"
          >同意退款</el-button>
          <el-button @click="isVisible = false">取 消</el-button>
        </span>
      </el-dialog>

      <!-- 发货 -->
      <el-dialog
        :visible.sync="isVisibles"
        title="发货"
        :close-on-click-modal="false"
      >
        <el-form
          ref="sendGoodsForm"
          :model="form"
          :rules="rules"
          label-width="80px"
        >
          <el-form-item label="快递公司" prop="express">
            <el-select v-model="form.express" filterable>
              <el-option
                v-for="(item, index) in companyList"
                :key="index"
                :label="item.dictName"
                :value="item.dictId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="快递单号" prop="deliverFormid">
            <el-input v-model="form.deliverFormid" maxlength="20" />
          </el-form-item>
        <!--
        <el-form-item label="快递公司编号" prop="shipperCode" v-if="false">
          <el-input v-model="form.shipperCode" />
        </el-form-item>-->
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button type="primary" @click="confirm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </span>
      </el-dialog>
    </div>
  </el-dialog>
</template>

<script>
import {
  aftersaleGetById,
  orderGetSelect,
  orderDilevery,
  refundSuccess,
  refundRefuse,
  success,
  refuse,
  confirmAndRefund,
  damaging
} from '@/api/order'
export default {
  name: 'AfterDetails',
  data() {
    return {
      loading: false,
      visible: false,
      afterId: 0,
      order: {},
      isVisible: false,
      isVisibles: false,
      companyList: [],
      title: '同意申请',
      textarea: '',
      showOne: false,
      showTwo: false,
      showThree: false,
      form: {
        express: '',
        deliverFormid: '',
        orderId: ''
      },
      rules: {
        logisticsName: [
          { required: false, message: '请输入快递公司名称', trigger: 'blur' }
        ],
        deliverFormid: [
          { required: true, message: '请输入快递单号', trigger: 'blur' }
        ],
        express: [
          { required: true, message: '请选择快递公司', trigger: 'blur' }
        ]
      }
    }
  },
  // computed: {
  //   afterId() {
  //     return this.$route.params.afterId
  //   }
  // },
  // created() {
  //   console.log(this.afterId)
  // },
  mounted() {
    this.getCompanyList()
    // setTimeout(() => {
    //   this.btnShow(),
    //   console.log('mounted')
    // }, 1000)
  },
  methods: {
    show(id) {
      this.visible = true
      this.afterId = id
      this.getProductList()
      console.log(this.order, 'this.order')
    },
    async getProductList() {
      this.loading = true
      try {
        const res = await aftersaleGetById({ afterId: this.afterId })
        this.order = res.data
        this.btnShow()
      } finally {
        this.loading = false
      }
    },
    async getCompanyList() {
      const res = await orderGetSelect()
      if (res.code === '') {
        this.companyList = res.data
      }
    },
    // 发货
    confirm() {
      this.$refs.sendGoodsForm.validate((valid) => {
        if (valid) {
          this.form.orderId = this.order.orderId
          orderDilevery(this.form).then((res) => {
            if (res.code === '') {
              this.$message({
                message: '发货成功',
                type: 'success'
              })
              this.isVisibles = false
            }
          })
        }
      })
    },
    cancel() {
      this.isVisibles = false
    },
    close() {
      this.visible = false
    },
    // 申请弹框
    agree(index) {
      if (index === 1) {
        this.title = '同意申请'
        this.isVisible = true
      } else if (index === 2) {
        this.title = '拒绝退款申请'
        this.isVisible = true
      } else if (index === 3) {
        this.title = '确认收货且退款'
        this.isVisible = true
      } else if (index === 4) {
        this.title = '货物有损拒绝退款'
        this.isVisible = true
      } else if (index === 5) {
        this.title = '同意退款申请'
        this.isVisible = true
      } else if (index === 9) {
        this.isVisibles = true
        this.form = {
          express: '',
          deliverFormid: '',
          orderId: 1
        }
      }
    },
    // 同意申请
    async agreeEn(index) {
      if (index === 1) {
        this.title = '同意申请'
        const res = await success({
          orderId: this.order.orderId,
          afterId: this.order.afterId
        })
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
          this.$router.go(-1)
        }
      } else if (index === 2) {
        this.title = '拒绝退款申请'
        if (this.showOne) {
          const res = await refundRefuse({
            orderId: this.order.orderId,
            afterId: this.order.afterId,
            reason: this.textarea
          })
          if (res.code === '') {
            this.$message({
              message: '成功',
              type: 'success'
            })
            this.isVisible = false
            this.$router.go(-1)
          }
        }
        if (this.showTwo) {
          const res = await refuse({
            orderId: this.order.orderId,
            afterId: this.order.afterId,
            reason: this.textarea
          })
          if (res.code === '') {
            this.$message({
              message: '成功',
              type: 'success'
            })
            this.isVisible = false
            this.$router.go(-1)
          }
        }
      } else if (index === 3) {
        this.title = '确认收货且退款'
        const res = await confirmAndRefund({
          orderId: this.order.orderId,
          afterId: this.order.afterId
        })
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
          this.$router.go(-1)
        }
      } else if (index === 4) {
        this.title = '货物有损拒绝退款'
        const res = await damaging({
          orderId: this.order.orderId,
          afterId: this.order.afterId
        })
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
          this.$router.go(-1)
        }
      } else if (index === 5) {
        const res = await refundSuccess({
          orderId: this.order.orderId,
          afterId: this.order.afterId
        })
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
          this.$router.go(-1)
        }
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
        }
      }
    },
    // 判断按钮展示
    btnShow() {
      console.log(this.order, 'this.order')
      this.showOne = false
      this.showTwo = false
      this.showThree = false
      if (
        this.order.afterType === 1 &&
        (this.order.afterState === 1 || this.order.afterState === 5)
      ) {
        this.showOne = true
      }
      if (
        this.order.afterType === 2 &&
        (this.order.afterState === 1 || this.order.afterState === 5)
      ) {
        this.showTwo = true
      }
      if (this.order.afterType === 2 && this.order.afterState === 3) {
        this.showThree = true
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import url("../../../styles/elDialog.scss");
ul {
  list-style: none;
  margin: 0;
  padding: 0;
}
.order_details {
  .close {
    position: absolute;
    right: 20px;
    &:hover {
      cursor: pointer;
    }
  }
  .cotent {
    overflow: hidden;
    font-size: 14px;
    margin: 20px;
    .goods_info,
    .order_info,
    .logistics_info,
    .pay_order_info,
    .take_goods_info {
      background: #fff;
      margin-bottom: 10px;
      padding: 10px 20px;
    }
    h2 {
      margin: 0;
      font-weight: 400;
      height: 40px;
      line-height: 40px;
      font-size: 18px;
      text-align: -10px;
    }
    .left_part {
      float: left;
      width: calc(70% - 10px);
      margin-right: 10px;
      .order_info {
        box-sizing: border-box;
        ul {
          margin: 10px 20px;
          overflow: hidden;
          li {
            overflow: hidden;
            line-height: 30px;
            p {
              float: left;
              font-size: 14px;
              width: 50%;
              span {
                &:nth-child(2) {
                  margin-left: 10px;
                }
              }
            }
          }
        }
      }
      .goods_info {
        .goods_list {
          padding: 15px;
          .good_price {
            ul {
              li {
                &:nth-child(1) {
                  p {
                    width: 50%;
                    float: left;
                  }
                }
                p {
                  line-height: 30px;
                }
              }
            }
            border-bottom: 1px gray solid;
          }
          .good_details {
            overflow: hidden;
            ul {
              display: flex;
              padding:0 10px 20px 10px;
              border-bottom: 1px solid #ccc;
              li {
                flex: 5;
                display: flex;
                justify-content: space-around;
                align-items: center;
                .details {
                  margin: 0 30px;
                  width: 150px;
                  line-height: 20px;
                  .skuDetails {
                    display: flex;
                    margin-right: 10px;
                  }
                }
                img {
                  width: 50px;
                  height: 50px;
                }
                &:nth-child(2) {
                  display: block;
                }
              }
              .cen{
                margin-top: 5%;
              }
            }
            .totalRefund{
              display: flex;
              justify-content: right;
              margin: 20px 40px 0 0;
            }
            .fontWeight{
              font-weight: 700;
            }
          }
        }
      }
      .logistics_info {
        .send_good {
          display: block;
          margin: 20px auto !important;
          &:hover {
            cursor: pointer;
          }
        }
        .logistics_content {
          padding: 0 20px;
          .logistics_title {
            span {
              display: inline-block;
              width: 45%;
            }
          }
          .logistics_item {
            span {
              display: inline-block;
              width: 30%;
            }
          }
        }
      }
    }

    .right_part {
      background: #fff;
      float: left;
      width: 30%;
      height: 600px;
      overflow: hidden;
      padding: 50px;
      font-size: 15px;
      .preO {
        .topTips {
          display: flex;
          justify-content: center;
          align-items: center;
          .leftImg {
            img {
              width: 50px;
              height: 50px;
            }
          }
        }
        .buyerR {
          text-align: left;
          margin-left: 53px;
        }
      }
    }
  }
  .record_list_content {
    img {
      width: 100px;
      height: 100px;
    }
    .proofBox {
      margin-top: 20px;
      .imgBox {
        padding-left: 20px;
        .el-image {
          margin-right: 15px;
          width: 100px;
          height: 100px;
        }
      }
      h3 {
        margin-bottom: 20px;
      }
    }
  }
}
.agreeTitle2 {
  text-align: center;
  font-size: 20px;
}
.btnList {
  display: flex;
  justify-content: center;
  margin-top: 30px;
  .lists {
    .btns {
      width: 200px;
      height: 50px;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #fff;
      background: #3a68f2;
      margin-bottom: 20px;
      border-radius: 5px;
      cursor: pointer;
    }
  }
}
.after_sales_record {
  .record_list {
    padding: 0 20px;
    border-bottom: 1px solid gray;
    overflow: hidden;
    p{
      line-height:30px
    }
    .record_list_title{
      padding: 10px 0;
      div{
        overflow: hidden;
         p{
             float:left ;
             width: 50%;
           }
      }
    }
    .detail_title {
      font-size: 24px;
      color: #333333;
      position: relative;
      margin: 50px 20px 20px;
      &:before {
        content: "";
        display: block;
        position: absolute;
        top: 5px;
        left: -20px;
        width: 4px;
        height: 24px;
        background-color: #3a68f2;
      }
    }
  }
}
</style>
