<template>
  <div class="group-list">
    <div class="group-warp">
      <div class="title">
        <label>
          <img src="../../../static/images/price/img-title.png" alt="组合优惠"/>
        </label>
        <div class="price-text" v-if="productData.rules">
          {{productData.rules[0].price}}元任选{{productData.rules[0].number}}件
        </div>
        <a v-show="componentContent.showMore" class="btn-all a-link" @click="jumpDiscount(productData)">更多<i class="iconfont icon-arrow-right"></i></a>
      </div>
      <swiper class="pro-box" :options="swiperOption">
        <swiper-slide class="pro-item" v-for="(item,index) in productData.composeProducts" :key="index" @click="jumpProductDetail(item)">
          <div class="pro-item-img">
            <img v-show="item.image" class="img" :src="item.image">
          </div>
          <div class="pro-item-info">
            <h3 class="name">
              {{item.productName}}
            </h3>
            <div class="stock">
              还剩{{item.stockNumber}}件
            </div>
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
      <div class="pagination price-pagination"></div>
    </div>
  </div>

</template>

<script>
import {commonMixin} from '../mixin'
export default {
  mixins: [commonMixin],
  data () {
    return {
      swiperOption: {
        slidesPerView: 2, // 显示数量
        spaceBetween: 20, // 间隔
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.price-pagination'
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.group-list{
  padding: 30px 20px 60px;
  min-height: 80px;
  .group-warp{
    width: 710px;
    height: 544px;
    padding: 0 10px;
    background: #333333;
    box-shadow: 0px 20px 30px rgba(0, 0, 0, 0.3);
    opacity: 1;
    border-radius: 20px;
  }
  .title{
    display: flex;
    align-items:center;
    position: relative;
    padding: 32px 0 20px 20px;
    .price-text{
      width: 300px;
      height: 50px;
      background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
      box-shadow: 0px 6px 12px rgba(233, 0, 0, 0.3);
      border-radius: 26px;
      font-size: 24px;
      color: #fff;
      text-align: center;
      line-height: 50px;
      margin-left: 20px;
    }
    .btn-all{
      position: absolute;
      right: 8px;
      top: 40px;
      line-height: 33px;
      padding-right: 25px;
      font-size: 24px;
      color: #FFEBC4;
      .iconfont{
        content: '';
        font-size: 26px;
        position: absolute;
        right: 0;
        top: 0;
      }
    }
  }
  .pro-box{
    padding-bottom: 20px;
    .pro-item{
      width: 220px;
      height: 398px;
      background: #FFFFFF;
      .pro-item-img{
        .img{
          width: 100%;
          height: 236px;
        }
      }
      .pro-item-info{
        padding: 0 20px;
        .name{
          font-size: 24px;
          line-height: 40px;
          color: #333333;
          overflow: hidden;
          text-overflow:ellipsis;
          white-space: nowrap;
        }
        .stock{
          padding: 0 8px;
          height: 40px;
          border: 2px solid #E4E5E6;
          line-height: 40px;
          margin: 10px 0;
          display: inline-block;
          font-size: 20px;
          color: #C5AA7B;
        }
        .price{
          font-size: 32px;
          font-weight: bold;
          line-height: 44px;
          color: #C83732;
          padding-right: 10px;
          display: inline-block;
        }
        .original-price{
          font-size: 20px;
          line-height: 28px;
          color: #CCCCCC;
          display: inline-block;
        }
      }
    }
  }
  .pagination{
    display: flex;
    justify-content: center;
    ::v-deep .swiper-pagination-bullet{
      width: 24px;
      height: 4px;
      background: #fff;
      opacity: 0.5;
      border-radius: 2px;
      margin: 0 5px;
    }
    ::v-deep .swiper-pagination-bullet-active{
      opacity: 1;
    }
  }
}
</style>
