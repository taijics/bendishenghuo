<template>
  <div class="myOrder">
    <div class="top">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="所有订单" name="first">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="待付款" name="second">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="待发货" name="third">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="待收货" name="fourth">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="待评价" name="fifth">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="待成团" name="sixth">
          <div class="sub-main" v-loading="loading">
            <OrderList
              :flag="flag"
              :orderList="orderList"
              :total="total" :page="page"
              @isCancel="isCancel"
              @isDelete="isDelete"
              @isConfirm="isConfirm"
              @isRefund="isRefund"
              @handleCurrentChange="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
      <div class="search">
        <el-input placeholder="商品名称/订单号" v-model="keyword" class="input-with-select" />
        <i class="el-icon-search" @click="searchOrder" />
      </div>
      <!-- 取消 -->
      <el-dialog
        class="cancelOrder"
        :visible.sync="cancelOrderShow"
        close-on-click-modal
        :before-close="handleClose1"
        width="50%"
        title="是否取消该订单"
        center>
        <div>
          <p>您确定要取消该订单吗？取消订单后，不能恢复。</p>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button class="leftBtn" @click="handleClose1">取消</el-button>
          <el-button class="rightBtn" @click="cancelOrder"  v-throttle>确定</el-button>
        </span>
      </el-dialog>
      <!-- 删除 -->
      <el-dialog
        class="cancelOrder"
        :visible.sync="deleteOrderShow"
        close-on-click-modal
        :before-close="handleClose3"
        width="500px"
        title="是否删除该订单"
        center>
        <div>
          <p>您确定要删除该订单吗？删除订单后，不能恢复。</p>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button class="leftBtn" @click="handleClose3">取消</el-button>
          <el-button class="rightBtn" @click="deleteOrder"  v-throttle>确定</el-button>
        </span>
      </el-dialog>
      <!-- 收货 -->
      <el-dialog
        class="confirm"
        :visible.sync="confirmShow"
        close-on-click-modal
        :before-close="handleClose2"
        width="500px"
        title="是否确认收货"
        center>
        <div>
          <p>为了保证您的售后权益，请收到商品检查无误后再确认收货</p>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button class="leftBtn" @click="handleClose2">取消</el-button>
          <el-button class="rightBtn" @click="confirm"  v-throttle>确定</el-button>
        </span>
      </el-dialog>
      <!-- 选择售后 -->
      <el-dialog
        class="refund"
        :visible.sync="refund"
        width="50%"
        :before-close="handleClose"
        title="请选择售后商品"
        center>
        <div>
          <div class="mar-bot-20 fs18">
            <el-checkbox @change="changeBox" v-model="checked">全选</el-checkbox>
          </div>
          <div class="box">
            <div class="back cur-poi"
            :class="productIds.indexOf(item.skuId)!=-1?'backActive':''" @click="select(item)"
            v-for="(item,index) in backList" :key="index">
              <img class="mar-bot-10" :src="item.image" alt="">
              <p style="text-align: left;" class="mar-bot-10 fs14">{{item.productName}}</p>
              <div class="mar-bot-10 fs14 font-color-999">
                <span v-for="(val,inx) in item.values" :key="inx">{{val}}</span>
              </div>
              <p class="mar-bot-20 fs14 font-color-999">x{{item.number}}</p>
              <p style="color: #C83732;">¥{{item.price}}</p>
              <icon-svg class="choice" icon-class="success" style="color: #C5AA7B;" />
            </div>
          </div>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button class="leftBtn" @click="handleClose">取消</el-button>
          <el-button class="rightBtn" @click="toAfterSale"  v-throttle>确定</el-button>
        </span>
      </el-dialog>
    </div>
  </div>
</template>
<script>
import OrderList from '@/components/base/orderList'

import {
  getOrderList,
  orderConfirm,
  orderCancel,
  orderDelete
} from '@/api/user/order.js'
export default {
  components: {
    OrderList
  },
  name: 'myOrder',
  data () {
    return {
      orderList: [], // 订单状态 1-待付款 2-待发货 3-待收货 4-已完成 5-已取消I
      page: 1,
      activeName: 'first',
      keyword: '',
      state: '',
      cancelOrderShow: false,
      refund: false,
      index: null,
      cancelId: null,
      confirmId: null,
      confirmShow: false,
      deleteId: null,
      deleteOrderShow: false,
      checked: false,
      orderData: {},
      total: 0,
      backList: [],
      productIds: [],
      productData: [],
      flag: true,
      loading: false
    }
  },
  mounted () {
    this.getOrderList()
  },
  methods: {
    // 获取订单列表
    async getOrderList () {
      this.loading = true
      const response = await getOrderList({
        search: this.keyword,
        state: this.state,
        page: this.page,
        pageSize: 5
      })
      const res = response.data
      if (res.code === '200') {
        this.orderList = res.data.list
        this.total = res.data.total
        if (this.state === '4') {
          const temp = []
          this.orderList.map((item) => {
            if (item.ifNotComment === 1) {
              temp.push(item)
            }
          })
          this.orderList = temp
        }
        this.orderList.forEach(i => {
          let flag = false
          i.skus.forEach(j => {
            if (j.ifAfter) {
              flag = true
            }
          })
          this.$set(i, 'ifAfter', flag ? 1 : 0)
        })
        if (this.orderList.length) {
          this.flag = true
        } else {
          this.flag = false
        }
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    // 搜索订单
    searchOrder () {
      this.activeName = 'first'
      this.state = ''
      this.page = 1
      this.getOrderList()
    },
    // 取消订单
    async cancelOrder () {
      const response = await orderCancel({ orderId: this.cancelId })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('订单取消成功')
        this.cancelOrderShow = false
        this.getOrderList()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 删除订单
    async deleteOrder () {
      const response = await orderDelete({ orderId: this.deleteId })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('订单删除成功')
        this.deleteOrderShow = false
        this.getOrderList()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 确认收货
    async confirm () {
      const response = await orderConfirm({ orderId: this.confirmId })
      const res = response.data
      if (this.code === '200') {
        this.$message.success('确认收货成功')
        this.confirmShow = false
        this.getOrderList()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 打开确认收货弹窗
    isConfirm (id) {
      this.confirmId = id
      this.confirmShow = true
    },
    // 打开删除订单弹窗
    isDelete (id) {
      this.deleteOrderShow = true
      this.deleteId = id
      // console.log(id)
    },
    // 切换订单列表
    handleClick (event) {
      console.log(event.index, 'index')
      if (event.index === '0') {
        this.state = ''
      } else {
        if (event.index === '5') {
          this.state = 6
        } else {
          this.state = event.index
        }
      }
      this.keyword = ''
      this.page = 1
      this.getOrderList()
    },
    // 打开取消订单弹窗
    isCancel (id) {
      this.cancelOrderShow = true
      this.cancelId = id
    },
    // 关闭退货弹窗
    handleClose () {
      this.backList = []
      this.checked = false
      this.productIds = []
      this.refund = false
    },
    // 关闭删除订单弹窗
    handleClose3 () {
      this.deleteOrderShow = false
      this.deleteId = null
    },
    // 关闭取消订单弹窗
    handleClose1 () {
      this.cancelOrderShow = false
      this.cancelId = null
    },
    // 关闭确认收货弹窗
    handleClose2 () {
      this.confirmShow = false
      this.confirmId = null
    },
    // 打开退货弹窗
    isRefund (data) {
      if (data.skus.length === 1) {
        this.$router.push({
          path: '/afterSale',
          query: {
            orderData: JSON.stringify(data),
            state: 1
          }
        })
        return
      }
      let temp = []
      data.skus.forEach(i => {
        if (i.ifAfter) {
          temp.push(i)
        }
      })
      this.backList = temp // 全选判断
      this.orderData = data
      this.refund = true
    },
    // 选择退货商品
    select (item) {
      if (this.productIds.indexOf(item.skuId) === -1) {
        this.productIds.push(item.skuId)
      } else {
        this.productIds.splice(this.productIds.indexOf(item.skuId), 1)
      }
      if (this.productIds.length === this.backList.length) {
        this.checked = true
      } else {
        this.checked = false
      }
    },
    changeBox (val) {
      if (val) {
        this.productIds = []
        this.backList.map((item) => {
          this.productIds.push(item.skuId)
        })
      } else {
        this.productIds = []
      }
    },
    // 跳转到申请售后页面
    toAfterSale () {
      if (this.productIds.length === 0) {
        return this.$message.warning('请先选择需要申请售后的商品')
      }
      var productData = []
      for (var k in this.productIds) {
        for (var i in this.orderData.skus) {
          if (this.orderData.skus[i].skuId === this.productIds[k]) {
            productData.push(this.orderData.skus[i])
          }
        }
      }
      var paramsData = this.orderData
      paramsData.skus = productData
      this.$router.push({
        path: '/afterSale',
        query: {
          orderData: JSON.stringify(paramsData),
          state: 1
        }
      })
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.page = val
      this.getOrderList()
    }
  }
}
</script>
<style lang="scss" scoped>
$navBarHeight: 50px;
.myOrder{
  width: 100%;
  .top{
    width: 100%;
    font-size: 14px;
    box-sizing: border-box;
    position: relative;
    >>>.el-tabs{
      .el-tabs__header{
        background-color: #FAFAFA;
        // border: 1px solid #E5E5E5;
        margin-bottom: 15px;
        height: $navBarHeight;
      }
      .el-tabs__nav{
        margin-left: 20px;
        height: $navBarHeight;
      }
      .el-tabs__item{
        height: $navBarHeight;
        line-height: $navBarHeight;
      }
      .el-tabs__nav-wrap::after{
        height: 0;
      }
    }
    .search{
      width: 280px;
      font-size: 12px;
      margin-right: 20px;
      display: flex;
      height: $navBarHeight;
      // display: flex;
      // align-items: center;
      position: absolute;
      top: 0;
      right: 0;
      i{
        font-size: 24px;
        position: absolute;
        top: 8px;
        right: 8px;
        cursor: pointer;
      }
      >>>.el-input{
        width: 100%;
        // flex: 3;
        border-radius: 0;
        .el-input__inner{
          border-radius: 0;
        }
        .el-input-group__append{
          border-radius: 0;
          border-left: 0;
          .el-button{
            border-left: 0;
          }
        }
      }
      .el-select{
        flex: 1;
        border-radius: 0;
        height: 40px;
      }
    }
  }
  >>>.cancelOrder,.confirm{
    .el-dialog__body{
      display: flex;
      justify-content: center;
      div{
        text-align: center;
        p{
          font-size: 16px;
        }
      }
    }
    .el-dialog__footer{
      .leftBtn{
        background-color: #F3F4F5;
        color: #333333;
        border-radius: 0;
      }
      .rightBtn{
        color: $mainGlod;
        background-color: #333;
        box-sizing: border-box;
        border-radius: 0;
      }
    }
  }
  >>>.refund{
    .el-dialog__body{
      display: flex;
      justify-content: center;
      background-color: #F8F8F8;
      padding: 20px 75px;
      box-sizing: border-box;
      .box{
        display: flex;
        flex-wrap: wrap;
        overflow-x: auto;
        height: 350px;
        width: 100%;
        text-align: center;
      }
      .el-checkbox{
        display: flex;
        align-items: center;
      }
      .el-checkbox__input{
        line-height: 18px;
      }
      .el-checkbox__label{
        font-size: 18px;
      }
      .back{
        width: 208px;
        padding: 10px 20px;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        text-align: center;
        flex-direction: column;
        background-color: #FFFFFF;
        margin: 0 20px 20px 0;
        border: 1px solid transparent;
        position: relative;
        img{
          width: 171px;
          height: 171px;
        }
        .choice{
          width: 30px;
          height: 30px;
          position: absolute;
          bottom: 10px;
          right: 10px;
          display: none;
        }
      }
      .back:nth-of-type(3n){
        margin-right: 0;
      }
      .backActive{
        border: 1px solid $mainGlod;
        .choice{
          display: block;
        }
      }
    }
    .el-dialog__footer{
      .leftBtn{
        background-color: #F3F4F5;
        color: #333;
        border-radius: 0;
      }
      .rightBtn{
        color: $mainGlod;
        background-color: #333;
        box-sizing: border-box;
        border-radius: 0;
      }
    }
  }
}
.sub-main{
  min-height: 400px;
}
</style>
