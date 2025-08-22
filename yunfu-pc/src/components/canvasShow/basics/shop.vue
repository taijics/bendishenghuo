<template>
  <div class="shop"  :class="'terminal' + terminal">
    <swiper :options="swiperOption">
      <swiper-slide class="shop-item" v-for="(item,index) in imgList" :key="index">
        <div class="shop-item-warp">
          <img class="img" :src="item.img">
          <div class="a-link" @click="jumpLink(item.linkObj)">
            进店逛逛<i class="iconfont icon-arrow-right"></i>
          </div>
        </div>
      </swiper-slide>
    </swiper>
    <div class="pagination shop-pagination"></div>
  </div>
</template>

<script>
import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import {funMixin} from '../config/mixin'
export default {
  name: 'shop',
  mixins: [funMixin],
  data () {
    return {
      swiperOption: {
        autoplay: false, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.shop-pagination'
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
  computed: {
    imgList: function () {
      return this.componentContent.imgTextData.filter(function (item) {
        return item.img
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.shop{
  position: relative;
  &-item{
    &-warp{
      position: relative;
      padding: 0 20px;
      .img{
        width: 100%;
      }
      .a-link{
        width: 220px;
        height: 80px;
        line-height: 80px;
        background: linear-gradient(225deg, #585858 0%, #333333 100%);
        box-shadow: 0px 20px 40px rgba(0, 0, 0, 0.3);
        display: block;
        color: #fff;
        font-size: 28px;
        text-align: center;
        position: absolute;
        right: 0;
        bottom: 30px;
        .icon{
          margin-left: 20px;
        }
      }
    }
  }
  .pagination{
    display: flex;
    justify-content: center;
    padding:20px 0;
    ::v-deep .swiper-pagination-bullet{
      width: 12px;
      height: 12px;
      background: #333333;
      border-radius: 50%;
      opacity: 0.2;
      margin: 0 10px;
    }
    ::v-deep .swiper-pagination-bullet-active{
      width: 24px;
      height: 12px;
      background: #333333;
      opacity: 1;
      border-radius: 8px;
    }
  }
}
</style>
