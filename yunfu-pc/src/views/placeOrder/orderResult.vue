<template>
  <div class="orderResult">
    <div class="container">
      <icon-svg style="font-size: 250px;" icon-class="order-result-success" />
      <article>
        <h1>恭喜您，支付成功</h1>
        <p>请耐心等待发货，保持手机畅通</p>
      </article>
      <div class="btns">
        <el-button class="common order" @click="linkTo('/myOrder')">查看订单</el-button>
        <el-button class="common index" @click="linkTo('/index')">继续购物</el-button>
      </div>
      <div v-show="showPolite" class="discount">
        <icon-svg class="icon" icon-class="order-result-pa" />
        <div class="content">
          <p v-if="credit">恭喜获得额外积分 <span>{{ credit }}</span></p>
          <p v-if="growth">恭喜获得额外会员成长值 <span>{{ growth }}</span></p>
          <p v-for="(item, index) in couponList"
          :key="index"
          >
          恭喜获得
          <span>{{ item.discount }}</span>
          <span v-if="item.couponType ===1">元</span>
          <span v-if="item.couponType ===2">折</span>优惠券1张</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {
  getPoliteList
} from '@/api/Activity/ActivityPolite.js'
export default {
  data () {
    return {
      showPolite: false,
      growth: 0,
      credit: 0,
      couponList: []
    }
  },
  created () {
    this.getPolite()
  },
  methods: {
    async getPolite () {
      const response = await getPoliteList({ orderId: this.$route.query.orderId })
      const res = response.data
      if (res.code === '200') {
        this.growth = res.data.growth
        this.credit = res.data.credit
        this.couponList = res.data.couponList
        if (this.growth || this.credit || (this.couponList && this.couponList.length > 0)) {
          this.showPolite = true
        }
      } else {
        this.$message.error(res.message)
      }
    },
    linkTo (path) {
      if (!path) {
        return
      }
      this.$router.push({
        path: path
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.orderResult{
  max-width: 1250px;
  height: 800px;
  margin: auto;
  .container{
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    article{
      margin: 30px 0;
      text-align: center;
      font-family: Microsoft YaHei;
      h1{
        font-size: 18px;
        color: #333333;
      }
      p{
        margin-top: 10px;
        font-size: 14px;
        color: #999999;
      }
    }
    .btns{
      width: 420px;
      margin-bottom: 30px;
      display: flex;
      justify-content: space-between;
      .common{
        width: 200px;
        height: 50px;
        padding: 0;
        border-radius: 0;
      }
      .order{
        color: #999;
        border: 1px solid #999;
      }
      .index{
        color: #FFEBC4;
        background: #333333;
      }
    }
    .discount{
      width: 385px;
      min-height: 120px;
      padding: 0 25px;
      background: #FFF9F6;
      border: 1px solid #FBE9E6;
      display: flex;
      .icon{
        font-size: 120px;
      }
      .content{
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
      }
      span{
        color: #C83732;
      }
    }
  }
}
</style>
