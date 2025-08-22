<!--
    * @FileDescription: DeleteModal
    * @Author: kahu
    * @Date: 2022/11/3
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/3
-->
<template>
  <div class="content">
    <TuiModal
        :show="isShow"
        :custom="true"
        :fadein="true"
    >
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          温馨提示
        </view>
        <view class="mar-top-40 text-align">
          您确定删除选中的商品吗？
        </view>
        <view class="flex-display flex-sp-between">
          <view
              class="btn"
              @click="$emit('update:showTip',false)"
          >
            点错了
          </view>
          <view
              class="btn submit"
              @click="$emit('confirm')"
          >
            确认删除
          </view>
        </view>
      </view>
    </TuiModal>
  </div>
</template>

<script setup>
import TuiModal from "../../../../components/modal/modal";
import { ref, watch } from "vue";
const isShow = ref(false)
const props = defineProps({
  showTip:{
    type:Boolean
  }
})
watch(()=>props.showTip,(val)=>{
  isShow.value = val
})
</script>

<style
    lang="scss"
    scoped
>
.Put-box1 {
  .btn {
    text-align: center;
    margin-top: 40rpx;
    border: 1px solid #333333;
    height: 80upx;
    line-height: 80upx;
    width: 240upx;
    color: #333333;
  }

  .submit {
    background-color: #333333;
    color: #FFEBC4;
  }
}
</style>
