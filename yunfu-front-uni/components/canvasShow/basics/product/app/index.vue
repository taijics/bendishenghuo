<template>
  <div class="hom-pro-list">
    <div class="title">
      <!-- #ifdef MP-WEIXIN -->
      <image
          class="title-img"
          :src="`${VUE_APP_STATIC_URL}static/canvas-images/product/img-title.png`"
          alt="商品推荐"
          mode="widthFix"
      />
      <!-- #endif -->
      <!-- #ifdef H5 || APP-PLUS -->
      <image
          class="title-img"
          :src="`${VUE_APP_STATIC_URL}static/canvas-images/product/img-title.png`"
          alt="商品推荐"
          mode="widthFix"
      />
      <!-- #endif -->
    </div>
    <div
        v-if="componentContent.arrangeType == '横向滑动' && productData.length > 2"
        class="product-list"
    >
      <swiper
          ref="mySwiper"
          class="swiper product-list-box"
          :circular="true"
          :indicator-dots="false"
          :autoplay="true"
          :disable-touch="productData.length < 2"
          :display-multiple-items="productData.length >= 2?2:productData.length"
          @change="swiperChange"
      >
        <swiper-item
            class="product-list-item-warp"
            v-for="(item,index) in productData"
            :key="index"
        >
          <div class="product-list-item" v-if="JSON.stringify(item)!=='{}'" @click="jumpProductDetail(item)">
            <div class="product-list-img">
              <image
                  class="img pic-img default-img"
                  :src="item.image"
              />
            </div>
            <div class="product-list-info">
              <label class="product-name">{{ item.productName }}</label>
              <div class="flex">
                <div
                    class="shop-box"
                    v-if="typeId == 1"
                    @click.stop="jumpStore(item)"
                >
                  <label class="shop-name">{{ item.shopName }}</label>
                  <div class="shop-logo">
                    <image :src="item.shopLogo" />
                  </div>
                </div>
                <label class="buy-count">已售{{ item.number ? item.number : 0 }}件</label>
              </div>
              <div class="price-warp">
                <!-- #ifdef MP-WEIXIN -->
                <image
                    class="iconImg"
                    v-if="item.activityType == 1"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/groupBuyIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 2"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 4"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 3"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 5"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 9"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/memberCenterIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 8"
                    :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"
                />
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
<!--                <image-->
<!--                    class="iconImg"-->
<!--                    v-if="item.activityType == 1"-->
<!--                    src="../../../static/images/groupBuyIcon.png"-->
<!--                >-->
<!--                  <image-->
<!--                      class="iconImg"-->
<!--                      v-if="item.activityType == 2"-->
<!--                      src="../../../static/images/spikeIcon.png"-->
<!--                  >-->
<!--                    <image-->
<!--                        class="iconImg"-->
<!--                        v-if="item.activityType == 4"-->
<!--                        src="../../../static/images/spikeIcon.png"-->
<!--                    >-->
<!--                      <image-->
<!--                          class="iconImg"-->
<!--                          v-if="item.activityType == 3"-->
<!--                          src="../../../static/images/discountListIcon.png"-->
<!--                      >-->
<!--                        <image-->
<!--                            class="iconImg"-->
<!--                            v-if="item.activityType == 5"-->
<!--                            src="../../../static/images/discountListIcon.png"-->
<!--                        >-->
<!--                          <image-->
<!--                              class="iconImg"-->
<!--                              v-if="item.activityType == 9"-->
<!--                              src="../../../static/images/memberCenterIcon.png"-->
<!--                          >-->
<!--                            <image-->
<!--                                class="iconImg"-->
<!--                                v-if="item.activityType == 8"-->
<!--                                :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"-->
<!--                            >-->
                              <!-- #endif -->
                              <div class="price">
                                ¥ {{ item.price }}
                              </div>
                              <div class="original-price">
                                ¥ {{ item.originalPrice }}
                              </div>
              </div>
            </div>
          </div>
          <!-- 自定义骨架屏 -->
          <div
              class="product-list-item ske-loading"
              v-else
          >
            <div class="product-list-img child-loading">

            </div>
            <div class="product-list-info">
              <label class="product-name child-loading"></label>
              <div class="price-warp child-loading" style="padding: 5px 0">
              </div>
              <div class="price-warp child-loading" style="padding: 5px 0">
              </div>
            </div>
          </div>
        </swiper-item>
      </swiper>
      <view
          class="swiper-dots"
          v-if="productData && productData.length > 2"
      >
        <text
            class="dot"
            :class="index - swiperCurrent <= 1 && index - swiperCurrent >=0  && 'dot-active'"
            v-for="(dot, index) in productData.length"
            :key="index"
        ></text>
      </view>
    </div>
    <div
        v-else
        class="product-list"
    >
      <div class="product-list-box">
        <div
            class="product-list-item-warp"
            v-for="(item,index) in productData"
            :key="index"
        >
          <div
              @click="jumpProductDetail(item)"
              class="product-list-item"
              v-if="JSON.stringify(item)!=='{}'"
          >
            <div class="product-list-img">
              <image
                  class="img pic-img default-img"
                  :src="item.image"
              />
            </div>
            <div class="product-list-info">
              <label class="product-name">{{ item.productName }}</label>
              <div class="flex">
                <div
                    class="shop-box"
                    v-if="typeId == 1"
                    @click.stop="jumpStore(item)"
                >
                  <label class="shop-name">{{ item.shopName }}</label>
                  <div class="shop-logo">
                    <image :src="item.shopLogo" />
                  </div>
                </div>
                <label class="buy-count">已售{{ item.number ? item.number : 0 }}件</label>
              </div>
              <div class="price-warp">
                <!-- #ifdef MP-WEIXIN -->
                <image
                    class="iconImg"
                    v-if="item.activityType == 1"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/groupBuyIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 2"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 4"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 3"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 5"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 9"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/memberCenterIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 8"
                    :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"
                />
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
                <image
                    class="iconImg"
                    v-if="item.activityType == 1"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/groupBuyIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 2"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 4"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 3"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 5"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 9"
                    :src="`${VUE_APP_STATIC_URL}static/canvas-images/memberCenterIcon.png`"
                />
                <image
                    class="iconImg"
                    v-if="item.activityType == 8"
                    :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"
                />
                <!-- #endif -->
                <div class="price">
                  ¥ {{ item.price }}
                </div>
                <div class="original-price">
                  ¥ {{ item.originalPrice }}
                </div>
              </div>
            </div>
          </div>
          <!-- 自定义骨架屏 -->
          <div
              class="product-list-item ske-loading"
              v-else
          >
            <div class="product-list-img child-loading">

            </div>
            <div class="product-list-info">
              <label class="product-name child-loading"></label>
              <div class="price-warp child-loading" style="padding: 5px 0">
              </div>
              <div class="price-warp child-loading" style="padding: 5px 0">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <slide-loading />
    <view class="reachBottom"
          v-if="productData.length >= total && total != 0">
      <image class="reach-icon"
             :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
             mode="widthFix">
      </image>
      <text class="reach-text">这里到底了哦~~</text>
    </view>
    <button
        v-show="componentContent.showMore"
        class="btn-more"
        @click="jumpProList(componentContent.productData)"
    >查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
  </div>
</template>

<script setup>
import {ref, toRefs} from 'vue';
import productMixin from '../mixin.js';
import { VUE_APP_STATIC_URL } from "@/config/api";
import SlideLoading from "../../../../SlideLoading/index.vue";

const props = defineProps({
  typeId: {
    type: Number,
    default: 1,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    },
  },
});
const { typeId, componentContent } = toRefs(props);
const { productData, total, jumpProductDetail, jumpProList,loadNext } = productMixin(componentContent);
const swiperCurrent = ref(0)
const topLeft = ref(0)

function swiperChange(e) {
  swiperCurrent.value = e.detail.current;
}
// 跳转到店铺主页
function jumpStore(item){
  uni.navigateTo({
    url: `/pages_category_page1/store/index?storeId=${item.shopId}`
  })
}
defineExpose({loadNext})
</script>

<style
    lang="scss"
    scoped
>
.hom-pro-list {
  padding: 20rpx 13rpx;

  .title {
    text-align: center;
    margin-bottom: 20rpx;

    .title-img {
      width: 211rpx;
    }
  }

  /**多行多列**/
  .product-list {
    position: relative;

    &-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;

      &.swiper {
        height: 620rpx;
      }
    }

    &.product-swiper .product-list-box {
      padding-left: 0;
    }

    &-item-warp {
      margin: 0 0 20rpx 0;
    }

    &-item {
      width: 348rpx;
      padding: 0 7rpx;
      box-sizing: content-box;
    }

    &-img {
      width: 348rpx;
      height: 348rpx;
      background-color: #f5f5f5;
      border-radius: 10rpx 10rpx 0 0;

      .img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }

    &-info {
      background-color: #FFFFFF;
      //box-shadow: 0px 0px 15px 0px rgba(52, 52, 52, 0.15);
      border-radius: 0 0 10rpx 10rpx;
      padding: 20rpx;

      label {
        font-weight: normal;
      }

      .product-name {
        font-size: 28rpx;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        margin-bottom: 18rpx;
        line-height: 40rpx;
      }

      .flex {
        display: flex;
        align-items: center;
      }

      .shop-box {
        background-color: #333333;
        border-radius: 0rpx 20rpx 20rpx 0rpx;
        line-height: 40rpx;
        display: flex;
        align-items: center;
        height: 40rpx;
        margin-right: 10rpx;

        .shop-name {
          font-size: 20rpx;
          color: #FFEBC4;
          padding: 0 8rpx 0 12rpx;
        }

        .shop-logo {
          border: 2rpx solid #707070;
          border-radius: 50%;
          overflow: hidden;
          float: right;

          image {
            width: 34rpx;
            height: 34rpx;
            display: block;
          }
        }
      }

      .buy-count {
        color: #C5AA7B;
        font-size: 20rpx;
        border: 2rpx solid #E4E5E6;
        line-height: 40rpx;
        padding: 0 5rpx;
      }

      .price-warp {
        display: flex;
        align-items: baseline;
        line-height: 56rpx;

        .iconImg {
          width: 58rpx;
          height: 36rpx;
          margin-right: 10rpx;
        }

        .price {
          color: #C83732;
          font-size: 40rpx;
          margin-right: 20rpx;
        }

        .original-price {
          font-size: 24rpx;
          color: #ccc;
          text-decoration: line-through;
        }
      }
    }

    //::v-deep .swiper-pagination-bullet{
    //  display: none;
    //}
  }
}

//::v-deep .uni-swiper-dots{
//  display: flex;
//  justify-content: center;
//  padding: 10rpx 0;
//  .uni-swiper-dot{
//    width: 10rpx;
//    height: 10rpx;
//    background: #333333;
//    opacity: 0.3;
//    border-radius: 5rpx;
//    margin: 0 5rpx;
//    &-active{
//      width: 20rpx;
//      height: 10rpx;
//      opacity: 1;
//    }
//  }
//}
.swiper-dots {
  display: flex;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 15rpx;
  z-index: 66;

  .dot {
    width: 10rpx;
    height: 10rpx;
    background: #333333;
    opacity: 0.3;
    border-radius: 5rpx;
    margin: 0 10rpx;
  }

  .dot-active {
    width: 20rpx;
    opacity: 1;
  }
}

//.pagination{
//  display: flex;
//  justify-content: center;
//  padding: 20rpx 0;
//  ::v-deep .swiper-pagination-bullet{
//    width: 10rpx;
//    height: 10rpx;
//    background: #333333;
//    opacity: 0.3;
//    border-radius: 5rpx;
//    margin: 0 5rpx;
//  }
//  ::v-deep .swiper-pagination-bullet-active{
//    width: 20rpx;
//    height: 10rpx;
//    opacity: 1;
//  }
//}

.btn-more {
  width: 170rpx;
  height: 54rpx;
  line-height: 54rpx;
  border: 2rpx solid #C5AA7B;
  color: #C5AA7B;
  font-size: 24rpx;
  background-color: transparent;
  margin: 20rpx auto 0;
  display: flex;
  align-items: center;
}

</style>
