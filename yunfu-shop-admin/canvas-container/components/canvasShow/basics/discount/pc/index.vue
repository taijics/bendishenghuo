<template>
  <div class="discount">
    <div class="discount-top">
      <div class="discount-top-text">全场5折起</div>
      <div class="discount-top-time">
<!--        距{{count[0]}}-->
        距离本场结束还有
        <div class="time"><span>{{count[1]}}</span>:<span>{{count[2]}}</span>:<span>{{count[3]}}</span></div></div>
    </div>
    <div class="discount-more" :style="{backgroundImage: 'url('+ componentContent.moreBg +')'}">
      <div class="discount-more-overlay">
        <button class="btn-more" @click="jumpGroupWorks(productData)">查看全部</button>
      </div>
    </div>
    <div class="discount-list">
      <div class="swiper-button-prev"></div>
      <div class="swiper-button-next"></div>
      <swiper class="products-swiper" :options="swiperOption">
        <swiper-slide class="products-swiper-slide item" v-for="(item,index) in productData.products" :key="index">
          <div class="a-link" @click="jumpProductDetail(item)">
            <div class="itemImgBox">
              <div class="imgBox">
                <el-image
                  :src="item.image"
                  fit="contain"></el-image>
              </div>
            </div>
            <div class="text">
              <h4 class="h4">{{item.productName}}</h4>
              <div class="priceBox">
                <span class="discount" v-if="item.originalPrice">¥{{item.originalPrice}}</span>
                <dl>
                  <dt><img src="../../../static/images/discount/flag-discount.png" alt="折扣价"></dt>
                  <dd>
                    ¥{{item.price}}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </swiper-slide>
      </swiper>
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
        spaceBetween: 13, // 间隔
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.discount-pagination'
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
.discount{
  width: 1200px;
  max-width: 100%;
  margin: 0 auto;
  overflow: hidden;
  &-top{
    height: 250px;
    padding-top: 96px;
    margin-bottom: 15px;
    background: url("../../../static/images/discount/bg-discount-top.png") no-repeat;
    &-text{
      background: url("../../../static/images/discount/bg-discount-top-text.png") no-repeat;
      width: 176px;
      height: 83px;
      padding-top: 13px;
      line-height: 50px;
      font-size: 25px;
      color: #fff;
      margin: 0px auto 18px;
      text-align: center;
    }
    &-time{
      margin: 0 auto;
      text-align: center;
      font-size: 16px;
      color: #FFEBC4;
      .time{
        font-size: 20px;
        color: #999;
        display: inline-block;
        span{
          display: inline-block;
          line-height: 40px;
          padding: 0 9px;
          margin: 0 5px;
          background-color: #343434;
          color: #fff;
        }
      }
    }
  }
  &-list{
    margin-right: 303px;
    position: relative;
    .swiper-button-prev,.swiper-button-next{
      width: 95px;
      height: 95px;
      position: absolute;
      cursor:pointer;
      top: 115px;
      background-repeat: no-repeat;
      &:after{
        content: '';
      }
    }
    .swiper-button-prev{
      left: -22px;
      background: url('../../../static/images/btn-prev2.png');
    }
    .swiper-button-next{
      right: -22px;
      background: url('../../../static/images/btn-next2.png');
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
          dl {
            display: inline-block;
            min-width: 130px;
            dt{
              float: left;
              img{
                display: block;
              }
            }
            dd{
              border: 1px solid #F3F4F5;
              font-size: 25px;
              line-height: 34px;
              color: #C83732;
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
  }
  &-more{
    width: 290px;
    height: 466px;
    float: right;
    position: relative;
    &-overlay{
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.6);
      display: flex;
      justify-content: center;
      align-items: center;
      .btn-more{
        width: 130px;
        height: 41px;
        background-color: #fff;
        font-size: 18px;
        color: #C5AA7B;
      }
    }
  }
}
</style>
