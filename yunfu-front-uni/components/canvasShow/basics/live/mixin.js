import {request} from "@/utils/request"
import API from '@/config/api';
import {
  ref,
  onMounted
} from 'vue';
import { funMixin } from '../../config/mixin'

export default function () {
  const { jumpLive } = funMixin()
  const appid = ref('wx2b03c6e691cd7370')
  const roomId = ref([]) // 填写具体的房间号
  const roomList = ref([])
  const page = ref({
    page: 1,
    pageSize: 6,
  })

  onMounted(() => {
    getLiveRooms()
  })

  // 获取直播间列表
  function getLiveRooms () {
    request(API.LiveRoomes, page.value, 'get').then(res => {
      console.log(res)
      roomList.value = res.data.list
    })
  }
  function toLiveRoom (item) {
    roomId.value.push(item.roomid)
    if (!appid.value || !roomId.value.length) { return }
    // 路由参数
    let customParams = encodeURIComponent(JSON.stringify({ path: 'livePage/index', pid: 1 }))
    // let customParams
    // 开发者在直播间页面路径上携带自定义参数（如示例中的path和pid参数），后续可以在分享卡片链接和跳转至商详页时获取，详见【获取自定义参数】、【直播间到商详页面携带参数】章节（上限600个字符，超过部分会被截断）
    // #ifdef MP-WEIXIN
    wx.navigateTo({
      url: `plugin-private://${appid.value}/pages/live-player-plugin?room_id=${roomId.value}&custom_params=${customParams}`
    })
    // #endif
  }

  return {
    appid,
    roomId,
    roomList,
    toLiveRoom,
    jumpLive
  }
}


