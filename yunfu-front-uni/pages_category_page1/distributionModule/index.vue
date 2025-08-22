<template>
  <view class="container flex-center flex-column">
    <view
        class="inStoreBackImg flex-items-plus"
    >
      <label>选择进入的店铺</label>
    </view>
    <view class="u-skeleton">
      <Skeleton
          el-color="#efefef"
          bg-color="#F8F8F8"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></Skeleton>
      <view
          class="flex-items-plus flex-column"
          v-for="(item,index) in StoreListData"
          :key="index"
          @click="getStore(item)"
      >
        <view class="store-box flex-items-plus flex-sp-between mar-top-30 bor-line-E5E5E5 pad-bot-30">
          <view class="flex-items-plus">
            <image
                class="storeLogoImg u-skeleton-rect"
                :src="item.shopLogo"
            ></image>
            <view class="font-color-656 fs24 mar-left-20">
              <view class="fs30 font-color-333 u-skeleton-rect shop-name">{{ item.shopName }}</view>
              <view class="flex-row-plus mar-top-20">
                <label class="u-skeleton-rect">等级：{{ item.levelName }} </label>
              </view>
              <view class="mar-top-10"><label class="u-skeleton-rect">关系：{{ item.state == 1 ? '有效' : '被清退' }}</label></view>
            </view>
          </view>
          <view class="income">
            <view class="font-color-333 fs30"><text class="u-skeleton-rect">总收益</text></view>
            <view class="font-color-C5AA7B fs30 price-text"><text class="u-skeleton-rect">{{ item.price }}元</text></view>
          </view>
        </view>
      </view>
    </view>
    <view
        v-if="ifEmpty"
        class="emptyCart-box flex-items-plus flex-column"
    >
      <image
          class="emptyCart-img"
          :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
      ></image>
      <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
    </view>
  </view>
</template>

<script setup>
import { ref } from "vue";
import { request } from '../../utils/request'
import API from "../../config/api";
import { onLoad } from "@dcloudio/uni-app";
import Skeleton from "@/components/Skeleton/index.vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const loading = ref(false);
const isFirstComeIn = ref(true);
const currentId = ref('')
const StoreListData = ref([{}, {}, {}, {}, {}, {}, {}, {}, {}])
const StoreListQuery = ref({
  id: ''
})
const page = ref(1)
const pageSize = ref(20)
const loadingType = ref(0)
const ifEmpty = ref(false)

onLoad(() => {
  getStoreList()
})

const back = () => {
  uni.switchTab({
    url: '../../pages/tabbar/user/index'
  });
}
/**
 * 获取店铺列表数据
 * @returns {Promise<void>}
 */
const getStoreList = async () => {
  loading.value = true
  try {
    const res = await request(API.FindSaleStoreList, {
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    // uni.hideLoading()
    if (res.data.list.length == 0) {
      loadingType.value = 1
      page.value = page.value
    }
    StoreListData.value = StoreListData.value.concat(res.data.list)
    StoreListData.value = StoreListData.value.filter(item => JSON.stringify(item) !== '{}')
    if (StoreListData.value.length === 0) {
      ifEmpty.value = true
    }
  } catch (err) {
    // uni.hideLoading()
  } finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}
/**
 * 跳转店铺详情
 * @param item
 */
const getStore = (item) => {
  uni.navigateTo({
    url: 'salesIndex?distributeInfo=' + JSON.stringify(item)
  });
}
</script>

<style lang="scss">
page {
  background: #F8F8F8;
}

.emptyCart-box {
  margin-top: 70upx;

  .emptyCart-img {
    width: 113upx;
    height: 98upx;
  }
}

.container {
  .inStoreBackImg {
    width: 100%;
    height: 100upx;
    background: #333333;
    color: #FFFFFF;
    position: relative;
    z-index: 999;
  }

  .store-box {
    width: 690upx;
    background: #FFFFFF;
    padding: 22rpx;
    .shop-name {
      min-width: 160rpx;
      min-height: 44rpx;
    }
    .storeLogoImg {
      width: 140upx;
      height: 140upx;
      margin-right: 10rpx;
    }

    .income {
      width: 200rpx;
      text-align: center;
      border-left: 2rpx solid #F3F4F5;
      .price-text {
        margin-top: 10rpx;
        text {
          min-width: 70rpx;
          display: inline-block;
        }
      }
    }
  }
}
</style>
