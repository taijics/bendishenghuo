<template>
	<view class="content">
		<view class="Box">
			<view class="productBox" v-for="(item,index) in productList" :key="index"
				@click="goodsDateils(item.shopId,item.productId,item.skuId)">
				<view class="proImg">
					<image :src="item.image" mode=""></image>
				</view>
				<view class="rightBox">
					<view class="proTitle">
						{{item.productName}}
					</view>
					<view class="price">
						<text class="fs36 font-color-red">
							¥{{item.price}}
						</text>
						<text class="mar-left-10 fs26">
							{{item.users}}人付款
						</text>
					</view>
					<view class="flex-sp-between flex-display mar-top-20" @click.stop="goStore(item.shopId)">
						<view>
							{{item.shopName}}
						</view>
						<view>
							<image class="rightIcon" :src="`${VUE_APP_STATIC_URL}images/arrowRight.png`" mode="aspectFill"></image>
						</view>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
import {request} from "../utils/request";
import API from "../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";
import { ref } from "vue"
import { onLoad, onPullDownRefresh } from "@dcloudio/uni-app";

const list = ref([])
const pageSize = ref(1)
const productList = ref([])

onPullDownRefresh(() => {
  pageSize.value = pageSize.value + 1
  GetremenList()
})

onLoad(() => {
  GetremenList()
})

const GetremenList = () => {
  let timestamp = new Date().getTime()
  request(API.GetremenList, {
    page: pageSize.value,
    pageSize: 5,
    timestamp: timestamp
  }, 'get').then(res => {
    uni.stopPullDownRefresh();
    console.log(res)
    if (res.code == 200) {
      productList.value = res.data.list
    } else {
      uni.showToast({
        title: res.message,
        icon: 'none'
      })
    }
  })
}

// 跳转店铺
const goStore = (shopId) => {
  uni.navigateTo({
    url: './store/index?storeId=' + shopId
  })
}
//商品详情
const goodsDateils = (shopId, productId, skuId) => {
  uni.navigateTo({
    url: './goodsModule/goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' +
        skuId
  })
}
</script>

<style lang="scss" scoped>
	page {
		background-color: #FBE7E0;
	}

	.content {
		.Box {
			padding: 30upx;

			.productBox {
				background-color: #FFFFFF;
				height: 280upx;
				margin-bottom: 20upx;
				border-radius: 20upx;
				padding: 20upx;
				display: flex;
				justify-content: space-between;

				.proImg {
					width: 240upx;
					height: 240upx;

					image {
						width: 100%;
						height: 100%;
						border-radius: 20upx;
					}
				}

				.rightBox {
					width: 60%;

					.proTitle {
						overflow: hidden;
						text-overflow: ellipsis;
						display: -webkit-box;
						-webkit-box-orient: vertical;
						-webkit-line-clamp: 2;
					}

					.biao {
						margin-top: 20upx;

						text {
							margin-right: 10upx;
							border-radius: 5upx;
							color: #C5AA7B;
							padding: 5upx 10upx 5upx;
							background-color: #FBE7E0;
						}
					}

					.price {
						margin-top: 55upx;
					}

					.rightIcon {
						width: 24upx;
						height: 24upx;
					}
				}
			}
		}
	}
</style>
