<template>
  <div class="product-list" :class="'terminal' + terminal">
    <div v-if="componentContent.arrangeType == '横向滑动'" class="picListWarp">
      <div
        v-if="productData.products && productData.products.length > 0"
        class="picList"
      >
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
        <Swiper
          class="products-swiper"
          :modules="modules"
          :loop="true"
          :slides-per-view="4"
          :space-between="13"
          :navigation="{ nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev' }"
          :autoplay="autoplay"
        >
          <SwiperSlide
            v-for="(item, index) in productData.products"
            :key="index"
            class="products-swiper-slide item"
          >
            <div class="a-link" @click="jumpProductDetail(item)">
              <div class="itemImgBox">
                <div class="imgBox">
                  <el-image :src="item.image" fit="contain" />
                </div>
              </div>
              <div class="text">
                <h4 class="h4">{{ item.productName }}</h4>
                <div class="priceBox">
                  <span
                    v-if="item.originalPrice"
                    class="discount"
                  >¥{{ item.originalPrice }}</span>
                  <dl>
                    <dt>
                      <img src="../../../static/images/group/flag-group.png" alt="拼团价" />
                    </dt>
                    <dd>¥{{ item.price }}</dd>
                  </dl>
                </div>
              </div>
            </div>
          </SwiperSlide>
        </Swiper>
      </div>
    </div>
    <div v-else class="picList">
      <ul
        v-if="productData.products && productData.products.length > 0"
        class="clearfix"
        :class="'imgTextNum' + componentContent.productNum"
      >
        <li
          v-for="(item, index) in productData.products.slice(
            0,
            componentContent.productRowNum * componentContent.productNum
          )"
          :key="index"
          class="item"
        >
          <div class="a-link" @click="jumpProductDetail(item)">
            <div class="itemImgBox">
              <div class="imgBox">
                <el-image :src="item.image" fit="contain" />
              </div>
            </div>
            <div class="text">
              <h4 class="h4">{{ item.productName }}</h4>
              <div class="priceBox">
                <span
                  v-if="item.originalPrice"
                  class="discount"
                >¥{{ item.originalPrice }}</span>
                <dl>
                  <dt>
                    <img src="../../../static/images/group/flag-group.png" alt="拼团价" />
                  </dt>
                  <dd>¥{{ item.price }}</dd>
                </dl>
              </div>
            </div>
          </div>
        </li>
      </ul>
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
import commonMixin from '../mixin';
import { Autoplay, Navigation } from 'swiper';

const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
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
  },
});
const { terminal, typeId, shopId, componentContent } = toRefs(props);
const { productData, jumpProductDetail, jumpGroupWorks } = commonMixin(componentContent, typeId, shopId);
const isEdit = localStorage.getItem('isEdit')
const autoplay = {
  delay: isEdit === 'true' ? 9999999 : 3000,
  disableOnInteraction: false
}
const modules = [Navigation, Autoplay];
</script>

<style lang="scss" scoped>
.product-list {
  padding: 20px 0;
  background-color: #fff;
  .picListWarp {
    width: 1380px;
    max-width: 100%;
    margin: 0 auto;
    position: relative;
  }
  .picList {
    width: 1200px;
    max-width: 100%;
    margin: 0 auto;
    .swiper-button-prev,
    .swiper-button-next {
      width: 50px;
      height: 50px;
      position: absolute;
      cursor: pointer;
      top: 140px;
      background-repeat: no-repeat;
      &:after {
        content: "";
      }
    }
    .swiper-button-prev {
      left: 0;
      background: url("../../../static/images/btn-prev.png");
    }
    .swiper-button-next {
      right: 0;
      background: url("../../../static/images/btn-next.png");
    }
    .a-link {
      cursor: pointer;
      &:hover {
        box-shadow: 3px 4px 20px 0px rgba(186, 186, 186, 0.5);
      }
      .itemImgBox {
        height: auto;
        display: flex;
        flex-direction: column;
        justify-content: center;
        .imgBox {
          padding-bottom: 100%;
          background-color: #cacaca;
          position: relative;
          .el-image {
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
          }
        }
      }
      .text {
        padding: 25px 20px 17px;
        text-align: center;
        //height: 180px;
        .h4 {
          font-size: 18px;
          line-height: 24px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          color: #333333;
          //max-height: 48px;
        }
        .p {
          color: #999;
          font-size: 16px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          padding-top: 18px;
          position: relative;
          margin-top: 8px;
          &:after {
            position: absolute;
            top: 0;
            left: 50%;
            margin-left: -80px;
            width: 160px;
            height: 2px;
            background: #f0f0f0;
            content: "";
          }
        }
        .priceBox {
          dl {
            display: inline-block;
            min-width: 130px;
            dt {
              float: left;
              img {
                display: block;
              }
            }
            dd {
              border: 1px solid #f3f4f5;
              font-size: 25px;
              line-height: 34px;
              color: #c83732;
              margin-left: 57px;
              padding: 0 10px;
            }
          }
          span.discount {
            display: block;
            font-size: 18px;
            line-height: 24px;
            padding: 15px 0 11px;
            color: #ccc;
            text-decoration: line-through;
          }
        }
      }
    }
    ul {
      margin: -15px 0 0 -15px;
      display: flex;
      flex-wrap: wrap;
      li {
        flex: 0 0 50%;
        padding: 15px 0 0 15px;
        width: 0;
      }
    }
    .imgTextNum2 {
      li {
        flex: 0 0 50%;
      }
    }
    .imgTextNum3 {
      li {
        flex: 0 0 33.33%;
      }
    }
    .imgTextNum4 {
      li {
        flex: 0 0 25%;
      }
    }
    .imgTextNum5 {
      li {
        flex: 0 0 20%;
      }
    }
  }
}
.btn-more {
  width: 130px;
  height: 41px;
  border: 2px solid #c5aa7b;
  color: #c5aa7b;
  font-size: 18px;
  background-color: transparent;
  margin: 20px auto 0;
  display: block;
  cursor: pointer;
}
</style>
