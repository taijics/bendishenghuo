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
        <el-form-item
          class="boxWidth radio-group"
          label="促销类型"
          prop="preheat"
        >
          <div class="item">
            <el-radio
              v-model="addForm.composeType"
              :label="1"
            >直接定价</el-radio>
            <el-input-number
              v-model="promote1"
              :controls="false"
              :max="10000000"
              :min="0.01"
              :precision="2"
            />
            元
          </div>
          <div class="item">
            <el-radio
              v-model="addForm.composeType"
              :label="2"
            >固定减价</el-radio>
            <el-input-number
              v-model="promote2"
              :controls="false"
              :max="10000000"
              :min="0.01"
              :precision="2"
            />
            元
          </div>
          <div class="item">
            <el-radio v-model="addForm.composeType" :label="3">折扣</el-radio>
            <el-input-number
              v-model="promote3"
              :precision="1"
              :min="1"
              :max="9.9"
              :step="0.1"
            />折
          </div>
        </el-form-item>
        <el-form-item class="applyType" label="活动商品" prop="commodity">
          <span
            class="selectBtn"
            @click="chooseProduct"
          >请选择<i
            v-if="addForm.composeProducts.length !== 0"
            class="selectNum"
          >{{ addForm.composeProducts.length }}</i></span>
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
      <el-button
        type="primary"
        @click="composeAdd('ruleForm')"
      >保 存</el-button>
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
            <el-input
              v-model="proOption.search"
              maxlength="20"
              placeholder="请输入商品名称"
            />
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
import { composeAdd, composeUpate, getComposeDetail, getComposeSelectProduct } from '@/api/marketing'
import { getClassifyGetAll } from '@/api/commodity'
function InitComposeForm() {
  this.composeProducts = [] // 商品明细数据
  this.composeName = '' // 活动名称
  this.composeType = 1
  this.startTime = '' // 活动开始时间
  this.endTime = '' // 活动结束时间
}
export default {
  name: 'AddGroupBuy',
  props: {
    composeId: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      // 新增
      getRowKeys(row) {
        return row.skuId
      },
      addForm: new InitComposeForm(),
      promote1: '',
      promote2: '',
      promote3: '',
      proOption: {
        page: 1,
        pageSize: 10
      },
      details: [],
      dateInfo: [], // 时间数组
      total: 0,
      tableData: [],
      selectTableData: [],
      groupBuyRules: {
        composeName: [
          { required: true, message: '请输入活动名称', trigger: 'blur' }
        ]
      },
      multipleSelection: [],
      isVisible: false // 选择商品弹窗
    }
  },
  watch: {
    composeId: {
      handler(nVal, oVal) {
        this.addForm.composeId = nVal
        if (!nVal) {
          this.addForm = new InitComposeForm()
          this.dateInfo = []
          this.promote1= ''
          this.promote2= ''
          this.promote3= ''
          this.selectTableData = []
        }else{
          this.addForm.composeProducts = []
          this.getComposeInfo()
        }
      }
    }
  },
  mounted() {
    if (this.composeId) {
      this.addForm.composeId = this.composeId
      this.getComposeInfo()
    }
  },
  methods: {
    resetData(){
      if(this.composeId === 0){
        this.addForm = new InitComposeForm()
        this.dateInfo = []
        this.promote1= ''
        this.promote2= ''
        this.promote3= ''
        this.selectTableData = []
      }
    },
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
    composeAdd(ruleForm) {
      if (this.addForm.composeProducts.length === 0) {
        this.$message.warning('请选择组合捆绑活动商品')
      } else {
        this.$refs[ruleForm].validate((valid) => {
          if (valid) {
            switch (this.addForm.composeType) {
              case 1:
                if (this.promote1) {
                  this.addForm.promote = this.promote1
                } else {
                  this.$message.warning('请填写促销类型的输入框内容')
                  return false
                }
                break
              case 2:
                if (this.promote2) {
                  this.addForm.promote = this.promote2
                } else {
                  this.$message.warning('请填写促销类型的输入框内容')
                  return false
                }
                break
              case 3:
                if (this.promote3) {
                  this.addForm.promote = this.promote3
                } else {
                  this.$message.warning('请填写促销类型的输入框内容')
                  return false
                }
                break
            }
            this.addForm.startTime = this.dateInfo[0]
            this.addForm.endTime = this.dateInfo[1]
            if (this.addForm.composeId) {
              composeUpate(this.addForm).then((res) => {
                if (res.code === '') {
                  this.$message.success('修改成功')
                  this.$emit('reset')
                } else {
                  this.$message.error(res.message)
                }
              })
            } else {
              composeAdd(this.addForm).then((res) => {
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
      }
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
      var _this = this
      console.log(this.multipleSelection, 'multipleSelection')
      if (this.multipleSelection.length > 5) {
        this.$message({
          message: '组合捆绑最多5个一组',
          type: 'warning'
        })
        return false
      }
      this.selectTableData = this.multipleSelection
      this.multipleSelection.forEach((i) => {
        idList.push({
          composeId: _this.addForm.composeId,
          productId: i.productId
        })
      })
      this.addForm.composeProducts = idList
      this.isVisible = false
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    // 跳转秒杀列表
    goToList() {
      this.$emit('reset')
    },
    async getComposeInfo() {
      var _this = this
      const res = await getComposeDetail({ composeId: this.addForm.composeId })
      // console.log(res,'res')
      // const dataList = []
      // res.data.composeProducts.forEach(item=>{
      //   dataList.push({
      //     composeId: res.data.composeId,
      //     productId: item.productId
      //   })
      // })
      // console.log(dataList,'dataList')
      // this.addForm.composeProducts = []
      // this.addForm.composeProducts = dataList
      this.addForm.composeName = res.data.composeName
      this.addForm.startTime = res.data.startTime
      this.addForm.endTime = res.data.endTime
      this.addForm.composeType = res.data.composeType
      switch (this.addForm.composeType) {
        case 1:
          this.promote1 = res.data.promote
          break
        case 2:
          this.promote2 = res.data.promote
          break
        case 3:
          this.promote3 = res.data.promote
          break
      }
      this.selectTableData = res.data.composeProducts.map((item) => {
        item.productImage = item.image
        item.section = item.sectionPrice
        return item
      })
      console.log(this.selectTableData,'this.selectTableData')
      this.selectTableData.forEach((i) => {
        this.addForm.composeProducts.push({
          productId: i.productId,
          composeId: _this.addForm.composeId
        })
      })
      this.dateInfo = [this.addForm.startTime, this.addForm.endTime]
    },
    // 删除产品
    delProduct(row) {
      var curIndex = 0
      this.addForm.composeProducts.forEach((item, index) => {
        if (item.productId === row.productId) {
          curIndex = index
        }
      })
      this.addForm.composeProducts.splice(curIndex, 1)
      this.selectTableData.splice(curIndex, 1)
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
  width: 180px;
  margin-right: 15px;
}
.boxWidth /deep/ .el-input-number {
  width: 180px;
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
