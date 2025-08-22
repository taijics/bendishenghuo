<!--  -->
<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <FixedNav
      class="formSearch"
      :height="200"
    >
      <div class="searchInput">
        <span>菜单名:</span>
        <el-input v-model="formInline.permissionName" maxlength="20" placeholder="请输入菜单名" />
      </div>
      <el-button type="primary" plain @click="search">查询</el-button>
      <el-button type="info" size="medium" plain @click="clear">重置</el-button>
      <el-button type="success" size="medium" plain @click="add(1)">新增父级目录</el-button>
      <el-button type="success" size="medium" plain @click="add(2)">新增子级菜单</el-button>
      <!-- <el-button type="success" size="medium" plain @click="add(3)">新增子级按钮</el-button> -->
    </FixedNav>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        :data="tableData"
        style="width: 100%; margin-bottom: 20px"
        row-key="permissionId"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        :tree-props="{ children: 'childs', hasChildren: 'hasChildren' }"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="permissionName" label="菜单名称" />
        <el-table-column label="图标">
          <template slot-scope="scope">
            <div>
              <i :class="scope.row.icon" />
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="permission" label="菜单标识" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="操作" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="btnList">
              <el-button type="text" @click="edit(scope.row)">编辑</el-button>
              <el-button type="text" @click="del(scope.row)">删除</el-button>
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

    <!-- *************对话框开始************* -->
    <el-dialog
      :title="userState ? '新增菜单' : '修改菜单'"
      :visible.sync="addFormDialog"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <!-- 新增角色 -->
      <div>
        <el-form ref="ruleForm" :model="addForm" label-width="80px" :rules="userRules">
          <el-form-item label="父节点ID">
            <el-input v-model="addForm.permissionPid" :disabled="true" placeholder="请输入角色名称" />
          </el-form-item>
          <el-form-item label="菜单名称" prop="permissionName">
            <el-input v-model="addForm.permissionName" maxlength="20" placeholder="请输入菜单名称" />
          </el-form-item>
          <el-form-item label="菜单路径" prop="permission">
            <el-input v-model="addForm.permission" maxlength="100" placeholder="请输入菜单路径" />
          </el-form-item>
          <el-form-item label="图标地址" prop="icon">
            <el-input
              v-model="addForm.icon"
              placeholder="请输入图片地址"
              @focus="getFocus"
            >
              <template slot="prepend">
                <i :class="addForm.icon"></i>
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="菜单描述">
            <el-input v-model="addForm.describe" maxlength="60" placeholder="请输入菜单描述" />
          </el-form-item>
          <el-form-item label="排序值" prop="sort">
            <el-input v-model="addForm.sort" maxlength="9" placeholder="请输入排序值" oninput="value=value.replace(/[^\d]/g,'')" />
          </el-form-item>
          <el-form-item label="权限类型" prop="resourceType">
            <el-select v-model="addForm.resourceType" placeholder="请选择活动区域">
              <el-option label="菜单" value="menu" />
              <el-option label="按钮" value="button" />
              <el-option label="目录" value="catalog" />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addFormDialog = false">取 消</el-button>
        <el-button type="primary" @click="addForm_enter('ruleForm')">确 定</el-button>
      </span>
    </el-dialog>

    <Icons :dialog-visible="iconVisible" @choose="chooseIcon" @close="iconVisible = false" />
  </div>
</template>

<script>
import FixedNav from '@/components/FixedNav/index.vue'
import {
  tabsGetAll,
  tabsAdd,
  tabsGetById,
  tabsUpdate,
  tabsDelete,
  getMaxSort
} from '@/api/setup'
import Icons from './Icons'
export default {
  components: {
    Icons,
    FixedNav
  },
  data() {
    // 这里存放数据
    return {
      fixed: false,
      formInline: {
        permissionName: '', // 搜索字段
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      userState: 1,
      addForm: {
        permissionPid: '', // 父节点id
        permissionName: '', // 权限名称
        permissionUri: '', // URI
        permission: '', // 组件
        icon: '', // 图标地址
        describe: '', // 描述
        resourceType: 'menu', // 权限类型 menu-菜单 button-按钮 catalog-目录
        sort: '' // 排序值
      },
      addFormDialog: false,
      userRules: {
        permissionName: [
          { required: true, message: '请输入权限名称', trigger: 'blur' }
        ],
        permission: [
          { required: true, message: '请输入菜单路径', trigger: 'blur' }
        ],
        resourceType: [
          { required: true, message: '请选择活动区域', trigger: 'change' }
        ],
        sort: [{ required: true, message: '请输入菜单路径', trigger: 'blur' }],
        icon: [{ required: true, message: '请输入图标地址', trigger: 'blur' }]
      },
      iconVisible: false,
      multipleSelection: []
    }
  },
  mounted() {
    this.getAll(this.formInline)
    window.addEventListener('scroll', () => { this.fixedNav() })
  },
  // 方法集合
  methods: {
    fixedNav() {
      // console.log(window.scrollY)
      this.fixed = window.scrollY > 200
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    removeTag(index) {
      console.log(index)
    },
    tagChange(index) {
      this.$forceUpdate()
      console.log(index)
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = {
        permissionName: '', // 搜索字段
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      }
      this.getAll(this.formInline)
    },
    // 新增角色
    add(index) {
      this.userState = 1
      getMaxSort().then(res => {
        if (index === 1) {
          if (this.multipleSelection.length >= 1) {
            this.$message({
              message: '请勿选择节点进行操作'
            })
            return
          }
          this.addForm = {
            permissionPid: '', // 父节点id
            permissionName: '', // 权限名称
            permissionUri: '', // URI
            permission: '', // 组件
            icon: '', // 图标地址
            describe: '', // 描述
            resourceType: 'catalog', // 权限类型 menu-菜单 button-按钮 catalog-目录
            sort: parseInt(res.data) // 排序值
          }
          this.addFormDialog = true
        } else if (index === 2) {
          if (this.multipleSelection.length === 0) {
            this.$message({
              message: '请选择父节点'
            })
            return
          }
          console.log(this.multipleSelection)
          if (this.multipleSelection[0].permissionPid !== 0) {
            this.$message({
              message: '请选择父节点进行操作'
            })
            return
          }
          this.addForm = {
            permissionPid: this.multipleSelection[0].permissionId, // 父节点id
            permissionName: '', // 权限名称
            permissionUri: '', // URI
            permission: '', // 组件
            icon: '', // 图标地址
            describe: '', // 描述
            resourceType: 'menu', // 权限类型 menu-菜单 button-按钮 catalog-目录
            sort: parseInt(res.data) // 排序值
          }
          this.addFormDialog = true
          console.log(this.multipleSelection[0])
          console.log(this.addForm)
        } else if (index === 3) {
          if (this.multipleSelection.length === 0) {
            this.$message({
              message: '请选择子节点'
            })
            return
          }
          console.log(this.multipleSelection[0].permissionPid)
          if (
            this.multipleSelection[0].permissionPid === 0 &&
            this.multipleSelection[0].childs.length !== 0
          ) {
            this.$message({
              message: '请勿选择父节点进行操作'
            })
            return
          }
          this.addForm = {
            permissionPid: this.multipleSelection[0].permissionId, // 父节点id
            permissionName: '', // 权限名称
            permissionUri: '', // URI
            permission: '', // 组件
            icon: 'el-icon-minus', // 图标地址
            describe: '', // 描述
            resourceType: 'button', // 权限类型 menu-菜单 button-按钮 catalog-目录
            sort: parseInt(res.data) // 排序值
          }
          this.addFormDialog = true
          console.log(this.multipleSelection[0])
          console.log(this.addForm)
        }
      })
    },
    // 确认新增角色
    addForm_enter(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          if (this.userState) {
            console.log(this.addForm)
            tabsAdd(this.addForm).then(res => {
              console.log(res)
              if (res.code === '') {
                this.$message({
                  message: '新增成功',
                  type: 'success'
                })
              }
              this.getAll(this.formInline)
              this.addFormDialog = false
            })
          } else {
            tabsUpdate(this.addForm).then(res => {
              console.log(res)
              if (res.code === '') {
                this.$message({
                  message: '修改成功',
                  type: 'success'
                })
              }
              this.getAll(this.formInline)
              this.addFormDialog = false
            })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    // 编辑角色
    edit(row) {
      this.userState = 0
      this.addFormDialog = true
      console.log(row)
      tabsGetById({ permissionId: row.permissionId }).then(res => {
        this.addForm = res.data
        console.log(this.addForm)
        // this.addForm.roleIds = [1];
      })
    },
    // 删除角色
    async del(row) {
      const res = await tabsDelete({ permissionId: row.permissionId })
      if (res.code === '') {
        this.$message({
          message: '删除成功',
          type: 'success'
        })
      }
      this.getAll(this.formInline)
    },
    // 组件传回值
    chooseIcon(icon) {
      console.log(icon)
      this.addForm.icon = icon
      this.iconVisible = false
    },
    getFocus() {
      this.iconVisible = true
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await tabsGetAll(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.userStyle {
  $comPadding: 12px 20px;
  .formSearch{
    padding: $comPadding;
    line-height: 40px;
    display: flex;
    .searchInput{
      margin-right: 20px;
      display: flex;
      span{
        min-width: 60px;
      }
    }
  }
  .tableBox{
    padding: $comPadding;
  }
}
</style>
