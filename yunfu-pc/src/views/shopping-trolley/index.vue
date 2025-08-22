<template>
  <div class='shopping-trolley sub-main'>
    <div class='trolley-list warp'>
      <div class='total-pro'>全部商品 <span>{{cartNumber > 0 ? cartNumber : ''}}</span></div>
      <div class='trolley-title'>
        <p>
          <el-checkbox
            v-model="selectAll"
            @change='getAllProduct'
            :true-label='1'
            :false-label='0'
          />
          全选
        </p>
        <p><b>商品名称</b></p>
        <p>商品属性</p>
        <p>单价</p>
        <p>数量</p>
        <p>小计</p>
        <p>操作</p>
      </div>
      <div class='trolley-body' v-loading="listLoading">
        <div class="minh" v-if="noGoods==false">
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
            <!-- +++++++++++++++++++++++++++++++++++++++++++++活动标题+++++++++++++++++++++++++++++++++++ -->
            <div class='pro-list'>
              <div class='pro-item' v-for='(kt, index2) in item.skus' :key='index2'>
                <!-- +++++++++++++++++++++++++++++++++++++++++组合捆绑++++++++++++++++++++++++++++++++++ -->
                <div v-if="kt.activityType !== 6">
                  <div class="nav" v-for="(key, inx) in activityCompose" :key="inx">
                    <div v-if="key.shopId === item.shopId">
                      <div v-for="k in key.compose" :key="k.composeId">
                        <div class="activityTitle" v-if="k.composeId === kt.composeId">
                          <div class="name">{{ k.composeName }}</div>
                          <div class="type" v-if="k.composeType === 1">
                            当前活动商品 满{{ k.productIdList.length }}件{{ `${k.promote}元`}}
                          </div>
                          <div class="type" v-if="k.composeType === 2">
                            当前活动商品 满{{ k.productIdList.length }}件{{ `减${k.promote}元`}}
                          </div>
                          <div class="type" v-if="k.composeType === 3">
                            当前活动商品 满{{ k.productIdList.length }}件{{ `打${k.promote}折`}}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- +++++++++++++++++++++++++++++++++++++++++定价捆绑++++++++++++++++++++++++++++++++++ -->
                <div v-if="kt.activityType === 6">
                  <div class="nav" v-for="(key, inx) in activityPrice" :key="inx">
                    <div class="activityTitle" v-if="key.price.length">
                      <div class="name">活动优惠</div>
                      <div class="type"  v-for="(k, ki) in key.price" :key="ki">
                        <span v-if="k.priceId">满{{ k.number }}件{{ k.price }}元</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="top">
                  <el-checkbox
                    v-model="kt.selected"
                    @change='selectProduct'
                    :true-label='1'
                    :false-label='0'
                  />
                  <div class='item'>
                    <img :src="kt.image" alt="" @click="goToProductDetail(kt,item.shopId)">
                  </div>
                  <div class='pro-des'>
                    <div>
                      <p @click="goToProductDetail(kt,item.shopId)">{{kt.productName}}</p>
                      <p>
                        <span>{{kt.sku}}</span>
                        <span>{{kt.value}}</span>
                      </p>
                    </div>
                  </div>
                  <div class='item'>
                    <p>¥ {{kt.price}}</p>
                  </div>
                  <div class='item'>
                    <el-input-number
                      :disabled="!kt.shelveState"
                      :min="1"
                      :max="kt.stockNumber"
                      :step=1 label="描述文字"
                      v-model="kt.number"
                      @change="handleChange(kt)"
                      size='small'
                    ></el-input-number>
                  </div>
                  <div class='item'>
                    <p v-if="kt.shelveState">¥ {{kt.total.toFixed(3).slice(0,-1)}}</p>
                    <p v-else class="fs20">(已下架)</p>
                  </div>
                  <div class='item'>
                    <p @click='confirDelete(kt)' v-throttle>
                      <icon-svg style="font-size:30px; margin-left: 30px;" icon-class="del" />
                    </p>
                  </div>
                </div>
                <!-- +++++++++++++++++++++++++++++++++++++++++++优惠券++++++++++++++++++++++++++++++++++ -->
                <div class='discount'>
                  优惠券
                  <div class='pop-box'>
                    <div class='box-content'>
                      <p class='title'>可领取的优惠券:</p>
                      <div class="type">
                        <CouponBox class="common"
                          :title="'平台券'"
                          :couponList="kt.markTools"
                          @chooseCoupon="getCoupon"
                        />
                        <CouponBox class="common"
                          :title="'商家券'"
                          :couponList="kt.shopMarkTools"
                          @chooseCoupon="getCoupon"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="noproduct minh" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
          <p class="fs20 font-color-999">你的购物车还没有宝贝哦～</p>
        </div>
        <!-- 底部操作栏 -->
        <div class='trolley-footer'>
          <div class='item'>
            <span class='hover'
              @click='confirDelete(selectedList, true)'
              v-throttle
            >删除</span>
          </div>
          <div class='item'>
            <span class="clearBtn"
              v-throttle
              @click="clearListFn"
            >清除失效的宝贝</span>
          </div>
          <div class='item'>
            已选商品<span>{{selectedList.length}}</span>件
          </div>
          <div class='item'>
            <p>
              合计 (不含运费) :<span> ¥ {{totalProice.toFixed(3).slice(0,-1)}}</span>
            </p>
            <p>优惠券: ¥0.00</p>
          </div>
          <div class="item hover"
            @click='submitOrder'
            v-throttle
          >
            结算
          </div>
        </div>
      </div>
    </div>
    <DeleteGoods
      v-if='deleteOpt.visiable'
      :delete-opt='deleteOpt'
      @close='closePop'
      @confirm='deleteGood'
    />
  </div>
</template>

<script>
import {mapGetters, mapMutations} from 'vuex'
import Cookie from 'js-cookie'
import DeleteGoods from '@/views/shopping-trolley/deleteGoods.vue'
import CouponBox from '@/views/shopping-trolley/components/cartCoupon.vue'
import {
  getCartList,
  clearCart,
  // putProduct,
  deleteCartItem,
  updateCartNum
} from '@/api/user/cart.js'
import {
  tabkeTheCoupon
} from '@/api/coupon.js'
import {
  getShopComposePro
} from '@/api/product.js'
import {
  getBindList
} from '@/api/Activity/ActivityBind.js'

export default {
  components: {
    CouponBox,
    DeleteGoods
  },
  data () {
    return {
      deleteOpt: {
          visiable: false
      },
      selectAll: 0,
      playDiscount: false,
      list: [],
      listLoading: false,
      // 已选择的商品
      selectedList: [],
      // 商品总价
      totalProice: 0,
      noGoods: false,
      // activityCompose: {}
      activityCompose: [],
      activityPrice: []
    }
  },
  created () {
    if (!Cookie.get('token')) {
      this.$message.warning('请先登录')
      this.$store.commit('resetVuex')
      // 登录弹框
      this.$store.commit('IS_LOGIN', false) // 清除顶部个人中心数据
      this.$store.commit('SHOW_LOGIN') // 调用登录弹框
    } else {
      this.getTrolleyList()
    }
  },
  computed: {
    ...mapGetters([
      'cartNumber'
    ])
  },
  methods: {
    ...mapMutations({
      setShoppingCart: 'SET_SHOPPINGCART',
      setCartNumber: 'SET_CARTNUMBER'
    }),
    // 购物车列表
    async getTrolleyList () {
      this.listLoading = true
      const response = await getCartList()
      const res = response.data
      if (res.data.length) {
        this.noGoods = false
        this.filterActivity(res.data)
        this.setShoppingCart(res.data) // 设置全局属性
        this.initList()
      } else {
        this.noGoods = true
      }
      this.listLoading = false
    },
    // 查询商品参与的所有有临时规则的活动
    filterActivity (data) {
      data.forEach(item => {
        let activity = [] // 店铺对应商品所参与的活动
        item.skus.forEach(i => {
          if (activity.indexOf(i.activityType) === -1) {
            activity.push(i.activityType)
          }
        })
        // 0-常规商品 1-拼团活动 2-秒杀活动 3-限时折扣活动 4-平台秒杀 5-平台折扣 6-定价捆绑 7-组合捆绑 8-场景营销 9-会员价
        if (activity.indexOf(7) !== -1) {
          this.getComposeData(item.shopId)
        }
        if (activity.indexOf(6) !== -1) {
          this.getPriceData(item.shopId)
        }
        this.list.push(item)
      })
    },
    // // 查询定价捆绑
    async getPriceData (shopId) {
      const response = await getBindList({
        shopId
      })
      const res = response.data
      this.activityPrice.push(Object.assign(
        { shopId },
        {
          price: res.data
        }
      ))
    },
    // 查询组合捆绑
    async getComposeData (shopId) {
      const response = await getShopComposePro({
        shopId,
        terminal: '3',
        system: '3'
      })
      const res = response.data
      /**
       * composeType 1直接定价 2固定减价 3折扣
       * promote 元/折扣
       */
      this.activityCompose.push(
        Object.assign(
          { shopId },
          {
            compose: res.data
          }
        )
      )
    },
    // 初始化购物车数据
    initList () {
      let cartNumber = 0
      this.list.forEach(j => {
        cartNumber = cartNumber + j.skus.length
        j.skus.forEach(k => {
          this.selectProduct(true)
        })
      })
      this.setCartNumber(cartNumber)
    },
    // 选择商品
    selectProduct (flag) {
      this.getSelectedProduct(flag)
      this.setShop()
      this.setselectAll()
    },
    // 选择商铺
    selectShop (shop) {
      this.setProduct(shop)
      this.getSelectedProduct()
      this.setselectAll()
    },
    // 全选
    getAllProduct () {
      this.list.forEach(j => {
        this.$set(j, 'selected', this.selectAll)
        j.skus.forEach(k => {
          this.$set(k, 'selected', this.selectAll)
        })
      })
      this.getSelectedProduct()
    },
    // 处理店铺下的商品选择状态
    setProduct (shop) {
      this.list.forEach((j) => {
        if (j.shopId === shop.shopId) {
          j.skus.forEach(k => {
            this.$set(k, 'selected', j.selected)
          })
        }
      })
    },
    // 店铺下的商品全选时, 更新店铺的选中状态
    setShop () {
      this.list.forEach(j => {
        const flag = j.skus.findIndex(item => !item.selected)
        this.$set(j, 'selected', flag < 0 ? 1 : 0)
      })
    },
    // 店铺全选时, 更新全选状态
    setselectAll () {
        const temp = this.list.findIndex(item => !item.selected)
        this.selectAll = temp < 0
    },
    // 选择的商品集合
    getSelectedProduct () {
      let shopCarts = []
      this.list.forEach((j, i) => {
        let skus = []
        j.skus.forEach((k, n) => {
          const index = this.selectedList.findIndex(item => item.skuId === k.skuId)
          this.$set(k, 'total', k.price * k.number)
          if (k.selected && index < 0) {
            this.selectedList.push(k)
          }
          if (!k.selected && index > -1) {
            this.selectedList.splice(index, 1)
          }
          skus[n] = {
            skuId: k.skuId,
            selected: k.selected
          }
        })
        shopCarts[i] = {
          shopId: j.shopId,
          skus
        }
      })
      this.getTotalPrice()
      // 将选择的商品上传服务
      // putProduct({ shopCarts })
    },
    // 计算商品总价
    getTotalPrice () {
      let sum = 0
      this.selectedList.forEach(item => {
        sum += item.total
      })
      this.totalProice = sum
    },
    // 确认是否删除商品
    confirDelete (info, flag) {
      if (flag && !info.length) return this.$message.warning('请选中需要删除的商品')
      this.deleteOpt = {
        visiable: true,
        info,
        all: flag
      }
    },
    // 删除单个商品
    async deleteGood (delData) {
      // const id = info.skuId
      const goodList = delData.all ? delData.info : [delData.info]
      let ids = []
      goodList.forEach(it => {
        let id = it.skuId
        ids.push(id)
        this.list.map(j => {
          j.skus.map(k => {
            if (k.skuId === id) {
              j.skus.splice(j.skus.findIndex(item => item.skuId === id), 1)
            }
          })
        })
      })
      let number = 0
      this.list.map(j => {
        j.skus.map(k => {
          number = number + 1
        })
      })
      this.setCartNumber(number)
      this.selectedList = []
      this.getSelectedProduct()
      this.closePop()
      const response = await deleteCartItem({ ids })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('删除成功')
      }
      let flag = 0
      this.list.forEach(item => {
        flag += item.skus.length
      })
      this.noGoods = flag === 0
    },
    // 修改购物车商品数量
    async handleChange (kt) {
      await updateCartNum({
        skuId: kt.skuId,
        number: kt.number
      })
      this.$set(kt, 'total', kt.productPrice * kt.number)
      this.getSelectedProduct()
    },
    // 清空失效宝贝
    async clearListFn () {
      const response = await clearCart()
      if (response.data.code === '200') {
        this.$message.success('清空成功！')
        location.reload()
      } else {
        this.$message.error(response.data.message || '清空失败！')
      }
    },
    // 结算
    submitOrder () {
      let shops = []
      let down = false
      this.list.forEach((j, i) => {
        let skus = []
        j.skus.forEach((k, n) => {
          if (!k.shelveState && k.selected) {
            down = true
            return this.$message.warning('选中的商品中有下架商品')
          }
          if (k.selected) {
            skus.push({
              skuId: k.skuId,
              priceId: k.priceId,
              number: k.number,
              ifLogistics: k.ifLogistics,
              selected: k.selected
            })
          }
        })
        if (skus.length) {
          shops.push({
            shopId: j.shopId,
            skus
          })
        }
      })
      if (down) {
        return
      }
      if (this.selectedList.length) {
        return this.$router.push({name: 'placeOrder',
          query: {
            type: 2,
            shops: JSON.stringify(shops),
            ifWork: 0,
            activityType: 0
          }
        })
      }
      return this.$message.warning('请至少选中一件商品')
    },
    closePop () {
      this.deleteOpt = {
        visiable: false
      }
    },
    // 跳转到商品详情
    goToProductDetail (item, id) {
      let data = {
        shopId: id,
        productId: item.productId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store', query: {shopId: id}
      })
    },
    // 领取优惠券
    async getCoupon (item) {
      const response = await tabkeTheCoupon({
        couponId: item.couponId || 0,
        shopCouponId: item.shopCouponId || 0,
        shopId: item.shopId || 0
      })
      if (response.data.code === '200') {
        this.$message.success('领取成功！')
      } else {
        this.$message.error(response.data.message || '领取失败！')
      }
    }
  }
}
</script>

<style scoped lang='scss'>
$cartRed: #C83732;
.shopping-trolley {
  width: 80%;
  margin: 20px auto;
  .hover:hover {
    cursor: pointer;
  }
  .trolley-list {
    .total-pro {
      font-size:20px;
      font-weight: bold;
      margin-bottom: 20px;
      span{
        color: $cartRed;
      }
    }
    .trolley-title {
      display: flex;
      background-color: #F1F2F7;
      height: 54px;
      line-height: 54px;
      padding-right: 12px;
      p {
        margin: 0;
        color: #333;
        font-size: 16px;
        flex: 1;
        text-align: center;
        &:nth-child(2) {
          flex:3;
          text-align: left;
          b {
            font-weight: normal;
            padding-left: 60px;
          }
        }
        &:nth-child(3) {
          flex:1;
          text-align: left;
        }
      }
      >>> .el-checkbox {
        margin-right: 5px;
      }
    }
    .trolley-body {
      .minh{
        min-height: 400px;
      }
      .main-list {
        .main-shop {
          line-height: 50px;
          color: #FFF;
          background-color: #333;
          font-size: 16px;
          padding-left: 30px;
          .goToStore {
              cursor: pointer;
          }
        }
        .pro-list {
          border: 1px solid #E5E5E5;
          margin-bottom: 20px;
          .pro-item {
            &:nth-child(n+2) {
              border-top: 1px solid #E5E5E5;
            }
            .nav{
              .activityTitle{
                height: 40px;
                line-height: 40px;
                padding: 0 10px;
                background-color: #F9F6F1;
                display: flex;
                align-items: center;
                .name{
                  height: 30px;
                  padding: 0px 10px;
                  line-height: 30px;
                  color: #FFF;
                  font-weight: bold;
                  background-color: #C83732;
                }
                .type{
                  margin-left: 18px;
                  color: #C83732;
                }
              }
            }
            .top{
              padding: 0 30px;
              display: flex;
              align-items: center;
              .item{
                flex: 1;
                padding: 15px;
                p {
                  text-align: center;
                }
                &:nth-child(1) {
                  display: flex;
                  align-items: center;
                  justify-content: center;
                }
                &:nth-child(2) {
                  img {
                    width: 100px;
                    height: 100px;
                    box-sizing: border-box;
                    cursor: pointer;
                  }
                }
                &:nth-child(5) {
                  color: #FF7800;
                  font-weight: bold;
                }
                &:last-child {
                  &:hover {
                    cursor: pointer;
                  }
                }
              }
              .pro-des {
                flex: 5;
                div {
                  p {
                    float: left;
                    overflow: hidden;
                    &:nth-child(1) {
                      width: 67%;
                      color: #333;
                      font-size: 16px;
                      padding-right: 30px;
                      box-sizing: border-box;
                    }
                    &:nth-child(2) {
                      width: 33%;
                      text-align: center;
                      span {
                        display: block;
                        font-size: 16px;
                        color: #999;
                      }
                    }
                  }
                }
              }
            }
            .discount{
              color: $mainGlod;
              font-size: 14px;
              padding: 8px 9px;
              display: inline-block;
              border: 1px $mainGlod solid;
              margin: 20px 20px 20px 55px;
              position: relative;
              &:hover {
                cursor: pointer;
                .pop-box{
                  display: block;
                }
              }
              .pop-box {
                display: none;
                position: absolute;
                left: 0;
                top: 25px;
                z-index: 2;
                padding-top: 30px;
                .box-content {
                  background: #fff;
                  padding: 20px;
                  border-radius: 4px;
                  border: .5px $mainGlod solid;
                  min-height: 100px;
                  min-width: 500px;
                  position: relative;
                  &::before {
                    position: absolute;
                    content:'';
                    width: 0; height: 0;
                    border-bottom: 12px solid $mainGlod;
                    border-left: 8px solid transparent;
                    border-right: 8px solid transparent;
                    top: -13px;
                    left: 25px;
                  }
                  &::after {
                    position: absolute;
                    content:'';
                    width: 0; height: 0;
                    border-bottom: 11px solid #fff;
                    border-left: 7px solid transparent;
                    border-right: 7px solid transparent;
                    top: -10px;
                    left: 25.5px;
                  }
                  .title {
                    font-size: 14px;
                    color: #333;
                  }
                  .type{
                    display: flex;
                  }
                  .common {
                    flex: 1;
                  }
                }
              }
            }
          }
        }
      }
      .noproduct{
        width: 100%;
        text-align: center;
        padding: 200px 0;
      }
    }
    .trolley-footer {
      margin: 60px 0 100px;
      background-color: #F1F2F7;
      height: 80px;
      display: flex;
      font-size: 16px;
      align-items: center;
      color: #333;
      .item {
        flex: 1;
        .clearBtn {
          cursor: pointer;
        }
        &:nth-child(1) {
          padding-left: 40px;
        }
        &:nth-child(3) {
          span{
            color: $mainGlod;
          }
        }
        &:nth-child(4) {
          span {
            color: $cartRed;
            font-size:20px;
          }
        }
        &:nth-child(4) {
          flex: 3;
          padding-right: 15px;
          p {
            text-align: right;
            line-height: normal;
            span {
              color: $cartRed;
              font-size:20px;
            }
          }
        }
        &:nth-child(n-2) {
          line-height: 40px;
        }
        &:last-child {
          width: 100px;
          text-align: center;
          font-size: 20px;
          color: #fff;
          background-color:$cartRed;
          line-height: 80px;
        }
        >>> .el-checkbox {
          margin-right: 5px;
        }
      }
    }
  }
}
</style>
