<template>
  <div class="hom-pro-list">
    <div class="product-swiper">
      <swiper class="product-swiper-box" :options="swiperOption">
        <swiper-slide class="product-swiper-item" v-for="(item,index) in productData.slice(0, 3)" :key="index" @click="jumpProductDetail(item)">
          <div class="product-swiper-img">
            <img class="img" :src="item.image">
          </div>
          <div class="product-swiper-info">
            <label class="product-name">{{item.productName}}</label>
            <div class="price-warp">
              <div class="price">
                ¥ {{item.price}}
              </div>
              <div class="original-price">
                ¥ {{item.originalPrice}}
              </div>
            </div>
          </div>
        </swiper-slide>
      </swiper>
      <div class="pagination new-pagination"></div>
    </div>
    <button v-show="componentContent.showMore" class="btn-more" @click="jumpLink(componentContent.linkObj)">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
  </div>
</template>

<script>
import {commonMixin} from '../mixin'
export default {
  mixins: [commonMixin],
  data () {
    return {
      index: 1,
      swiperOption: {
        slidesPerView: 3,
        spaceBetween: 12,
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.new-pagination'
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.hom-pro-list{
  ::v-deep .swiper-wrapper{
    position: static;
  }
  /**横向滑动**/
  .product-swiper{
    width: 100%;
    height: 454px;
    padding: 90px 34px 0;
    background: url("../../../static/images/newProduct/bg-product-card.png") no-repeat center;
    position: relative;
    &+.btn-more{
      margin-top: 20px;
    }
    .title{
      padding: 22px 0px 0 0;
      label{
        background-image: none;
        color: #A56C4C;
        font-style: italic;
        padding: 0;
      }
    }
    &-box {
      padding-bottom: 20px;
    }
    &-item {
      width: 220px;
      position: relative;
      background-color: #FFFFFF;
    }
    &-img {
      width: 220px;
      height: 220px;
      position: relative;
      &:after{
        content: '';
        display: block;
        width: 54px;
        height: 54px;
        background: url("../../../static/images/newProduct/flag-new.png") no-repeat;
        position: absolute;
        top: 0;
        left: 0;
      }
      .img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
    &-info {
      background-color: #FFFFFF;
      padding: 10px;
      text-align: center;
      .product-name{
        font-size: 20px;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow:ellipsis;
        white-space: nowrap;
        margin-bottom: 6px;
        line-height: 28px;
      }
      .price-warp{
        display: flex;
        justify-content: center;
        align-items: baseline;
        line-height: 28px;
        .price{
          color: #C83732;
          font-size: 20px;
          margin-right: 10px;
        }
        .original-price{
          font-size: 16px;
          color: #ccc;
          text-decoration: line-through;
        }
      }
    }
  }
}

.pagination{
  display: flex;
  justify-content: center;
  width: 100%;
  bottom: 0;
  ::v-deep .swiper-pagination-bullet{
    width: 24px;
    height: 4px;
    background: #FFFFFF;
    opacity: 0.5;
    border-radius: 2px;
    margin: 0 10px;
  }
  ::v-deep .swiper-pagination-bullet-active{
    opacity: 1;
  }
}
.btn-more {
  width: 170px;
  height: 54px;
  border: 2px solid #C5AA7B;
  color: #C5AA7B;
  font-size: 24px;
  background-color: transparent;
  margin: 20px auto 0;
  display: block;
}

</style>
