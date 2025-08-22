<template>
  <div class="group-list">
    <div class="group-warp">
      <div class="title">
        <label>
          <img src="../../../static/images/group/img-title.png" alt="拼团专区"/>
        </label>
        <a v-show="componentContent.showMore" class="btn-all a-link" @click="jumpDiscount(productData)">更多<i class="iconfont icon-arrow-right"></i></a>
      </div>
      <swiper class="pro-box" :options="swiperOption">
        <swiper-slide class="pro-item" v-for="(item,index) in productData.products" :key="index" @click="jumpProductDetail(item)">
          <div class="pro-item-img">
            <img v-show="item.image" class="img" :src="item.image">
          </div>
          <div class="pro-item-info">
            <label class="name">{{item.productName}}</label>
            <div class="price">
              <label class="unit">¥ </label>
              <label class="val"> {{item.price}}</label>
            </div>
            <label class="buyCount">{{item.workUsers?item.workUsers:0}}人已拼</label>
          </div>
        </swiper-slide>
      </swiper>
      <div class="pagination group-pagination"></div>
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
        slidesPerView: 3, // 显示数量
        spaceBetween: 16, // 间隔
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.group-pagination'
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
    .group-warp{
      width: 710px;
      height: 528px;
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
      padding: 40px 0 30px 20px;
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
        height: 382px;
        background: #FFFFFF;
        .pro-item-img{
          .img{
            width: 100%;
            height: 220px;
          }
        }
        .pro-item-info{
          text-align: center;
          padding: 0px 10px 20px;
          .name{
            font-size: 24px;
            font-weight: normal;
            color: #FFEBC4;
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
          .price{
            color: #C83732;
            font-size: 28px;
            font-weight: bold;
            line-height: 40px;
          }
          .buyCount{
            font-size: 24px;
            color: #ccc;
            line-height: 34px;
            font-weight: normal;
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
