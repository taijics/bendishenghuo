<template>
  <div class="pending">
    <div class="formSearch">
      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="上次消费时间">
          <div class="dateBox">
            <el-form-item>
              <el-date-picker
                v-model="formInline.lastTimes"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item label="成为客户时间">
          <div class="dateBox">
            <el-form-item>
              <el-date-picker
                v-model="formInline.dates"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item class="inputWide" label="手机号">
          <el-input v-model="formInline.phone" maxlength="11" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item class="inputWide" label="客户标签">
          <el-select v-model="formInline.labelId" placeholder="客户标签" clearable>
            <el-option
              v-for="item in tagList"
              :key="item.labelId"
              :label="item.labelName"
              :value="item.labelId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="primary" plain @click="clear">重置</el-button>
          <!--          <el-button type="primary" plain @click="addTag">添加标签</el-button>-->
          <el-button type="primary" plain @click="addCustomer">添加客户</el-button>
          <el-button type="success" plain @click="userDataExport">导出</el-button>
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
        @selection-change="handleSelectionChange"
      >
        <el-table-column
          type="selection"
          width="55"
        />
        <el-table-column prop="name" label="客户昵称" show-overflow-tooltip />
        <el-table-column prop="phone" label="手机号" show-overflow-tooltip />
        <el-table-column prop="frequency" label="消费次数" show-overflow-tooltip />
        <el-table-column prop="total" label="累计消费金额（元）" show-overflow-tooltip />
        <el-table-column prop="lastTime" label="上次消费时间" show-overflow-tooltip />
        <el-table-column prop="time" label="成为客户时间" show-overflow-tooltip />
        <el-table-column :formatter="row=>row.registerIp?row.registerIp:'-'" label="注册IP" show-overflow-tooltip />
        <el-table-column :formatter="row=>row.lastLoginIp?row.lastLoginIp:'-'" prop="time" label="最后登录IP" show-overflow-tooltip />
        <el-table-column prop="labelName" label="客户标签" show-overflow-tooltip />
        <el-table-column label="操作" show-overflow-tooltip fixed="right">
          <template slot-scope="scope">
            <div class="btnList">
              <el-button type="text" @click="edit(scope.row)">加标签</el-button>
              <el-button type="text" @click="showDetail(scope.row.buyerUserId)">详情</el-button>
              <!-- <el-popconfirm title="确定删除此标签？" @onConfirm="deleteTagFn(scope.row.labelId)">
                <el-button slot="reference" class="delCls" type="text">删除</el-button>
              </el-popconfirm> -->
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <!-- 添加客户 -->
    <el-dialog
      :close-on-click-modal="false"
      title="添加客户"
      :visible.sync="isDataVisible"
      width="560px"
      top="50px"
      class="group-dialog"
    >
      <div class="changeCustomer">
        <el-form ref="ruleForm" :model="basicInfo" label-width="150px" :rules="basicInfoRules">
          <el-form-item class="inputWide" label="客户手机号" prop="phone">
            <el-input v-model="basicInfo.phone" placeholder="请输入客户手机号" maxlength="11" show-word-limit oninput="value=value.replace(/[^\d]/g,'')" />
          </el-form-item>
          <el-form-item class="inputWide" label="客户昵称">
            <el-input v-model="basicInfo.name" placeholder="请输入客户昵称" maxlength="10" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" show-word-limit />
          </el-form-item>
          <el-form-item class="inputWide" label="性别">
            <el-radio v-model="basicInfo.sex" label="男">男</el-radio>
            <el-radio v-model="basicInfo.sex" label="女">女</el-radio>
          </el-form-item>
          <el-form-item class="inputWide" label="生日">
            <el-date-picker
              v-model="basicInfo.birthday"
              type="date"
              value-format="yyyy-MM-dd"
              placeholder="选择日期"
            />
          </el-form-item>
          <el-form-item class="inputWide" label="标签">
            <el-select
              v-model="basicInfo.ids"
              multiple
              collapse-tags
              placeholder="请选择"
            >
              <el-option
                v-for="item in tagList"
                :key="item.labelId"
                :label="item.labelName"
                :value="item.labelId"
              />
            </el-select>
          </el-form-item>
          <el-form-item class="inputWide" label="备注">
            <el-input
              v-model="basicInfo.remark"
              maxlength="200"
              type="textarea"
              :rows="4"
              placeholder="请输入内容"
            />
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="saveCustomer('ruleForm')">保 存</el-button>
        <el-button @click="closeAddCustomer">取 消</el-button>
      </span>
    </el-dialog>
    <!-- 添加标签 -->
    <el-dialog
      :close-on-click-modal="false"
      title="添加标签"
      :visible.sync="isTagListVisible"
      width="500px"
      top="50px"
      class="group-dialog"
    >
      <div class="changeCustomer">
        <el-form ref="ruleForm" label-width="150px">
          <el-form-item class="inputWide" label="标签">
            <el-select
              v-model="currentIds"
              multiple
              collapse-tags
              placeholder="请选择"
            >
              <el-option
                v-for="item in tagList"
                :key="item.labelId"
                :label="item.labelName"
                :value="item.labelId"
              />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="saveCustomerTag">保 存</el-button>
        <el-button @click="closeAddTag">取 消</el-button>
      </span>
    </el-dialog>

    <!-- 详情弹窗 -->
    <CustomerDetail ref="customerDetail" />
  </div>
</template>

<script>
import CustomerDetail from '@/views/customer/customerList/customerDetail.vue'
import { getCustomerList, getLabelData, addCustomer, deleteLabel, buyerSaveLabel, userExport } from '@/api/customer'
export default {
  name: 'TagList',
  components: {
    CustomerDetail
  },
  data() {
    return {
      formInline: {
        dates: [], // 成为客户时间数组
        lastTimes: [], // 上次消费时间
        phone: '', // 手机号
        page: 1, // 当前页
        pageSize: 10, // 每页数
        labelId: null
      },
      basicInfo: {
        birthday: '',
        buyerUserId: '',
        ids: [],
        name: '',
        phone: '',
        remark: '',
        sex: ''
      },
      currentIds: [], // 当前选择标签
      customerInfo: {}, // 客户详情
      tagList: [],
      isDataVisible: false, // 数据效果展示
      isTagListVisible: false, // 标签展示
      total: 1,
      currentId: '', // 当前标签ID
      tableData: [],
      currentPage: 1,
      multipleSelection: [],
      basicInfoRules: {
        phone: [
          { required: true, message: '请输入客户手机号', trigger: 'blur' }
        ]
      }
    }
  },
  mounted() {
    this.getCustomerAll(this.formInline)
    this.getTagList()
  },
  methods: {
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getCustomerAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = {
        labelName: '', // 标签名称
        dates: [], // 成为客户时间数组
        lastTimes: [], // 上次消费时间
        phone: '', // 手机号
        page: 1, // 当前页
        pageSize: 10, // 每页数
        labelId: null
      }
      this.getCustomerAll(this.formInline)
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getCustomerAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getCustomerAll(this.formInline)
    },
    // 客户详情
    showDetail(id) {
      this.$refs.customerDetail.show(id)
    },
    // 编辑
    edit(item) {
      this.currentIds = item.labelIds
      this.currentId = item.buyerUserId
      this.isTagListVisible = true
    },
    saveCustomerTag() {
      buyerSaveLabel({ buyerUserId: this.currentId, labelIds: this.currentIds }).then(res => {
        if (res.code === '') {
          this.$message({
            message: '添加成功',
            type: 'success'
          })
          this.getCustomerAll(this.formInline)
          this.getTagList()
          this.isTagListVisible = false
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    closeAddTag() {
      this.isTagListVisible = false
      this.currentIds = []
    },
    addCustomer() {
      this.isDataVisible = true
    },
    // 导出用户
    async userDataExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      console.log(this.formInline, 'this.formInline')
      const res = await userExport(this.formInline)
      if (!res) {
        return
      }
      const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
      const fileName = '用户列表.xls'
      if ('download' in document.createElement('a')) {
        // 非IE下载
        const elink = document.createElement('a')
        elink.download = fileName
        elink.href = URL.createObjectURL(blob)
        elink.style.display = 'none'
        document.body.appendChild(elink)
        elink.click()
        URL.revokeObjectURL(elink.href) // 释放URL 对象
        document.body.removeChild(elink)
      } else {
        // IE10+下载
        navigator.msSaveBlob(blob, fileName)
      }
    },
    saveCustomer(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          const reg = /^[1][3,4,5,7,8,9][0-9]{9}$/
          if (!reg.test(this.basicInfo.phone)) {
            this.$message({
              message: '请输入正确的手机号',
              type: 'warning'
            })
            return false
          }
          addCustomer(this.basicInfo).then(res => {
            if (res.code === '') {
              this.$message({
                message: '添加成功',
                type: 'success'
              })
              this.formInline.page = 1
              this.getCustomerAll(this.formInline)
              this.basicInfo = {}
              this.isDataVisible = false
            } else {
              this.$message({
                message: res.message,
                type: 'error'
              })
            }
          })
        }
      })
    },
    closeAddCustomer() {
      this.isDataVisible = false
    },
    // 初始化查询所有数据
    async getCustomerAll(formInline) {
      const res = await getCustomerList(formInline)
      this.total = res.data.total
      this.tableData = res.data.list
    },
    async getTagList() {
      const res = await getLabelData()
      if (res.code === '') {
        this.tagList = res.data
        console.log(this.tagList, 'taglist')
      } else {
        this.$message({
          message: res.message,
          type: 'error'
        })
      }
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    deleteTagFn(id) {
      deleteLabel({ labelId: id }).then(res => {
        if (res.code === '') {
          this.$message({
            message: '删除成功',
            type: 'success'
          })
          this.formInline.page = 1
          this.getCustomerAll(this.formInline)
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    }
  }
}
</script>

<style lang='scss' scoped>
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
.inputWide /deep/ .el-form-item__content {
  width: 260px;
}
.inputWide /deep/ .el-select {
  width: 100%;
}
.changeCustomer .inputWide /deep/ .el-form-item__content {
  width: 280px;
}
.changeCustomer .inputWide /deep/ .el-select {
  width: 280px;
}
.customerDetail /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
.changeCustomer /deep/ .el-date-editor--date {
  width: 280px;
}
</style>
