<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="分销员昵称">
            <el-input v-model="formInline.distributorName" maxlength="20" placeholder="请输入分销员昵称" />
          </el-form-item>
          <el-form-item label="分销员手机号">
            <el-input v-model="formInline.distributorPhone" maxlength="11" placeholder="请输入手机号" />
          </el-form-item>
          <el-form-item label="加入时间">
            <el-date-picker
              v-model="formInline.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd"
            />
          </el-form-item>
          <el-form-item label="分销员等级">
            <el-select v-model="formInline.distributorLevelId" placeholder="请选择分销员等级">
              <el-option
                v-for="(item,index) in humenList"
                :key="index"
                :label="item.levelName"
                :value="item.distributorLevelId"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
            <el-button type="success" plain @click="add">添加分销员</el-button>
          </el-form-item>
        </el-form>
      </div>
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <el-table
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
          >
            >
            <el-table-column prop="distributorName" label="分销员昵称" />
            <el-table-column prop="distributorPhone" label="分销员手机号" />
            <el-table-column prop="inviteesName" label="邀请人" />
            <el-table-column prop="levelName" label="分销员等级" />
            <el-table-column prop="total" label="累计客户" />
            <el-table-column prop="subordinate" label="累计下级" />
            <el-table-column prop="money" label="累计佣金(元 )" />
            <el-table-column label="操作" show-overflow-tooltip>
              <template slot-scope="scope">
                <div class="btnList">
                  <el-button type="text" @click="edit(scope.row)">编辑</el-button>
                  <el-button type="text" @click="del(scope.row)">清退</el-button>
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
      </div>
    </div>
    <!-- 分销员弹框 -->
    <el-dialog
      :visible.sync="isVisible.show"
      :title="isVisible.title"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div>
        <el-form ref="form" :model="form" :rules="rules" label-width="120px">
          <el-form-item label="分销员昵称" prop="distributorName">
            <el-input v-model="form.distributorName" maxlength="20" :disabled="isVisible.index ===2" />
          </el-form-item>
          <el-form-item label="分销员手机号" prop="distributorPhone">
            <el-input
              v-if="distributorPhoneShow"
              :value="hidden(form.distributorPhone, 3, 3)"
              :disabled="isVisible.index ===2"
              maxlength="11"
            />
            <el-input
              v-else
              v-model="form.distributorPhone"
              :disabled="isVisible.index ===2"
              maxlength="11"
            />
          </el-form-item>
          <el-form-item label="分销员等级" prop="distributorLevelId">
            <el-select v-model="form.distributorLevelId" placeholder="请选择分销员等级">
              <el-option
                v-for="(item,index) in humenList"
                :key="index"
                :label="item.levelName"
                :value="item.distributorLevelId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="邀请人" prop="invitees">
            <el-select v-model="form.invitees" clearable placeholder="请选择邀请人">
              <el-option
                v-for="(item,index) in InviteList"
                :key="index"
                :label="item.distributorName"
                :value="item.distributorId"
              />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="agreeEn">确定</el-button>
        <el-button @click="isVisible.show = false">取 消</el-button>
      </span>
    </el-dialog>

    <!-- 清退弹框 -->
    <el-dialog
      :visible.sync="isVisible.shows"
      :title="isVisible.title"
      center
      :close-on-click-modal="false"
      width="30%"
    >
      <div style="text-align: center;">
        <div class="unbindimg">
          <img src="../../../assets/images/tixing.png" alt srcset>
        </div>
        <div class="dialog_content">
          清退之后，用户将失去分销员身份，
          下级客户将会解绑关系。确定要清退吗
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isVisible.shows = false">取消</el-button>
        <el-button type="primary" @click="agreeEn">确认</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  getAllLevel,
  distributorGetAll,
  getAllInvitees,
  distributorAdd,
  distributorGetById,
  distributorUpdate,
  distributorDelete
} from '@/api/distributor'
import { hidden } from '@/utils';
export default {
  data() {
    return {
      formInline: {
        distributorName: '',
        distributorPhone: '',
        dates: [],
        distributorLevelId: '',
        page: 1,
        pageSize: 10
      },
      form: {
        invitees: '', // 邀请人id
        distributorName: '', // 分销员名称
        distributorPhone: '', // 分销员手机号
        distributorLevelId: '' // 分销员等级id
      },
      isVisible: {},
      humenList: [],
      total: 1,
      tableData: [],
      currentPage: 1,
      InviteList: [],
      privacyTime: 0,
      distributorPhoneShow: false,
      rules: {
        distributorName: [
          { required: true, message: '请输入分销员昵称', trigger: 'blur' }
        ],
        distributorPhone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { min: 11, max: 11, message: "请输入11位手机号码", trigger: "blur" },
          {
            pattern: /^1[3456789]\d{9}$/,
            message: "请输入正确的手机号码"
          }
        ],
        distributorLevelId: [{ required: true, message: '请选择分销员等级', trigger: 'change' }],
        invitees: [{ required: true, message: '请选择邀请人', trigger: 'change' }],
      },
    }
  },
  created() {
    this.getAll(this.formInline)
    this.getAllPeo()
    this.getAllPeos()
    this.privacyTime = localStorage.getItem("privacyTime");
  },
  methods: {
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    reset() {
      this.form = {
        invitees: '', // 邀请人id
        distributorName: '', // 分销员名称
        distributorPhone: '', // 分销员手机号
        distributorLevelId: '' // 分销员等级id
      }
    },
    // 添加分销员
    add() {
      this.isVisible = {
        show: true,
        title: '添加分销员',
        index: 1
      }
      this.distributorPhoneShow = false
      this.reset()
    },
    // 编辑
    async edit(row) {
      this.distributorPhoneShow = true
      const res = await distributorGetById({
        distributorId: row.distributorId
      })
      if (res.code === '') {
        this.form = res.data
        this.isVisible = {
          show: true,
          title: '编辑分销员',
          index: 2
        }
      }
    },
    async agreeEn() {
      if (this.isVisible.index === 1) {
        const res = await distributorAdd(this.form)
        if (res.code === '') {
          this.$message.success('新增成功')
          this.getAll(this.formInline)
          this.reset()
          this.isVisible.show = false
        }
      } else if (this.isVisible.index === 2) {
        const res = await distributorUpdate(this.form)
        if (res.code === '') {
          this.$message.success('编辑成功')
          this.getAll(this.formInline)
          this.reset()
          this.isVisible.show = false
        }
      } else if (this.isVisible.index === 3) {
        const res = await distributorDelete({
          distributorId: this.isVisible.distributorId
        })
        if (res.code === '') {
          this.$message.success('清退成功')
          this.getAll(this.formInline)
          this.reset()
          this.isVisible.shows = false
        }
      }
    },
    // 清退
    del(row) {
      this.isVisible = {
        shows: true,
        title: '清退',
        index: 3,
        distributorId: row.distributorId
      }
    },
    // 清除
    clear() {
      this.formInline = {
        orderFormid: '',
        distributorName: '',
        distributorPhone: '',
        dates: [],
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await distributorGetAll(formInline)
      this.tableData = res.data.list
      this.tableData.forEach((item) => {
        item.distributorPhone = hidden(item.distributorPhone, 3, 3)
      })
      this.total = res.data.total
    },
    // 初始化查询所有分销员
    async getAllPeo() {
      const res = await getAllLevel({ })
      this.humenList = res.data
    },
    // 初始化查询所有邀请人
    async getAllPeos() {
      const res = await getAllInvitees({ })
      this.InviteList = res.data
    },
    // 中间部分
    hidden(str, frontLen, endLen) {
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
      // return str
    }
  }
}
</script>

<style lang='scss' scoped>
@import url("../../../styles/elDialog.scss");
.custom_page {
  padding: 20px;
}
.checkBoxStyle {
  margin-bottom: 20px;
}
.dialog_content {
  width: 275px;
  height: 46px;
  margin: auto;
  font-size: 16px;
  font-family: PingFang SC;
  font-weight: 400;
  color: #333333;
  line-height: 30px;
  margin-top: 25px;
}
</style>

