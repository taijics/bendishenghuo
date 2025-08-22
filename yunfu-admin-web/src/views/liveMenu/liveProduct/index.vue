<template>
  <div class="liveRoomPage">
    <nav class="formSearch">
      <el-form
        :inline="true"
        :model="listQuery"
      >
        <el-form-item
          label="状态："
        >
          <el-radio-group
            v-model="listQuery.state"
            @change="searchTypeChange"
          >
            <el-radio-button
              v-for="item in searchType"
              :key="item.value"
              :label="item.value"
            >
              {{ item.label }}
            </el-radio-button>
          </el-radio-group>
        </el-form-item>
        <br />
        <el-form-item
          label="关键字："
        >
          <el-input
            v-model="listQuery.search"
            maxlength="20"
            placeholder="请输入商品名称/ID"
            class="inputKeyWord"
            style="width: 400px"
          >
            <template #append>
              <el-button
                :icon="ElIconSearch"
                @click="getList"
              />
            </template>
          </el-input>
        </el-form-item>
      </el-form>
    </nav>
    <section>
      <el-table
        v-loading="tableLoading"
        :data="roomList"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          prop="id"
          label="直播商品ID"
        />
        <el-table-column
          prop="productName"
          label="商品名称"
        />
        <el-table-column
          prop="productId"
          label="关联商品ID"
        />
        <el-table-column
          width="100"
          prop="productImage"
          label="商品图片"
        >
          <template #default="scope">
            <img style="width: 40px; height: 40px" :src="scope.row.productImage" alt="" />
          </template>
        </el-table-column>
        <el-table-column
          prop="startTime"
          label="商品小程序路径"
        >
          <template #default="scope">
            /pages_category_page1/goodsModule/goodsDetails?productId=
            {{ scope.row.productId }}
          </template>
        </el-table-column>
        <el-table-column
          label="价格类型"
          width="100"
        >
          <template #default="scope">
            <el-tag v-if="scope.row.priceType == 1"> 一口价</el-tag>
            <el-tag
              v-if="scope.row.priceType == 2"
              type="success"
            >
              价格区间
            </el-tag>
            <el-tag
              v-if="scope.row.priceType == 3"
              type="danger"
            >
              折扣价
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
          label="审核状态"
          width="100"
        >
          <template #default="scope">
            <el-tag
              v-if="scope.row.state == 0"
              type="warning"
            > 待审核
            </el-tag>
            <el-tag
              v-if="scope.row.state == 1"
              type="success"
            > 已通过
            </el-tag>
            <el-tag
              v-if="scope.row.state == 2"
              type="danger"
            > 未通过
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
          label="微信审核状态"
          width="120"
        >
          <template #default="scope">
            <el-tag
              v-if="scope.row.wxAuditStatus == 0"
              type="info"
            >
              未审核
            </el-tag>
            <el-tag
              v-if="scope.row.wxAuditStatus == 1"
              type="success"
            >
              审核中
            </el-tag>
            <el-tag
              v-if="scope.row.wxAuditStatus == 2"
              type="warning"
            >
              审核通过
            </el-tag>
            <el-tag
              v-if="scope.row.wxAuditStatus == 3"
              type="danger"
            >
              审核失败
            </el-tag>
            <el-tag v-if="scope.row.wxAuditStatus == -1"> 未提交</el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="添加时间"
        />
        <el-table-column
          label="操作"
        >
          <template #default="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.state == 0"
                type="primary"
                link
                @click="audit(scope.row)"
              >审核
              </el-button>
              <el-button
                type="primary"
                link
                @click="seeMore(scope.row)"
              >详情
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          v-model:current-page="listQuery.page"
          :page-size="listQuery.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </section>

    <el-dialog
      v-model="DetailsShow"
      :title="'直播间商品信息'"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form
            :model="ProForm"
            label-width="180px"
          >
            <el-form-item label="商品名称:">
              {{ ProForm.productName }}
            </el-form-item>
            <el-form-item label="商品库存:">
              {{ ProForm.stockNumber }}
            </el-form-item>
            <el-form-item label="商品图片:">
              <img style="width: 140px; height: 140px" :src="ProForm.productImage" alt="" srcset="" />
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <el-form
            :model="ProForm"
            label-width="180px"
          >
            <el-form-item label="商品价格:">
              <span v-if="ProForm.priceType == 1">
                一口价: {{ ProForm.fixedPrice }}
              </span>
              <span v-if="ProForm.priceType == 2">
                最低价： {{ ProForm.minPrice }} - 最高价：{{ ProForm.maxPrice }}
              </span>
              <span v-if="ProForm.priceType == 3">
                现价: {{ ProForm.marketPrice }}
              </span>
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div
        v-if="ProForm.remark"
        style="text-align: center; margin-top: 20px"
      >
        <span style="color: red">备注：</span>
        {{ ProForm.remark }}
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="DetailsShow = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 审核 -->
    <el-dialog
      v-model="auditShow"
      :title="'审核'"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <el-form
        :model="auditForm"
        label-width="100px"
      >
        <el-form-item label="审核状态">
          <el-radio-group v-model="auditFormState">
            <el-radio :label="1">通过</el-radio>
            <el-radio :label="2">未通过</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item
          v-if="auditFormState == 2"
          label="理由"
        >
          <el-input
            v-model="auditForm.remark"
            maxlength="200"
            placeholder="请输入内容"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="auditShow = false">取 消</el-button>
          <el-button @click="submint">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { Search as ElIconSearch } from '@element-plus/icons-vue'
import { liveProAudit, liveProGetAll, } from '@/api/live'
import { onMounted, ref } from 'vue';

const searchType = [
  {
    label: '全部',
    value: 'null',
  },
  {
    label: '待审核',
    value: 0,
  },
  {
    label: '审核已通过',
    value: 1,
  },
  {
    label: '审核未通过',
    value: 2,
  },
]
const tableLoading = ref(false)
const listQuery = ref({
  state: 'null',
  search: '',
  page: 1,
  pageSize: 10,
  shopId: null,
})

const proListQuery = ref({
  liveId: null,
  page: 1,
  pageSize: 10,
  shopId: null,
})

const roomList = ref([])
const roomProList = ref([])

const total = ref(0)
const proTotal = ref(0)
const DetailsShow = ref(false)
const auditShow = ref(false)
const activeName = ref('first')
const disabled = ref(false)
const ProForm = ref({})
const liveRules = ref([])
const rules = ref([])
const auditForm = ref({})
const auditFormState = ref(1)

onMounted(() => {
  getList()
})

// 获取商品列表
function getList () {
  tableLoading.value = true
  liveProGetAll(listQuery.value).then(res => {
    total.value = res.data.total
    roomList.value = res.data.list
  }).finally(() => {
    tableLoading.value = false
  })
}
function audit (row) {
  auditForm.value = Object.assign({}, row)
  auditShow.value = true
}
async function submint () {
  auditForm.value.state = auditFormState.value
  const res = await liveProAudit(auditForm.value)
  ElMessage.success('状态审核成功')
  auditShow.value = false
  getList()
}
function seeMore (row) {
  ProForm.value = row
  DetailsShow.value = true
}
// 选择查询状态
function searchTypeChange (e) {
  listQuery.value.state = e
  getList()
}
// 分页
function handleCurrentChange (e) {
  listQuery.value.page = e
  getList()
}
function handleSizeChange (e) {
  listQuery.value.pageSize = e
  getList()
}
function handleCurrentChange1 (e) {
  proListQuery.value.page = e
  getList()
}
function handleSizeChange1 (e) {
  proListQuery.value.pageSize = e
  getList()
}
</script>

<style lang="scss" scpoed>
.liveRoomPage {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  nav {
    .search {
      line-height: 40px;
      margin: 10px 0;
      display: flex;

      .title {
        min-width: 120px;
        text-align: right;
      }

      .inputKeyWord {
        max-width: 400px;
        min-width: 200px;
      }
    }
  }

  section {
    .fenye {
      margin-top: 20px;
    }
  }
}
</style>
