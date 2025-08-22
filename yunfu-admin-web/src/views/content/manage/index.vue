<template>
  <div class="main-con">
    <el-form :inline="true" :model="query">
      <el-form-item label="发布时间">
        <el-date-picker
          v-model="date"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          format="YYYY-MM-DD HH:mm:ss"
          date-format="YYYY/MM/DD ddd"
        />
      </el-form-item>
      <el-form-item label="动态类型">
        <el-select
          v-model="query.fileType"
          placeholder="请选择"
          style="width: 100px;"
        >
          <el-option label="图文" :value="1"/>
          <el-option label="视频" :value="2"/>
        </el-select>
      </el-form-item>
      <el-form-item label="发布状态">
        <el-select
          v-model="query.publishStatus"
          placeholder="请选择"
          style="width: 110px;"
        >
          <el-option label="未审核" :value="0"/>
          <el-option label="审核失败" :value="2"/>
          <el-option label="已发布" :value="1"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" plain @click="search">查询</el-button>
        <el-button plain @click="reset">重置</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="loading"
      :data="tableData.list || []"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      tooltip-effect="dark"
      style="width: 100%"
      class="dataTable"
    >
      <el-table-column prop="remark" label="动态文案">
        <template #default="scope">
          <div class="text-overflow">{{scope.row.remark}}</div>
        </template>
      </el-table-column>
      <el-table-column prop="fileType" label="动态类型" width="120">
        <template #default="scope">
          <span v-if="scope.row.fileType == 1">图文</span>
          <span v-if="scope.row.fileType == 2">视频</span>
        </template>
      </el-table-column>
      <el-table-column prop="publishStatus" label="发布状态" width="120">
        <template #default="scope">
          <span v-if="scope.row.publishStatus == 0">未审核</span>
          <span v-if="scope.row.publishStatus == 1">已发布</span>
          <span v-if="scope.row.publishStatus == 2">审核失败</span>
        </template>
      </el-table-column>
      <el-table-column prop="productCount" label="关联商品数" width="130"/>
      <el-table-column prop="likeCount" label="点赞数" width="120"/>
      <el-table-column prop="browseCount" label="浏览数" width="120"/>
      <el-table-column prop="publishTime" label="发布时间" width="170"/>
      <el-table-column prop="name" label="操作" width="160">
        <template #default="scope">
          <el-button
            type="primary"
            link
            @click="details(scope.row)">
            详情
          </el-button>
          <el-button
            v-if="scope.row.publishStatus===0"
            type="primary"
            link
            @click="toAudit(scope.row)">
            审核
          </el-button>
          <el-popconfirm
            title="确认删除？"
            @confirm="del(scope.row)"
          >
            <template #reference>
              <el-button type="danger" link>删除</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :current-page="query.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="query.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="tableData.total"
      style="margin: 20px 0 0 0;"
      @size-change="val => {handlePageChange(val, 'pageSize')}"
      @current-change="val => {handlePageChange(val, 'page')}"
    />
    <el-dialog
      v-model="visible"
      width="500px"
      align-center
      :show-close="false"
      :close-on-click-modal="false"
      class="audit-dialog"
    >
      <p class="t-center">是否通过审核？</p>
      <el-form
        :model="formData"
        ref="formRef"
        :rules="rules"
      >
        <el-form-item prop="reviewStatus">
          <el-radio-group v-model="formData.reviewStatus">
            <el-radio :label="1">通过</el-radio>
            <el-radio :label="2">审核失败</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item prop="reviewContent" v-if="formData.reviewStatus===2">
          <el-input
            type="textarea"
            v-model="formData.reviewContent"
            :autosize="{minRows: 6, maxRows: 6}"
            resize="none"
            placeholder="请填写审核失败原因"
          />
        </el-form-item>
        <el-form-item style="margin-top: 30px;" label-width="170px">
          <el-button plain @click="close">取消</el-button>
          <el-button type="primary" @click="audit(formRef)">确认</el-button>
        </el-form-item>
        </el-form>
    </el-dialog>
    <DynamicInfo ref="infoRef"/>
  </div>
</template>

<script setup>
import moment from 'moment';
import DynamicInfo from "./dynamicInfo.vue";
import {
  ref,
  reactive,
  onBeforeMount} from "vue";
import {
  contentQuery,
  contentAudit,
  contentDel
} from "@/api/content";

const  defaultQuery = {
  fileType: "",
  publishStatus: "",
  publishStartTime: '',
  publishEndTime: '',
  page: 1,
  pageSize: 10,
}
const query = ref(
  {...defaultQuery}
)
const date = ref('')
const loading = ref(false);
const tableData = reactive({
  total: 0,
  list: []
})
const defaultFormData = {
  reviewContent: '',
  reviewStatus: 1,
  recommendId: ''
};
const formData = ref({...defaultFormData});
const formRef = ref(null);
const rules = ref({
  reviewContent: [{ required: true, message: '请填写审核失败原因', trigger: 'blur' }]
})
const visible = ref(false);
const infoRef = ref(null);

onBeforeMount(() => {
  search();
})

const search = async() => {
  loading.value = true;
  if(date.value&&date.value[0]) {
    query.value.publishStartTime = moment(date.value[0]).format("YYYY-MM-DD HH:mm:ss");
    query.value.publishEndTime = moment(date.value[1]).format("YYYY-MM-DD HH:mm:ss");
  }
  const {code, data} = await contentQuery(query.value);
  if(code==='') {
    Object.assign(tableData, data);
  }
  loading.value = false;
}

function reset() {
  date.value = '';
  query.value = {...defaultQuery};
  search();
}

function handlePageChange(val, type) {
  query.value[type] = val;
  search();
}

// 审核
function toAudit(row) {
  visible.value = true;
  formData.value.recommendId = row.recommendId;
}
const  audit = async(formEl) => {
  if (!formEl) return
  await formEl.validate(async(valid) => {
    if(valid) {
      const {code} = await contentAudit(formData.value);
      if(code==='') {
        close();
        search();
        ElMessage({
          message: '审核成功',
          type: 'success',
        });
      }
    } else {
      return false;
    }
  })
}
function close() {
  visible.value = false;
  formData.value = {...defaultFormData};
}

const del = async(row) => {
  const {code} = await contentDel({recommendId: row.recommendId});
  if(code==='') {
    reset();
    ElMessage({
      message: '删除成功',
      type: 'success',
    });
  }
}

function details(row) {
  infoRef.value.getInfo(row);
}
</script>

<style lang="scss" scoped>
.main-con {
  margin-top: 20px;
  padding: 20px;
  background: #FFFFFF;
  .text-overflow {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
}
:deep(.audit-dialog) {
  .t-center {
    text-align: center;
    margin-bottom: 20px;
    padding-top: 10px;
  }
  .el-dialog__header {
    background-color: #FFFFFF;
    padding: 0;
    .el-dialog__close {
      color: rgba(0,0,0,.5);
    }
  }
  .el-dialog__headerbtn:focus,.el-dialog__headerbtn:hover {
    .el-dialog__close,.el-dialog__close {
      color: #3182bd;
    }
  }
}
</style>