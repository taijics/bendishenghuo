<template>
  <div class="spikeList" :class="'terminal'+terminal" v-if="componentContent.shopSeckillId && productData.products && productData.products.length > 0">
    <div class="warp">
      <div>
        <div class="spikeCard">
          <div class="listLeft">
            <img src="../../../static/images/spike/bg-spike.png">
            <div class="bgBox">
              <div class="title"><img src="../../../static/images/spike/tit-spike.png" alt="秒杀专区"></div>
              <div class="text">整点秒杀，数量有限</div>
              <div class="sessions">{{productData.seckillName}} {{state===0?'倒计时':''}}</div>
              <div class="time-text time-text-end" v-if="state===2">活动已结束</div>
              <div v-else>
                <div class="time-text">距离{{count[0]}}还有</div>
                <div class="timeBox">
                  <span>{{count[1]}}</span><i>:</i><span>{{count[2]}}</span><i>:</i><span>{{count[3]}}</span>
                </div>
              </div>
              <button class="btn-more" @click="jumpSeckills(productData)">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
            </div>
          </div>
          <div class="listRight">
            <div class="listItem" v-for='it in productData.products.slice(0, 6)' :key='it.productId' @click="jumpProductDetail(it)">
              <div class="imgBox">
                <img :src="it.image" alt="">
              </div>
              <div class="itemInfo">
                <h3>{{it.productName}}</h3>
                <div class="begrenzt">
                  <span class="people">还剩{{it.stockNumber}}件</span>
                  <div class="progress" :style="{'width':it.sliderVal + '%'}"></div>
                </div>
                <div class="originalPrice">¥{{it.originalPrice}}</div>
                <dl class="discountPrice">
                  <dt>
                    <img src="../../../static/images/spike/flag-spike.png" alt="秒杀价">
                  </dt>
                  <dd>
                    <span>￥</span><b>{{it.price}}</b>
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {commonMixin} from '../mixin'
export default {
  mixins: [commonMixin]
}
</script>

<style lang="scss" scoped>
.spikeList{
  min-height: 100px;
  &.terminal4{
    background-color: #F3F4F5;
    .warp{
      width: 1200px;
    }
    .spikeCard {
      display: flex;
      width: 100%;
      .listLeft {
        width: 487px;
        height: 758px;
        text-align: center;
        position: relative;
        .bgBox {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          .title{
            padding-top: 140px;
          }
          .text{
            color: #8E8D8C;
            font-size: 30px;
            line-height: 40px;
            margin: 15px 0 100px 0;
          }
          .sessions{
            color: #FFEBC4;
            font-size: 30px;
            line-height: 40px;
          }
          .time-text{
            padding-top: 60px;
            color: #FFEBC4;
            font-size: 18px;
            &-end{
              margin-bottom: 20px;
            }
          }
          .timeBox {
            display: flex;
            align-items: center;
            justify-content: center;
            margin:10px 0 50px;
            span {
              display: block;
              width: 60px;
              height: 60px;
              background: rgba(51,51,51,0.8);
              color: #FFFFFF;
              font-size: 30px;
              line-height: 60px;
            }
            i {
              font-size: 30px;
              color: #fff;
              font-style: normal;
              font-weight: bold;
              padding: 0 13px;
            }
          }
          .btn-more {
            width: 130px;
            height: 41px;
            border: 2px solid #FFEBC4;
            color: #FFEBC4;
            font-size: 18px;
            background-color: transparent;
          }
        }
      }
      .listRight {
        padding: 40px 0 0 8px;
        .listItem {
          float:left;
          width: 220px;
          height: 335px;
          margin:0 0 15px 15px;
          background-color: #fff;
          .imgBox {
            width: 220px;
            height: 220px;
            img {
              width: 100%;
              height: 100%;
            }
          }
          .itemInfo {
            position: relative;
            padding: 10px;
            text-align: center;
            h3{
              font-size: 14px;
              color: #333;
              line-height: 18px;
              overflow: hidden;
              text-overflow:ellipsis;
              white-space: nowrap;
            }
            .begrenzt{
              position: absolute;
              left: 5px;
              top: -35px;
              width: 210px;
              height: 30px;
              border: 1px solid #C83732;
              background-color: #C83732;
              text-align: center;
              .people{
                position: relative;
                z-index: 2;
                font-size: 12px;
                color: #FFBAB8;
                line-height: 30px;
              }
              .progress{
                position: absolute;
                right: 0;
                top: 0;
                background-color: #fff;
                height: 28px;
              }
            }
            .discountPrice {
              display: inline-block;
              width: 130px;
              dt{
                float: left;
              }
              dd{
                border: 1px solid #F3F4F5;
                color: #C83732;
                line-height: 30px;
                font-weight: bold;
                span {
                  font-size: 18px;
                }
                b {
                  font-size: 18px;
                }
              }
            }
            .originalPrice {
              font-size: 14px;
              line-height: 19px;
              padding: 10px 0 6px;
              color: #ccc;
              text-decoration: line-through;
            }
          }
        }
      }
    }
  }
}
</style>
