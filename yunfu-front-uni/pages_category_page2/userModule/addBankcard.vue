<template>
	<view class="container flex-center flex-column">
		<view class="addressBack-box">
			<view class="consignee-box bor-line-F7F7F7">
				<input v-model="username" class="fs28" placeholder-class="consignee" placeholder="姓名" />
			</view>
			<view class="iphoneNum-box bor-line-F7F7F7">
				<input type="number" v-model="phone" class="fs28" placeholder-class="iphoneNum" placeholder="手机号码" />
			</view>
			<view class="consignee-box bor-line-F7F7F7">
				<input v-model="bankName" class="fs28" placeholder-class="consignee" placeholder="银行名称" />
			</view>
			<view class="cardnum">
				<input type="number" class="fs28" v-model="cardNum" placeholder-class="detailAddress" placeholder="卡号" />
			</view>
		</view>
		<view class="deleteBankcard-box" v-if="type == 2">
      <label class="font-color-C5AA7B" @click="delBankcard">删除银行卡</label>
<!--      <submit-button text="删除银行卡" @submitEvent="delBankcard"></submit-button>-->
		</view>
		<view class="saveAddress-box">
      <submit-button v-if="type == 1" position="bottom" text="添加银行卡" @submitEvent="saveBankcardClick"></submit-button>
      <submit-button v-else position="bottom" text="保存" @submitEvent="saveBankcardClick"></submit-button>
		</view>
	</view>
</template>

<script setup>
   import { onLoad } from "@dcloudio/uni-app";
   import { request } from "@/utils/request";
   import API from "@/config/api";
   import { ref } from "vue";
   import { btnUseLoading } from '../../hooks/bntUseLoading'

   const { btnShowLoading } = btnUseLoading()
   const show=ref(false)
   const type=ref(1) // 1.添加银行卡 2.编辑银行卡
   const cardNum=ref('')
   const bankCode=ref('')
   const bankName=ref('')
   const bankTagList=ref([])
   const username=ref('')
   const phone=ref('')
   const id=ref('')
   const withdraw=ref('')
   const choosedValueList=ref([0])
   const bankcardId = ref('')
   onLoad(options=> {
     if (options.type) {
       type.value = options.type
     }
     if (options.withdraw) {
       withdraw.value = options.withdraw
     }
     // initBankList()
     if (type.value == 2) {
       bankcardId.value = uni.getStorageSync('bankcardId')
       renderBankcard(bankcardId.value)
       uni.removeStorageSync('bankcardId')
     }
   })

   function renderBankcard(bankcardId) {
     request(API.GetByIdBankcard ,{bankId:bankcardId},"GET").then(res => {
       const bankCard = res.data
       id.value = bankcardId
       username.value = bankCard.name
       phone.value = bankCard.phone
       bankName.value = bankCard.bankName
       bankCode.value = bankCard.bankCode
       cardNum.value = bankCard.bankCard
       bankTagList.value.forEach((item, index) => {
         if (bankCod.value == item.value) {
           choosedValueList.value = [index]
         }
       })
     }).catch(res => {

     })
   }

   function initBankList(){
     request(API.QueryBankList).then(res => {
       bankTagList.value = res.data.map((item) => {
         return {
           'value': item.bankCode,
           'label': item.bankName
         }
       })
     }).catch(res => {

     })
   }

   //新增或更新银行卡
   function saveBankcardClick() {
     bankTagList.value.forEach((item, index) => {
       if (item.label == bankName.value) {
         bankCode.value = item.value
       }
     })
     let phoneCodeVerification = /^[1][3-9][0-9]{9}$/;
     const method = type.value == 1 ? 'POST' : 'PUT';
     if (username.value == '') {
       uni.showToast({
         title: '请输入姓名！',
         duration: 2000,
         icon: 'none'
       });
     } else if (phone.value == '') {
       uni.showToast({
         title: '请输入手机号！',
         duration: 2000,
         icon: 'none'
       });
     } else if (!phoneCodeVerification.test(phone.value)) {
       uni.showToast({
         title: '请输入正确的手机号！',
         duration: 2000,
         icon: 'none'
       });
     } else if (bankName.value == '') {
       uni.showToast({
         title: '请填写银行名称！',
         duration: 2000,
         icon: 'none'
       });
     }else if (cardNum.value == '') {
       uni.showToast({
         title: '请输入卡号！',
         duration: 2000,
         icon: 'none'
       });
     }else if (cardNum.value.length != 16 && cardNum.value.length != 19 ) {
       uni.showToast({
         title: '请输入正确的卡号！',
         duration: 2000,
         icon: 'none'
       });
     }else {
       btnShowLoading()
       if(type.value == 1){
         request(API.SaveBankcard, {
           name: username.value,
           phone: phone.value,
           bankName: bankName.value,
           bankCard: cardNum.value
         }, 'POST').then(res => {
           if (res.code === "200") {
             uni.showToast({
               title: '添加成功',
               duration: 2000,
               icon: 'none'
             });
             if (withdraw.value == 1) {
               setTimeout(function(){
                 uni.navigateTo({
                   url: 'withdraw'
                 })
               },2000)
             } else {
               setTimeout(function(){
                 uni.navigateTo({
                   url: 'bankcard'
                 })
               },2000)
             }
           } else {
             uni.showToast({
               title: res.data.message,
               duration: 2000,
               icon: 'none'
             });
           }
         }).catch(res => {
           uni.showToast({
             title: res.data.message,
             duration: 2000,
             icon: 'none'
           });
         })
       }else{
         request(API.UpdateBankcard, {
           bankId:id.value,
           name: username.value,
           phone: phone.value,
           bankName: bankName.value,
           bankCard: cardNum.value
         }, 'POST').then(res => {
           if (res.code === "200") {
             uni.navigateTo({
               url: 'bankcard'
             })
           } else {
             uni.showToast({
               title: res.msg,
               duration: 2000,
               icon: 'none'
             });
           }
         }).catch(res => {
           uni.showToast({
             title: '操作失败',
             duration: 2000,
             icon: 'none'
           });
         })
       }
     }
   }

   //删除银行卡
   function delBankcard() {
     uni.showModal({
       title: '温馨提示',
       content: '确认删除该银行卡？',
       confirmText: '确定',
       cancelText: '取消',
       success: (res) => {
         if (res.confirm) {
           subm()
         } else if (res.cancel) {

         }
       }
     })
   }
   function subm() {
     btnShowLoading()
     request(API.DelMemberBankcard, {
       bankId: bankcardId.value
     }, 'POST').then(res => {
       uni.navigateTo({
         url: 'bankcard'
       })
     }).catch(res => {
     })
   }

</script>

<style lang="scss">
	page {
		background-color: #F7F7F7;
	}

	.container {
		.addressBack-box {
			background-color: #FFFFFF;
			padding: 30upx 30upx;

			.consignee-box {
				padding-bottom: 36upx;
				width: 690upx;
				margin-top: 20upx;

				.consignee {
					color: #999999;
					font-size: 28upx;
				}
			}

			.iphoneNum-box {
				padding-bottom: 36upx;
				width: 690upx;
				margin-top: 36upx;

				.iphoneNum {
					color: #999999;
					font-size: 28upx;
				}
			}

			.location-box {
				padding-bottom: 36upx;
				width: 690upx;
				margin-top: 36upx;

				.location {
					color: #999999;
					font-size: 28upx;
				}
			}

			.bankTag-box {
				margin-top: 19px;
				padding-bottom: 19px;

				.addressTag {
					color: #999999
				}
			}

			.cardnum {
				margin-top: 19px;
			}

			.detailAddress-box {
				padding-bottom: 36upx;
				width: 690upx;
				margin-top: 36upx;

				.detailAddress {
					color: #999999;
					font-size: 28upx;
				}
			}
		}

		.addressTagBack-box {
			background-color: #FFFFFF;
			padding: 30upx 30upx;
			margin-top: 20upx;

			.addressTag-box {
				padding-bottom: 36upx;
				width: 690upx;

				.addressTag {
					color: #999999;
					font-size: 28upx;
				}
			}

			.defaultState-box {
				padding-bottom: 10upx;
				width: 690upx;
				margin-top: 36upx;
				.defaultState {
					color: #999999;
					font-size: 28upx;
				}
			}
		}

		.arrow {
			width: 24upx;
			height: 24upx;
		}

		.saveAddress-box {
			position: fixed;
			bottom: 50upx;
			left: 30upx;

			.saveAddress {
				width: 690upx;
				height: 100upx;
				color: #FFEBC4;
				text-align: center;
				line-height: 100upx;
				background: #333333;
			}
		}
	}

	.deleteBankcard-box {
		background-color: #FFFFFF;
		padding: 30upx 30upx;
		margin-top: 20upx;
		text-align: center;
	}

	.content {
		font-size: 35rpx;
		width: 500rpx;

		.btn {
			margin-bottom: 20rpx;
			width: 200rpx;
			background-image: linear-gradient(135deg, #FFA100 10%, #FF7911 100%);
		}
	}
</style>
