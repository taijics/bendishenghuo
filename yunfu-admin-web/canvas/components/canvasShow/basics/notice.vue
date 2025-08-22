<template>
  <div
    class="notice-list"
    :class="'terminal' + terminal"
    :style="{ backgroundColor: componentContent.bgColor }"
  >
    <Swiper :modules="modules" :autoplay="autoplay">
      <SwiperSlide v-for="(item, index) in noticesList" :key="index">
        <div
          class="a-link"
          :style="{ color: componentContent.titColor }"
          @click="jumpNoticeDetail(item)"
        >
          <span>{{ item.noticeTitle }}</span>
        </div>
      </SwiperSlide>
    </Swiper>
  </div>
</template>

<script setup>
import api from '../config/api'
import { Autoplay } from 'swiper';
import { Swiper, SwiperSlide } from 'swiper/vue';
import 'swiper/swiper.css';
import { ref, toRefs, onMounted } from 'vue';
import funMixin from '../config/mixin/funMixin.js'
const { jumpNoticeDetail, sendReq, beforeGetData, afterGetData } = funMixin()
const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    }
  }
})
const { terminal, componentContent } = toRefs(props)

const noticesList = ref([])
const isEdit = localStorage.getItem('isEdit')
const autoplay = {
  delay: isEdit === 'true' ? 9999999 : 3000,
  disableOnInteraction: false
}
const modules = [Autoplay];

onMounted(() => {
  getData()
})

function getData () {
  beforeGetData()
  const _url = `${api.getNotices}`
  const params = {
    method: 'GET',
    url: _url,
  }
  sendReq(
    params,
    (res) => {
      afterGetData()
      noticesList.value = res.data
    },
    () => {
      afterGetData()
    }
  )
}
</script>

<style lang="scss" scoped>
.notice-list {
  height: 60px;
  line-height: 60px;
  padding: 0 20px;
  .a-link {
    display: block;
    cursor: pointer;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    text-align: center;
    span {
      display: inline-block;
      padding-left: 50px;
      font-size: 24px;
      background: url('../static/images/notice/ico_notice2.png') no-repeat left
        center;
    }
  }
  &.terminal4 {
    height: 50px;
    line-height: 50px;
    padding: 0;
    .swiper-container {
      height: 100%;
      width: 1200px;
      max-width: 100%;
      margin: 0 auto;
    }
    .a-link {
      display: block;
      cursor: pointer;
      text-align: left;
      span {
        display: block;
        padding-left: 25px;
        font-size: 14px;
        background: url('../static/images/notice/ico_notice.png') no-repeat left
          center;
      }
    }
  }
}
</style>
