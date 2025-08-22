import api from '../../config/api'
import { funMixin } from '../../config/mixin'
import { ref, onMounted, onBeforeUnmount, watch } from 'vue';

export default function (componentContent, typeId, shopId) {
  const { sendReq, jumpProductDetail, jumpSeckills } = funMixin()
  const state = ref(0)
  const productData = ref({
    products: [],
  })
  const count = ref([])
  const timer = ref(null)

  onMounted(() => {
    getData()
  })

  onBeforeUnmount(() => {
    clearInterval(timer.value)
  })

  function getData() {
    if(componentContent.value.shopSeckillId){
      if(typeId.value === 1){
        const params = {
          method: 'GET',
          url: `${api.getPlatformSeckills}?ids=${componentContent.value.shopSeckillId}`,
        }
        sendReq(params, (res) => {
          if(res.data.length> 0){
            productData.value = res.data[0]
            productData.value.products.map(function(value){
              value.sliderVal = (value.stockNumber/value.total*100).toFixed(2)
              return value;
            });
            // 只有进行中和未开始活动, 用倒计时
            timer.value = setInterval(()=>{
              getTime(productData.value)
            }, 1000)
          }
        })
      }
      if(typeId.value === 3){
        const params = {
          method: 'GET',
          url: `${api.getSeckills}?shopId=${shopId.value}&ids=${componentContent.value.shopSeckillId}`,
        }
        sendReq(params, (res) => {
          if(res.data.length> 0){
            productData.value = res.data[0]
            productData.value.products.map(function(value){
              value.sliderVal = (value.stockNumber/value.total*100).toFixed(2)
              return value;
            });
            // 只有进行中和未开始活动, 用倒计时
            if(productData.value.state !==2) {
              timer.value = setInterval(()=>{
                getTime(productData.value)
              }, 1000)
            }
          } else {
            productData.value = {
              products:[]
            }
          }
        })
      }
    } else {
      productData.value = {
        products:[]
      }
    }
  }
  function getTime (info) {
    const date = new Date().getTime()
    let startTime = ''
    let endTime = ''
    if (typeId.value === 1) {
      startTime = new Date(info.startTime.replace(/-/g, '/')).getTime()
      endTime = new Date(info.endTime.replace(/-/g, '/')).getTime()
    } else {
      startTime = new Date(info.effectiveStart.replace(/-/g, '/')).getTime()
      endTime = new Date(info.effectiveEnd.replace(/-/g, '/')).getTime()
    }
    if (date > endTime) {
      state.value = 2
    } else if (startTime > date) {
      state.value = 0
      countDown(startTime - date) // 未开始
    } else {
      state.value = 1
      countDown(endTime - date) // 进行中
    }
  }
  function countDown (time) {
    const fn = (v) => (v < 10 ? `0${v}` : v)
    const t = parseInt(time / 1000)
    const text = state.value === 0 ? '开始' : '结束'
    const hour = parseInt(t / 3600)
    const min = parseInt((t % 3600) / 60)
    const s = t % 60
    // console.log(min, '分',t)
    count.value = [text, fn(hour), fn(min), fn(s)]
    // console.log(text, fn(hour), fn(min), fn(s))
  }

  return {
    state,
    productData,
    count,
    jumpProductDetail,
    jumpSeckills
  }
}
