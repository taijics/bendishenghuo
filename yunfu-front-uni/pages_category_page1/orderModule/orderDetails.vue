<!-- 订单详情 -->
<template>
  <view class="u-skeleton">
<!--    <global-loading />-->
    <view>
<!--      <Skeleton-->
<!--          el-color="#fff"-->
<!--          bg-color="#efefef"-->
<!--          :loading="loading && isFirstComeIn"-->
<!--          :animation="true"-->
<!--      ></Skeleton>-->
      <view
          class="content"
          style="padding-bottom:200upx;"
      >
        <view class="order-details-status">
          <!--  待付款-->
          <view
              class="status-title-box"
              v-if="dataList.state==1"
          >
            <view class="l u-skeleton-rect">
              <text class="status">等待买家付款</text>
               <text class="label">剩{{hou}}小时{{min}}分{{sec}}秒自动关闭</text>
<!--              <view style="color: #FFFFFF; margin-top: 20rpx;display: flex;justify-content: center">
                <text>剩</text>
                {{ remainingTime }}
                <u-count-down
                    v-if="remainingTime!==null"
                    :timestamp="remainingTime"
                    fontSize="24rpx"
                    separatorColor="#FFFFFF"
                    separatorSize="24rpx"
                ></u-count-down>
                <text>自动关闭</text>
              </view>-->
            </view>
          </view>
          <!--  待发货-->
          <view
              class="status-title-box"
              v-else-if="dataList.state==2"
          >
            <view class="l">
              <text class="status u-skeleton-rect">等待卖家发货</text>
              <text class="label u-skeleton-rect">付款后2-5个工作日发货</text>
            </view>
          </view>
          <!--  待收货-->
          <view
              class="status-title-box"
              v-else-if="dataList.state==3"
          >
            <view class="l">
              <text class="status u-skeleton-rect">卖家已发货</text>
              <!-- <text class="label">还剩5天21小时自动确认</text> -->
            </view>
          </view>
          <!-- 已完成 -->
          <view
              class="status-title-box"
              v-else-if="dataList.state==4"
          >
            <view class="l">
              <text class="status u-skeleton-rect">交易成功</text>
              <text class="label u-skeleton-rect">感谢您的使用</text>
            </view>
          </view>
          <!--  拼团失败-->
          <view
              class="status-title-box"
              v-else-if="dataList.state==5 && dataList.collageId != 0"
          >
            <view class="l">
              <text class="status u-skeleton-rect">拼团失败</text>
              <text class="label u-skeleton-rect">剩余时间 00:00:00</text>
            </view>
            <view class="clusterback">
            </view>
          </view>
          <!-- 交易关闭-->
          <view
              class="status-title-box2"
              v-else-if="dataList.state==5"
          >
            <text class="status">交易关闭</text>
            <text class="label">您已关闭了这笔交易</text>
          </view>
          <!-- 退款成功-->
          <view
              class="status-title-box2"
              v-else-if="(dataList.returnType==1 && dataList.moneyReturnList.status==4) || (dataList.returnType==2 && dataList.moneyReturnList.status==6)"
          >
            <text class="status">退款成功</text>
            <text class="label">该笔订单 ¥{{ dataList.paySum }} 退款，已原路退回</text>
          </view>
          <!--  待成团-->
          <view
              class="status-title-box"
              v-else-if="dataList.state==6"
          >
            <view class="l">
              <text class="status u-skeleton-rect">待成团</text>
              <text class="label u-skeleton-rect">剩余时间{{hou}}小时{{min}}分{{sec}}秒</text>
<!--              <view style="color: #FFFFFF; margin-top: 20rpx;">-->
<!--                <text>剩余时间</text>-->
<!--                <u-count-down-->
<!--                    :timestamp="remainingTime"-->
<!--                    fontSize="24rpx"-->
<!--                    :separator="zh"-->
<!--                    separatorColor="#FFFFFF"-->
<!--                    separatorSize="24rpx"-->
<!--                ></u-count-down>-->
<!--              </view>-->
            </view>
          </view>

        </view>
        <view class="order-details-info-box">
          <view class="address-box u-skeleton-rect">
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/orderAddress.png`"
                class="address-img"
            >
            </image>
            <view class="address-r">
              <view class="address-name-box">
                <text>{{ dataList.receiveName }}</text>
                <text class="phone">{{ dataList.receivePhone }}</text>
              </view>
              <view class="address-info">
                <text>{{ dataList.receiveAdress }} {{ dataList.address }}</text>
              </view>
            </view>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                v-if="false"
                class="arrow-right-img"
            ></image>
          </view>

          <view class="order-list-box">
            <view class="item">
              <view class="order-list-top">
                <view
                    class="top-l"
                    @click="goShop(dataList.shopId)"
                >
                  <image
                      :src="`${VUE_APP_STATIC_URL}static/images/orderStoreIcon.png`"
                      class="shop-img"
                  ></image>
                  <text class="shop-name">{{ dataList.shopName }}</text>
                  <image
                      :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                      class="arrow-img"
                  >
                  </image>
                </view>
                <view
                    class="toService"
                    @click="openService(dataList.shopId)"
                >
                  <image
                      :src="`${VUE_APP_STATIC_URL}static/images/serviceImg-order-detail.png`"
                      class="service-img"
                  ></image>
                  <text>联系客服</text>
                </view>
              </view>
              <view class="order-info-box">
                <view class="order-info">
                  <view
                      class="order-info-item"
                      v-for="proItem in dataList.skus"
                      :key="proItem.productId"
                      @click="goodsItemTap(proItem.productId,proItem.skuId)"
                  >
                    <image
                        :src="proItem.image"
                        class="product-img default-img"
                    ></image>
                    <view class="info-box">
                      <text class="product-name">{{ proItem.productName }}</text>
                      <view class="price-sku-box">
                        <view class="product-sku">
                          <view
                              class="mar-left-20"
                              v-for="vItem in proItem.values"
                          >
                            <text>{{ vItem }}</text>
                          </view>
                        </view>
                        <view class="product-num">x {{ proItem.number }}</view>
                      </view>
                      <view class="price-sku-box">
                        <!--											<view class="price-box">-->
                        <!--												<view class="product-price1">实付：<text-->
                        <!--														class="fuhao">￥</text>{{proItem.price}}</view>-->
                        <!--												&lt;!&ndash; <view class="product-price2">价格：<text class="fuhao">￥</text>{{proItem.price}}</view> &ndash;&gt;-->
                        <!--											</view>-->

                        <view
                            v-if="(dataList.state === 3 || dataList.state === 4) && proItem.afterState == 0 && !proItem.returnType"
                        >
                          <view
                              class="item-applay-btn"
                              v-if="proItem.returnStatus == null || (!proItem.canApplyIntervention && proItem.returnStatus == 2)"
                              @click.stop="applayItemTap(proItem)"
                          >退款
                          </view>
                        </view>

                        <view v-if="proItem.returnType == 1">
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 0 || proItem.returnStatus == 1 || proItem.returnStatus == 3 || proItem.returnStatus == 4"
                          >
                            退款中
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 4"
                          >已退款
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 5"
                          >退款失败
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="applyPlatform(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.canApplyIntervention"
                          >客服介入
                          </view>
                        </view>
                        <view v-if="proItem.returnType == 2">
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 0 || proItem.returnStatus == 1 || proItem.returnStatus == 3 || proItem.returnStatus == 4"
                          >
                            退货中
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 6"
                          >已退款
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 7"
                          >退款中
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="goApplyTap(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.returnStatus == 5 || proItem.returnStatus == 8"
                          >
                            退款失败
                          </view>
                          <view
                              class="item-applay-btn"
                              @click="applyPlatform(proItem.returnCode,proItem.returnType)"
                              v-if="proItem.canApplyIntervention"
                          >客服介入
                          </view>
                        </view>

                        <view
                            v-if="proItem.commentStatus == 0"
                            class="evaluate"
                            @click="evaluateTap(pIndex)"
                        >立即评价
                        </view>
                        <view
                            v-if="proItem.commentStatus == 1 && proItem.additionalComment != null"
                            @click="evaluateTowTap(pIndex)"
                            class="evaluate2"
                        >追加评价
                        </view>

                      </view>
                    </view>
                  </view>
                  <view class="delivery-way-box">
                    <view class="item">
                      <text class="way">商品总价</text>
                      <text class="way">¥{{ dataList.orderPrice }}</text>
                    </view>
                    <view class="item">
                      <text class="way">快递运费</text>
                      <text class="way">¥{{ dataList.logisticsPrice }}</text>
                    </view>
                    <view class="item">
                      <text class="way">平台优惠</text>
                      <text class="way">-¥{{ dataList.discountPrice }}</text>
                    </view>
                  </view>
                </view>
                <!-- 待发货 待收货 已完成 -->
                <view
                    class="order-total-box"
                    v-if="dataList.state==2||dataList.state==3||dataList.state==4"
                >
                  <text>实付款</text>
                  <text class="way-color">¥{{ dataList.price }}</text>
                </view>
                <!-- 待付款 价格是橙色-->
                <view
                    class="order-total-box"
                    v-else-if="dataList.state==1"
                >
                  <text>需付款</text>
                  <text class="way-color">¥{{ dataList.price }}</text>
                </view>
                <!-- 退款成功 交易关闭 -->
                <view
                    class="order-total-box"
                    v-else-if="(dataList.returnType==1 && dataList.moneyReturnList.status==4) || (dataList.returnType==2 && dataList.goodsReturn.status==6) || (dataList.state==5)"
                >
                  <text>需付款</text>
                  <text>¥{{ dataList.price }}</text>
                </view>
              </view>
            </view>
          </view>
          <view class="order-details-information padd u-skeleton-rect">
            <view class="order-title">
              <text>订单信息</text>
            </view>
            <view class="info-box">
              <!--都有  但是：待付款  待发货  退款成功 交易关闭  只有前两个item-->
              <view class="item">
                <text>订单编号：{{ dataList.orderFormid }}</text>
                <text
                    class="copy-color"
                    :data-clipboard-text="dataList.orderFormid"
                    @click="copy"
                >复制
                </text>
              </view>
              <view class="item">
                <text>创建时间：{{ dataList.createTime }}</text>
              </view>
              <!-- 待收货  有付款时间和发货时间 -->
              <view
                  class="item"
                  v-if="dataList.state==3"
              >
                <text>付款时间：{{ dataList.paymentTime }}</text>
              </view>
              <view
                  class="item"
                  v-if="dataList.state == 3 || dataList.state == 4"
              >
                <text>发货时间：{{ dataList.dileveryTime }}</text>
              </view>
              <!-- 交易成功 有成交时间-->
              <view
                  class="item"
                  v-if="dataList.state == 4"
              >
                <text>成交时间：{{ dataList.receiveTime }}</text>
              </view>
            </view>
          </view>
          <view v-if="dataList.state==3 || dataList.state==4">
            <view class="order-details-information mt20 u-skeleton-rect">
              <view
                  class="order-title-box"
                  @click="wuLiuTap"
              >
                <view class="order-title padd-l">
                  <text class="line"></text>
                  <text>物流信息</text>
                </view>
                <image
                    mode="aspectFill"
                    :src="`${VUE_APP_STATIC_URL}static/images/arrowDown.png`"
                    class="arrow-down-img"
                    style="transform:rotate(180deg);"
                    v-if="isShowWuLiu == true"
                >
                </image>
                <image
                    mode="aspectFill"
                    :src="`${VUE_APP_STATIC_URL}static/images/arrowDown.png`"
                    class="arrow-down-img"
                    v-else
                >
                </image>
              </view>
            </view>
            <!-- 暂无物流 -->
            <view v-if="isShowWuLiu">
              <view
                  v-if="steps.length>0"
                  class="logistics"
              >
                <uni-steps
                    :options="steps"
                    direction="column"
                    :active="0"
                ></uni-steps>
              </view>
              <view
                  v-else
                  class="emptyOrder-box flex-items-plus flex-column"
              >
                <image
                    class="emptyOrder-img"
                    :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
                ></image>
                <label class="font-color-999 fs26 mar-top-30">这里空空如也～</label>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 待付款 待发货 待收货 已完成 退款成功 -->
      <view
          class="order-details-btn"
          style="padding-top:30upx;"
          :style="{'padding-bottom':(isIphone==true? 40:0)+'rpx'}"
      >
        <text
            class="btn-l"
            @click="cancelOrder"
            v-if="dataList.state==1 || dataList.state==6"
        >取消订单
        </text>
        <text
            class="btn btn-r"
            @click="payOrder"
            v-if="dataList.state==1"
        >立即付款
        </text>
        <text
            class="btn-l"
            @click="applyMoneyAllTap"
            v-if="dataList.state==2 || dataList.state==3"
        >申请退款
        </text>
        <text
            class="btn btn-r"
            @click="confirmReceiptTap"
            v-if="dataList.state==3"
        >确认收货
        </text>
        <text
            class="btn"
            @click="applyTap"
            v-if="dataList.state==4"
        >申请售后
        </text>
        <text
            class="btn btn-r"
            @click="goInviteSpll(dataList.collageId,dataList.orderId,dataList.skus[0].productId,dataList.skus[0].skuId,dataList.shopGroupWorkId)"
            v-if="dataList.state==6"
        >邀请拼单
        </text>
        <text
            class="btn-l"
            @click="delOrder"
            v-if="dataList.state==5 && dataList.collageId == 0"
        >删除订单
        </text>
        <text
            class="btn btn-r"
            @click="againCollage(dataList.skus[0].productId,dataList.shopId,dataList.skus[0].skuId,dataList)"
            v-if="dataList.state==5 && dataList.collageId == 0"
        >再次购买
        </text>
        <text
            class="btn"
            @click="againCollage(dataList.skus[0].productId,dataList.shopId,dataList.skus[0].skuId,dataList)"
            v-if="dataList.state==5 && dataList.collageId != 0"
        >再次开团
        </text>
      </view>
      <u-popup
          class="pay-type-popup"
          v-model="showPayTypePopup"
          mode="bottom"
          border-radius="14"
          close-icon-pos="top-right"
          close-icon-size="20"
      >
        <view class="pay-type-item">
          <u-radio-group
              @change="payTypeChange"
              v-model="paymentMode"
          >
            <view class="pay-type-radio">
              <view class="pay-type-img">
                <image
                    class="pay-type-img-inner"
                    :src="`${VUE_APP_STATIC_URL}static/images/alipay.png`"
                />
              </view>
              <label class="pay-type-label">支付宝支付</label>
              <u-radio
                  class="pay-type-radio-item"
                  style="transform:scale(0.9)"
                  :checked="paymentMode == 2"
                  :name="2"
                  value="2"
              />
            </view>
            <view class="pay-type-radio">
              <view class="pay-type-img">
                <image
                    class="pay-type-img-inner"
                    :src="`${VUE_APP_STATIC_URL}static/images/huabei.png`"
                />
              </view>
              <label class="pay-type-label">花呗分期</label>
              <u-radio
                  class="pay-type-radio-item"
                  style="transform:scale(0.9)"
                  :disabled="totalPrice < 0.03"
                  :checked="paymentMode == 3"
                  :name="3"
                  value="3"
              />
            </view>
          </u-radio-group>
          <view class="huabei-detail">
            <u-radio-group
                @change="huabeiPeriodChange"
                v-model="huabeiPeriod"
            >
              <view class="period-radio">
                <view class="period-amount">
                  <label class="period-each">￥ {{ clip2Decimal(fenqiFeeList[0]) }}x3期</label>
                  <label class="period-each-charge">手续费￥{{ clip2Decimal(chargeFeeList[0]) }}/期</label>
                </view>
                <u-radio
                    class="period-type-radio-item"
                    style="transform:scale(0.9)"
                    :disabled="fenqiDisabledList[0]"
                    :checked="huabeiPeriod == 3"
                    :name="3"
                    value="3"
                />
              </view>
              <view class="period-radio">
                <view class="period-amount">
                  <label class="period-each">￥ {{ clip2Decimal(fenqiFeeList[1]) }}x6期</label>
                  <label class="period-each-charge">手续费￥{{ clip2Decimal(chargeFeeList[1]) }}/期</label>
                </view>
                <u-radio
                    class="period-type-radio-item"
                    style="transform:scale(0.9)"
                    :disabled="fenqiDisabledList[1]"
                    :checked="huabeiPeriod == 6"
                    :name="6"
                    value="6"
                />
              </view>
              <view class="period-radio">
                <view class="period-amount">
                  <label class="period-each">￥ {{ clip2Decimal(fenqiFeeList[2]) }}x12期</label>
                  <label class="period-each-charge">手续费￥{{ clip2Decimal(chargeFeeList[2]) }}/期</label>
                </view>
                <u-radio
                    class="period-type-radio-item"
                    style="transform:scale(0.9)"
                    :disabled="fenqiDisabledList[2]"
                    :checked="huabeiPeriod == 12"
                    :name="12"
                    value="12"
                />
              </view>
            </u-radio-group>
          </view>
        </view>
        <view class="paytype-confirm">
          <view
              class="fenqi-total-amount"
              v-if="totalPrice >= 0.03 && paymentMode == 3"
          >
            <label class="fenqi-all">分期总额 ￥{{ clip2Decimal(totalPrice) }}</label>
            <label class="charge-fee-all">手续费 ￥{{ clip2Decimal(chargeFee) }}</label>
          </view>
          <view
              class="fenqi-total-amount"
              v-if="paymentMode == 2"
          >
            <label class="order-amount">订单总额 ￥{{ clip2Decimal(totalPrice) }}</label>
          </view>
          <view class="fenqi-confirm">
            <text
                class="btn"
                @click="continuePay"
            >确认
            </text>
          </view>
        </view>
      </u-popup>
    </view>
  </view>
</template>

<script setup>
import UCountDown from "../../uni_modules/vk-uview-ui/components/u-count-down/u-count-down";
import { VUE_APP_STATIC_URL } from "@/config/api";
import ClipboardJS from "clipboard";
import { hidden } from "../../utils/hidden";
import { handleDoPay } from "../../utils/payUtil";
import { Services } from "../../utils/services";
import { request } from '../../utils/request'
import API from "../../config/api";
import { onBackPress, onLoad, onUnload } from "@dcloudio/uni-app";
import { inject, ref } from "vue";
import { useLoading } from "@/hooks/useLoading";
import Skeleton from "@/components/Skeleton/index.vue";

const loading = ref(false);
const isFirstComeIn = ref(true);
const canApplyIntervention = ref(false)
const orderId = ref(0)
const active = ref(0)
const steps = ref([])
const isShowWuLiu = ref(false)
const hou = ref("00")
const min = ref("00")
const sec = ref("00")
const timeOut = ref(undefined)
const orderRefundList = ref([])
const item = ref({})
const isIphone = ref(false)
const noticeId = ref(0)
const paymentMode = ref(2)
const showPayTypePopup = ref(false)
const chargeFee = ref(0)
const totalPrice = ref(0)
const huabeiPeriod = ref(-1)
const fenqiFeeList = ref([0, 0, 0])
const chargeFeeList = ref([0, 0, 0])
const fenqiDisabledList = ref([true, true, true])
const huabeiChargeType = ref(1)
const huabeiFeeRateList = ref([0, 0, 0])
const alipayInfo = ref({})
const isAllSelect = ref(1) //是否为拆单售后
const serviceURL = ref('')// 客服
const corpId = ref('')
const isLoading = ref(false)
const ifShow = ref(false)
const remainingTime = ref(null) //倒计时剩余时间
const dataList = ref({
  orderFormid: null,
  createTime: null,
  orderPrice: 0,
  logisticsPrice: 0,
  discountPrice: 0
})
const {showLoading: $showLoading, hideLoading: $hideLoading} = useLoading();
const $getJumpParam = inject('$getJumpParam')
onLoad(options => {
  isIphone.value = getApp().globalData.isIphone;
  if (options.detail) {
    options = $getJumpParam(options)
  }
  orderId.value = (parseInt(options.orderId))
  item.value = options
  if (options.noticeId) {
    noticeId.value = options.noticeId
  }
  getDataList(orderId.value)
  Orderrefund()
  getHuabeiFeeRateList()
})
onUnload(() => {
  if (timeOut.value) {
    clearTimeout(timeOut.value)
  }
})
// onBackPress(e => {
//   if (e.from === 'backbutton') {
//     back()
//   }
//   // if (e.from === 'navigateBack') {
//   //   return false;
//   // }
//   // back();
//   // return true;
// })

//去商品详情
function againCollage(productId, shopId, skuId, isStartAGroup, item) {
  if (isStartAGroup) {
    uni.navigateTo({
      url: '../goodsModule/goodsDetails?productId=' + productId + '&shopId=' + shopId +
          '&skuId=' +
          skuId
    })
  } else {
    // 跳转详情
    buyAgain(item)
  }
}

async function buyAgain(item) {
  // 循环sku，获取商品详情
  const postAjax = []
  item.skus.forEach(e => {
    postAjax.push(queryProductDetail(e))
  })
  // 并发执行
  const skuDetailList = await Promise.all(postAjax);
  let canNotBuyNameList = []
  // 判断库存
  skuDetailList.forEach(skuDetail => {
    for (const skuDetailSkuMapKey in skuDetail.map) {
      // 判断此SKU是否存在于传进来的item
      const findSku = item.skus.find(findItem => findItem.skuId === skuDetail.map[
          skuDetailSkuMapKey].skuId);
      if (findSku) {
        const skuInfo = skuDetail.map[skuDetailSkuMapKey]
        if (findSku.number > skuInfo.stockNumber) {
          canNotBuyNameList.push(findSku.productName)
        }
      }
    }
  })
  // 如果有库存不足
  if (canNotBuyNameList.length > 0) {
    uni.showToast({
      icon: 'none',
      title: canNotBuyNameList.join(",") + " 库存不足"
    })
    return;
  }
  // 制造数据
  const buyInfo = [{
    ifWork: item.ifWork,
    shopId: item.shopId,
    shopName: item.shopName,
    shopDiscountId: item.shopDiscountId,
    shopSeckillId: item.shopSeckillId,
    skus: item.skus
  }]
  uni.setStorageSync('skuItemDTOList', buyInfo)
  uni.navigateTo({
    url: '../orderModule/orderConfirm?type=1',
  })
}

//获取商品详情
async function queryProductDetail(item) {
  // uni.showLoading({
  //   title: '加载中...',
  //   mask: true
  // })
  $showLoading("加载中...")
  let postData = {
    shopId: item.shopId,
    productId: item.productId,
    skuId: item.skuId,
    terminal: 1
  }
  let productData
  const res = await request(API.QueryProductDetail, postData, "GET")
  $hideLoading()
  return res.data
}

function goInviteSpll(collageId, orderId, productId, skuId, shopGroupWorkId) {
  uni.navigateTo({
    url: '../goodsModule/inviteSpell?collageId=' + collageId + '&orderId=' + orderId + '&type=1' +
        '&productId=' + productId + '&skuId=' + skuId + '&shopGroupWorkId=' + shopGroupWorkId
  })
}

function back() {
  uni.navigateTo({
    url: 'index'
  })
}

//商品详情
function goodsItemTap(productId, skuId) {
  uni.navigateTo({
    url: '../goodsModule/goodsDetails?shopId=' + dataList.value.shopId + '&productId=' + productId +
        '&skuId=' + skuId
  })
}

function copy() {
  // #ifdef H5
  let clipboard = new ClipboardJS('.copy-color');
  clipboard.on('success', function (e) {
    uni.showToast({
      title: '复制成功',
      icon: 'success'
    })
    clipboard.destroy();
  })
  clipboard.on('error', function (e) {
    uni.showToast({
      title: '复制失败',
      icon: 'success'
    })
    clipboard.destroy();
  })
  // #endif
  // #ifndef H5
  uni.setClipboardData({
    data: dataList.value.orderFormid,
    success: function () {
      uni.showToast({
        title: '复制成功',
        icon: 'success'
      })
    }
  });
  // #endif
}

function getDataList(orderId) {
  // uni.showLoading({
  //   title: '加载中...',
  // })
  loading.value = true
  request(API.GetOrderDetail, {
    orderId: orderId,
    noticeId: noticeId.value
  }, 'GET').then(res => {
    // uni.hideLoading()
    let data = res.data
    dateformat(res.data.time)
    // console.log(data)
    dataList.value = data
    dataList.value.receivePhone = hidden(dataList.value.receivePhone, 3, 4)
    ifShow.value = true
    getShippingTrace(dataList.value.express, dataList.value.deliverFormid)
    if (dataList.value.state == 1 || dataList.value.state == 6) {
      countDown();
    }
    console.log(dataList.value)
  }).catch(err => {
    // uni.hideLoading()
    throw Error(err)
  }).finally(() => {
    loading.value = false
  })
}

function timeFormat(param) { //小于10的格式化函数
  return param < 10 ? '0' + param : param;
}

function wuLiuTap() {
  isShowWuLiu.value = !isShowWuLiu.value
}


//时分秒换算
function dateformat(micro_second) {
  // 总秒数
  let second = Math.floor(micro_second / 1000);
  // 天数
  let day = Math.floor(second / 3600 / 24);
  // 小时
  let hr = Math.floor(second / 3600 % 24);
  // 分钟
  let minn = Math.floor(second / 60 % 60);
  // 秒
  let secc = Math.floor(second % 60);
  hou.value = hr
  min.value = minn
  sec.value = secc
  remainingTime.value = second

}

function countDown() {
  let timeOuts = setTimeout(() => {
    let hour = parseInt(hou.value);
    let minr = parseInt(min.value);
    let secr = parseInt(sec.value);

    let netxSec = secr - 1;
    let netxMin = minr
    let netxHou = hour;

    if (netxHou == 0 && netxMin == 0 && netxSec == -1) {
      clearTimeout(timeOut.value)
      getDataList(orderId.value)
    } else {
      if (netxSec == -1) {
        netxSec = 59
        netxMin = netxMin - 1;
      }
      if (netxMin == -1) {
        netxMin = 59
        netxHou = netxHou - 1
      }
      if (netxHou == -1) {
        netxHou = 23
      }

      hou.value = timeFormat(netxHou)
      min.value = timeFormat(netxMin)
      sec.value = timeFormat(netxSec)
      timeOut.value = timeOuts
      countDown();
    }
  }, 1000)
}

//物流信息
function getShippingTrace(express, deliverFormid) {
  console.log(express, deliverFormid)
  request(API.ShippingTrace, {
    express: express,
    deliverFormid: deliverFormid
  }, "GET").then(res => {
    let traces = res.data
    let len = traces.length
    for (let i = 0; i < len; i++) {
      let item = traces[i]
      steps.value.push({
        title: item.reason,
        desc: item.time,
      })
    }
    steps.value = steps.value.reverse()
  }).catch(res => {
    throw Error(res)
  })
}

//删除订单
function delOrder() {
  uni.showModal({
    title: '温馨提示',
    content: '您确定要删除该订单吗？',
    confirmText: '确定删除',
    cancelText: '点错了',
    success: res => {
      if (res.confirm) {
        doDel()
      } else if (res.cancel) {
        console.log('用户点击取消')
      }
    }
  })
}

function doDel() {
  // uni.showLoading({
  // 	mask: true,
  // 	title: '提交中...',
  // })
  request(API.DelOrder, {
    orderId: orderId.value
  }, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title: '删除成功',
    })
    setTimeout(() => {
      uni.navigateBack()
    }, 1500);

  }).catch(res => {
    throw Error(res)
    // uni.hideLoading()
  }).finally(() => $hideLoading())
}

//去店铺首页
function goShop(id) {
  uni.navigateTo({
    url: '../store/index?storeId=' + id
  })
}

//退款
function applayItemTap(proItem) {
  if (dataList.value.skus.length > 1) {
    isAllSelect.value = 0
  }
  uni.setStorageSync('applyItem', proItem)
  uni.navigateTo({
    url: 'afterSaleApplyRefund?orderId=' + orderId.value + '&isAllSelect=' + isAllSelect.value
  })
}

//去退款详情
function goApplyTap(code, type) {
  if (type == 1) {
    uni.navigateTo({
      url: 'refundDetails?returnCode=' + code
    })
  } else if (type == 2) {
    uni.navigateTo({
      url: 'returnDetails?returnCode=' + code
    })
  }
}

function applyPlatform(code, type) {
  // uni.navigateTo({
  //   url: `/pages/userCenter/afterSale/platformJoin/index?returnCode=${code}&returnType=${type}`,
  // })
}

//取消订单
function cancelOrder() {
  uni.showModal({
    title: '温馨提示',
    content: '您确定要取消该订单吗？',
    confirmText: '确定取消',
    cancelText: '点错了',
    success: res => {
      if (res.confirm) {
        doCancel()
      } else if (res.cancel) {
        console.log('用户点击取消')
      }
    }
  })
}

function doCancel() {
  // uni.showLoading({
  // 	mask: true,
  // 	title: '提交中...',
  // })
  $showLoading("加载中...")
  request(API.CancelOrder, {
    orderId: orderId.value
  }, 'POST').then(res => {
    // uni.hideLoading()
    uni.showToast({
      title: '取消成功',
    })
    setTimeout(() => {
      getDataList(orderId.value)
    }, 1500);

  }).catch(res => {
    throw Error(res)
    // uni.hideLoading()
  }).finally(() => $hideLoading())
}

async function payOrder() {
  // #ifdef MP-ALIPAY
  showPayTypePopup.value = true
  totalPrice.value = dataList.value.price
  // #endif
  let submitResult = {
    collageId: dataList.value.collageId,
    money: dataList.value.orderPrice,
    orderId: dataList.value.orderId,
    type: 2,
    paymentMode:1
  }
  // #ifdef APP-PLUS || H5 || MP-WEIXIN
  await handleDoPay.call(undefined, submitResult)
  // #endif
}

// 支付宝付款
async function continuePay() {
  await handleDoPay.call(undefined, submitResult)
}

//退款列表
function Orderrefund() {
  request(API.Orderrefund, {
    orderId: orderId.value,
  }, 'GET').then(res => {
    orderRefundList.value = res.data
  }).catch(res => {
    throw Error(res)
  })
}

//申请退款
function applyMoneyAllTap() {
  dataList.value.skus.map(item => {
    if (item.afterState) {
      isAllSelect.value = 0
    }
  })
  if (orderRefundList.value.length === 0) {
    uni.showToast({
      title: '您所有商品已经申请退款，请勿重复申请',
      icon: 'none'
    })
    return
  }
  uni.setStorageSync('afterSaleApplyRefund', orderRefundList.value)
  uni.navigateTo({
    url: `afterSaleApplyRefund?orderId=${ orderId.value }&sellPriceitem=${ dataList.value.price }
					      &isAllSelect=${ isAllSelect.value }`,
  })
}

function confirmReceiptTap() {
  uni.showModal({
    title: '温馨提示',
    content: '确定您已经收到货物，否则会造成财产损失',
    confirmText: '确定收到',
    cancelText: '点错了',
    success: res => {
      if (res.confirm) {
        confirmReceiveGooods()
      } else if (res.cancel) {
        console.log('用户点击取消')
      }
    }
  })
}

//确认收货
function confirmReceiveGooods() {
  // uni.showLoading({
  // 	title: '确认中...',
  // })
  $showLoading("确认中...")

  request(API.ConfirmReceive, {
    orderId: dataList.value.orderId
  }, 'POST').then(res => {
    // uni.hideLoading()
    $hideLoading()
    uni.showToast({
      title: '确认成功',
    })
    uni.navigateTo({
      url: "index?type=4"
    })
  }).catch(res => {
    // uni.hideLoading()
    throw Error(res)
    $hideLoading()
  })
}

// 申请售后
function applyTap() {
  if (orderRefundList.value.length === 0) {
    uni.showToast({
      title: '您所有商品已经申请退款，请勿重复申请',
      icon: 'none'
    })
    return
  }
  uni.setStorageSync('afterSaleApplyRefund', orderRefundList.value)
  let productData = item.value
  let isAllSelect = 1
  let newArr = JSON.parse(JSON.stringify(productData))
  newArr.skus.map((item, index) => {
    console.log("item----", item)
    if (item.afterState) {
      newArr.skus.splice(index, 1)
      isAllSelect = 0
    }
  })
  console.log(isAllSelect, '00000000000')
  uni.navigateTo({
    url: 'afterSaleApply?item=' + JSON.stringify(newArr) + '&isAllSelect=' + isAllSelect
  })
}

// 支付类型变更
function payTypeChange(n) {
  console.log(n, 'target--')
  paymentMode.value = n;
  if (paymentMode.value == 2) {
    huabeiPeriod.value = -1
    fenqiDisabledList.value = [true, true, true]
  } else {
    huabeiPeriod.value = 3
  }
  recalcHuabei()
}

// 重新计算花呗分期的手续费
function recalcHuabei() {
  if (paymentMode.value == 3) {
    fenqiFeeList.value[0] = totalPrice.value * (1 + huabeiFeeRateList.value[0] / 100) / 3
    fenqiFeeList.value[1] = totalPrice.value * (1 + huabeiFeeRateList.value[1] / 100) / 6
    fenqiFeeList.value[2] = totalPrice.value * (1 + huabeiFeeRateList.value[2] / 100) / 12

    chargeFeeList.value[0] = totalPrice.value * (huabeiFeeRateList.value[0] / 100) / 3
    chargeFeeList.value[1] = totalPrice.value * (huabeiFeeRateList.value[1] / 100) / 6
    chargeFeeList.value[2] = totalPrice.value * (huabeiFeeRateList.value[2] / 100) / 12

    var index = 0;
    if (huabeiPeriod.value == 6) {
      index = 1
    } else if (huabeiPeriod.value == 12) {
      index = 2
    }
    chargeFee.value = (totalPrice.value * (huabeiFeeRateList.value[index] / 100))
        .toFixed(2)

    if (totalPrice.value >= 0.03) {
      fenqiDisabledList.value[0] = false
    }
    if (totalPrice.value >= 0.06) {
      fenqiDisabledList.value[1] = false
    }
    if (totalPrice.value >= 0.12) {
      fenqiDisabledList.value[2] = false
    }
  }
}

//花呗分期数变更
function huabeiPeriodChange(n) {
  huabeiPeriod.value = n
  recalcHuabei()
}

// 查询花呗分期配置
function getHuabeiFeeRateList() {
  request(API.GetHuabeiConfig, {}, 'GET').then(res => {
    huabeiChargeType.value = res.data.huabeiChargeType
    if (huabeiChargeType.value == 2) {
      huabeiFeeRateList.value = res.data.huabeiFeeRateList
    }
  })
}

async function openService(shopId) {
  (await Services(shopId)).flyToService()
}

function clip2Decimal(value) {
  if (value === undefined || value === null) {
    return "0.00"
  }
  return (parseInt(value * 100) / 100).toFixed(2)
}
</script>

<style
    lang="scss"
    scoped
>
page {
  background: #f7f7f7;
}

.logistics {
  padding: 20upx 20upx;
}

.content {
  padding: 0 0 160upx 0;
}

.order-details-status {
  width: 750upx;
  height: 250upx;
  background: #333333;
}

.status-title-box {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  padding: 40upx 30upx 0;
  box-sizing: border-box;
  text-align: center;
}

.status-title-box2 {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40upx 30upx 0;
  box-sizing: border-box;
}

.status-title-box .l {
  width: 100%;
  display: flex;
  flex-direction: column;
}

.status-title-box .l .status,
.status-title-box2 .status {
  font-size: 30upx;
  color: #fff;
  min-width: 100rpx;
  min-height: 30rpx;
}

.status-title-box .l .label,
.status-title-box2 .label {
  font-size: 24upx;
  color: #fff;
  margin-top: 14upx;
  min-width: 150rpx;
  min-height: 30rpx;
}

.status-title-box .r {
  width: 80upx;
  height: 80upx;
}

.order-details-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
  margin-top: -80upx;
}

.address-box {
  margin-top: 20upx;
  background: #fff;
  width: 100%;
  padding: 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
}

.address-box .address-img {
  width: 70upx;
  height: 70upx;
  margin-right: 20upx;
}

.address-box .address-r {
  flex: 1;
  display: flex;
  flex-direction: column;
  font-size: 28upx;
  color: #333;
}

.arrow-right-img {
  width: 24upx;
  height: 24upx;
  margin-left: 20upx;
}

.address-name-box {
  font-size: 30upx;
  color: #333;
}

.phone {
  font-size: 24upx;
  color: #999;
  margin-left: 20upx;
}

.address-info {
  font-size: 28upx;
  color: #333;
  margin-top: 15upx;
}

.order-list-box {
  margin: 20upx 0;
  .toService {
    line-height: 40rpx;
    padding: 0 8rpx;
    cursor: pointer;
    display: flex;
    align-items: center;

    .service-img {
      width: 60upx;
      height: 60upx;
      margin-right: 12rpx;
    }

    text {
      line-height: 40rpx;
    }
  }
}

.order-list-box .item {
  margin-bottom: 20upx;
  background: #fff;
}

.order-list-top {
  height: 96upx;
  padding: 0 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #eee;
}

.top-l {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.shop-img {
  width: 34upx;
  height: 34upx;
  margin-right: 10upx;
}

.shop-name {
  font-size: 30upx;
  color: #333;
  font-weight: bold;
}

.arrow-img {
  margin-left: 15upx;
  width: 24upx;
  height: 24upx;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
}

.order-info {
  border-bottom: 1px solid #eee;
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 20upx 0;
}

.product-img {
  width: 180upx;
  height: 180upx;
  border-radius: 10upx;
  margin-right: 30upx;
}

.info-box {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.product-name {
  font-size: 26upx;
  color: #333;
  height: 68upx;
  line-height: 34upx;
  display: -webkit-box;
  overflow: hidden;
  text-overflow: ellipsis;
  word-break: break-all;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.price-sku-box {
  width: 100%;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.product-sku {
  font-size: 24upx;
  color: #999;
  display: inline-block;
  margin-left: -20upx;
  display: flex;
  flex-direction: row;
}

.price-box {
  display: flex;
  flex-direction: column;
}

.product-price1 {
  font-size: 24upx;
  color: #333;
  font-weight: 400;
}

.product-price2 {
  font-size: 24upx;
  color: #999;
  text-decoration: line-through;
  font-weight: 400;
}

.product-price .fuhao {
  font-size: 28upx;
}

.item-applay-btn {
  height: 50upx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  padding: 0 30upx;
  background: rgba(255, 255, 255, 1);
  border: 1px solid rgba(187, 187, 187, 1);
  border-radius: 25upx;
  font-size: 24upx;
  font-weight: 400;
  color: rgba(51, 51, 51, 1);
}

.product-num {
  font-size: 28upx;
  color: #999;
  display: inline-block;
}

.delivery-way-box {
  display: flex;
  flex-direction: column;
  margin: 30upx 0 10upx;
}

.delivery-way-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 26upx;
  color: #333;
}

.delivery-way-box .item .way {
  color: #999;
}

.order-total-box {
  padding: 30upx 0;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 26upx;
  color: #333;
}

.order-total-box .way-color {
  color: #333333;
  font-size: 32rpx;
}

.order-details-information {
  background: #fff;
}

.order-details-information.padd {
  padding: 30upx;
  box-sizing: border-box;
}

.order-details-information .order-title {
  font-size: 30upx;
  color: #333;
  font-weight: 500;
  display: flex;
  flex-direction: row;
  align-items: center;
}

.order-details-information .info-box {
  margin-top: 30upx;
}

.order-details-information .info-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 24upx;
  color: #666;
  margin-bottom: 20upx;
}

.order-details-information .info-box .item .copy-color {
  font-size: 24upx;
  color: #C5AA7B;
}

.order-details-btn {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  min-height: 160upx;
  background: #fff;
  box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.1);
  box-sizing: border-box;
  display: flex;
  padding: 0 30upx;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  z-index: 10;
}

.order-details-btn .btn {
  width: 100%;
  height: 100upx;
  background: #333333;
  font-size: 28upx;
  color: #FFEBC4;
  text-align: center;
  line-height: 100upx;
  font-weight: 500;
}

.order-details-btn .btn-l {
  width: 50%;
  height: 100upx;
  border: 2rpx solid #333333;
  font-size: 28upx;
  color: #333;
  text-align: center;
  line-height: 100upx;
  box-sizing: border-box;
  margin-right: 10rpx;
}

.order-details-btn .btn-r {
  width: 50%;
  margin-left: 10rpx;
}

.mt20 {
  margin-top: 20upx;
}

.order-title-box {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.order-details-information .order-title-box .order-title.padd-l {
  padding-left: 30upx;
}

.arrow-down-img {
  width: 40upx;
  height: 40upx;
  margin: 30upx;
  box-sizing: border-box;
}

.evaluate {
  height: 56upx;
  border-radius: 28upx;
  text-align: center;
  line-height: 56upx;
  font-size: 26upx;
  padding: 0 30upx;
  border: 1px solid #C5AA7B;
  color: #C5AA7B;
}

.evaluate2 {
  height: 56upx;
  border-radius: 28upx;
  text-align: center;
  line-height: 56upx;
  font-size: 26upx;
  padding: 0 30upx;
  border: 1px solid #BBBBBB;
  color: #333;
}

.emptyOrder-box {
  padding: 70upx 0;

  .emptyOrder-img {
    width: 200upx;
    height: 200upx;
  }
}

.pay-type-item {
  .pay-type-radio {
    background-color: white;
    border-bottom: 1upx solid #EDEDED;
    margin-bottom: 20upx;
    padding: 24upx 20upx 24upx 20upx;

    .pay-type-img {
      display: inline-block;

      .pay-type-img-inner {
        width: 50upx;
        height: 50upx;
        vertical-align: middle;
      }
    }

    .pay-type-label {
      vertical-align: middle;
      margin-left: 30upx;
    }

    .pay-type-radio-item {
      float: right;
      margin-right: 20upx;
      width: 50upx;
      height: 50upx;
    }
  }

  .huabei-detail {
    margin-top: 20upx;

    .fenqi-wenzi {
      display: inline-block;
      margin-left: 64upx;
    }

    .fenqi-amount {
      display: block;
      margin-left: 64upx;
      margin-top: 14upx;
      color: #BABBBC;
    }

    .fenqi-charge-fee {
      float: right;
      margin-right: 68upx;
      color: #BABBBC;
    }

    .fenqi-modal {
      width: 40upx;
      height: 40upx;
      margin-left: 20upx;
      float: right;
      position: relative;
      top: -80upx;
    }
  }
}

.paytype-confirm {
  height: 120upx;
  padding: 0upx 108upx 0upx 32upx;

  .fenqi-all {
    display: inline-block;
    width: 100%;
  }

  .fenqi-total-amount {
    width: 65%;
    float: left;
  }

  .fenqi-confirm {
    float: right;
    width: 160upx;
    padding: 0upx 20upx;

    .btn {
      width: 216upx;
      height: 80upx;
      line-height: 80upx;
      font-size: 28upx;
      text-align: center;
      background: #333333;
      color: #FFEBC4;
      display: inline-block;
      margin-right: 66upx;
    }
  }
}

.period-radio {
  margin: 30upx;
  padding-right: 100upx;
  width: 95%;
  border-bottom: 1px solid #EFEFEF;

  .period-amount {
    display: inline-block;

    .period-each-charge {
      display: inline-block;
      margin-top: 12upx;
      margin-left: 6upx;
      font-size: 26rpx;
      color: #b7b7b7;
      margin-bottom: 13upx;
    }
  }

  .period-each {
    display: block;
  }

  .period-type-radio-item {
    float: right;
  }
}
</style>
