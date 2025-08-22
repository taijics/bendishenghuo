<template>
  <ActivitySlot  class="getCouponPage activitySpitze" :imgTitle="imgTitle">
    <template v-slot:section>
      <div v-if="coupons.length > 0">
        <div class="spitzeList">
          <div class="couponBox"
            v-for="(item, index) in coupons"
            :key="item.couponId"
            :class="{marginLeft : (index + 1) % 3 !== 1}"
          >
            <icon-svg v-if="item.state === 3" class="couponBg" icon-class="activity-coupon-bg-0" />
            <icon-svg v-if="item.state === 0" class="couponBg" icon-class="activity-coupon-bg-1" />
            <div class="edge" :class="{edgeRed : item.type === 2, edgeDefault : item.type === 1}">
              <div class="type" v-if="item.type === 1">商家券</div>
              <div class="type" v-if="item.type === 2 ">平台券</div>
            </div>
            <div class="content">
              <div class="title">
                <span v-if="item.couponType === 1">￥</span>{{item.reduceMoney}}<span v-if="item.couponType === 2">折</span>
              </div>
              <div class="line"></div>
              <div class="text">
                <div class="name">{{ item.activityName }}</div>
                <div class="time">
                  <p v-if="item.activityStartTime && item.activityEndTime">
                    {{ item.activityStartTime.split(' ')[0].replaceAll('-', '.') }} ~ {{ item.activityEndTime.split(' ')[0].replaceAll('-', '.') }}
                  </p>
                  <p v-if="item.startTime && item.endTime">
                    {{ item.startTime.split(' ')[0].replaceAll('-', '.') }} ~ {{ item.endTime.split(' ')[0].replaceAll('-', '.') }}
                  </p>
                </div>
                <div class="types">
                  <div class="type" v-if="item.type === 1">商家券</div>
                  <div class="type" v-if="item.type === 2 ">平台券</div>
                </div>
              </div>
            </div>
            <div v-if="item.state === 3" class="use" @click="takeCoupon(item)"></div>
            <div v-if="item.state === 0" class="use" @click="useCoupon(item)"></div>
          </div>
        </div>
      </div>
      <div v-else class="noproduct">
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-coupon-nodata" />
        <p class="fs20 font-color-999">该活动没有优惠卷～</p>
      </div>
    </template>
  </ActivitySlot>
</template>

<script>
import ActivitySlot from '@/components/activity/activitySlot.vue'
import {
  getShopCoupon,
  getCommonCoupon,
  tabkeTheCoupon
} from '@/api/coupon.js'
export default {
  components: { ActivitySlot },
  data () {
    return {
      imgTitle: 'static/image/activity/couponTitle.webp',
      query: {
        ids: [], // 优惠券id
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        search: '', // 搜索字段
        shopId: ''
      },
      commonlist: [],
      shoplist: [],
      coupons: []
    }
  },
  created () {
    if (this.$route.query.shopId) {
      this.query.shopId = this.$route.query.shopId
      this.getShopCouponList()
    } else {
      this.getCommonCouponList()
    }
  },
  methods: {
    async getShopCouponList () {
      const response = await getShopCoupon(this.query)
      const res = response.data
      if (res.code === '200') {
        this.shoplist = res.data.list.map(item => {
          item.type = 1
          return item
        }) || []
      }
      this.coupons = [...this.shoplist]
    },
    async getCommonCouponList () {
      const response = await getCommonCoupon(this.query)
      const res = response.data
      if (res.code === '200') {
        this.commonlist = res.data.list.map(item => {
          item.type = 2
          return item
        }) || []
      }
      this.coupons = [...this.commonlist]
    },
    async takeCoupon (item) {
      let params = {}
      if (item.type === 1) { // 领取店铺优惠券
        params.shopCouponId = item.shopCouponId
      }
      if (item.type === 2) { // 领取平台优惠券
        params.couponId = item.couponId
      }
      const response = await tabkeTheCoupon({
        couponId: 0,
        shopCouponId: 0,
        shopId: 0
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('领取成功')
        item.state = 0
      } else {
        this.$message(res.message)
      }
    },
    // 使用优惠券
    useCoupon (item) {
      this.$router.push({
        name: 'couponProList',
        query: {
          coupon: JSON.stringify(item)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
$defaultColor: #999;
.getCouponPage{
  min-height: 800px;
  background-color: #F5F5F5;
  .spitzeList{
    width: 100%;
    padding: 20px 0;
    display: flex;
    flex-wrap: wrap;
    .couponBox{
      width: 30%;
      height: 150px;
      margin: 5px 0;
      position: relative;
      display: flex;
      align-items: center;
      .couponBg{
        width: 100%;
        height: 100%;
        position: absolute;
        z-index: 0;
      }
      .edge{
        width: 0;
        height: 0;
        border: 35px solid;
        border-color: $mainGlod transparent transparent $mainGlod;
        position: absolute;
        top: 0;
        left: 0;
        z-index: 1;
        .type{
          display: block;
          width: 45px;
          color: #FFF;
          transform: rotate(-45deg);
          font-size: 14px;
          position: absolute;
          top: -15px;
          left: -30px;
        }
      }
      .edgeDefault{
        border-color: #C5AA7B transparent transparent #C5AA7B;
      }
      .edgeRed{
        border-color: #C83732 transparent transparent #C83732;
      }
      // 优惠券内容
      .content{
        flex: 8;
        // height: 100%;
        height: 85px;
        font-size: 32px;
        display: flex;
        align-items: center;
        position: relative;
        z-index: 0.5;
        .title{
          // display: flex;
          min-width: 100px;
          text-align: center;
          color: #C83732;
          font-size: 40px;
          span{
            font-size: 20px;
          }
        }
        .line{
          width: 0;
          height: 80px;
          margin: 0 12px;
          border: 1px solid #EEEEEE;
        }
        .text{
          height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          .name{
            font-size: 18px;
          }
          p{
            font-size: 14px;
            color: #999999;
          }
          .types{
            font-size: 14px;
          }
        }
      }
      .use{
        flex: 2;
        height: 100%;
        cursor: pointer;
        z-index: 1;
      }
    }
    .marginLeft{
      margin-left: 5%;
    }
  }
  .noproduct{
    margin-top: 100px;
    text-align: center;
  }
}
</style>
