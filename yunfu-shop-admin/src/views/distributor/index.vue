<template>
  <div class="topPadding">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="业绩管理" name="first">
        <!-- 点击按钮栏 -->
        <div class="btnList">
          <el-radio-group v-model="radio1" @change="touchBtn">
            <el-radio-button label="1">分销订单</el-radio-button>
            <el-radio-button label="2">分销员业绩</el-radio-button>
            <el-radio-button label="3">分销方案</el-radio-button>
          </el-radio-group>
        </div>
        <Order v-if="radio1 ==='1' && activeName === 'first'" />
        <Humens v-if="radio1 === '2' && activeName === 'first'" />
        <Programme v-if="radio1 === '3' && activeName === 'first'" />
      </el-tab-pane>
      <el-tab-pane label="分销员" name="second">
        <!-- 点击按钮栏 -->
        <div class="btnList">
          <el-radio-group v-model="radio2" @change="touchBtns">
            <el-radio-button label="1">分销员列表</el-radio-button>
            <el-radio-button label="2">待审核信息</el-radio-button>
            <el-radio-button label="3">招募设置</el-radio-button>
          </el-radio-group>
        </div>
        <List v-if="radio2 ==='1' && activeName === 'second'" />
        <Msg v-if="radio2 === '2' && activeName === 'second'" />
        <Sys v-if="radio2 === '3' && activeName === 'second'" />
      </el-tab-pane>
      <el-tab-pane label="客户关系" name="third">
        <div class="btnList">
          <el-radio-group v-model="radio3" @change="touchBtn3">
            <el-radio-button label="1">关系查询</el-radio-button>
            <el-radio-button label="2">关系设置</el-radio-button>
          </el-radio-group>
        </div>
        <PopSearch v-if="radio3 ==='1' && activeName === 'third'" />
        <PopSys v-if="radio3 === '2' && activeName === 'third'" />
      </el-tab-pane>
      <!--<el-tab-pane label="推广设置" name="fourth">
        <div class="btnList">
          <el-radio-group v-model="radio4" @change="touchBtn4">
            <el-radio-button label="1">推广店铺</el-radio-button>
            <el-radio-button label="2">邀请下级</el-radio-button>
          </el-radio-group>
        </div>
        <ShopTen v-if="radio4 ==='1' && activeName === 'fourth'" />
        <Invite v-if="radio4 === '2' && activeName === 'fourth'" />
      </el-tab-pane>-->
    </el-tabs>
  </div>
</template>
<script>
import Order from './achievement/order'
import Humens from './achievement/humens'
import Programme from './achievement/programme'
import List from './personnel/list'
import Msg from './personnel/msg'
import Sys from './personnel/sys'
import PopSearch from './customer/popSearch'
import PopSys from './customer/popSys'
export default {
  components: {
    Order,
    Humens,
    Programme,
    List,
    Msg,
    Sys,
    PopSearch,
    PopSys
  },
  data() {
    return {
      activeName: 'first',
      radio1: '1',
      radio2: '1',
      radio3: '1',
      radio4: '4',
      tableData: [],
      multipleSelection: []
    }
  },
  methods: {
    // 顶部切换
    handleClick(tab, event) {
      this.activeName = tab.name
      this.radio1 = '1'
      this.radio2 = '1'
      this.radio3 = '1'
      this.radio4 = '1'
    },
    // 查询
    onSubmit() {
    },
    touchBtn(index) {
      this.radio2 = index
    },
    touchBtns(index) {
      this.radio2 = index
    },
    touchBtn3(index) {
      this.radio3 = index
    },
    touchBtn4(index) {
      this.radio4 = index
    },

    // 表格选中
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    handleSizeChange(val) {
      this.formParams.pageSize = val
      this.getAll(this.formParams)
    },
    handleCurrentChange(val) {
      this.formParams.page = val
      this.getAll(this.formParams)
    },
    // 查询
    search() {
      this.total = 1
      this.formParams.page = 1
      this.getAll(this.formParams)
    }
  }
}
</script>
<style lang="scss" scope>
@import url("../../styles/elDialog.scss");
.topPadding {
  padding-left: 30px;
}
.seacherBox {
  padding-top: 30px;
}
</style>
