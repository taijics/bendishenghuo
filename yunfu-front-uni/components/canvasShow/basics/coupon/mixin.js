import api from '../../config/api'
import { funMixin } from '../../config/mixin'
import { ref, onMounted, watch } from 'vue'
import {request} from "../../../../utils/request"

export default function(componentContent, typeId, shopId) {
  const { sendReq, jumpStore } = funMixin()
  const couponsData = ref([])

  onMounted(() => {
    getData()
  })

   function getData() {
    if(componentContent.value.selectedCoupon && componentContent.value.selectedCoupon.length > 0){
      let _url = ''
      if(typeId.value === 1){
        _url =`${api.getCoupons}?page=1&pageSize=99&ids=${componentContent.value.selectedCoupon}`
      } else if(typeId.value === 3) {
        _url =`${api.getShopCoupons}?page=1&pageSize=99&shopId=${shopId.value}&ids=${componentContent.value.selectedCoupon}`
      }
      const params = {
        method: 'GET',
        url: _url,
      }
      sendReq(params, (res) => {
        couponsData.value = res.data.list
        if(typeId.value === 1){
          couponsData.value.forEach(item=>{
            item.couponName = item.activityName
            item.effectiveStart = item.activityStartTime
            item.effectiveEnd = item.activityEndTime
          })
        }
        if(JSON.stringify(componentContent.value.couponList) !== JSON.stringify(couponsData.value)){
          componentContent.value.couponList = couponsData.value
        }
      })
    } else {
      couponsData.value = []
    }
  }
  // 领取优惠券
  function receiveCoupon(item) {
    const res = uni.getStorageSync('storage_key');
    const token = res.token
    if (token) {
      var paramsData = {}
      if(typeId.value === 1){
        paramsData.couponId = item.couponId
      } else if(typeId.value === 3) {
        paramsData.shopCouponId = item.shopCouponId
        paramsData.shopId = shopId.value
      }
      request(api.takeCoupon, paramsData, 'POST').then(res => {
        getData()
        uni.showToast({
          title:'领取成功',
          icon:"success"
        })
      }).catch(err => {
        if(res.data.code !== '200'){
          uni.showToast({
            title:res.data.message,
            icon:"none"
          })
        }
        throw Error(err)
      })
    } else {
      uni.showToast({
        title:'请先登录',
        icon:"none"
      })
      uni.navigateTo({
        url:'/pages_category_page2/userModule/login'
      })
    }
  }

  return {
    componentContent,
    couponsData,
    receiveCoupon,
    jumpStore
  }
}
