<template>
	<view>
    <global-loading />
    <u-mask :show="show" z-index="10000">
			<view class="warp">
				<view class="rect" @tap.stop>
					<!-- 关闭按钮 -->
					<view class="guanbiView">
						<!-- #ifdef MP-WEIXIN -->
						<image @click="showcos" :src="`${VUE_APP_STATIC_URL}static/img/guanbi.png`" class="guanbi"
							style="width:30px;height:30px;" mode="widthFix"></image>
						<!-- #endif -->
						<!-- #ifdef H5 || APP-PLUS -->
						<image @click="showcos" :src="`${VUE_APP_STATIC_URL}static/img/guanbi.png`" class="guanbi"
							style="width:30px;height:30px;" mode="widthFix"></image>
						<!-- #endif -->
					</view>
					<!-- 内容 -->
					<view class="imgBox">
						<view v-if="shareType==1" class="boxInner imgBoxShop"
							:style="{'backgroundImage':'url(' + erweima + ')'}"></view>
						<view v-else class="boxInner imgBoxProduct" :style="{'backgroundImage':'url(' + erweima + ')'}">
						</view>
					</view>
					<!-- 分享 -->
				</view>
			</view>
			<view class="fenx" :style="{'height':(isIphone === true? 140:130)+'rpx'}">
				<view class="shareBox" :class="{'width100':noMp}" hover-class="btn-click" @click="WXfenx">
					<view style="flex: 1;text-align: center;display: flex;">
						<view style="margin-left: 120rpx;" v-if="noMp">
							<image :src="`${VUE_APP_STATIC_URL}static/img/album.png`" mode="widthFix"></image>
						</view>
						<view style="margin-left: 35%;" v-else>
							<image :src="`${VUE_APP_STATIC_URL}static/img/album.png`" mode="widthFix"></image>
						</view>
						<view style="margin-left: 10rpx;font-size: 28rpx;color: #333333">保存到本地</view>
					</view>
				</view>
				<view class="linkBtnBox" hover-class="btn-click" @click="FZlianj" v-if="noMp">
					<view style="flex: 1;text-align: center;display: flex;">
						<view class="linkBox">
							<image :src="`${VUE_APP_STATIC_URL}static/img/lianjie.png`" mode="widthFix"></image>
						</view>
						<view style="margin-left: 10rpx;">
							复制链接
						</view>
					</view>
				</view>
			</view>
		</u-mask>
	</view>
</template>

<script setup>
import { ref } from "vue";
import {onLoad} from "@dcloudio/uni-app";
import { request } from '../../utils/request'
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const size = ref(110); // 二维码大小
const onval = ref(true);
const loadMake = ref(true);
const erweima = ref(''); // 二维码图片地址
const openSettingBtnHidden = ref(true);
const show = ref(true);
const item = ref({});
const listitem = ref({});
const skuId = ref(0); // 商品规格Id
// 活动信息查询参数
const FindSalesPromQuery = ref({
  type: 1,
  tenantCode: ''
});
const shopId = ref(null); // 店铺Id
const salesId = ref(null); // 活动Id
const productId = ref(null); // 商品Id
const noMp = ref(false); // 是否非小程序
const shareType = ref(1);
const isIphone = ref(false);

onLoad((options) => {
  isIphone.value = getApp().globalData.isIphone;
  if (options.productId) {
    productId.value = options.productId
  }
  if (options.skuId) {
    skuId.value = options.skuId
  }
  if (options.shopId) {
    shopId.value = options.shopId
  }
  if (options.salesId) {
    salesId.value = options.salesId
  }
  if (options.shareType) {
    shareType.value = options.shareType
  }
  erweima.value = options.shareImg
  // #ifndef MP
  noMp.value = true
  // #endif
})

const showcos = () => {
  uni.navigateBack({
    delta: 1
  })
}

/**
 * 保存图片到本地
 */
const WXfenx = () => {
  // #ifdef APP-PLUS
  uni.downloadFile({
    url: erweima.value,
    success: (res) => {
      if (res.statusCode === 200) {
        uni.saveImageToPhotosAlbum({
          filePath: res.tempFilePath,
          success: function() {
            uni.hideLoading()
            uni.showToast({
              title: "保存成功",
            });
          },
          fail: function() {
            uni.hideLoading()
            uni.showToast({
              title: "保存失败",
              icon: "none"
            });
          }
        });
      }
    }
  })
  // #endif
  // #ifdef MP-WEIXIN || MP-ALIPAY
  uni.getImageInfo({
    src: erweima.value,
    success: function(image) {
      uni.saveImageToPhotosAlbum({
        filePath: image.path,
        success: function() {
          uni.hideLoading()
          uni.showToast({
            title: '图片保存成功'
          });
        },
        fail: function() {
          uni.hideLoading()
          uni.showModal({
            title: '图片保存失败',
            content: '请确认是否已开启授权',
            confirmText: '开启授权',
            success(res) {
              if (res.confirm) {
                uni.openSetting({
                  success(settingdata) {
                    if (settingdata.authSetting["scope.writePhotosAlbum"]) {
                      uni.showToast({
                        title: '授权成功，请重试哦~',
                        icon: "none"
                      });
                    } else {
                      uni.showToast({
                        title: '请确定已打开保存权限',
                        icon: "none"
                      });
                    }
                  }
                })
              }
            }
          })
        },
      });
    },
    fail(err) {
      console.log(err, 'err报错999')
    }
  });
  // #endif
  // #ifdef H5
  var oA = document.createElement('a');
  oA.download = ''; // 设置下载的文件名，默认是’下载’
  oA.href = erweima.value;
  document.body.appendChild(oA);
  oA.click();
  oA.remove(); // 下载之后把创建的元素删除
  // #endif
}

/**
 * 复制链接
 */
const FZlianj = () => {
  if (productId.value) {
    var link = `${API.shareLink}/#/pages_category_page1/goodsModule/goodsDetails?shopId=${shopId.value}&productId=${productId.value}&skuId=${skuId.value}&salesId=${salesId.value}`
  } else {
    var link = `${API.shareLink}/#/pages_category_page1/store/index?storeId=${shopId.value}&salesId=${salesId.value}`
  }
  // #ifdef MP-WEIXIN || MP-ALIPAY || APP-PLUS
  uni.setClipboardData({
    data: link,
    success: res => {
      uni.showToast({
        title: '复制成功',
        icon: 'none',
        duration: 2000 //时间
      });
    }
  })
  // #endif
  // #ifdef H5
  let result
  let textarea = document.createElement("textarea")
  textarea.value = link
  textarea.readOnly = "readOnly"
  document.body.appendChild(textarea)
  textarea.select() // 选中文本内容
  textarea.setSelectionRange(0, link.length) // 设置选定区的开始和结束点
  uni.showToast({
    title: '复制成功'
  })
  result = document.execCommand("copy") //将当前选中区复制到剪贴板
  textarea.remove()
  // #endif
}
</script>

<style lang="scss" scoped>
	.warp {
		display: flex;
		align-items: center;
		justify-content: center;
		height: 100%;

	}

	.qrimg-i {
		margin-right: 10px;
	}

	.rect {
		background-color: #fff;
		position: relative;
		margin-top: -20rpx;

		.imgBox {

			.boxInner {
				display: inline-block;
				background-size: contain !important;
				background-position: center top !important;
				background-repeat: no-repeat !important;
			}

			.imgBoxShop {
				min-height: 814upx;
				min-width: 426upx;
			}

			.imgBoxProduct {
				min-height: 700upx;
				min-width: 426upx;
			}
		}

		.guanbiView {
			.guanbi {
				width: 50upx;
				height: 40upx;
				position: absolute;
				top: -80rpx;
				left: 50%;
				margin-left: -23rpx;
			}
		}

		//.shareImg {
		//	width: 100%;
		//	height: 720rpx !important;
		//}
	}

	.btn-click {
		background-color: #ececec;
	}

	.fenx {
		position: fixed;
		bottom: 101rpx;
		z-index: 10001;
		background-color: #F7F7F7;
		width: 100%;
		display: flex;
		color: #343434;

		view {
			line-height: 98rpx;
		}

		image {
			width: 50rpx;
			height: 50rpx !important;
			display: inline-block;
			margin-top: 25rpx;
		}
	}

	.shareBox {
		width: 100%;
	}

	.linkBtnBox {
		flex: 1;
		width: 50%;
		text-align: center;
		display: flex;

		.linkBox {
			margin-left: 70rpx;
		}
	}

	.width100 {
		width: 50%;
	}
</style>
