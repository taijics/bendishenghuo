<template>
  <div class="detail_page">
    <div class="content">
      <div class="head_box">
        售后详情
        <div
          v-if="detailRow.type != 2"
          class="btn_list"
        >
          <el-button @click="refuse">拒绝售后</el-button>
          <el-button
            type="primary"
            @click="handle"
          >同意售后
          </el-button>
        </div>
        <div
          v-else
          class="btn_list"
        >
          <el-button @click="back">返回</el-button>
        </div>
      </div>
      <div class="detail">
        <div class="order_info">
          <p class="detail_title">订单信息</p>
          <ul class="order_list">
            <li
              v-for="(item, index) in orderInfo"
              :key="index"
            >
              <p>{{ item.name }}:</p>
              <p
                :class="[
                  {
                    active:
                      item.type === 1 || item.type === 2 || item.type === 4,
                  },
                ]"
              >
                <span @click="getInfo(item)">{{ item.value }}</span>
                <span
                  v-if="item.type === 3 && item.value"
                  class="active"
                  @click="getInfo(item)"
                >查看物流</span>
                <span v-if="item.type === 3 && !item.value">暂无物流信息</span>
              </p>
            </li>
          </ul>
        </div>

        <div class="after_sale_shop">
          <p class="detail_title">售后商品</p>
          <div
            v-for="(item, index) in shopList"
            :key="index"
            class="goods_list"
          >
            <div class="good_details">
              <ul>
                <li>
                  <img :src="item.image" />
                </li>
                <li>
                  <p>{{ item.productName }}</p>
                  <p>{{ item.skuValue }}</p>
                  <p>SKU: {{ item.sku }}</p>
                </li>
                <li>
                  <p>¥{{ item.productPrice * item.number }}</p>
                  <p>¥{{ `${ item.productPrice }*${ item.number }` }}</p>
                </li>
                <li>¥{{ item.total }}</li>
              </ul>
            </div>
          </div>
          <div class="total">
            <ul>
              <li></li>
              <li></li>
              <li>退款总金额</li>
              <li>¥{{ total }}</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="after_sales_record">
        <p class="detail_title">协商历史</p>
        <div
          v-for="(item, index) in recordList"
          :key="index"
          class="record_list"
        >
          <div class="record_list_title">
            <p>{{ item.title }}</p>
            <p>{{ item.name }}</p>
            <p>{{ item.time }}</p>
          </div>
          <div class="record_list_content">
            <p>
              <!-- <span>{{ item.type }}:</span> -->
              <span> 留言：{{ item.reason }}</span>
            </p>
            <p v-if="item.images.length != 0">
              <span>举证图片:</span>
              <el-image
                v-for="(imgItem, imgIndex) in item.images"
                :key="imgIndex"
                style="width: 100px; height: 100px"
                :src="imgItem"
                :preview-src-list="item.images"
              />
              <!--              <img v-for="(imgItem, imgIndex) in item.images" :src="imgItem" :key="imgIndex" alt>-->
            </p>
          </div>
        </div>
      </div>
    </div>
    <el-dialog
      v-model="dialog.visible"
      :title="dialog.title"
      append-to-body
      :fullscreen="!true"
      :before-close="close"
      width="55%"
    >
      <OrderInfo
        v-if="dialog.type === 1"
        :order-info-data="orderInfo"
        :shop-list-data="shopList"
      />
      <StoreInfo
        v-if="dialog.type === 2"
        :dialog="dialog.arr"
      />
      <Logistics
        v-if="dialog.type === 3"
        :logistics-list="dialog"
      />
      <Buyer
        v-if="dialog.type === 4"
        :dialog="dialog.arr"
      />
      <AfterSales
        v-if="dialog.type === 5"
        :dialog="dialog"
        @close="close"
        @dialogs="dialogs"
      />
      <!-- <goods v-if="dialog.type===1" :info="info" />
        <audit-log v-if="dialog.type===2" :info="info" />-->
    </el-dialog>
  </div>
</template>

<script setup>
import OrderInfo from './component/order-info.vue'
import StoreInfo from './component/store-info.vue'
import Logistics from './component/logistics.vue'
import Buyer from './component/buyer.vue';
import AfterSales from './component/after-sales.vue';
import { afterGetById, getBuyer, getDilevery, handles } from '@/api/after'
import { businessListGetById } from '@/api/business'
import { onMounted, ref, toRefs, watch } from 'vue';

const props = defineProps({
  detailRow: {
    type: Object,
    default: () => ({}),
  }
})
const { detailRow } = toRefs(props)

const orderInfo = ref([
  { name: '订单ID', value: '', type: 1, field: 'orderFormid' },
  { name: '售后订单ID', value: '', type: '', field: 'afterFormid' },
  { name: '支付时间', value: '', type: '', field: 'paymentTime' },
  { name: '支付方式', value: '', type: '', field: 'paymentMode' },
  { name: '订单总金额', value: '', type: '', field: 'orderPrice' },
  { name: '店铺名称', value: '', type: 2, field: 'shopName' },
  { name: '物流单号', value: '', type: 3, field: 'deliverFormid' },
  { name: '售后类型', value: '', type: '', field: 'afterType' },
  { name: '买家账户', value: '', type: 4, field: 'customerName' },
])
const shopList = ref([
  {
    image:
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=137628589,3436980029&fm=26&gp=0.jpg',
    productName: 'DAD 气垫霜',
    skuValue: '粉色, 中瓶',
    skuId: '2525',
    productPrice: '60',
    number: '2',
    salePrice: '50',
  },
])
const recordList = ref([])
const total = ref(0)
const dialog = ref({})
const afterDetails = ref('')
const shopId = ref(0)

watch(detailRow, (nVal, oVal) => {
  if (nVal) {
    getDetails()
  }
}, {
  deep: true
})

onMounted(() => {
  getDetails()
})

async function getDetails () {
  const res = await afterGetById({ afterId: detailRow.value.afterId })
  if (res.code === '') {
    afterDetails.value = res.data
    shopId.value = afterDetails.value.shopId
    const o = res.data
    getOrderInfo(o)
    shopList.value = o.products
    total.value = o.refundPrice
    recordList.value = o.afterHistory
  }
}

function getOrderInfo (o) {
  const payChannel = {
    1: '微信支付',
    2: '支付宝支付',
    3: '余额支付',
  }
  const returnType = {
    1: '无售后',
    2: '退款',
    3: '退货',
  }
  orderInfo.value.map((item) => {
    item.value = o[item.field] || ''
    if (item.field === 'payChannel') {
      item.value = payChannel[item.value]
    }
    if (item.field === 'returnType') {
      item.value = returnType[item.value]
    }
  })
}

function handle () {
  dialog.value = {
    title: '同意售后',
    visible: true,
    type: 5,
    btnName: '同意售后',
    allow: true,
    orderId: afterDetails.value.orderId,
    afterId: afterDetails.value.afterId,
  }
}

function refuse () {
  dialog.value = {
    title: '拒绝售后',
    visible: true,
    type: 5,
    btnName: '拒绝售后',
    orderId: afterDetails.value.orderId,
    afterId: afterDetails.value.afterId,
  }
}

async function getInfo (item) {
  switch (item.type) {
  case 1:
    dialog.value = {
      title: '订单信息',
      visible: true,
      type: item.type,
    }
    break

  case 2:
    businessListGetById({
      shopId: afterDetails.value.shopId,
    })
      .then((res) => {
        if (res.code === '') {
          dialog.value = {
            title: '店铺信息',
            visible: true,
            type: item.type,
            arr: res.data,
          }
        }
      })
      .catch((err) => {
        console.log(err)
      })
    break
  case 3:
    getDilevery({
      express: afterDetails.value.express,
      deliverFormid: afterDetails.value.deliverFormid,
    })
      .then((res) => {
        if (res.code === '') {
          dialog.value = {
            title: '物流信息',
            visible: true,
            type: item.type,
            arr: res.data,
            detail: afterDetails,
          }
        }
      })
      .catch((err) => {
        console.log(err)
      })
    break

  case 4:
    getBuyer({
      buyerUserId: afterDetails.value.buyerUserId,
    })
      .then((res) => {
        if (res.code === '') {
          dialog.value = {
            title: '买家信息',
            visible: true,
            type: item.type,
            arr: res.data,
          }
        }
      })
      .catch((err) => {
        console.log(err)
      })
    break

  default:
    return
  }
}

async function dialogs (arr) {
  if (arr.btnName === '拒绝售后') {
    const res = await handles({
      orderId: arr.orderId,
      afterId: arr.afterId,
      state: '2',
      remark: arr.remark,
    })
    if (res.code === '') {
      ElMessage.success('成功拒绝售后')
      dialog.value.visible = false
      back()
    }
  } else if (arr.btnName === '同意售后') {
    const res = await handles({
      orderId: arr.orderId,
      afterId: arr.afterId,
      state: '1',
      remark: arr.remark,
    })
    if (res.code === '') {
      ElMessage.success('成功同意售后')
      dialog.value.visible = false
      back()
    }
  }
}

const emits = defineEmits(['cancel'])

// 返回
function back () {
  emits('cancel')
}

function close () {
  dialog.value = {}
}

</script>
<style lang="scss" scoped>
.detail_page {
  background-color: #fff;
  height: calc(100% - 10px);

  .content {
    .head_box {
      overflow: hidden;
      height: 80px;
      line-height: 80px;
      font-size: 24px;
      border-bottom: 1px solid #e0e5eb;

      .btn_list {
        display: inline-block;
        float: right;
      }
    }

    .detail,
    .after_sales_record {
      min-height: 500px;
      background: rgba(255, 255, 255, 1);
      box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
      border-radius: 4px;
      padding: 1px 30px;
      margin-top: 15px;

      .detail_title {
        font-size: 24px;
        color: #333333;
        position: relative;
        margin: 50px 20px 20px;

        &:before {
          content: '';
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

    .order_info {
      .order_list {
        padding-left: 20px;
        overflow: hidden;
        list-style: none;

        li {
          float: left;
          width: calc(100% / 3);
          margin-bottom: 30px;

          p {
            margin: 0;
            padding: 0;
            display: inline-block;
            font-size: 16px;
            color: #333333;

            &:nth-child(1) {
              // width: 23%;
              margin-right: 20px;
            }

            &:nth-child(2) {
              color: #666666;
            }
          }
        }

        .active {
          color: #3a68f2 !important;

          &:hover {
            cursor: pointer;
          }
        }
      }
    }

    .after_sale_shop {
      .goods_list {
        padding-left: 20px;

        .good_details {
          border-bottom: 1px #e0e5eb solid;

          ul {
            overflow: hidden;
            display: flex;
            margin: 0;
            padding: 30px 0;
            font-size: 16px;

            li {
              flex: 3;
              display: flex;
              // justify-content: center;
              // align-items: center;
              text-align: left;

              img {
                width: 90px;
                height: 90px;
                border-radius: 4px;
                font-size: 16px;
                color: #333333;
              }

              &:nth-child(2),
              &:nth-child(3) {
                display: block;
              }

              &:nth-child(3) {
                p {
                }
              }

              &:nth-child(4) {
              }

              p {
                margin: 0;
                padding: 0;
                height: 30px;
                line-height: 30px;
              }
            }
          }
        }
      }

      .total {
        padding-left: 20px;

        ul {
          margin: 0;
          padding: 30px 0;
          display: flex;
          justify-content: flex-end;

          li {
            // height: 40px;
            font-size: 16px;
            color: #333333;
            display: flex;
            width: 90px;
            // justify-content: center;
            // align-items: center;
            &:nth-child(4) {
              margin-right: 140px;
            }
          }
        }
      }
    }

    .after_sales_record {
      p {
        margin: 0;
        padding: 0;
        font-size: 16px;
      }

      .record_list {
        padding-left: 20px;

        .record_list_title {
          background: #f7f7f7;
          overflow: hidden;
          margin-bottom: 30px;

          p {
            float: left;
            text-indent: 10px;
            width: calc(100% / 3);
            height: 36px;
            line-height: 36px;
          }
        }

        .record_list_content {
          p {
            overflow: hidden;
            margin-bottom: 30px;

            span {
              display: block;
              float: left;
              // width: 100px;
              &:nth-of-type(2) {
                text-indent: 10px;
              }

              &:nth-of-type(2) {
                color: #666666;
                width: calc(100% - 100px);
              }
            }

            img {
              width: 90px;
              height: 90px;
              border-radius: 4px;
            }
          }
        }
      }
    }
  }
}

:deep(.el-dialog__wrapper) {
  .el-dialog__header {
    height: 70px;
    background-color: #3a68f2;

    .el-dialog__title {
      font-size: 24px;
      color: #fff;
    }
  }
}
</style>
