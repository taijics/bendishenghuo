<template>
  <ActivitySlot class="couponProList sub-main" :imgTitle="imgTitle">
    <template v-slot:title>
      <div class="couponDetail">
        <div class="content">
          <div class="title">
            <span v-if="coupon.couponType === 1">￥</span>
            <span class="num">{{coupon.reduceMoney}}</span>
            <span v-if="coupon.couponType === 2">折</span>
          </div>
          <span class="fullmoney" v-if="coupon.couponType === 1">满{{coupon.fullmoney}}元</span>
        </div>
        <div class="circle"></div>
      </div>
    </template>
    <template v-slot:section>
      <div class='banxin' v-if="productList.length">
        <div class="content">
          <ProductList :productList='productList'></ProductList>
          <el-pagination
            v-if="productList.length>0"
            :current-page="page"
            :page-size="12"
            @current-change="handleCurrentChange"
            background layout='prev, pager, next'
            :total='total'
          ></el-pagination>
        </div>
      </div>
      <div v-else class="noproduct">
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
        <p class="fs20 font-color-999">该活动没有优惠卷～</p>
      </div>
    </template>
  </ActivitySlot>
</template>
<script>
import ProductList from '@/components/base/productList'
import ActivitySlot from '@/components/activity/activitySlot.vue'
import {
  getCouponProducts
} from '@/api/coupon.js'
export default {
  components: {
    ProductList,
    ActivitySlot
  },
  data () {
    return {
      imgTitle: 'static/image/activity/coupon-product.webp',
      page: 1,
      total: 0,
      productList: [],
      noData: false,
      coupon: {}
    }
  },
  created () {
    this.coupon = JSON.parse(this.$route.query.coupon)
    console.log(this.coupon)
    this.getCouponProList()
  },
  methods: {
    // 获取分类商品
    async getCouponProList () {
      const rLoading = this.openLoading()
      const response = await getCouponProducts({
        activityId: this.coupon.activityId || '',
        shopCouponId: this.coupon.shopCouponId || '',
        page: this.page,
        pageSize: 12
      })
      const res = response.data
      if (res.code === '200') {
        this.productList = res.data.list
        if (this.productList.length === 0) {
          this.noData = true
        }
        this.total = res.data.total
      } else {
        this.$message.error(res.message)
      }
      rLoading.close()
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.page = val
      this.getCouponProList()
    }
  }
}
</script>
<style lang="scss" scoped>
.couponProList{
  width: 100%;
  height: 100%;
  min-height: 800px;
  background-color: #f0f0f0;
  text-align: center;
  position: relative;
  .couponDetail{
    $bgheight: 110px;
    width: 200px;
    height: $bgheight;
    margin: auto;
    position: absolute;
    top: 100px;
    left: 0;
    right: 0;
    overflow: hidden;
    background-image: linear-gradient(to right, #C5AA7B, #FFEBC4);
    .content{
      $content-margin: 10px;
      height: $bgheight - 2*$content-margin;
      background-color: #FFF;
      margin: 10px;
      color: #C83732;
      display: flex;
      flex-direction: column;
      justify-content: center;
      .title{
        font-size: 20px;
        .num{
          font-size: 40px;
        }
      }
      .fullmoney{
        margin: 10px 0;
      }
    }
    .circle{
      width: 40px;
      height: 40px;
      border-radius: 20px;
      background-color: #C5AA7B;
      position: absolute;
      top: 30%;
      left: -10px;
      z-index: 10;
    }
  }
  .banxin {
    width: 1252px;
    height: 100%;
    margin: 0 auto 40px;
    .content{
      background-color: #FFFFFF;
      width: 100%;
      box-sizing: border-box;
      h3{
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 50px;
        padding-top: 50px;
      }
      .noproduct{
        width: 100%;
        text-align: center;
        padding: 200px 0;
      }
      >>>.el-pagination{
        text-align: right;
        .el-pager{
          li:not(.disabled):hover{
            color: $mainGlod;
          }
          li:not(.disabled).active{
            background-color: $mainGlod;
          }
          li:not(.disabled).active:hover{
            color: #F4F4F5;
          }
        }
      }
    }
  }
  .noproduct{
    margin-top: 100px;
    text-align: center;
  }
}
</style>
