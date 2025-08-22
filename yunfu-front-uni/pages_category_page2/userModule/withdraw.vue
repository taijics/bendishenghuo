<template>
	<view class="container flex-center flex-column">
		<view class="addressBack-box">
			<view class="consignee-box bor-line-F7F7F7">
				<input type="number" v-model="balance" @input="applycheck" class="fs28" placeholder-class="consignee" placeholder="提现金额(元)" />
			</view>
			<view @click="bankTagClick" class="bankTag-box bor-line-F7F7F7 flex-row-plus flex-sp-between flex-items">
				<view class="fs28 addressTag">银行卡</view>
				<view>
					<label>{{cardNum}}</label>
					<image class="arrow mar-left-20" :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"></image>
				</view>
			</view>
			<view class="apply-box">
				<view class="apply-withdraw" @click="applyWithdraw">申请提现</view>
			</view>
		</view>
		<view class="withdraw-history">
			<view class="history-list">
        <view class="history-head">
          <label class="history-label fs30 font-color-333">历史记录</label>
        </view>
				<view class="history-content" v-for="(item, index) in withdrawHistoryList" :key="index">
					<view class="withdraw-detail flex-items flex-sp-between">
						<view class="detail-top">
              <view class="detail-bottom">
                <label class="status fs28 font-color-333" v-if="item.state==0">审核中</label>
                <label class="status fs28 font-color-333" v-else-if="item.state==1">通过</label>
                <label class="status fs28 font-color-333" v-else-if="item.state==2">拒绝</label>
              </view>
              <view>
                <label class="cardnum fs24 font-color-999">银行卡号：{{item.bankCard}}</label>
              </view>
						</view>
            <view>
              <label class="apply-balance">{{item.withdrawalMoney}}</label>
            </view>
					</view>
				</view>
			</view>
		</view>
		<!-- 弹窗 -->
		<u-select v-model="bankTagShowFlag" mode="single-column" title="银行卡" :list="bankcardselectList" @confirm="bankcardConfirm"></u-select>
		<!-- <u-select v-model="bankTagShowFlag" :default-value="choosedValueList" mode="single-column" :list="list"
		 @confirm="bankcardConfirm" title="银行卡" value-name="id" label-name="cardNum"></u-select> -->
	</view>
</template>

<script setup>
import { ref, onMounted, nextTick, computed } from "vue";
import { request } from "@/utils/request";
import API from "@/config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const balance = ref("");
const cardNum = ref("");
const bankcardId = ref(0);
const bankName = ref("");
const bankTagShowFlag = ref(false);
const choosedValueList = ref([0]);
const bankcardList = ref([]);
const withdrawHistoryList = ref([]);
const bankcardselectList = ref([{ value: "", label: "" }]);
const price = ref(0);

onMounted(() => {
	initBankcardList()
	getBalance()
})

const getBalance = async () => {
	try {
		const res = await request(API.GetDistributor,{},"GET")
		price.value = res.data.price
		withdrawHistoryList.value = res.data.withdrawals
	} catch (err) {
	}
}

const initBankcardList = async () => {
	bankcardselectList.value = []
	try {
		const res = await request(API.QueryBankcardList, {
			page: 1,
			pageSize:100
		}, 'GET')
		bankcardList.value = res.data
		for(let i=0;i<bankcardList.value.total;i++){
			bankcardselectList.value.push({value:bankcardList.value.list[i].bankName,label:bankcardList.value.list[i].bankCard})
		}
	} catch (err) {
	}
}

const applycheck = async (e) => {
	//正则表达试
	e.target.value = (e.target.value.match(/^\d*(\.?\d{0,2})/g)[0]) || null
	//重新赋值给input
	await nextTick()
	balance.value = e.target.value
}

const applyWithdraw = async () => {
	if (balance.value === '') {
		uni.showToast({
			title: "提现金额不能为空",
			duration: 2000,
			icon: 'none'
		})
		return
	}else if (balance.value > price.value ) {
		uni.showToast({
			title: "余额不足，请重新输入申请金额",
			duration: 2000,
			icon: 'none'
		})
		return
	} else if (parseFloat(balance.value) > 1000000) {
		uni.showToast({
			title: "提现金额不能超过1000000",
			duration: 2000,
			icon: 'none'
		})
		return
	} else if(bankName.value == "" || bankName.value == null) {
		uni.showToast({
			title: '请选择银行卡',
			duration: 2000,
			icon: 'none'
		})
		return
	} else {
		try {
			const res = await request(API.MemberAccountWithdraw, {
				bankName: bankName.value,
				bankCard: cardNum.value,
				withdrawalMoney: balance.value
			}, 'POST')
			uni.showToast({
				title: '申请成功',
				duration: 2000,
				icon: 'none'
			})
			balance.value = ''
			getBalance()
			initBankcardList()
		} catch (err) {
			if (res.data && res.data.code == 40001) {
				uni.navigateTo({
					url: 'login'
				})
			} else if (res.data) {
				uni.showToast({
					title: res.data.msg,
					duration: 2000,
					icon: 'none'
				})
			}
		}
	}
}

const bankTagClick = () => {
	if(bankcardList.value.total > 0){
		bankTagShowFlag.value = true
	}else{
		uni.showToast({
			title: '你还没有添加银行卡～',
			duration: 2000,
			icon: 'none'
		})
		setTimeout(function(){
			uni.navigateTo({
				url:'addBankcard?withdraw=1'
			})
		},3000)
	}

}

const bankcardConfirm = (e) => {
	cardNum.value = e[0].label
	bankName.value = e[0].value
}

const parsedMoney = computed(() => parseFloat(money.value / 100).toFixed(2));
const parsedStatus = computed(() => {
	if (status.value === 0) {
		return '审核中';
	} else if (status.value === 1) {
		return '已通过';
	} else {
		return '已拒绝';
	}
})
</script>

<style lang="scss">
	page {
		background-color: #F8F8F8;
	}
	.container {
    padding: 20rpx;
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

			.apply-withdraw {
				width: 100%;
				height: 100upx;
				line-height: 100upx;
				color: #FFEBC4;
				text-align: center;
				background: #333333;
				margin: 0 auto;
				margin-top: 20rpx;
			}

			.bankTag-box {
				margin-top: 19px;
				padding-bottom: 19px;

				.addressTag {
					color: #999999
				}
				.arrow {
					width: 16upx;
					height: 24upx;
				}
			}
		}

		.withdraw-history {
			margin-top: 14rpx;
			.history-list {
				background: white;
        padding: 30rpx;
        .history-label {
          height: 92rpx;
          line-height: 92rpx;
        }
				.history-content {
          border-top: 2rpx solid #F3F4F5;
          .withdraw-detail {
            height: 150rpx;
            .apply-balance {
              width: 160rpx;
              height: 58rpx;
              line-height: 58rpx;
              font-size: 24rpx;
              background: #EEEEEE;
              display: block;
              text-align: center;
              color: #999999;
            }
          }
				}
			}
		}
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
