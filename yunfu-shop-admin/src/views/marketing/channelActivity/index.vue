<!--
    * @FileDescription: 渠道券活动
    * @Author: kahu
    * @Date: 2022/8/25
    * @LastEditors: kahu
    * @LastEditTime: 2022/8/25
-->
<template>
  <div class="content">
    <el-button
      type="primary"
      @click="handleEditForm"
    >新增
    </el-button>
    <el-table
      v-loading="loading"
      :data="list"
      :header-cell-style="tableOptions.headStyle"
      class="table"
    >
      <el-table-column
        type="selection"
      />
      <el-table-column
        prop="id"
        label="活动ID"
        width="180"
        show-overflow-tooltip
      />
      <el-table-column
        prop="activityName"
        label="活动名称"
        width="180"
        show-overflow-tooltip
      />
      <el-table-column
        prop="activityUrl"
        label="活动链接"
        show-overflow-tooltip
      >
        <template v-slot="scope">
          <span
            v-if="scope.row.activityUrl"
          >{{ scope.row.activityUrl }}
          </span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="beginningAndEndingTime"
        label="活动起止时间"
        width="180"
        :formatter="row=>row.startTime+' - '+row.endTime"
      />
      <el-table-column
        prop="status"
        label="状态"
        width="180"
      >
        <template v-slot="scope">
          <el-tag
            v-if="scope.row.state===0"
            type="warning"
          >未开始
          </el-tag>
          <el-tag
            v-if="scope.row.state===1"
            type="success"
          >进行中
          </el-tag>
          <el-tag
            v-if="scope.row.state===2"
            type="danger"
          >已结束
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="publishCount"
        label="活动发放总数"
        width="180"
      />

      <el-table-column
        prop="releaseCount"
        label="已发放总数"
        width="180"
      />
      <el-table-column
        prop="address"
        label="操作"
        width="320"
        fixed="right"
      >
        <template v-slot="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleCopeLink(scope.row)"
          >复制链接
          </el-button>
          <el-button
            size="mini"
            type="warning"
            @click="handleEditForm(scope.row,true)"
          >详情
          </el-button>
          <el-button
            v-if="scope.row.state === 0"
            size="mini"
            type="warning"
            @click="handleEditForm(scope.row)"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
          >删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      background
      layout="total, sizes, prev, pager, next, jumper"
      :current-page="queryOptions.page"
      :page-size="queryOptions.pageSize"
      :page-sizes="tableOptions.pageSizes"
      :total="tableOptions.total"
      @size-change="(val)=>handlePageChange(val,1)"
      @current-change="(val)=>handlePageChange(val,2)"
    />

    <ActiveForm v-model="showForm" :item="formItem" @confirm="handleGetTable" />
  </div>
</template>

<script>
import ActiveForm from './form'
import { getAll, del } from '@/api/channelActivity';

export default {
  name: 'ChannelActivity',
  components: { ActiveForm },
  data() {
    return {
      showForm: false,
      formItem: {},
      loading: false,
      list: [],
      queryOptions: {
        page: 1,
        pageSize: 10
      },
      tableOptions: {
        headStyle: { background: '#EEF3FF', color: '#333333' },
        pageSizes: [5, 10, 30, 50, 100],
        total: 0
      }
    }
  },
  created() {
    this.handleGetTable()
  },
  methods: {
    async handleGetTable() {
      this.loading = true
      const { data } = await getAll(this.queryOptions);
      this.list = data.list
      this.tableOptions.total = data.total
      this.loading = false
    },
    /**
     * 分页
     * @param val
     * @param type 1page 2pageSize
     */
    handlePageChange(val, type) {
      type === 1 ? this.queryOptions.page = val : this.queryOptions.pageSize = val
      this.handleGetTable()
    },
    handleEditForm(item, isLook = false) {
      if (!item) {
        this.formItem = {}
      } else {
        this.formItem = item
        if (isLook) {
          this.formItem.isLook = true
        } else {
          this.formItem.isLook = false
        }
      }
      this.showForm = true
    },
    handleCopeLink(item) {
      const htmlInputElement = document.createElement('input');
      htmlInputElement.value = item.activityUrl
      document.body.appendChild(htmlInputElement);
      htmlInputElement.select()
      document.execCommand('copy')
      document.body.removeChild(htmlInputElement)
      this.$message.success('复制成功')
    },
    handleDelete(item) {
      const message = `是否删除活动${item.activityName}`
      this.$confirm(message, '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async() => {
        // 删除逻辑
        this.loading = true
        await del({ id: item.id })
        this.handleGetTable()
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
      }).catch(() => {
      }).finally(() => {
        this.loading = false
      });
    }
  }
}
</script>

<style
  lang="scss"
  scoped
>
.content {
  padding: 20px;

  .table {
    margin: 20px 0;
  }
}
</style>
