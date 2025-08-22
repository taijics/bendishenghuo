<template>
    <div class="placeOrder warp">
      <div class="poAddressList">
        <div class="poAddListTit">
          <span>请选择收货地址</span>
          <span @click="newAddressFn">新增地址</span>
        </div>
        <div class="poAddListBox"  v-if="addressData.length === 0">
          <span>暂无收货信息</span>
        </div>
        <div class="poAddListBox"  v-if="addressData.length !== 0">
          <div class="title">收货人信息：</div>
          <div class="addressItem">
            <div class="addressInfo">
              <span class="userName">{{ addressObj.receiveName }}</span>
              <span class="userAddress">{{ addressObj.receiveAdress }} {{ addressObj.address }}</span>
              <span class="userPhone">{{ addressObj.receivePhone }}</span>
            </div>
            <span class="changeAddress" @click="showChangeAddress">
              <icon-svg style="font-size: 16px;" icon-class="exchange" />
              切换
            </span>
          </div>
        </div>
      </div>
      <!-- 订单商品信息 -->
      <div class="shoplist">
        <div class="shopTitle">请确认订单信息</div>
        <ShopOrder v-for="item in this.settlement.shops"
          :key="item.shopId"
          :type="state"
          :shopsData="item"
        >
          <template slot="coupon">
            <div class="couponContainer">
              <div class="couponItem"
                v-for="(coupon, index) of item.shopCoupons"
                :key="index"
              >
                <CouponBox
                  :type="'商家券'"
                  :couponItem="coupon"
                  :isSelect="coupon.checked"
                  @couponSelect="couponSelect"
                />
              </div>
            </div>
          </template>
        </ShopOrder>
      </div>
      <!-- 优惠券信息 -->
      <!-- 平台券 -->
      <div class="couponContainer" v-if="this.settlement.coupons.length">
        <p>平台券</p>
        <div class="couponItem"
          v-for="(item, index) of this.settlement.coupons"
          :key="index"
        >
          <CouponBox
            :type="'平台券'"
            :couponItem="item"
            :isSelect="item.checked"
            @couponSelect="couponSelect"
          />
        </div>
      </div>
      <div class="payBox">
        <div class="payTit">选择支付方式</div>
        <div class="payList">
<!--            <span :class="{payActive: payType === 'alipay'}" @click="selectPay(type = 'alipay')">-->
<!--              <i class="iconfont">&#xe627;</i>-->
<!--              <b class="iconfont">&#xe612;</b>-->
<!--              支付宝支付-->
<!--            </span>-->
          <span class="typeBox" :class="{payActive: payType === 'weChat'}" @click="selectPay(payType = 'weChat')">
            <i class="iconfont">&#xe686;</i>
            <b class="iconfont">&#xe612;</b>
            微信支付
          </span>
        </div>
      </div>
      <div class="placeOrderBtn">
        <div class="payInfo">
          <span>运费：+¥{{(distributionPrice || 0).toFixed(2)}}</span>
          <span>平台优惠：-￥{{(couponAmount).toFixed(2)}}</span>
          <span>商家优惠：-￥{{(couponShopAmount).toFixed(2)}}</span>
          <span>需付款：<b>￥{{totalPrice.toFixed(2)}}</b></span>
        </div>
        <el-button v-if="disabledButton" class="submitOrder unDisButton" @click="clickTips">提交订单</el-button>
        <el-button v-else class="submitOrder" @click="clickPayOrder" :loading="btnLoading">提交订单</el-button>
      </div>
      <!-- 付款提示 -->
      <el-dialog
        title="请在1小时内完成付款，否则订单会被系统取消"
        :visible.sync="paymentDialog"
        width="30%">
        <div class="payment">
          <div class="paymentBox">
            <div class="successBox">
              <span>支付成功请点击</span>
              <el-button type="primary" plain>已完成付款</el-button>
            </div>
            <div class="errorBox">
              <span>遇到问题请点击</span>
              <el-button type="primary" v-throttle>重新付款</el-button>
            </div>
          </div>
          <div class="paymentInfo">
            <p>注：重新付款前，请关闭之前的付款页面</p>
            <p>如有疑问或需要帮助，请进入<b>帮助中心</b>或联系<b>在线客服</b></p>
          </div>
        </div>
      </el-dialog>
      <!-- 微信支付 -->
      <el-dialog
        class="weChat"
        title="微信支付"
        :visible.sync="weChatDialog"
        :before-close="handleClose"
        width="500px">
          <div class="qCode">
            <div class="wechatTitle">
              <div class="tips">
                <p>请使用微信扫一扫</p>
                <p>扫描二维码支付</p>
              </div>
              <div>￥{{ payInfo.money }}</div>
            </div>
            <img class="code" :src="payInfo.url" alt="">
          </div>
      </el-dialog>
      <!-- 新建收货地址 -->
      <el-dialog
        :title="addressDialogTitle"
        :visible.sync="newAddressDialog"
        width="630px">
        <AddAddress @hideAddDialog="hideAddDialog" @cancelAdd="closeAdd" />
      </el-dialog>
      <!-- 切换地址 -->
      <el-dialog
        title="选择收货地址"
        :visible.sync="changeAddressDialog"
        :close-on-click-modal="false"
        :destroy-on-close="false"
      >
        <ul class="addressTable">
          <li
            class="addressListItem"
            v-for="(item, index) of addressData"
            :key="index"
            :class="{addressActive: curAdd === index}"
            @click="curAdd = index"
          >
          <div class="top com">
            <div class="left">姓名：
              <span>{{ item.receiveName }}</span> <span>{{ item.receivePhone }}</span>
            </div>
            <div
              class="setDef"
              :class="{colorActive: item.ifDefault}"
              @click="changeAddress(item)"
            >编辑</div>
          </div>
          <div class="bottom com">
            <div class="left">
              地址：<span>{{ item.receiveAdress }} {{ item.address }}</span>
              <span v-if="item.ifDefault" class="defTip">默认地址</span>
            </div>
            <div class="setDef"
              v-if="!item.ifDefault"
              @click="setDefAddress(item)"
            >设为默认地址</div>
          </div>
          </li>
        </ul>
        <span slot="footer" class="dialog-footer">
          <el-button class="combtns" @click="changeAddressDialog = false" v-throttle>取消</el-button>
          <el-button class="combtns btnBlack" @click="setChangeAddress" v-throttle>确认</el-button>
        </span>
      </el-dialog>
      <!-- 支付失败 -->
      <el-dialog
        title="温馨提示"
        :visible.sync="errorDialog"
        width="300px">
        <div class="errorDialog">
          <div class="errorTit">
            <span class="iconfont">&#xe620;</span>
            <p>您的订单支付失败</p>
          </div>
          <span slot="footer" class="dialog-footer">
            <el-button class="btns" @click="toOrder" v-throttle>查看订单</el-button>
            <el-button class="btns pay" type="primary" @click="clickPayOrder" v-throttle>重新支付</el-button>
          </span>
        </div>
      </el-dialog>
    </div>
</template>

<script>
import { TextToCode } from 'element-china-area-data'
import { mapGetters, mapMutations } from 'vuex'

import AddAddress from '@/components/orderInfo/addAddress'
import ShopOrder from '@/views/placeOrder/components/shopOrder.vue'
import CouponBox from '@/views/placeOrder/components/couponBox.vue'
import {
  getAllAddressList,
  addAddress,
  updateAddress
} from '@/api/user/address.js'
import {
  orderSubmit,
  getSettlement,
  getGroupSettle,
  checkOrderResult
} from '@/api/user/order.js'
import {
  getCartList,
  deleteCartItem
} from '@/api/user/cart.js'
export default {
  name: 'placeOrder',
  components: {
    AddAddress,
    ShopOrder,
    CouponBox
  },
  data () {
    return {
      addressData: [],
      addressDialogTitle: '新建收货地址',
      newAddressDialog: false,
      paymentDialog: false,
      weChatDialog: false,
      payType: '',
      errorDialog: false,
      promotionInfoDTO: {
        couponId: 0,
        ifAdd: 1,
        reduceMoney: 0
      },
      settlement: {
        coupons: [],
        shops: []
      },
      totalPrice: 0,
      shopIndex: 0, // 当前操作的优惠券所在店铺的索引
      showDiscount: false,
      currentCoupon: null,
      currentShopCoupon: null,
      currentDiscount: 0,
      discountTotal: 0, // 优惠总额
      couponCurrent: {},
      shopCouponCurrent: {},
      submitData: {
        receiveId: '',
        couponId: '',
        price: '',
        remark: '',
        shops: []
      },
      curAdd: 0,
      currentAddressId: '',
      addressObj: {
        receiveName: '',
        receivePhone: '',
        receiveAdress: '',
        address: ''
      }, // 地址展示信息
      remarksInfo: '',
      payInfo: {},
      chatTimer: '',
      activityType: 0,
      workData: {},
      paramShops: [],
      type: null,
      ifWork: 0,
      state: 0,
      distributionPrice: 0, // 总运费
      changeAddressDialog: false,
      btnLoading: false,
      checkedPlatformCoupon: undefined, // 选中的平台券
      selectShopCoupon: [], // 商家券
      couponAmount: 0, // 平台券总折扣
      couponShopAmount: 0, // 商家券总折扣
      hasCheck: 0, // 含有不可叠加券： 1.平台券  2.商家券
      disabledButton: false, // 获地址是否符合商家配送范围内
    }
  },
  created () {
    if (this.$route.query.works) {
      this.workData = JSON.parse(this.$route.query.works)
    }
    if (this.$route.query.type) {
      this.type = this.$route.query.type
    }
    if (this.$route.query.ifWork !== undefined) {
      this.ifWork = parseInt(this.$route.query.ifWork)
    }
    if (this.$route.query.activityType !== undefined) {
      this.activityType = parseInt(this.$route.query.activityType)
    }
    if (this.$route.query.shops) {
      this.paramShops = JSON.parse(this.$route.query.shops)
    }
    if (this.paramShops.shopDiscountId) {
      this.state = 3
    }
    if (this.paramShops.shopSeckillId) {
      this.state = 2
    }
    if (this.workData.shopGroupWorkId) {
      this.state = 1
    }
  },
  mounted () {
    // 获取地址列表
    this.getAddressList()
    if (this.$route.query.type) {
      this.getSetProList()
    } else {
      this.getWorkSettlement()
    }
  },
  computed: {
    ...mapGetters([
      'newAddress' // 新增修改收货地址
    ]),
    shopIds () {
      return this.settlement.shops.map(item => {
        return item.shopId
      })
    }
  },
  methods: {
    ...mapMutations({
      seNewAddress: 'SET_NEWADDRESS', // 新增修改收货地址
      setAreacode: 'SET_AREACODE', // 新增修改收货地址
      setCartNumber: 'SET_CARTNUMBER', // 购物车数量
      setShoppingCart: 'SET_SHOPPINGCART' // 购物车
    }),
    // 获取地址列表
    async getAddressList () {
      const response = await getAllAddressList({
        page: 1,
        pageSize: 100
      })
      const res = response.data
      if (res.code === '200') {
        this.addressData = res.data.list
        if (this.addressData.length === 1) { // 只有1条，默认为收货地址
          this.currentAddressId = this.addressData[0].receiveId
          this.setPageAddressObj(this.addressData[0])
          return
        }
        this.addressData.forEach((item, index) => {
          if (item.ifDefault) { // 如果有默认地址时
            this.currentAddressId = item.receiveId
            this.setPageAddressObj(item)
          } else if (index === 0) { // 没有则优先选择第一个地址
            this.currentAddressId = item.receiveId
            this.setPageAddressObj(item)
          }
        })
      } else {
        this.$message.warning(res.message)
      }
    },
    // 设置收货渲染数据
    setPageAddressObj (item) {
      this.addressObj = {
        receiveName: item.receiveName,
        receivePhone: item.receivePhone,
        receiveAdress: item.receiveAdress,
        address: item.address
      }
    },
    // 新增地址
    async hideAddDialog () {
      this.newAddressDialog = false
      const response = await addAddress({
        receiveName: this.newAddress.receiveName,
        receivePhone: this.newAddress.receivePhone,
        receiveAdress: this.newAddress.receiveAdress,
        address: this.newAddress.address,
        label: '',
        ifDefault: this.newAddress.ifDefault ? 1 : 0
      })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '地址添加成功',
          type: 'success'
        })
        this.page = 1
        this.addressData = []
        this.setAreacode([])
        this.getAddressList()
        if (this.newAddress.ifDefault) {
          if (this.$route.query.type) {
            this.getSetProList()
          } else {
            this.getWorkSettlement()
          }
        }
      } else {
        this.$message.error(res.message)
      }
    },
    // 取消新增地址
    closeAdd () {
      this.newAddressDialog = false
    },
    // 新增地址
    newAddressFn () {
      let obj = {
        receiveName: '',
        receivePhone: '',
        receiveAdress: '',
        address: '',
        label: '',
        ifDefault: false
      }
      this.setAreacode([])
      this.seNewAddress(obj)
      this.addressDialogTitle = '新增收货地址'
      this.newAddressDialog = true
    },
    showChangeAddress () {
      this.changeAddressDialog = true
    },
    // 修改收货地址
    setChangeAddress () {
      let item = this.addressData[this.curAdd]
      this.currentAddressId = item.receiveId
      this.addressObj = {
        receiveName: item.receiveName,
        receivePhone: item.receivePhone,
        receiveAdress: item.receiveAdress,
        address: item.address
      }
      this.changeAddressDialog = false
      if (this.$route.query.type) {
        this.getSetProList()
      } else {
        this.getWorkSettlement()
      }
    },
    // 修改地址信息
    changeAddress (item) {
      this.changeAddressDialog = false
      let addressData = item.receiveAdress.split('-')
      let areaData = []
      areaData.push(TextToCode[addressData[0]].code)
      areaData.push(TextToCode[addressData[0]][addressData[1]].code)
      areaData.push(TextToCode[addressData[0]][addressData[1]][addressData[2]].code)
      let currentItem = JSON.parse(JSON.stringify(item))
      this.seNewAddress(currentItem)
      this.setAreacode(areaData)
      this.addressDialogTitle = '修改收货地址'
      this.newAddressDialog = true
    },
    // 设置默认地址
    setDefAddress (item) {
      item.ifDefault = 1
      this.seNewAddress(item)
      this.updateAddressFun()
    },
    // 更新地址
    async updateAddressFun () {
      this.changeAddressDialog = false
      const response = await updateAddress({
        receiveId: this.newAddress.receiveId,
        receiveName: this.newAddress.receiveName,
        receivePhone: this.newAddress.receivePhone,
        receiveAdress: this.newAddress.receiveAdress,
        address: this.newAddress.address,
        label: '',
        ifDefault: this.newAddress.ifDefault.toString()
      })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '地址修改成功',
          type: 'success'
        })
        this.page = 1
        this.addressData = []
        this.setAreacode([])
        this.getAddressList()
      } else {
        this.$message.error(res.message)
      }
    },
    // 拼团商品结算查询
    async getWorkSettlement () {
      this.workData.receiveId = this.currentAddressId
      const rLoading = this.openLoading()
      this.distributionPrice = 0

      const response = await getGroupSettle(this.workData)
      const res = response.data
      if (res.code === '200') {
        this.successBackSettlement(res)
        rLoading.close()
      } else {
        this.$message.warning(res.message)
      }
    },
    // 查询结算产品列表
    async getSetProList () {
      const rLoading = this.openLoading()
      this.distributionPrice = 0
      const response = await getSettlement({
        type: this.type,
        shops: this.paramShops,
        ifWork: this.ifWork,
        receiveId: this.currentAddressId
      })
      const res = response.data
      if (res.code === '200') {
        this.successBackSettlement(res)
        rLoading.close()
      } else {
        this.$message.warning(res.message)
        this.$router.back()
      }
    },
    // 结算查询成功回调
    successBackSettlement (res) {
      this.disabledButton = false
      this.settlement = res.data
      this.currentAddressId = res.data.receive.receiveId || ''
      this.settlement.shops = res.data.shops || [] // 订单商家信息
      this.settlement.coupons.forEach((item, index) => {
        item.index = index
        item.type = 1
        item.discountAmount = 0
      })
      this.settlement.shops.forEach(item => {
        // 处理收获地址是否符合商家配送范围内
        if (item.receiveNotMatch) {
           this.disabledButton = item.receiveNotMatch
        }
        if (this.disabledButton) {
          this.clickTips()
        }
        // 处理商家券
        item.shopCoupons = item.shopCoupons.map((i, index) => {
          i.index = index
          i.type = 2 // type 1平台券 2商家券
          i.uniWebId = `${item.shopId}+${index}` // 创建一个前端单方面的唯一值，处理选中状态
          i.shopId = item.shopId // 方便后续确定优惠券
          i.discountAmount = 0
          return i
        })
        item.totalAfterDiscount = item.total
        this.distributionPrice += Number(item.distribution.distributionPrice) || 0
      })
      this.getTotal()
    },
    // 选择优惠券
    couponSelect (val) {
      if (val.type === 1) {
        this.couponItemTap(val)
      } else {
        this.shopCouponItemTap(val)
      }
    },
    // 商家券 本方法参考uniapp代码的同名方法
    shopCouponItemTap (coupon) {
      const index = coupon.index
      this.shopIndex = this.shopIds.indexOf(coupon.shopId)

      // 取消选择优惠券
      if (coupon.checked) {
        coupon.checked = false
        coupon.discountAmount = 0
        this.settlement.shops[this.shopIndex].totalAfterDiscount = this.settlement.shops[this.shopIndex].total
        this.settlement.shops[this.shopIndex].currentCoupon = {}
        this.settlement.shops[this.shopIndex].skus.forEach(item => {
          item.buyerShopCouponId = null
        })
        this.selectShopCoupon = []
        this.getTotal()
        return false
      }

      if (this.settlement.shops[this.shopIndex].total < coupon.fullMoney) {
        this.$message.warning('不满足优惠券使用条件！')
      } else if (coupon.couponType === 1 && this.settlement.shops[this.shopIndex].total < coupon.reduceMoney) {
        this.$message.warning('不可使用大于商品金额的优惠劵！')
      } else {
        // 选择优惠券
        if (this.promotionInfoDTO.couponId !== 0) {
          this.$message.warning('此券不可与平台券叠加！')
          return false
        }
        if (coupon.couponType === 1) {
          if (coupon.reduceMoney >= this.settlement.shops[this.shopIndex].total) {
            this.$message.warning('优惠券优惠金额不能大于等于合计金额！')
            return false
          }
        }

        this.isShopCoupons = false
        this.shopCouIndex = index
        let useCoupon = this.useShopCoupon(this.shopIndex, this.shopCouIndex)
        if (useCoupon) {
          // 确认使用当前点击的商家券，先将所有的商家券取消选中
          for (let i = 0; i < this.selectShopCoupon.length; i++) {
            this.selectShopCoupon[i].checked = false
          }
          this.selectShopCoupon = []

          coupon.checked = true
          this.settlement.shops[this.shopIndex].id = coupon.id
          this.settlement.shops[this.shopIndex].currentCoupon = coupon
          this.settlement.shops[this.shopIndex].skus.forEach(item => {
            if (item.buyerShopCouponId > 0 && item.buyerShopCouponId !== coupon.shopCouponId) {
              item.buyerShopCouponId = null
            }
          })
          this.selectShopCoupon.push(coupon)
        } else {
          this.settlement.shops[this.shopIndex].totalAfterDiscount = this.settlement.shops[this.shopIndex].total
        }
        this.getTotal()
      }
    },
    // 平台券 本方法参考uniapp的同名方法
    couponItemTap (coupon) {
      if (!coupon.checked && this.selectShopCoupon.length) { // 判断商家券情况
        this.$message.warning('不可与商家券叠加使用！')
        return false
      }
      // 已选中的情况下取消选中
      if (coupon.checked) {
        let promotionInfoDTO = {}
        if (coupon.couponId) {
          promotionInfoDTO['couponId'] = 0
          promotionInfoDTO['ifAdd'] = 1
          promotionInfoDTO['reduceMoney'] = 0
        }
        this.promotionInfoDTO = promotionInfoDTO
        coupon.checked = false
        coupon.discountAmount = 0
        this.isShowDiscount = false
        this.checkedPlatformCoupon = undefined
        this.settlement.shops.forEach(shopItem => {
          if (shopItem.skus) {
            shopItem.skus.forEach(skuItem => {
              skuItem.buyerCouponId = null
            })
          }
        })
        this.getTotal()
      } else {
        // 先把所有已选中的平台优惠券改为未选中
        this.settlement.coupons.forEach((item) => {
          item.checked = false
        })
        let totalPrice = 0 // 订单总价
        let shopsLen = this.settlement.shops.length // 结算页店铺数量
        let matchCouponSkuList = []
        for (let i = 0; i < shopsLen; i++) {
          let matchCouponNormalPrice = 0
          let priceCount = 0
          const curShop = this.settlement.shops[i]
          let skuLen = curShop.skus.length
          let tmpPriceSkuList = []
          for (let j = 0; j < skuLen; j++) {
            const curSku = curShop.skus[j]
            if (curSku.priceId > 0) {
              priceCount++
            }
            const ids = coupon.ids
            if (ids.indexOf(curSku.productId) > -1) {
              if (curSku.priceId > 0) {
                tmpPriceSkuList.push(curSku)
              } else {
                matchCouponSkuList.push(curSku)
                matchCouponNormalPrice = matchCouponNormalPrice + curSku.price * curSku.number
              }
            }
          }
          if (priceCount === tmpPriceSkuList.length) {
            totalPrice += curShop.priceAfterDiscount
            matchCouponSkuList = matchCouponSkuList.concat(tmpPriceSkuList)
          }
          totalPrice += matchCouponNormalPrice
        }
        if (this.settlement.shops[this.shopIndex].total < coupon.fullMoney) {
          this.$message.warning('不满足优惠券使用条件！')
        }
        if (coupon.couponType === 1 && coupon.reduceMoney >= totalPrice) {
          this.$message.warning('不可使用大于等于合计金额的优惠劵！')
          return false
        }
        // 如果是折扣券，需要记录，在什么基数上打折
        coupon.useMoney = totalPrice
        let promotionInfoDTO = {}
        if (coupon.couponId) {
          promotionInfoDTO['couponId'] = coupon.couponId
          promotionInfoDTO['ifAdd'] = coupon.ifAdd
          promotionInfoDTO['couponType'] = coupon.couponType
          promotionInfoDTO['reduceMoney'] = coupon.reduceMoney
        }
        this.promotionInfoDTO = promotionInfoDTO
        this.isShowDiscount = false
        this.checkedPlatformCoupon = coupon
        matchCouponSkuList.forEach(item => {
          item.buyerCouponId = coupon.couponId
        })
        this.getTotal()
        // 选中优惠券
        coupon.checked = true
      }
    },
    // 校验商家券是否满足使用条件
    // 后续该方法的维护直接从uniapp端的代码复制过来
    useShopCoupon (shopIndex, couponIndex) {
      const curShop = this.settlement.shops[shopIndex]
      curShop.totalAfterDiscount = 0
      let curCoupon
      if (curShop.shopCoupons && curShop.shopCoupons.length > 0) {
        curCoupon = curShop.shopCoupons[couponIndex]
      }
      if (!curCoupon) {
        return false
      }
      let useCoupon = false
      let matchCouponNormalSkuList = []
      let matchCouponPriceSkuList = []
      if (curCoupon.applyType !== 1) {
        const ids = curCoupon.ids
        let skuLength = curShop.skus.length
        // 符合优惠券商品列表中的普通sku价格综合
        let matchCouponNormalPrice = 0
        // 符合定价捆绑且在优惠券商品列表中的价格综合
        let matchCouponPricePrice = 0
        // 符合定价捆绑活动的sku数量
        let priceCount = 0
        for (let idx = 0; idx < skuLength; idx++) {
          let curSku = curShop.skus[idx]
          if (curSku.priceId > 0) {
            priceCount++
          }
          if (ids.indexOf(curSku.productId) > -1) {
            if (curSku.priceId > 0) {
              matchCouponPriceSkuList.push(curSku)
            } else {
              matchCouponNormalSkuList.push(curSku)
              matchCouponNormalPrice = matchCouponNormalPrice + curSku.price * curSku.number
            }
          }
        }
        // 如果定价捆绑的所有sku都符合优惠券
        if (priceCount === matchCouponPriceSkuList.length) {
          matchCouponPricePrice = curShop.priceAfterDiscount
        }
        // 符合的sku的price加起来是否满足满减的条件
        const priceFinal = matchCouponPricePrice + matchCouponNormalPrice
        if (priceFinal < curCoupon.fullMoney || (curCoupon.couponType === 1 && priceFinal <= curCoupon
          .reduceMoney)) {
          return false
        }
        // 判断是满减，还是折扣
        if (curCoupon.couponType === 1) {
          curShop.totalAfterDiscount = curShop.total - curCoupon.reduceMoney
          curCoupon.discountAmount = curCoupon.reduceMoney
          useCoupon = true
        } else {
          // 打折后优惠抵扣的金额
          let priceDiscount = (priceFinal * ((10 - curCoupon.reduceMoney) / 10)).toFixed(2)
          let tmpTotal = curShop.total - priceDiscount
          if (tmpTotal.toFixed(2) >= 0.01) {
            curShop.totalAfterDiscount = tmpTotal.toFixed(2)
            curCoupon.discountAmount = priceDiscount
            useCoupon = true
          }
        }
        if (useCoupon) {
          // 满足的sku设置buyerShopCouponId
          if (priceCount === matchCouponPriceSkuList.length) {
            let length1 = matchCouponPriceSkuList.length
            for (let idx = 0; idx < length1; idx++) {
              matchCouponPriceSkuList[idx].buyerShopCouponId = curCoupon.shopCouponId
            }
          }
          let length2 = matchCouponNormalSkuList.length
          for (let idx = 0; idx < length2; idx++) {
            matchCouponNormalSkuList[idx].buyerShopCouponId = curCoupon.shopCouponId
          }
        }
      } else {
        if (curCoupon.couponType === 1) {
          if (curShop.total > curCoupon.reduceMoney) {
            curShop.totalAfterDiscount = curShop.total - curCoupon.reduceMoney
            curCoupon.discountAmount = curCoupon.reduceMoney
            useCoupon = true
          }
        } else {
          if (curShop.total > curCoupon.fullMoney) {
            let priceDiscount = (curShop.total * ((10 - curCoupon.reduceMoney) / 10)).toFixed(2)
            let tmpTotal = curShop.total - priceDiscount
            if (tmpTotal.toFixed(2) >= 0.01) {
              curShop.totalAfterDiscount = tmpTotal.toFixed(2)
              curCoupon.discountAmount = priceDiscount
              useCoupon = true
            }
          }
        }
        if (useCoupon) {
          let skuLength = curShop.skus.length
          for (let idx = 0; idx < skuLength; idx++) {
            curShop.skus[idx].buyerShopCouponId = curCoupon.shopCouponId
          }
        }
      }
      return useCoupon
    },
    /**
     * 计算总价，商家券的优惠计算，在调用本方法之前已经计算好在shops[].totalAfterDiscount
     * 本方法参考uniapp的方法即可
     */
    getTotal () {
      this.totalPrice = 0
      this.totalCount = 0
      let shopSumPrice = 0
      let shopsLen = this.settlement.shops.length
      this.calcCouponShopAmount()

      for (let i = 0; i < shopsLen; i++) {
        this.totalPrice += parseFloat(this.settlement.shops[i].totalAfterDiscount)
        shopSumPrice += parseFloat(this.settlement.shops[i].totalAfterDiscount)
        this.totalCount += this.settlement.shops[i].number
      }

      this.calcCouponAmount()
      if (this.checkedPlatformCoupon) {
        this.totalPrice = shopSumPrice - this.couponAmount
      }
      // 加上每个商家的运费
      this.settlement.shops.forEach((item) => {
        this.totalPrice = this.totalPrice + (item.distribution.distributionPrice || 0)
      })
    },
    getShopTotal () {
      let total = 0
      this.settlement.shops.forEach(shop => {
        total += parseFloat(shop.total)
      })
      return total
    },
    // 计算商家券优惠金额
    calcCouponShopAmount () {
      if (!this.selectShopCoupon || this.selectShopCoupon.length === 0) {
        this.couponShopAmount = 0
      }
      let tmpAmount = 0
      this.selectShopCoupon.forEach(coupon => {
        tmpAmount += coupon.discountAmount
      })
      this.couponShopAmount = tmpAmount
    },
    // 计算平台券优惠金额
    calcCouponAmount () {
      let tmpAmount = 0
      if (this.checkedPlatformCoupon) {
        if (this.checkedPlatformCoupon.couponType === 1) {
          tmpAmount = this.checkedPlatformCoupon.reduceMoney
        } else {
          tmpAmount = (this.checkedPlatformCoupon.useMoney * ((10 - this.checkedPlatformCoupon.reduceMoney) / 10)).toFixed(2)
        }
      }
      this.couponAmount = parseFloat(tmpAmount)
    },
    // 选择支付方式
    selectPay (payType) {
      this.payType = payType
    },
    clickTips () {
       this.$message.warning('当前地址不支持配送，请参与红色字提示！')
    },
    // 提交支付
    clickPayOrder () {
      this.errorDialog = false
      if (this.payType === '') {
        this.$message.warning('请选择支付方式')
      } else if (this.currentAddressId === '') {
        this.$message.warning('请选择您的收货地址')
      } else {
        let shops = []
        this.settlement.shops.forEach((j, i) => {
          let skus = []
          j.skus.forEach((k, n) => {
            if (k.selected) {
              skus.push({
                skuId: k.skuId,
                number: k.number,
                selected: k.selected,
                platformSeckillId: k.platformSeckillId,
                platformDiscountId: k.platformDiscountId,
                shopSeckillId: k.shopSeckillId,
                shopDiscountId: k.shopDiscountId,
                priceId: k.priceId,
                composeId: k.composeId,
                sceneId: k.sceneId,
                useMember: k.useMember,
                buyerCouponId: k.buyerCouponId,
                buyerShopCouponId: k.buyerShopCouponId
              })
            }
          })
          if (skus.length) {
            shops.push({
              id: j.id,
              shopId: j.shopId,
              remark: j.remark,
              distribution: {
                distributionPrice: j.distribution.distributionPrice,
                logisticsId: j.distribution.logisticsId,
                distributionName: j.distribution.distributionName
              },
              skus
            })
          }
        })
        this.submitData.shops = shops
        this.submitData.receiveId = this.currentAddressId
        this.submitData.price = this.totalPrice.toFixed(2)
        // 优惠总额 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        this.submitData.discountPrice = parseFloat((this.couponAmount + this.couponShopAmount).toFixed(2) || 0)
        this.submitData.remark = this.settlement.shops[0].remark
        if (this.activityType === 1 && this.ifWork !== 1) {
          this.submitData.shopGroupWorkId = this.workData.shopGroupWorkId
          this.submitData.type = 1
          if (this.workData.collageId) {
            this.submitData.collageId = this.workData.collageId
            this.submitData.type = 2
          }
        } else if (this.activityType === 2) {
          this.submitData.shopSeckillId = this.paramShops[0].shopSeckillId
          this.submitData.type = 3
        } else if (this.activityType === 3) {
          this.submitData.shopDiscountId = this.paramShops[0].shopDiscountId
          this.submitData.type = 4
        }
        this.orderSubmit(this.submitData, 'submitData')
      }
    },
    // 提交订单
    async orderSubmit (subData) {
      subData.couponId = this.promotionInfoDTO && this.promotionInfoDTO.couponId > 0 ? this.promotionInfoDTO.couponId : 0
      this.btnLoading = true
      const response = await orderSubmit(subData)
      const res = response.data
      if (res.code === '200') {
        this.payInfo = res.data
        if (this.type === 2 || this.type === '2') {
          let ids = []
          subData.shops.forEach(i => {
            i.skus.forEach(j => {
              ids.push(j.skuId)
            })
          })
          deleteCartItem({ids}).then(res => {
            if (res.data.code === '200') {
              this.getTrolleyList()
            }
          })
        }
        this.weChatDialog = true
        this.chatTimer = setInterval(() => {
          this.checkPay(res.data)
        }, 3000)
      } else {
        this.$message({
          message: res.message,
          type: 'warning'
        })
      }
      this.btnLoading = false
    },
    // 查询订单是否支付成功
    checkPay (paramsData) {
      setTimeout(() => {
        checkOrderResult({
          collageId: paramsData.collageId,
          money: paramsData.money,
          orderId: paramsData.orderId,
          type: 1
        }).then(response => {
          const res = response.data
          if (res.code === '200') {
            if (res.data.code === 'SUCCESS') {
              this.$message({
                message: '支付成功！',
                type: 'success'
              })
              clearInterval(this.chatTimer)
              this.getTrolleyList()
              // 支付有礼跳转
              this.$router.push({path: '/orderResult', query: {orderId: paramsData.orderId}})
            }
          } else {
            clearInterval(this.chatTimer)
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }, 0)
    },
    // 获取购物车列表
    async getTrolleyList () {
      const response = await getCartList()
      const res = response.data
      let cartNumber = 0
      if (res.data.length) {
        res.data.forEach(j => {
          cartNumber = cartNumber + j.skus.length
        })
      }
      this.setShoppingCart(res.data)
      this.setCartNumber(cartNumber)
    },
    // 取消支付
    handleClose () {
      this.$confirm('确认取消支付？')
        .then(_ => {
          clearInterval(this.chatTimer)
          this.weChatDialog = false
          this.errorDialog = true
        })
        .catch(_ => {})
    },
    toOrder () {
      this.$router.push({path: '/myOrder'})
    }
  }
}
</script>

<style lang="scss" scoped>
.placeOrder {
  margin: 20px auto;
  .poAddressList {
    width: 100%;
    border: 1px solid #F5F5F5;
    // padding: 20px;
    margin-bottom: 30px;
    box-sizing: border-box;
    .poAddListTit {
      height: 80px;
      background-color: #FAFAFA;
      display: flex;
      justify-content: space-between;
      align-items: center;
      span:nth-child(1) {
        color: #333333;
        font-size: 16px;
        margin-left: 30px;
      }
      span:nth-child(2) {
        color: $mainGlod;
        font-size: 14px;
        cursor: pointer;
        margin-right: 30px;
      }
    }
    .poAddListBox {
      height: 130px;
      margin:20px 30px 0 30px;
      font-family: Microsoft YaHei;
      .title{
        font-size: 16px;
        color: #333333;
      }
      .addressItem{
        height: 40px;
        margin: 30px auto 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        .addressInfo{
          display: flex;
          align-items: center;
          cursor: default;
          .userName{
            display: block;
            width: 100px;
            height: 40px;
            line-height: 40px;
            text-align: center;
            color: #B39259;
            background-color: rgba($color: #C5AA7B, $alpha: .1);
          }
          .userAddress{
            margin: 0 30px 0 20px;
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
        }
        .changeAddress{
          width: 100px;
          height: 40px;
          line-height: 40px;
          text-align: center;
          color: #FFEBC4;
          background-color: #333333;
          cursor: pointer;
        }
      }
    }
  }
  >>> .el-dialog {
    // .el-dialog__body {
    //   background: #F8F8F8;
    // }
    .el-dialog__header {
      text-align: center;
    }
    .el-dialog__footer {
      text-align: center;
      .dialog-footer {
        text-align: center;
        button {
          height: 45px;
          width: 160px;
        }
        .combtns{
          width: 200px;
          height: 50px;
          background: #F3F4F5;
          border-radius: 0px;
        }
        .btnBlack{
          color: $mainGlod;
          background: #333333;
        }
      }
    }
  }
  .addressTable{
    width: 100%;
    max-height: 415px;
    overflow-y: auto;
    .addressListItem{
      height: 80px;
      padding: 15px 20px;
      margin-bottom: 15px;
      border: 1px solid #F3F4F5;
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      .com{
        display: flex;
        font-size: 14px;
        font-family: Microsoft YaHei;
        color: #999999;
        .left{
          flex: 1;
        }
      }
      .left{
        span{
          color: #333333;
        }
        .defTip{
          width: 70px;
          height: 25px;
          padding: 10px;
          color: #FFF;
          background-color: $mainGlod;
          cursor: default;
        }
      }
      .setDef{
        cursor: pointer;
      }
    }
    .addressActive{
      background: rgba(197, 170, 123, 0.26);
      border: 1px solid #C5AA7B;
    }
    .colorActive{
      color: $mainGlod;
    }
  }
  .shoplist{
    .shopTitle{
      line-height: 80px;
      padding-left: 30px;
      background-color: #FAFAFA;
    }
  }
  .orderList {
    background: #FCFCFC;
    border: 1px solid #E5E5E5;
    margin-bottom: 25px;
    .orderInfoTit {
      width: 100%;
      display: flex;
      height: 44px;
      line-height: 44px;
      color: #333333;
      font-size: 14px;
      font-weight: 400;
    }
    span {
      text-align: center;
    }
    span:nth-child(1) {
      width: 40%;
      text-align: left;
      padding-left: 125px;
      box-sizing: border-box;
    }
    span:nth-child(2) {
      width: 20%;
      text-align: left;
    }
    span:nth-child(3) {
      width: 15%;
    }
    span:nth-child(4) {
      width: 15%;
    }
    span:nth-child(5) {
      width: 10%;
    }
    span:nth-child(6) {
      width: 10%;
    }
  }
  .couponContainer{
    margin-bottom: 30px;
    height: 100%;
    margin-top: 30px;
    overflow: auto;
    box-sizing: border-box;
    border: 1px solid #F3F4F5;
    p{
      padding-left: 30px;
      line-height: 80px;
      font-size: 16px;
      background-color: #FAFAFA;
    }
    .couponItem {
      width: 280px;
      height: 88px;
      margin: 15px;
      float: left;
      cursor: pointer;
      position: relative;
      box-sizing: border-box;
      display: flex;
    }

    .svg-icon{
      width:100%;
      height:100%;
      position: absolute;
      z-index: -1;
    }
    .des{
      flex: 8;
      display: flex;
      justify-content: flex-start;
      align-items: center;
      .nums{
        flex: 4;
        text-align: right;
        .money{
          font-size: 40px;
        }
      }
      .cloumn{
        flex: 6;
        display: flex;
        flex-direction: column;
        margin-left: 8px;
      }
    }
    .aside{
      flex: 2;
      display: flex;
      justify-content: center;
      align-items: center;
      .checkBox{
        width: 20px;
        height: 20px;
        border: 1px solid #E8E9EB;
      }
    }
    .marginR{
      margin-right: 13px;
    }
  }
  .payBox {
    .payTit {
      padding-left: 30px;
      line-height: 80px;
      font-size: 16px;
      color: #333333;
      background-color: #FAFAFA;
    }
    .payList{
      height: 120px;
      padding: 0 20px;
      border: 2px solid #F3F4F5;
      display: flex;
      align-items: center;
      .typeBox{
        display: block;
        width: 150px;
        height: 60px;
        margin: 0 20px;
        color: #666666;
        font-size: 16px;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        position: relative;
        i {
          font-size: 26px;
          margin-right: 5px;
        }
        b {
          color: $mainGlod;
          position: absolute;
          right: -1px;
          bottom: -1px;
          display: none;
        }
      }
      .payActive {
        border: 1px solid $mainGlod;
        b {
          display: block;
        }
      }
      span {
        border: 1px solid #E5E5E5;
        padding: 5px 10px;
        margin-right: 15px;
      }
      span:nth-child(1) {
        i:nth-child(1) {
          color: #40ba49;
          cursor: pointer;
        }
      }
      span:nth-child(2) {
        i {
          color:  #40ba49;
        }
      }
    }
  }
  // 提交订单部分
  .placeOrderBtn {
    margin-top: 50px;
    width: 100%;
    padding: 30px 0;
    .payInfo{
      padding: 0 15px;
      line-height: 70px;
      border: 2px solid #F3F4F5;
      display: flex;
      span {
        display: block;
        font-size: 14px;
        color: #333333;
        margin-left: 100px;
      }
      span:nth-child(1) {
        margin-left: 0;
      }
      span:nth-child(4) {
        b {
          color: $mainGlod;
        }
      }
    }
    .submitOrder{
      display: block;
      width: 200px;
      height: 50px;
      margin: 40px auto 0;
      padding: 0;
      background-color: #333;
      color: #FFEBC4;
      border-radius: 0;
    }
    .unDisButton{
      opacity: 0.6;
    }
  }
  .payment {
    width: 80%;
    margin: 0 auto;
    .paymentBox {
      margin-top: 50px;
      display: flex;
      justify-content: center;
      .successBox, .errorBox {
        width: 240px;
        text-align: center;
      }
      .successBox {
        border-right: 1px solid #DDDDDD;
        >>> .el-button {
          border: 1px solid $mainGlod;
        }
      }
      span {
        display: block;
        margin-bottom: 20px;
      }
    }
    .paymentInfo {
      text-align: center;
      margin-top: 60px;
      p {
        font-size: 16px;
        color: #999999;
        line-height: 30px;
        b {
          color: #FF7800;
          cursor: pointer;
          font-weight: normal;
        }
      }
    }
  }
  // 微信支付弹框
  .weChat {
    >>> .el-dialog__body {
      background: #FFFFFF;
      .qCode {
        .wechatTitle{
          width: 280px;
          margin: auto;
          padding: 10px 15px;
          color: #333;
          border: 2px solid #F3F4F5;
          display: flex;
          justify-content: space-around;
          align-items: center;
          .tips{
            flex: 1;
          }
        }
        .code{
          width: 280px;
          height: 280px;
          display: block;
          margin: 10px auto;
          border: 2px solid #F3F4F5;
        }
      }
    }
  }
  .errorDialog {
    text-align: center;
    .errorTit {
      span {
        font-size: 50px;
        color: red;
      }
      p {
        margin: 30px 0;
      }
    }
    span {
      display: block;
    }
    .btns{
      border-radius: 0;
      background-color: #F3F4F5;
    }
    .pay{
      color: #FFEBC4;
      background-color: #333;
    }
  }
  .remarksBox {
    display: flex;
    background: #F7F7F7;
    padding: 25px;
    border-radius: 8px;
    margin-bottom: 30px;
    .remarksInfo {
      width: 100%;
      >>> .el-textarea__inner {
        width: 100%;
        height: 84px;
      }
    }
    .selectBox {
      margin-left: 70px;
      label {
        color: #666666;
        font-size: 16px;
        font-weight: normal;
      }
    }
    .shopTotal {
      color: $mainGlod;
      flex: 1;
      text-align: right;
    }
  }
}
</style>
