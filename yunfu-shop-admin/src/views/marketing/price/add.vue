<template>
  <div class="addGroupBuy">
    <!-- 新增用户 -->
    <div class="addGroupBuyBox">
      <el-form
        ref="ruleForm"
        class="formBox"
        :model="addForm"
        label-width="150px"
        :rules="groupBuyRules"
      >
        <div class="flexBox">
          <el-form-item label="活动名称" prop="composeName">
            <el-input
              v-model="addForm.composeName"
              maxlength="15"
              placeholder="请输入活动名称"
              oninput="value=value.replace(/\s+/g, '')"
            />
          </el-form-item>
        </div>
        <el-form-item class="timeDataBox" label="活动时间">
          <div class="dateBox">
            <el-form-item>
              <el-date-picker
                v-model="dateInfo"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                value-format="yyyy-MM-dd HH:mm:ss"
                @change="changeDate"
              />
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item class="priceRules" label="优惠规则">
          <div v-for="(item, index) in priceRules" :key="index" class="item">
            <div class="group">
              任选
              <el-input-number
                v-model="item.number"
                :max="100"
                :min="2"
                :precision="0"
                :step="1"
              />
              件
            </div>
            <div class="group">
              捆绑价
              <el-input-number
                v-model="item.price"
                :controls="false"
                :max="10000000"
                :min="0.01"
                :precision="2"
              />
              元
            </div>
            <div v-if="index !== 0" class="btnDel">
              <el-button
                type="primary"
                icon="el-icon-delete"
                @click="delRow(index)"
              />
            </div>
          </div>
          <div class="btnAdd">
            <el-button type="primary" @click="addRow">添加层级</el-button>
          </div>
        </el-form-item>
        <el-form-item class="applyType" label="活动商品" prop="commodity">
          <span
            class="selectBtn"
            @click="chooseProduct"
          >请选择<i
            v-if="addForm.priceProducts.length !== 0"
            class="selectNum"
          >{{ addForm.priceProducts.length }}</i></span>
          <div class="selecTable">
            <el-table
              :data="selectTableData"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 100%"
            >
              <el-table-column
                prop="productId"
                label="商品id"
                show-overflow-tooltip
              />
              <el-table-column label="商品主图" width="150" align="center">
                <template slot-scope="scope">
                  <img
                    height="80"
                    width="80"
                    :src="scope.row.productImage"
                    alt
                    srcset
                  >
                </template>
              </el-table-column>
              <el-table-column
                prop="productName"
                label="商品名称"
                width="220"
              />
              <el-table-column
                prop="section"
                label="售价区间"
                show-overflow-tooltip
              />
              <el-table-column
                prop="stockNumber"
                label="库存"
                width="120"
                show-overflow-tooltip
              />
              <el-table-column label="操作" show-overflow-tooltip>
                <template slot-scope="scope">
                  <div class="btnList">
                    <el-popconfirm
                      title="确定删除此活动？"
                      @onConfirm="delProduct(scope.row)"
                    >
                      <el-button
                        slot="reference"
                        class="delCls"
                        type="text"
                      >删除</el-button>
                    </el-popconfirm>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-form-item>
      </el-form>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button type="primary" @click="priceAdd('ruleForm')">保 存</el-button>
      <el-button type="danger" @click="goToList">取 消</el-button>
    </span>
    <!-- 新建分组弹框 -->
    <el-dialog
      title="选择商品"
      :visible.sync="isVisible"
      width="55%"
      top="50px"
      class="group-dialog"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="formSearch">
        <el-form :inline="true" :model="proOption" class="demo-form-inline">
          <el-form-item label="商品名称">
            <el-input v-model="proOption.search" maxlength="20" placeholder="请输入商品名称" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="getProList">查询</el-button>
            <el-button type="primary" @click="clear">重置</el-button>
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
          :row-key="getRowKeys"
          max-height="600"
          @selection-change="handleSelectionChange"
        >
          <el-table-column
            type="selection"
            :reserve-selection="true"
            width="55"
          />
          <el-table-column
            prop="productId"
            label="商品id"
            show-overflow-tooltip
          />
          <el-table-column label="商品主图" width="150" align="center">
            <template slot-scope="scope">
              <img
                height="80"
                width="80"
                :src="scope.row.productImage"
                alt
                srcset
              >
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="商品名称" width="220" />
          <el-table-column
            prop="section"
            label="售价区间"
            show-overflow-tooltip
          />
          <el-table-column
            prop="stockNumber"
            label="库存"
            width="120"
            show-overflow-tooltip
          />
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="proOption.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="proOption.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
        <div class="footBtnBox">
          <span slot="footer">
            <el-button type="primary" @click="saveIdList">确 定</el-button>
            <el-button @click="closeSelect">取 消</el-button>
          </span>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { priceAdd, priceUpate, getPriceDetail, getComposeSelectProduct } from '@/api/marketing'
// import { getClassifyGetAll } from '@/api/commodity'

function InitPriceForm() {
  this.priceProducts = [] // 商品明细数据
  this.composeName = '' // 活动名称
  this.priceType = 1
  this.startTime = '' // 活动开始时间
  this.endTime = '' // 活动结束时间
}
export default {
  name: 'AddGroupBuy',
  props: {
    priceId: {
      type: Number,
      default: 0
    }
  },
  data() {
    const validLanguage = (rule, value, callback) => {
      if (value === '' || value === undefined || value === null) {
        callback(new Error('请输入活动名称'))
      } else {
        // 判断是否为中文字符
        if ((!/^[\u4e00-\u9fa5]+$/.test(value)) && value.length > 60) {
          callback(new Error('请在60个英文字符内'))
        } else if (value.length > 30) {
          callback(new Error('请在30个中文字符内'))
        } else {
          callback()
        }
      }
    }
    return {
      // 新增
      getRowKeys(row) {
        return row.skuId
      },
      addForm: new InitPriceForm(),
      proOption: {
        page: 1,
        pageSize: 10
      },
      priceRules: [
        {
          number: 0,
          price: 0
        }
      ], // 优惠规则列
      details: [],
      dateInfo: [], // 时间数组
      total: 0,
      tableData: [],
      selectTableData: [],
      groupBuyRules: {
        composeName: [
          { required: true, validator: validLanguage, trigger: 'blur' }
          // {
          //   min: 2,
          //   max: 30,
          //   message: "长度在 2 到 30 个字符",
          //   trigger: "blur",
          // },
        ]
      },
      multipleSelection: [],
      isVisible: false // 选择商品弹窗
    }
  },
  watch: {
    priceId: {
      handler(nVal, oVal) {
        this.addForm.priceId = nVal
        if (!nVal) {
          this.addForm = new InitPriceForm()
          this.dateInfo = []
          this.priceRules = []
          this.selectTableData = []
        } else {
          this.addForm.priceProducts = []
          this.getPriceInfo()
        }
      }
    }
  },
  mounted() {
    if (this.priceId) {
      this.addForm.priceId = this.priceId
      this.getPriceInfo()
    }
  },
  methods: {
    changeDate(e) {
      var startTime = Date.parse(e[1])
      var timestamp = Date.parse(new Date())
      if (startTime < timestamp) {
        this.dateInfo = []
        this.$message.warning('活动结束时间不能小于当前时间')
      }
    },
    clear() {
      this.proOption.search = ''
      this.getProList()
    },
    priceAdd(ruleForm) {
      this.$refs[ruleForm].validate((valid) => {
        if (valid) {
          this.addForm.startTime = this.dateInfo[0]
          this.addForm.endTime = this.dateInfo[1]
          this.addForm.priceRules = this.priceRules
          if (this.addForm.priceId) {
            priceUpate(this.addForm).then((res) => {
              if (res.code === '') {
                this.$message.success('修改成功')
                this.$emit('reset')
              } else {
                this.$message({
                  message: res.message,
                  type: 'error'
                })
              }
            })
          } else {
            priceAdd(this.addForm).then((res) => {
              if (res.code === '') {
                this.$message.success('提交成功')
                this.$emit('reset')
              } else {
                this.$message.error(res.message)
              }
            })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    handleSizeChange(val) {
      this.proOption.pageSize = val
      this.getProList()
    },
    handleCurrentChange(val) {
      this.proOption.page = val
      this.getProList()
    },
    // 选择商品
    chooseProduct(type) {
      this.getProList()
      this.isVisible = true
    },
    // 获取可以选择捆绑的商品
    getProList() {
      getComposeSelectProduct(this.proOption).then((res) => {
        if (res.code === '') {
          this.tableData = res.data.list
          this.total = res.data.total
          for (let i = 0; i < this.tableData.length; i++) {
            for (let j = 0; j < this.selectTableData.length; j++) {
              if (this.tableData[i].productId === this.selectTableData[j].productId) {
                this.$refs.multipleTable.toggleRowSelection(this.tableData[i]);
              }
            }
          }
        }
      })
    },
    // 选中商品
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    // 保存选择商品ID
    saveIdList() {
      const idList = []
      this.selectTableData = this.multipleSelection
      this.multipleSelection.forEach((i) => {
        idList.push({
          priceId: this.addForm.priceId,
          productId: i.productId
        })
      })
      this.addForm.priceProducts = idList
      this.isVisible = false
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    // 跳转列表
    goToList() {
      this.$emit('reset')
    },
    async getPriceInfo() {
      var _this = this
      const res = await getPriceDetail({ priceId: this.addForm.priceId })
      this.addForm.composeName = res.data.composeName
      this.addForm.startTime = res.data.startTime
      this.addForm.endTime = res.data.endTime
      this.addForm.priceType = res.data.priceType
      this.priceRules = res.data.rules
      this.selectTableData = res.data.composeProducts.map((item) => {
        item.productImage = item.image
        item.section = item.sectionPrice
        return item
      })
      this.selectTableData.forEach((i) => {
        this.addForm.priceProducts.push({
          productId: i.productId,
          priceId: _this.addForm.priceId
        })
      })
      this.dateInfo = [this.addForm.startTime, this.addForm.endTime]
    },
    // 删除产品
    delProduct(row) {
      var curIndex = 0
      this.addForm.priceProducts.forEach((item, index) => {
        if (item.productId === row.productId) {
          curIndex = index
        }
      })
      this.addForm.priceProducts.splice(curIndex, 1)
      this.selectTableData.splice(curIndex, 1)
    },
    // 增加行
    addRow() {
      this.priceRules.push({
        number: 0,
        price: 0
      })
    },
    // 删除行
    delRow(index) {
      this.priceRules.splice(index, 1)
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.addGroupBuy {
  background: #ffffff;
  .dialog-footer {
    display: flex;
    justify-content: space-around;
  }
  .formBox {
    .flexBox {
      display: flex;
    }
    .applyType {
      .selectBtn {
        width: 100px;
        height: 30px;
        line-height: 30px;
        background: #66b1ff;
        color: #ffffff;
        text-align: center;
        display: inline-block;
        font-size: 14px;
        margin-right: 30px;
        border-radius: 4px;
        cursor: pointer;
        position: relative;
        i {
          position: absolute;
          right: -10px;
          top: -10px;
          width: 25px;
          height: 25px;
          line-height: 25px;
          background: #ffffff;
          border-radius: 50%;
          border: 1px solid #66b1ff;
          text-align: center;
          color: #409eff;
          font-style: normal;
          font-size: 12px;
        }
      }
    }
  }
  .footBtnBox {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 50px;
  }
  .dateBox {
    display: flex;
    align-items: center;
    .description {
      width: 59px;
      text-align: center;
      display: block;
      font-size: 14px;
      color: #999999;
    }
  }
}
.priceRules {
  .item {
    margin-bottom: 10px;
    .group {
      display: inline-block;
      margin-right: 50px;
      .el-input {
        width: 100px;
      }
    }
    .btnDel {
      display: inline-block;
    }
  }
}
</style>
<style scoped>
.flexBox /deep/ .el-input {
  width: 500px;
}
.inputW /deep/ .el-input {
  width: 100px;
  margin: 0 8px 0 0;
}
.inputW /deep/ .el-input .el-input__inner {
  text-align: center;
}
.inputW /deep/ .el-form-item__error {
  padding-left: 0;
}
.inputW /deep/ .el-checkbox {
  margin-left: 20px;
}
.inputW /deep/ .el-radio {
  margin-left: 30px;
}
.boxWidth /deep/ .el-input {
  width: 100px;
  margin-right: 15px;
}
.boxWidth /deep/ .el-input .el-input__inner {
  text-align: center;
}
.addGroupBuy /deep/ .el-button--primary {
  background: #409eff;
  border-color: #409eff;
}
.addGroupBuy /deep/ .el-dialog__header {
  background-color: #409eff;
}
.addGroupBuy /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #ffffff;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__content {
  display: flex;
  align-items: center;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__label {
}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
input[type="number"] {
  -moz-appearance: textfield;
}

.radio-group .item {
  padding-bottom: 10px;
}
</style>
