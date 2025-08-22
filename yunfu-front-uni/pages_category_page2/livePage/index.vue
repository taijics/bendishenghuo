<template>
	<view class="live-list-page">
		<view class="live-list">
			<LiveBox class="live-item"
				v-for="item in roomList"
				:key="item.roomid"
				:liveData="item"
			/>
		</view>
    <view v-if="ifShow" class="emptyCart-box">
      <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/collectEmpty.png`"></image>
      <label class="text font-color-999 fs26 mar-top-30">暂无直播~</label>
    </view>
	</view>
</template>

<script setup>
// const NET = require('@/utils/request')
// const API = require('@/config/api')
import {ref} from "vue";
import {request} from "../../utils/request";
import API from "../../config/api";
import LiveBox from './components/liveBox.vue'
import {onLoad, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const page = ref({
  page: 1,
  pageSize: 10
})
const isLoading = ref(false)
const roomList = ref([])
const ifShow = ref(false)

onLoad(() => {
  getLiveRooms()
})

onReachBottom(() => {
  page.value.page ++
  getLiveRooms()
})

/**
 * 获取直播间列表
 */
const getLiveRooms = async () => {
  if (isLoading.value) { return }
  isLoading.value = true
  try {
    const res = await request(API.LiveRoomes, page.value, 'get')
    if (page.value.page === 1) { // 第一次查询
      roomList.value = res.data.list
      if (roomList.value.length === 0) {
        ifShow.value = true
      }
    } else {
      // 下拉继续查询
      roomList.value = roomList.value.concat(res.data.list)
    }
    isLoading.value = false
  } catch (err) {
    console.log(err)
    isLoading.value = false
  }
}

// export default {
// 	components: {
// 		LiveBox
// 	},
// 	data() {
// 		return {
// 			page: {
// 				page: 1,
// 				pageSize: 10,
// 			},
// 			isLoading: false,
// 			roomList: [],
//       ifShow: false
// 		}
// 	},
// 	onLoad() {
// 		this.getLiveRooms()
// 	},
// 	onReachBottom() {
// 		this.page.page ++
// 		this.getLiveRooms()
//   },
// 	methods: {
// 		// 获取直播间列表
// 		getLiveRooms () {
// 			if (this.isLoading) { return }
// 			this.isLoading = true
// 			NET.request(API.LiveRoomes, this.page, 'get').then(res => {
// 				if (this.page.page === 1) { // 第一次查询
// 					this.roomList = res.data.list
//           if (this.roomList.length === 0) {
//             this.ifShow = true
//           }
// 				} else { // 下拉继续查询
// 					this.roomList = this.roomList.concat(res.data.list)
// 				}
// 				this.isLoading = false
// 			}).catch(err => {
// 				console.log(err)
// 				this.isLoading = false
// 			})
// 		},
// 	}
// }
</script>

<style lang="scss" scoped>
.live-list-page{
	.live-list{
		width: 100%;
		display: flex;
		flex-wrap: wrap;
		.live-item{
			width: 48%;
			height: 460rpx;
			margin: 1%;
			border-radius: 8rpx;
      overflow: hidden;
		}
	}
  .emptyCart-box{
		position: absolute;
		top: 0;
		bottom: 0;
		left: 0;
		right: 0;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
    .emptyCart-img{
      width: 198upx;
      height: 183upx;
    }
  }
}
</style>
