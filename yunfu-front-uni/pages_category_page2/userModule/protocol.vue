<template>
	<view>
		<view id="text">
			<rich-text :nodes="item.dictDescribe"></rich-text>
		</view>
	</view>
</template>
<script setup>
import {ref} from "vue"
import {request} from "../../utils/request"
import API from "../../config/api"
import {onLoad} from "@dcloudio/uni-app";

const type = ref('app_privacy_agreement')
const item = ref({})

onLoad((option) => {
  type.value = option.type
  let title = "《cereshop》商城用户协议"
  if (type.value === 'app_privacy_agreement') {
    title = "《cereshop》商城隐私协议"
  }
  uni.setNavigationBarTitle({
    title: title
  })
  console.log(type.value)
  getquery()
})

const getquery = async () => {
  try {
    const res = await request(API.Query, {
      name: type.value
    }, 'GET')
    item.value = res.data
  } catch (err) {}
}
</script>

<style scoped>
	#text {
		padding: 40rpx;
	}
</style>
