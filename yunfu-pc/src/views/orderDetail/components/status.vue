<template>
  <div class="orderDetailStatus">
    <nav>
      <p :class="{ colorRed : data.status === 1.5 || (data.type === 0 && data.status <= 1) || (data.type === 3 && (data.status === 1 || data.status === 6 || data.status === 7)) }">{{ title }}</p>
    </nav>
    <!-- 普通活动 -->
    <section v-if="data.type === 0">
      <div class="box" :class="{colorGlod : data.status >= 1 }">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-submit"
        />
        <p>提交订单</p>
      </div>
      <span class="defaultSpot" :class="{glodSpot : data.status > 0 }"></span>
      <div class="box" :class="{colorGlod : data.status >= 2 }">
        <!-- 关闭订单（需要判断是否支付）、退款审核 -->
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-loading"
        />
        <p>订单处理</p>
      </div>
      <span class="defaultSpot"
        v-if="data.status !== 5"
        :class="{glodSpot : data.status!==1 && data.status!==''}"
      ></span>
      <div class="box"
        v-if="data.status !== 5"
        :class="{colorGlod : data.status >= 3 }"
      >
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-store"
        />
        <p>商品出库</p>
      </div>
      <span class="defaultSpot"
        v-if="data.status !== 5"
        :class="{glodSpot : data.status >= 4 , redSpot : data.status === 3}"
      ></span>
      <div class="box"
        v-if="data.status !== 5"
        :class="{colorGlod : data.status >= 4, colorRed : data.status === 3}"
      >
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-express"
        />
        <p>等待收货</p>
      </div>
      <span class="defaultSpot"
        :class="{glodSpot : data.status >= 4}"
      ></span>
      <div class="box"
      :class="{colorGlod : data.status >= 4 }">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-finish"
        />
        <p v-if="data.status !== 5">已完成</p>
        <p v-if="data.status === 5">已关闭</p>
      </div>
    </section>
    <!-- 拼团详情 -->
    <section v-if="data.type === 1">
    <!-- <section> -->
      <div class="box" :class="{colorGlod : data.status >= 0}">
        <icon-svg
          v-if="true"
          style="font-size: 90px;"
          icon-class="order-detail-submit"
        />
        <p>付款成功</p>
      </div>
      <div class="defaultSpot"
        :class="{glodSpot : data.status >= 0}"
      ></div>
      <div class="box" v-if="data.status !== 1.5" :class="{colorGlod : data.status >= 1}">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-pintuan-1"
        />
        <p>拼团中</p>
      </div>
      <div class="defaultSpot"
        v-if="data.status !== 1.5"
        :class="{glodSpot : data.status >= 1 }"
      ></div>
      <!-- 拼团失败 单独的状态 -->
      <div class="box" v-if="data.status === 1.5" style="color: #C83732;">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-pintuan-0"
        />
        <p>拼团失败</p>
      </div>
      <div class="defaultSpot"
        v-if="data.status === 1.5"
      ></div>
      <div class="box" :class="{colorGlod : data.status >= 2}">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-store"
        />
        <p>商品出库</p>
      </div>
      <div class="defaultSpot"
        :class="{glodSpot: data.status >= 2}"
      ></div>
      <div class="box" :class="{colorGlod : data.status >= 3}">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-express"
        />
        <p>运输中</p>
      </div>
      <div class="defaultSpot"
        :class="{glodSpot: data.status >= 3}"
      ></div>
      <div class="box" :class="{colorGlod : data.status >= 4}">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-finish"
        />
        <p v-if="data.status === 5">已关闭</p>
        <p v-if="data.status !== 5">已完成</p>
      </div>
    </section>
    <!-- 售后详情 -->
    <section v-if="data.type === 3">
    <!-- <section> -->
      <div class="box" :class="{colorGlod : data.status >= 1 }">
        <icon-svg
          v-if="true"
          style="font-size: 90px;"
          icon-class="order-detail-submit"
        />
        <p>申请售后</p>
      </div>
      <span class="defaultSpot"
        :class="{glodSpot : data.status >= 0 }"
      ></span>
      <div class="box" :class="{colorGlod : data.status >= 1 }">
        <icon-svg
          v-if="data.status <= 2"
          style="font-size: 90px;"
          icon-class="order-detail-loading"
        />
        <p v-if="data.status <= 2">订单处理</p>

        <icon-svg
          v-if="data.status >= 3"
          style="font-size: 90px;"
          icon-class="order-detail-list-1"
        />
        <p v-if="data.status >= 3">订单处理</p>
      </div>
      <span
        v-if="data.afterType === 2"
        class="defaultSpot"
        :class="{glodSpot : data.status >= 2 }"
      ></span>
      <div
      v-if="data.status === 10"
      class="box colorRed">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-express"
        />
        <p>录入退货物流</p>
      </div>
      <!-- 售后条件渲染内容 -->
      <div
        v-if="data.status === 10"
        class="defaultSpot"
        :class="{glodSpot : data.status >= 2 && data.status !== 10 }"
      ></div>
      <div
      v-if="data.afterType === 2"
      class="box" :class="{colorGlod : data.status >= 2 && data.status !== 10 }">
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-express"
        />
        <p>运输中</p>
      </div>
      <!-- 退款审核 -->
      <span class="defaultSpot"
        v-if="data.status === 4 || data.status === 8"
        :class="{glodSpot : (data.status === 4 || data.status === 8) && data.status !== 10 }"
      ></span>
      <div class="box"
      v-if="data.status === 4 || data.status === 8"
      :class="{colorGlod : (data.status === 4 || data.status === 8) && data.status !== 10 }" >
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-check-1"
        />
        <p>审核通过</p>
      </div>
      <!--  -->
      <span
        v-if="data.status !== 6 && data.status !== 5 && data.status !== 9"
        class="defaultSpot"
        :class="{glodSpot : (data.status === 4 || data.status === 8) && data.status !== 10 }"
      ></span>
      <div
        v-if="data.status !== 6 && data.status !== 5 && data.status !== 9"
        class="box"
        :class="{colorGlod : (data.status === 4 || data.status === 8) && data.status !== 10 }"
      >
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-finish"
        />
        <p v-if="data.status !== 9">已完成</p>
      </div>
      <span
        v-if="data.status === 6 || data.status === 5 || data.status === 9"
        class="defaultSpot redSpot"
      ></span>
      <div
        v-if="data.status === 6 || data.status === 5 || data.status === 9"
        class="box colorRed"
      >
        <icon-svg
          style="font-size: 90px;"
          icon-class="order-detail-list-0"
        />
        <p v-if="data.status === 6">审核未通过</p>
        <p v-if="data.status === 5">退款失败</p>
        <p v-if="data.status === 9">已关闭</p>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  props: {
    // type 0 正常订单  1-待付款 2-待发货 3-待收货 4-已完成 5-已关闭
    // type 1 拼团菜单  0-待成团，1-拼团成功，2-拼团失败,
    // type 3 售后订单  默认 '' 1-审核中 2-退款中 3-退货中 4-退款成功 5-退款失败 6-审核不通过 7-评审中 8-退货完成，拒绝退款 9-已关闭 10-审核通过
    data: {
      type: Object,
      default: () => ({
        orderState: null,
        isPay: false,
        type: null,
        status: null
      })
    }
  },
  data () {
    return {
      title: '订单状态',
      titleRed: false
    }
  },
  watch: {
    data: {
      handler (nVal, oVal) {
        this.filterStatus()
      },
      deep: true
    }
  },
  methods: {
    filterStatus () {
      if (typeof (this.data.status) !== 'number') {
        return
      }
      if (this.data.type === 0) {
        switch (this.data.status) {
          case 1:
            this.title = '待付款'
            break
          case 2:
            this.title = '待发货'
            break
          case 3:
            this.title = '待收货'
            break
          case 4:
            this.title = '已完成'
            break
          case 5:
            this.title = '已关闭'
            break
          default:
            break
        }
      }
      if (this.data.type === 1) {
        switch (this.data.status) {
          case 0:
            this.title = '待成团'
            break
          case 1:
            this.title = '拼团成功'
            break
          case 1.5:
            this.title = '拼团失败'
            break
          case 2:
            this.title = '待发货'
            break
          case 3:
            this.title = '待收货'
            break
          case 4:
            this.title = '已完成'
            break
          case 5:
            this.title = '已关闭'
            break
          default:
            break
        }
      }
      if (this.data.type === 3) {
        switch (this.data.status) {
          case 1:
            this.title = '审核中'
            break
          case 2:
            this.title = '退款中'
            break
          case 3:
            this.title = '退货中'
            break
          case 4:
            this.title = '退款成功'
            break
          case 5:
            this.title = '退款失败'
            break
          case 6:
            this.title = '审核未通过'
            break
          case 7:
            this.title = '平台评审中'
            break
          case 8:
            this.title = '退货完成，拒绝退款'
            break
          case 9:
            this.title = '已关闭'
            break
          case 10:
            this.title = '审核通过'
            break
          default:
            break
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.orderDetailStatus{
  height: 360px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  nav{
    p{
      color: $mainGlod;
      font-size: 30px;
      font-family: Microsoft YaHei;
    }
  }
  section{
    width: 100%;
    margin: 70px 0;
    display: flex;
    justify-content: center;
    align-items: center;
    .box{
      flex: 1;
      text-align: center;
      img{
          width: 35px;
          height: 35px;
          margin-bottom: 20px;
      }
      p{
          font-size: 14px;
      }
    }
    .defaultSpot{
        flex: 0.5;
        height: 0;
        border-bottom: 8px dotted #CCCCCC;
        span{
            position: relative;
            top: -20px;
        }
    }
  }
  .colorRed{
    color: #C83732;
  }
  .colorGlod{
      color: $mainGlod;
  }
  .glodSpot{
      border-color: $mainGlod !important;
  }
  .redSpot{
      border-color: #C83732 !important;
  }
}
</style>
