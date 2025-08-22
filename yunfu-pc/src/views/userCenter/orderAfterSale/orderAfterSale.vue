<template>
  <div class="orderAfterSale">
    <div class="top">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="售后中" name="first">
          <div class="sub-main" v-loading="loading">
            <AftersaleList @handleCurrentChange="handleCurrentChange" v-if="listShow" :afterSaleList="afterSaleList" :total="total" :page="page" />
          </div>
        </el-tab-pane>
        <el-tab-pane label="已完成" name="second">
          <div class="sub-main" v-loading="loading">
            <AftersaleList @handleCurrentChange="handleCurrentChange" v-if="listShow" :afterSaleList="afterSaleList" :total="total" :page="page" />
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>
<script>
import AftersaleList from '@/components/base/aftersaleList.vue'

import {
  getAfterSaleList
} from '@/api/user/afterSale.js'
export default {
  name: 'orderAfterSale',
  components: {
    AftersaleList
  },
  data () {
    return {
      afterSaleList: [],
      activeName: 'first',
      keyword: '',
      page: 1,
      total: 0,
      state: 1,
      listShow: false,
      loading: false
    }
  },
  mounted () {
    this.getAfterSale()
  },
  methods: {
    // 获取售后列表
    async getAfterSale () {
      this.loading = true
      const response = await getAfterSaleList({
        state: this.state,
        page: this.page,
        pageSize: 5
      })
      const res = response.data
      if (res.code === '200') {
        this.afterSaleList = res.data.list
        this.total = res.data.total
        this.listShow = true
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    // 切换列表
    handleClick (event) {
      this.state = Number(event.index) + 1
      this.page = 1
      this.getAfterSale()
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.page = val
      this.getAfterSale()
    }
  }
}
</script>
<style lang="scss" scoped>
.orderAfterSale{
  width: 100%;
  .top{
    width: 100%;
    font-size: 14px;
    box-sizing: border-box;
    position: relative;
    >>>.el-tabs{
      .el-tabs__header{
        border: 1px solid #E5E5E5;
        margin-bottom: 30px;
        height: 56px;
      }
      .el-tabs__nav{
        margin-left: 20px;
        height: 56px;
      }
      .el-tabs__item{
        height: 56px;
        line-height: 56px;
      }
      .el-tabs__nav-wrap::after{
        height: 0;
      }
    }
    >>>.search{
      font-size: 12px;
      margin-right: 20px;
      display: flex;
      position: absolute;
      height: 56px;
      display: flex;
      align-items: center;
      top: 0;
      right: 0;
      .el-input{
        flex: 3;
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
}
.sub-main{
  min-height: 400px;
}
</style>
