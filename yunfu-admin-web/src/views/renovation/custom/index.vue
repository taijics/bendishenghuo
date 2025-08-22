<template>
  <div class="classification-page">
    <div class="toolbar">
      <el-button type="success" @click="addCustom">添加页面</el-button>
    </div>
    <el-table
      :data="tableData"
      style="width: 100%"
      border
      row-key="id"
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      :tree-props="{ children: 'childs' }"
    >
      <el-table-column prop="name" label="页面名称" />
      <el-table-column prop="updateTime" label="更新时间" />
      <el-table-column prop="status" label="操作">
        <template #default="scope">
          <el-button type="primary" link @click.native.prevent="fitupRow(scope.row)">装修</el-button>
          <el-button type="primary" link @click.native.prevent="checkRow(scope.row)">查看</el-button>
          <el-button type="primary" link @click.native.prevent="updateRow(scope.row)">编辑</el-button>
          <el-button type="primary" link @click.native.prevent="deleteRow(scope.row)">删除</el-button>
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
    <el-dialog
      v-model="dialog.isVisible"
      :title="dialog.type === 'add' ? '添加页面' : '编辑页面'"
      width="30%"
    >
      <el-form :model="form">
        <el-form-item label="页面名称">
          <el-input v-model="form.name" maxlength="20" autocomplete="off" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialog.isVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitForm">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import {
  selectCanvasCustomList,
  saveCanvasCustom,
  delCanvasCustom,
} from '@/api/renovation'
export default {
  data() {
    return {
      formParams: {
        page: 1,
        pageSize: 10,
        type: 2,
      },
      form: {
        name: '',
        type: 2,
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      dialog: {
        type: 'add',
        isVisible: false,
      },
    }
  },
  created() {
    this.getCanvasList()
    this.getAll(this.formParams)
  },
  methods: {
    handleSizeChange(val) {
      this.formParams.pageSize = val
      this.getAll(this.formParams)
    },
    handleCurrentChange(val) {
      this.formParams.page = val
      this.getAll(this.formParams)
    },
    fetch(config) {
      const { limit, page } = config
      this.formParams.pageIndex = page || 1
      this.formParams.pageSize = limit || 10
      this.getCanvasList()
    },
    // 新增自定义页面
    addCustom() {
      this.dialog.isVisible = true
      this.form.name = ''
      delete this.form.id
      this.dialog = {
        type: 'add',
        isVisible: true,
      }
    },
    // 窗口确定
    submitForm() {
      if (!this.form.name) {
        this.$message.error('页面名称不能为空！')
        return
      }
      if (this.dialog.type === 'add') {
        saveCanvasCustom(this.form).then(
          (res) => {
            if (res && res.data) {
              this.$message({
                message: '新增成功',
                type: 'success',
              })
            }
            this.dialog.isVisible = false
            this.getCanvasList()
          },
          (error) => {
            console.log(error)
          }
        )
      } else if (this.dialog.type === 'edit') {
        saveCanvasCustom(this.form).then(
          (res) => {
            if (res && res.data) {
              this.$message({
                message: '编辑成功',
                type: 'success',
              })
            }
            this.dialog.isVisible = false
            this.getCanvasList()
          },
          (error) => {
            console.log(error)
          }
        )
      }
    },
    // 编辑
    updateRow(row) {
      this.form.id = row.id
      this.form.name = row.name
      this.dialog = {
        type: 'edit',
        isVisible: true,
      }
    },
    // 查看
    checkRow(row) {
      const id = row.classifyId
      this.dialog = {
        type: 'check',
        isVisible: true,
      }
      this.$refs.edit.setParams({
        id,
      })
    },
    // 装修
    fitupRow() {},
    // 删除
    async deleteRow(row) {
      this.$confirm('此操作将永久删除该自定义页面, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          delCanvasCustom({ id: row.id }).then((res) => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!',
              })
            }
            this.getCanvasList()
          })
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '已取消删除',
          })
        })
    },

    async getCanvasList() {
      this.getAll(this.formParams)
    },
    async getAll(formParams) {
      const res = await selectCanvasCustomList(formParams)
      this.tableData = res.data.list
      this.total = res.data.total
    },
  },
}
</script>

<style lang="scss" scoped>
.classification-page {
  padding: 15px 20px;
  .toolbar {
    margin-bottom: 15px;
    text-align: right;
  }
}
</style>
