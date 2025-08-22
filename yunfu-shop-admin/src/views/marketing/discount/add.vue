<template>
  <div class="addGroupBuy">
    <!-- 新增用户 -->
    <div class="addGroupBuyBox">
      <el-form ref="ruleForm" class="formBox" :model="addForm" label-width="150px" :rules="discountRules" :disabled="visitDetail">
        <div class="flexBox">
          <el-form-item label="活动名称" prop="discountName">
            <el-input v-model="addForm.discountName" maxlength="15" placeholder="请输入活动名称" />
          </el-form-item>
        </div>
        <div class="flexBox">
          <el-form-item label="备注">
            <el-input v-model="addForm.remark" maxlength="200" placeholder="请输入备注" />
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
              />
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item class="boxWidth" label="商品限购" prop="proQuota">
          <el-radio v-model="addForm.ifLimit" label="1">不限购</el-radio>
          <el-radio v-model="addForm.ifLimit" label="2">限购</el-radio>
          <el-input v-model="addForm.limitNumber" maxlength="9" :disabled="addForm.ifLimit === '1'" oninput="value=value.replace(/[^\d]/g,'')" />件/人
        </el-form-item>
        <el-form-item class="boxWidth" label="活动商品限量" prop="proQuota">
          <el-radio v-model="addForm.ifNumber" label="0">不限量</el-radio>
          <el-radio v-model="addForm.ifNumber" label="1">限量</el-radio>
          <el-input v-model="addForm.number" maxlength="9" :disabled="addForm.ifNumber === '0'" oninput="value=value.replace(/[^\d]/g,'')" />件
        </el-form-item>
        <el-form-item class="boxWidth" label="活动预热" prop="enableTime">
          <el-radio v-model="addForm.ifEnable" label="1">停用</el-radio>
          <el-radio v-model="addForm.ifEnable" label="2">启用</el-radio>
          <el-input v-model="addForm.enableTime" maxlength="9" :disabled="addForm.ifEnable === '1'" oninput="value=value.replace(/[^\d]/g,'')" />小时前
        </el-form-item>
        <el-form-item label="优惠券叠加" prop="overlying">
          <el-radio v-model="addForm.ifAdd" label="1">叠加</el-radio>
          <el-radio v-model="addForm.ifAdd" label="0">不叠加</el-radio>
        </el-form-item>
        <el-form-item class="applyType" label="活动商品" prop="commodity">
          <span class="selectBtn" @click="chooseProduct"><span v-if="!visitDetail">请选择</span><span v-else>查看商品</span><i v-if="addForm.details.length !== 0" class="selectNum">{{ addForm.details.length }}</i></span>
        </el-form-item>
      </el-form>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button v-show="!visitDetail" type="primary" @click="addSeckillFn('ruleForm')">保 存</el-button>
      <el-button v-if="visitDetail" type="primary" @click="goToDiscount">取 消</el-button>
      <el-button v-else type="danger" @click="goToDiscount">取 消</el-button>
    </span>
    <!-- 新建分组弹框 -->
    <el-dialog
      :title="visitDetail ? '查看商品' : '选择商品'"
      :visible.sync="isVisible"
      width="55%"
      top="50px"
      class="group-dialog"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
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
            v-if="!visitDetail"
            type="selection"
            :reserve-selection="true"
            width="55"
          />
          <el-table-column label="商品信息" width="150" align="center">
            <template slot-scope="scope">
              <img height="80" width="80" :src="scope.row.image " alt srcset>
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="" />
          <el-table-column prop="originalPrice" label="原价（元）" width="120" />
          <el-table-column prop="value" label="规格" width="120" />
          <el-table-column label="折扣" width="155">
            <template scope="scope">
              <el-input-number v-model="scope.row.discount" :disabled="visitDetail" size="small" :controls="false" :precision="1" :max="9.9" :min="0.1" maxlength="2" @blur="blurInput(scope.row)" />
            </template>
          </el-table-column>
          <el-table-column label="活动价（元）">
            <template slot-scope="scope">
              <span v-if="scope.row.discount < 10 && scope.row.discount !== null && scope.row.discount !== ''">{{ numFilter(scope.row.discount / 10 * scope.row.originalPrice) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="stockNumber" label="库存" width="120" show-overflow-tooltip />
          <!--          <el-table-column width="80" label="操作" show-overflow-tooltip>-->
          <!--            <template slot-scope="scope">-->
          <!--              <div class="btnList">-->
          <!--                <el-popconfirm title="确定删除此活动？" @onConfirm="deleteSeckillFn(scope.row)">-->
          <!--                  <el-button slot="reference" class="delCls" type="text">删除</el-button>-->
          <!--                </el-popconfirm>-->
          <!--              </div>-->
          <!--            </template>-->
          <!--          </el-table-column>-->
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
            <el-button v-if="!visitDetail" type="primary" @click="saveIdList">确 定</el-button>
            <el-button @click="closeSelect">取 消</el-button>
          </span>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getDisProList, addDiscount, discountUpdate, getDiscountDetail } from '@/api/marketing'

function InitDiscountForm() {
  this.details = [] // 商品明细数据
  this.enableTime = null // 预热几小时前
  this.endTime = '' // 折扣活动结束时间
  this.discountName = '' // 折扣活动名称
  this.ifAdd = '1' // 优惠券是否叠加 1-是 0-否
  this.ifEnable = '1' // 秒杀活动预热 1-停用 2-启用
  this.ifLimit = '1' // 商品限购 1-不限购 2-限购
  this.limitNumber = null // 限购几件/人
  this.remark = '' // 备注
  this.ifNumber = '0' // 是否限量
  this.number = null // 限制数量
  this.startTime = '' // 活动开始时间
}
export default {
  name: 'AddGroupBuy',
  props: {
    discountId: {
      type: Number,
      default: 0
    },
    visitDetail: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      // 新增
      getRowKeys(row) {
        return row.skuId
      },
      addForm: new InitDiscountForm(),
      proOption: {
        page: 1,
        pageSize: 10
      },
      dateInfo: [], // 数组时间
      details: [],
      isThreshold: true,
      total: 0,
      tableData: [],
      shopDiscountId: '', // 秒杀ID
      discountRules: {
        discountName: [
          { required: true, message: '请输入活动名称', trigger: 'blur' }
        ]
      },
      multipleSelection: [],
      roleList: [],
      isVisible: false, // 选择商品弹窗
      inputDiscountTableData: [],
      selectionKeys: [],
    }
  },
  watch: {
    discountId: {
      handler(nVal, oVal) {
        this.shopDiscountId = nVal
        if (!nVal) {
          this.dateInfo = []
          this.addForm = new InitDiscountForm()
        } else {
          this.getDiscountInfo()
        }
      }
    }
  },
  mounted() {
    this.getProList()
    this.shopDiscountId = this.discountId
    if (this.shopDiscountId) {
      this.getDiscountInfo()
    }
  },
  methods: {
    resetData() {
      this.addForm = new InitDiscountForm()
      this.dateInfo = []
      this.inputDiscountTableData = []
      this.getProList()
      this.$refs.multipleTable.clearSelection()
    },
    blurInput(data) {
      const index = this.inputDiscountTableData.findIndex(item => item.skuId === data.skuId)
      if (index === -1) {
        this.inputDiscountTableData.push(data)
      } else {
        this.inputDiscountTableData[index].discount = data.discount
      }
    },
    addSeckillFn(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          if (this.dateInfo.length === 0) {
            this.$message.warning('请选择活动开始和结束日期')
            return false
          }
          if (this.addForm.ifLimit === '2' && this.addForm.limitNumber === null) {
            this.$message.warning('请填写活动限购多少件')
            return false
          }
          if (this.addForm.ifNumber === ' 2' && this.addForm.number === null) {
            this.$message.warning('请输入活动限制数量')
            return false
          }
          if (this.addForm.ifEnable === ' 2' && this.addForm.enableTime === null) {
            this.$message.warning('请填写活动预热前多少小时')
            return false
          }
          this.addForm.startTime = this.dateInfo[0]
          this.addForm.endTime = this.dateInfo[1]
          if (this.shopDiscountId) {
            discountUpdate(this.addForm).then(res => {
              console.log(res)
              if (res.code === '') {
                this.$message.success('修改成功')
                this.dateInfo = []
                this.addForm = new InitDiscountForm()
                this.$emit('reset')
              }
            })
          } else {
            addDiscount(this.addForm).then(res => {
              if (res.code === '') {
                this.$message.success('提交成功')
                this.dateInfo = []
                this.addForm = new InitDiscountForm()
                this.$emit('reset')
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
      this.isVisible = true
      if (this.visitDetail) {
        this.proOption.activityId = this.shopDiscountId
      } else {
        this.proOption.activityId = null
      }
      this.getProList()
    },
    getProList() {
      getDisProList(this.proOption).then(res => {
        if (res.code === '') {
          const dataList = res.data.list
          if (this.inputDiscountTableData.length > 0) {
            dataList.forEach(item => {
              const index = this.inputDiscountTableData.findIndex(cItem => cItem.skuId === item.skuId)
              if (index !== -1) {
                item.discount = this.inputDiscountTableData[index].discount
              }
            })
          }
          this.tableData = dataList
          this.total = res.data.total
          if (this.$refs.multipleTable) {
            for (let i = 0; i < this.tableData.length; i++) {
              for (let j = 0; j < this.addForm.details.length; j++) {
                if (this.tableData[i].productId === this.addForm.details[j].productId && this.tableData[i].skuId === this.addForm.details[j].skuId) {
                  this.$refs.multipleTable.toggleRowSelection(this.tableData[i]);
                }
              }
            }
          }
        }
      })
    },
    // 编辑时表格默认勾选
    // setRowSelection(){
    //   if (this.$refs.multipleTable) {
    //     for (let i = 0; i < this.tableData.length; i++) {
    //       for (let j = 0; j < this.addForm.details.length; j++) {
    //         if (this.tableData[i].productId === this.addForm.details[j].productId && this.tableData[i].skuId === this.addForm.details[j].skuId) {
    //           this.$refs.multipleTable.toggleRowSelection(this.tableData[i]);
    //           console.log('执行了')
    //         }
    //       }
    //     }
    //   }
    // },
    // 选中商品
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    // 保存选择商品ID
    saveIdList() {
      const idList = []
      this.multipleSelection.forEach(i => {
        let discountPrice = null
        if (i.discount < 10) {
          discountPrice = i.discount / 10 * i.originalPrice
        } else {
          discountPrice = i.discount / 100 * i.originalPrice
        }
        idList.push({
          price: discountPrice,
          discount: i.discount,
          productId: i.productId,
          skuId: i.skuId
        })
      })
      this.addForm.details = idList
      this.isVisible = false
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    // 跳转折扣列表
    goToDiscount() {
      this.$emit('reset')
    },
    async getDiscountInfo() {
      this.addForm.details = []
      const res = await getDiscountDetail({ shopDiscountId: this.shopDiscountId })
      this.addForm.ifEnable = res.data.ifEnable.toString()
      this.addForm.enableTime = res.data.enableTime
      this.addForm.effectiveTime = res.data.effectiveTime
      this.addForm.discountName = res.data.discountName
      this.addForm.startTime = res.data.startTime
      this.addForm.endTime = res.data.endTime
      this.addForm.person = res.data.person
      this.addForm.ifAdd = res.data.ifAdd.toString()
      this.addForm.ifNumber = res.data.ifNumber.toString()
      this.addForm.ifLimit = res.data.ifLimit.toString()
      this.addForm.number = res.data.number
      this.addForm.limitNumber = res.data.limitNumber
      this.addForm.remark = res.data.remark
      this.addForm.shopDiscountId = res.data.shopDiscountId
      const idList = res.data.products
      idList.forEach(i => {
        this.addForm.details.push({
          discount: i.discount,
          price: i.discountPrice,
          productId: i.productId,
          skuId: i.skuId
        })
      })
      this.dateInfo = [this.addForm.startTime, this.addForm.endTime]
    },
    // 删除
    deleteSeckillFn() {
    },
    numFilter(value) {
      const realVal = parseFloat(value).toFixed(2)
      return realVal
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.addGroupBuy {
  background: #FFFFFF;
  .dialog-footer {
    display: flex;
    justify-content: center;
    .el-button {
      margin: 0px 16px;
    }
  }
  .formBox {
    margin-top: 20px;
    .flexBox {
      display: flex;
    }
    .applyType {
      span {
        width: 100px;
        height: 30px;
        line-height: 30px;
        background: #66b1ff;
        color: #FFFFFF;
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
          background: #FFFFFF;
          border-radius: 50%;
          border: 1px solid #66b1ff;
          text-align: center;
          color: #409EFF;
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
  width: 100px;
  margin-right: 15px;
}
.boxWidth /deep/ .el-input .el-input__inner {
  text-align: center;
}
.addGroupBuy /deep/ .el-button--primary {
  background: #409EFF;
  border-color: #409EFF;
}
.addGroupBuy /deep/ .el-dialog__header {
  background-color: #409EFF;
}
.addGroupBuy /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__content {
  display: flex;
  align-items: center;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__label {}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
input[type="number"]{
  -moz-appearance: textfield;
}
</style>
