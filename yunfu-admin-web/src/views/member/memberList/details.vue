<template>
  <el-dialog
    v-model="visible"
    title="详情"
    width="80%"
    :close-on-click-modal="false"
    @close="closeModalDetail"
  >
    <div class="custom_info_page">
      <h2>客户信息</h2>
      <div class="custom_info">
        <div class="info_item">
          <img :src="userObj.headImage" alt />
        </div>
        <div class="info_item">
          <ul>
            <li v-for="(item, index) in infoList" :key="index">
              <p>
                <span>{{ item.name }} :</span>
                <span>{{ item.value }}</span>
              </p>
            </li>
          </ul>
        </div>
      </div>
      <div class="custom_tag">
        <h2>客户标签</h2>
        <div class="Tag">
          <p v-for="(item, index) in tagList" :key="index">
            {{ item.labelName }}
          </p>
          <p @click="addTag">贴标签</p>
        </div>
      </div>
      <div class="custom_data">
        <h2>消费数据</h2>
        <div class="data_list">
          <p>
            <span>
              下 单 数:
              <strong>{{ userObj.orders }}</strong>
            </span>
            支付成功数:
            <strong>{{ userObj.pays }}</strong>
          </p>
          <p>
            <span>
              售后次数:
              <strong>{{ userObj.afters }}</strong>
            </span>
            售后单数:
            <strong>{{ userObj.afterOrders }}</strong>
          </p>
        </div>
        <div class="tab_list">
          <p
            v-for="(item, index) in tabList"
            :key="index"
            :class="[{ active: componentName === item.componentName }]"
            @click="changeTab(item)"
          >
            {{ item.tabName }}
          </p>
        </div>
      </div>
      <div v-if="componentName === 'order'">
        <el-form :inline="true" :model="userForm">
          <el-form-item label="订单编号">
            <el-input
              v-model="userForm.orderFormid"
              maxlength="20"
              placeholder="请输入订单编号"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="searchOrders">查询</el-button>
          </el-form-item>
        </el-form>
        <el-table
          :data="userObj.orderList"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          style="width: 100%"
        >
          <el-table-column prop="orderFormid" label="订单编号" />
          <el-table-column prop="shopName" label="店铺名称" />
          <el-table-column prop="products" label="商品数量">
            <template #default="scope">
              <span>{{ scope.row.products }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="订单金额(元)" />
          <el-table-column label="状态">
            <template #default="scope">
              <span v-if="scope.row.state === 1">待付款</span>
              <span v-if="scope.row.state === 2">待发货</span>
              <span v-if="scope.row.state === 3">待收货</span>
              <span v-if="scope.row.state === 4">已完成</span>
              <span v-if="scope.row.state === 5">已关闭</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div v-if="componentName === 'comment'">
        <el-table
          :data="userObj.comments"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          style="width: 100%"
        >
          <el-table-column prop="shopName" label="店铺名称" />
          <el-table-column prop="productName" label="商品名称" />
          <el-table-column prop="comments" label="评论">
            <template #default="scope">
              <el-button type="primary" link @click="seeComment(scope.row.commentId)">查看</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div v-if="componentName === 'addressInfo'">
        <el-table
          :data="userObj.receives"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          style="width: 100%"
        >
          <el-table-column prop="receiveName" label="姓名" />
          <el-table-column prop="receivePhone" label="电话" />
          <el-table-column prop="receiveAdress" label="地址">
            <template #default="scope">
              <span>{{ scope.row.receiveAdress }}{{ scope.row.address }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <!-- *************对话框开始************* -->
      <!-- 打标签 -->
      <el-dialog
        v-model="addFormDialog"
        title="选择标签"
        width="30%"
        append-to-body
        center
        :close-on-click-modal="false"
      >
        <div>
          <!-- 表单搜索 -->
          <el-form :inline="true" :model="tipsForm">
            <el-form-item label="标签名称">
              <el-input
                v-model="tipsForm.labelName"
                maxlength="20"
                placeholder="请输入标签名称"
              />
            </el-form-item>
            <el-form-item>
              <el-button @click="searchTips">查询</el-button>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" link @click="runTips">管理标签</el-button>
            </el-form-item>
          </el-form>
          <!-- 多选 -->
          <el-checkbox-group v-model="checkList">
            <el-checkbox
              v-for="(item, index) in tipsList"
              :key="index"
              class="checkBoxStyle"
              :label="item.buyerLabelId"
            >{{ item.labelName }}</el-checkbox>
          </el-checkbox-group>
        </div>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="addFormDialog = false">取 消</el-button>
            <el-button type="primary" @click="saveTips">确定</el-button>
          </span>
        </template>
      </el-dialog>
      <!-- 查看评论弹框 -->
      <el-dialog
        v-model="comDialogVisible"
        title="评论详情"
        :close-on-click-modal="false"
        :before-close="handleClose"
        width="60%"
        center
        :append-to-body="true"
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
            <el-button v-if="comState" @click="toShow">允许展示</el-button>
            <el-button v-else @click="noneShow">隐藏</el-button>
            <el-button type="primary" @click="delCom">删除</el-button>
          </span>
        </template>
      </el-dialog>
    </div>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="doCancel">取消</el-button>
        <el-button type="primary" @click="doSubmit">确认</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  customerMageGetById,
  getLabels,
  customerSaveUserLabel,
} from '@/api/customerMage'
import {
  commentSysGetById,
  commentSysUpdate,
  commentSysDelete,
  commentAllow,
} from '@/api/comment'

const router = useRouter()
const visible = ref(false)
const infoList = ref([
  { name: '用户昵称', value: '', fields: 'name' },
  { name: '手 机 号', value: '', fields: 'phone' },
  { name: '性  别', value: '', fields: 'sex' },
  { name: '注册时间', value: '', fields: 'createTime' },
  { name: '生   日', value: '', fields: 'birthday' }
])
const tagList = ref([])
const tabList = ref([
  { tabName: 'TA的订单', componentName: 'order' },
  { tabName: 'TA的评论', componentName: 'comment' },
  { tabName: 'TA的收货地址', componentName: 'addressInfo' }
])
const componentName = ref('order')
const user = ref('')
const userObj = ref({})
const addFormDialog = ref(false)
const tipsForm = ref({
  labelName: ''
})
const userForm = ref({
  orderFormid: ''
})
const checkList = ref([])
const tipsList = ref([])
const comDialogVisible = ref(false)
const commentDetails = ref({ images: [], addImages: [] })
const commentId = ref('')
const comState = ref(1) // 是否隐藏 1-是 0-否
const emits = defineEmits(['reset'])

// 允许展示
const toShow = async () => {
  const res = await commentAllow({
    commentId: commentId.value,
    state: 1,
  })
  if (res.code === '') {
    ElMessage.success('成功')
    comDialogVisible.value = false
    comState.value = 0
    getUser()
  }
}
// 隐藏
const noneShow = async () => {
  const res = await commentSysUpdate({
    commentId: commentId.value,
    state: 0,
  })
  if (res.code === '') {
    comState.value = 1
    ElMessage.success('隐藏成功')
    comDialogVisible.value = false
    getUser()
  }
}
// 删除
const delCom = async () => {
  const res = await commentSysDelete({
    commentId: commentId.value,
  })
  if (res.code === '') {
    ElMessage.success('删除成功')
    comDialogVisible.value = false
    getUser()
  }
}
// 评论详情
const seeComment = async (id) => {
  comDialogVisible.value = true
  const res = await commentSysGetById({ commentId: id })
  commentId.value = id
  commentDetails.value = res.data
}
const handleClose = () => {
  comDialogVisible.value = false
}
const closeModalDetail = () => {
  comState.value = 1
  componentName.value = 'order'
}
// 贴标签
const addTag = () => {
  addFormDialog.value = true
  getSelect({ labelName: tipsForm.value.labelName })
}
// 查询订单
const searchOrders = () => {
  user.value.orderFormid = userForm.value.orderFormid
  getUser()
}
// 查询标签
const searchTips = () => {
  getSelect({ labelName: tipsForm.value.labelName })
}
// 跳转标签页面
const runTips = () => {
  addFormDialog.value = false
  router.push({
    path: '/member/tips',
  })
}
// 打标签
const saveTips = async () => {
  const res = await customerSaveUserLabel({
    buyerUserId: user.value.buyerUserId,
    buyerLabelIds: checkList.value,
  })
  if (res.code === '') {
    ElMessage.success('成功')
    checkList.value = []
    getUser()
    addFormDialog.value = false
  }
}
const changeTab = (item) => {
  componentName.value = item.componentName
}
// 客户详情
const getUser = async (obj) => {
  if (obj) {
    user.value = obj
  }
  const res = await customerMageGetById({
    buyerUserId: user.value.buyerUserId,
    orderFormid: user.value.orderFormid,
  })
  userObj.value = res.data
  tagList.value = []
  // checkList.value = []
  for (let i in res.data.labels) {
    tagList.value.push({
      buyerLabelId: res.data.labelIds[i],
      labelName: res.data.labels[i]
    })
    // checkList.value.push(res.data.labelIds[i])
  }
  visible.value = true
  getInfoList(userObj.value)
}
defineExpose({ getUser })

// 获取客户信息
const getInfoList = (ob) => {
  infoList.value.map((item) => {
    item.value = ob[item.fields] || ''
    if (item.fields === 'sex') {
      item.value = item.value === '1' ? '男' : '女'
    }
  })
}
// 初始化查询所有标签
const getSelect = async (name) => {
  const res = await getLabels(name)
  tipsList.value = res.data
}
const doCancel = () => {
  visible.value = false
}
const doSubmit = () => {
  visible.value = false
  emits('reset')
}
</script>

<style lang="scss" scoped>
// 评论详情
.comment_manage_page {
  padding: 20px;
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
    align-items: flex-start;

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
  // .line {
  //   width: 890px;
  //   height: 1px;
  //   background: #e0e5eb;
  //   margin: 0 auto;
  //   margin-bottom: 33px;
  // }
  // .addComment {
  //   font-size: 20px;
  //   color: #ff7911;
  //   margin-bottom: 20px;
  // }
}
//
h2 {
  font-size: 24px;
  font-weight: 500;
  position: relative;
  &::before {
    content: '';
    height: 24px;
    width: 4px;
    background-color: #3a68f2;
    position: absolute;
    left: -10px;
    top: 2px;
    display: block;
  }
}
.custom_info_page {
  margin-top: 20px;
  padding: 20px 100px;
  background-color: #fff;
  min-height: 500px;

  .custom_info {
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    .info_item {
      &:nth-child(1) {
        height: 180px;
        width: 100px;
        img {
          width: 100px;
          height: 100px;
          border-radius: 50px;
          text-align: center;
          margin-top: 40px;
        }
      }
      &:nth-child(2) {
        margin-left: 100px;
        ul {
          overflow: hidden;
          list-style: none;
          li {
            float: left;
            width: 50%;
            p {
              font-size: 16px;
              color: #333;
              line-height: 40px;
              span:nth-child(2) {
                color: #666;
              }
            }
          }
        }
      }
    }
  }

  .custom_tag {
    margin-bottom: 30px;
    .Tag {
      padding-top: 20px;
    }
    p {
      display: inline-block;
      background-color: #d8e1fc;
      font-size: 16px;
      color: #333;
      text-align: center;
      margin-right: 10px;
      border-radius: 4px;
      padding: 8px 15px;
      &:last-child {
        background-color: #fff;
        color: #3a68f2;
        &:hover {
          cursor: pointer;
        }
      }
    }
  }

  .custom_data {
    .data_list {
      padding: 20px 0 40px 0;
      p {
        font-size: 16px;
        line-height: 40px;
        font {
          color: #666;
        }
        span {
          display: inline-block;
          width: 200px;
        }
      }
    }
    .tab_list {
      overflow: hidden;
      margin-bottom: 20px;
      p {
        float: left;
        padding: 0 50px;
        font-size: 16px;
        border: 1px #e0e5eb solid;
        box-sizing: border-box;
        color: #999999;
        height: 48px;
        line-height: 48px;
        &:nth-child(-n + 2) {
          border-right: 0;
        }
        &:nth-child(1) {
          border-radius: 4px 0 0 4px;
        }
        &:nth-child(3) {
          border-radius: 0 4px 4px 0;
        }
        &:hover {
          cursor: pointer;
        }
      }
      .active {
        background-color: #3a68f2;
        color: #fff;
        border: 0;
      }
    }
  }
}
</style>
