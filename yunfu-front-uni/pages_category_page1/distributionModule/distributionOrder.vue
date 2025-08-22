<template>
	<view>
    <view class="u-skeleton">
      <Skeleton
          el-color="#efefef"
          bg-color="#fff"
          :loading="loading && isFirstComeIn"
          :animation="true"
      />
			<view  class="flex-center clientList-box" v-for="(item, index) in FindMySalesDatalist" :key="index">
				<view class="directAward-box font-color-656 fs26">
					<view class="directAward-icon flex-row-plus flex-items flex-sp-between" @click="arrowTypeChange(index)">
						<view class="flex-column-plus font-color-333 fs30">
							<label class="orderId-box u-skeleton-rect">订单号：{{item.orderId}}</label>
							<view class="orderId-box commission mar-top-20">
                <view class="u-skeleton-rect commission">
                  佣金：<label class="font-color-C5AA7B">¥{{item.commission}}</label>
                </view>
							</view>
						</view>
            <view class="u-skeleton-rect arrow-box">
             <image v-if="item.ifOpen == false" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`"></image>
              <image v-if="item.ifOpen == true" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`"></image>
            </view>
					</view>
					<view class="upBox" v-if="item.ifOpen == true">
						<view class="flex-row-plus flex-items mar-top-30 flex-sp-between">
							<label class="orderId-box font-color-999 fs26 u-skeleton-rect">商品数：{{item.products}}</label>
							<label class="orderId-box font-color-999 fs26 u-skeleton-rect">实付金额：¥{{item.price}}</label>
						</view>
						<view class="flex-row-plus flex-items mar-top-30 flex-sp-between">
							<label class="orderId-box font-color-999 fs26 u-skeleton-rect">下单人：{{item.customerName}}</label>
							<label class="commission-box mar-left-70 font-color-999 fs26 u-skeleton-rect">状态：<text class="state" :class="{current: item.state==0}">{{item.state===0?'未结算':'已结算'}}</text></label>
						</view>
					</view>
				</view>
			</view>
		</view>
		<view v-if="ifEmpty" class="emptyCart-box flex-items-plus flex-column">
			<image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/collectEmpty.png`"></image>
			<label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
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
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import { ref } from "vue";
import { request } from '../../utils/request'
import API from "../../config/api";
import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "../../components/Skeleton/index.vue";

const shopId = ref(0);
const distributorId = ref(0);
const page = ref(1);
const pageSize = ref(20);
const FindMySalesData = ref([]);
const FindMySalesDatalist = ref([{}, {}, {}, {}, {}, {}, {}, {}, {}]);
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const noMore = ref(false); // 没有更多数据显示隐藏
const isFirstComeIn = ref(true);
const total = ref(0); // 订单总数据
const ifEmpty = ref(false); // 是否为空

onLoad((options) => {
  shopId.value = options.shopId
  distributorId.value = options.distributorId
  getSalesOrderPage()
})

onReachBottom(() => {
  if(noMore.value){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getSalesOrderPage()
  }
})
/**
 * 获取分销订单列表数据
 * @returns {Promise<void>}
 */
const getSalesOrderPage = async () => {
  loading.value = true
  try {
    const res = await request(API.FindMySalesPage, {
      shopId: shopId.value,
      distributorId: distributorId.value,
      page: page.value,
      pageSize: pageSize.value,
    }, 'GET')
    uni.hideLoading()
    FindMySalesDatalist.value = FindMySalesDatalist.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{}')
    FindMySalesData.value = res.data
    if (FindMySalesDatalist.value.length >= total.value) {
      noMore.value = true
    }
    if (FindMySalesDatalist.value.length === 0) {
      ifEmpty.value = true
    }
  } catch (err) {
    uni.hideLoading()
  } finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}
/**
 * 是否展开收起
 * @param arrowTypeId
 */
const arrowTypeChange = (arrowTypeId) => {
  FindMySalesDatalist.value[arrowTypeId].ifOpen = FindMySalesDatalist.value[arrowTypeId].ifOpen == true ? false : true
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss">
page {
  background: #F8F8F8;
}
	.emptyCart-box{
		margin-top: 70upx;
    .emptyCart-img{
         margin-top: 30%;
         width: 198rpx;
         height: 183rpx;
    }
	}
	.directAward-box {
		width: 95%;
		display: flex;
		justify-content: flex-start;
		flex-direction: column;
		background-color: #FFFFFF;
		padding: 40upx 20upx;
		margin-top: 30upx;
		.orderId-box {
			width: 350upx;
		}
    .commission {
      display: inline-block;
      min-width: 150rpx;
    }
		.commission-box {
			width: 340upx;
		}
    .state {
      color: #16BB89;
    }
    .current {
      color: #C83732 !important;
    }
    .arrow-box {
      min-width: 24rpx;
      min-height: 24rpx;
    }
		.arrow-down {
			width: 24upx;
			height: 24upx;
		}

		.upBox {
			border-top: 1upx solid #EDEDED;
			margin-top: 30upx;
		}
	}
</style>
