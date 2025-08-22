<template>
  <div class="hom-pro-list">
    <div class="title">
      <img src="../../../static/images/product/img-title.png" alt="商品推荐"/>
    </div>
    <div v-if="componentContent.arrangeType == '横向滑动'" class="product-list product-swiper">
      <swiper ref="mySwiper" class="product-list-box" :options="swiperOption">
        <swiper-slide class="product-list-item" v-for="(item,index) in productData.slice(0, 10)" :key="index" @click="jumpProductDetail(item)">
          <div class="product-list-img">
            <img v-show="item.image" class="img" :src="item.image">
          </div>
          <div class="product-list-info">
            <label class="product-name">{{item.productName}}</label>
            <div>
              <div class="shop-box" v-if="typeId == 1" @click.stop="jumpStore(item)">
                <label class="shop-name">{{item.shopName}}</label>
                <div class="shop-logo">
                  <img :src="item.shopLogo">
                </div>
              </div>
              <label class="buy-count">{{item.users?item.users: 0}}人付款</label>
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
      <div class="pagination product-pagination" slot="pagination"></div>
    </div>
    <div v-if="componentContent.arrangeType == '多行多列'" class="product-list">
      <div class="product-list-box" >
        <div class="product-list-item" v-for="(item,index) in productData" :key="index" @click="jumpProductDetail(item)">
          <div class="product-list-img">
            <img v-show="item.image" class="img" :src="item.image">
          </div>
          <div class="product-list-info">
            <label class="product-name">{{item.productName}}</label>
            <div>
              <div class="shop-box" v-if="typeId == 1" @click.stop="jumpStore(item)">
                <label class="shop-name">{{item.shopName}}</label>
                <div class="shop-logo">
                  <img :src="item.shopLogo">
                </div>
              </div>
              <label class="buy-count">{{item.users?item.users: 0}}人付款</label>
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
        </div>
      </div>
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
      swiperOption: {
        slidesPerView: 2,
        spaceBetween: 14,
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.product-pagination',
          clickable: true
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
.hom-pro-list{
  padding: 20px 0;
  .title{
    text-align: center;
    margin-bottom: 20px;
    label{
      background: url("../../../static/images/icon-title.png") no-repeat left center;
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
      ::v-deep .swiper-pagination-bullet{
        display: none;
      }
    }
    &.product-swiper .product-list-box{
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
      background-color: #FFFFFF;
      //box-shadow: 0px 0px 15px 0px rgba(52, 52, 52, 0.15);
      border-radius: 0 0 10px 10px;
      padding: 20px;
      label{
        font-weight: normal;
      }
      .product-name{
        font-size: 28px;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow:ellipsis;
        white-space: nowrap;
        margin-bottom: 18px;
        line-height: 40px;
      }
      .shop-box{
        background-color: #333333;
        border-radius: 0px 20px 20px 0px;
        line-height: 40px;
        display: inline-block;
        height: 40px;
        margin-right: 10px;
        .shop-name{
          font-size: 20px;
          color: #FFEBC4;
          padding: 0 8px 0 12px;
        }
        .shop-logo{
          border: 2px solid #707070;
          border-radius: 50%;
          overflow: hidden;
          float: right;
          img{
            width: 34px;
            height: 34px;
            display: block;
          }
        }
      }
      .buy-count{
        color: #C5AA7B;
        font-size: 20px;
        margin-bottom: 16px;
        border: 2px solid #E4E5E6;
        line-height: 40px;
        padding: 0 5px;
        display: inline-block;
      }
      .price-warp{
        display: flex;
        align-items: baseline;
        line-height: 56px;
        .price{
          color: #C83732;
          font-size: 40px;
          margin-right: 20px;
        }
        .original-price{
          font-size: 24px;
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

.pagination{
  display: flex;
  justify-content: center;
  padding: 20px 0;
  ::v-deep .swiper-pagination-bullet{
    width: 10px;
    height: 10px;
    background: #333333;
    opacity: 0.3;
    border-radius: 5px;
    margin: 0 5px;
  }
  ::v-deep .swiper-pagination-bullet-active{
    width: 20px;
    height: 10px;
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
