<template>
	<view class="container">
<!--		<global-loading />-->
		<!-- 店铺首页 -->
		<view class="content" v-if="id">
			<view class="shop-top" :style="{'padding-top': topHeight + 'px'}">
				<image :src="`${VUE_APP_STATIC_URL}static/images/back_img04.png`" class="back" @click="back"></image>
				<view class="search-btn" @click="searchPro">
					<image class="search-icon" :src="`${VUE_APP_STATIC_URL}static/img/searchImg.png`" mode="widthFix">
					</image>
					<text class="fs24 font-color-999 mar-left-10">请输入您想要的宝贝</text>
				</view>
			</view>
			<view class="stopInfo">
				<view class="shop-top-content">
					<view class="contentLeft">
						<image :src="storeInfo.shopLogo" class="photo-img"></image>
						<view class="shop-info-top">
							<view class="shop-name">
								<text class="shop-name">{{storeInfo.shopName}}</text>
								<text class="shop-num">粉丝数：{{fansNumber}}</text>
							</view>
							<!-- #ifdef MP-WEIXIN -->
							<view v-if="hasService" class="btns flex-column-plus mar-left-10" @click="flyToService">
								<image class="store-icon"
									:src="`${VUE_APP_STATIC_URL}static/images/service-product-detail.png`"></image>
								<text>客服</text>
							</view>
							<!-- #endif -->
						</view>
					</view>
					<view class="contentRight">
						<view class="favorites-box cur-poi" @click="collectToggle">
							<image v-if="ifCollect === 0" class="store-icon"
								:src="`${VUE_APP_STATIC_URL}static/images/iconShoucang.png`">
							</image>
							<image v-else class="store-icon"
								:src="`${VUE_APP_STATIC_URL}static/images/shoucangActive.png`"></image>
							<text class="text">{{ifCollect === 0? '收藏' : '取消'}}</text>
						</view>
					</view>
				</view>
				<view class="distributorBox flex-items flex-sp-between" @click="applyForRecruit">
					<view class="distributor">
						<view class="flex-display flex-items">
							<image class="item-btn-icon" :src="`${VUE_APP_STATIC_URL}static/img/user/fenxiao2.png`"
								mode="widthFix"></image>
							<view>成为分销员</view>
						</view>
					</view>
					<view class="rightArrow">
						<image :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"></image>
					</view>
				</view>
			</view>
			<view class="shopContent">
				<view class="tabs-nav-warp">
					<scroll-view class="tabs-nav" scroll-x="true">
						<view class="ul">
							<view class="li" :class="{'on':activeTab==='index'}" @click="tabChange('index')">首页</view>
							<view class="li" :class="{'on':activeTab==='all'}" @click="tabChange('all')">全部</view>
							<view class="li" v-for="(item,index) in classList" :key="index"
								:class="{'on':activeTab===item.classifyId}" @click="tabChange(item.classifyId)">
								{{item.classifyName}}
							</view>
						</view>
					</scroll-view>
				</view>
				<view v-if="activeTab=== 'index'">
					<CanvasPage ref="canvasRef" :componentsData="componentsData" :terminal="terminal" :typeId="3" :shopId="id">
					</CanvasPage>
				</view>
				<view v-else>
					<view class="shop-banner-box" v-if="bannerInfo && bannerInfo.length > 0">
						<swiper indicator-dots="true">
							<swiper-item v-for="(item, index) in bannerInfo" :key="index" @click="applyForRecruit()">
								<image :src="item.bannerImage" class="shop-banner-img"></image>
							</swiper-item>
						</swiper>
					</view>
					<view class="shop-list-content">
						<!--					<view class="shop-list-nav">-->
						<!--						<view class="nav-item padd-l" :class="{'active' : navIndex == 0}" @click="navIndexTap(0)">-->
						<!--							<text class="nav-title">全部商品</text>-->
						<!--							<text class="line"></text>-->
						<!--						</view>-->
						<!--						<view class="nav-item padd-r" :class="{'active' : navIndex == 1}" @click="navIndexTap(1)">-->
						<!--							<text class="nav-title">分类查看</text>-->
						<!--							<text class="line"></text>-->
						<!--						</view>-->
						<!--					</view>-->
						<block v-if='isShowGoods'>
							<view class="navBox">
								<view class="shop-list-nav">
									<view class="nav-item-sort" @click="sortTap(1)">
										<text class="nav-title" :class="{'active' : sortIndex == 1}">新品</text>
									</view>
									<view class="nav-item-sort" @click="sortTap(2)">
										<text class="nav-title" :class="{'active' : sortIndex == 2}">价格</text>
										<view class="r">
											<image :src="`${VUE_APP_STATIC_URL}static/images/arrowSortUp.png`"
												v-if="type == 1" class="arrow-img padd-t"></image>
											<image :src="`${VUE_APP_STATIC_URL}static/images/arrowSortDown.png`"
												v-if="type == 2" class="arrow-img padd-b"></image>
										</view>
									</view>
									<view class="nav-item-sort" @click="sortTap(3)">
										<text class="nav-title" :class="{'active' : sortIndex == 3}">销量</text>
										<view class="r">
											<image :src="`${VUE_APP_STATIC_URL}static/images/arrowSortUp.png`"
												v-if="volume == 1" class="arrow-img padd-t"></image>
											<image :src="`${VUE_APP_STATIC_URL}static/images/arrowSortDown.png`"
												v-if="volume == 2" class="arrow-img padd-b"></image>
										</view>
									</view>
								</view>
							</view>
							<view class="shop-list-box">
								<view class="item" v-for="(cItem, index) in storeInfolist" :key="index"
									@click="goodsItemTap(cItem.productId,cItem.skuId)">
									<image :src="cItem.image" class="product-img default-img"></image>
									<view class="product-bottom-box">
										<view class="product-name">{{cItem.productName}}</view>
										<view class="product-num font-color-C5AA7B mar-top-10">已售{{cItem.number}}件
										</view>
										<view class="product-price-box">
											<image v-if="cItem.activityType===1" class="iconImg"
												:src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`"
												alt="拼团icon"></image>
											<image v-if="cItem.activityType === 2" class="iconImg"
												:src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`" alt="秒杀活动">
											</image>
											<image v-if="cItem.activityType === 3" class="iconImg discountIcon"
                             :src="`${VUE_APP_STATIC_URL}static/images/discountTagIcon.png`"
                             alt="限时折扣活动"></image>
											<image v-if="cItem.activityType === 4" class="iconImg"
												:src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`" alt="平台秒杀">
											</image>
											<image v-if="cItem.activityType===5" class="iconImg"
												:src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`"
												alt="平台折扣"></image>
											<image v-if="cItem.activityType===9" class="iconImg"
												:src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`"
												alt="会员价"></image>
											<image v-if="cItem.activityType === 8" class="iconImg"
                             :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"
                             alt="场景营销"></image>
											<text
												class="price-box fs40 font-color-C83732 mar-right-20">￥{{cItem.price}}</text>
											<text class="price-through">￥{{cItem.originalPrice}}</text>
										</view>
									</view>
								</view>
                <slide-loading />
							</view>
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
							<view class='empty-container' v-if="isEmpty">
								<image :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
								<text>暂无商品</text>
							</view>
						</block>
					</view>
				</view>
			</view>
		</view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
	import { request } from "@/utils/request";
	import API from "@/config/api";
	import api from '@/components/canvasShow/config/api'
	import CanvasPage from '@/components/canvasShow/canvasShowPage.vue'
  import { ref } from "vue";
  import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
  import {VUE_APP_STATIC_URL} from "@/config/api";

  const componentsData = ref([])
  const navIndex = ref(0)
  const id = ref('')
  const price = ref(0)
  const storeInfo = ref({})
  const classList = ref([])
  const dataList =  ref([])
  const isShowGoods = ref(true)
  const sortIndex = ref(0)
  const list = ref([])
  const bannerInfo = ref([])
  const total = ref(0)
  const ifNew = ref(0)
  const type = ref(1)
  const volume = ref(1)
  const page = ref(1)
  const pageSize = ref(20)
  const classifyId = ref('')
  const loadingType = ref(0)
  const storeInfolist = ref([])
  const isIphone = ref(false)
  const activeTab = ref('index')
  const terminal = API.terminal
  const collectId = ref(0)
  const ifCollect = ref(0)
  const salesId = ref(0)
  const fansNumber = ref('')
  const topHeight = ref(10)
  const hasService = ref(false)
  const isLoading = ref(false)
  const corpId = ref('')
  const serviceURL = ref('')
  const isEmpty = ref(false) // 是否没有商品数据
  const noMore = ref(false) // 是否没有更多数据
  const topLeft = ref(0) // 页面滚动距离
  const returnTopFlag = ref(false); // 返回顶部显示隐藏

  onLoad(options=>{
    // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
    let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
    topHeight.value = menuButtonInfo.top
    // #endif
    // #ifdef APP
    topHeight.value = 50
    // #endif
    isIphone.value = getApp().globalData.isIphone;
    if (getApp().globalData.shopShareItem) {
      const item = getApp().globalData.shopShareItem
      id.value = parseInt(item.storeId)
      salesId.value = parseInt(item.salesId)
      getApp().globalData.shopShareItem = undefined
    } else {
      id.value = parseInt(options.storeId)
      salesId.value = parseInt(options.salesId)
    }
    bindSalesCustomer(salesId.value, id)
    canvasGet()
    getTemplate()
    getFindProductGroupList()
    getShopBanner()
    getShopInfo()
    addBusinessBuyerUser();
    // #ifdef MP-WEIXIN
    getServiceUrl(id.value)
    // #endif
  })
  const canvasRef = ref()
  onReachBottom(()=> {
    if (noMore.value) {
      uni.stopPullDownRefresh()
    } else {
      if(activeTab.value === 'index'){
        canvasRef.value.loadMore()
      }else{
        page.value = page.value + 1
        getTemplate()
      }
    }
  })

  onPageScroll(e => {
    returnTopFlag.value = e.scrollTop > 600;
    topLeft.value = e.scrollTop
  })

  // 读取画布
  function canvasGet() {
    let apiUrl = api.getCanvas + '?terminal=' + terminal + '&type=' + 3
    if (id) {
      apiUrl += '&shopId=' + id.value
    }
    let params = {
      url: apiUrl,
      method: 'GET'
    }
    request(apiUrl, {}, 'GET').then(res => {
      if (JSON.stringify(res.data) !== '{}') {
        componentsData.value = JSON.parse(res.data.json)
      }
    }).catch(res => {
      throw Error(res)
    })
  }

  function getShopBanner() {
    request(API.GetShopBanner, {
      shopId: id.value
    }, 'GET').then(res => {
      bannerInfo.value = res.data
    }).catch(res => {
      throw Error(res)
    })
  }

  function getTemplate() {
    let data = {
      shopId: id.value,
      ifNew: ifNew.value,
      type: type.value,
      volume: volume.value,
      page: page.value,
      pageSize: pageSize.value,
      groupId: classifyId.value
    }
    request(API.GetStore, data, 'GET').then(res => {
      uni.hideLoading()
      if (res.data.page.list.length == 0) {
        loadingType.value = 1
      }
      storeInfo.value = res.data;
      total.value = res.data.page.total
      storeInfolist.value = storeInfolist.value.concat(res.data.page.list)
      if (total.value == 0) {
        isEmpty.value = true
      }
      if (storeInfolist.value.length >= total.value) {
        noMore.value = true
      }
    }).catch(res => {
      uni.hideLoading()
      uni.showToast({
        title: res.data.message,
        duration: 2000,
        icon: 'none'
      });
      throw Error(res)
    })
  }

  // 查询店铺分组数据
  function getFindProductGroupList() {
    request(API.GetStoreShopClassify, {
      shopId: id.value
    }, 'GET').then(res => {
      classList.value = res.data.filter(item => JSON.stringify(item) !== "{}")
    }).catch(res => {throw Error(res)})
  }

  function goodsItemTap(productId, skuId) {
    uni.navigateTo({
      url: '../goodsModule/goodsDetails?shopId=' + id.value + '&productId=' + productId + '&skuId=' +
          skuId
    })
  }

  function navIndexTap(index) {
    storeInfolist.value = []
    navIndex.value = index,
        isShowGoods.value = index == 0
    if (index == 0) {
      page.value = 1
      classifyId.value = ''
      getTemplate()
    } else {
      isShowGoods.value = false
    }
  }
  function back() {
    uni.navigateBack()
  }
  function sortTap(index) {
    page.value = 1
    storeInfolist.value = []
    if (index == 1) {
      ifNew.value = ifNew.value != 0 ? 0 : 1,
          type.value = 1,
          volume.value = 1,
          sortIndex.value = index
    } else if (index == 2) {
      ifNew.value = 0,
          type.value = type.value != 1 ? 1 : 2,
          volume.value = 1,
          sortIndex.value = index
    } else if (index == 3) {
      ifNew.value = 0,
          type.value = 1,
          volume.value = volume.value != 1 ? 1 : 2,
          sortIndex.value = index
    }
    getTemplate()
  }

  function classItemTap(classifyId) {
    page.value = 1
    classifyId.value = classifyId
    isShowGoods.value = true
    storeInfolist.value = []
    getTemplate()
  }
  // 栏目切换
  function tabChange(key) {
    isEmpty.value = false
    noMore.value = false
    activeTab.value = key
    if (key !== 'index') {
      page.value = 1
      classifyId.value = key === 'all' ? '' : key
      storeInfolist.value = []
      getTemplate()
    }
  }
  //判断是否已申请成为该店铺的分销员
  function applyForRecruit() {
    const res = uni.getStorageSync('storage_key');
    const token = res.token
    if (token) {
      let item = {}
      if (uni.getStorageSync('storage_key')) {
        item = uni.getStorageSync('storage_key');
      }
      if (JSON.stringify(item) == '{}') {

      } else {
        request(API.HasApply, {
          shopId: id.value
        }, 'GET', false).then(res => {
          if (res.data.distributorId == undefined) {
            uni.navigateTo({
              url: '../distributionModule/recruit?shopId=' + id.value
            })
          } else if (res.data.state === 1) {
            uni.showToast({
              title: "您已申请成为该店铺的分销员",
              icon: "none"
            })
          } else {
            uni.showToast({
              title: "您的申请正在审核中，请稍后查看",
              icon: "none"
            })
          }
        }).catch(res => {throw Error(res)})
      }
    } else {
      uni.showToast({
        title: '请先登录',
        icon: "none"
      })
      uni.navigateTo({
        url: '/pages_category_page2/userModule/login'
      })
    }
  }
  function bindSalesCustomer(salesId, storeId) {
    if (salesId && storeId) {
      //如果已登录，静默绑定客户关系，否则跳转到登录页面
      if (uni.getStorageSync('storage_key')) {
        request(API.BindSalesCustomer, {
          shopId,
          distributorId: salesId
        }, 'POST').then(res => {
          uni.showToast({
            title: "绑定成功",
            icon: "none"
          })
        }).catch(res => {
          uni.showToast({
            title: res.data.msg,
            icon: "none"
          })
          throw Error(res)
        })
      } else {
        uni.setStorageSync('salesId', salesId)
        uni.setStorageSync("shopId", storeId)
        uni.navigateTo({
          url: '../../pages_category_page2/userModule/login'
        })
      }
    }
  }
  // 获取店铺信息
  function getShopInfo() {
    request(API.getShopIndex + `?shopId=${id.value}`, null,
        'GET').then(function(res) {
      ifCollect.value = res.data.ifCollect;
      collectId.value = res.data.collectId;
      fansNumber.value = res.data.fansNumber;
    }).catch(function(res) {
      uni.showToast({
        title: '失败',
        icon: "none"
      });
      throw Error(res)
    });
  }

  //收藏店辅
  function collectToggle() {
    const res = uni.getStorageSync('storage_key');
    const token = res.token
    if (token) {
      if (ifCollect.value == 0) {
        collectShop();
      } else {
        cancelCollectShop();
      }
    } else {
      uni.showToast({
        title: '请先登录',
        icon: "none"
      })
      uni.navigateTo({
        url: '/pages_category_page2/userModule/login'
      })
    }
  }

  //收藏
  function collectShop() {
    request(API.collect, {
          shopId: parseInt(id.value)
        },
        'POST', false).then(function(res) {
      ifCollect.value = 1;
      uni.showToast({
        title: '收藏成功',
        icon: "success"
      });
    }).catch(function(res) {
      uni.showToast({
        title: '失败',
        icon: "none"
      });
      throw Error(res)
    });
  }

  //取消收藏
  function cancelCollectShop() {
    request(API.cancelCollect, {
          ids: [collectId.value]
        },
        'POST').then(function(res) {
      ifCollect.value = 0;
      uni.showToast({
        title: '取消收藏成功',
        icon: "success"
      });
    }).catch(function(res) {
      uni.showToast({
        title: '失败',
        icon: "none"
      });
      throw Error(res)
    });
  }
  function addBusinessBuyerUser() {
    request(API.AddBusinessBuyerUser, {
      shopId: id.value
    }, "POST")
  }
  // 查询产品
  function searchPro(key, type) {
    uni.navigateTo({
      url: `/pages_category_page1/search/index/index`
    })
  }

  // 获取客服url
  function getServiceUrl(id) {
    if (isLoading.value || !id || id === 'null') {
      return
    }
    const shopids = uni.getStorageSync('service_shopids') || []
    const corpIds = uni.getStorageSync('service_corpIds') || []
    const urls = uni.getStorageSync('service_urls') || []

    const index = shopids.indexOf(id)
    if (index === -1) {
      isLoading.value = true
      request(API.CustomerService, {
        id
      }, 'get').then(res => {
        if (res.code === '' && res.data.corpId && res.data.url) {
          shopids.push(id.value)
          corpIds.push(res.data.corpId)
          urls.push(res.data.url)

          uni.setStorageSync('service_shopids', shopids);
          uni.setStorageSync('service_corpIds', corpIds);
          uni.setStorageSync('service_urls', urls);

          corpId.value = res.data.corpId
          serviceURL.value= res.data.url
          if (serviceURL.value) {
            hasService.value = true
          }
        }
        isLoading.value = false
      }).catch(err => {
        console.log(err)
        isLoading.value = false
        throw Error(err)
      })
    } else {
      corpId.value = corpIds[index]
      serviceURL.value = urls[index]
      if (serviceURL.value) {
        hasService.value = true
      }
    }
  }

  // 跳转客服
  function flyToService() {
    if (!serviceURL.value || !corpId.value) {
      hasService.value = false
      return
    }
    const extInfo = { // 客服信息
      url: serviceURL.value // 客服链接
    }
    // #ifdef MP-WEIXIN
    wx.openCustomerServiceChat({
      extInfo,
      corpId: corpId.value // 企业ID
    })
    // #endif
  }
</script>
<style lang="scss" scoped>
	page {
		background: #F8F8F8;
	}
</style>
<style lang='scss' scoped>
	page {
		background: #F8F8F8;
	}

	.shop-top {
		background: #333333;
		display: flex;
		align-items: center;
		width: 100%;
		position: fixed;
		z-index: 99;
		padding-bottom: 20rpx;
	}

	// #ifdef APP-PLUS
	.shop-top {
		padding-top: 80rpx;
	}

	// #endif
	.stopInfo {
		padding: 200rpx 20rpx 20rpx 20rpx;
		background: #F8F8F8;
	}

	// 店铺头部
	.shop-top-content {
		padding: 10rpx 30rpx;
		background: #FFFFFF;
		display: flex;
		align-items: center;

		.contentLeft {
			flex: 9;
			display: flex;

			.photo-img {
				width: 102rpx;
				height: 102rpx;
				border-radius: 10rpx;
				margin-right: 10rpx;
			}

			.shop-info-top {
				border-radius: 20rpx 20rpx 0 0;
				position: relative;
				display: flex;
				align-items: center;

				.shop-name {
					display: flex;
					flex-direction: column;
					justify-content: space-between;
					font-size: 32rpx;
					color: #333333;

					.shop-num {
						font-size: 26rpx;
						color: #333333;
						opacity: 0.7;
						margin-top: 15rpx;
					}
				}

				.btns {
					width: 100rpx;
					height: 95%;
					font-size: 24rpx;
					text-align: center;

					image {
						max-width: 56rpx;
						max-height: 56rpx;
						margin: auto;
					}
				}
			}
		}

		.contentRight {
			flex: 3;

			.favorites-box {
				display: flex;
				width: 160rpx;
				height: 60rpx;
				background: #C83732;
				opacity: 1;
				border-radius: 46rpx;
				align-items: center;
				justify-content: center;

				.store-icon {
					width: 32rpx;
					height: 32rpx;
					margin-right: 8rpx;
				}

				.text {
					font-size: 26rpx;
					color: #fff;
				}
			}
		}
	}

	.rightArrow {
		image {
			width: 18rpx;
			height: 24rpx;
		}
	}

	.distributorBox {
		background: #FFFFFF;
		margin-top: 20rpx;
		height: 80rpx;
		padding: 0 20rpx;
		display: flex;
		justify-items: center;
		color: #333333;
		font-size: 28rpx;
	}

	// 首页内容
	.shopContent {
		width: 100%;
		/* background: #fff; */
		border-radius: 20rpx 20rpx 0 0;

		.tabs-nav-warp {
			padding: 0 20px;

			.tabs-nav {
				margin-top: 20upx;

				.ul {
					white-space: nowrap;

					.li {
						display: inline-block;
						margin-left: 60upx;
						font-size: 28upx;
						color: #999999;
						position: relative;
						padding-bottom: 18upx;

						&:first-child {
							margin-left: 0;
						}

						&.on {
							&:after {
								content: '';
								width: 100%;
								height: 4upx;
								background: #C5AA7B;
								position: absolute;
								left: 0;
								bottom: 0;
							}

							font-weight:bold;
							color: #333333;
						}
					}
				}
			}
		}

		.shop-banner-box {
			background: #f7f7f7;
			padding: 20rpx 30rpx;
			box-sizing: border-box;
		}

		.shop-list-content {
			width: 100%;

			/* background: #fff; */
			.navBox {
				padding: 0 20rpx;

				.shop-list-nav {
					display: flex;
					flex-direction: row;
					align-items: center;
					height: 80rpx;
					line-height: 76rpx;
					background: #fff;
				}
			}

			.shop-list-box {
				width: 100%;
				background: #f7f7f7;
				padding: 16rpx 20rpx 0;
				box-sizing: border-box;
				display: flex;
				flex-wrap: wrap;

				.item {
					width: 49%;
					margin: 12rpx 0;
					background: #d6d6d6;
					border-radius: 10rpx;
					display: flex;
					flex-direction: column;
				}

				.item:nth-of-type(2n) {
					margin-left: 2%;
					margin-right: 0;
				}
			}
		}
	}

	.shop-banner-img {
		width: 100%;
		height: 280rpx;
		border-radius: 20rpx;
	}

	.nav-item {
		flex: 1;
		font-size: 30rpx;
		color: #666;
		display: flex;
		flex-direction: column;
		align-items: center;
		height: 80rpx;
		line-height: 76rpx;
	}

	.nav-item.active {
		color: #ff7911;
	}

	.nav-item .line {
		display: inline-block;
		width: 80rpx;
		height: 4rpx;
		background: #fff;
		border-radius: 2rpx;
	}

	.nav-item.active .line {
		background: linear-gradient(0deg, rgba(255, 162, 0, 1), rgba(255, 121, 17, 1));
	}

	.nav-item.padd-l {
		padding-left: 20%;
		box-sizing: border-box;
	}

	.nav-item.padd-r {
		padding-right: 20%;
		box-sizing: border-box;
	}

	.nav-item-sort {
		flex: 1;
		font-size: 24rpx;
		color: #222;
		display: flex;
		flex-direction: row;
		align-items: center;
		justify-content: center;
		height: 80rpx;
		line-height: 80rpx;

		.r {
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			margin-left: 5rpx;
		}

		.r .arrow-img {
			width: 32rpx;
			height: 32rpx;
			padding: 7rpx;
			box-sizing: border-box;
		}
	}


	.product-img {
		width: 347rpx;
		height: 347rpx;
	}

	.product-bottom-box {
		padding: 20rpx;
		box-sizing: border-box;
		background: #fff;
	}

	.product-name {
		display: block;
		font-size: 28rpx;
		color: #333;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.product-num {
		font-size: 24rpx;
		margin-top: 15rpx;
		border: 2rpx solid #E4E5E6;
		padding: 10rpx;
		display: inline-block;
	}

	.product-price-box {
		width: 100%;
		display: flex;
		flex-direction: row;
		align-items: center;
		margin-top: 30rpx;

		.iconImg {
			width: 58rpx;
			height: 36rpx;
			margin-right: 10rpx;
		}

		.discountIcon {
			width: 100rpx;
		}
	}

	.product-price-box .price-through {
		text-decoration: line-through;
		font-size: 24rpx;
		color: #CCC;
	}

	.shop-sort-list {
		margin-top: 20rpx;
		width: 100%;
		display: flex;
		flex-direction: column;
	}

	.shop-sort-list .item {
		display: flex;
		flex-direction: column;
		background: #fff;
		padding: 0 30rpx 20rpx;
		box-sizing: border-box;
		margin-bottom: 20rpx;
	}

	.shop-sort-list .item .sort-title {
		font-size: 30rpx;
		color: #333;
		padding: 30rpx 0;
	}

	.sort-single-box {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		width: 100%;
	}

	.sort-single-box .single {
		width: 340rpx;
		height: 78rpx;
		margin: 0 5rpx 10rpx 0;
		background: #fff;
		border: 1px solid #E5E5E5;
		border-radius: 4rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		font-size: 26rpx;
		color: #333;
		box-sizing: border-box;
	}

	.sort-single-box .single:nth-of-type(2n) {
		margin-left: 5rpx;
		margin-right: 0;
	}

	.back {
		width: 50rpx;
		height: 50rpx;
		padding: 0 20rpx;
	}

	.empty-container {
		width: 100%;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.empty-container image {
		width: 200rpx;
		height: 200rpx;
		margin-top: 150rpx;
	}

	.empty-container text {
		font-size: 28rpx;
		color: #999;
		margin-top: 30rpx;
		display: block;
		width: 300rpx;
		text-align: center;
	}

	.active {
		color: #ff7911;
	}


	.distributor {
		font-size: 26upx;
		border-radius: 25upx;
		display: flex;
		align-items: center;

		.item-btn-icon {
			width: 40upx;
			height: 40upx;
			margin-right: 10upx;
		}
	}

	.search-btn {
		height: 64rpx;
		border-radius: 4rpx;
		display: flex;
		flex-direction: row;
		align-items: center;
		margin-right: 30rpx;
		width: 428rpx;
		background: rgba(255, 255, 255, 0.1);

		.search-icon {
			width: 44rpx;
			height: 44rpx;
			margin-left: 10rpx;
			margin-top: 8rpx;
		}

		.search-word {
			font-size: 26rpx;
			font-weight: 400;
			color: rgba(153, 153, 153, 1);
			margin-left: 10rpx;
		}
	}

	// #ifdef H5 || APP-PLUS
	.search-btn {
		width: 100%;
	}

	// #endif
	// #ifdef MP-ALIPAY
	.back {
		width: 25rpx;
		height: 25rpx;
		margin-top: 15rpx;
		padding: 10rpx;
		display: none;
	}

	.shop-top {
		margin-top: 0 !important;
	}

	.shop-top-content {
		padding-top: 80rpx;
	}

	.nav-item-sort .r .arrow-img {
		width: 16rpx;
		height: 16rpx;
		padding: 4rpx;
	}

	.tabs-nav {
		margin-top: 20upx;

		.ul {
			.li {
				&:first-child {
					margin-left: 36upx;
				}
			}
		}
	}

	// #endif
</style>
