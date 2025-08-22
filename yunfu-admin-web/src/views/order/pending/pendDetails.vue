<template>
  <div class="order_details">
    <div class="cotent">
      <div class="left_part">
        <div class="order_info">
          <h2>订单信息</h2>
          <ul>
            <li>
              <p>
                <span>商家名称:</span>
                <span>{{ order.shopName }}</span>
              </p>
              <p>
                <span>订单ID:</span>
                <span>{{ order.orderId }}</span>
              </p>
              <p>
                <span>支付单号:</span>
                <span>{{ order.transactionId }}</span>
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
                <span>售后状态:</span>
                <span>{{ order.afterStateName }}</span>
              </p>
            </li>
            <li>
              <p>
                <span>支付方式:</span>
                <span v-if="order.paymentMode === 1">微信</span>
                <span v-if="order.paymentMode === 2">支付宝</span>
              </p>
              <p>
                <span>物流方案:</span>
                <span>{{ order.logisticsName }}</span>
              </p>
            </li>
            <li>
              <p>
                <span>创建时间:</span>
                <span>{{ order.createTime }}</span>
              </p>
              <p>
                <span>支付时间:</span>
                <span>{{ order.paymentTime }}</span>
              </p>
            </li>
            <li>
              <p>备注:{{ order.remark }}</p>
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
            <div class="good_price">
              <ul>
                <li>
                  <p>商品总价: ¥{{ order.orderPrice }}</p>
                  <p>支付金额: ¥{{ order.price }}</p>
                </li>
                <li>
                  <p>物流费用: ￥{{ order.logisticsPrice }}</p>
                </li>
              </ul>
            </div>
            <div class="good_details">
              <ul>
                <li>
                  <img :src="item.image" />
                  <div class="details">
                    <p>{{ item.productName }}</p>
                    <p class="skuDetails">
                      <span
                        v-for="(detailsItem, detailsindex) of item.skuDetails"
                        :key="detailsindex"
                        class="detail_span"
                      >
                        {{ detailsItem.skuName }}: {{ detailsItem.skuValue }}
                      </span>
                    </p>
                    <p>SKU: {{ item.skuId }}</p>
                  </div>
                </li>
                <li class="cen">
                  ¥{{ `${ item.productPrice } * ${ item.number }` }}
                </li>
                <li>
                  {{ order.orderPrice }}
                </li>
              </ul>
            </div>
          </div>
        </div>
        <!-- 未发货时物流信息显示去发货按钮 -->
        <div
          v-show="order.logisticsName && order.logisticsNum"
          class="logistics_info"
        >
          <h2>物流信息</h2>
          <!-- <p
              v-if="!order.logisticsNum"
              class="send_good"
              @click="send"
            >
              去发货
            </p>-->
          <el-button
            v-if="!order.logisticsNum && order.state === 2"
            type="primary"
            class="send_good"
            @click="send"
          >去发货
          </el-button>
          <div
            v-else
            class="logistics_content"
          >
            <p class="logistics_title">
              <span>物流公司: {{ order.logisticsName }}</span>
              <span>运单号: {{ order.logisticsNum }}</span>
            </p>
            <!-- <p
                v-for="(item, index) in tracesList"
                :key="index"
                class="logistics_item"
              >
                <span>{{ item.acceptTime }}</span>
                <span>{{ acceptStation }}</span>
              </p> -->
          </div>
        </div>
      </div>
      <div class="right_part">
        <div class="pay_order_info">
          <h2>下单人信息</h2>
          <p>下单账户: {{ order.customerName }}</p>
          <p>订单总数: {{ order.total }}个</p>
          <p>下单备注: {{ order.remark }}</p>
        </div>
        <div class="take_goods_info">
          <h2>收货信息</h2>
          <p>姓名: {{ order.receiveName }}</p>
          <p>手机号: {{ order.receivePhone }}</p>
          <p>地址: {{ order.receiveAdress }}</p>
        </div>
      </div>
    </div>
    <!-- 发货 -->
    <el-dialog
      v-model="isVisible"
      title="发货"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <el-form
        ref="sendGoodsForm"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item
          label="快递公司"
          prop="express"
        >
          <el-select
            v-model="form.express"
            filterable
          >
            <el-option
              v-for="(item, index) in companyList"
              :key="index"
              :label="item.dictName"
              :value="item.dictId"
            />
          </el-select>
        </el-form-item>
        <el-form-item
          label="快递单号"
          prop="deliverFormid"
        >
          <el-input
            v-model="form.deliverFormid"
            maxlength="20"
            oninput="value = value.replace(/[^\a-\z\A-\Z0-9]/g,'')"
          />
        </el-form-item>
        <!--
          <el-form-item label="快递公司编号" prop="shipperCode" v-if="false">
            <el-input v-model="form.shipperCode" />
          </el-form-item>-->
      </el-form>
      <template
        #footer
      >

        <div class="dialog-footer">
          <el-button
            type="primary"
            @click="confirm"
          >确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>

      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { orderDilevery, orderGetById, orderGetSelect } from '@/api/order'
import { ref, watch, toRefs, onMounted } from 'vue';

const props = defineProps({
  detailRow: {
    type: Object,
    default: () => ({}),
  },
})
const { detailRow } = toRefs(props)
const order = ref({})
const form = ref({
  orderId: '',
  express: '',
  deliverFormid: '',
})
const isVisible = ref(false)
const rules = {
  logisticsName: [
    { required: false, message: '请输入快递公司名称', trigger: 'blur' },
  ],
  deliverFormid: [
    { required: true, message: '请输入快递单号', trigger: 'blur' },
  ],
  express: [
    { required: true, message: '请选择快递公司', trigger: 'blur' },
  ],
}
const companyList = ref([])
watch(detailRow, (nVal, oVal) => {
  if (nVal) {
    form.value.orderId = nVal.orderId
    getProductList()
  }
})
onMounted(() => {
  form.value.orderId = detailRow.value.orderId
  getProductList()
})
async function getProductList () {
  const res = await orderGetById({ orderId: detailRow.value.orderId })
  order.value = res.data
}
const emits = defineEmits(['cancel'])
function close () {
  emits('cancel')
}
const sendGoodsForm = ref()
function confirm () {
  sendGoodsForm.value.validate((valid) => {
    if (valid) {
      form.value.orderId = detailRow.value.orderId
      orderDilevery(form.value).then((res) => {
        if (res.code === '') {
          ElMessage({
            message: '发货成功',
            type: 'success',
          })
          isVisible.value = false
          close()
        }
      })
    }
  })
}
function cancel () {
  isVisible.value = false
}
async function getCompanyList () {
  const res = await orderGetSelect()
  if (res.code === '') {
    companyList.value = res.data
  }
}
function send () {
  getCompanyList()
  isVisible.value = true
}

</script>

<style lang="scss" scoped>
ul {
  list-style: none;
  margin: 0;
  padding: 0;
}

.order_details {
  h3 {
    // margin-left: 20px;
    margin: 20px 0 20px 20px;
    font-weight: 700;
  }

  .close {
    // float: right;
    position: absolute;
    right: 20px;

    &:hover {
      cursor: pointer;
    }
  }

  .cotent {
    margin: 20px;
    overflow: hidden;
    font-size: 14px;

    .goods_info,
    .order_info,
    .logistics_info,
    .pay_order_info,
    .take_goods_info {
      background: #fff;
      margin-bottom: 10px;
      padding: 10px 20px;
    }

    .pay_order_info,
    .take_goods_info {
      p {
        line-height: 30px;
      }
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
          padding: 10px 30px;

          li {
            overflow: hidden;

            p {
              width: 50%;
              float: left;
              font-size: 14px;
              line-height: 30px;

              span {
                &:nth-child(2) {
                  margin-left: 10px;
                }
              }
            }
          }
        }

        .remarks {
          margin-left: 30px !important;
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
            ul {
              display: flex;
              margin-top: 20px;

              li {
                flex: 3;
                display: flex;
                justify-content: space-around;
                align-items: center;

                .details {
                  margin: 0 30px;
                  width: 180px;
                  line-height: 20px;

                  .skuDetails {
                    margin-top: 8px;
                    margin-bottom: 8px;
                    margin-right: 10px;
                    line-height: 1;
                    color: #9e9e9e;

                    .detail_span {
                      margin-right: 8px;
                    }
                  }
                }

                img {
                  width: 50px;
                  height: 50px;
                }
              }
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
          padding: 0 10%;

          .logistics_title {
            span {
              margin: 20px 0;
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
      float: left;
      width: 30%;
    }
  }
}
</style>
