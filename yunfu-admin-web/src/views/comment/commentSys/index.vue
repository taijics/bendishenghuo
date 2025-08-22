<template>
  <div class="comment_manage_page">
    <div class="content">
      <el-tabs v-model="formParams.ifSensitive" @tab-click="selectItem">
        <el-tab-pane
          v-for="(item, index) in tabList"
          :key="index"
          :label="item.name"
          :name="item.id.toString()"
        />
      </el-tabs>
      <el-form :inline="true" :model="formParams">
        <el-form-item label="商家名称">
          <el-input v-model="formParams.shopName" placeholder="请输入商家名称" maxlength="20" />
        </el-form-item>

        <el-form-item label="商家编码">
          <el-input v-model="formParams.shopCode" placeholder="请输入商家编码" maxlength="20" />
        </el-form-item>

        <el-form-item label="商品ID">
          <el-input v-model="formParams.productId" placeholder="请输入商品ID" maxlength="20" />
        </el-form-item>

        <el-form-item label="关键词">
          <el-input v-model="formParams.keyword" placeholder="请输入关键词" maxlength="20" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="search">查询</el-button>
          <el-button plain @click="clear">重置</el-button>
        </el-form-item>
      </el-form>
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        style="width: 100%"
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        class="dataTable"
      >
        <el-table-column prop="shopName" label="商家名称" />
        <el-table-column prop="shopCode" label="商家编码" />
        <el-table-column prop="productId" label="商品ID" />
        <el-table-column prop="name" label="评论人" />
        <el-table-column prop="createTime" label="评论日期" />
        <el-table-column label="操作">
          <template #default="scope">
            <div v-if="Number(formParams.ifSensitive)">
              <el-button
                type="primary"
                link
                @click="details(scope.row)"
              >查看</el-button>
            </div>
            <div v-else>
              <el-button
                type="primary"
                link
                @click="details(scope.row)"
              >查看</el-button>
              <el-button type="primary" link @click="handle(scope.row)">{{
                scope.row.state ? '显示' : '隐藏'
              }}</el-button>
              <el-popconfirm title="确认删除？" @confirm="deletes(scope.row.commentId)">
                <template #reference>
                  <el-button type="danger" link>删除</el-button>
                </template>
              </el-popconfirm>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
            :current-page="formParams.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="formParams.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            background
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <!-- ******************************************************弹框开始***************************************************************** -->
    <!-- 查看评论弹框 -->
    <el-dialog
      v-model="dialogVisible"
      title="评论详情"
      :close-on-click-modal="false"
      :before-close="handleClose"
      width="60%"
      center
    >
      <div class="pinStyle">
        <div class="comment">
          <div class="com_left">评论：</div>
          <div class="com_right">{{ commentDetails.comment }}</div>
        </div>
        <div v-if="commentDetails.images.length != 0" class="comment_imgList">
          <div class="img_left">图片：</div>
          <div class="imgList">
            <el-image
              v-for="(item, index) in commentDetails.images"
              :key="index"
              :src="item"
              :preview-src-list="commentDetails.images"
            />
          </div>
        </div>
        <div class="line"></div>
        <div v-if="commentDetails.addComment != ''" class="addComment">
          {{ commentDetails.time }}天后追评
        </div>
        <div class="comment">
          <div v-if="commentDetails.addComment != ''" class="com_left">
            追评：
          </div>
          <div class="com_right">{{ commentDetails.addComment }}</div>
        </div>
        <div
          v-if="commentDetails.addImages.length != 0"
          class="comment_imgList"
        >
          <div class="img_left">图片</div>
          <div class="imgList">
            <el-image
              v-for="(item, index) in commentDetails.addImages"
              :key="index"
              :src="item"
              :preview-src-list="commentDetails.addImages"
            />
          </div>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button
            v-if="Number(formParams.ifSensitive)"
            @click="toShow"
          >允许展示</el-button>
          <el-button v-else @click="noneShow(state)">{{
            state ? '显示' : '隐藏'
          }}</el-button>
          <el-button type="primary" @click="del">删除</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import {
  commentSysGetall,
  commentSysGetById,
  commentSysUpdate,
  commentSysDelete,
  commentAllow,
} from '@/api/comment'
import { onMounted, ref, shallowRef } from 'vue';

const formParams = ref({
  ifSensitive: '0', // 是否敏感词审核  1-是 0-否
  shopName: '', // 商家名称
  shopCode: '', // 商家编码
  productId: '', // 商品id
  keyword: '', // 关键词
  page: 1, // 当前页
  pageSize: 10 // 每页记录数
})
let tableData = ref([])
let tableLoading = shallowRef(false)
const tabList = ref([
  { name: '全部评论', id: 0 },
  { name: '敏感评论', id: 1 },
])
let total = shallowRef(1)
let dialogVisible = shallowRef(false)
let commentDetails = ref({
  images: [],
  addImages: []
})
let commentId = ref('')
let state = ref(0)

onMounted(() => {
  getList(formParams.value)
})

function handleSizeChange (val) {
  formParams.value.pageSize = val
  getList(formParams.value)
}

function handleCurrentChange (val) {
  formParams.value.page = val
  getList(formParams.value)
}

function selectItem (tab, event) {
  formParams.value.ifSensitive = tab.name
  getList(formParams.value)
}

// 查询
function search () {
  total.value = 1
  formParams.value.page = 1
  getList(formParams.value)
}

function clear () {
  formParams.value = {
    ifSensitive: '0', // 是否敏感词审核  1-是 0-否
    shopName: '', // 商家名称
    shopCode: '', // 商家编码
    productId: '', // 商品id
    keyword: '', // 关键词
    page: 1, // 当前页
    pageSize: 10 // 每页记录数
  }
  getList(formParams.value)
}

function handle (row) {
  commentSysUpdate({
    commentId: row.commentId,
    state: row.state === 1 ? 0 : 1,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success(row.state === 1 ? '显示成功' : '隐藏成功')
      dialogVisible.value = false
      getList(formParams.value)
    }
  }).catch(err => {
    console.log(err)
  })
}

function toShow () {
  commentAllow({
    commentId: commentId.value,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success('成功')
      dialogVisible.value = false
    }
  })
}

function noneShow (type) {
  commentSysUpdate({
    commentId: commentId.value,
    state: type === 0 ? 1 : 0,
  }).then(res => {
    if (res.code === '') {
      if (type === 0) {
        ElMessage.success('隐藏成功')
      } else {
        ElMessage.success('显示成功')
      }
      dialogVisible.value = false
      getList(formParams.value)
    }
  })
}

function del () {
  commentSysDelete({
    commentId: commentId.value,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success('删除成功')
      dialogVisible.value = false
      getList(formParams.value)
    }
  })
}

function deletes (id) {
  commentSysDelete({
    commentId: id,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success('删除成功')
      getList(formParams.value)
    }
  })
}

function details (row) {
  state.value = row.state
  dialogVisible.value = true
  commentSysGetById({ commentId: row.commentId }).then(res => {
    commentId.value = row.commentId
    commentDetails.value = res.data
  })
}

function handleClose () {
  dialogVisible.value = false
}

function getList (formParams) {
  tableLoading.value = true
  commentSysGetall(formParams).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}

</script>

<style lang="scss" scoped>
.comment_manage_page {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
.pinStyle {
  .comment {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    .com_left {
      font-size: 20px;
      color: #333333;
      margin-right: 20px;
    }
    .com_right {
      font-size: 18px;
      color: #333333;
    }
  }
  .comment_imgList {
    display: flex;
    margin-bottom: 20px;
    align-items: center;
    .img_left {
      font-size: 20px;
      color: #333333;
      margin-right: 20px;
      width: 60px;
    }
    .imgList {
      display: flex;
      justify-content: flex-start;
      align-items: center;
      flex-wrap: wrap;
      .el-image {
        width: 200px;
        height: 134px;
        border-radius: 4px;
        margin-right: 20px;
        margin-bottom: 20px;
      }
    }
  }
  .line {
    width: 890px;
    height: 1px;
    background: #e0e5eb;
    margin: 0 auto;
    margin-bottom: 33px;
  }
  .addComment {
    font-size: 20px;
    color: #ff7911;
    margin-bottom: 20px;
  }
  .fenye {
    margin-top: 20px;
  }
}
</style>
