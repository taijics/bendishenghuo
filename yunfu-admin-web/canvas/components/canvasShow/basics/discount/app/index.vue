<template>
  <div class="hom-pro-list">
    <div class="title">
      <img src="../../../static/images/discount/img-title.png" alt="限时折扣" />
    </div>
    <div
      v-if="componentContent.arrangeType == '横向滑动'"
      class="product-list product-swiper"
    >
      <Swiper
        ref="mySwiper"
        class="product-list-box"
        :slides-per-view="2"
        :slides-per-group="2"
        :space-between="14"
        :modules="modules"
        :pagination="{ el: '.pagination', clickable: true }"
        :autoplay="autoplay"
      >
        <SwiperSlide
          v-for="(item, index) in productData.products"
          :key="index"
          class="product-list-item"
          @click="jumpProductDetail(item)"
        >
          <div class="product-list-img">
            <img v-show="item.image" class="img" :src="item.image" />
          </div>
          <div class="product-list-info">
            <label class="product-name">{{ item.productName }}</label>
            <div>
              <div class="flag">
                <img src="../../../static/images/discount/flag-discount2.png" alt="限时折扣" />
              </div>
              <label class="buy-count">剩余{{ item.stockNumber }}件</label>
            </div>
            <div class="price-warp">
              <div class="price">¥ {{ item.price }}</div>
              <div class="original-price">¥ {{ item.originalPrice }}</div>
            </div>
          </div>
        </SwiperSlide>
      </Swiper>
      <div class="pagination discount-pagination"></div>
    </div>
    <div v-if="componentContent.arrangeType == '多行多列'" class="product-list">
      <div class="product-list-box">
        <div
          v-for="(item, index) in productData.products"
          :key="index"
          class="product-list-item"
          @click="jumpProductDetail(item)"
        >
          <div class="product-list-img">
            <img v-show="item.image" class="img" :src="item.image" />
          </div>
          <div class="product-list-info">
            <label class="product-name">{{ item.productName }}</label>
            <div>
              <div class="flag">
                <img src="../../../static/images/discount/flag-discount2.png" alt="限时折扣" />
              </div>
              <label class="buy-count">剩余{{ item.stockNumber }}件</label>
            </div>
            <div class="price-warp">
              <div class="price">¥ {{ item.price }}</div>
              <div class="original-price">¥ {{ item.originalPrice }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <button
      v-show="componentContent.showMore"
      class="btn-more"
      @click="jumpGroupWorks(productData)"
    >
      查看全部 <span class="icon iconfont icon-arrow-right"></span>
    </button>
  </div>
</template>
<script setup>
import { Swiper, SwiperSlide } from 'swiper/vue';
import 'swiper/swiper.css';
import { ref, toRefs } from 'vue';
import commonMixin from '../mixin'
import { Pagination, Autoplay } from 'swiper';
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
    },
  }
})
const { typeId, shopId, componentContent } = toRefs(props)
const { productData, jumpProductDetail, jumpGroupWorks } = commonMixin(componentContent, typeId, shopId)
const isEdit = localStorage.getItem('isEdit')
const autoplay = {
  delay: isEdit === 'true' ? 9999999 : 3000,
  disableOnInteraction: false
}
const modules = [Pagination, Autoplay];
</script>

<style lang="scss" scoped>
.hom-pro-list {
  padding: 20px 0;
  .title {
    text-align: center;
    margin-bottom: 20px;
    label {
      background: url('../../../static/images/icon-title.png') no-repeat left
        center;
      font-size: 30px;
      font-weight: bold;
      padding-left: 48px;
    }
  }
  /**多行多列**/
  .product-list {
    position: relative;
    &-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      padding-left: 20px;
    }
    &.product-swiper .product-list-box {
      margin: 0 20px;
      padding-left: 0;
    }
    &-item {
      margin: 0 14px 20px 0;
      width: 348px;
    }
    &-img {
      width: 348px;
      height: 348px;
      background-color: #f5f5f5;
      border-radius: 10px 10px 0 0;
      .img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
    &-info {
      background-color: #ffffff;
      //box-shadow: 0px 0px 15px 0px rgba(52, 52, 52, 0.15);
      border-radius: 0 0 10px 10px;
      padding: 20px;
      label {
        font-weight: normal;
      }
      .product-name {
        font-size: 28px;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        margin-bottom: 18px;
        line-height: 40px;
      }
      .shop-box {
        background-color: #333333;
        border-radius: 0px 20px 20px 0px;
        line-height: 40px;
        display: inline-block;
        height: 40px;
        margin-right: 10px;
        .shop-name {
          font-size: 20px;
          color: #ffebc4;
          padding: 0 8px 0 12px;
        }
        .shop-logo {
          border: 2px solid #707070;
          border-radius: 50%;
          overflow: hidden;
          float: right;
          img {
            width: 34px;
            height: 34px;
            display: block;
          }
        }
      }
      .flag {
        float: left;
        margin-right: 20px;
        img {
          height: 44px;
        }
      }
      .buy-count {
        color: #c5aa7b;
        font-size: 20px;
        border: 2px solid #e4e5e6;
        line-height: 40px;
        padding: 0 5px;
        display: inline-block;
      }
      .price-warp {
        display: flex;
        align-items: baseline;
        line-height: 56px;
        margin-top: 16px;
        .price {
          color: #c83732;
          font-size: 40px;
          margin-right: 20px;
        }
        .original-price {
          font-size: 24px;
          color: #ccc;
          text-decoration: line-through;
        }
      }
    }
    //:deep(.swiper-pagination-bullet){
    //  display: none;
    //}
  }
}

.pagination {
  display: flex;
  justify-content: center;
  padding: 20px 0;
  :deep(.swiper-pagination-bullet) {
    width: 10px;
    height: 10px;
    background: #333333;
    opacity: 0.3;
    border-radius: 5px;
    margin: 0 5px;
  }
  :deep(.swiper-pagination-bullet-active) {
    width: 20px;
    height: 10px;
    opacity: 1;
  }
}
.btn-more {
  width: 170px;
  height: 54px;
  border: 2px solid #c5aa7b;
  color: #c5aa7b;
  font-size: 24px;
  background-color: transparent;
  margin: 20px auto 0;
  display: block;
  cursor: pointer;
}
</style>
