<template>
  <div class="module-box link-select" :class="styleType && 'style' + styleType">
    <div class="link-select__warp">
      <div class="module-box__title">
        <label class="module-box__label">{{ title }}</label>
      </div>
      <el-select
        v-model="selectValue"
        class="link-select__select"
        placeholder="请选择跳转到的页面"
        @change="selectChanged"
      >
        <el-option
          v-for="item in options"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </el-select>
    </div>
    <div v-show="confirmBtnVisible" class="link-select__confirm">
      <div v-if="!selectName" class="btn" @click="openDialog">
        <span class="iconfont">&#xe685;</span> 添加{{ typeText }}
      </div>
      <div v-else class="info">
        <span class="text">{{ typeText }}</span>
        <span class="name">{{ selectName }}</span>
        <span class="iconfont" @click="openDialog">&#xe66c;</span>
        <span class="iconfont" @click="delSelect">&#xe651;</span>
      </div>
    </div>
    <el-dialog v-model="categoryVisible" width="600px" title="选择类别">
      <category-select ref="categorySelectRef" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="categoryVisible = false">取 消</el-button>
          <el-button type="primary" @click="categoryChanged">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <el-dialog v-model="productVisible" title="选择商品">
      <product-select ref="productSelectRef" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="productVisible = false">取 消</el-button>
          <el-button type="primary" @click="productChanged">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <el-dialog v-model="shopVisible" title="选择店辅">
      <shop-select ref="shopSelectRef" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="shopVisible = false">取 消</el-button>
          <el-button type="primary" @click="shopChanged">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <el-dialog v-model="customVisible" title="选择自定义页面">
      <custom-page-select ref="customPageSelectRef" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="customVisible = false">取 消</el-button>
          <el-button type="primary" @click="customChanged">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <el-dialog v-model="noticeVisible" title="选择公告">
      <notice-select ref="noticeSelectRef" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="noticeVisible = false">取 消</el-button>
          <el-button type="primary" @click="noticeChanged">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, toRefs, onMounted, watch } from 'vue';
import productSelect from './product-select.vue';
import shopSelect from './shop-select.vue';
import categorySelect from './category-select.vue';
import customPageSelect from './custom-page-select.vue';
import noticeSelect from './notice-select.vue';

const selectValue = ref('');
const confirmBtnVisible = ref(false);
const selectName = ref('');
const typeText = ref('');
const productVisible = ref(false);
const shopVisible = ref(false);
const categoryVisible = ref(false);
const customVisible = ref(false);
const noticeVisible = ref(false);
const categorySelectRef = ref();
const productSelectRef = ref();
const shopSelectRef = ref();
const customPageSelectRef = ref();
const noticeSelectRef = ref();

const props = defineProps({
  title: {
    type: String,
    default: '链接',
  },
  styleType: {
    type: String,
    default: '',
  },
  linkObj: {
    type: Object,
    default: () => ({
      selectValue: '',
      selectName: '',
      typeText: '',
      url: '',
    }),
  },
  options: {
    type: Array,
    default: () => [
      // {
      //   value: '/index',
      //   label: '首页'
      // },
      {
        value: '/category',
        label: '分类页面',
      },
      {
        value: '/shop',
        label: '店辅主页',
      },
      {
        value: '/detail',
        label: '商品详情',
      },
      {
        value: '/shopSearch',
        label: '店辅列表',
      },
      {
        value: '/notice',
        label: '公告',
      },
      // {
      //   value: '/custom',
      //   label: '自定义页面'
      // }
    ],
  },
});
const { title, styleType, linkObj, options } = toRefs(props);
const emits = defineEmits(['update:linkObj']);

onMounted(() => {
  selectValue.value = linkObj.value.selectValue;
  selectName.value = linkObj.value.selectName;
  typeText.value = linkObj.value.typeText;
  confirmBtnVisible.value = selectValue.value !== '/index' && selectValue.value;
});

// 链接选择
function selectChanged (value) {
  categoryVisible.value = false;
  shopVisible.value = false;
  productVisible.value = false;
  confirmBtnVisible.value = true;
  selectName.value = '';
  typeText.value = '';
  const linkObj = {
    selectValue: selectValue.value,
    selectName: '',
    typeText: '',
    url: '/',
  };
  switch (value) {
    case '/category':
      typeText.value = '类别';
      break;
    case '/shop':
      typeText.value = '店辅';
      break;
    case '/detail':
      typeText.value = '商品';
      break;
    case '/custom':
      typeText.value = '自定义';
      break;
    case '/notice':
      typeText.value = '公告';
      break;
    default:
      confirmBtnVisible.value = false;
      emits('update:linkObj', linkObj);
      break;
  }
}
// 打开添加弹窗
function openDialog () {
  switch (typeText.value) {
    case '类别':
      categoryVisible.value = true;
      break;
    case '店辅':
      shopVisible.value = true;
      break;
    case '商品':
      productVisible.value = true;
      break;
    case '自定义':
      customVisible.value = true;
      break;
    case '公告':
      noticeVisible.value = true;
      break;
  }
}
// 类别选择
function categoryChanged () {
  const nodesObj = categorySelectRef.value.cascader.getCheckedNodes();
  if (nodesObj && nodesObj.length > 0) {
    var data = nodesObj[0].data;
    selectName.value = nodesObj[0].label;
    categoryVisible.value = false;
    const linkObj = {
      selectValue: selectValue.value,
      selectName: selectName.value,
      typeText: typeText.value,
      data: data,
    };
    emits('update:linkObj', linkObj);
  } else {
    ElMessage.warning(`请选择类别`)
  }
}
// 商品选择
function productChanged () {
  var data = productSelectRef.value.tableRadio;
  productVisible.value = false;
  selectName.value = productSelectRef.value.tableRadio.productName;
  const linkObj = {
    selectValue: selectValue.value,
    selectName: selectName.value,
    typeText: typeText.value,
    data: data,
  };
  emits('update:linkObj', linkObj);
}
// 店辅选择
function shopChanged () {
  var data = shopSelectRef.value.tableRadio;
  shopVisible.value = false;
  selectName.value = shopSelectRef.value.tableRadio.shopName;
  const linkObj = {
    selectValue: selectValue.value,
    selectName: selectName.value,
    typeText: typeText.value,
    data: data,
  };
  emits('update:linkObj', linkObj);
}
// 自定义页面选择
function customChanged () {
  var data = customPageSelectRef.value.tableRadio;
  customVisible.value = false;
  selectName.value = customPageSelectRef.value.tableRadio.name;
  const linkObj = {
    selectValue: selectValue.value,
    selectName: selectName.value,
    typeText: typeText.value,
    data: data,
  };
  emits('update:linkObj', linkObj);
}
// 公告选择
function noticeChanged () {
  var data = noticeSelectRef.value.tableRadio;
  noticeVisible.value = false;
  selectName.value = noticeSelectRef.value.tableRadio.noticeTitle;
  const linkObj = {
    selectValue: selectValue.value,
    selectName: selectName.value,
    typeText: typeText.value,
    data: data,
  };
  emits('update:linkObj', linkObj);
}
// 删除选择
function delSelect () {
  const linkObj = {
    selectValue: '',
    selectName: '',
    typeText: '',
    data: {},
  };
  emits('update:linkObj', linkObj);
}

watch(() => linkObj, (newVal) => {
  console.log(newVal, 'newVal')
  selectValue.value = newVal.value.selectValue
  selectName.value = newVal.value.selectName
  typeText.value = newVal.value.typeText
  confirmBtnVisible.value = selectValue.value !== '/index' && selectValue.value
}, { immediate: false, deep: true })
</script>

<style lang="scss" scoped>
.link-select {
  &__select {
    width: 100%;
  }
  &__confirm {
    margin-top: 10px;
    .btn {
      text-align: center;
      background-color: $mainColor;
      color: #fff;
      height: 36px;
      line-height: 36px;
      border-radius: 4px;
      cursor: pointer;
    }
    .info {
      height: 36px;
      line-height: 36px;
      border-radius: 4px;
      padding: 0 10px;
      border: 1px solid $mainColor;
      display: flex;
      .text {
        color: $mainColor;
      }
      .name {
        flex: 1;
        margin-left: 10px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .iconfont {
        margin-left: 10px;
        cursor: pointer;
        color: #666;
      }
    }
  }
  &.style1 {
    .link-select__warp {
      display: flex;
      justify-content: space-between;
      width: 100%;
      align-items: center;
    }
    width: 100%;
    margin-bottom: 0;
    .module-box__title {
      margin-bottom: 0;
    }
    .link-select__select {
      width: auto;
    }
  }
}
</style>
