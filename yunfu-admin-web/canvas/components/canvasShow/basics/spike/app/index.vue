<template>
  <div class="spike">
    <div
      v-if="productData.products && productData.products.length > 0"
      class="spike-card"
    >
      <div class="spike-card-top">
        <h2 class="spike-card-top-title">
          <img
            src="../../../static/images/spike/img-title.png"
            alt="秒杀专区"
          >
        </h2>
        <div v-if="state === 2" class="spike-card-top-time">活动已结束</div>
        <div v-else class="spike-card-top-time">
          距离{{ count[0] }}还有 <span>{{ count[1] }}</span><i>:</i><span>{{ count[2] }}</span><i>:</i><span>{{ count[3] }}</span>
        </div>
        <a
          class="btn-more"
          @click="jumpSeckills(productData)"
        >更多<i class="iconfont icon-arrow-right" /></a>
      </div>
      <ul class="spike-card-list">
        <li
          v-for="item in productData.products.slice(0, 4)"
          :key="item.productId"
          class="spike-card-item"
          @click="jumpProductDetail(it)"
        >
          <div class="spike-card-item-img">
            <img :src="item.image" alt="">
          </div>
          <div class="spike-card-item-info">
            <h3 class="name">
              {{ item.productName }}
            </h3>
            <div class="stock">还剩{{ item.stockNumber }}件</div>
            <div class="price-warp">
              <div class="price">¥ {{ item.price }}</div>
              <div class="original-price">¥ {{ item.originalPrice }}</div>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>
<script setup>
import commonMixin from '../mixin'
import { toRefs } from 'vue';
const props = defineProps({
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
    }
  }
})
const { typeId, shopId, componentContent } = toRefs(props)
const { state, productData, count, jumpProductDetail, jumpSeckills } = commonMixin(componentContent, typeId, shopId)
</script>

<style lang="scss" scoped>
.spike {
  background: #f8f8f8;
  padding: 20px;
  &-card {
    height: 498px;
    background: #ffffff;
    border-radius: 20px;
    &-top {
      position: relative;
      padding: 32px 0 22px;
      display: flex;
      &-title {
        padding: 10px 20px 0 30px;
      }
      &-time {
        padding: 0 18px;
        height: 50px;
        background: linear-gradient(90deg, #c83732 0%, #e25c44 100%);
        box-shadow: 0px 6px 12px rgba(233, 0, 0, 0.3);
        opacity: 1;
        border-radius: 26px;
        font-size: 24px;
        line-height: 50px;
        color: #fff;
        text-align: center;
      }
      .btn-more {
        position: absolute;
        right: 8px;
        top: 40px;
        line-height: 33px;
        padding-right: 25px;
        font-size: 24px;
        color: #333;
        cursor: pointer;
        .iconfont {
          content: '';
          font-size: 26px;
          position: absolute;
          right: 0;
          top: 0;
        }
      }
    }
    &-item {
      width: 50%;
      border-top: 1px solid #f3f4f5;
      border-left: 1px solid #f3f4f5;
      float: left;
      align-items: center;
      &:nth-child(2n + 1) {
        border-left: 0px;
      }
      &-img {
        width: 162px;
        height: 196px;
        margin-right: 10px;
        float: left;
        img {
          width: 100%;
          height: 100%;
          object-fit: contain;
        }
      }
      &-info {
        height: 100%;
        margin-left: 172px;
        width: 168px;
        .name {
          font-size: 24px;
          line-height: 40px;
          color: #333333;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
        .stock {
          padding: 0 8px;
          height: 40px;
          border: 2px solid #e4e5e6;
          line-height: 40px;
          margin: 10px 0;
          display: inline-block;
          font-size: 20px;
          color: #c5aa7b;
        }
        .price {
          font-size: 32px;
          font-weight: bold;
          line-height: 44px;
          color: #c83732;
          padding-right: 10px;
          display: inline-block;
        }
        .original-price {
          font-size: 20px;
          line-height: 28px;
          color: #cccccc;
          display: inline-block;
        }
      }
    }
  }
}
</style>
