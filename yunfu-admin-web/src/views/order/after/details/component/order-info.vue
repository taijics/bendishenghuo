<template>
  <div class="order_info_page">
    <div class="order_info">
      <p
        v-for="(item, index) in orderInfoData"
        :key="index"
      >
        <span>{{ item.name }}:</span>
        <span>{{ item.value }}</span>
      </p>
    </div>
    <div class="detail_title">商品信息</div>
    <div
      v-for="(sItem, sIndex) in shopListData"
      :key="sIndex"
      class="goods_list"
    >
      <div class="good_details">
        <ul>
          <li>
            <img :src="sItem.image" />
          </li>
          <li>
            <p>{{ sItem.productName }}</p>
            <p>{{ sItem.skuValue }}</p>
            <p>SKU: {{ sItem.skuId }}</p>
          </li>
          <li>
            <p>¥{{ sItem.total }}</p>
            <p>¥{{ `${ sItem.productPrice }*${ sItem.number }` }}</p>
          </li>
          <li>¥{{ sItem.total }}</li>
        </ul>
      </div>
    </div>
    <div class="total">
      <ul>
        <li></li>
        <li></li>
        <li></li>
        <li>
          <p
            v-for="(sItem, sIndex) in shopListData"
            :key="sIndex"
          >
            <span>订单总金额：¥ {{ sItem.total }}</span>
          </p>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, toRefs } from 'vue';

const props = defineProps({
  orderInfoData: {
    type: Array,
  },
  shopListData: {
    type: Array,
  }
})
const { orderInfoData, shopListData } = toRefs(props)
const orderInfo = ref([
  { name: '订单ID', value: '542543543', field: '' },
  { name: '支付单号', value: '12353563', field: '' },
  { name: '支付状态', value: '待发货', field: '' },
  { name: '售后状态', value: '售后中', field: '' },
])
const shopList = ref([
  {
    skuImg:
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=137628589,3436980029&fm=26&gp=0.jpg',
    productName: 'DAD 气垫霜',
    skuNameStr: '粉色, 中瓶',
    skuId: '2525',
    sellPrice: '60',
    buyNum: '2',
    salePrice: '50',
  },
  {
    skuImg:
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=137628589,3436980029&fm=26&gp=0.jpg',
    productName: 'DAD 气垫霜',
    skuNameStr: '粉色, 中瓶',
    skuId: '2525',
    sellPrice: '60',
    buyNum: '2',
    salePrice: '50',
  }
])
const recordList = ref([
  {
    title: '申请平台介入',
    name: '刘十',
    time: '2020-05-08 15:30:56',
    type: '问题描述',
    value: '不退款',
    img: '举证图片',
    imgSrc:
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=137628589,3436980029&fm=26&gp=0.jpg',
  },
  {
    title: '拒绝退款',
    name: '王辉',
    time: '2020-04-08 17:30:20',
    type: '卖家留言',
    value: '不退款',
    img: '',
    imgSrc: '',
  },
  {
    title: '发起了售后',
    name: '张强',
    time: '2020-03-25 13:25:45',
    type: '买家留言',
    value: '不要了, 买到的宝贝不符合预期',
    img: '',
    imgSrc: '',
  },
])
const total = ref(200)
</script>

<style
    lang="scss"
    scoped
>
.order_info_page {
  .order_info {
    overflow: hidden;

    p {
      width: 50%;
      float: left;
      line-height: 30px;

      span {
        font-size: 16px;
        color: #333333;
        display: inline-block;

        &:nth-of-type(1) {
          // width:130px;
          margin-right: 20px;
        }

        &:nth-of-type(2) {
          color: #666666;
        }
      }
    }
  }

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

  .goods_list {
    .good_details {
      border-bottom: 1px #e0e5eb solid;

      ul {
        overflow: hidden;
        display: flex;
        margin: 0;
        padding: 30px 0;
        list-style: none;

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
              // text-align: center;
              &:nth-child(1) {
                font-weight: 600;
              }

              &:nth-child(2) {
                font-size: 12px;
              }
            }
          }

          &:nth-child(4) {
            font-weight: 600;
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
      list-style: none;

      li {
        // height: 40px;
        flex: 3;
        font-size: 16px;
        color: #333333;
        // justify-content: center;
        // align-items: center;
        &:nth-child(4) {
          // font-weight: 600;
        }

        p {
          margin: 0;
          padding: 0;
          height: 30px;
          line-height: 30px;
          width: 100%;
          clear: both;

          span {
            display: inline-block;
            float: left;

            &:nth-of-type(1) {
              // width: 40%;
              margin-right: 10%;
            }

            &:nth-of-type(2) {
              width: 50%;
              font-weight: 600;
            }
          }
        }
      }
    }
  }
}
</style>
