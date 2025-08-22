<template>
  <div class="couponPackage">
    <el-tabs v-model="activeName">
      <el-tab-pane :label="'未使用('+notUsedData.length+')'" name="notUsed">
        <div class="couponList" v-if="flag">
          <div class="clearfix sub-main">
            <div class="couponItem active" v-for="(item, index) of notUsedData" :key="index">
              <CouponItem
              :data="item"
              :type="2" :disable="false"/>
            </div>
          </div>
        </div>
        <div class="nothing sub-main" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-coupon-nodata" />
          <p class="fs20 font-color-999">没有该类型的优惠券～</p>
        </div>
      </el-tab-pane>
      <el-tab-pane :label="'已使用('+usedData.length+')'" name="used">
        <div class="couponList" v-if="flag1">
          <div class="clearfix sub-main">
            <div class="couponItem" v-for="(item, index) of usedData" :key="index">
              <CouponItem
                :data="item"
                :isUse="1"
                :disable="true"
              />
            </div>
          </div>
        </div>
        <div class="nothing" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-coupon-nodata" />
          <p class="fs20 font-color-999">没有该类型的优惠券～</p>
        </div>
      </el-tab-pane>
      <el-tab-pane :label="'已失效('+invalid.length+')'" name="invalid">
        <div class="couponList" v-if="flag2">
          <div class="clearfix sub-main">
            <div class="couponItem" v-for="(item, index) of invalid" :key="index">
              <CouponItem :data="item" :isUse="2" :disable="true"/>
            </div>
          </div>
        </div>
        <div class="nothing sub-main" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-coupon-nodata" />
          <p class="fs20 font-color-999">没有该类型的优惠券～</p>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import CouponItem from './couponListSlot.vue'
import {
  getCouponList
} from '@/api/coupon.js'
export default {
  name: 'couponPackage',
  components: {CouponItem},
  data () {
    return {
      activeName: 'notUsed',
      notUsedData: [],
      usedData: [],
      invalid: [],
      flag: true,
      flag1: true,
      flag2: true
    }
  },
  mounted () {
    this.getCouponList(0)
    this.getCouponList(1)
    this.getCouponList(2)
  },
  methods: {
    // 获取优惠券列表
    async getCouponList (stateData) {
      const rLoading = this.openLoading()
      const response = await getCouponList({
        state: stateData
      })
      const res = response.data
      if (res.code === '200') {
        if (stateData === 0) {
          this.notUsedData = res.data
          this.flag = res.data.length
        } else if (stateData === 1) {
          this.usedData = res.data
          this.flag1 = res.data.length
        } else if (stateData === 2) {
          this.invalid = res.data
          this.flag2 = res.data.length
        }
      } else {
        this.$message.warning(res.message)
      }
      rLoading.close()
    }
  }
}
</script>

<style lang="scss" scoped>
.couponPackage {
  border: 1px solid #E5E5E5;
  min-height: 500px;
  >>> .el-tabs__nav-scroll {
    padding-left: 30px;
    .el-tabs__nav {
      height: 60px;
      line-height: 60px;
    }
  }
  // >>> .el-tabs__content {
  //   padding:0 30px;
  // }
  .couponList {
    margin-bottom: 30px;
    padding: 10px;
    .couponItem {
      display: inline-block;
      margin: 0 5px;
      &:nth-child(3n) {
        margin-right: 0;
      }
      .couponItemTop {
        background: #d7d7d7;
        color: #ffffff;
        padding: 20px;
        box-sizing: border-box;
        position: relative;
        img {
          opacity: 0.2;
          position: absolute;
          top: 40%;
        }
        .couponType {
          position: absolute;
          top: 1px;
          right: -33px;
          width: 100px;
          transform: rotate(45deg);
          background: #FFFFFF;
          color: #999999;
          text-align: center;
          height: 40px;
          line-height: 50px;
        }
        span {
          font-size: 12px;
          display: block;
          margin-bottom: 18px;
          cursor: pointer;
          i {
            margin-right: 5px;
            font-style: normal;
            font-size: 16px;
          }
        }
        span:nth-child(2) {
          font-size: 28px;
        }
        span:nth-child(4) {
          margin-bottom: 0;
        }
      }
      .couponItemBot {
        height: 40px;
        line-height: 40px;
        color: #999999;
        position: relative;
        text-align: center;
        background: #FFFFFF;
        cursor: pointer;
      }
    }
    .active {
      .couponItemTop {
        background: #fd5b5b;
        color: #ffffff;
        .couponType {
          background: #FFFFFF;
          color: #fd5b5b;
        }
      }
      .couponItemBot {
        background: #f3f3f3;
        color: #333333;
      }
    }
  }
}
.sub-main{
  min-height: 400px;
}
.nothing{
    width: 100%;
    text-align: center;
    min-height: 400px;
    p{
        margin-bottom: 20px;
    }
    .el-button{
        background-color: #FF7800;
        color: #FFFFFF;
        font-weight: normal;
        border-radius: 0;
    }
}
</style>
