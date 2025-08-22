<template>
	<view class="container u-skeleton">
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    ></Skeleton>
    <!-- 商品列表 -->
		<view>
			<view v-for="(item, index) in list" :key="index" class="goodsDetails-box flex-display flex-column mar-left-30" @click="goodsDateils(item.shopId,item.productId,item.skuId)">
				<view v-if="item.activityType == 0" class="goodsDetails flex-items-plus flex-row mar-top-30">
					<image class="goodsImg u-skeleton-rect" :src="item.image"></image>
					<view class="mar-left-30">
						<view class="goodsName-box overflowNoDot">
							<label class="goodsName fs26 u-skeleton-rect">{{item.productName}}</label>
						</view>
						<view class="priceBuyNum-box mar-top-20">
							<label class="fs24 font-color-C5AA7B u-skeleton-rect">¥</label>
							<label class="fs36 font-color-C5AA7B mar-left-10 u-skeleton-rect">{{item.price}}</label>
							<label class="fs24 font-color-999 mar-left-10 u-skeleton-rect" v-if="item.users != null">{{item.users}}人付款</label>
							<label class="fs24 font-color-999 mar-left-10 u-skeleton-rect" v-else>0人付款</label>
						</view>
						<view class="flex-display flex-sp-between flex-row mar-top-10 flex-items">
							<label class="fs22 font-color-999 u-skeleton-rect shop-name">{{item.shopName}}</label>
						</view>
					</view>
				</view>
				<view v-else class="spikeList">
				  <view class="listItem">
				    <view class="itemBox u-skeleton-rect">
				      <img :src="item.image">
				    </view>
				    <view class="itemInfo mar-top-30">
              <view v-if="isFirstComeIn" class="u-skeleton-rect skeleton-box" style="width: 100%"></view>
				      <p class="u-skeleton-rect">{{item.productName}}</p>
				      <view class="number u-skeleton-rect" v-if="item.users != null">{{item.users}}人付款 <span v-if="item.total !=0">，限量{{item.total}}件</span></view>
					  <view class="number u-skeleton-rect" v-else>0人付款<span v-if="item.total !=0">，限量{{item.total}}件</span></view>
					  <view class="flex-row-plus flex-item mar-top-30">
							<view class="discountsPriceLine font-color-999 u-skeleton-rect">¥{{item.originalPrice}}</view>
							<view class="mar-left-30 font-color-C5AA7B flex-row-plus">
								<label v-if="item.activityType == 1" class="fs30 u-skeleton-rect">拼团价</label>
								<label v-if="item.activityType == 2" class="fs30 u-skeleton-rect">秒杀价</label>
								<label v-if="item.activityType == 3" class="fs30 u-skeleton-rect">折扣价</label>
                <view class="u-skeleton-rect price-box">
                  <b>￥</b>
                  <label class="fs28">{{item.price}}</label>
                </view>
							</view>
					  </view>
					  <view class="flex-display flex-sp-between flex-row mar-top-10 flex-items">
					  	<label class="fs22 font-color-999 u-skeleton-rect shop-name">{{item.shopName}}</label>
					  </view>
				    </view>
				  </view>
				</view>
			</view>
      <slide-loading />
      <view
          class="reachBottom"
          v-if="noMore && topLeft > 400"
      >
        <image
            class="reach-icon"
            :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
            mode="widthFix"
        ></image>
        <text class="reach-text">这里到底了哦~~</text>
      </view>
      <!-- 搜索为空 -->
      <view v-if="ifEmpty" class="emptyCart-box flex-items-plus flex-column">
        <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
        <label class="font-color-999 fs26 mar-top-30">无可用商品</label>
      </view>
		</view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import { ref } from 'vue'
import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { request } from "../../utils/request";
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "@/components/Skeleton/index.vue";

const loading = ref(false);
const isFirstComeIn = ref(true);
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const noMore = ref(false); // 没有更多数据显示隐藏
const ifEmpty = ref(false)
const page = ref(1)
const pageSize = ref(20)
const activityId = ref(null)
const shopCouponId = ref(null)
const list = ref([{}, {}, {}, {}, {}, {}, {}])
const loadingType = ref(0)
const ifShow = ref(false)

onLoad((option) => {
  if (option.shopCouponId) {
    activityId.value = option.activityId
    shopCouponId.value = option.shopCouponId
  }
  searchList(1)
})

onReachBottom(() => {
  if (noMore.value) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    searchList(0)
  }
})

const searchList = async (type) => {
  loading.value = true
  if(type == 1){
    list.value = [{}, {}, {}, {}, {}, {}, {}]
    page.value = 1
  }
  if(shopCouponId.value){
    try {
      const res = await request(API.getCouponProducts, {
        activityId: activityId.value,
        shopCouponId: shopCouponId.value,
        page: page.value,
        pageSize: pageSize.value
      }, 'GET')
      list.value = list.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{}')
      if (list.value.length === 0) {
        ifEmpty.value = true
      }
      if (list.value.length >= res.data.total) {
        noMore.value = true
      }
    } catch (err) {
    } finally {
      loading.value = false
      isFirstComeIn.value = false
    }
  }
}

/**
 * 商品详情
 */
const goodsDateils = (shopId,productId,skuId) => {
  uni.navigateTo({
    url: 'goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss">
	input{padding-left: 80upx;}
	.container{
		height: 100%;
		.emptyCart-box{
			margin-top: 70upx;
			.emptyCart-img{
				width: 270upx;
				height: 270upx;
			}
		}
		.searchImg{
			width: 36upx;
			height: 36upx;
			position: absolute;
			left: 60upx;
		}
		.search-box{
			background-color: #F7F7F7;
			border-radius: 33upx;
			width: 530upx;
			height: 66upx;
		}
		.searchboxPlace{
			font-size: 26upx;
			color: #A9A9A9;
			padding-right: 30upx;
		}
		.searchClose-icon{
			z-index: 997;
			width: 40upx;
			height: 40upx;
			margin-left: -50upx;
		}
		.promotion618{
			width: 130upx;
			height: 30upx;
		}
		.goodsDetails-box{
			width: 690upx;
			.goodsDetails{
				border-bottom: 1upx solid #EDEDED;
				padding-bottom: 30upx;
				.goodsName-box{
					width: 389upx;
					height: 85upx;
					.img618-cion{
						width:70upx;
						height:36upx;
					}
          .goodsName {
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            min-height: 84rpx;
          }
				}
				.goodsImg{
					width: 260upx;
					height: 260upx;
				}
				.discounts-box{
					margin-left: -10upx;
					margin-top: 20upx;
					.discounts-text{
						margin-left: 10upx;
						color: #C5AA7B;
						background-color: #FFE4CC;
						padding: 6upx 12upx;
						border-radius: 4upx;
					}
				}
				.arrowImg{
					width: 20upx;
					height: 20upx;
				}
			}


		}
		.spikeList {
			.arrowImg{
				width: 20upx;
				height: 20upx;
			}
		  // padding: 108upx 30upx 20upx 30upx;
		  padding-top: 30rpx;
		  border-bottom: 1upx solid #EDEDED;
		  .listItem {
		    display: flex;
		    // padding-bottom: 10upx;
		    border-bottom: 1upx solid #EEEEEE;
		    margin-bottom: 30upx;
		    &:last-child {
		      border-bottom: none;
		    }
		    .itemBox {
		      width: 260upx;
		      height: 260upx;
		      margin-right: 30upx;
		      img {
		        width: 100%;
		        height: 100%;
		      }
		    }
		    .itemInfo {
          .discountsPriceLine {
            min-width: 60rpx;
          }
          .skeleton-box {
            min-height: 40rpx;
          }
          .price-box {
            min-width: 60rpx;
          }
		      flex: 1;
		      p {
		        font-size: 26upx;
		        color: #333333;
		        line-height: 40upx;
		        margin-bottom: 20upx;
		        text-overflow: -o-ellipsis-lastline;
		        overflow: hidden;
		        text-overflow: ellipsis;
		        display: -webkit-box;
		        -webkit-line-clamp: 2;
		        line-clamp: 2;
		        -webkit-box-orient: vertical;
		      }
		      .number {
		        color: #999999;
		        font-size: 26upx;
            display: inline-block;
            min-width: 150rpx;
            min-height: 44rpx;
		      }
          .shop-name {
            min-height: 44rpx;
            min-width: 150rpx;
            display: inline-block;
          }
		    }
		  }
		}
	}
</style>
