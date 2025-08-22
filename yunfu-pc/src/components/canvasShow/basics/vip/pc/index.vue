<template>
  <div class="product-list" :class="'terminal'+terminal">
    <div class="picListWarp" v-if="componentContent.arrangeType == '横向滑动'">
      <div class="picList" v-if="productData && productData.length>0">
        <div class="vip-button-prev"></div>
        <div class="vip-button-next"></div>
        <swiper class="products-swiper" :options="swiperOption">
          <swiper-slide class="products-swiper-slide item" v-for="(item,index) in productData" :key="index">
            <div class="a-link" @click="jumpProductDetail(item)">
              <div class="itemImgBox">
                <div class="imgBox">
                  <img class="img" :src="item.image" :alt="item.productName">
                </div>
              </div>
              <div class="text">
                <h4 class="h4">{{item.productName}}</h4>
                <div class="priceBox">
                  <icon-svg style="width:53px; height:33px;" icon-class="activity-vip" />
                  <div class="priceR">
                    <span>￥</span><b>{{item.price}}</b>
                  </div>
                </div>
              </div>
            </div>
          </swiper-slide>
        </swiper>
      </div>
    </div>
    <div v-else class="picList" >
      <ul class="clearfix" :class="'imgTextNum' +  componentContent.productNum">
        <li class="item" v-for="(item,index) in productData.slice(0, componentContent.productRowNum * componentContent.productNum)" :key="index">
          <div class="a-link" @click="jumpProductDetail(item)">
            <div class="itemImgBox">
              <div class="imgBox">
                <img class="img" :src="item.image" :alt="item.productName">
              </div>
            </div>
            <div class="text">
              <h4 class="h4">{{item.productName}}</h4>
              <div class="priceBox">
                <icon-svg style="width:53px; height:33px;" icon-class="activity-vip" />
                <div class="priceR">
                  <span>￥</span><b>{{item.price}}</b>
                </div>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <button v-show="componentContent.showMore" class="btn-more" @click="jumpVip">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
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
            el: '.vip-pagination'
          },
          navigation: {
            nextEl: '.vip-button-next',
            prevEl: '.vip-button-prev'
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
      .vip-button-prev,.vip-button-next{
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
      .vip-button-prev{
        left: 0;
        background: url('../../../static/images/btn-prev.png');
      }
      .vip-button-next{
        right: 0;
        background: url('../../../static/images/btn-next.png');
      }
      .a-link{
        cursor: pointer;
        &:hover{
          border: 1px solid #d8d8d8;
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
            .img {
              width: 100%;
              height: 100%;
              position: absolute;
              top: 0;
              left: 0;
              object-fit: cover;
            }
          }
        }
        .text{
          padding:25px 20px 17px;
          text-align: center;
          //height: 180px;
          .h4{
            font-size: 18px;
            line-height: 24px;
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
            color: #333333;
            margin-bottom: 15px;
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
            display: flex;
            justify-content: center;
            .priceR{
              min-width: 100px;
              color: #C83732;
              line-height: 30px;
              font-size: 25px;
            }
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
    cursor: pointer;
  }
</style>
