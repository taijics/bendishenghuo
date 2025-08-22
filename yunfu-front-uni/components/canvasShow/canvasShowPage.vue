<template>
  <div class="layout hom-layout">
    <div class="list-group-item"
         v-for="(item,index) in componentsData"
         :key="index">
      <!--        <component :is="componentMap[terminal-1].get(item.type)" :componentContent="item.componentContent" :terminal="terminal" :typeId="typeId" :shopId="shopId"></component>-->
      <com-banner v-if="item.type==='banner'"
                  :componentContent="item.componentContent"
                  :terminal="terminal"
                  :typeId="typeId"
                  :shopId="shopId"></com-banner>
      <com-text v-if="item.type==='text'"
                :componentContent="item.componentContent"
                :terminal="terminal"
                :typeId="typeId"
                :shopId="shopId"></com-text>
      <com-image-text v-if="item.type==='imageText'"
                      :componentContent="item.componentContent"
                      :terminal="terminal"
                      :typeId="typeId"
                      :shopId="shopId"></com-image-text>
      <com-brand-list v-if="item.type==='brandList'"
                      :componentContent="item.componentContent"
                      :terminal="terminal"
                      :typeId="typeId"
                      :shopId="shopId"></com-brand-list>
      <com-category-list v-if="item.type==='categoryList'"
                         :componentContent="item.componentContent"
                         :terminal="terminal"
                         :typeId="typeId"
                         :shopId="shopId"></com-category-list>
      <com-image-text-list v-if="item.type==='imageTextList'"
                           :componentContent="item.componentContent"
                           :terminal="terminal"
                           :typeId="typeId"
                           :shopId="shopId"></com-image-text-list>
      <com-assist-div v-if="item.type==='assistDiv'"
                      :componentContent="item.componentContent"
                      :terminal="terminal"
                      :typeId="typeId"
                      :shopId="shopId"></com-assist-div>
      <com-image-text-nav v-if="item.type==='imageTextNav'"
                          :componentContent="item.componentContent"
                          :terminal="terminal"
                          :typeId="typeId"
                          :shopId="shopId"></com-image-text-nav>
      <com-product v-if="item.type==='productList'"
                   ref="productPage"
                   :componentContent="item.componentContent"
                   :terminal="terminal"
                   :typeId="typeId"
                   :shopId="shopId"></com-product>
      <com-video-box v-if="item.type==='videoBox'"
                     :componentContent="item.componentContent"
                     :terminal="terminal"
                     :typeId="typeId"
                     :shopId="shopId"></com-video-box>
      <com-coupon v-if="item.type==='coupon'"
                  :componentContent="item.componentContent"
                  :terminal="terminal"
                  :typeId="typeId"
                  :shopId="shopId"></com-coupon>
      <com-custom v-if="item.type==='custom'"
                  :componentContent="item.componentContent"
                  :terminal="terminal"
                  :typeId="typeId"
                  :shopId="shopId"></com-custom>
      <com-notice v-if="item.type==='notice'"
                  :componentContent="item.componentContent"
                  :terminal="terminal"
                  :typeId="typeId"
                  :shopId="shopId"></com-notice>
      <com-vip v-if="item.type==='vip'"
               :componentContent="item.componentContent"
               :terminal="terminal"
               :typeId="typeId"
               :shopId="shopId"></com-vip>
      <com-group v-if="item.type==='groupList'"
                 :componentContent="item.componentContent"
                 :terminal="terminal"
                 :typeId="typeId"
                 :shopId="shopId"></com-group>
      <com-discount v-if="item.type==='discountList'"
                    :componentContent="item.componentContent"
                    :terminal="terminal"
                    :typeId="typeId"
                    :shopId="shopId"></com-discount>
      <com-spike v-if="item.type==='spikeList'"
                 :componentContent="item.componentContent"
                 :terminal="terminal"
                 :typeId="typeId"
                 :shopId="shopId"></com-spike>
      <com-price v-if="item.type==='priceList'"
                 :componentContent="item.componentContent"
                 :terminal="terminal"
                 :typeId="typeId"
                 :shopId="shopId"></com-price>
      <com-new-product v-if="item.type==='newProduct'"
                       :componentContent="item.componentContent"
                       :terminal="terminal"
                       :typeId="typeId"
                       :shopId="shopId"></com-new-product>
      <com-shop v-if="item.type==='shop'"
                :componentContent="item.componentContent"
                :terminal="terminal"
                :typeId="typeId"
                :shopId="shopId"></com-shop>
      <com-live v-if="item.type==='live'"
                :componentContent="item.componentContent"
                :terminal="terminal"
                :typeId="typeId"
                :shopId="shopId"></com-live>
    </div>
  </div>
</template>

<script setup>
import comBanner from '@/components/canvasShow/basics/banner.vue'
import comText from '@/components/canvasShow/basics/text.vue'
import comImageText from '@/components/canvasShow/basics/imageText.vue'
import comBrandList from '@/components/canvasShow/basics/brandList.vue'
import comCategoryList from '@/components/canvasShow/basics/categoryList.vue'
import comImageTextList from '@/components/canvasShow/basics/imageTextList.vue'
import comAssistDiv from '@/components/canvasShow/basics/assistDiv.vue'
import comImageTextNav from '@/components/canvasShow/basics/imageTextNav.vue'
import comProduct from '@/components/canvasShow/basics/product/app/index.vue'
import comVideoBox from '@/components/canvasShow/basics/video.vue'
import comCoupon from '@/components/canvasShow/basics/coupon/app/index.vue'
import comCustom from '@/components/canvasShow/basics/custom.vue'
import comNotice from '@/components/canvasShow/basics/notice.vue'
import comVip from '@/components/canvasShow/basics/vip/app/index.vue'
import comGroup from '@/components/canvasShow/basics/group/app/index.vue'
import comDiscount from '@/components/canvasShow/basics/discount/app/index.vue'
import comSpike from '@/components/canvasShow/basics/spike/app/index.vue'
import comPrice from '@/components/canvasShow/basics/price/app/index.vue'
import comNewProduct from '@/components/canvasShow/basics/newProduct/app/index.vue'
import comShop from '@/components/canvasShow/basics/shop.vue'
import comLive from '@/components/canvasShow/basics/live/app/index.vue'

import { nextTick, onMounted, ref, toRefs } from 'vue';
const props = defineProps({
  terminal: {
    type: Number,
    default: 4
  },
  typeId: {
    type: Number,
    default: 1
  },
  shopId: {
    type: Number,
    default: 0
  },
  componentsData: {
    type: Array,
    default: ()=>[]
  },
})
const { terminal, typeId, shopId, componentsData } = toRefs(props)

const productPage = ref()
function loadMore(){
  try {
    productPage.value && Array.isArray(productPage.value) && productPage.value.at(-1)?.loadNext()
  } catch (e) {
    console.error(e)
    throw Error(e)
  }
}
defineExpose({loadMore})
</script>

<style lang="scss"
       scoped>
.hom-layout {
  background-color: #ffffff;
  width: 100%;
  overflow: hidden;
}
</style>

<style lang="scss">
.warp {
  width: 710upx;
  margin: 0 auto;
  max-width: 100%;

  &.terminal4 {
    width: 1200px;
    max-width: 100%;
  }
}

.flex-box {
  display: flex;
}
</style>
