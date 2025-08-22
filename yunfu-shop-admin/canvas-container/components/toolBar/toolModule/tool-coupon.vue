<template>
<div class="tool-coupon">
  <!--<div class="selectMode">-->
    <!--<div>添加优惠券</div>-->
    <!--<el-radio-group class="modeRight" v-model="modeValue" @change="modeChange">-->
      <!--<el-radio label="1">手动添加</el-radio>-->
      <!--<div class="mode2">-->
        <!--<el-radio label="2">自动获取</el-radio>-->
        <!--<el-tooltip class="item" effect="dark" content="系统自动获取仅设置为“公开领取”的店铺优惠券，新创建的券排在前面" placement="bottom">-->
        <!--<span class="iconfont">&#xe60a;</span>-->
        <!--</el-tooltip>-->
      <!--</div>-->
    <!--</el-radio-group>-->
  <!--</div>-->
  <div class="addCouponBox" v-show="couponBtnVisible">
    <div v-if="couponList && couponList.length > 0" class="couponBox">
      <ul>
        <li v-for="(item,index) in couponList" :key="index">
          <h4>{{item.couponName?item.couponName:item.activityName}}</h4>
          <a class="btn-close">
            <i class="icon iconfont icon-close" @click="delCoupon(index)"></i>
          </a>
        </li>
      </ul>
    </div>
    <div class="addCouponBtn" @click="addCoupon">
      <i class="iconfont">&#xe685;</i><span>添加优惠券</span>
    </div>
  </div>
  <el-dialog title="选择优惠券" :visible.sync="couponDialogVisible" width="1000">
    <coupon-select ref="couponSelect"></coupon-select>
    <span slot="footer" class="dialog-footer">
         <el-button @click="couponDialogVisible = false">取 消</el-button>
         <el-button type="primary" @click="couponChanged">确 定</el-button>
      </span>
  </el-dialog>
</div>
</template>

<script>
  import CouponSelect from './coupon-select'
  import { mapGetters, mapMutations } from 'vuex'
  import api from '@@/components/canvasShow/config/api'
  import Cookies from 'js-cookie'
  export default {
    name: 'tool-coupon',
    components: { CouponSelect },
    props: {
      selectedCoupon: {
        type: Array,
        default: () => []
      },
      couponList: {
        type: Array,
        default: () => []
      }
    },
    data () {
      return {
        modeValue: '1', // 添加优惠券方式
        couponBtnVisible: true,
        couponDialogVisible: false
      }
    },
    computed: {
      ...mapGetters([
        'typeId'
      ])
    },
    methods: {
      ...mapMutations({
        setCouponNum: 'SET_COUPONNUM'
      }),
      // 添加优惠券
      addCoupon () {
        let _this=this
        this.couponDialogVisible = true
        // this.$nextTick(function () {
        //   _this.$refs.couponSelect.resetTableData(_this.couponList);
        // })
      },
      // 确定选择
      couponChanged () {
        this.couponDialogVisible = false
        this.couponList = this.$refs.couponSelect.multipleSelection
        this.couponListIds = []
        this.couponList.forEach(item => {
          if(this.typeId===1){
            this.couponListIds.push(item.couponId)
          } else if(this.typeId===3){
            this.couponListIds.push(item.shopCouponId)
          }

        })
        this.$emit('update:couponList', this.couponList)
        this.$emit('update:selectedCoupon', this.couponListIds)
        this.setCouponNum()
      },
      // 删除已选优惠券
      delCoupon (index) {
        this.couponList.splice(index,1)
        this.couponListIds.splice(index,1)
        this.$emit('update:couponList', this.couponList)
        this.$emit('update:selectedCoupon', this.couponListIds)
        this.setCouponNum()
      }
    }
  }
</script>

<style lang="scss" scoped>
.tool-coupon{
  padding-bottom: 20px;
}
.selectMode {
  display: flex;
  justify-content: space-between;
  align-items: center;
  .modeRight {
    display: flex;
    .iconfont{
      cursor: pointer;
    }
  }
  ::v-deep .el-radio {
    margin-right: 0;
  }
  ::v-deep .el-radio__label {
    padding-left: 5px;
  }
  .mode2 {
    margin-left: 10px;
    span {
      font-size: 14px;
      color: #999999;
    }
  }
}
.addCouponBox {
  background: #F6F7F9;
  padding: 10px 13px;
  margin: 20px 0 0;
  .addCouponBtn {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 40px;
    line-height: 40px;
    background: #ffffff;
    font-size: 14px;
    color: $mainColor;
    border: 1px solid $mainColor;
    box-sizing: border-box;
    cursor: pointer;
    i {
      margin-right: 10px;
    }
  }
}

.couponBox {
  display: flex;
  align-items: center;
  justify-content: space-between;
  ul{
    width: 100%;
    li{
      height: 40px;
      line-height: 40px;
      text-indent: 10px;
      position: relative;
      margin-bottom: 10px;
      width: 100%;
      box-shadow: 0 0 4px 0 rgb(10 42 97 / 20%);
      .btn-close{
        position: absolute;
        right: -8px;
        top: -8px;
        line-height: 16px;
        display: none;
        i{
          display: block;
          color: #c3c3c3;
        }
      }
      &:hover .btn-close{
        display: block;
      }
    }
  }
}
</style>
