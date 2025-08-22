<template>
  <div class="liveRoomPage">
    <nav class="formSearch">
      <el-form :inline="true" :model="listQuery">
        <el-form-item label="状态：">
          <el-radio-group v-model="listQuery.state" @change="searchTypeChange">
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
        <el-form-item label="关键字：">
          <el-input
            v-model="listQuery.search"
            maxlength="20"
            placeholder="请输入直播间名称/ID/主播昵称/微信号"
            class="inputKeyWord"
            style="width: 400px"
          >
            <template #append>
              <el-button :icon="ElIconSearch" @click="getList" />
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
        <el-table-column prop="id" label="直播间id" />
        <el-table-column prop="title" label="直播间标题" />
        <el-table-column prop="anchorNickname" label="主播昵称" />
        <el-table-column prop="anchorWechat" label="主播微信号" />
        <el-table-column prop="startTime" label="直播开始时间" />
        <el-table-column prop="endTime" label="预计结束时间" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="审核状态" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.state == 0" type="warning"> 待审核 </el-tag>
            <el-tag v-if="scope.row.state == 1" type="success"> 已通过 </el-tag>
            <el-tag v-if="scope.row.state == 2" type="danger"> 未通过 </el-tag>
          </template>
        </el-table-column>
        <!-- <el-table-column prop="createTime" label="直播回放">
            <template #default="scope">
              <el-switch
                v-model="scope.row.reply"
                active-text="开"
                active-color="#13ce66"
                inactive-text="关"
                inactive-color="#ff4949"
              />
            </template>
          </el-table-column> -->
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.state == 0"
                type="primary"
                link
                @click="audit(scope.row)"
              >审核</el-button>
              <el-button
                type="primary"
                link
                @click="seeMore(scope.row)"
              >详情</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="listQuery.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="listQuery.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </section>

    <el-dialog
      v-model="DetailsLiveShow"
      :title="'直播间信息'"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form :model="liveForm" label-width="180px">
            <el-form-item label="直播间标题:">
              {{ liveForm.title }}
            </el-form-item>
            <el-form-item label="直播间id:">
              {{ liveForm.id }}
            </el-form-item>
            <el-form-item label="直播间开始时间:">
              {{ liveForm.startTime }}
            </el-form-item>
            <el-form-item label="背景图:">
              <img :src="liveForm.coverImg" alt="" srcset="" />
            </el-form-item>
            <el-form-item label="直播间类型:">
              {{ liveForm.liveType == 1 ? '推流' : '手机' }}
            </el-form-item>
            <el-form-item label="是否开启点赞:">
              {{ liveForm.closeLike == 0 ? '是' : '否' }}
            </el-form-item>
            <el-form-item label="是否开启评论:">
              {{ liveForm.closeComment == 0 ? '是' : '否' }}
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <el-form :model="liveForm" label-width="180px">
            <el-form-item label="主播微信号:">
              {{ liveForm.anchorWechat }}
            </el-form-item>
            <el-form-item label="主播昵称:">
              {{ liveForm.anchorNickname }}
            </el-form-item>
            <el-form-item label="直播间结束时间:">
              {{ liveForm.endTime }}
            </el-form-item>
            <el-form-item label="分享图:">
              <img :src="liveForm.shareImg" alt="" srcset="" />
            </el-form-item>
            <el-form-item label="是否开启回放:">
              {{ liveForm.closePlayback == 0 ? '是' : '否' }}
            </el-form-item>
            <el-form-item label="是否开启预约:">
              {{ liveForm.closeAppointment == 0 ? '是' : '否' }}
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div>
        <el-table
          :data="roomProList"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column prop="productId" label="商品ID" />
          <el-table-column prop="productImage" label="商品图片">
            <template #default="scope">
              <img style="width: 40px; height: 40px" :src="scope.row.productImage" alt="" />
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="商品名称" />
          <el-table-column prop="stockNumber" label="库存" />
          <el-table-column prop="fixedPrice" label="价格">
            <template #default="scope">
              <span v-if="scope.row.priceType == 1">
                一口价: {{ scope.row.fixedPrice }}
              </span>
              <span v-if="scope.row.priceType == 2">
                最低价：{{ scope.row.minPrice }} <br />
                最高价：{{ scope.row.maxPrice }}
              </span>
              <span v-if="scope.row.priceType == 3">
                现价: {{ scope.row.marketPrice }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="saleNumber" label="销售数量" />
          <el-table-column prop="saleAmount" label="销售金额" />
        </el-table>
        <el-pagination
          style="margin-top: 20px"
          :current-page="proListQuery.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="proListQuery.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="proTotal"
          @size-change="handleSizeChange1"
          @current-change="handleCurrentChange1"
        />
      </div>
      <div v-if="liveForm.remark" style="text-align: center; margin-top: 20px">
        <span style="color: red">备注：</span>
        {{ liveForm.remark }}
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="closeFn">关 闭</el-button>
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
      <el-form :model="auditForm" label-width="100px">
        <el-form-item label="审核状态">
          <el-radio-group v-model="auditFormState">
            <el-radio :label="1">通过</el-radio>
            <el-radio :label="2">未通过</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="auditFormState == 2" label="理由">
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
          <el-button type="primary" @click="submint">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { Search as ElIconSearch } from '@element-plus/icons-vue'
import {
  liveGetList,
  // liveGetById,
  livePutAudit,
  liveGetProduct,
} from '@/api/live'
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
const DetailsLiveShow = ref(false)
const activeName = ref('first')
const disabled = ref(false)
const liveForm = ref({})
const liveRules = ref({})
const rules = ref([])
const auditShow = ref(false)
const auditForm = ref({})
const auditFormState = ref(1)

onMounted(() => {
  getList()
})

function getList () {
  tableLoading.value = true
  liveGetList(listQuery.value).then((res) => {
    total.value = res.data.total
    roomList.value = res.data.list
  }).finally(() => {
    tableLoading.value = false
  })
}

// 获取直播间相关产品信息
function getProList () {
  proListQuery.value.shopId = liveForm.value.shopId
  proListQuery.value.liveId = liveForm.value.id
  liveGetProduct(proListQuery.value).then((res) => {
    roomProList.value = res.data.list
    proTotal.value = res.data.total
  })
}

function audit (row) {
  auditForm.value = Object.assign({}, row)
  auditShow.value = true
}

function submint () {
  auditForm.value.state = auditFormState.value
  livePutAudit(auditForm.value).then((res) => {
    ElMessage.success('状态审核成功')
    auditShow.value = false
    getList()
  })
}

function seeMore (row) {
  liveForm.value = row
  DetailsLiveShow.value = true
  getProList()
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

function closeFn () {
  DetailsLiveShow.value = false
}
</script>

<style lang="scss" scpoed>
img {
  width: 100px;
  height: 100px;
}
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
