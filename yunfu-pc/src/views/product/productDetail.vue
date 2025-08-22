<template>
  <div class="productDetailPage">
    <ProHead />
    <DetailSlot
      :productData="productDetailData"
      :skuData="productOption"
      :currentData="currentProductData"
      :similarProducts="similarProducts"
      :evaluateParam="evaluateParam"
      :productNumber="productNumber"
      :priceRules="priceRules"
      @selectSku="selectSku"
      @collect="collect"
      @reloadDetail="reloadDetail"
      @setNumber="val => { this.productNumber = val }"
      v-loading="pageloading"
    >
      <!--------------------------------------- 优惠信息部分组件插槽 ------------------------------------------------>
      <template v-slot:buyDiscount>
        <div v-if="[1,2,3,4,5,9].includes(currentProductData.activityType)" class="discount commonContainer">
          <img class="bc" src="static\image\activity\discount-bc.webp" />
          <!-- 秒杀、折扣信息 -->
          <div v-if="[2,3,4,5].includes(currentProductData.activityType)" class="miaosha discountLayout">
            <div class="left">
              <icon-svg v-if="[2,4].includes(currentProductData.activityType)"
                style="width: 115px; height: 20px;"
                icon-class="activity-type-miaosha"
              />
              <icon-svg v-if="[3,5].includes(currentProductData.activityType)"
                style="width: 115px; height: 20px;"
                icon-class="activity-type-zhekou"
              />
              <div class="numBox">
                <span>限量{{ limitData.total }}件</span>
                <el-progress
                  v-if="limitData.surplusNumber < limitData.total"
                  :color="'#C83732'"
                  :show-text="false"
                  :stroke-width="10"
                  :percentage="(parseInt(limitData.surplusNumber) / parseInt(limitData.total)) * 100"
                >
                </el-progress>
                <el-progress
                  v-else
                  :color="'#C83732'"
                  :show-text="false"
                  :stroke-width="10"
                  :percentage="100"
                >
                </el-progress>
              </div>
            </div>
            <div class="right" v-if="!ifEnable">
              <div class="rest">距离结束剩余</div>
              <div class="restTime">
                <span class="time">{{endTime | formatHours }}</span>
                <span class="betw">:</span>
                <span class="time">{{endTime | formatMinutes}}</span>
                <span class="betw">:</span>
                <span class="time">{{endTime | formatSeconds}}</span>
              </div>
            </div>
            <div class="right" v-else>
              <div class="rest">距离开始剩余</div>
              <div class="restTime">
                <span class="time">{{startTime | formatHours }}</span>
                <span class="betw">:</span>
                <span class="time">{{startTime | formatMinutes}}</span>
                <span class="betw">:</span>
                <span class="time">{{startTime | formatSeconds}}</span>
              </div>
            </div>
          </div>
          <!-- 拼团 -->
          <div class="pintuan" v-if="currentProductData.activityType===1">
            <icon-svg style="width: 115px; height: 20px;" icon-class="activity-type-pintuan" />
            <div class="total">{{ limitData.person }}人团</div>
          </div>
          <!-- 会员价 -->
          <div class="vip" v-if="currentProductData.activityType===9">
            <icon-svg style="width: 115px; height: 20px;" icon-class="activity-type-vip" />
          </div>
        </div>
        <div class="festival commonContainer" v-if="currentProductData.activityType===8">
          <img class="bc" src="static\image\activity\festival-bc.webp" />
          <div class="festival_content">
            <span>{{ `${productDetailData.productName || '特惠活动'}` }}</span>
            <span v-if="productDetailData.sceneFreeShipping === 1">包邮</span>
            <span v-if="productDetailData.sceneDiscount">{{ `${productDetailData.sceneDiscount}` }}折优惠</span>
          </div>
        </div>
      </template>
      <!---------------------------------------- 按钮组件插槽 ------------------------------------------------------------>
      <template v-slot:buyBtn>
        <!-- 已下架 -->
        <div class="btns" v-if="!productDetailData.shelveState">
          <button disabled class="btncom">已下架</button>
        </div>
        <!-- 通用购买 -->
        <div class="btns" v-else-if="currentProductData.activityType===0 && currentProductData.stockNumber!==0">
          <button class="btncom addCart" @click="clickAddCart">加入购物车</button>
          <button class="btncom buy" @click='buyGood'>立即购买</button>
        </div>
        <!-- 团购 -->
        <div class="btns" v-else-if="currentProductData.activityType === 1 && currentProductData.stockNumber !== 0">
          <button class="btncom addCart" @click="openGroup(1)" v-if="!ifEnable">我要开团</button>
          <button class="btncom" v-else>未开始</button>
          <button class="btncom buy" @click='buyGood(2)'>单独购买</button>
        </div>
        <!-- 秒杀、折扣、场景营销、会员价 -->
        <div class="btns" v-else-if="currentProductData.activityType in [2,3,4,5,8,9] && currentProductData.stockNumber!==0">
          <button class="btncom addCart" @click="clickAddCart">加入购物车</button>
          <button class="btncom buy" @click='buyGood'>立即购买</button>
        </div>
        <!-- 组合销售 -->
        <div class="btns" v-else-if="currentProductData.activityType === 6">
          <button class="btncom" @click="clickAddCart">组合销售加入购物车</button>
        </div>
        <!-- 会员价 -->
        <div class="btns" v-else-if="currentProductData.activityType === 9">
          <button class="btncom addCart" @click="clickAddCart">加入购物车</button>
          <button class="btncom buy" @click='buyGood'>立即购买</button>
        </div>
        <!-- 场景营销 -->
        <div class="btns" v-else-if="currentProductData.activityType === 8">
          <button class="btncom addCart" @click="clickAddCart">加入购物车</button>
          <button class="btncom buy" @click='buyGood'>立即购买</button>
        </div>
        <!-- 无库存 -->
        <div class="btns" v-else-if="currentProductData.stockNumber===0 && productDetailData.shelveState">
            <button class="btncom" disabled>已售空</button>
        </div>
        <div class="btns" v-else>
          <button class="btncom" disabled>该规格暂不参与活动</button>
        </div>
      </template>
      <!---------------------------------------- 营销活动额外内容插槽 ------------------------------------------------------------------->
      <template v-slot:extra>
        <!-- 组合套餐 -->
        <div class="combition" v-if="composeList.length > 0">
          <div class="title">组合套餐</div>
          <img class="bc" src="static\image\activity\extraBc.webp" />
          <el-tabs v-model="activeTable" type="card">
            <el-tab-pane
              v-for="(item, index) in composeList"
              :key="item.composeId"
              :label="item.composeName"
              :name="index.toString()"
            >
              <div class="toleft composeBtns" @click="composeMove('left')">
                <i class="el-icon-arrow-left"></i>
              </div>
              <div class="contentLeft">
                <div class="list" ref="composeList" :style="`left:${composePosition}px`">
                  <div class="item" ref="composeItem"
                    v-for="(i, idx) in item.composeProductInfoList"
                    :key="i.productId"
                  >
                    <icon-svg v-if="idx !== 0" style="margin: 0 40px; color: #CCC;" icon-class="detail-+++" />
                    <ComposeProduct
                      :productData="i"
                      :index="idx"
                      @getsku="getTheSku"
                      @jump="jumpDetail"
                    />
                  </div>
                </div>
              </div>
              <div class="toleft composeBtns" @click="composeMove('right')">
                <i class="el-icon-arrow-right"></i>
              </div>
              <icon-svg style="margin: 0 40px; color: #CCC;" icon-class="detail-===" />
              <div class="buyPro">
                <div class="sum">活动共{{ item.composeProductInfoList.length }}件商品</div>
                <div class="price">
                  <icon-svg style="width: 75px; height: 18px;" icon-class="compose-price" />
                  <span>{{ composePrice }}</span>
                </div>
                <div class="lights">
                  <div class="btn" @click="buyCompose">立即购买</div>
                </div>
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
        <!-- 拼团 -->
        <div class="pinList"
        v-if="currentProductData.activityType === 1 && productDetailData.collageOrders.length && ifEnable === 0">
          <div class="fightOrderTit">
            <span>这些人正在拼单</span>
          </div>
          <div class="pinListBox">
            <div class="pinItem"
            v-for="item in productDetailData.collageOrders"
            :key="item.collageId">
              <div class="Avatar">
                <img :src="item.headImage" alt="">
              </div>
              <div class="pinUserInfo">
                <span class="pUserName">{{item.name}}</span>
                <div class="rest">
                  <span class="notBad">还差<b>{{item.person}}</b>人拼成</span>
                  <span class="remainingTime">剩余：<b>{{item.time | formatTime}}</b></span>
                </div>
              </div>
              <div v-if="!item.lock" class="pinBtn" @click="goToGroupBuy(item.collageId)">和Ta拼</div>
              <div v-else class="pinBtn">已结束</div>
            </div>
          </div>
        </div>
      </template>
    </DetailSlot>
    <el-dialog
      title="提示"
      :visible.sync="groupBuyDialog"
      width="30%"
      :before-close="groupBuyClose"
    >
      <span>是否跟他拼团？</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="groupBuyClose">取 消</el-button>
        <el-button type="primary" @click="openGroup(0)">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {mapMutations} from 'vuex'
import Cookie from 'js-cookie'

import ProHead from '@/views/product/productHead.vue'
import DetailSlot from '@/views/product/productDetailSlot.vue'
import ComposeProduct from '@/views/product/components/composeProduct.vue'

import {
  addToCart,
  getCartList
} from '@/api/user/cart.js'
import {
  getShopIndex
} from '@/api/shop.js'
import {
  postCollect,
  cancelCollect
} from '@/api/user/user.js'
import {
  // getProducts,
  getProductsById,
  getComposePro
} from '@/api/product.js'

import {
  getBindList
} from '@/api/Activity/ActivityBind.js'
export default {
  name: 'productDetail',
  components: {
    ProHead,
    DetailSlot,
    ComposeProduct
  },
  inject: ['reload'],
  data () {
    return {
      pageloading: false,
      currentComp: 'detailData',
      productSizeData: {},
      productColor: {},
      productDetailData: {},
      activeName: 'Detail',
      productOption: {},
      evaluateParam: {
        productId: '',
        words: []
      },
      similarProducts: [],
      productPrice: '',
      originalPrice: '',
      // currentProductData: {
      //   productPrice: '',
      //   originalPrice: '',
      //   stockNumber: '',
      //   activityType: ''
      // },
      currentProductData: {},
      productNumber: 1,
      // 商品问答
      productAnswerList: [
        {
          id: 1
        }
      ],
      priceSpikezNum: 100,
      groupBuyDialog: false,
      setTime: null,
      setTime1: null,
      collageId: null,
      ifEnable: null,
      endTime: 0,
      startTime: 0,
      activeTable: '0',
      currentPro: {},
      limitData: {}, // 活动限制数据
      shopData: {},
      skuMap: null,
      skuNames: null,
      composeList: [],
      skusList: [],
      priceRules: [],
      composePosition: 0
    }
  },
  filters: {
    formatHours: function (value) {
      if (!value) {
        return `00`
      }
      let hours = Math.floor(value / (1000 * 60 * 60))
      if (hours < 10 && hours > 0) {
        return '0' + hours
      } else if (hours > 10) {
        return hours
      } else {
        return '00'
      }
    },
    formatMinutes: function (value) {
      if (!value) {
        return `00`
      }
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      if (minutes < 10 && minutes > 0) {
        return '0' + minutes
      } else if (minutes > 10) {
        return minutes
      } else {
        return '00'
      }
    },
    formatSeconds: function (value) {
      if (!value) {
        return `00`
      }
      let seconds = Math.round((value % (1000 * 60)) / 1000)
      if (seconds < 10 && seconds > 0) {
        return '0' + seconds
      } else if (seconds > 10) {
        return seconds
      } else {
        return '00'
      }
    },
    formatTime: function (value) {
      let hours = Math.floor(value / (1000 * 60 * 60))
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      let seconds = Math.round((value % (1000 * 60)) / 1000)
      if (hours < 10 && hours > 0) {
        hours = '0' + hours
      }
      if (minutes < 10 && minutes > 0) {
        minutes = '0' + minutes
      }
      if (seconds < 10 && seconds > 0) {
        seconds = '0' + seconds
      }
      return hours + ':' + minutes + ':' + seconds
    }
  },
  watch: {
    activeTable: {
      handler (nVal, oVal) {
        this.skusList = []
      }
    }
  },
  computed: {
    composePrice () {
      console.log('选中规格', this.skusList)
      const choosed = this.skusList.filter(r => r)
      if (this.composeList[this.activeTable].composeProductInfoList.length !== choosed.length) {
        return `请选择规格`
      }
      console.log(this.composeList[this.activeTable].composeType)
      let price, total
      switch (this.composeList[this.activeTable].composeType) {
        // 1直接定价
        case 1:
          price = this.composeList[this.activeTable].promote.toFixed(2)
          break
        // 2固定减价
        case 2:
          total = 0
          this.skusList.forEach(item => {
            total += parseFloat(item.price)
          })
          price = (total - this.composeList[this.activeTable].promote).toFixed(2)
          break
        // 3折扣
        case 3:
          total = 0
          this.skusList.forEach(item => {
            total += parseFloat(item.price)
          })
          price = (total * this.composeList[this.activeTable].promote).toFixed(2)
          break
        default:
          return 0
      }
      return `￥${price}`
    }
  },
  created () {
    this.currentPro = JSON.parse(this.$route.query.proData)
    this.getShopIndex()
    this.getProductInfo()
    this.getComposeData()
  },
  destroyed () {
    clearInterval(this.setTime)
    clearInterval(this.setTime1)
  },
  methods: {
    ...mapMutations({
      setCartNumber: 'SET_CARTNUMBER',
      setShoppingCart: 'SET_SHOPPINGCART',
      setCollectData: 'SET_COLLECTDATA'
    }),
    // 活动倒计时
    countDown () {
      clearInterval(this.setTime)
      this.setTime = setInterval(() => {
        if (this.endTime > 1000) {
          this.endTime -= 1000
        } else {
          if (this.currentProductData.activityType > 0) {
            this.endTime = 0
            clearInterval(this.setTime)
            alert('活动已结束')
            window.location.reload()
          }
        }
      }, 1000)
    },
    // 预热倒计时
    startCountDown () {
      clearInterval(this.setTime2)
      this.setTime = setInterval(() => {
        if (this.startTime > 1000) {
          this.startTime -= 1000
        } else {
          if (this.currentProductData.activityType > 0) {
            this.startTime = 0
            clearInterval(this.setTime2)
            // window.location.reload()
          }
        }
      }, 1000)
    },
    // 拼团倒计时
    countDown1 () {
      clearInterval(this.setTime1)
      this.setTime1 = setInterval(() => {
        this.productDetailData.collageOrders.map(item => {
          if (item.time > 1000) {
            item.time -= 1000
          } else {
            this.$set(item, 'lock', true)
            item.time = 0
          }
        })
      }, 1000)
    },
    // 获取店铺信息
    async getShopIndex () {
      const response = await getShopIndex({ shopId: this.currentPro.shopId })
      const res = response.data
      if (res.code === '200') {
        let data = {
          ifCollect: res.data.ifCollect,
          collectId: res.data.collectId,
          shopAdress: res.data.shopAdress,
          shopName: res.data.shopName,
          shopId: res.data.shopId,
          classifyNumber: res.data.classifyNumber,
          number: res.data.number,
          shopLogo: res.data.shopLogo
        }
        this.setCollectData(data)
      }
    },
    // 获取商品详情
    async getProductInfo () {
      this.pageloading = true
      const response = await getProductsById({
        shopId: this.currentPro.shopId,
        productId: this.currentPro.productId,
        skuId: this.currentPro.skuId,
        terminal: '3',
        system: '3',
        city: ''
      })
      const res = response.data
      if (res.code === '200') {
        this.productDetailData = res.data
        this.evaluateParam.productId = this.productDetailData.productId
        this.evaluateParam.words = this.productDetailData.words
        // this.evaluateParam.words = this.productDetailData.comments
        this.similarProducts = this.productDetailData.similarProducts
        this.limitData = {
          sales: this.productDetailData.number,
          person: this.productDetailData.person,
          surplusNumber: this.productDetailData.surplusNumber,
          total: this.productDetailData.total
        }
        if (res.data.priceId) { // 定价捆绑规则查询
          this.getRules(res.data.priceId)
        }
        this.skuMap = res.data.map
        this.skuNames = res.data.names
        // getProducts操作
        if (!res.data.names.length) {
          this.$message.error(res.message || '请求失败！')
        } else {
          let sku = []
          let onlyOne = true
          for (var key in this.skuMap) {
            if (this.skuMap[key].skuId === this.currentPro.skuId) {
              this.setCurrentProductData(this.skuMap[key])
              sku = key.split(',')
              onlyOne = false
            }
          }
          if (onlyOne) {
            this.setCurrentProductData(this.skuMap['attr_code_0_value_0'])
            sku = ['attr_code_0_value_0']
          }
          // 设置规格选中状态
          this.skuNames.forEach(j => {
            j.values.forEach(k => {
              if (sku.indexOf(k.valueCode) !== -1) {
                this.$set(k, 'selected', true)
              }
            })
          })
        }
        this.setActivityOption()
        // this.getProOption()
        if (this.productDetailData.collageOrders.length) {
          this.countDown1()
        }
        window.scrollTo(0, 0)
        this.pageloading = false
      } else {
        this.$message.error(res.message || '请求失败！')
      }
    },
    setCurrentProductData (data) {
      this.currentProductData.stockNumber = data.stockNumber
      this.currentProductData.price = data.price
      this.currentProductData.originalPrice = data.originalPrice
      this.currentProductData.skuId = data.skuId
      this.currentProductData.activityType = data.activityType
    },
    // 查询组合捆绑商品
    async getComposeData () {
      const response = await getComposePro({
        shopId: this.currentPro.shopId,
        productId: this.currentPro.productId,
        skuId: this.currentPro.skuId,
        terminal: '3',
        system: '3'
      })
      const res = response.data
      /**
       * composeType 1直接定价 2固定减价 3折扣
       * promote 元/折扣
       */
      this.composeList = res.data
    },
    // 查询定价捆绑
    async getRules (priceId) {
      const response = await getBindList({
        priceId,
        shopId: this.currentPro.shopId
      })
      const res = response.data
      this.priceRules = res.data
    },
    reloadDetail () {
      this.$router.go(0)
    },
    // 获取商品规格信息
    // async getProOption () {
    //   const response = await getProducts({
    //     shopId: this.currentPro.shopId,
    //     productId: this.currentPro.productId
    //   })
    //   const res = response.data
    //   if (res.code === '200') {
    //     this.productOption = res.data
    //     this.ifEnable = res.data.skuTool.ifEnable
    //     let nowTime = Date.now()
    //     this.endTime = new Date(res.data.skuTool.endTime).getTime() - nowTime
    //     this.productSizeData = res.data.names[0]
    //     if (this.endTime > 1000) {
    //       this.countDown()
    //     }
    //   } else {
    //     this.$message(res.message)
    //   }
    // },
    // 设置活动相关信息
    setActivityOption () {
      /*
      this.ifEnable = res.data.skuTool.ifEnable
      let nowTime = Date.now()
      this.endTime = new Date(res.data.skuTool.endTime).getTime() - nowTime
      this.productSizeData = res.data.names[0]
      if (this.endTime > 1000) {
        this.countDown()
      } */
      for (var i in this.skuMap) {
        if (this.skuMap[i].skuId === this.currentPro.skuId) {
          this.productOption = this.skuMap[i]
          this.ifEnable = this.skuMap[i].ifEnable
          let nowTime = Date.now()
          this.endTime = new Date(this.skuMap[i].endTime).getTime() - nowTime
          this.startTime = new Date(this.skuMap[i].startTime).getTime() - nowTime
          this.productSizeData = this.skuNames[0]
          if (this.productOption.activityType > 0 && this.endTime > 1000 && !this.ifEnable) {
            console.log('countDown from setActivityOption')
            this.countDown()
          } else {
            this.startCountDown()
          }
          break
        }
      }
    },
    // 加入购物车
    async clickAddCart () {
      if (this.currentProductData.stockNumber > 0) {
        const response = await addToCart({
          skuId: this.currentProductData.skuId,
          number: this.productNumber
        })
        const res = response.data
        if (res.code === '200') {
          this.$message.success('添加成功')
          this.getTrolleyList()
        } else {
          this.$message(res.message)
        }
      } else {
        this.$message.warning('商品库存不足')
      }
    },
    // 购物车列表
    async getTrolleyList () {
      const response = await getCartList()
      const res = response.data
      let cartNumber = 0
      if (res.data.length) {
        this.setShoppingCart(res.data)
        res.data.forEach(j => {
          cartNumber = cartNumber + j.skus.length
        })
      }
      this.setCartNumber(cartNumber)
    },
    clickSwitchTab (type) {
      this.currentComp = type
    },
    // 购买
    buyGood (type) {
      if (this.currentProductData.stockNumber > 0) {
        if (!Cookie.get('token')) {
          this.$message.warning('请先登录')
          this.$store.commit('resetVuex')
          // 登录弹框
          this.$store.commit('IS_LOGIN', false) // 清除顶部个人中心数据
          this.$store.commit('SHOW_LOGIN') // 调用登录弹框
        } else {
          let shopsData = [
            {
              shopId: this.productDetailData.shopId,
              skus: [
                {
                  // skuId: skuId || this.getSkuId(),
                  skuId: this.currentProductData.skuId,
                  number: this.productNumber || 1
                }
              ]
            }
          ]
          let paramsType = null
          if (this.currentProductData.activityType === 0 || (this.currentProductData.activityType !== 0 && this.ifEnable === 1)) {
            paramsType = 0
          } else {
            if (type && type === 2) {
              paramsType = 0
            } else {
              paramsType = this.currentProductData.activityType
            }
          }
          this.$router.push({
            path: '/placeOrder',
            query: {
              type: 1,
              ifWork: 0,
              shops: JSON.stringify(shopsData),
              activityType: paramsType
            }})
        }
      } else {
        this.$message.warning('商品库存不足')
      }
    },
    jumpDetail (query) {
      this.currentPro.productId = query.productId
      this.currentPro.skuId = query.skuId
      this.getProductInfo()
      this.getComposeData()
    },
    // 获取组合捆绑skuId
    getTheSku (query) {
      console.log(query)
      const sku = {
        number: 1,
        price: query.item.price,
        skuId: query.item.skuId
      }
      // this.skusList[query.index] = sku
      if (this.skusList.length !== this.composeList[this.activeTable].composeProductInfoList.length) {
        this.skusList = new Array(this.composeList[this.activeTable].composeProductInfoList.length)
      }
      this.skusList.splice(query.index, 1, sku)
      console.log(this.skusList)
    },
    // 组合捆绑购买
    async buyCompose () {
      if (!Cookie.get('token')) {
        this.$message.warning('请先登录')
        this.$store.commit('resetVuex')
        // 登录弹框
        this.$store.commit('IS_LOGIN', false) // 清除顶部个人中心数据
        this.$store.commit('SHOW_LOGIN') // 调用登录弹框
        return
      }
      if (this.composeList[this.activeTable].composeProductInfoList.length !== this.skusList.length) {
        return this.$message.error('请选择组合商品规格')
      }
      const shops = [{
        shopId: this.currentPro.shopId,
        composeId: this.composeList[this.activeTable].composeId,
        skus: this.skusList
      }]
      console.log(shops)
      this.$router.push({
        name: 'placeOrder',
        query: {
          type: 1,
          shops: JSON.stringify(shops),
          ifWork: 0,
          activityType: 7
        }
      })
    },
    // 拼团
    openGroup (x) {
      if (this.currentProductData.stockNumber > 0) {
        if (!Cookie.get('token')) {
          this.$message.warning('请先登录')
          this.$store.commit('resetVuex')
          // 登录弹框
          this.$store.commit('IS_LOGIN', false) // 清除顶部个人中心数据
          this.$store.commit('SHOW_LOGIN') // 调用登录弹框
        } else {
          // if (this.productOption.names.length === 0) {
          //   var skuId = this.productOption.names[0].skuId
          // }
          const o = this.productOption
          let worksData = {
            shopId: o.shopId,
            number: this.productNumber,
            // skuId: skuId || this.getSkuId(),
            skuId: this.currentProductData.skuId,
            productId: this.productDetailData.productId,
            type: x ? 1 : 2
          }
          if (x) {
            worksData.shopGroupWorkId = this.productOption.shopGroupWorkId
          } else {
            worksData.shopGroupWorkId = this.productOption.shopGroupWorkId
            worksData.collageId = this.collageId
          }
          this.$router.push({path: '/placeOrder',
            query: {
              works: JSON.stringify(worksData),
              activityType: this.currentProductData.activityType
            }})
        }
      } else {
        this.$message.warning('商品库存不足')
      }
    },
    // 选择规格sku
    selectSku (o, list) {
      const temp = this.productDetailData.names
      this.productNumber = 1
      if (list.values.length > 1) {
        temp.forEach(j => {
          if (j.nameCode === list.nameCode) {
            j.values.forEach(k => {
              this.$set(k, 'selected', k.valueCode === o.valueCode)
            })
          }
        })
      }
      let selectOption = []
      temp.forEach(j => {
        j.values.forEach(k => {
          if (k.selected) {
            selectOption.push(k.valueCode)
          }
        })
      })
      let select = selectOption.toString()
      for (let key in this.skuMap) {
        if (key === select) {
          this.currentProductData = this.skuMap[key]
          this.productOption = this.skuMap[key]
          this.ifEnable = this.skuMap[key].ifEnable
          let nowTime = Date.now()
          this.endTime = new Date(this.skuMap[key].endTime).getTime() - nowTime
          this.startTime = new Date(this.skuMap[key].startTime).getTime() - nowTime
          this.productSizeData = this.skuNames[0]
          if (this.productOption.activityType > 0 && this.endTime > 1000 && !this.ifEnable) {
            this.countDown()
          } else {
            this.startCountDown()
          }
          break
        }
      }
    },
    // 获取skuId
    // getSkuId () {
    //   const temp = this.productOption
    //   let id = ''
    //   temp.names.forEach(j => {
    //     j.values.forEach(k => {
    //       if (k.selected) id = ((id && `${id},`) || '') + k.valueCode
    //     })
    //   })
    //   return temp.map[id].skuId
    // },
    // 拼团确认
    goToGroupBuy (id) {
      this.collageId = id
      this.groupBuyDialog = true
    },
    // 取消拼团
    groupBuyClose () {
      this.collageId = null
      this.groupBuyDialog = false
    },
    // // 轮播图
    // thumbsClick (index) {
    //   this.swiperThumbs.slideTo(index, 300, false)
    //   this.swiperTop.slideTo(index, 300, false)
    // },
    // 收藏
    collect () {
      if (this.productDetailData.ifCollect === 0) {
        this.collectItem()
      } else {
        this.unCollect()
      }
    },
    // 收藏商品、店铺
    async collectItem () {
      const response = await postCollect({ productId: this.productDetailData.productId })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('收藏成功')
        this.productDetailData.ifCollect = 1
      }
    },
    // 取消收藏
    async unCollect () {
      const response = await cancelCollect({ ids: [this.productDetailData.collectId] })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('取消成功')
        this.productDetailData.ifCollect = 0
      } else {
        this.$message.error(res.message)
      }
    },
    // 移动组合捆绑内容
    composeMove (direction) {
      const long = this.$refs.composeItem.length * 180 + (this.$refs.composeItem.length - 1) * (16 + 40 * 2)
      const visual = long - 750
      let num = 0
      if (direction === 'left') {
        if (this.composePosition >= 0) { return }
        let timer = setInterval(() => {
          num += 10
          if (num >= 151) {
            clearTimeout(timer)
            return
          }
          // 移动商品
          this.composePosition += 10
        }, 1)
      }
      if (direction === 'right') {
        if (this.composePosition <= -visual) { return }
        let timer = setInterval(() => {
          num += 10
          if (num >= 151) {
            clearTimeout(timer)
            return
          }
          // 移动商品
          this.composePosition = this.composePosition < -visual ? -visual : this.composePosition - 10
        }, 1)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
$lightGlod: #FFEBC4;
.productDetailPage{
  background-color: #F5F5F5;
  >>>.commonContainer{
    margin: 15px 0;
    position: relative;
    .bc{
      width: 100%;
      img{
        width: 100%;
        height: 100%;
      }
    }
  }
  >>>.discount{
    .discountLayout{
      width: 90%;
      height: 50px;
      padding: 0 22px;
      position: absolute;
      top: 18px;
      display: flex;
      justify-content: space-between;
      font-family: Microsoft YaHei;
      .left{
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        .svg-icon{
          margin-left: -15px;
        }
        .numBox{
          width: 100%;
          height: 20px;
          display: flex;
          align-items: center;
          span{
            color: $lightGlod;
          }
          .el-progress{
            display: inline-block;
            width: 190px;
            margin: 0 10px;
            .el-progress-bar__outer,.el-progress-bar__inner{
              border-radius: 0;
            }
          }
        }
      }
      .right{
        width: 120px;
        height: 50px;
        .rest{
          font-size: 12px;
          color: $lightGlod;
          text-align: center;
        }
        .restTime{
          margin-top: 10px;
          font-size: 12px;
          display: flex;
          justify-content: space-around;
          align-items: center;
          .time{
            padding: 5px;
            color: $lightGlod;
            background-color: #999;
          }
          .betw{
            color: #999;
            font-size: 24px;
            padding-bottom: 5px;
          }
        }
      }
    }
    .pintuan{
      width: 100%;
      position: absolute;
      top: 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      .svg-icon{
        margin-left: 20px;
      }
      .total{
        width: 100px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        margin-right: 20px;
        color: #FFF;
        background-color: #C83732;
        border: 1px solid rgba(0, 0, 0, 0);
      }
    }
    .vip{
      width: 100%;
      position: absolute;
      top: 35px;
      margin-left: 20px;
    }
  }
  >>>.festival{
    $festival_height: 50px;
    $content_margin_top_bottom: 10px;
    height: $festival_height;
    .bc{
      height: $festival_height;
    }
    .festival_content{
      position: absolute;
      top: 0;
      margin: $content_margin_top_bottom 18px;
      padding: 0 15px 0 8px;
      line-height: $festival_height - ($content_margin_top_bottom * 2);
      color: #C83732;
      background-color: #FFD4D8;
      border-radius: 8px 30px 30px 0px;
    }
  }
  .btns{
    margin-top: 40px;
    .btncom{
      width: 100%;
      height: 50px;
      padding: 0;
      cursor: pointer;
      border: 1px solid #333333;
    }
    .addCart{
      color: $mainGlod;
      background: #333333;
    }
    .buy{
      margin-top: 15px;
      background-color: #FFFFFF;
      border: 1px solid #333333;
    }
  }
  .combition{
    max-width: 1250px;
    background-color: #FFFFFF;
    margin: 10px 0;
    font-family: Microsoft YaHei;
    padding: 15px 20px;
    position: relative;
    .title{
      padding-bottom: 15px;
      font-size: 18px;
      color: #333333;
      border-bottom: 1px solid #F3F4F5;
    }
    .bc{
      margin-top: 60px;
      width: 100%;
    }
    >>>.el-tabs{
      position: absolute;
      top: 60px;
      .el-tabs__header{
        border: none;
      }
      .el-tabs__nav{
        width: 100%;
        max-width: 1210px;
        border: none;
        border-radius: 0;
        overflow-x: auto;
        &::-webkit-scrollbar {
          height: 8px;
        }
        &::-webkit-scrollbar-thumb {
          border-radius: 3px;
          -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.1);
          background-color: #e3e3e3;
        }
        .el-tabs__item{
          // min-width: 100px;
          height: 40px;
          line-height: 40px;
          margin-right: 8px;
          padding: 0 18px;
          text-align: center;
          font-size: 14px;
          color: #333;
          background-color: #F5F5F5;
          border: none;
        }
        .is-active{
          color: #FFF;
          background-color: $mainGlod;
        }
      }
      .el-tab-pane{
        width: 1210px;
        height: 250px;
        display: flex;
        justify-content: center;
        align-items: center;
      }
    }
    .contentLeft{
      max-width: 750px;
      overflow: hidden;
      display: flex;
      .list{
        display: flex;
        justify-content: space-around;
        position: relative;
        .item{
          display: inline-flex;
          align-items: center;
        }
      }
    }
    .composeBtns{
      width: 30px;
      height: 30px;
      line-height: 30px;
      text-align: center;
      background-color: #FFF;
      cursor: pointer;
    }
    .buyPro{
      .sum{
        text-align: center;
        color: $lightGlod;
        font-weight: bold;
      }
      .price{
        margin: 20px 0 30px;
        text-align: center;
        color: $lightGlod;
        font-weight: bold;
        span{
          font-size: 18px;
        }
      }
      .btn{
        width: 200px;
        height: 50px;
        line-height: 50px;
        text-align: center;
        color: #333333;
        background: linear-gradient(272deg, $lightGlod 0%, $mainGlod 100%);
        cursor: pointer;
      }
      .lights{
        position: relative;
        overflow: hidden;
        cursor: pointer;
      }
      .lights:before {
        content:"";
        position: absolute;
        left: -10px; /**第一个数字参数控制扫光速度，数字越大越慢**/
        top: 10px;
        width: 200px;
        height: 8px; /**光标的宽度，可根据实际调整**/
        background-color: rgba(255, 255 ,255,.5);
        transform: rotate(-45deg);
        animation: scanLights 2s linear 1s infinite alternate;/**第一个数字参数控制扫光速度，数字越大越慢**/
      }
      @keyframes scanLights {
        0% { left: -100px; top: 0; }
        to { left: 150px; top: 0px; }
      }
    }
  }
  .pinList{
    width: 100%;
    height: 280px;
    margin-bottom: 30px;
    background-color: #FFF;
    .fightOrderTit{
      height: 50px;
      line-height: 50px;
      padding-left: 20px;
      font-size: 18px;
      font-family: Microsoft YaHei;
      font-weight: bold;
      color: #333333;
      border-bottom: 2px solid #F3F4F5;
    }
    .pinListBox {
      height: 185px;
      padding: 20px 15px;
      overflow-x: auto;
      white-space: nowrap;
      // display: flex;
      .pinItem {
        width: 180px;
        height: 100%;
        margin: 0 60px;
        display: inline-flex;
        flex-direction: column;
        align-items: center;
        .Avatar {
          width: 70px;
          height: 70px;
          border-radius: 50%;
          overflow: hidden;
          img {
            width: 100%;
            height: 100%;
          }
        }
        .pinUserInfo {
          width: 100%;
          span {
            display: block;
            font-size: 14px;
            b {
              font-weight: normal;
              color: #C83732;
            }
          }
          .pUserName{
            margin: 10px 0;
            text-align: center;
          }
          .rest{
            display: flex;
            justify-content: space-between;
          }
        }
        .pinBtn {
          width: 100%;
          height: 40px;
          margin-top: 15px;
          border: 1px solid $mainGlod;
          text-align: center;
          line-height: 40px;
          cursor: pointer;
          font-size: 16px;
          color: $mainGlod;
        }
      }
    }
  }
}
.pinListBox::-webkit-scrollbar {
  height: 8px;
  background-color: #F5F5F5;
}
/*定义滚动条轨道 内阴影+圆角*/
.pinListBox::-webkit-scrollbar-track {
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.2);
  border-radius: 3px;
  background-color: #FFFFFF;
}
/*定义滑块 内阴影+圆角*/
.pinListBox::-webkit-scrollbar-thumb {
  border-radius: 3px;
  -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.1);
  background-color: #e3e3e3;
}
</style>
