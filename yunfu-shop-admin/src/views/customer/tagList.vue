<template>
  <div class="tagListPage">
    <div class="formSearch">
      <div class="searchItem">
        <span>标签名称：</span>
        <el-input v-model="formInline.tagName" maxlength="20" class="label" placeholder="请输入内容" />
      </div>
      <div class="searchItem">
        <span>客户数量：</span>
        <el-input v-model="formInline.minPerson" maxlength="9" class="nums" />
        <span>至</span>
        <el-input v-model="formInline.maxPerson" maxlength="9" class="nums" />
      </div>
      <div class="btns">
        <el-button type="primary" plain @click="search">查询</el-button>
        <el-button type="primary" plain @click="clear">重置</el-button>
        <el-button type="primary" plain @click="addTag">添加标签</el-button>
        <el-button type="primary" plain @click="deleteTagFn(id = null)">删除</el-button>
      </div>
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
        <el-table-column prop="labelName" label="标签名称" show-overflow-tooltip />
        <el-table-column prop="remark" label="备注信息" show-overflow-tooltip />
        <el-table-column prop="person" label="客户数量" show-overflow-tooltip />
        <el-table-column label="操作" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="btnList">
              <el-button type="text" @click="edit(scope.row.labelId)">编辑</el-button>
              <el-popconfirm title="确定删除此标签？" @onConfirm="deleteTagFn(scope.row.labelId)">
                <el-button slot="reference" class="delCls" type="text">删除</el-button>
              </el-popconfirm>
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
    <!-- 新建弹框 -->
    <el-dialog
      :close-on-click-modal="false"
      :title="currentId ? '修改标签' : '新增标签'"
      :visible.sync="isDataVisible"
      width="30%"
      top="50px"
      class="group-dialog"
    >
      <div class="addTagBox">
        <el-form :inline="true" :model="addForm" :rules="addFormRules" label-width="90px">
          <el-form-item label="标签名称" prop="labelName">
            <el-input v-model="addForm.labelName" placeholder="请输入内容" maxlength="10" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" show-word-limit />
          </el-form-item>
          <el-form-item label="备注信息">
            <el-input
              v-model="addForm.remark"
              maxlength="200"
              type="textarea"
              :rows="5"
              placeholder="请输入内容"
            />
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="saveTag">保 存</el-button>
        <el-button @click="closeAddTag">取 消</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { addLabel, getLabels, labelEdit, labelUpdate, deleteLabel } from '@/api/customer'
export default {
  name: 'TagList',
  data() {
    return {
      formInline: {
        labelName: '', // 标签名称
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        minPerson: null, // 最大人
        maxPerson: null // 最小人
      },
      addForm: {
        labelName: '',
        remark: ''
      },
      isDataVisible: false, // 数据效果展示
      total: 1,
      currentId: '', // 当前标签ID
      tableData: [],
      currentPage: 1,
      multipleSelection: [],
      addFormRules: {
        labelName: [
          { required: true, message: '请输入标签名称', trigger: 'blur' }
        ]
      }
    }
  },
  mounted() {
    this.getTagAll(this.formInline)
  },
  methods: {
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getTagAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = {
        labelName: '', // 标签名称
        minPerson: null, // 最小
        maxPerson: null, // 最大
        page: 1, // 当前页
        pageSize: 10 // 每页记录数
      }
      this.getTagAll(this.formInline)
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getTagAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getTagAll(this.formInline)
    },
    // 编辑
    edit(id) {
      if (id) {
        this.currentId = id
        labelEdit({ labelId: this.currentId }).then(res => {
          if (res.code === '') {
            this.addForm.labelName = res.data.labelName
            this.addForm.remark = res.data.remark
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }
      this.isDataVisible = true
    },
    addTag() {
      this.currentId = ''
      this.addForm.labelName = ''
      this.addForm.remark = ''
      this.isDataVisible = true
    },
    saveTag() {
      if (this.currentId) {
        labelUpdate(Object.assign({}, this.addForm, { 'labelId': this.currentId })).then(res => {
          if (res.code === '') {
            this.$message({
              message: '修改成功',
              type: 'success'
            })
            this.formInline.page = 1
            this.getTagAll(this.formInline)
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      } else {
        addLabel(this.addForm).then(res => {
          if (res.code === '') {
            this.$message({
              message: '添加成功',
              type: 'success'
            })
            this.formInline.page = 1
            this.getTagAll(this.formInline)
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }
      this.isDataVisible = false
    },
    closeAddTag() {
      this.isDataVisible = false
    },
    // 初始化查询所有数据
    async getTagAll(formInline) {
      const res = await getLabels(formInline)
      this.total = res.data.total
      this.tableData = res.data.list
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
      console.log(this.multipleSelection)
    },
    deleteTagFn(id) {
      var ids = []
      if (id) {
        ids.push(id)
      } else {
        this.multipleSelection.forEach(item => {
          ids.push(item.labelId)
        })
        if (ids.length === 0) {
          this.$message({
            message: '请选择要删除的标签',
            type: 'warning'
          })
          return false
        }
      }
      console.log(ids, 'ids')
      deleteLabel({ ids }).then(res => {
        if (res.code === '') {
          this.$message({
            message: '删除成功',
            type: 'success'
          })
          this.formInline.page = 1
          this.getTagAll(this.formInline)
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
@import url("../../styles/elDialog.scss");
.tagListPage{
  .formSearch{
    width: 100%;
    margin: 10px 0;
    padding: 0 12px;
    display: flex;
    flex-wrap: wrap;
    line-height: 60px;
    .searchItem{
      margin-right: 20px;
      display: flex;
      span{
        min-width: 80px;
        text-align: center;
      }
      .label{
        max-width: 200px;
        min-width: 120px;
      }
      .nums{
        max-width: 120px;
        min-width: 80px;
      }
    }
  }
  .tableBox{
    margin: 0 12px;
  }
  .fenye {
    margin-top: 20px;
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
.tagCustomer /deep/ .el-form-item__content {
  display: flex;
}
.tagCustomer {
  display: flex !important;
}
.tagCustomer /deep/ .el-form-item__content span {
  margin: 0 5px;
}
.tagListPage .formSearch /deep/ .el-form {
  display: flex;
}
.tagListPage .tagNameStyle /deep/ .el-form-item__content {
  width: 300px;
}
.addTagBox /deep/ .el-form-item {
  display: flex;
}
.addTagBox /deep/ .el-form-item__content {
  width: 80%;
}
</style>
