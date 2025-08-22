<template>
  <div class="link-config">
    <div v-if="props.linkType === 1">
      <span class="name">{{ formData.name }}</span>
      <el-button
        v-if="formData.name"
        type="primary"
        link
        @click="editProduct"
      >修改
      </el-button>
      <el-button
        v-else
        size="small"
        type="primary"
        @click="addProduct"
      >
        添加商品
      </el-button>
      <ProductTable
        ref="productTable"
        :pro-id="formData.id"
        @doSubmit="proSubmit"
      />
    </div>
    <div v-if="props.linkType === 2">
      <el-cascader
        ref="cascader"
        v-model="formData.id"
        :options="categoryList"
        :props="{
          checkStrictly: true,
          label: 'categoryName',
          value: 'id',
          children: 'childs',
        }"
        clearable
        @change="categoryChange"
      />
    </div>
    <div v-if="props.linkType === 3">
      <ul
        v-if="formData && formData.items && formData.items.length > 0"
        class="coupon-list"
      >
        <li
          v-for="(item, index) in formData.items"
          :key="index"
        >
          <span class="name">{{ item.activityName }}</span>
          <el-button
            v-if="item.activityId"
            type="primary"
            link
            @click="editCoupon"
          >修改
          </el-button>
        </li>
      </ul>
      <el-button
        v-else
        size="small"
        type="primary"
        @click="addCoupon"
      >
        添加平台券
      </el-button>
      <CouponTable
        ref="couponTable"
        :is-multiple="true"
        @doSubmit="couponSubmit"
      />
    </div>
    <div v-if="props.linkType === 4">
      <el-form
        class="link-form"
        :model="formData"
        label-width="100px"
      >
        <el-form-item label="小程序app id">
          <el-input
            v-model="formData.appId"
            maxlength="20"
            class="input-sub"
          />
        </el-form-item>
        <el-form-item label="页面路径">
          <el-input
            v-model="formData.link"
            maxlength="40"
            class="input-sub"
          />
        </el-form-item>
      </el-form>
    </div>
    <div v-if="props.linkType === 5">
      <el-form
        :model="formData"
        label-width="100px"
      >
        <el-form-item label="页面路径">
          <el-input
            v-model="formData.link"
            maxlength="40"
            class="input-sub"
          />
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, onBeforeMount, watchEffect } from 'vue'
import ProductTable from '../basics/productTable.vue'
import CouponTable from '../basics/couponTable.vue'
import { getClassify } from '@/api/public'
import { checkEmptyChild } from '@@/config/common'

const props = defineProps({
  data: {
    type: Object,
    default: () => {
    },
  },
  linkType: {
    type: Number,
    default: 0,
  },
})
const formData = ref({})
const cascader = ref(null)
const productTable = ref(null)
const couponTable = ref(null)
const categoryList = ref([])
const emits = defineEmits(['update:data'])

watchEffect(() => {
  formData.value = props.data
})

onBeforeMount(() => {
  getCategoryList()
})

const addProduct = () => {
  productTable.value.open()
}
const editProduct = () => {
  productTable.value.open()
}
const proSubmit = (val) => {
  formData.value.id = val.productId
  formData.value.shopId = val.shopId
  formData.value.skuId = val.skuId
  formData.value.name = val.productName
  emits('update:data', formData.value)
}
const addCoupon = () => {
  couponTable.value.open()
}
const editCoupon = () => {
  couponTable.value.open()
}
const couponSubmit = (items) => {
  formData.value.items = items
  emits('update:data', formData.value)
}
// 获取前端分类
const getCategoryList = () => {
  getClassify()
    .then((res) => {
      categoryList.value = res.data
      checkEmptyChild(categoryList.value)
    })
    .catch((res) => {
      return ElMessage({
        message: res.msg,
        type: 'error',
      })
    })
}
// 类别改变
const categoryChange = () => {
  const nodesObj = cascader.value.getCheckedNodes()
  if (nodesObj.length > 0) {
    const pathLabels = nodesObj[0].pathLabels.join('/')
    formData.value.name = pathLabels
    formData.value.depth = nodesObj[0].level
  }
}
</script>

<style
    lang="scss"
    scoped
>
.link-config {
  .radio {
    padding: 5px 0;
  }

  .coupon-list {
    margin: 0;
    padding: 0;

    li {
      list-style: none;
    }

    .el-button {
      margin-left: 10px;
      font-size: 14px;
    }
  }

  .input-sub {
    width: 300px;

    :deep(.el-input__inner) {
      height: 32px;
      line-height: 32px;
    }
  }

  .link-form {
    .el-form-item {
      margin-top: 10px;

      &:first-child {
        margin-top: 0px;
      }
    }
  }

  .el-button--text {
    font-size: 14px;
    margin-left: 10px;
  }
}
</style>
