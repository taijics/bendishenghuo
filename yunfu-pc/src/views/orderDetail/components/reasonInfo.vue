<template>
  <div class="afterSaleInfo">
    <div class="info title">售后信息</div>
    <div class="info type">
      <p>售后方式：{{ data.type ===1 ?'仅退款':'退货退款' }}</p>
      <p>货物状态：{{ data.goodsState ===0 ?'未收到货':'已收到货' }}</p>
    </div>
    <p class="info">售后理由：{{ data.returnReason }}</p>
    <p class="info long">退货理由描述：{{ data.explain }}</p>
    <div class="pic" v-if="data.image">
        <span>凭证：</span>
        <el-image
            v-for="(url, index) in data.image"
            :key="index"
            style="width: 100px; height: 100px"
            :src="url"
          >
        </el-image>
        <!-- :preview-src-list="image" -->
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => ({
        type: 0,
        goodsState: 0,
        returnReason: '',
        explain: '',
        image: []
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.afterSaleInfo{
    height: 265px;
    padding: 20px 30px;
    border: 1px solid #F3F4F5;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .title{
      font-size: 16px;
    }
    .info{
      font-size: 14px;
    }
    .type{
      width: 50%;
      display: flex;
      justify-content: space-between;
      p{
        display: block;
        font-size: 14px;
      }
    }
    .pic{
      height: 100px;
      display: flex;
      .el-image{
        margin: 0 5px;
      }
    }
}
</style>
