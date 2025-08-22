/**
  单个商品组件
 */
<template>
  <div class="itemSlot">
    <div class="showImg" @click="toDetail">
      <img v-if="data.image || data.productImage" :src="data.image || data.productImage" alt="">
      <!-- 图片底部是否需要增加内容 配合absolute使用 -->
      <slot name="extra"></slot>
    </div>
    <div class="footer">
      <div class="title">{{ data.productName }}</div>
      <div class="priceContainer">
        <!-- 自定义Icon -->
        <slot name="icon"></slot>
        <div class="price">￥{{ data.price }}</div>
        <span class="originalPrice">￥{{ data.originalPrice }}</span>
      </div>
      <!-- 自定义按钮 -->
      <slot name="button"></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => {}
    }
  },
  methods: {
    // 图片点击回调
    toDetail () {
      this.$emit('toDetail')
    }
  }
}
</script>

<style lang="scss" scoped>
.itemSlot{
  .showImg{
    width: 100%;
    height: 330px;
    position: relative;
    cursor: pointer;
    img{
      width: 100%;
      height: 100%;
      margin: auto;
    }
  }
  .footer{
    width: 100%;
    .title{
      width: 95%;
      margin: 15px auto;
      text-align: center;
      font-size: 18px;
      font-family: Microsoft YaHei;
      color: #333333;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .priceContainer{
      display: flex;
      justify-content: center;
      align-items: center;
      .price{
        min-width: 100px;
        text-align: center;
        font-size: 25px;
        font-family: Microsoft YaHei;
        font-weight: bold;
        color: #C83732;
      }
      .originalPrice{
        font-size: 18px;
        font-family: Microsoft YaHei;
        color: #CCCCCC;
        text-decoration: line-through;
      }
    }
  }
}
</style>
