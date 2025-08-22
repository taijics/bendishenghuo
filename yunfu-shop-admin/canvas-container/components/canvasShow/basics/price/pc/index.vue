<template>
  <div class="product-list" :class="'terminal'+terminal">
    <div class="picListWarp" v-if="componentContent.arrangeType == '横向滑动'">
      <div class="picList" v-if="productData.composeProducts && productData.composeProducts.length>0">
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
        <swiper class="products-swiper" :options="swiperOption">
          <swiper-slide class="products-swiper-slide item" v-for="(item,index) in productData.composeProducts" :key="index">
            <div class="a-link" @click="jumpProductDetail(item)">
              <div class="itemImgBox">
                <div class="imgBox">
                  <el-image
                    :src="item.image"
                    fit="contain"></el-image>
                </div>
              </div>
              <div class="text">
                <div class="discount-text">
                  <span>任选{{productData.rules[0].number}}件{{productData.rules[0].price}}元</span>
                </div>
                <h4 class="h4">{{item.productName}}</h4>
                <div class="priceBox">
                  <span>¥{{item.price}}</span>
                </div>
                <button class="btn-cart" @click="addCart(item.id)">加入购物车</button>
              </div>
            </div>
          </swiper-slide>
        </swiper>
      </div>
    </div>
    <div v-else class="picList" >
      <ul class="clearfix" :class="'imgTextNum' +  componentContent.productNum">
        <li class="item" v-for="(item,index) in productData.composeProducts.slice(0, componentContent.productRowNum * componentContent.productNum)" :key="index">
          <div class="a-link" @click="jumpProductDetail(item)">
            <div class="itemImgBox">
              <div class="imgBox">
                <el-image
                  :src="item.image"
                  fit="contain"></el-image>
              </div>
            </div>
            <div class="text">
              <div class="discount-text">
                <span>任选{{productData.rules[0].number}}件{{productData.rules[0].price}}元</span>
              </div>
              <h4 class="h4">{{item.productName}}</h4>
              <div class="priceBox">
                <span>¥{{item.price}}</span>
              </div>
              <button class="btn-cart" @click="addCart(item.id)">加入购物车</button>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <button v-show="componentContent.showMore" class="btn-more" @click="jumpPice(productData)">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
  </div>
</template>

<script>
  import {commonMixin} from '../mixin'
  export default {
    mixins: [commonMixin],
    data () {
      return {
        swiperOption: {
          slidesPerView: 4, // 显示数量
          spaceBetween: 13, // 间隔
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
.product-list{
  padding: 20px 0;
  background-color: #fff;
  min-height: 100px;
  .picListWarp{
    width: 1380px;
    max-width: 100%;
    margin: 0 auto;
    position: relative;
  }
  .picList{
    width: 1200px;
    max-width: 100%;
    margin: 0 auto;
    .swiper-button-prev,.swiper-button-next{
      width: 50px;
      height: 50px;
      position: absolute;
      cursor:pointer;
      top: 140px;
      background-repeat: no-repeat;
      &:after{
        content: '';
      }
    }
    .swiper-button-prev{
      left: 0;
      background: url('../../../static/images/btn-prev.png');
    }
    .swiper-button-next{
      right: 0;
      background: url('../../../static/images/btn-next.png');
    }
    .a-link{
      cursor: pointer;
      &:hover{
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
      .text{
        padding:25px 10px 17px;
        text-align: center;
        position: relative;
        //height: 180px;
        .discount-text{
          background: url("../../../static/images/price/bg-discount.png") no-repeat;
          width: 100%;
          height: 47px;
          font-size: 14px;
          color: #fff;
          line-height: 60px;
          text-align: center;
          position: absolute;
          top: -47px;
          left: 0;
        }
        .h4{
          font-size: 18px;
          line-height: 24px;
          overflow: hidden;
          text-overflow:ellipsis;
          white-space: nowrap;
          color: #333333;
          //max-height: 48px;
        }
        .p{
          color: #999;
          font-size: 16px;
          overflow: hidden;
          text-overflow:ellipsis;
          white-space: nowrap;
          padding-top: 18px;
          position: relative;
          margin-top: 8px;
          &:after{
            position: absolute;
            top: 0;
            left: 50%;
            margin-left: -80px;
            width: 160px;
            height: 2px;
            background: #F0F0F0;
            content: '';
          }
        }
        .priceBox {
          padding-top: 11px;
          line-height: 33px;
          span {
            font-size: 25px;
            color: #C83732;
            padding-right: 12px;
          }
          span.discount {
            font-size: 18px;
            color: #ccc;
            text-decoration: line-through;
          }
        }
        .btn-cart{
          margin-top: 5px;
          width: 100%;
          height: 40px;
          background-color: #333;
          font-size: 18px;
          color: #FFEBC4;
        }
      }
    }
    ul{
      margin: -15px 0 0 -15px;
      display: flex;
      flex-wrap: wrap;
      li{
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
  border: 2px solid #C5AA7B;
  color: #C5AA7B;
  font-size: 18px;
  background-color: transparent;
  margin: 20px auto 0;
  display: block;
}
</style>
