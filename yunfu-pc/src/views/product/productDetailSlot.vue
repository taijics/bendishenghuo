<template>
  <div class="detailPage">
    <div class="top">
      <div class="swiper-box" style="height: 560px">
          <!-- swiper1 -->
          <swiper
            :options="swiperOptionTop"
            class="gallery-top"
            ref="swiperTop">
            <swiper-slide
              v-for="(item) of productData.images"
              :key="item"
              :style="{backgroundImage: 'url('+ item +')'}"></swiper-slide>
          </swiper>
          <!-- swiper2 Thumbs -->
          <div class="swiperThumbsLeft">
            <div class="thumbsBox">
              <swiper
                :options="swiperOptionThumbs"
                class="gallery-thumbs"
                ref="swiperThumbs">
                <swiper-slide
                  v-for="(item, index) of productData.images"
                  :key="index"
                  :style="{backgroundImage: 'url('+ item +')'}">
                  <div style="width: 100%; height: 100%;"
                    @click="thumbsClick(index)"></div>
                </swiper-slide>
              </swiper>
              <div class="swiper-button-prev swiper-button-white iconfont"
                slot="button-prev">&#xe660;</div>
              <div class="swiper-button-next swiper-button-white iconfont"
                slot="button-next">&#xe695;</div>
            </div>
          </div>
      </div>
      <div class="proInfo">
        <div class="proName">{{productData.productName}}</div>
        <div class="proBrief">{{productData.productBrief}}</div>
        <!-- -----------------------------------------营销活动额外优惠信息插槽-------------------------------------------- -->
        <slot name="buyDiscount"></slot>
        <!-- +++++++++++++++++++++++++++++++++++++++活动icon  ++++++++++++++++++++++++++++++++ -->
        <div class="proPrice">
          <icon-svg v-if="currentData.activityType === 1"
          style="width: 57px; height: 36px;"
          icon-class="activity-pintuan" />
          <icon-svg v-if="[2,4].includes(currentData.activityType)"
          style="width: 57px; height: 36px;"
          icon-class="activity-miaosha" />
          <icon-svg v-if="[3,5].includes(currentData.activityType)"
          style="width: 57px; height: 36px;"
          icon-class="activity-zhekou" />
          <icon-svg v-if="currentData.activityType === 9"
          style="width: 57px; height: 36px;"
          icon-class="activity-vip" />
          <!-- ++++++++++++++++++++++++++++++++++++++ 价格 ++++++++++++++++++++++++++++++++ -->
          <span class="price">￥{{ currentData.price || currentData.originalPrice }}</span>
          <span class="orginPrice" v-if="currentData.price > 0">￥{{ currentData.originalPrice }}</span>
          <div class="favoritesBtn" @click="collect">
            <icon-svg
            v-if="productData.ifCollect === 0"
            style="font-size: 24px;" icon-class="unCollect" />
            <icon-svg v-else
            style="font-size: 24px;" icon-class="collect" />
            <span>收藏</span>
          </div>
        </div>
        <!-- ----------------------------------------------------优惠券------------------------------------------------- -->
        <div class="disCoupon" v-if="productData.markTools || productData.shopMarkTools || priceRules">
          <span>优惠:</span>
          <div class="proDiscount" v-if="priceRules.length === 0">
            <div class="activityLabel"
              v-for="item of productData.markTools"
              :key="item.couponId"
            >
              <span>{{item.activityName}}</span>
              <span>优惠券：{{item.content}}</span>
              <span @click="getThisCoupon(item, 1)">{{item.state === 3 ? '领取' : '已领取'}}</span>
            </div>
            <div class="activityLabel"
              v-for="item of productData.shopMarkTools"
              :key="item.shopCouponId"
            >
              <span>{{item.activityName}}</span>
              <span>优惠券：{{item.content}}</span>
              <span @click="getThisCoupon(item, 2)">{{item.state === 3 ? '领取' : '已领取'}}</span>
            </div>
          </div>
          <div class="proRules" v-else>
            <div class="rule"
              v-for="(item, index) in priceRules"
              :key="index"
            >
              <div class="container">
                满<span>{{ item.number }}</span>件<span>{{ item.price }}</span>元
              </div>
            </div>
          </div>
        </div>
        <!-- -----------------------------------------------------规格----------------------------------------------- -->
        <div class="sku" v-if="productData.names && productData.names.length > 0">
          <ul v-for='it in productData.names' :key='it.nameCode'>
            <li>
              <p class="proDescribeTit">
                {{it.skuName === '' ? '' : it.skuName + ':'}}
              </p>
              <!-- 多选项值 -->
              <p v-if="it.values && it.values.length > 1">
                <span
                  v-for='kt in it.values'
                  :key='kt.valueCode'
                  :class="[{'selected-item': kt.selected}]"
                  @click="selectSku(kt, it);"
                >
                  {{kt.skuValue }}
                </span>
              </p>
              <!-- 单规格单选项值 -->
              <p v-else>
                <span class="selected-item">
                  {{ '默认规格' }}
                </span>
              </p>
            </li>
          </ul>
        </div>
        <div class="sum">
          <span>数量：</span>
          <div class="proNumberList">
            <el-input-number v-model="productNumber"
            :min="1" :max="currentData.stockNumber"
            label="库存"
            @change="setNumber"></el-input-number>
            <span>库存<b>{{currentData.stockNumber}}</b>件</span>
          </div>
        </div>
        <!-- --------------------------------------------购买、加入购物车按钮插槽----------------------------------- -->
        <slot name="buyBtn"></slot>
      </div>
    </div>
    <!-- ------------------------------------------------中间额外活动---------------------------------------------- -->
    <slot name="extra"></slot>
    <!-- ------------------------------------------------下半部商品信息-------------------------------------------- -->
    <div class="bottom">
      <div class="favorite">
        <div class="title">猜你喜欢</div>
        <div class="favoriteList">
          <div class="likeProItem"
            @click="goToProDetail(item)"
            v-for="(item) of similarProducts"
            :key="item.productId">
            <div class="itemImgBox">
              <div class="imgBox">
                <img ref="getHeight" :src="item.image">
              </div>
            </div>
            <div class="text">
              <h4 class="h4">{{item.productName}}</h4>
            </div>
          </div>
        </div>
      </div>
      <div class="infos">
        <el-tabs v-model="activeName" type="card">
          <el-tab-pane label="宝贝详情" name="first">
            <div class="detailCont" v-html="productData.text"></div>
          </el-tab-pane>
          <el-tab-pane label="商品评论" name="second">
            <Evaluation :evaluateParam="evaluateParam" />
          </el-tab-pane>
          <el-tab-pane label="商品问答" name="third">
            <ProductAnswer />
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import { Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'

import LikeList from '@/views/product/components/likeList'
import Evaluation from '@/views/product/components/evaluation'
import ProductAnswer from '@/views/product/components/productAnswer'

import {
  tabkeTheCoupon
} from '@/api/coupon.js'
export default {
  components: {
    Swiper,
    SwiperSlide,
    LikeList,
    Evaluation,
    ProductAnswer
  },
  props: {
    productData: {
      type: Object,
      default: () => {}
    },
    // 规格信息  { names: [] }
    skuData: {
      type: Object,
      default: () => {}
    },
    currentData: {
      type: Object,
      default: () => {}
    },
    // 定价捆绑规则
    priceRules: {
      type: Array,
      default: () => []
    },
    // 猜你喜欢数据
    similarProducts: {
      type: Array,
      default: () => []
    },
    evaluateParam: {
      type: Object,
      default: () => {}
    }
  },
  data () {
    return {
      swiperTop: null,
      swiperThumbs: null,
      swiperOptionTop: {
        spaceBetween: 10,
        loop: true,
        loopedSlides: 20
      },
      swiperOptionThumbs: {
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        direction: 'vertical',
        spaceBetween: 10,
        slidesPerView: 3,
        loop: true,
        freeMode: true,
        loopedSlides: 20, // looped slides should be the same
        centeredSlides: true,
        watchSlidesVisibility: true
      },
      activeName: 'first',
      productNumber: 1
    }
  },
  mounted () {
    if (!this.swiperTop || !this.swiperThumbs) {
      this.swiperTop = this.$refs.swiperTop.$swiper
      this.swiperThumbs = this.$refs.swiperThumbs.$swiper

      this.swiperTop.controller.control = this.swiperThumbs
      this.swiperThumbs.controller.control = this.swiperTop
    }
  },
  methods: {
    // 轮播图
    thumbsClick (index) {
      this.swiperThumbs.slideTo(index, 300, false)
      this.swiperTop.slideTo(index, 300, false)
    },
    // 规格选择
    selectSku (o, list) {
      this.$emit('selectSku', o, list)
    },
    // 收藏
    collect () { this.$emit('collect') },
    // 跳转到商品详情
    goToProDetail (item) {
      let data = {
        productId: item.productId,
        skuId: item.skuId,
        shopId: item.shopId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
      this.$emit('reloadDetail')
    },
    setNumber () {
      this.$emit('setNumber', this.productNumber)
    },
    // 领取优惠券
    async getThisCoupon (item, index) {
      if (item.state !== 3) {
        return
      }
      let params = {}
      if (index === 1) { // 领取平台优惠券
        params.couponId = item.couponId
      }
      if (index === 2) { // 领取店铺优惠券
        params.shopCouponId = item.shopCouponId
      }
      const response = await tabkeTheCoupon(params)
      const res = response.data
      if (res.code === '200') {
        this.$message.success('领取成功')
        item.state = 0
      } else {
        this.$message(res.message)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.detailPage{
  max-width: 1250px;
  margin: auto;
  .top{
    margin-bottom: 30px;
    padding: 40px 45px;
    background-color: #FFF;
    display: flex;
    .swiper-box {
      width: 580px;
      position: relative;
      margin-right: 50px;
      .swiper-slide {
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      }
      .gallery-top {
        height: 100%!important;
        width: 440px;
        position: absolute;
        right: 0;
      }
      .swiperThumbsLeft {
        width: 120px;
        position: absolute;
        left: 0;
        top: 10%;
        box-sizing: border-box;
        padding: 10px 0;
        height: 80%;
        .thumbsBox {
          width: 100%;
          height: 100%;
          position: relative;
          .swiper-button-prev,
          .swiper-button-next {
            // width: 32px;
            // height: 32px;
            // line-height: 32px;
            font-size: 30px;
            position: absolute;
            left: 45px;
            text-align: center;
            // background: #999999;
            color: $mainGlod;
            &::after{
              content: ''; // 去除框架自带icon图标
            }
          }
          .swiper-button-prev {
            position: absolute;
            top: -30px;
          }
          .swiper-button-next {
            position: absolute;
            top: initial;
            bottom: -50px;
          }
        }
      }
      .gallery-thumbs {
        position: relative;
        width: 100%;
        height: 100%;
      }
      .gallery-thumbs .swiper-slide {
        width: 100%;
        opacity: 0.7;
      }
      .gallery-thumbs .swiper-slide-active {
        opacity: 1;
        border: 1px solid $mainGlod;
        box-sizing: border-box;
      }
    }
    .proInfo{
      flex: 1;
      font-family: Microsoft YaHei;
      .proName{
        margin-bottom: 15px;
        font-size: 30px;
        font-weight: bold;
        color: #333333;
      }
      .proBrief{
        max-width: 530px;
        color: #CCC;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      .proPrice{
        height: 32px;
        margin: 15px 0;
        display: flex;
        align-items: flex-end;
        .price{
          margin-right: 10px;
          font-size: 25px;
          font-weight: bold;
          color: #C83732;
        }
        .orginPrice{
          font-size: 18px;
          color: #CCCCCC;
          text-decoration: line-through;
        }
        .favoritesBtn{
          flex: 1;
          display: flex;
          justify-content: flex-end;
          align-items: center;
          cursor: pointer;
          span{
            line-height: 36px;
            margin-left: 5px;
          }
        }
      }
      .disCoupon{
        padding: 15px 0;
        margin: 15px 0;
        border-width: 2px 0;
        border-style: solid;
        border-color: #F3F4F5;
        font-size: 12px;
        .proDiscount {
          padding: 10px 0 16px;
          max-height: 112px;
          overflow-y: auto;
          box-sizing: border-box;
          .discountInfo {
            span:nth-child(1) {
              font-size: 16px;
              color: #999999;
            }
            span:nth-child(2) {
              font-size: 14px;
              color: $mainGlod;
              border: 1px solid $mainGlod;
              padding: 0 2px;
              border-radius: 4px;
            }
            span:nth-child(3) {
              font-size: 14px;
              color: #666666;
            }
          }
          .activityLabel {
            padding-left: 20px;
            margin-bottom: 20px;
            span:nth-child(1) {
              font-size: 14px;
              color: $mainGlod;
              border: 1px solid $mainGlod;
              padding: 1px 8px;
              border-radius: 2px;
            }
            span:nth-child(2) {
              font-size: 14px;
              color: #666666;
            }
            span:nth-child(3) {
              font-size: 14px;
              color: $mainGlod;
              text-decoration: underline;
              cursor: pointer;
            }
          }
          .activityLabel:last-child{
            margin-bottom: 0;
          }
        }
        .proRules{
          margin-left: 8px;
          .rule{
            display: flex;
            .container{
              padding: 5px 9px;
              margin: 8px 0;
              color: #C83732;
              border: 1px solid #C83732;
            }
          }
        }
      }
      .sku{
        min-height: 50px;
        ul {
          li {
            p {
              font-size: 14px;
              font-family: Microsoft YaHei;
              &:nth-child(2) {
                span {
                  display: inline-block;
                  height: 40px;
                  line-height: 40px;
                  text-align: center;
                  padding: 0 9px;
                  margin: 10px 8px;
                  font-size: 14px;
                  color: #666666;
                  border: 1px solid #E4E5E6;
                  cursor: pointer;
                }
                .selected-item {
                  color: $mainGlod;
                  border-color: transparent;
                  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                }
              }
            }
          }
        }
      }
      .sum{
        font-size: 14px;
        .proNumberList{
          margin: 10px 0 0 8px;
          >>>.el-input-number{
            span{
              background-color: #FFF;
            }
          }
          span{
            margin-left: 15px;
            b{
              color: #C83732;
            }
          }
        }
      }
    }
  }
  .bottom{
    display: flex;
    .favorite{
      width: 200px;
      margin-right: 20px;
      .title{
        width: 200px;
        height: 50px;
        line-height: 50px;
        text-align: center;
        color: $mainGlod;
        background: #333333;
        cursor: default;
      }
      .favoriteList{
        display: flex;
        flex-direction: column;
        .likeProItem{
          width: 100%;
          margin-top: 20px;
          background-color: #FFF;
          padding-bottom: 8px;
          cursor: pointer;
          .itemImgBox{
            img{
              width: 100%;
            }
          }
          .text{
            text-align: center;
          }
        }
      }
    }
    .infos{
      flex: 1;
      .detailCont{
        max-width: 928px;
      }
      >>>.el-tabs{
        .el-tabs__header{
          margin: 0;
          border: none;
          .el-tabs__nav{
            border: none;
            .el-tabs__item{
              width: 200px;
              height: 50px;
              margin-right: 3px;
              padding: 0;
              line-height: 50px;
              text-align: center;
              font-size: 14px;
              color: #FFF;
              background-color: #333;
              border: none;
            }
            .is-active{
              background-color: $mainGlod;
            }
          }
        }
        .el-tab-pane{
          background-color: #FFF;
          padding: 20px 52px;
        }
      }
    }
  }
}
</style>
