<!--  -->
<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item label="用户名">
          <el-input v-model="formInline.search" maxlength="20" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="是否启用">
          <el-select v-model="formInline.state" placeholder="请选择">
            <el-option label="是" value="1" />
            <el-option label="否" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="success" plain @click="add">新增用户</el-button>
          <el-button type="info" plain @click="clear">重置</el-button>
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
      >
        <el-table-column label="用户名" width="220">
          <template slot-scope="scope">{{ scope.row.username }}</template>
        </el-table-column>
        <el-table-column prop="name" label="姓名" />
        <el-table-column prop="sex" label="性别" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="state" label="是否启用">
          <template slot-scope="scope">
            <span v-if="scope.row.state == 0">停用</span>
            <span v-if="scope.row.state == 1">启用</span>
          </template>
        </el-table-column>
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
      :title="userState ? '新增用户' : '修改用户'"
      :visible.sync="addFormDialog"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <!-- 新增用户 -->
      <div>
        <el-form
          ref="ruleForm"
          :model="addForm"
          label-width="80px"
          :rules="userRules"
        >
          <el-form-item label="用户名" prop="username">
            <el-input v-model="addForm.username" maxlength="20" placeholder="请输入用户名" />
          </el-form-item>
          <el-form-item label="姓名" prop="name">
            <el-input v-model="addForm.name" maxlength="20" placeholder="请输入姓名" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input
              v-model="addForm.password"
              maxlength="16"
              placeholder="请输入密码"
              show-password
            />
          </el-form-item>
          <el-form-item label="邮箱">
            <el-input v-model="addForm.email" maxlength="40" placeholder="请输入邮箱" />
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input v-if="phoneShow" @focus="focusPhoneInput" maxlength="11" :value="hidden(addForm.phone, 3, 4)" />
            <el-input v-else v-model="addForm.phone" maxlength="11" />
          </el-form-item>
          <el-form-item label="性别">
            <el-radio-group v-model="addForm.sex">
              <el-radio label="男" />
              <el-radio label="女" />
            </el-radio-group>
          </el-form-item>
          <el-form-item label="是否启用">
            <el-select v-model="addForm.state" placeholder="请选择">
              <el-option label="是" :value="1" />
              <el-option label="否" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label="选择角色">
            <el-select
              v-model="addForm.roleIds"
              multiple
              placeholder="请选择"
              @remove-tag="removeTag"
              @change="tagChange"
            >
              <el-option
                v-for="item in roleList"
                :key="item.roleId"
                :label="item.roleName"
                :value="item.roleId"
              />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addFormDialog = false">取 消</el-button>
        <el-button type="primary" @click="addForm_enter('ruleForm')"
          >确 定</el-button
        >
      </span>
    </el-dialog>
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import {
  getList,
  userAdd,
  roleGetall,
  userGetById,
  userUpdate,
  userDelete
} from '@/api/setup'
export default {
  // import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    // 这里存放数据
    return {
      formInline: {
        search: '', // 搜索字段
        state: '', // 是否启用 1-是 0-否
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      userState: 1,
      addForm: {
        name: '', // 昵称
        password: '', // 密码
        email: '', // 邮箱
        phone: '', // 手机
        sex: '男', // 性别
        state: '1', // 是否启用 1-是 0-否
        roleIds: [] // 角色id
      },
      addFormDialog: false,
      userRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { min: 11, max: 11, message: "请输入11位手机号码", trigger: "blur" },
          {
            pattern: /^1[3456789]\d{9}$/,
            message: "请输入正确的手机号码"
          }
        ],
      },
      roleList: [],
      privacyTime: 0,
      phoneShow: true,
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
    this.privacyTime = localStorage.getItem("privacyTime");
    console.log(this.privacyTime)
  },
  // 方法集合
  methods: {
    focusPhoneInput(){
      this.phoneShow = false
      this.addForm.phone = ''
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
        search: '', // 搜索字段
        state: '', // 是否启用 1-是 0-否
        page: '1', // 当前页
        pageSize: '10' // 每页记录数
      }
      this.getAll(this.formInline)
    },
    // 新增用户
    add() {
      this.userState = 1
      this.addFormDialog = true
      this.phoneShow = false
      this.addForm = {
        name: '', // 昵称
        password: '', // 密码
        email: '', // 邮箱
        phone: '', // 手机
        sex: '男', // 性别
        state: 1, // 是否启用 1-是 0-否
        roleIds: [] // 角色id
      }
    },
    // 确认新增用户
    addForm_enter(ruleForm) {
      console.log(this.addForm)
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          if (this.userState) {
            userAdd(this.addForm).then(res => {
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
            userUpdate(this.addForm).then(res => {
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
    // 编辑用户
    edit(row) {
      this.userState = 0
      this.addFormDialog = true
      this.phoneShow = true
      console.log(row)
      userGetById({ businessUserId: row.businessUserId }).then(res => {
        this.addForm = res.data
        this.addForm.roleIds = res.data.ids
        console.log(this.addForm)
        console.log(this.roleList)
        // this.addForm.roleIds = [1];
      })
    },
    // 删除用户
    async del(row) {
      this.$confirm('此操作将永久删除该用户, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          userDelete({ businessUserId: row.businessUserId }).then(res => {
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
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getList(formInline)
      const res2 = await roleGetall({ search: '', page: 1, pageSize: 10 })
      this.tableData = res.data.list
      this.total = res.data.total
      this.roleList = res2.data.list
    },
    // 中间部分
    hidden (str, frontLen, endLen) {
      let endLenData = 0
      if (str.length !== 2) {
        endLenData = endLen
      }
      const len = str.length - frontLen - endLenData;
      let xing = '';
      for (let i = 0; i < len; i++) {
        xing += '*';
      }
      return (
        str.substring(0, frontLen) + xing + str.substring(str.length - endLenData)
      );
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
