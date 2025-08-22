/**
  购物车-店铺商品插槽组件
 */
<template>
  <div class="cartItemSlot">
    <div class='main-list' v-for='(item, index) in list' :key='index'>
      <div class='main-shop' v-if='item.skus.length'>
        <el-checkbox v-model="item.selected"
            @change='selectShop(item)'
            :true-label='1'
            :false-label='0'/>
        <span class="goToStore"
            @click="toStore(item.shopId)"
        >店铺: {{item.shopName}}</span>
      </div>
      <div class='pro-list'>
        <div class='pro-item' v-for='(i, j) in item.skus' :key='j'>
          <div class="top">
            <el-checkbox
                v-model="i.selected"
                @change='selectProduct'
                :true-label='1'
                :false-label='0'/>
            <div class='item'>
                <img :src="i.image" alt="" @click="goToProductDetail(kt,item.shopId)">
            </div>
            <div class='pro-des'>
                <div>
                    <p @click="goToProductDetail(i,item.shopId)">{{kt.productName}}</p>
                    <p>
                        <span>{{i.sku}}</span>
                        <span>{{i.value}}</span>
                    </p>
                </div>
            </div>
            <div class='item'>
                <p>¥ {{i.price}}</p>
            </div>
            <div class='item'>
                <el-input-number
                  :disabled="!i.shelveState"
                  v-model="i.number"
                  @change="handleChange(kt)"
                  :min="1"
                  :max="kt.stockNumber"
                  :step=1 label="描述文字"
                  size='small'
                ></el-input-number>
            </div>
            <div class='item'>
                <p v-if="i.shelveState">¥ {{i.total}}</p>
                <p v-else class="fs20">(已下架)</p>
            </div>
            <div class='item'>
                <p @click='confirDelete(i)' v-throttle>
                    <icon-svg
                      style="font-size:30px; margin-left: 30px;"
                      icon-class="del"
                    />
                </p>
            </div>
        </div>
        <!-- 领取优惠券 -->
        <div class='discount'>
            优惠券
            <div class='pop-box'>
              <div class='box-content'>
                  <p class='title'>可领取的优惠券:</p>
                  <ul>
                      <li v-for='(d, dIndex) in i.markTools' :key='dIndex'>
                          <p>¥{{d.count}}</p>
                          <p>
                              <span>{{d.discount}}</span>
                              <span>{{d.time}}</span>
                          </p>
                          <p>领取</p>
                      </li>
                      <li v-for='(d, dIndex) in i.shopMarkTools' :key='dIndex'>
                          <p>¥{{d.count}}</p>
                          <p>
                              <span>{{d.discount}}</span>
                              <span>{{d.time}}</span>
                          </p>
                          <p>领取</p>
                      </li>
                  </ul>
                  <!-- <ul v-else>
                      暂无优惠券
                  </ul> -->
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    list: {
      type: Array,
      default: () => []
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
