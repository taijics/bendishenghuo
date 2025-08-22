<template>
  <div class="rabattBox sub-main">
    <!-- 根据路由传参type 渲染店铺 -->
    <ActivitySlot class="activityRabatt" :imgTitle="imgTitle">
      <!-- 顶部标题填充内容 -->
      <template v-slot:title>
        <div class="title"
          v-if="flag&&$route.query.shopId || !$route.query.shopId"
        >
          <span class="glodTxt"
            v-if="$route.query.shopId && !ifPreheat"
          >活动结束倒计时</span>
          <span class="glodTxt"
            v-if="$route.query.shopId && ifPreheat"
          >活动开始倒计时</span>
          <span class="glodTxt"
            v-if="!$route.query.shopId && sessionList[idInx] && sessionList[idInx].type === 1"
          >{{sessionList[idInx].startTime}} 场结束倒计时</span>
          <span class="glodTxt"
            v-if="!$route.query.shopId && sessionList[idInx] && !sessionList[idInx].type"
          >{{sessionList[idInx].startTime}} 场开始倒计时</span>
          <div class="timeBox">
            <div class="hour bc">{{time | formatHours}}</div>
            <div class="after">:</div>
            <div class="min bc">{{time | formatMinutes}}</div>
            <div class="after">:</div>
            <div class="sec bc">{{time | formatSeconds}}</div>
          </div>
        </div>
      </template>
      <template v-slot:section>
        <div class="timeList"
          v-if="!$route.query.shopId"
          :class="sessionList.length>4?'long':''"
        >
          <div class="time"
            :class="index===idInx?'start':''"
            v-for="(item,index) in sessionList"
            :key="index"
            @click="changeSession(index)"
          >
            {{ item.startTime }}&emsp;{{item.type === 1 ? '抢购中':item.type === 2?'已结束':'未开始'}}
          </div>
        </div>
        <div class="rabattList" v-if="flag" v-loading="loadingList">
          <div class="item"
            v-for="item in proList"
            :key="item.productId"
          >
            <ItemSlot
              :data="item"
              @toDetail="toProductDetail(item)"
            >
              <template v-slot:extra v-if="item.limitStockNumber">
                <div class="progress">
                  <span>限量{{item.limitStockNumber}}件</span>
                  <el-progress
                    :color="'#C83732'"
                    :show-text="false"
                    :stroke-width="26"
                    :percentage="(item.limitStockNumber / item.limitNumber) * 100"></el-progress>
                </div>
              </template>
              <template v-slot:icon>
                <icon-svg style="font-size:57px;" icon-class="activity-miaosha" />
              </template>
              <template v-slot:button v-if="sessionList.length">
                <button class="buy"
                  :class="sessionList[idInx].type === 1 ? 'butNow' : sessionList[idInx].type === 2 ? 'buyNot' : 'buyWill'"
                  @click="toProductDetail(item)"
                >{{ sessionList[idInx].type === 1 ? '立即抢购' : sessionList[idInx].type === 2 ? '已结束' : '未开始' }}</button>
              </template>
              <template v-slot:button v-else>
                <button class="buy"
                  :class="ifPreheat ? 'buyWill' : 'butNow'"
                  @click="toProductDetail(item)"
                >{{ ifPreheat ? '未开始' : '立即抢购' }}</button>
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
      v-if="flag"
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
  getSeckill,
  getSeckillIndex,
  getSeckillTime
} from '@/api/Activity/ActivitySeckill.js'
export default {
  name: 'rabatt',
  components: { ActivitySlot, ItemSlot },
  data () {
    return {
      imgTitle: 'static/image/activity/rabattTitle.webp',
      page: 1,
      pageSize: 12,
      total: 0,
      ids: '',
      shopId: '',
      proList: [],
      loadingList: false,
      time: '',
      setTime: null,
      limitNumber: null,
      ifPreheat: false, // 是否预热
      // shopName: '',
      // shopLogo: '',
      value: 1,
      type: '',
      volume: '',
      index: '1',
      flag: true,
      idInx: 0,
      sessionList: [],
      session: ''
    }
  },
  filters: {
    formatHours: function (value) {
      let hours = Math.floor(value / (1000 * 60 * 60))
      if (hours < 10 && hours > 0) {
        return '0' + hours
      } else if (hours > 10) {
        return hours
      } else {
        return '00'
      }
    },
    formatMinutes: function (value) {
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      if (minutes < 10 && minutes > 0) {
        return '0' + minutes
      } else if (minutes > 10) {
        return minutes
      } else {
        return '00'
      }
    },
    formatSeconds: function (value) {
      let seconds = Math.round((value % (1000 * 60)) / 1000)
      if (seconds < 10 && seconds > 0) {
        return '0' + seconds
      } else if (seconds > 10) {
        return seconds
      } else {
        return '00'
      }
    }
  },
  mounted () {
    if (this.$route.query.ids) {
      this.ids = this.$route.query.ids
    }
    if (this.$route.query.shopId) {
      this.shopId = this.$route.query.shopId
      this.getSeckill()
    } else {
      this.getSeckills()
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
    // 获取平台秒杀专区列表
    async getPlatformSeckills () {
      if (!this.sessionList[this.idInx]) {
        this.flag = false
        return
      }
      const response = await getSeckill({
        page: this.page,
        pageSize: this.pageSize,
        session: this.sessionList[this.idInx].startTime
      })
      const res = response.data
      if (res.code === '200') {
        this.proList = res.data.list
        this.total = res.data.total
        if (res.data.list.length) {
          this.flag = true
        } else {
          this.flag = false
        }
      }
    },
    // 获取秒杀专区列表
    async getSeckill () {
      this.loadingList = true
      let params = {
        shopId: this.shopId,
        shopSeckillId: this.ids[0] || this.ids,
        page: this.page,
        pageSize: this.pageSize
      }
      if (this.ids === '') {
        params.volume = this.volume
        params.type = this.type
      }
      const response = await getSeckillIndex(params)
      const res = response.data
      if (res.code === '200') {
        this.ifPreheat = res.data.state !== 1
        this.proList = res.data.page.list
        this.total = res.data.page.total
        this.time = this.ifPreheat ? res.data.enableTime : res.data.time
        this.limitNumber = res.data.limitNumber
        if (res.data.page.list.length) {
          this.flag = true
        } else {
          this.flag = false
          this.time = 0
        }
        if (this.ids !== '' && this.flag) {
          this.countDown()
        }
        // this.shopName = res.data.shopName
        // this.shopLogo = res.data.shopLogo
      } else {
        this.$message.warning(res.message)
      }
      this.loadingList = false
    },
    // 切换活动
    changeSession (index) {
      this.idInx = index
      this.page = 1
      if (this.sessionList[this.idInx].type === 1) { // 抢购中
        this.time = new Date(this.sessionList[this.idInx].endTime).getTime() - new Date().getTime()
      }
      if (!this.sessionList[this.idInx].type) { // 未开始
        this.time = new Date(this.sessionList[this.idInx].startTime).getTime() - new Date().getTime()
      }
      if (this.time > 0) {
        this.countDown()
      } else {
        this.time = 0
      }
      this.getPlatformSeckills()
    },
    // 获取活动时间段
    async getSeckills () {
      const response = await getSeckillTime()
      const res = response.data
      if (res.code === '200') {
        // type: 0 未开始    1抢购中   2已结束
        this.sessionList = res.data.map(item => {
          const [startTime, endTime] = item.split('|')
          let timesStart = new Date(startTime).getTime() - new Date().getTime() > 0 ? 0 : 1
          let timesEnd = new Date(endTime).getTime() - new Date().getTime() > 0 ? 0 : 1
          return {
            startTime,
            endTime,
            type: timesStart && !timesEnd ? 1 : timesStart && timesEnd ? 2 : 0
          }
        })
        console.log(this.sessionList)
        if (this.sessionList[this.idInx] && this.sessionList[this.idInx].type === 1) { // 抢购中
          this.time = new Date(this.sessionList[this.idInx].endTime).getTime() - new Date().getTime()
        }
        if (this.sessionList[this.idInx] && !this.sessionList[this.idInx].type) { // 未开始
          this.time = new Date(this.sessionList[this.idInx].startTime).getTime() - new Date().getTime()
        }
        if (this.time > 0) {
          this.countDown()
        } else {
          this.time = 0
        }
        this.getPlatformSeckills()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 翻页
    changePage (val) {
      this.page = val
      this.getSeckill()
    },
    // 默认
    defaultSort () {
      this.index = '1'
      this.page = 1
      this.type = ''
      this.volume = ''
      this.getSeckill()
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
      this.getSeckill()
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
      this.getSeckill()
    }
  }
}
</script>

<style lang="scss" scoped>
.rabattBox {
  max-width: 1250px;
  margin: auto;
  .activityRabatt{
    position: relative;
    .title{
      width: 40%;
      height: 60px;
      color: #FFF;
      margin: auto;
      text-align: center;
      position: absolute;
      top: 160px;
      left: 0;
      right: 0;
      display: flex;
      justify-content: space-around;
      align-items: center;
      .glodTxt{
        color: #FFEBC4;
        font-size: 16px;
      }
      .timeBox{
        height: 60px;
        display: flex;
        align-items: center;
        .after{
          font-size: 30px;
          margin: 0 13px;
        }
        .bc{
          width: 40px;
          height: 40px;
          line-height: 40px;
          font-size: 20px;
          color: #FFFFFF;
          background-color: #333333;
        }
      }
    }
    .timeList{
      // width: 1200px;
      height: 60px;
      margin-top: 20px;
      overflow-y: auto;
      display: flex;
      flex-wrap: nowrap;
      overflow-y: hidden;
      .time{
        flex: 0 0 23%;
        height: 60px;
        line-height: 60px;
        text-align: center;
        color: #999;
        margin: 0 1%;
        cursor: pointer;
        background-color: #E4E5E6;
      }
      .start{
        background-color: #333;
        color: #FFEBC4;
      }
    }
    .long{
      padding-bottom: 15px;
    }
    .rabattList {
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      min-height: 532px;
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
          align-items: center;
          span{
            margin-left: 10px;
          }
          >>> .el-progress{
            flex: 1;
            height: 10px;
            margin: 0 10px;
            // .el-progress-bar{
            //   height: 10px;
            // }
            .el-progress-bar__outer,.el-progress-bar__inner{
              border-radius: 0;
              height: 10px !important;
            }
          }
        }
        .buy{
          width: 100%;
          height: 40px;
          padding: 0;
          margin: 15px 0 0;
          color: #fff;
          cursor: pointer;
        }
        .butNow{
          background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
          box-shadow: 0px 3px 6px rgba(233, 0, 0, 0.3);
        }
        .buyNot{
          background-color: #999999;
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
  .noproduct{
    width: 100%;
    text-align: center;
    min-height: 500px;
    img{
      margin-top: 50px;
    }
  }
}
// 隐藏滚动条
// .timeList::-webkit-scrollbar {
//   display: none; /* Chrome Safari */
// }
// .timeList{
//   scrollbar-width: none; /* firefox */
//   -ms-overflow-style: none; /* IE 10+ */
// }
</style>
