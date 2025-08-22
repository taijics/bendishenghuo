<!--
    * @FileDescription: selectChannelCoupons
    * @Author: kahu
    * @Date: 2022/8/25
    * @LastEditors: kahu
    * @LastEditTime: 2022/8/25
-->
<template>
  <el-dialog
    :close-on-click-modal="false"
    title="选择渠道优惠券"
    :visible.sync="diaShow"
    width="60%"
    append-to-body
    :before-close="handleClose"
  >
    <div class="content">
      <div class="content pending">
        <div class="formSearch">
          <el-form
            :inline="true"
            :model="formInline"
            class="demo-form-inline"
          >
            <el-form-item label="优惠券名称">
              <el-input
                v-model="formInline.couponName"
                maxlength="20"
                clearable
                placeholder="请输入内容"
                @blur="search"
              />
            </el-form-item>
            <el-form-item label="优惠券类型">
              <el-select
                v-model="formInline.couponType"
                placeholder="请选择优惠券类型"
                @change="search"
              >
                <el-option
                  label="全部"
                  :value="null"
                />
                <el-option
                  label="满减券"
                  value="1"
                />
                <el-option
                  label="折扣券"
                  value="2"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="状态">
              <el-select
                v-model="formInline.state"
                placeholder="请选择优惠券状态"
                @change="search"
              >
                <el-option
                  label="全部"
                  :value="null"
                />
                <el-option
                  label="未开始"
                  value="0"
                />
                <el-option
                  label="进行中"
                  value="1"
                />
                <el-option
                  label="已结束"
                  value="2"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="创建时间">
              <el-date-picker
                v-model="formInline.dates"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                value-format="yyyy-MM-dd HH:mm:ss"
                @change="search"
              />
            </el-form-item>
            <el-form-item>
              <el-button
                type="primary"
                plain
                @click="search"
              >查询
              </el-button>
              <el-button
                type="primary"
                plain
                @click="clear"
              >重置
              </el-button>
              <el-button
                type="primary"
                plain
                @click="addActivity"
              >新增
              </el-button>
            </el-form-item>
          </el-form>
        </div>
        <!-- 表格 -->
        <div class="tableBox">
          <el-table
            ref="multipleTable"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
            :row-key="row=>row.shopCouponId"
            @selection-change="handleTableSelection"
          >
            <el-table-column
              type="selection"
              reserve-selection
            />
            <el-table-column
              label="优惠券名称"
              width="220"
            >
              <template slot-scope="scope">{{ scope.row.couponName }}</template>
            </el-table-column>
            <el-table-column
              label="类型"
              show-overflow-tooltip
            >
              <template slot-scope="scope">
                <span v-if="scope.row.couponType === 1">满减券</span>
                <span v-if="scope.row.couponType === 2">折扣券</span>
              </template>
            </el-table-column>
            <el-table-column
              label="状态"
              show-overflow-tooltip
            >
              <template slot-scope="scope">
                <span v-if="scope.row.state === 0">未开始</span>
                <span v-if="scope.row.state === 1">进行中</span>
                <span v-if="scope.row.state === 2">已结束</span>
              </template>
            </el-table-column>
            <el-table-column
              prop="content"
              label="内容"
              show-overflow-tooltip
            />
            <el-table-column
              prop="createTime"
              label="创建时间"
              show-overflow-tooltip
            />
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="formInline.page"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="10"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>
    </div>

    <span
      slot="footer"
      class="dialog-footer"
    >
      <el-button @click="handleClose">取 消</el-button>
      <el-button
        type="primary"
        @click="handleConfirm"
      >确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
import { getCoupon, delCoupon, getCouponData, stopCoupon } from '@/api/marketing'
import activityMixin from '@/views/marketing/mixin/index.js'

function CouponQueryForm() {
  this.type = 2
  this.couponName = '' // 优惠券名称
  this.couponType = null // 优惠券类型
  this.dates = [] // 创建时间数组
  this.endTime = '' // 创建时间结束时间
  this.page = 1 // 当前页
  this.pageSize = 10 // 每页记录数
  this.startTime = '' // 创建时间开始时间
  this.state = '1' // 优惠券状态
  this.takeEnd = '2022-01-01 00:00:00' // 活动结束时间
  this.stockNumber = 1 // 库存限制
}

export default {
  name: 'ChannelManage',
  mixins: [activityMixin],
  model: {
    prop: 'showSelect',
    event: 'change'
  },
  props: {
    showSelect: {
      type: Boolean,
      default: () => false
    },
    defaultSelection: {
      type: Array,
      default() { return [] }
    },
    takeEnd: {
      type: String,
      default: () => '2022-01-01 00:00:00'
    },
    stockNumber: {
      type: Number,
      default: () => 1
    }
  },
  data() {
    return {
      formInline: new CouponQueryForm(),
      isDataVisible: false, // 数据效果展示
      dataInfo: [], // 商品使用数据
      total: 1,
      tableData: [],
      dataEffect: [],
      selection: [],
    }
  },
  computed: {
    diaShow: {
      get() {
        return this.showSelect
      },
      set(value) {
        this.$emit('change', value)
      }
    },
  },
  watch: {
    'defaultSelection': {
      deep: true,
      handler(val) {
        this.$nextTick(() => {
          this.selection = val
          this.handleManageSelection()
        })
      }
    },
    'diaShow'(val) {
      if (val) {
        this.formInline.takeEnd = this.takeEnd
        this.formInline.stockNumber = this.stockNumber
        this.getAll(this.formInline)
      } else {
        this.tableData = []
      }
    }
  },
  mounted() {
    // this.getAll(this.formInline)
  },
  methods: {
    handleManageSelection() {
      // 清空所有选中
      this.$refs.multipleTable?.clearSelection()
      this.tableData.forEach(tableData => {
        const find = this.defaultSelection.find(item => item.shopCouponId === tableData.shopCouponId);
        if (find) {
          // 勾选指定行
          this.$nextTick(() => {
            this.$refs.multipleTable.toggleRowSelection(tableData, true)
          })
        }
      })
    },
    handleTableSelection(selection) {
      this.selection = selection
    },
    handleClose() {
      this.$emit('cancel', this.selection)
      this.selection = []
      this.diaShow = false
    },
    handleConfirm() {
      this.$emit('confirm', this.selection)
      this.selection = []
      this.diaShow = false
    },

    closeModal() {
      this.$refs.addCoupon.resetData()
    },
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      if (this.formInline.dates && this.formInline.dates.length !== 0) {
        this.formInline.startTime = this.formInline.dates[0]
        this.formInline.endTime = this.formInline.dates[1]
      } else {
        delete (this.formInline.startTime)
        delete (this.formInline.endTime)
      }
      this.getAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = new CouponQueryForm()
      this.formInline.takeEnd = this.takeEnd
      this.formInline.stockNumber = this.stockNumber
      this.getAll(this.formInline)
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    // 停止优惠券活动
    stopFn(id) {
      stopCoupon({ shopCouponId: id }).then(res => {
        if (res.code === '') {
          this.$message.success('停止成功')
          this.formInline.page = 1
          this.getAll(this.formInline)
        } else {
          this.$message.error(res.message)
        }
      })
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getCoupon(formInline)
      this.total = res.data.total
      this.tableData = res.data.list
      this.handleManageSelection()
    },
    // 显示数据效果
    showData(id) {
      getCouponData({ shopCouponId: id }).then(res => {
        if (res.code === '') {
          this.dataInfo = res.data
        } else {
          this.$message.error(res.message)
        }
      })
      this.isDataVisible = true
    },
    // 删除优惠券
    delCouponFn(data) {
      delCoupon({ shopCouponId: data.shopCouponId }).then(res => {
        if (res.code === '') {
          this.$message.success('删除成功')
          this.formInline.page = 1
          this.getAll(this.formInline)
        } else {
          this.$message.error(res.message)
        }
      })
    }
  }
}
</script>

<style
  lang="scss"
  scoped
>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");

.pending {
  padding: 30px;
}

.fenye {
  margin-top: 20px;
}

.dataEffect {
  .couponTit {
    margin: 20px 0;
  }

  .dataListBox {
    display: flex;
    justify-content: center;
    margin: 30px 0;

    .dataItem {
      width: 220px;
      height: 120px;
      border-radius: 8px;
      border: 1px solid #999999;
      text-align: center;
      margin: 0 10px;

      span {
        display: block;
        margin-top: 35px;
      }
    }
  }

  .tabListInfo {
    margin: 20px 0;
  }
}
</style>
<style scoped>
.btnList /deep/ .delCls {
  margin-left: 10px;
}

.group-dialog /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
</style>
