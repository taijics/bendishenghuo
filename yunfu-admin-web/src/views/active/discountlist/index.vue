<template>
  <div class="zhekouPage">
    <!-- 搜索 -->
    <el-form :inline="true" :model="query">
      <el-form-item label="活动名称">
        <el-input
          v-model="query.discountName"
          maxlength="20"
          placeholder="请输入活动名称"
        />
      </el-form-item>
      <el-form-item label="活动状态">
        <el-select v-model="query.state" placeholder="请选择活动状态">
          <el-option
            v-for="item in activityStatusSelect"
            :key="item.index"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" plain @click="search">查询</el-button>
        <el-button plain @click="clear">重置</el-button>
        <el-button type="primary" plain @click="addActivity"
          >新建活动</el-button
        >
      </el-form-item>
    </el-form>
    <!-- 表格 -->
    <el-table
      v-loading="tableLoading"
      :data="tableData"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      tooltip-effect="dark"
      style="width: 100%"
      class="dataTable"
    >
      <el-table-column
        prop="discountName"
        label="活动名称"
        align="center"
        width="220"
      />
      <el-table-column prop="content" label="活动内容" align="center" />
      <el-table-column label="活动状态" align="center">
        <template #default="scope">
          <span v-if="scope.row.state == 0">报名未开始</span>
          <span v-if="scope.row.state == 1">报名进行中</span>
          <span v-if="scope.row.state == 2">活动待开始</span>
          <span v-if="scope.row.state == 3">活动进行中</span>
          <span v-if="scope.row.state == 4">活动已结束</span>
        </template>
      </el-table-column>
      <el-table-column prop="signTime" label="报名时间" align="center" />
      <el-table-column prop="time" label="起止时间" align="center" />
      <el-table-column prop="shops" label="商家数" align="center" />
      <el-table-column prop="products" label="商品数量" align="center" />
      <el-table-column label="操作" align="center">
        <template #default="scope">
          <div class="btnList">
            <el-button type="primary" link @click="details(scope.row)"
              >详情</el-button
            >
            <el-button
              v-if="scope.row.state != 4"
              type="primary"
              link
              @click="editActivity(scope.row)"
              >编辑</el-button
            >
            <el-popconfirm
              v-if="scope.row.state !== 4"
              title="确认结束？"
              @confirm="endActivity(scope.row)"
            >
              <template #reference>
                <el-button type="danger" link>结束</el-button>
              </template>
            </el-popconfirm>
            <el-popconfirm
              v-if="scope.row.state === 4"
              title="确认删除？"
              @confirm="delActivity(scope.row)"
            >
              <template #reference>
                <el-button type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :current-page="query.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="query.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="total"
      style="margin: 12px 0"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
    <AddActive ref="addActiveRef" @refersh="refersh" />
    <ActivityDetail ref="activityDetailRef" />
  </div>
</template>

<script setup>
import AddActive from "@/views/active/discountlist/discountAdd.vue";
import ActivityDetail from "@/views/active/discountlist/discountDetail.vue";
import {
  getDiscountData,
  stopDiscountData,
  delDiscountData,
} from "@/api/active/active_discount.js";
import { onMounted, ref } from "vue";
const query = ref({
  discountName: "", // 活动名称
  // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
  state: "",
  page: 1,
  pageSize: 10,
});
const tableLoading = ref(false);
const total = ref(1);
const tableData = ref([]);
const activityStatusSelect = ref([
  {
    index: 0,
    label: "报名未开始",
    value: 0,
  },
  {
    index: 1,
    label: "报名进行中",
    value: 1,
  },
  {
    index: 2,
    label: "活动待开始",
    value: 2,
  },
  {
    index: 3,
    label: "活动进行中",
    value: 3,
  },
  {
    index: 4,
    label: "活动已结束",
    value: 4,
  },
]);
const addActiveRef = ref(null);
const activityDetailRef = ref(null);
onMounted(() => getAll());

function getAll() {
  tableLoading.value = true;
  getDiscountData(query.value)
    .then((res) => {
      tableData.value = res.data.list;
      total.value = res.data.total;
    })
    .finally(() => {
      tableLoading.value = false;
    });
}

function handleSizeChange(val) {
  query.value.pageSize = val;
  getAll();
}

function handleCurrentChange(val) {
  query.value.page = val;
  getAll();
}

function search() {
  total.value = 1;
  query.value.page = 1;
  getAll();
}

function clear() {
  query.value = {
    discountName: "",
    state: "",
    page: 1,
    pageSize: 10,
  };
  getAll();
}

function details(row) {
  activityDetailRef.value.open(row.discountId);
}

function addActivity() {
  addActiveRef.value.open();
}

function editActivity(row) {
  addActiveRef.value.open(row);
}

async function endActivity(item) {
  const res = await stopDiscountData({ discountId: item.discountId });
  if (res.code === "") {
    ElMessage.success("结束成功");
  } else {
    ElMessage.error(res.message);
  }
  getAll();
}

async function delActivity(item) {
  const res = await delDiscountData({ discountId: item.discountId });
  if (res.code === "") {
    ElMessage({
      message: "结束成功",
      type: "success",
    });
  } else {
    ElMessage.error(res.message);
  }
  getAll();
}

function refersh() {
  getAll();
}
</script>

<style lang="scss" scoped>
.zhekouPage {
  padding: 20px;
  margin-top: 20px;
  background-color: #ffffff;
  .tableBox {
    .fenye {
      margin-top: 20px;
    }
  }
}
</style>
