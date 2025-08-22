<template>
  <div class="group-list">
    <div class="group-warp">
      <div class="title">
        <label>
          <img src="../../../static/images/group/img-title.png" alt="拼团专区" />
        </label>
        <a
          v-show="componentContent.showMore"
          class="btn-all a-link"
          @click="jumpGroupWorks(productData)"
        >更多<i class="iconfont icon-arrow-right"></i></a>
      </div>
      <Swiper
        class="pro-box"
        :modules="modules"
        :loop="true"
        :slides-per-view="3"
        :space-between="16"
        :pagination="{ el: '.pagination', clickable: true }"
        :autoplay="autoplay"
      >
        <SwiperSlide
          v-for="(item, index) in productData.products"
          :key="index"
          class="pro-item"
          @click="jumpProductDetail(item)"
        >
          <div class="pro-item-img">
            <img v-show="item.image" class="img" :src="item.image" />
          </div>
          <div class="pro-item-info">
            <label class="name">{{ item.productName }}</label>
            <div class="price">
              <label class="unit">¥ </label>
              <label class="val"> {{ item.price }}</label>
            </div>
            <label class="buyCount">{{ item.workUsers ? item.workUsers : 0 }}人已拼</label>
          </div>
        </SwiperSlide>
      </Swiper>
      <div class="pagination group-pagination"></div>
    </div>
  </div>
</template>
<script setup>
import { Swiper, SwiperSlide } from 'swiper/vue';
import 'swiper/swiper.css';
import { toRefs } from 'vue';
import commonMixin from '../mixin'
import { Autoplay, Pagination } from 'swiper';

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
.group-list {
  padding: 30px 20px 60px;
  .group-warp {
    width: 710px;
    height: 528px;
    padding: 0 10px;
    background: #333333;
    box-shadow: 0px 20px 30px rgba(0, 0, 0, 0.3);
    opacity: 1;
    border-radius: 20px;
  }
  .title {
    display: flex;
    align-items: center;
    position: relative;
    padding: 40px 0 30px 20px;
    .btn-all {
      position: absolute;
      right: 8px;
      top: 40px;
      line-height: 33px;
      padding-right: 25px;
      font-size: 24px;
      color: #ffebc4;
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
  .pro-box {
    padding-bottom: 20px;
    .pro-item {
      width: 220px;
      height: 382px;
      background: #ffffff;
      .pro-item-img {
        .img {
          width: 100%;
          height: 220px;
        }
      }
      .pro-item-info {
        text-align: center;
        padding: 0px 10px 20px;
        .name {
          font-size: 24px;
          font-weight: normal;
          color: #ffebc4;
          line-height: 50px;
          background-color: #333333;
          text-align: center;
          margin-bottom: 18px;
          padding: 0 5px;
          display: block;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
        .price {
          color: #c83732;
          font-size: 28px;
          font-weight: bold;
          line-height: 40px;
        }
        .buyCount {
          font-size: 24px;
          color: #ccc;
          line-height: 34px;
          font-weight: normal;
        }
      }
    }
  }
  .pagination {
    display: flex;
    justify-content: center;
    :deep(.swiper-pagination-bullet) {
      width: 24px;
      height: 4px;
      background: #fff;
      opacity: 0.5;
      border-radius: 2px;
      margin: 0 5px;
    }
    :deep(.swiper-pagination-bullet-active) {
      opacity: 1;
    }
  }
}
</style>
