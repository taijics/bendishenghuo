<template>
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
        <p v-for="(item, index) in tagList" :key="index">{{ item }}</p>
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
        <el-table-column prop="products" label="商品数量" />
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
        <el-table-column prop="receiveAdress" label="地址" />
      </el-table>
      <!-- <el-pagination
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        /> -->
    </div>
    <!-- *************对话框开始************* -->
    <!-- 打标签 -->
    <el-dialog
      v-model="addFormDialog"
      title="选择标签"
      width="30%"
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
  </div>
</template>

<script setup>
import { ref, onBeforeMount, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  customerMageGetById,
  getLabels,
  customerSaveUserLabel,
} from '@/api/customerMage'

const props = defineProps({
  ids: {
    type: Object,
    default: () => ({
      buyerUserId: null,
      orderFormid: null,
    }),
  },
  buyerUserId: {
    type: Number,
    default: null,
  },
})

const router = useRouter()
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

watch(() => props.ids, (newVal) => {
  user.value = newVal
}, { immediate: true, deep: true })

onBeforeMount(() => {
  // this.user = this.$route.params
  // console.log(this.user)
  getUser(props.ids)
})

// 客户详情
const getUser = async (obj) => {
  const res = await customerMageGetById({
    buyerUserId: obj.buyerUserId,
    orderFormid: obj.orderFormid,
  })
  userObj.value = res.data
  tagList.value = res.data.labels
  formateUserInfo(userObj.value)
}
// 获取客户信息
const formateUserInfo = (ob) => {
  infoList.value.map((item) => {
    item.value = ob[item.fields] || ''
    if (item.fields === 'sex') {
      item.value = item.value === '1' ? '男' : '女'
    }
  })
}
// 贴标签
const addTag = () => {
  addFormDialog.value = true
  getSelect({ labelName: tipsForm.value.labelName })
}
// 查询订单
const searchOrders = () => {
  user.value.orderFormid = userForm.value.orderFormid
  getUser(user.value)
}
// 查询标签
const searchTips = () => {
  getSelect({ labelName: tipsForm.value.labelName })
}
// 跳转标签页面
const runTips = () => {
  router.push({
    path: '/customer/tips',
  })
}
// 打标签
const saveTips = async () => {
  const res = await customerSaveUserLabel({
    buyerUserId: user.value.buyerUserId,
    buyerLabelIds: checkList.value
  })
  if (res.code === '') {
    ElMessage({
      message: '成功',
      type: 'success',
    })
    getUser(user.value)
    checkList.value = []
    addFormDialog.value = false
  }
}
const changeTab = (item) => {
  componentName.value = item.componentName
}
// 初始化查询所有标签
const getSelect = async (name) => {
  const res = await getLabels(name)
  tipsList.value = res.data
}
</script>

<style lang="scss" scoped>
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
      margin-right: 20px;
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
