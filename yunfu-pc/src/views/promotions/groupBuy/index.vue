<template>
  <div class="groupBuyBox sub-main">
    <ActivitySlot  class="activityGroup" :imgTitle="imgTitle">
      <template v-slot:title>
          <div class="title">
            <div class="top"></div>
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
        <div class="groupList" v-if="flag">
          <div class="item" v-for="item in proList" :key="item.productId">
            <ItemSlot :data="item" @toDetail="toProductDetail(item)">
              <template v-slot:extra>
                <div class="progress">
                  <span>限量{{100}}件</span>
                  <el-progress
                  :color="'#C83732'"
                  :show-text="false"
                  :stroke-width="26"
                  :percentage="70"></el-progress>
                </div>
              </template>
              <template v-slot:icon>
                <icon-svg style="font-size:57px;" icon-class="activity-pintuan" />
              </template>
              <template v-slot:button>
                <button class="buy" :class="ifPreheat ? 'buyWill' : 'butNow'" @click="toProductDetail(item)">{{ ifPreheat ? '未开始' : '立即拼团' }}</button>
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
  getGroupList
} from '@/api/Activity/ActivityGroup.js'
export default {
  name: 'groupBuy',
  components: { ActivitySlot, ItemSlot },
  data () {
    return {
      imgTitle: 'static/image/activity/groupTitle.webp',
      page: 1,
      pageSize: 12,
      total: 0,
      id: '',
      shopId: '',
      ifPreheat: false, // 是否预热
      time: '',
      setTime: null,
      proList: [],
      volume: '',
      type: '',
      index: '1',
      flag: true
      // shopName: '',
      // shopLogo: ''
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
    }
    this.getWork()
  },
  methods: {
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
    // 获取拼团专区列表
    async getWork () {
      const rLoading = this.openLoading()
      let params = {
        shopId: this.shopId,
        shopGroupWorkId: this.id,
        page: this.page,
        pageSize: this.pageSize
      }
      if (this.id === '') {
        params.volume = this.volume
        params.type = this.type
      }
      const response = await getGroupList(params)
      const res = response.data
      if (res.code === '200') {
        this.ifPreheat = res.data.state !== 1
        this.proList = res.data.page.list
        this.total = res.data.page.total
        this.time = this.ifPreheat ? res.data.enableTime : res.data.time
        // this.shopName = res.data.shopName
        // this.shopLogo = res.data.shopLogo
        if (res.data.page.list.length) {
          this.flag = true
        } else {
          this.flag = false
        }
        rLoading.close()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 翻页
    changePage (val) {
      this.page = val
      this.getWork()
    },
    // 默认
    defaultSort () {
      this.index = '1'
      this.page = 1
      this.type = ''
      this.volume = ''
      this.getWork()
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
      this.getWork()
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
      this.getWork()
    }
  }
}
</script>

<style lang="scss" scoped>
$zhekouHeight: 40px;
$zhekouTitleFS: 16px;
.groupBuyBox{
  max-width: 1250px;
  margin: auto;
  .activityGroup{
    position: relative;
    // .title{
    //   width: 40%;
    //   height: 60px;
    //   color: #FFF;
    //   margin: auto;
    //   text-align: center;
    //   position: absolute;
    //   top: 160px;
    //   left: 0;
    //   right: 0;
    //   display: flex;
    //   justify-content: space-around;
    //   align-items: center;
    //   .glodTxt{
    //     color: #FFEBC4;
    //     font-size: 30px;
    //     font-family: Microsoft YaHei;
    //   }
    //   .timeBox{
    //     height: 60px;
    //     display: flex;
    //     align-items: center;
    //     .after{
    //       font-size: 30px;
    //       margin: 0 13px;
    //     }
    //     .bc{
    //       width: 60px;
    //       height: 60px;
    //       line-height: 60px;
    //       font-size: 30px;
    //       font-family: Microsoft YaHei;
    //       font-weight: bold;
    //       color: #FFFFFF;
    //       background-color: #333333;
    //     }
    //   }
    // }
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
    .groupList{
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
          align-items: center;
          span{
            margin-left: 10px;
          }
        }
        .buy{
          width: 100%;
          height: 40px;
          padding: 0;
          margin: 15px 0 0;
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
