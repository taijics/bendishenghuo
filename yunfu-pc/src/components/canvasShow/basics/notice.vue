<template>
  <div class="notice-list"
    :class="'terminal'+terminal"
    :style="{backgroundColor:componentContent.bgColor}"
  >
    <swiper :options="swiperOption">
      <swiper-slide v-for="(item,index) in noticesList" :key="index">
        <div class="a-link"
          @click="jumpNoticeDetail(item)"
          :style="{color:componentContent.titColor}"
        >
          <span>{{item.noticeTitle}}</span>
        </div>
      </swiper-slide>
    </swiper>
  </div>
</template>

<script>
import {
  getNotices
} from '../config/api'
import { funMixin } from '../config/mixin'
import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
export default {
  name: "noticeComponent",
  mixins: [funMixin],
  data () {
    return {
      noticesList: [],
      swiperOption: {
        autoplay: true, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.swiper-pagination'
        }
      }
    }
  },
  props: {
    terminal: {
      type: Number,
      default: 4
    },
    componentContent: {
      type: Object
    }
  },
  components: {
    Swiper,
    SwiperSlide
  },
  directives: {
    swiper: directive
  },
  mounted() {
    this.getData()
  },
  methods: {
    async getData() {
      const response = await getNotices()
      const res = response.data
      this.noticesList = res.data
    }
  }
}
</script>

<style lang="scss" scoped>
.notice-list{
  height: 60px;
  line-height: 60px;
  padding: 0 20px;
  .a-link{
    display: block;
    cursor: pointer;
    overflow: hidden;
    text-overflow:ellipsis;
    white-space: nowrap;
    text-align: center;
    span{
      display: inline-block;
      padding-left: 50px;
      font-size: 24px;
      background: url("../static/images/notice/ico_notice2.png") no-repeat left center;
    }
  }
  &.terminal4{
    height: 50px;
    line-height: 50px;
    padding: 0;
    .swiper-container{
      height: 100%;
      width: 1200px;
      max-width: 100%;
      margin: 0 auto;
    }
    .a-link{
      display: block;
      cursor: pointer;
      text-align: left;
      span{
        display: block;
        padding-left: 25px;
        font-size: 14px;
        background: url("../static/images/notice/ico_notice.png") no-repeat left center;
      }
    }
  }
}
</style>
