<!-- 商品分组 -->
<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="分组名称">
            <el-input v-model="formInline.search" maxlength="20" placeholder="请输入分组名称" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button type="primary" plain @click="addNewGroup">新增分组</el-button>
            <!-- <span v-for="(item,index) in btnList" :key="index" class="promissStyle">
              <el-button type="success" plain @click="btnClick(item)">{{ item.permissionName }}</el-button>
            </span> -->
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
          <el-table-column label="分组名称" width="300">
            <template slot-scope="scope">{{ scope.row.groupName }}</template>
          </el-table-column>
          <el-table-column label="分组描述" width="300">
            <template slot-scope="scope">{{ scope.row.groupDescribe }}</template>
          </el-table-column>
          <el-table-column label="商品数量" width="150">
            <template slot-scope="scope">{{ scope.row.number }}</template>
          </el-table-column>
          <el-table-column prop="updateTime" label="修改时间" width="220" />
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button type="text" @click="edit(scope.row)">编辑</el-button>
                <!--                <el-button type="text" @click="edit(scope.row)">详情</el-button>-->
                <el-button type="text" @click="del(scope.row)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="formInline.page"
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
    <!-- 新建分组弹框 -->
    <el-dialog
      :close-on-click-modal="false"
      :title="title"
      :type="type"
      :visible.sync="isVisible"
      width="45%"
      top="50px"
      class="group-dialog"
    >
      <el-form :model="sizeForm">
        <el-form-item label="分组封面" prop="fileLength" />
        <div class="upload-wrap">
          <el-upload
            ref="upload"
            :headers="headers"
            :action="action"
            :on-success="handleImageSuccess"
            list-type="picture-card"
            :limit="1"
            :file-list="imgList"
          >
            <i class="el-icon-plus" />
          </el-upload>
        </div>

        <el-form-item label="分组名称">
          <el-input v-model="params.groupName" maxlength="20" />
        </el-form-item>
        <el-form-item size="large" class="btn-wrap">
          <el-button type="primary" @click="onSubmit">确定</el-button>
          <el-button @click="isVisible = false">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

    <el-dialog
      title="活动报名"
      :visible.sync="commidyVisible"
      width="900px"
      center
      top="10vh"
      :close-on-click-modal="false"
    >
      <CommGroup
        :group-id="shopGroupId"
        @cancel="commidyVisible = false"
        @reload="search"
      />
    </el-dialog>
  </div>
</template>

<script>
import CommGroup from '@/views/commodity/commodityList/commodityGroup.vue'
import {
  commodityListGetAll,
  commodityListDelete,
  commodityListUpdate,
  commodityListAdd
} from '@/api/commodity'
import { getBtnList, getToken } from '@/utils/auth'
import { uploadUrl } from '@/utils/request'
export default {
  components: {
    CommGroup
  },
  data() {
    // 这里存放数据
    return {
      btnList: '',
      activeName: 'first',
      formInline: {
        search: '',
        page: 1,
        pageSize: 10,
      },
      params: {
        groupImage: '',
        groupName: '',
      },
      total: 1,
      tableData: [],
      isVisible: false,
      type: 'add',
      sizeForm: {},
      imgList: [],
      commidyVisible: false,
      shopGroupId: 0,
      action: uploadUrl,
      headers: {
        'Authorization-business': getToken()
      },
    }
  },
  // 监听属性 类似于data概念
  computed: {
    title() {
      return this.type === 'add' ? '新建分组' : '查看分组'
    }
  },
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getAll(this.formInline)
    this.btnList = getBtnList()
  },
  // 方法集合
  methods: {
    btnClick(id) {
      console.log(id)
      if (id.permissionName === '新增分组') {
        this.add()
      }
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    handleImageSuccess(response) {
      const url = response.data.url
      this.params.groupImage = url
    },
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 新建分组
    add() {
      this.type = 'add'
      this.isVisible = true
      this.params = {
        groupImage: '',
        groupName: ''
      }
      this.$refs.upload.clearFiles()
    },
    // 编辑分组
    edit(row) {
      this.commidyVisible = true
      this.shopGroupId = row.shopGroupId
    },
    async onSubmit() {
      if (this.type === 'add') {
        this.addGroup()
      } else {
        this.updateGroup()
      }
    },
    async addGroup() {
      if (this.params.groupName === '') {
        this.$message.error('请输入分组名称')
        return
      }
      const res = await commodityListAdd(this.params)
      if (res.code === '') {
        this.isVisible = false
        this.$message({
          message: '新增成功',
          type: 'success'
        })
        this.getAll(this.formInline)
      }
    },
    async updateGroup() {
      const res = await commodityListUpdate(this.params)
      if (res.code === '') {
        this.isVisible = false
        this.$message({
          message: '修改成功',
          type: 'success'
        })
        this.getAll(this.formInline)
      }
    },
    // 删除分组
    del(row) {
      this.$confirm('选中数据将被永久删除, 是否继续？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          commodityListDelete({ shopGroupId: row.shopGroupId }).then(res => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
              this.getAll(this.formInline)
            }
          })
        })
        .catch(() => {})
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await commodityListGetAll(formInline)
      this.total = res.data.total
      this.tableData = res.data.list
    },
    // 1.4
    // 新增分组
    addNewGroup() {
      this.shopGroupId = 0
      this.commidyVisible = true
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
.group-dialog {
  .btn-wrap {
    text-align: center;
  }
  .upload-wrap {
    width: 100%;
    display: flex;
    align-items: flex-end;
    .image-wrap {
      width: 120px;
      height: 120px;
      line-height: 120px;
      margin-right: 15px;
      margin-bottom: 15px;
      text-align: center;
      border: 1px dashed #d9d9d9;
      img {
        width: 100%;
        height: 100%;
      }
    }
  }
}
</style>
