<template>
  <el-dialog
    v-model="infoVisible"
    title="动态详情"
    width="50%"
    center
    top="10vh"
    :close-on-click-modal="false"
    @closed="close"
  >
    <div class="dialog-con">
      <div class="t-box">
        <p><font>发布店铺：</font>{{info.shopName}}</p>
        <p><font>发布时间：</font>{{info.publishTime}}</p>
      </div>
      <div class="item-box">
        <p><font>动态类型：</font>{{info.fileType===1?'图文':'视频'}}</p>
      </div>
      <div class="item-box">
        <p class="label">动态文案：</p>
        <p class="r-p">{{info.remark}}</p>
      </div>
      <div class="item-box" v-if="info.fileType===1">
        <p class="label">动态图：</p>
        <div class="r-p img-box">
          <el-image
            style="width: 200px; height: 200px;margin-right: 20px;"
            :src="item"
            :zoom-rate="1.2"
            :max-scale="7"
            :min-scale=".2"
            :preview-src-list="[item]"
            :initial-index="4"
            fit="cover"
            v-for="(item, index) in info.fileUrl"
            :key="index"
          />
        </div>
      </div>
      <div class="item-box" v-else>
        <p class="label">动态视频：</p>
        <div class="r-p video">
          <video controls="controls" loop="loop" width="auto" height="400px" v-if="info.fileUrl">
            <source :src="info.fileUrl" type="video/mp4" />
          </video>
        </div>
      </div>
      <div class="item-box" v-if="info.fileType===2">
        <p class="label">视频封面：</p>
        <div class="r-p img-box">
          <el-image
            style="width: 200px; height: 200px;margin-right: 20px;"
            :src="item"
            :zoom-rate="1.2"
            :max-scale="7"
            :min-scale=".2"
            :preview-src-list="[item]"
            :initial-index="4"
            fit="cover"
            v-for="(item, index) in info.cover"
            :key="index"
          />
        </div>
      </div>
      <div class="item-box">
        <p class="label">关联商品：</p>
        <el-table
          :data="info.products || []"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%;"
          max-height="400"
        >
          <el-table-column
            prop="productId"
            label="商品id"
            show-overflow-tooltip
          />
          <el-table-column label="商品图片" width="220" align="center">
            <template #default="scope">
              <img
                height="80"
                width="80"
                :src="scope.row.productImage"
                alt
                srcset
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="productName"
            label="商品名称"
            align="center"
          />
          <el-table-column
            prop="section"
            label="售价区间"
            show-overflow-tooltip
          />
        </el-table>
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
import {ref} from "vue";
import {
  contentInfo
  } from '@/api/content';

const infoVisible = ref(false)
const info = ref({})

const getInfo = async(item) => {
  const {code, data} = await contentInfo({recommendId: item.recommendId});
  if(code==="") {
    infoVisible.value = true;
    info.value = data;
    if(data.fileType===1) {
      info.value.fileUrl = data.fileUrl.split(',');
    }
    if(data.cover) {
      info.value.cover = data.cover.split(',');
    }
  }
}
function close() {
  info.value = {};
  infoVisible.value = false;
}

defineExpose({
  getInfo
})
</script>

<style lang="scss" scoped>
:deep(.el-image-viewer__img) {
  width: auto;
  height: auto;
}
.dialog-con {
  padding: 20px;
  .t-box, .item-box {
    display: flex;
    margin-top: 20px;
    p {
      font {
        display: inline-block;
        width: 100px;
      }
      &.label {
        width: 100px;
      }
    }
    .r-p {
      flex: 1;
      word-break: break-word;
      video {
        height: 400px;
        width: auto;
      }
    }
  }
  .t-box {
    p {
      flex: 1;
    }
  }
}
</style>