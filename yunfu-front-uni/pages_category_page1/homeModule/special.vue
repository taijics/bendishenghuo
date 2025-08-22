<template>
	<view>
    <global-loading />

    <!-- 专题 -->
		<swiper class="banner" indicator-dots indicator-color="#FFFFFF" indicator-active-color="#FF7911" autoplay>
			<swiper-item class="banner-item" v-for="(item,index) in bannerList">
				<image :src="item" mode="widthFix" class="bannerImg"></image>
			</swiper-item>
		</swiper>
		<view>
			<!-- {{goodsList.productVOList}} -->
		</view>
		<view v-if="goodsList.productVOList.length>0">
			<view v-for="(item, index) in goodsList.productVOList" :key="item.id" class="goodsDetails-box flex-display flex-column mar-left-30"
			 @click="goodsDateils(item.id)">
				<view class="goodsDetails flex-items-plus flex-row mar-top-30">
					<image class="goodsImg" :src="item.imgs[0]"></image>
					<view class="mar-left-30">
						<view class="goodsName-box overflowNoDot">
							<label class="goodsName fs26 mar-left-20">{{item.productName}}</label>
						</view>
						<view class="priceBuyNum-box mar-top-20">
							<label class="fs24 font-color-C5AA7B">¥</label>
							<label class="fs36 font-color-C5AA7B mar-left-10">{{item.price}}</label>
							<label class="fs24 font-color-999 mar-left-10" v-if="item.buyCount != null">{{item.buyCount}}人付款</label>
							<label class="fs24 font-color-999 mar-left-10" v-else>0人付款</label>
						</view>
						<view class="flex-display flex-sp-between flex-row mar-top-10 flex-items">
							<label class="fs22 font-color-999">{{item.storeDTO.storeName}}</label>
							<image class="arrowImg" :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"></image>
						</view>
					</view>
				</view>
			</view>
		</view>

		<!-- 为空 -->
		<view v-else class="emptyOrder-box flex-items-plus flex-column">
			<image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
			<label class="font-color-999 fs26 mar-top-30">专题商品为空哦～</label>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue';
import { request } from "@/utils/request";
import API from "@/config/api";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const key = ref('');
const bannerList = ref([]);
const goodsList = ref({
  productVOList: []
});
const subject = ref({});
const current = ref(1);
const size = ref(10);

onLoad((options) => {
  key.value = options.key
  getSubjectDetailByKeyList();
})

const getSubjectDetailByKeyList = () => {
  request(API.SubjectWithProduct + key.value, {
    current: current.value,
    map: {},
    model: {},
    order: 'descending',
    size: size.value,
    sort: 'id'

  }, 'POST').then(res => {
    uni.hideLoading()
    bannerList.value.push(res.data.subject.banner)
    goodsList.value = res.data.productPageVO
    subject.value = res.data.subject
    uni.setNavigationBarTitle({
      title: res.data.subject.title
    })
  }).catch(res => {
    uni.hideLoading()
  })
}

const goodsDateils = (id) => {
  uni.navigateTo({
    url:`../goodsModule/goodsDetails?id=${id}`
  })

}
</script>

<style lang="scss">
	page {
		background-color: #FBE7E0;
	}

	.bannerImg {
		height: 300upx;
		width: 100%;
	}

	.choiceness {
		height: 60upx;
		width: 300upx;
	}

	.goodsDetails-box {
		width: 690upx;
		background: #fff;
		margin-top: 10upx;
		border-radius: 10upx;
		padding: 0 20upx;
		box-sizing: border-box;

		.goodsDetails {
			padding-bottom: 30upx;

			.goodsName-box {
				width: 389upx;
				height: 85upx;

				.img618-cion {
					width: 70upx;
					height: 36upx;
				}
			}

			.goodsImg {
				width: 260upx;
				height: 260upx;
			}

			.discounts-box {
				margin-left: -10upx;
				margin-top: 20upx;

				.discounts-text {
					margin-left: 10upx;
					color: #C5AA7B;
					background-color: #FFE4CC;
					padding: 6upx 12upx;
					border-radius: 4upx;
				}
			}

			.arrowImg {
				width: 20upx;
				height: 20upx;
			}
		}
	}
  .emptyOrder-box {
    .emptyOrder-img {
      width: 113rpx;
      height: 98rpx;
    }
  }
</style>
