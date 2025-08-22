<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    title="详情"
    width="74%"
  >
    <div>
      <el-card class="box-card">
        <span class="addTitle">商品详情</span>
        <el-button
          type="success"
          class="btnList"
          @click="back"
        >关闭
        </el-button>
        <el-button
          v-if="productItem.shelveState === 2"
          type="primary"
          class="btnList"
          @click="examineShow(productData)"
        >审核
        </el-button>
      </el-card>
      <el-card class="box-card">
        <label>商品详情</label>
        <div class="GoodBox">
          <el-row class="detail-box">
            <el-col :span="12">
              <div>商品名称：{{ productItem.productName }}</div>
              <div>商品卖点：{{ productItem.productBrief }}</div>
              <div>
                商品图片：
                <div>
                  <img
                    v-for="(item, index) in productItem.images"
                    :key="index"
                    class="proImage"
                    :src="item.imgPath"
                    alt=""
                    @click="handlePictureCardPreview(item)"
                  />
                </div>
              </div>
              <div>商品款式：</div>
            </el-col>
            <el-col :span="12">
              <div>官方分类：{{ productItem.classifyName }}</div>
              <div>商家分组：{{ productItem.shopGroupName }}</div>
              <div>商家名称：{{ productItem.shopName }}</div>
              <div>
                商品状态：
                <span v-if="productItem.shelveState == 0">已下架 </span>
                <span v-if="productItem.shelveState == 1">已上架</span>
                <span v-if="productItem.shelveState == 2">待审核</span>
                <span v-if="productItem.shelveState == 3">审核失败</span>
              </div>
            </el-col>
          </el-row>
          <el-row class="detail-box">
            <el-col :span="24">
              <el-table
                :data="productItem.skuList"
                style="width: 100%"
                :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              >
                <el-table-column
                  v-for="(skuAttr, index) in skuAttrName"
                  :key="index"
                  :label="skuAttr.skuName"
                >
                  <template #default="scope">
                    {{
                      attrValueFilter(scope.row.skuAttrCodeDTOList && scope.row.skuAttrCodeDTOList[index],productItem.skuAttrList)
                    }}
                  </template>
                </el-table-column>
                <el-table-column label="售价">
                  <template #default="scope">
                    <el-input
                      v-model="scope.row.price"
                      maxlength="9"
                      disabled
                      oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                    />
                  </template>
                </el-table-column>
                <el-table-column label="原价">
                  <template #default="scope">
                    <el-input
                      v-model="scope.row.originalPrice"
                      maxlength="9"
                      disabled
                      oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                    />
                  </template>
                </el-table-column>
                <el-table-column label="库存">
                  <template #default="scope">
                    <el-input
                      v-model="scope.row.stockNumber"
                      maxlength="9"
                      disabled
                      oninput="value=value.replace(/[^\d]/g,'')"
                    />
                  </template>
                </el-table-column>
                <el-table-column label="重量(KG)">
                  <template #default="scope">
                    <el-input
                      v-model="scope.row.weight"
                      maxlength="9"
                      disabled
                      oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                    />
                  </template>
                </el-table-column>
                <el-table-column label="SKU">
                  <template #default="scope">
                    <el-input
                      v-model="scope.row.sku"
                      maxlength="20"
                      disabled
                    />
                  </template>
                </el-table-column>
              </el-table>
            </el-col>
          </el-row>
        </div>
      </el-card>

      <el-card class="box-card">
        <label>商品简介</label>
        <!-- <Tinymce
          ref="content"
          v-model="productItem.productText"
          class="tinymce-wrap"
          :height="180"
        /> -->
        <br />
        <br />
        <div v-html="productItem.productText"></div>
      </el-card>

      <el-dialog
        v-model="dialogVisible"
        append-to-body
        class="check-image-dialog"
        title="查看图片"
        center="center"
      >
        <img
          :src="dialogImageUrl"
          style="
            display: block;
            margin: auto;
            max-width: 500px;
            max-height: 500px;
          "
          alt
        />
      </el-dialog>
    </div>
  </el-dialog>
</template>

<script setup>
import { shallowRef, computed, ref, toRefs } from 'vue';
// import Tinymce from '@/components/Tinymce';
// import { uploadUrl } from '@/utils/request';
import { getProductById } from '@/api/commodity'

const props = defineProps({
  examineShow: {
    type: Function,
    default: null,
  }
})
const { examineShow } = toRefs(props)
defineExpose({ show })

let visible = shallowRef(false)
let dialogVisible = ref(false)
const dialogImageUrl = ref('')
const productItem = ref({})
const productData = ref({
  productId: 0,
  isDetail: true,
})

const skuAttrName = computed(() => (
  productItem.value.skuAttrList &&
    productItem.value.skuAttrList.filter((skuAttr) => {
      const hasChilds = skuAttr.values.some((attr) => {
        return attr.skuValue
      })
      return skuAttr.skuName && hasChilds
    })
))

function show (id) {
  visible.value = true
  productData.value.productId = id
  details()
}

function handlePictureCardPreview (item) {
  dialogImageUrl.value = item.imgPath
  dialogVisible.value = true
}

function back () {
  visible.value = false
}

function details () {
  getProductById({
    productId: productData.value.productId,
  }).then(res => {
    productItem.value = res.data
    productItem.value.skuAttrList = res.data.names
    productItem.value.skuList = productItem.value.skus
  })
}

function attrValueFilter (map, list) {
  const hasChilds =
      list &&
      list.filter((skuAttr) => {
        const hasChild = skuAttr.values.some((attr) => {
          return attr.skuValue
        })
        return skuAttr.skuName && hasChild
      })
  if (!map) {
    return ''
  }
  const { code, valueCode } = map
  let codeStr = ''
  hasChilds.map((item) => {
    const { values } = item
    values &&
    values.some((attr) => {
      const isSome = item.code === code && attr.valueCode === valueCode
      if (isSome) {
        codeStr = attr.skuValue
      }
      return isSome
    })
  })
  return codeStr
}
</script>

<style lang="scss" scoped>
.box-card {
  margin: 20px;
}

.btnList {
  float: right;
  padding: 3px 0;
  width: 100px;
  height: 48px;
  border-radius: 4px;
  margin-right: 30px;
}

.addTitle {
  font-size: 24px;
  color: #333333;
  line-height: 50px;
}

.GoodBox {
  padding: 40px;

  .detail-box {
    div {
      line-height: 60px;

      .proImage {
        margin-right: 20px;
        width: 80px;
        height: 80px;
      }
    }
  }
}

.tinymce-wrap {
  margin-top: 10px;
}

.check-image-dialog {
  margin-top: -100px;
  text-align: center;

  .img {
    text-align: center;
  }
}
</style>
