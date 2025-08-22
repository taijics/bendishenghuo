<template>
  <div class="main-con">
    <el-button
      type="primary"
      style="float: right;"
      @click="hadleClassify()"
    >
      新增分类
    </el-button>
    <el-table
      v-loading="loading"
      :data="tableData"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      style="width: 100%;margin-top: 40px;"
      class="dataTable"
    >
      <el-table-column prop="recommendTypeId" label="内容分类id" />
      <el-table-column prop="name" label="分类名称" />
      <el-table-column prop="sort" label="排序" />
      <el-table-column label="操作" fixed="right">
        <template #default="scope">
          <el-popconfirm
            title="确认删除？"
            @confirm="del(scope.row)"
          >
            <template #reference>
              <el-button type="danger" link>删除</el-button>
            </template>
          </el-popconfirm>
          <el-button
            type="primary"
            link
            @click="hadleClassify(scope.row)">
            编辑
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog
      v-model="visible"
      width="600px"
      :title="`${classifyId?'编辑':'新增'}分类`"
      center
      :close-on-click-modal="false"
      @closed="onClosed"
    >
      <el-form
        ref="formRef"
        style="margin-top: 20px;max-width: 450px;"
        label-width="80px"
        :rules="userRules"
        :model="formData"
      >
        <el-form-item label="分类名" prop="name">
          <el-input v-model="formData.name"/>
        </el-form-item>
        <el-form-item label="排序值" prop="sort">
          <el-input type="number" v-model="formData.sort"/>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="addForm_enter(formRef)">确 定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import {
  reactive,
  ref,
  onBeforeMount} from "vue";
import {
  classifyQuery,
  classifyAdd,
  classifyEdit,
  classifyDelete
} from '@/api/content';
let loading = ref(false)
const formRef = ref(null)
const selectClassifyId = ref('')
const tableData = ref([
  {name: '多少'}
])
const visible = ref(false)
const submitLoading = ref(false)
const classifyId = ref('')
const formData = ref(
  {
    name: '',
    sort: null
  }
)
const userRules = ref({
  name: [
    { required: true, message: '请输入分类名', trigger: 'blur' },
  ],
  sort: [
    { required: true, message: '请输入分类值', trigger: 'blur' },
  ],
})

onBeforeMount(() => {
  getTableData();
})

const getTableData = async() => {
  loading.value = true;
  const {data} = await classifyQuery({page: 1, pageSize: 999});
  loading.value = false;
  tableData.value = data.list || [];
}

function hadleClassify(item={}) {
  selectClassifyId.value = item.recommendTypeId||'';
  formData.value = {...item};
  visible.value = true;
}

const del = async({recommendTypeId=''}) => {
  const {code} = await classifyDelete({recommendTypeId})
  if(code==='') {
    ElMessage({
      type: 'success',
      message: '删除成功!',
    })
    getTableData();
  }
}

const addForm_enter = async(formEl) => {
  if (!formEl) return
  await formEl.validate(async(valid, fields) => {
    if(valid) {
      submitLoading.value = true;
      const api = selectClassifyId.value?classifyEdit:classifyAdd;
      const {code} = await api(formData.value);
      submitLoading.value = false;
      visible.value = false;
      if (code === '') {
        ElMessage({
          message: `${selectClassifyId.value?'修改':'新增'}成功`,
          type: 'success',
        })
      }
      selectClassifyId.value = '';
      getTableData();
    } else {
      return flase;
    }
  })
}

const onClosed = () => {
  formRef.value.resetFields();
}
</script>

<style scoped lang="scss">
.main-con {
  padding: 20px;
  margin-top: 20px;
  background: #FFFFFF;
  overflow: hidden;
}
</style>