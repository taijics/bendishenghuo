<template>
  <div class="activeData">
    <div class="topData">
      <div v-for="(item, index) in infoList" :key="index" class="details">
        <div class="textOne">{{ item.value }}</div>
        <div class="textTwo">
          <div class="l_text">{{ item.name }}</div>
        </div>
      </div>
    </div>
    <div class="botTable">
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>商家数据明细</span>
          <el-button
            class="exportBtn"
            type="primary"
            @click="send"
          >导出</el-button>
        </div>
        <div class="text">
          <!--  表格 -->
          <div class="content_table">
            <slot name="table"></slot>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { toRefs } from 'vue';

const props = defineProps({
  infoList: {
    type: Array,
    default: () => [],
  }
})
const { infoList } = toRefs(props)
const $emit = defineEmits(['export'])
function send () {
  $emit('export')
}

</script>

<style lang="scss" scoped>
.activeData {
  .topData {
    width: 100%;
    height: 140px;
    background: #ffffff;
    box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: space-around;
    .details {
      .textOne {
        font-size: 40px;
        font-weight: bold;
        color: #ffae11;
        text-align: center;
      }
      .textTwo {
        font-size: 18px;
        color: #333333;
        display: flex;
        justify-content: center;
        align-items: center;
        .l_text {
          height: 20px;
        }
      }
    }
  }
  .botTable {
    margin-top: 20px;
    .clearfix {
      span {
        line-height: 40px;
      }
    }
    .exportBtn {
      float: right;
    }
  }
}
</style>
