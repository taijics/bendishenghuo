<template>
	<view class="collection-box">
		<view class="tabsbox">
			<u-tabs :list="collectionTypeList" bar-width="60" :bold="false" active-color="#333333"
				inactive-color="#CCCCCC" :is-scroll="false" :current="collectionTypeFlag"
				@change="collectionTypeActive"></u-tabs>
		</view>
		<view v-if="collectionTypeFlag == 0">
      <u-skeleton
          el-color="#efefef"
          bg-color="#ffffff"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></u-skeleton>
			<view v-if="productCollect.length>0">
				<view class="wid function-box">
					<view class="finishbox" @click="finishClick" v-if="allCheckShow">完成</view>
					<view v-else class="flex-row-plus editicon-box flex-items fs28" @click="editClick">
						<image class="editicon" :src="`${VUE_APP_STATIC_URL}static/images/collectionEditicon.png`">
						</image>
						<text class="mar-left-10">编辑</text>
					</view>
				</view>
				<view class="swipe-box u-skeleton">
					<view class="actionBox" v-for="(item, index) in productCollect" :key="item.collectId"
						:index="index">
						<u-swipe-action :disabled="allCheckShow" :ref="getActionSwipeRefs" :show="item.show" :autoClose="false" @open="productOpen(index)"
							@click="productActionClick" :options="options">
							<!-- :disabled="allCheckShow" -->
							<view class="flex-item" @click.stop="toGoodsDetails(item.productId,item.shopId,item.skuId)">
								<view class="item wid flex-row-plus flex-display">
									<view class="flex-items selctBtn" v-show="allCheckShow">
										<image mode="aspectFill" v-if="item.selected == 1"
											@click.stop="productItemSel(index,0)"
											:src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
											class="cart-select-img"></image>
										<image mode="aspectFill" v-else @click.stop="productItemSel(index,1)"
											:src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
											class="cart-select-img"></image>
									</view>
									<view class="infoCent flex-display">
										<image class="product-img default-img u-skeleton-fillet" mode="aspectFill" :src="item.image" />
										<!-- 此层wrap在此为必写的，否则可能会出现标题定位错误 -->
										<view class="title-wrap mar-left-20 priceBox">
                      <view v-if="isFirstComeIn" class="u-skeleton-rect productName1"></view>
                      <view v-if="isFirstComeIn" class="u-skeleton-rect productName2"></view>
                      <view v-if="isFirstComeIn" class="u-skeleton-rect productName3"></view>
											<text
                          v-if="!isFirstComeIn"
												class="title u-line-2 fs28 font-color-333">{{ item.productName }}</text>
											<view class="flex-items">
												<!-- <image v-if="item.activityType" class="iconImg mar-right-10"
													:src="imgs[item.activityType]"></image> -->
													<image v-if="item.activityType===1" class="iconImg" :src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`" alt="拼团icon"></image>
													<image v-if="item.activityType === 2" class="iconImg"  :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`" alt="秒杀活动"></image>
													<image v-if="item.activityType === 3" class="iconImg discountIcon" :src="`${VUE_APP_STATIC_URL}static/images/discountTagIcon.png`" alt="限时折扣活动"></image>
													<image v-if="item.activityType === 4" class="iconImg" :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`" alt="平台秒杀"></image>
													<image v-if="item.activityType===5" class="iconImg" :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`" alt="平台折扣"></image>
													<image v-if="item.activityType===9" class="iconImg" :src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`" alt="会员价"></image>
													<image v-if="item.activityType === 8" class="iconImg" :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`" alt="场景营销"></image>
                        <view class="u-skeleton-rect price-text">
                          <text class="fs40 font-color-C83732">¥</text>
                          <text class="fs40 font-color-C83732">{{item.price}}</text>
                        </view>
												<text
													class="font-color-CCC discountsPriceLine fs24 u-skeleton-rect">¥{{item.originalPrice}}</text>
											</view>
										</view>
									</view>
								</view>
							</view>
						</u-swipe-action>
					</view>
				</view>
				<view v-if="allCheckShow" class="pad-bot-140"></view>
				<view v-show="allCheckShow" class="allcheck-box flex-row-plus flex-sp-between flex-items">
					<view class="left">
						<image mode="aspectFill" v-if="isAllProCheck"
							:src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`" class="cart-select-img"
							@click="allProductSel(0)"></image>
						<image mode="aspectFill" v-else :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
							class="cart-select-img" @click="allProductSel(1)"></image>
						<text>全选</text>
					</view>
					<view class="right">
						<view class="btn-delete" @click="showCardModalPaoductDel">删除</view>
					</view>
				</view>
				<view v-if="allCheckShow" class="pad-bot-140"></view>
			</view>
			<view v-if="productCollect.length==0&&proCollectShow" class="mar-top-60 empty-box">
				<image class="collect-empty" :src="`${VUE_APP_STATIC_URL}static/images/collectEmpty.png`"></image>
				<view class="tohome-box flex-items-plus">暂无收藏</view>
			</view>
		</view>
		<view v-if="collectionTypeFlag == 1">
      <u-skeleton
          el-color="#efefef"
          bg-color="#f7f7f7"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></u-skeleton>
			<view v-if="storeCollect.length>0">
				<view class="finishbox" @click="finishClick" v-if="allCheckShow">完成</view>
				<view v-else class="flex-row-plus editicon-box flex-items fs28" @click="editClick">
					<image class="editicon" :src="`${VUE_APP_STATIC_URL}static/images/collectionEditicon.png`">
					</image>
					<text class="mar-left-10">编辑</text>
				</view>
				<view class="swipe-box swipeBox u-skeleton">
          <u-skeleton
              el-color="#fff"
              bg-color="#f7f7f7"
              :loading="loading && isFirstComeIn"
              :animation="true"
          ></u-skeleton>
          <view class="actionBox" v-for="(item, index) in storeCollect" :key="item.collectId" :index="index">
            <view class="shopBox">
              <u-swipe-action :ref="getShopActionSwipeRefs" :disabled="allCheckShow" :show="item.show" :options="options" @click="storeActionClick(index)"
                              @open="storeOpen(index)">
                <view class="item wid flex-row-plus flex-display">
                  <view v-show="allCheckShow" class="selctBtn flex-items">
                    <image mode="aspectFill" v-if="item.selected == 1"
                           @click.stop="storeItemSel(index,0)"
                           :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                           class="cart-select-img"></image>
                    <image mode="aspectFill" v-else @click.stop="storeItemSel(index,1)"
                           :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                           class="cart-select-img"></image>
                  </view>
                  <view class="infoCent">
                    <view class="flex-row-plus flex-sp-between flex-items-plus wid">
                      <view class="flex-items-plus flex-row pad-topbot-10">
                        <image class="head-img u-skeleton-fillet" mode="aspectFill" :src="item.shopLogo" />
                        <!-- 此层wrap在此为必写的，否则可能会出现标题定位错误 -->
                        <view class="title-wrap mar-left-20">
                          <text class="title u-line-2 shopName u-skeleton-fillet">{{ item.shopName }}</text>
                          <text class="font-color-CCC fs24 u-skeleton-fillet">{{item.person}}人关注</text>
                        </view>
                      </view>
                      <view class="toStore flex-items-plus fs24 u-skeleton-fillet" @click="toStoreClick(item.shopId)">
                        进入店铺
                        <image :src="`${VUE_APP_STATIC_URL}static/images/arrowR.png`"></image>
                      </view>
                    </view>
                    <view class="shopImgBox" v-if="item?.productList?.length > 0">
                      <view class="itemImgBox" v-for="(sItem, sIndex) in item.productList"
                            :key="sIndex"
                            @click.stop="goodsDateils(sItem.shopId,sItem.productId,sItem.skuId)">
                        <image :src="sItem.image" class="pic-img default-img u-skeleton-fillet"></image>
                      </view>
                    </view>
                  </view>
                </view>
              </u-swipe-action>
            </view>
          </view>
				</view>
				<view v-show="allCheckShow" class="allcheck-box flex-row-plus flex-sp-between flex-items">
					<view class="left">
						<image mode="aspectFill" v-if="isAllStoreCheck"
							:src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`" class="cart-select-img"
							@click="allStoreSel(0)"></image>
						<image mode="aspectFill" v-else :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
							class="cart-select-img" @click="allStoreSel(1)"></image>
						<text>全选</text>
					</view>
					<view class="right">
						<view class="btn-delete" @click="showCardModalshopDel">删除</view>
					</view>
				</view>
				<view v-if="allCheckShow" class="pad-bot-140"></view>
			</view>
			<view v-if="storeCollect.length==0&&storeCollectShow" class="mar-top-60 empty-box">
				<image class="collect-empty" :src="`${VUE_APP_STATIC_URL}static/images/collectEmpty.png`"></image>
				<view class="tohome-box flex-items-plus">暂无收藏</view>
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
		<!-- 删除确认弹窗 -->
		<tui-modal :show="cardModal" :custom="true" :fadein="true">
			<view class="Put-box1">
				<view class="text-align fs34 fs-bold">
					温馨提示
				</view>
				<view v-if="paoductDelSubmit" class="mar-top-40 text-align">
					是否删除该商品？
				</view>
				<view v-if="shopDelSubmit" class="mar-top-40 text-align">
					是否删除该店铺？
				</view>
				<view class="flex-display flex-sp-between">
					<view class="btn submit" v-if="paoductDelSubmit" @click="paoductDel">确定</view>
					<view class="btn submit" v-if="shopDelSubmit" @click="shopDel">确定</view>
				</view>
			</view>
			<view v-if="cardModal" @click="cardModal = false" class="cancelDel">
				<image :src="`${VUE_APP_STATIC_URL}static/images/cancelClose.png`" mode=""></image>
			</view>
		</tui-modal>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import tuiModal from "@/components/modal/modal";
import { request } from "@/utils/request";
import API from "@/config/api";
import { ref } from "vue";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import SlideLoading from "@/components/SlideLoading/index.vue";
import Skeleton from "../../components/Skeleton/index.vue";

// 初始化图片数组
const imgs = ref([
  `${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`,
  `${VUE_APP_STATIC_URL}static/images/spikeIcon.png`,
  `${VUE_APP_STATIC_URL}static/images/discountListIcon.png`,
  `${VUE_APP_STATIC_URL}static/images/spikeIcon.png`,
  `${VUE_APP_STATIC_URL}static/images/discountListIcon.png`,
]);

// 收藏类型列表
const collectionTypeList = ref([{ name: '商品' }, { name: '店铺' }]);

// 选择的收藏类型标记，0 表示商品，1 表示店铺
const collectionTypeFlag = ref(0);
const disabled = ref(false);
const btnWidth = ref(180);
const show = ref(false);
const options = ref([{ text: ' ', style: { backgroundColor: '#F15C48' } }]);

// 页面滚动和加载控制
const topLeft = ref(0); // 滚动距离
const returnTopFlag = ref(false); // 返回顶部标记
const noMore = ref(false); // 是否还有更多数据
const loading = ref(true); // 加载状态
const isFirstComeIn = ref(true); // 是否第一次进入页面

// 选中和全选控制
const isAllProCheck = ref(false);
const isAllStoreCheck = ref(false);
const allCheckShow = ref(false);

// 商品和店铺收藏数据初始化
const createEmptyItems = (count, itemTemplate = {}) => Array.from({ length: count }, () => ({ ...itemTemplate }));
const productCollect = ref(createEmptyItems(8));
const storeCollect = ref(createEmptyItems(7, { productList: createEmptyItems(4) }));

// 分页参数
const productPage = ref(1);
const productPageSize = ref(10);
const proloadingType = ref(0);
const storePage = ref(1);
const storePageSize = ref(10);
const storeloadingType = ref(0);

// 显示控制
const storeCollectShow = ref(false);
const proCollectShow = ref(false);
const cardModal = ref(false);
const paoductDelSubmit = ref(false);
const shopDelSubmit = ref(false);

// 当前操作数据
const ids = ref(null);
const currentIndex = ref(null);
const currentType = ref(null);

// 页面加载时获取商品收藏数据
onLoad(() => {
  getProductCollect();
});

// 到达页面底部时触发分页加载
onReachBottom(() => {
  if (noMore.value) {
    uni.stopPullDownRefresh();
    return;
  }
  if (collectionTypeFlag.value === 0) {
    productPage.value += 1;
    getProductCollect();
  } else if (collectionTypeFlag.value === 1) {
    storePage.value += 1;
    getStoreCollect();
  }
});

// 批量删除商品收藏
function showCardModalPaoductDel() {
  const isShowProoductDelSubmit = productCollect.value.some(value => value.selected === 1);
  if (isShowProoductDelSubmit) {
    cardModal.value = true;
    paoductDelSubmit.value = true;
    shopDelSubmit.value = false;
  } else {
    uni.showToast({
      title: `请先选择要删除的收藏宝贝！`,
      icon: 'none'
    });
  }
}

function paoductDel() {
  if (currentType.value === 1) {
    cancelCollect(ids.value);
    productCollect.value.splice(currentIndex.value, 1);
  } else {
    const ids = productCollect.value.filter(value => value.selected === 1).map(value => value.collectId);
    request(API.deleteCollect, { ids }, 'POST').then(res => {
      productCollect.value = [];
      cardModal.value = false;
      uni.showToast({ title: `删除成功`, icon: 'none' });
      productPage.value = 1;
      getProductCollect();
    }).catch(res => {
      cardModal.value = false;
      uni.showToast({ title: `删除失败`, icon: 'none' });
      throw Error(res);
    });
  }
}

// 批量删除店铺收藏
function showCardModalshopDel() {
  const isShowShopDelSubmit = storeCollect.value.some(value => value.selected === 1);
  if (isShowShopDelSubmit) {
    cardModal.value = true;
    shopDelSubmit.value = true;
    paoductDelSubmit.value = false;
  } else {
    uni.showToast({
      title: `请先选择要删除的收藏店铺`,
      icon: 'none'
    });
  }
}

function shopDel() {
  if (currentType.value === 2) {
    cancelCollect(ids.value);
    storeCollect.value.splice(currentIndex.value, 1);
  } else {
    const ids = storeCollect.value.filter(value => value.selected === 1).map(value => value.collectId);
    request(API.deleteCollect, { ids }, 'POST').then(res => {
      storeCollect.value = [];
      cardModal.value = false;
      uni.showToast({ title: `删除成功`, icon: 'none' });
      storePage.value = 1;
      getStoreCollect();
    }).catch(res => {
      cardModal.value = false;
      uni.showToast({ title: `删除失败`, icon: 'none' });
      throw Error(res);
    });
  }
}

// 跳转到店铺详情页面
function toStoreClick(storeId) {
  uni.navigateTo({
    url: '../../pages_category_page1/store/index?storeId=' + storeId
  });
}

// 跳转到商品详情页面
function toGoodsDetails(productId, shopId, skuId) {
  uni.navigateTo({
    url: '../../pages_category_page1/goodsModule/goodsDetails?productId=' + productId +
        '&shopId=' + shopId + '&skuId=' + skuId
  });
}

// 处理收藏类型切换
function collectionTypeActive(index) {
  isFirstComeIn.value = true;
  productCollect.value = createEmptyItems(8);
  storeCollect.value = createEmptyItems(7, { productList: createEmptyItems(4) });
  collectionTypeFlag.value = index;
  noMore.value = false;
  if (index === 0) {
    productPage.value = 1;
    proloadingType.value = 0;
    getProductCollect();
  } else if (index === 1) {
    storePage.value = 1;
    storeloadingType.value = 0;
    getStoreCollect();
  }
}

// 点击店铺
function storeClick(index, index1) {
  if (index1 === 0) {
    cardModal.value = true;
    shopDelSubmit.value = true;
    ids.value = storeCollect.value[index].collectId;
    currentIndex.value = index;
    currentType.value = 2;
  }
}

// 打开商品操作菜单
function productOpen(index) {
  productCollect.value.forEach((val, idx) => {
    val.show = idx === index;
  });
  ids.value = productCollect.value[index].collectId;
  currentIndex.value = index;
  currentType.value = 1;
}

// 打开删除层
function productActionClick() {
  cardModal.value = true;
  paoductDelSubmit.value = true;
  shopDelSubmit.value = false;
}

// 打开店铺操作菜单
function storeOpen(index) {
  storeCollect.value.forEach((val, idx) => {
    val.show = idx === index;
  });
  ids.value = storeCollect.value[index].collectId;
  currentIndex.value = index;
  currentType.value = 2;
}

// 商品选中操作
function productItemSel(index, number) {
  productCollect.value[index].selected = number;
  isAllProCheck.value = productCollect.value.every(value => value.selected === 1);
}

// 店铺选中操作
function storeItemSel(index, number) {
  storeCollect.value[index].selected = number;
  isAllStoreCheck.value = storeCollect.value.every(value => value.selected === 1);
}

// 全选商品
function allProductSel(type) {
  isAllProCheck.value = !isAllProCheck.value;
  productCollect.value.forEach(value => value.selected = type);
}

// 全选店铺
function allStoreSel(type) {
  isAllStoreCheck.value = !isAllStoreCheck.value;
  storeCollect.value.forEach(value => value.selected = type);
}

// 获取 ActionSwipe 引用
const actionSwipe = ref([]);
const getActionSwipeRefs = (e) => {
  actionSwipe.value.push(e);
}

// 获取 ShopActionSwipe 引用
const shopActionSwipe = ref([]);
const getShopActionSwipeRefs = (e) => {
  shopActionSwipe.value.push(e);
}

// 编辑操作
function editClick() {
  allCheckShow.value = true;
  actionSwipe.value.forEach(item => item.close());
  shopActionSwipe.value.forEach(item => item.close());
}

// 完成编辑
function finishClick() {
  allCheckShow.value = false;
}

// 获取商品收藏数据
function getProductCollect() {
  loading.value = true;
  request(API.getProductCollect, { page: productPage.value, pageSize: productPageSize.value }, 'GET')
      .then(res => {
        if (res.data.list.length === 0) {
          proCollectShow.value = true;
          proloadingType.value = 1;
        } else {
          productCollect.value = productCollect.value
              .concat(res.data.list)
              .filter(item => JSON.stringify(item) !== '{}')
              .map(value => ({ ...value, show: false, selected: 0 }));
        }
        noMore.value = productCollect.value.length >= res.data.total;
        loading.value = false;
        isFirstComeIn.value = false;
      })
      .catch(res => {
        uni.showToast({
          title: '收藏商品查询失败',
          icon: "none"
        });
        throw Error(res);
      });
}

// 获取店铺收藏数据
function getStoreCollect() {
  loading.value = true;
  request(API.getStoreCollect, { page: storePage.value, pageSize: storePageSize.value }, 'GET')
      .then(res => {
        if (res.data.list.length === 0) {
          storeCollectShow.value = true;
          storeloadingType.value = 1;
        }
        storeCollect.value = storeCollect.value
            .concat(res.data.list)
            .filter(item => Array.isArray(item.productList) ? item.productList.length === 4 && item.productList.every(subItem => Object.keys(subItem).length !== 0) : true)
            .map(value => ({ ...value, show: false, selected: 0 }));
        noMore.value = storeCollect.value.length >= res.data.total;
        loading.value = false;
        isFirstComeIn.value = false;
      })
      .catch(res => {
        uni.showToast({
          title: '失败',
          icon: "none"
        });
        throw Error(res);
      });
}

// 取消收藏
function cancelCollect(idss) {
  request(API.cancelCollect, { ids: [idss] }, 'POST').then(res => {
    uni.showToast({ title: '删除成功', icon: "none" });
    cardModal.value = false;
    currentType.value = null;
    currentIndex.value = null;
    ids.value = null;
    productCollect.value = [];
    storeCollect.value = [];
    getStoreCollect();
    getProductCollect();
  }).catch(res => {
    uni.showToast({ title: '失败', icon: "none" });
    throw new Error(res);
  });
}

// 跳转商品详情
function goodsDateils(shopId, productId, skuId) {
  uni.navigateTo({
    url: `/pages_category_page1/goodsModule/goodsDetails?shopId=${shopId}&productId=${productId}&skuId=${skuId}`
  });
}

// 页面滚动处理
onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop;
});
</script>

<style lang="scss" scoped>
	.collection-box {
		.empty-box {
			display: flex;
			justify-content: center;
			flex-direction: column;
			align-items: center;

			.tohome-box {
				color: #999999;
				margin-top: 50rpx;
			}

			.collect-empty {
				margin-top: 30%;
				width: 198rpx;
				height: 183rpx;
			}
		}

		.function-box {
			background-color: #F7F7F7;
		}

		.tabsbox {
			margin-top: 4rpx;
			background-color: #FFFFFF;
      position: relative;
      z-index: 999;
		}

		.editicon-box {
			display: flex;
			justify-content: flex-end;
			position: relative;
			left: -30rpx;
			padding: 16rpx 0;
		}

		.finishbox {
			display: flex;
			justify-content: flex-end;
			position: relative;
			left: -30rpx;
			padding: 16rpx 0;
		}

		.editicon {
			width: 50rpx;
			height: 50rpx;
		}

		.swipe-box {
			padding: 10rpx 20rpx;
			.actionBox {
				margin-bottom: 20rpx;
        background: #ffffff;
			}

			.item {
				display: flex;

				.infoCent {
					padding: 20rpx;
          .price-text {
            min-width: 100rpx;
            height: 50rpx;
            //margin-top: 10rpx;
            margin-right: 10rpx;
          }
          .discountsPriceLine {
            min-width: 60rpx;
            height: 40rpx;
            line-height: 40rpx;
          }
				}

				.selctBtn {
					background: #F7F7F7;
				}
			}

			.shopImgBox {
				display: flex;
				justify-content: flex-end;
				margin-left: 90rpx;
				padding-bottom: 20rpx;
				margin-top: 20rpx;

				.itemImgBox {
					margin-right: 15rpx;
					margin-left: 5rpx;

					image {
						width: 120rpx;
						height: 120rpx;
						border: 2rpx solid #F3F4F5;
					}
				}
			}

			.product-img {
				width: 220rpx;
				flex: 0 0 220rpx;
				height: 220rpx;
			}

			.head-img {
				width: 80rpx;
				flex: 0 0 80rpx;
				height: 80rpx;
				border-radius: 50%;
			}

			.title {
				text-align: left;
				font-size: 28rpx;
				color: $u-content-color;
				height: 165rpx;
				padding-right: 20rpx;
			}

			.shopName {
				height: auto;
				overflow: hidden;
				white-space: nowrap;
				text-overflow: ellipsis;
				max-width: 340rpx;
        min-width: 100rpx;
        min-height: 40rpx;
        margin-bottom: 10rpx;
			}

			.cart-select-img {
				width: 40upx;
				height: 40upx;
				margin: 0upx 30upx 0upx;
				box-sizing: border-box;
			}

			.toStore {
				width: 100px;
				color: #FFEBC4;
				padding: 0rpx 20rpx;
				height: 52rpx;
				background: #333333;
				margin-right: 15rpx;

				image {
					width: 10rpx;
					height: 18rpx;
					margin-left: 10rpx;
				}
			}

			.shopBox {
				margin-bottom: 20rpx;
        min-height: 280rpx;
			}
		}

		.allcheck-box {
			background-color: #FFFFFF;
			width: 100%;
			position: fixed;
			bottom: 0upx;

			.left {
				display: flex;
				flex-direction: row;
				align-items: center;
				font-size: 28upx;
				color: #666;

				.cart-select-img {
					width: 40upx;
					height: 40upx;
					margin: 30upx;
					box-sizing: border-box;
				}
			}

			.right {
				display: flex;
				flex-direction: row;
				align-items: center;
				box-sizing: border-box;
			}

			.btn-delete {
				width: 232upx;
				height: 104upx;
				line-height: 104upx;
				text-align: center;
				font-size: 28upx;
				color: #FFFFFF;
				background: #C83732;
			}
		}

		.Put-box1 {
			.btn {
				text-align: center;
				margin-top: 40rpx;
				border: 1px solid #333333;
				height: 80upx;
				line-height: 80upx;
				width: 100%;
				color: #333333;
			}

			.submit {
				background-color: #333333;
				color: #FFEBC4;
			}
		}

		.cancelDel {
			position: absolute;
			bottom: -50px;
			left: 45%;

			image {
				width: 60upx;
				height: 60upx;
			}
		}
	}

	.priceBox {
    .productName1 {
      width: 420rpx;
      height: 30rpx;
      margin-bottom: 10rpx;
    }
    .productName2 {
      width: 420rpx;
      height: 30rpx;
      margin-bottom: 10rpx;
    }
    .productName3 {
      width: 200rpx;
      height: 30rpx;
      margin-bottom: 50rpx;
    }
		.iconImg {
			width: 58rpx;
			height: 36rpx;
			margin-right: 10rpx;
		}
		.discountIcon{
			width: 100rpx;
		}
	}
</style>
<style lang="scss" scoped>
@import '../../style/images';
	.tabsbox ::v-deep #u-tab-item-0 {
		position: relative;
	}

	.tabsbox ::v-deep .u-tab-bar {
		background-color: #c5aa7b !important;
	}

	.tabsbox ::v-deep #u-tab-item-0::before {
		content: '';
		width: 2rpx;
		height: 30rpx;
		display: block;
		background: #CCCCCC;
		position: absolute;
		right: 0;
		top: 20rpx;
	}

	.swipe-box ::v-deep .u-swipe-del {
		align-items: center;
		justify-content: center;
		width: 160rpx !important;
	}
  .swipe-box ::v-deep .u-swipe-action {
    background: none !important;
  }

	.swipe-box ::v-deep .u-btn-text {
		width: 60rpx;
		height: 60rpx;
		display: block;
		background: $delIcon no-repeat center center;
		background-size: contain;
	}
</style>
<style>
	page {
		background-color: #F7F7F7;
	}
</style>
