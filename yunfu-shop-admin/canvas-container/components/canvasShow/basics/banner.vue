<template>
  <div class="banner"  :class="'terminal' + terminal">
    <swiper :options="swiperOption">
      <swiper-slide class="banner-item" v-for="(item,index) in bannerList" :key="index" :style="{backgroundImage: 'url('+ item.bannerUrl +')','height':componentContent.height + 'px'}" @click="jumpLink(item.linkObj)">
<!--        <div class="a-link" @click="jumpLink(item.linkObj)"><img class="img" :src="item.bannerUrl" v-show="item.bannerUrl"></div>-->
      </swiper-slide>
    </swiper>
    <div class="swiper-pagination" slot="pagination"></div>
  </div>
</template>

<script>
import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
  import {funMixin} from '../config/mixin'
  export default {
    name: 'cereBanner',
    mixins: [funMixin],
    data () {
      return {
        swiperOption: {
          autoplay: false, // 可选选项，自动滑动
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
      this.$forceUpdate() // 刷新轮播图
    },
    computed: {
      bannerList: function () {
        console.log(this.componentContent)
        return this.componentContent.bannerData.filter(function (item) {
          return item.bannerUrl
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
.banner{
  .banner-item {
    width: 100%;
    background-repeat: no-repeat;
    background-position: center;
    background-size: auto 100%;
    img {
      width: 100%;
    }
  }
  &.terminal4{
    ::v-deep .el-carousel{
      height: 100%;
      .el-carousel__container{
        height: 100%;
      }
    }
    .banner-item{
      img{
        display: none;
      }
    }
  }
  .swiper-pagination{
    display: flex;
    justify-content: center;
    bottom: 20px;
    width: 100%;
    ::v-deep .swiper-pagination-bullet{
      width: 30px;
      height: 4px;
      background: #fff;
      opacity: 0.5;
      border-radius: 2px;
      margin: 0 7.5px;
    }
    ::v-deep .swiper-pagination-bullet-active{
      opacity: 1;
      width: 58px;
    }
  }
}
</style>
