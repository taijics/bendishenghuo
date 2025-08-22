<template>
  <div class="logistics_info">
    <div class="logistics_com">
      <p>
        <span>物流公司:</span>
        <span>{{ logisticsList.detail.express }}</span>
      </p>
      <p>
        <span>物流单号:</span>
        <span>{{ logisticsList.detail.deliverFormid }}</span>
      </p>
    </div>
    <div class="logistics_status">
      <div>物流信息:</div>
      <div>
        <p v-for="(item, index) in logisticsList.arr" :key="index">
          <span>{{ item.time }}</span>
          <span>{{ item.reason }}</span>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { toRefs } from 'vue';

const props = defineProps({
  logisticsList: {
    type: Object,
    default () {
      return {}
    },
  }
})
const { logisticsList } = toRefs(props)

</script>

<style lang="scss" scoped>
.logistics_info {
  padding: 20px 10%;
  .logistics_com {
    overflow: hidden;
    margin-bottom: 30px;
    p {
      width: 50%;
      float: left;
      span {
        font-size: 16px;
        color: #333333;
        display: inline-block;
        &:nth-of-type(1) {
          width: 80px;
        }
        &:nth-of-type(2) {
          color: #666666;
        }
      }
    }
  }
  .logistics_status {
    overflow: hidden;
    div {
      font-size: 16px;
      color: #333333;
      float: left;
      &:nth-of-type(1) {
        width: 80px;
      }
      &:nth-of-type(2) {
        width: calc(80% - 80px);
        color: #666666;
        p {
          margin: 0;
          margin-bottom: 20px;
          span {
            display: inline-block;
            &:nth-of-type(2) {
              margin-top: 10px;
            }
          }
        }
      }
    }
  }
}
</style>
