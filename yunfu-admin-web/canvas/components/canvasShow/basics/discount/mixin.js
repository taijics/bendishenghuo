import 'swiper/swiper.css';
import api from '../../config/api'
import {
  funMixin
} from '../../config/mixin'
import {
  ref,
  onMounted,
  onBeforeUnmount,
  watch
} from 'vue';
import {
  canvasStore
} from '@@/store/canvas'
import {
  storeToRefs
} from 'pinia';
const canvasStoreObj = canvasStore();

export default function (componentContent, typeId, shopId) {
  const {
    sendReq,
    beforeGetData,
    afterGetData,
    jumpProductDetail,
    jumpGroupWorks
  } = funMixin()
  const {
    discountNum
  } = storeToRefs(canvasStoreObj);
  const value = ref(100)
  const productData = ref({
    products: []
  })
  const count = ref([])
  const timer = ref(null)

  onMounted(() => {
    getData()
  })

  onBeforeUnmount(() => {
    clearInterval(timer.value)
  })

  function getData () {
    if (componentContent.value.discountId) {
      beforeGetData()
      var _url = ''
      if (typeId.value === 1) {
        _url = `${api.getMinDiscount}?ids=${componentContent.value.discountId}`
      }
      if (typeId.value === 3) {
        _url = `${api.getDiscounts}?shopId=${shopId.value}&ids=${componentContent.value.discountId}`
      }
      const params = {
        method: 'GET',
        url: _url,
      }
      sendReq(
        params,
        (res) => {
          afterGetData()
          if (res.data.length > 0) {
            productData.value = res.data[0]
            // 只有进行中和未开始活动, 用倒计时
            if (productData.value.state !== 2) {
              timer.value = setInterval(() => {
                getTime(productData.value)
              }, 1000)
            }
          }
        },
        () => {
          afterGetData()
        }
      )
    } else {
      productData.value = {
        products: [],
      }
    }
  }

  function getTime (info) {
    const date = new Date().getTime()
    const startTime = new Date(info.startTime.replace(/-/g, '/')).getTime()
    const endTime = new Date(info.endTime.replace(/-/g, '/')).getTime()
    if (startTime > date) {
      countDown(startTime - date, true) // 未开始
    } else {
      countDown(endTime - date) // 进行中
    }
  }

  function countDown (time, isStart) {
    const fn = (v) => (v < 10 ? `0${v}` : v)
    const t = parseInt(time / 1000)
    const text = isStart ? '开始' : '结束'
    const hour = parseInt(t / 3600)
    const min = parseInt((t % 3600) / 60)
    const s = t % 60
    count.value = [text, fn(hour), fn(min), fn(s)]
  }

  watch(() =>
    discountNum,
  (newVal) => {
    getData()
  }, {
    immediate: false,
    deep: true
  })

  return {
    value,
    productData,
    count,
    jumpProductDetail,
    jumpGroupWorks
  }
}
