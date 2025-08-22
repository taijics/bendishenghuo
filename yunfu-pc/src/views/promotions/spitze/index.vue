/**
  限时折扣
 */
<template>
  <div class="spikeBox sub-main">
      <ActivitySlot  class="activitySpitze" :imgTitle="imgTitle">
        <template v-slot:title>
          <div class="title">
            <div class="top">全场{{ discountData.discount || 0 }}折</div>
            <div class="bottom">
              <span class="glodTxt" v-if="!ifPreheat">距离本场结束：</span>
              <span class="glodTxt" v-else>距离本场开始：</span>
              <div class="timeBox">
                <div class="hour bc">{{time | formatHours}}</div>
                <div class="after">:</div>
                <div class="min bc">{{time | formatMinutes}}</div>
                <div class="after">:</div>
                <div class="sec bc">{{time | formatSeconds}}</div>
              </div>
            </div>
          </div>
        </template>
        <template v-slot:section>
          <ul>
            <li></li>
          </ul>
          <div class="spitzeList" v-if="flag">
            <div class="item" v-for="item in proList" :key="item.productId">
              <ItemSlot :data="item"
                @click="toProductDetail(item)"
                @toDetail="toProductDetail(item)">
                <template v-slot:extra>
                  <div class="progress">
                    <icon-svg style="width: 24px; height: 24px; margin-right: 10px;" icon-class="activity-cart-black" />
                    <span>{{item.users || item.saleNumber || 0}} 人已购买</span>
                  </div>
                </template>
                <template v-slot:icon>
                  <icon-svg style="font-size:57px;" icon-class="activity-zhekou" />
                </template>
                <template v-slot:button>
                  <button class="buy" :class="ifPreheat ? 'buyWill' : 'butNow'" @click="toProductDetail(item)">{{ ifPreheat ? '未开始' : '立即抢购' }}</button>
                </template>
              </ItemSlot>
            </div>
          </div>
          <div v-else class="noproduct">
            <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
            <p class="fs20 font-color-999">该活动没有商品～</p>
          </div>
        </template>
      </ActivitySlot>
      <el-pagination
        style="margin-bottom:20px;"
        background
        layout="prev, pager, next, jumper"
        :page-size="pageSize"
        :current-page="page"
        @current-change="changePage"
        :total="total">
      </el-pagination>
    </div>
</template>

<script>
import ActivitySlot from '@/components/activity/activitySlot.vue'
import ItemSlot from '@/views/promotions/components/itemSlot.vue'
import {
  getDiscountList,
  getPlatformDiscountList,
  getDiscountIndex
} from '@/api/Activity/ActivityDiscount.js'
export default {
  name: 'spitze',
  components: { ActivitySlot, ItemSlot },
  data () {
    return {
      imgTitle: 'static/image/activity/spitzeTitle.webp',
      page: 1,
      pageSize: 12,
      total: 0,
      id: '',
      shopId: '',
      proList: [],
      time: '',
      setTime: null,
      ifPreheat: false, // 是否预热
      // shopName: '',
      // shopLogo: ''
      type: '',
      volume: '',
      index: '1',
      flag: true,
      discountData: {}
    }
  },
  filters: {
    formatHours: function (value) {
      if (!value) { return '00' }
      let hours = Math.floor(value / (1000 * 60 * 60))
      if (hours < 10) {
        return '0' + hours
      } else {
        return hours
      }
    },
    formatMinutes: function (value) {
      if (!value) { return '00' }
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      if (minutes < 10) {
        return '0' + minutes
      } else {
        return minutes
      }
    },
    formatSeconds: function (value) {
      if (!value) { return '00' }
      let seconds = Math.round((value % (1000 * 60)) / 1000)
      if (seconds < 10) {
        return '0' + seconds
      } else {
        return seconds
      }
    }
  },
  mounted () {
    if (this.$route.query.id) {
      this.id = this.$route.query.id
    }
    if (this.$route.query.shopId) {
      this.shopId = this.$route.query.shopId
      this.getDiscount()
    } else {
      this.getDiscounts()
      this.getPlatformDiscount()
    }
  },
  beforeDestroy () {
    // 离开页面清除定时器
    clearInterval(this.setTime)
  },
  methods: {
    // 倒计时
    countDown () {
      clearInterval(this.setTime)
      this.setTime = setInterval(() => {
        if (this.time < 1000) {
          clearInterval(this.setTime)
          return alert('活动已结束')
        }
        this.time -= 1000
      }, 1000)
    },
    // 跳转到商品详情
    toProductDetail (item) {
      let data = {
        productId: item.productId,
        shopId: item.shopId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 获取平台限时折扣
    async getPlatformDiscount () {
      const rLoading = this.openLoading()
      const response = await getPlatformDiscountList({
        page: this.page,
        pageSize: this.pageSize,
        discountId: this.$route.query.id,
        type: '',
        volume: ''
      })
      const res = response.data
      if (res.code === '200') {
        this.proList = res.data.list
        this.total = res.data.total
        this.time = new Date(this.discountData.endTime).getTime() - new Date().getTime()
        if (res.data.list.length) {
          this.flag = true
        } else {
          this.flag = false
          this.time = 0
        }
        if (this.id !== '' && this.flag) {
          this.countDown()
        }
      }
      rLoading.close()
    },
    async getDiscounts () {
      const response = await getDiscountList({ discountId: this.$route.query.id })
      const res = response.data
      if (res.code === '200') {
        this.discountData = res.data
      } else {
        this.$message.error(res.message)
      }
    },
    // 获取店铺首页
    async getDiscount () {
      const rLoading = this.openLoading()
      let params = {
        shopId: this.shopId,
        shopDiscountId: this.id,
        page: this.page,
        pageSize: this.pageSize
      }
      if (this.id === '') {
        params.volume = this.volume
        params.type = this.type
      }
      const response = await getDiscountIndex(params)
      const res = response.data
      if (res.code === '200') {
        this.ifPreheat = res.data.state !== 1
        this.proList = res.data.page.list
        this.total = res.data.page.total
        this.time = this.ifPreheat ? res.data.enableTime : res.data.time
        if (res.data.page.list.length) {
          this.flag = true
        } else {
          this.flag = false
          this.time = 0
        }
        if (this.id !== '' && this.flag) {
          this.countDown()
        }
        rLoading.close()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 翻页
    changePage (val) {
      this.page = val
      this.getDiscount()
    },
    // 默认
    defaultSort () {
      this.index = '1'
      this.page = 1
      this.type = ''
      this.volume = ''
      this.getDiscount()
    },
    // 价格
    priceSort () {
      this.index = '2'
      this.page = 1
      if (this.type === '' || this.type === 2) {
        this.type = 1
      } else {
        this.type = 2
      }
      this.volume = ''
      this.getDiscount()
    },
    // 销量
    salesSort () {
      this.index = '3'
      this.page = 1
      if (this.volume === '' || this.volume === 2) {
        this.volume = 1
      } else {
        this.volume = 2
      }
      this.type = ''
      this.getDiscount()
    }
  }
}
</script>

<style lang="scss" scoped>
$zhekouHeight: 40px;
$zhekouTitleFS: 16px;
.spikeBox {
  max-width: 1250px;
  margin: auto;
  .activitySpitze{
    position: relative;
    .title{
      width: 40%;
      height: 100px;
      color: #FFF;
      margin: auto;
      text-align: center;
      position: absolute;
      top: 130px;
      left: 0;
      right: 0;
      .top{
        width: 146px;
        height: 60px;
        margin: auto;
        text-align: center;
        color: #C83732;
        font-size: 32px;
        font-family: Microsoft YaHei;
      }
      .bottom{
        display: flex;
        justify-content: center;
        align-items: center;
        .glodTxt{
          color: #FFEBC4;
          font-size: $zhekouTitleFS;
          font-family: Microsoft YaHei;
        }
        .timeBox{
          height: $zhekouHeight;
          display: flex;
          align-items: center;
          .after{
            font-size: $zhekouTitleFS;
            margin: 0 13px;
          }
          .bc{
            width: $zhekouHeight;
            height: $zhekouHeight;
            line-height: $zhekouHeight;
            font-size: $zhekouTitleFS;
            font-family: Microsoft YaHei;
            font-weight: bold;
            color: #FFFFFF;
            background-color: #333333;
          }
        }
      }
    }
    .spitzeList {
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      .item {
        width: 23%;
        margin: 20px 1%;
        transition: all 0.3s linear;
        .progress{
          width: 100%;
          height: 40px;
          background-color: #DADBDC;
          position: absolute;
          bottom: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          span{
            font-size: 14px;
            color: #333333;
          }
        }
        .buy{
          width: 100%;
          height: 40px;
          padding: 0;
          margin: 15px 0 0;
          color: #FFF;
          background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
          box-shadow: 0px 3px 6px rgba(233, 0, 0, 0.3);
          cursor: pointer;
        }
        .butNow{
          background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
          box-shadow: 0px 3px 6px rgba(233, 0, 0, 0.3);
        }
        .buyWill{
          background: linear-gradient(90deg, #29C790 0%, #75D98C 100%);
          box-shadow: 0px 3px 6px rgba(52, 203, 144, 0.3);
        }
      }
      .item:hover{
        box-shadow:0 0 20px #cccccc;
      }
    }
  }
  .spikeTit {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 60px;
    h3 {
      font-size: 36px;
      color: #333333;
      font-weight: bold;
    }
    .countdown {
      display: flex;
      align-items: center;
      margin-left: 50px;
      .countdownTit {
        font-size: 24px;
        color: #333333;
        font-weight: bold;
      }
      .timeDown{
        margin-left: 10px;
        span{
          display: inline-block;
          text-align: center;
          font-size: 24px;
          height: 40px;
          line-height: 40px;
        }
        .time{
          min-width: 40px;
          background: #000;
          color: #FFFFFF;
        }
      }
    }
  }
  .sort {
    width: 100%;
    height: 63px;
    line-height: 27px;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #f1f1f1;
    color: #666666;
    margin-bottom: 28px;
    .default {
      margin-left: 20px;
      cursor: pointer;
    }
    .sales {
      margin-right: 20px;
      cursor: pointer;
      img{
        width: 9px;
        height: 16px;
        vertical-align: middle;
      }
    }
    .price {
      display: flex;
      margin: 0 20px;
      cursor: pointer;
      .arr {
        vertical-align: middle;
        width: 12px;
        margin-left: 3px;
        .up {
          width: 0;
          height: 0;
          border: 6px solid transparent;
          border-bottom-color: #999999;
        }
        .down {
          width: 0;
          height: 0;
          border: 6px solid transparent;
          border-top-color: #999999;
          margin-top: 3px;
        }
      }
    }
    .active{
      color: #FF7800;
      .arr{
        .high{
          border-top-color: #FF7800;
        }
        .low{
          border-bottom-color: #FF7800;
        }
      }
    }
  }
  .spikeList {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    .item {
      width: 282px;
      margin:0 40px 65px 0;
      transition: all 0.3s linear;
      .imgBox {
        height: 282px;
        margin-bottom: 25px;
        cursor: pointer;
        img {
          width: 100%;
          height: 100%;
        }
      }
      &:nth-child(4n) {
        margin-right: 0;
      }
      .priceBox {
        text-align: center;
        h3 {
          font-size: 16px;
          font-weight: bold;
          color: #333434;
          margin-bottom: 12px;
          cursor: pointer;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .price {
          width: 200px;
          font-size: 18px;
          font-weight: bold;
          color: $mainColor;
          display: block;
          padding-bottom: 10px;
          border-bottom: 2px solid #f3f3f3;
          margin: 0 auto 13px auto;
        }
        .people {
          font-size: 14px;
          font-weight: 400;
          color: #999999;
          display: block;
          margin-bottom: 16px;
        }
        button {
          width: 120px;
          height: 34px;
          background: linear-gradient(247deg, #F71622, #FE6F52);
          border: 1px solid #EC4B42;
          border-radius: 4px;
          color: #FFFFFF;
          cursor: pointer;
        }
      }
    }
    .item:hover{
      box-shadow:0 0 20px #cccccc;
    }
  }
  .noproduct{
    width: 100%;
    text-align: center;
    min-height: 500px;
    img{
      margin-top: 50px;
    }
  }
}
</style>
