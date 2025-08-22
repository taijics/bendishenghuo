<!--  -->
<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item label="角色名">
          <el-input v-model="formInline.search" maxlength="20" placeholder="请输入角色名" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="info" plain @click="clear">重置</el-button>
          <el-button type="success" plain @click="add">新增角色</el-button>
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
        <el-table-column type="selection" width="55" />
        <el-table-column label="角色id" width="220">
          <template slot-scope="scope">{{ scope.row.roleId }}</template>
        </el-table-column>
        <el-table-column prop="roleName" label="角色名称" />
        <el-table-column prop="roleDescribe" label="描述" />
        <el-table-column label="操作" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="btnList">
              <el-button type="text" @click="edit(scope.row)">编辑</el-button>
              <el-button type="text" @click="del(scope.row)">删除</el-button>
              <el-button type="text" @click="buss(scope.row)">分配权限</el-button>
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
    <!-- 新增角色 -->
    <el-dialog
      :title="userState ? '新增角色' : '修改角色'"
      :visible.sync="addFormDialog"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <!-- 新增角色 -->
      <div>
        <el-form ref="ruleForm" :model="addForm" label-width="80px" :rules="userRules">
          <el-form-item label="角色名称" prop="roleName">
            <el-input v-model="addForm.roleName" maxlength="20" placeholder="请输入角色名称" />
          </el-form-item>
          <el-form-item label="角色描述">
            <el-input v-model="addForm.roleDescribe" maxlength="60" placeholder="请输入角色描述" />
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addFormDialog = false">取 消</el-button>
        <el-button type="primary" @click="addForm_enter('ruleForm')">确 定</el-button>
      </span>
    </el-dialog>
    <!-- 分配权限 -->
    <el-dialog :visible.sync="dialogVisible" title="分配权限" center :close-on-click-modal="false">
      <el-form :model="activityObj" label-width="80px" label-position="left">
        <el-form-item label="权限列表">
          <el-tree
            ref="permissionNode"
            :data="permissionsList"
            check-strictly
            show-checkbox
            highlight-current
            node-key="permissionId"
            :default-expand-all="true"
            :props="props"
            @check-change="handleCheckChange"
          />
        </el-form-item>
      </el-form>
      <div style="text-align:center;">
        <el-button @click="dialogVisible=false">取消</el-button>
        <el-button type="primary" @click="confirmRole">确认</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import {
  roleAdd,
  roleGetall,
  roleGetById,
  roleUpdate,
  roleDelete,
  getRolePermission,
  distribution
} from '@/api/setup'
export default {
  // import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    // 这里存放数据
    return {
      formInline: {
        search: '', // 搜索字段
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      },
      total: 1,
      tableData: [],
      multipleSelection: [],
      activityObj: {
        ids: []
      },
      props: {
        children: 'childs',
        label: 'permissionName'
      },
      currentPage: 1,
      userState: 1,
      dialogVisible: false,
      checkStrictly: true,
      permissionsList: [],
      addForm: {
        roleName: '', // 角色名称
        roleDescribe: '' // 角色描述
      },
      addFormDialog: false,
      userRules: {
        roleName: [
          { required: true, message: '请输入角色名称', trigger: 'blur' }
        ]
      },
      roleId: null
    }
  },
  // 监听属性 类似于data概念
  computed: {},
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getAll(this.formInline)
  },
  // 方法集合
  methods: {
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
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
        search: '', // 搜索字段
        state: '', // 是否启用 1-是 0-否
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      }
      this.getAll(this.formInline)
    },
    // 新增角色
    add() {
      this.userState = 1
      this.addFormDialog = true
      this.addForm = {
        roleName: '', // 昵称
        roleDescribe: '' // 电话
      }
    },
    // 确认新增角色
    addForm_enter(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          if (this.userState) {
            roleAdd(this.addForm).then(res => {
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
            roleUpdate(this.addForm).then(res => {
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
      roleGetById({ roleId: row.roleId }).then(res => {
        this.addForm = res.data
        this.addForm.roleIds = res.data.ids
        console.log(this.addForm)
        // this.addForm.roleIds = [1];
      })
    },
    // 删除角色
    async del(row) {
      this.$confirm('此操作将永久删除该角色, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          roleDelete({ roleId: row.roleId }).then(res => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
            }
            this.getAll(this.formInline)
          })
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '已取消删除'
          })
        })
    },
    // 分配权限
    async buss(row) {
      this.roleId = row.roleId
      this.dialogVisible = true
      const res = await getRolePermission({
        roleId: this.roleId
      })
      if (res.code === '') {
        this.permissionsList = res.data.permissions
        this.$nextTick(() => {
          // this.$refs.treeBox.setCheckedKeys(res.data.ids)
          this.$refs.permissionNode.setCheckedKeys(res.data.ids)
        })
      }
    },
    // 提交
    async confirmRole() {
      const loading = this.$loading({
        lock: true,
        text: '处理中请稍后...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.3)'
      })
      const arr = []
      this.treeList.forEach((v, i) => {
        arr.push(v.permissionId)
      })
      const res = await distribution({
        roleId: this.roleId,
        permissionIds: arr
      })
      if (res.code === '') {
        loading.close()
        this.$message.success('分配成功,请手动刷新页面')
        this.dialogVisible = false
        this.roleId = null
      }
      // console.log(arr)
    },
    selectChildren(data) {
      data && data.children && data.children.map(item => {
        this.$refs.permissionNode.setChecked(item.id, true)
        if (data.children) {
          this.selectChildren(item)
        }
      })
    },
    handleCheck(data, { checkedKeys }) {
      // 节点所对应的对象、节点本身是否被选中、节点的子树中是否有被选中的节点
      // 如果为取消
      if (checkedKeys.includes(data.id)) {
        // 如果当前节点有子集
        this.selectChildren(data)
      }
    },
    // 获取选中的ID
    handleCheckChange(data, checked, indeterminate) {
      // 节点所对应的对象、节点本身是否被选中、节点的子树中是否有被选中的节点
      // 如果为取消
      if (checked === false) {
        // 如果当前节点有子集
        if (data.children) {
          // 循环子集将他们的选中取消
          data.children.map(item => {
            this.$refs.permissionNode.setChecked(item.id, false)
          })
        }
      } else {
        // 否则(为选中状态)
        // 判断父节点id是否为空
        if (data.parentId !== 0) {
          // 如果不为空则将其选中
          this.$refs.permissionNode.setChecked(data.parentId, true)
        }
      }

      var check = this.$refs.permissionNode.getCheckedNodes()
      // console.log(data, checked, indeterminate, check)
      this.treeList = check
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await roleGetall(formInline)
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
  padding: 20px;
}
</style>
