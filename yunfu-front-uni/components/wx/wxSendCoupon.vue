<template>
    <view class="warp">
        <!-- #ifdef MP-WEIXIN -->
        <send-coupon
          v-if="cParams"
          @sendcoupon="sendcoupon"
          @userconfirm="userconfirm"
          :send_coupon_params="cParams.send_coupon_params"
          :sign="cParams.sign"
          :send_coupon_merchant="cParams.send_coupon_merchant"
        >
            <slot></slot>
        </send-coupon>
        <view v-else @click.stop="receiveCoupon">
            <slot></slot>
        </view>
        <!-- #endif -->
        <!-- #ifndef MP-WEIXIN -->
        <view @click.stop="receiveCoupon">
            <slot></slot>
        </view>
        <!-- #endif -->

        <!-- 优惠券领取 -->
        <tui-modal :show="confirmVisible" :custom="true" :fadein="true">
            <view class="Put-box1">
                <view class="text-align fs34 fs-bold">
                    是否领取此优惠券
                </view>
                <view class="flex-display flex-sp-between">
                    <view class="btn" @click="confirmVisible = false">
                        取消
                    </view>
                    <view class="btn submit" @click="receive">
                        确定
                    </view>
                </view>
            </view>
        </tui-modal>
    </view>
</template>

<script setup>
import { ref, onMounted, defineEmits } from "vue"
import { request } from "../../utils/request"
import API from "@/config/api"
import tuiModal from "@/components/modal/modal"
const props = defineProps({
  couponList: {
    type: Array,
    default: () => []
  },
  isExchange: {
    type: Boolean,
    default: false
  }
  // 卡券无法加询问
  // isConfirm: {
  //     type: Boolean,
  //     default: false
  // }
})
const cParams = ref('')
const confirmVisible = ref(false)
const successList = ref([])

const emits = defineEmits(['success', 'closeAd'])

onMounted(() => {
  let ids = []
  props.couponList.forEach(item=>{
    if(item.cardId){
      ids.push(item.cardId)
    }
    // 解除app h5不能领券问题
    successList.value.push(item)
  })
  // #ifdef MP-WEIXIN
  if(ids && ids.length > 0){
    buildParam4Plug(ids)
  }
  // #endif
})

/**
 * 获取微信卡券参数
 */
const buildParam4Plug = async (ids) => {
  try {
    const res = await request(API.buildParam4Plug, ids, 'POST')
    cParams.value = res.data
  } catch (err) {
    throw Error(err)
  }
}

/**
 * 领取优惠券
 */
const receiveCoupon = async () => {
  // #ifdef MP-WEIXIN
  if(successList.value.length > 0){
    const res = uni.getStorageSync('storage_key'),token = res.token;
    if (token) {
      if(props.isExchange){
        // 积分兑换
        let paramsData = {
          couponId: props.couponList[0].couponId,
          source: 3
        }
        try {
          const res = await request(API.exchangeCoupon, paramsData, 'POST')
          emits('success')
        } catch (err) {
          throw Error(err)
        }
      } else {
        if (props.couponList.length === 1 && props.couponList[0].ifCredit) {
          // 单个积分兑换的卡券去积分中心兑
          uni.navigateTo({
            url: `../integral/exchangeDetail?data=${JSON.stringify(props.couponList[0])}`
          })
        } else {
          let params = []
          successList.value.forEach(item=>{
            params.push({
              couponId: item.couponId,
              couponCode: item.couponCode,
              source: 1
            })
          })
          // 领取优惠卷
          try {
            const res = await request(API.takeBatchCoupon, params, 'POST')
            if (res.code === '200') {
              // uni.showToast({
              //   title:'领取成功',
              // })
              emits('success')
              if(!cParams.value){
                emits('closeAd')
              }
            }
          } catch (err) {
            if(res.data.code !== '200'){
              uni.showToast({
                title:res.data.message,
                icon:"none"
              })
            }
            throw Error(err)
          }
        }
      }
    } else {
      uni.showToast({
        title:'请先登录',
        icon:"none"
      })
      uni.navigateTo({
        url:'/pages_category_page2/userModule/login'
      })
    }
  } else {
    emits('closeAd')
  }
  // #endif
}

/**
 * 领取优惠券回调
 */
const sendcoupon = (e) => {
  console.log('领取了微信卡券', e)
  const errcode = e.detail.errcode,resultList = e.detail.send_coupon_result
  switch (errcode) {
    case 'OK':
      break
    case 'PARAM_ERROR':
      console.log('参数错误，请开发者查看msg中具体的错误信息并进行修复处理')
      break
    case 'USER_NOT_EXISTS':
      console.log('登录态获取失效')
      break
    case 'USER_GET_FAILED':
      console.log('登录态获取失败')
      break
    case 'SIGN_ERROR':
      console.log('签名错误')
      break
    case 'SYSTEMERROR':
      console.log('发券超时')
      break
    case 'FREQUENCY_LIMITED':
      console.log('发券频率过高')
      break
  }
  if(errcode === 'OK'){
    resultList.forEach(item=>{
      let cName = ''
      props.couponList.forEach(citem=>{
        if(item.stock_id === citem.cardId){
          cName = citem.activityName
          if(item.code === 'SUCCESS'){
            citem.couponCode = item.coupon_code
            successList.value.push(citem)
          }
        }
      })
      switch (item.code) {
        case 'FAILED':
          console.log('该张券发券失败，查看message中的具体错误信息')
          break
        case 'NOTENOUGH':
          uni.showToast({
            title:cName + '优惠券已被领取完',
            icon:"none"
          })
          console.log('总预算用完')
          break
        case 'DAYLIMIT':
          uni.showToast({
            title:cName + '优惠券领取张数已达到上限',
            icon:"none"
          })
          console.log('用户达到单天限领')
          break
        case 'NATURELIMIT':
          uni.showToast({
            title:cName + '优惠券领取张数已达到上限',
            icon:"none"
          })
          console.log('用户自然人限领')
          break
        case 'MAXQUOTA':
          uni.showToast({
            title:cName + '优惠券领取张数已达到上限',
            icon:"none"
          })
          console.log('用户领取张数达到上限')
          break
        case 'DUPREQUEST':
          uni.showToast({
            title:cName + '优惠券领取张数已达到上限',
            icon:"none"
          })
          console.log('已通过该发券凭证给用户发券')
          break
        case 'NOTRUNNING':
          console.log('批次状态非运营中')
          break
        case 'EXPIRED':
          uni.showToast({
            title:cName + '优惠券已过期',
            icon:"none"
          })
          console.log('该批次已过期')
          break
        case 'NOTMONEY':
          console.log('账户余额不足')
          break
        case 'USERLIMIT':
          console.log('用户已超限领额度')
          break
        case 'FREQUENCYLIMIT':
          console.log('超过频率限制')
          break
      }
    })
    receiveCoupon()
  } else {
    emits('closeAd')
  }
}
/**
 * 用户确认领券事件
 */
const userconfirm = (e) =>{
  console.log('用户确认领券', e)
  emits('closeAd')
}

const receive = () => {
  console.log(1)
}
</script>
