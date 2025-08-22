<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="活动名称">
            <el-input
              v-model="formInline.activityName"
              maxlength="20"
              placeholder="请输入活动名称"
            />
          </el-form-item>
          <el-form-item label="活动状态">
            <el-select v-model="formInline.state" placeholder="请选择活动状态">
              <el-option label="报名未开始" value="0" />
              <el-option label="报名进行中" value="1" />
              <el-option label="活动待开始" value="2" />
              <el-option label="活动进行中" value="3" />
              <el-option label="活动已结束" value="4" />
            </el-select>
          </el-form-item>
          <el-form-item label="营销方式">
            <el-select
              v-model="formInline.discountMode"
              placeholder="请选择营销方式"
            >
              <el-option label="满减" value="1" />
              <el-option label="优惠券" value="2" />
            </el-select>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
            <el-button type="primary" plain @click="addActive"
              >新建活动</el-button
            >
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          :data="tableData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column label="活动名称" width="220">
            <template #default="scope">{{ scope.row.activityName }}</template>
          </el-table-column>
          <el-table-column label="活动状态">
            <template #default="scope">
              <span v-if="scope.row.state == 0">报名未开始</span>
              <span v-if="scope.row.state == 1">报名进行中</span>
              <span v-if="scope.row.state == 2">活动待开始</span>
              <span v-if="scope.row.state == 3">活动进行中</span>
              <span v-if="scope.row.state == 4">活动已结束</span>
            </template>
          </el-table-column>
          <el-table-column prop="discountMode" label="营销方式">
            <template #default="scope">
              <span v-if="scope.row.discountMode == 1">满减</span>
              <span v-if="scope.row.discountMode == 2">优惠券</span>
            </template>
          </el-table-column>
          <el-table-column prop="shopNumber" label="商家数" />
          <el-table-column prop="productNumber" label="商品数量" />
          <el-table-column label="操作" show-overflow-tooltip>
            <template #default="scope">
              <div class="btnList">
                <el-button type="text" @click="details(scope.row)"
                  >详情</el-button
                >
                <el-button
                  v-if="scope.row.state != 4"
                  type="text"
                  @click="edit(scope.row)"
                  >编辑</el-button
                >
                <el-button
                  v-if="scope.row.state != 4"
                  type="text"
                  @click="del(scope.row)"
                  >结束</el-button
                >
                <el-button
                  v-if="scope.row.state == 4"
                  type="text"
                  @click="deleteA(scope.row)"
                  >删除</el-button
                >
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
    <el-dialog
      :title="'直播间信息'"
      v-model="activityVisible"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <AddActive />
    </el-dialog>
  </div>
</template>

<script>
import AddActive from '@/views/active/addActive.vue'
import { activeGetAll, activeEnd, activeDelete } from '@/api/active'
export default {
  components: {
    AddActive,
  },
  data() {
    // 这里存放数据
    return {
      formInline: {
        activityName: '',
        // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
        state: '',
        discountMode: '', // 优惠方式 1-满减 2-优惠券
        page: 1,
        pageSize: 10,
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      activityVisible: false,
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
    // 新建活动
    addActive() {
      // this.$router.push({
      //   name: 'addActive'
      // })
      this.activityVisible = true
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 重置
    clear() {
      this.formInline = {
        activityName: '',
        // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
        state: '',
        discountMode: '', // 优惠方式 1-满减 2-优惠券
        page: 1,
        pageSize: 10,
      }
      this.getAll(this.formInline)
    },
    // 详情
    details(row) {
      // this.$router.push({ name: 'activeDetails', query: { info: row }})
    },
    // 编辑
    edit(item) {
      // this.$router.push({
      //   name: 'addActive',
      //   query: { info: item }
      // })
    },
    // 删除活动
    async deleteA(row) {
      const res = await activeDelete({ activityId: row.activityId })
      if (res.code === '') {
        this.$message({
          message: '删除成功',
          type: 'success',
        })
        this.getAll(this.formInline)
      }
    },
    // 结束
    async del(row) {
      const res = await activeEnd({ activityId: row.activityId })
      if (res.code === '') {
        this.$message({
          message: '结束成功',
          type: 'success',
        })
        this.getAll(this.formInline)
      }
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await activeGetAll(formInline)
      console.log(res)
      this.tableData = res.data.list
      this.total = res.data.total
    },
  },
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 30px;
}
.fenye {
  margin-top: 20px;
}
.detail_title {
  font-size: 24px;
  color: #333333;
  position: relative;
  margin: 50px 20px 20px;
  &:before {
    content: '';
    display: block;
    position: absolute;
    top: 5px;
    left: -20px;
    width: 4px;
    height: 24px;
    background-color: #3a68f2;
  }
}
</style>
