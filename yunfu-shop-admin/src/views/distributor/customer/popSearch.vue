<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="客户昵称">
            <el-input v-model="formInline.name" maxlength="20" placeholder="请输入客户昵称" />
          </el-form-item>
          <el-form-item label="客户手机号">
            <el-input v-model="formInline.phone" maxlength="11" placeholder="请输入客户手机号" />
          </el-form-item>
          <el-form-item label="分销员昵称">
            <el-input v-model="formInline.distributorName" maxlength="20" placeholder="请输入分销员昵称" />
          </el-form-item>
          <el-form-item label="绑定状态">
            <el-select v-model="formInline.ifBind" placeholder="请选择绑定状态">
              <el-option label="全部" :value="null" />
              <el-option label="已绑定" value="1" />
              <el-option label="未绑定" value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label-width="0">
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
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
            <el-table-column prop="name" label="客户昵称" />
            <el-table-column prop="phone" label="客户手机号" />
            <el-table-column prop="distributorName" label="所属分销员" />
            <el-table-column prop="distributorPhone" label="分销员手机号" />
            <el-table-column label="绑定状态">
              <template slot-scope="scope">
                <span v-if="scope.row.ifBind == 0">未绑定</span>
                <span v-if="scope.row.ifBind == 1">已绑定</span>
              </template>
            </el-table-column>
            <el-table-column prop="updateTime" label="关系更新时间" />
            <el-table-column label="操作" show-overflow-tooltip>
              <template slot-scope="scope">
                <div class="btnList">
                  <el-button type="text" @click="relieve(scope.row)">解绑</el-button>
                  <el-button type="text" @click="add(scope.row)">绑定</el-button>
                  <el-button type="text" @click="del(scope.row)">移除</el-button>
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
    <!-- *****************************弹框开始***************************** -->
    <!-- 解绑/移除弹框 -->
    <el-dialog
      :visible.sync="isVisible.show"
      :title="isVisible.title"
      center
      :close-on-click-modal="false"
      width="30%"
    >
      <div style="text-align: center;">
        <div class="unbindimg">
          <img src="../../../assets/images/tixing.png" alt srcset>
        </div>
        <div class="dialog_content">{{ isVisible.text }}</div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isVisible.show = false">取消</el-button>
        <el-button type="primary" @click="agreeEn">确认</el-button>
      </span>
    </el-dialog>
    <el-dialog
      :visible.sync="isVisible.shows"
      :title="isVisible.title"
      center
      :close-on-click-modal="false"
      width="30%"
    >
      <div style="text-align: center;">
        <div style="display: flex" class="diaoCen">
          <el-input v-model="searchs" maxlength="20" style="width:200px" clearable placeholder="请输入分销员名称" />
          <el-button type="primary" @click="searchDis">查询</el-button>
        </div>
        <el-radio-group v-model="distributorId">
          <el-radio
            v-for="(item,index) in inviteList"
            :key="index"
            :label="item.distributorId"
          >{{ item.distributorName }}</el-radio>s
        </el-radio-group>
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
  shipGetAll,
  shipAdd,
  getAllInvitees,
  relieveBind,
  shipDelete
} from '@/api/distributor'
export default {
  data() {
    return {
      formInline: {
        name: '', // 客户昵称
        phone: '', // 客户手机号
        distributorName: '', // 分销员昵称
        ifBind: null, // 绑定状态 是否绑定 1-是 0-否
        page: 1,
        pageSize: 10
      },
      distributorId: '',
      isVisible: {},
      total: 1,
      tableData: [],
      currentPage: 1,
      searchs: '',
      inviteList: []
    }
  },
  created() {
    this.getAll(this.formInline)
    this.getList()
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
    searchDis() {
      this.getList()
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 绑定
    add(row) {
      this.isVisible = {
        shows: true,
        title: '绑定',
        index: 1,
        arr: row
      }
    },
    // 解绑
    relieve(row) {
      this.isVisible = {
        show: true,
        title: '解绑',
        text: '解绑后对应的分销员将失去绑定关系，并且无法再获得收益',
        index: 2,
        arr: row
      }
    },
    // 移除
    del(row) {
      this.isVisible = {
        show: true,
        title: '移除',
        text: '移除后客户将从分销员工具消失， 但仍可被其他分销员绑定关系',
        index: 3,
        arr: row
      }
    },
    async agreeEn() {
      if (this.isVisible.index === 1) {
        if (this.distributorId === '') {
          this.$message.error('请选择分销员')
          return
        }
        const res = await shipAdd({
          buyerUserId: this.isVisible.arr.buyerUserId,
          distributorId: this.distributorId
        })
        if (res.code === '') {
          this.$message.success('绑定成功')
          this.getAll(this.formInline)
          this.searchs = ''
          this.isVisible.shows = false
        }
      } else if (this.isVisible.index === 2) {
        const res = await relieveBind({
          buyerUserId: this.isVisible.arr.buyerUserId,
          distributorId: this.isVisible.arr.distributorId
        })
        if (res.code === '') {
          this.$message.success('解绑成功')
          this.getAll(this.formInline)
          this.isVisible.show = false
        }
      } else if (this.isVisible.index === 3) {
        const res = await shipDelete({
          buyerUserId: this.isVisible.arr.buyerUserId,
          distributorId: this.isVisible.arr.distributorId
        })
        if (res.code === '') {
          this.$message.success('移除成功')
          this.getAll(this.formInline)
          this.isVisible.show = false
        }
      }
    },
    // 清除
    clear() {
      this.formInline = {
        name: '', // 客户昵称
        phone: '', // 客户手机号
        distributorName: '', // 分销员昵称
        ifBind: null, // 绑定状态 是否绑定 1-是 0-否
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await shipGetAll(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
    },
    // 初始化查询所有邀请人
    async getList() {
      const res = await getAllInvitees({
        search: this.searchs
      })
      this.inviteList = res.data
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
.diaoCen {
  display: flex;
  justify-content: center;
  input {
    width: 200px;
  }
  button {
    margin-left: 20px;
  }
}
.el-radio-group {
  margin-top: 20px;
}
::v-deep .el-radio__inner {
  width: 30px;
  height: 30px;
}
::v-deep.el-radio__label {
  font-size: 18px;
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

