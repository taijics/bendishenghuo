<!--  -->
<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form>
        <el-form-item>
          <el-button v-if="authState==2" type="success" @click="add">添加</el-button>
        </el-form-item>
        <el-form-item>
          <el-button v-if="authState==1" type="success" @click="goAuthPageUrl">去授权</el-button>
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
        <el-table-column prop="kfId" label="客服id" />
        <el-table-column prop="name" label="客服名称" />
        <el-table-column width="100" label="客服头像">
          <template slot-scope="scope">
            <img
              style="width: 40px; height: 40px"
              :src="scope.row.headImg"
              alt=""
            >
          </template>
        </el-table-column>
        <el-table-column prop="url" label="客服链接" />
        <!-- <el-table-column prop="name" label="接待人数量" /> -->
        <el-table-column label="操作" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="btnList">
              <el-button type="text" @click="edit(scope.row)">编辑</el-button>
              <el-button type="text" @click="del(scope.row)">删除</el-button>
              <el-button type="text" @click="reception(scope.row)">接待人员管理</el-button>
            </div>
          </template>
        </el-table-column>
        <template slot="empty">
          <div>
            {{ authState==1?'暂未授权':'暂无数据' }}
          </div>
        </template>
      </el-table>
    </div>

    <!-- *************对话框开始************* -->
    <el-dialog
      :title="userState ? '新增客服' : '修改客服'"
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
          <el-form-item label="客服头像" prop="headImg">
            <!-- 上传图片 -->
            <div class="uploadWidth">
              <el-upload
                class="avatar-uploader"
                list-type="picture-card"
                :headers="headers"
                :action="uploadUrl"
                :show-file-list="false"
                :on-success="handlePictureCardPreview"
              >
                <img
                  v-if="headImg"
                  :src="headImg"
                  class="avatar"
                >
                <i v-else class="el-icon-plus avatar-uploader-icon" />
              </el-upload>
            </div>
          </el-form-item>
          <el-form-item label="客服名称" prop="name">
            <el-input v-model="addForm.name" maxlength="20" placeholder="请输入客服名称" />
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addFormDialog = false">取 消</el-button>
        <el-button type="primary" @click="addForm_enter('ruleForm')">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 接待人员管理 -->
    <el-drawer
      title="接待人员管理"
      :visible.sync="servicePage"
      direction="rtl"
      class="serviceBox"
      size="60%"
    >
      <div class="userStyle">
        <el-form :inline="true">
          <el-form-item label="客服名称:">
            {{ serviceItem.name }}
          </el-form-item>
          <br>
          <el-form-item label="客服头像:">
            <img
              style="width: 60px; height: 60px"
              :src="serviceItem.headImg"
              alt=""
            >
          </el-form-item>
        </el-form>
        <el-form :inline="true" :model="ReceptionistForm">
          <el-form-item>
            <el-button type="success" plain @click="addReception">添加</el-button>
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <div class="userStyle">
        <el-table
          ref="multipleTable"
          :data="serverData"
          border
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column prop="name" label="名称" />
          <el-table-column prop="state" label="接待状态">
            <template slot-scope="scope">
              <span v-if="scope.row.state == 0">接待中</span>
              <span v-if="scope.row.state == 1">空闲</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button type="text" @click="deleteReceptionist(scope.row)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-drawer>
    <!-- 接待人弹窗 -->
    <el-dialog
      title="添加接待人"
      :visible.sync="addServerShow"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <el-form :inline="true" :model="CustomerForm" class="demo-form-inline">
        <el-form-item class="inputWide" label="部门">
          <el-select
            v-model="CustomerName"
            placeholder="请选择"
            @change="selDepartment"
          >
            <el-option
              v-for="item in DepartmentList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          ref="multipleTable"
          :data="CustomerData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          max-height="400"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="55" />
          <el-table-column
            prop="name"
            label="接待人昵称"
            show-overflow-tooltip
          />
        </el-table>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addServerShow = false">取 消</el-button>
        <el-button type="primary" @click="addReceptionSubmit()">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import {
  getAllList,
  delService,
  AddService,
  UpService,
  getAllReceptionist,
  getDepartmentList,
  getExternalUserList,
  saveReceptionist,
  deleteReceptionist,
  checkAuthState
} from '@/api/server';
import { QYuploadUrl } from '@/utils/request';
import { getToken } from '@/utils/auth';
export default {
  // import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    // 这里存放数据
    return {
      uploadUrl: QYuploadUrl,
      headers: {
        'Authorization-business': getToken()
      },
      formInline: {
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
      },
      total: 1,
      tableData: [],
      userState: 1,
      addForm: {
        headImg: '',
        name: '',
      },
      addFormDialog: false,
      userRules: {
        name: [{ required: true, message: '请输入客服名称', trigger: 'blur' }],
        headImg: [{ required: true, message: '请上传头像', trigger: 'blur' }],
      },
      servicePage: false,
      serviceItem: {},
      serverData: [],
      addServerShow: false,
      CustomerForm: {
        dates: [], // 成为客户时间数组
        lastTimes: [], // 上次消费时间
        phone: '', // 手机号
        page: 1, // 当前页
        pageSize: 10, // 每页数
        labelId: null,
      },
      CustomerData: [],
      DepartmentList: [],
      CustomerName: '',
      ReceptionistForm: {
        name: '',
        state: null,
        openKfId: '',
        userIdList: [],
      },
      headImg: '',
      authState: null,
      authPageUrl: ''
    };
  },
  // 监听属性 类似于data概念
  computed: {},
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getAll(this.formInline);
    this.getAuthState()
  },
  // 方法集合
  methods: {
    getAuthState() {
      checkAuthState().then(res => {
        console.log(res)
        // 授权状态 1-未授权 2-已授权 3-获取授权链接异常
        this.authState = res.data.state
        this.authPageUrl = res.data.authPageUrl
      })
    },
    goAuthPageUrl() {
      if (this.authPageUrl) {
        window.open(this.authPageUrl)
      }
    },
    // 上传
    handlePictureCardPreview(file) {
      this.headImg = file.data.url;
      this.addForm.headImg = file.data.mediaId;
    },
    // 分页管理
    handleSizeChange(val) {
      this.formInline.pageSize = val;
      this.getAll(this.formInline);
    },
    handleCurrentChange(val) {
      this.formInline.page = val;
      this.getAll(this.formInline);
    },
    // 新增用户
    add() {
      if (this.tableData.length < 10) {
        this.userState = 1;
        this.addFormDialog = true;
        this.addForm = {
          name: '', //
          headImg: '', //
          openKfId: '',
        };
        this.headImg = ''
      } else {
        this.$message.warning('最多添加10个客服');
      }
    },
    // 编辑用户
    edit(row) {
      this.userState = 0;
      this.addFormDialog = true;
      const item = Object.assign({}, row)
      this.addForm = item;
      this.headImg = this.addForm.headImg
    },
    // 确认新增用户
    addForm_enter(ruleForm) {
      this.$refs[ruleForm].validate((valid) => {
        if (valid) {
          if (this.userState === 1) {
            AddService(this.addForm).then((res) => {
              console.log(res);
              if (res.code === '') {
                this.$message({
                  message: '新增成功',
                  type: 'success',
                });
              }
              this.getAll(this.formInline);
              this.addFormDialog = false;
            });
          } else {
            UpService(this.addForm).then((res) => {
              console.log(res);
              if (res.code === '') {
                this.$message({
                  message: '修改成功',
                  type: 'success',
                });
              }
              this.getAll(this.formInline);
              this.addFormDialog = false;
            });
          }
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    // 删除用户
    async del(row) {
      this.$confirm('此操作将永久删除该客服, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          delService({ openKfId: row.openKfId }).then((res) => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!',
              });
            }
            this.getAll(this.formInline);
          });
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '已取消删除',
          });
        });
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getAllList(formInline);
      this.tableData = res.data;
      // this.total = res.data.total
    },
    reception(row) {
      console.log(row, 123456789);
      this.serviceItem = row;
      this.ReceptionistForm.openKfId = row.openKfId;
      this.servicePage = true;
      this.getAllReceptionist();
    },
    // 获取客服下的接待人员
    getAllReceptionist() {
      getAllReceptionist(this.ReceptionistForm).then((res) => {
        this.serverData = res.data;
      });
    },
    clear() {
      this.ReceptionistForm.name = '';
      this.ReceptionistForm.state = null;
      this.getAllReceptionist();
    },
    // 添加接待人
    addReception() {
      this.addServerShow = true;
      this.getDepartmentList();
    },
    // 获取客户列表数据
    async getDepartmentList() {
      const res = await getDepartmentList();
      this.DepartmentList = res.data;
      const pid = this.DepartmentList[0].id;
      this.CustomerName = this.DepartmentList[0].name;
      this.getCustomerAll(pid);
    },
    selDepartment(e) {
      console.log(e);
      this.getCustomerAll(e);
    },
    getCustomerAll(pid) {
      getExternalUserList({ id: pid }).then((res) => {
        this.CustomerData = res.data;
      });
    },
    // 选中接待人员
    handleSelectionChange(val) {
      this.ReceptionistForm.userIdList = val.map((el) => {
        return el.userId;
      });
      console.log(this.ReceptionistForm.userIdList);
    },
    // 确认添加
    addReceptionSubmit() {
      saveReceptionist(this.ReceptionistForm).then((res) => {
        this.addServerShow = false;
        this.$message.success('添加成功');
        this.getAllReceptionist();
      });
    },
    // 删除接待员
    deleteReceptionist(row) {
      this.ReceptionistForm = row;
      this.$confirm('此操作将永久删除该接待员, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          deleteReceptionist(this.ReceptionistForm).then((res) => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!',
              });
            }
            this.getAllReceptionist();
          });
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '已取消删除',
          });
        });
    },
  },
};
</script>
<style lang='scss' scoped>
.userStyle {
  padding: 20px;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 140px;
  height: 140px;
  line-height: 140px;
  text-align: center;
}
.avatar {
  width: 100%;
  height: 100%;
  display: block;
}
</style>
