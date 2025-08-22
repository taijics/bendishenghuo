<template>
  <div class="discount">
    <div class="discount-top">
      <div class="discount-top-text">全场{{ productData.discount || 9 }}折起</div>
      <div class="discount-top-time">
        {{ifPreheat ? '距离本场开始还有': '距离本场结束还有'}}
        <div class="time">
          <span>{{ count[1] || '00' }}</span>:<span>{{ count[2] || '00' }}</span>:<span>{{ count[3] || '00' }}</span>
        </div>
      </div>
    </div>
    <div class="discount-more" :style="{backgroundImage: 'url('+ componentContent.moreBg +')'}">
      <div class="discount-more-overlay">
        <button class="btn-more" @click="jumpDiscount(productData)">查看全部</button>
      </div>
    </div>
    <div class="discount-list">
      <div class="discount-button-prev"></div>
      <div class="discount-button-next"></div>
      <swiper class="products-swiper" :options="swiperOption">
        <swiper-slide class="products-swiper-slide item"
          v-for="(item,index) in productData.products"
          :key="index"
        >
          <div class="a-link" @click="jumpProductDetail(item)">
            <div class="itemImgBox">
              <div class="imgBox">
                <el-image
                  :src="item.image"
                  fit="cover"></el-image>
              </div>
            </div>
            <div class="text">
              <h4 class="h4">{{item.productName}}</h4>
              <div class="priceBox">
                <span class="discount" v-if="item.originalPrice">¥{{item.originalPrice}}</span>
                <div class="discountPrice">
                  <icon-svg style="width:53px; height:33px;" icon-class="activity-zhekou" />
                  <div class="priceR">
                    <span>￥</span><b>{{item.price}}</b>
                  </div>
                </div>
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
        // loop: true,
        pagination: {
          el: '.discount-pagination'
        },
        navigation: {
          nextEl: '.discount-button-next',
          prevEl: '.discount-button-prev'
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
$discountHeight: 465px; // 折扣页内容 统一高度
.discount{
  width: 1250px;
  max-width: 100%;
  margin: 0 auto;
  overflow: hidden;
  &-top{
    height: 250px;
    padding-top: 96px;
    margin-bottom: 15px;
    // background: url("../../../static/images/discount/bg-discount-top.png") no-repeat;
    background: url("../../../static/images/discount/bg-discount-top.png");
    background-size: cover;
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
    height: $discountHeight;
    margin-right: 303px;
    position: relative;
    .discount-button-prev,.discount-button-next{
      width: 95px;
      height: 95px;
      position: absolute;
      cursor:pointer;
      top: 115px;
      background-repeat: no-repeat;
      z-index: 2;
      &:after{
        content: '';
      }
    }
    .discount-button-prev{
      left: -22px;
      background: url('../../../static/images/btn-prev2.png');
    }
    .discount-button-next{
      right: -22px;
      background: url('../../../static/images/btn-next2.png');
    }
    .a-link{
      height: $discountHeight;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
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
          .discountPrice {
            display: flex;
            justify-content: center;
            .priceR{
              min-width: 100px;
              border: 1px solid #F3F4F5;
              color: #C83732;
              line-height: 30px;
              font-size: 25px;
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
    height: $discountHeight;
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
        cursor: pointer;
      }
    }
  }
}
</style>
