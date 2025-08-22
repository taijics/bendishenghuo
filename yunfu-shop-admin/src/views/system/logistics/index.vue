<!--  -->
<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formParams" class="demo-form-inline">
          <el-form-item label="方案名称">
            <el-input v-model="formParams.logisticsName" maxlength="20" placeholder="请输入方案名称" />
          </el-form-item>
          <el-form-item>
            <el-button type="success" plain @click="add">新增物流方案</el-button>
            <el-button type="primary" plain @click="search">查询</el-button>
            <span v-for="(item,index) in btnList" :key="index" class="promissStyle">
              <el-button type="success" plain @click="btnClick(item)">{{ item.permissionName }}</el-button>
            </span>
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
          <el-table-column label="方案名称" width="220">
            <template slot-scope="scope">{{ scope.row.logisticsName }}</template>
          </el-table-column>
          <el-table-column prop="regions" label="可配送范围" width="420" />
          <el-table-column prop="name" label="计费方式" width="220">
            <template slot-scope="scope">
              <span v-if="scope.row.chargeType == 1">按件数</span>
              <span v-if="scope.row.chargeType == 2">按重量</span>
              <span v-if="scope.row.chargeType == 3">包邮</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button type="text" @click="seeMore(scope.row)">查看</el-button>
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
    </div>
    <!-- 方案组件 -->
    <grope-edit
      ref="edit"
      :dialog-visible="dialog.isVisible"
      :type="dialog.type"
      @close="editClose"
      @success="getLists"
    />
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import { getBtnList } from '@/utils/auth'
import { logisticsGetAll, logisticsDelete } from '@/api/shopSys'
import GropeEdit from './Edit'
export default {
  components: {
    GropeEdit
  },
  data() {
    // 这里存放数据
    return {
      btnList: '',
      formParams: {
        logisticsName: '',
        page: 1,
        pageSize: 10
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      dialog: {
        type: 'add',
        isVisible: false
      }
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
    this.getList(this.formParams)
    this.btnList = getBtnList()
    console.log(this.btnList, 'btnList')
  },
  // 方法集合
  methods: {
    btnClick(id) {
      console.log(id)
      if (id.permissionName === '新建方案') {
        this.add()
      }
    },
    handleSizeChange(val) {
      this.formParams.pageSize = val
      this.getList(this.formParams)
    },
    handleCurrentChange(val) {
      this.formParams.page = val
      this.getList(this.formParams)
    },
    getLists() {
      console.log(111)
      this.getList(this.formParams)
    },
    // 查询
    search() {
      this.total = 1
      this.formParams.page = 1
      this.getList(this.formParams)
    },
    // 新建方案
    add() {
      this.dialog = {
        type: 'add',
        isVisible: true
      }
    },
    // 查看
    seeMore(row) {
      const { logisticsId } = row
      this.dialog = {
        type: 'check',
        isVisible: true
      }
      this.$refs.edit.setParams({
        checkId: logisticsId
      })
    },
    // 编辑
    edit(row) {
      const { logisticsId } = row
      this.dialog = {
        type: 'edit',
        isVisible: true
      }
      this.$refs.edit.setParams({
        checkId: logisticsId
      })
    },
    // 关闭弹框
    editClose() {
      this.dialog.isVisible = false
    },
    // 删除
    del(row) {
      this.$confirm('选中数据将被永久删除, 是否继续？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(() => {
          logisticsDelete({ logisticsId: row.logisticsId }).then(res => {
            if (res.code === '') {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
            }
            this.getList(this.formParams)
          })
        })
        .catch(() => {})
    },
    // 初始化查询所有数据
    async getList(formParams) {
      const res = await logisticsGetAll(formParams)
      this.tableData = res.data.list
      this.total = res.data.total
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
</style>
