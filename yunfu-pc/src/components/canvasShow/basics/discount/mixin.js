import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import {
  getDiscount,
  getShopDiscounts
} from '@/components/canvasShow/config/api.js'
import {funMixin} from '@/components/canvasShow/config/mixin'

export const commonMixin = {
  name: 'discountList',
  mixins: [funMixin],
  data () {
    return {
      value: 100,
      productData: {},
      count: [],
      timer: null,
      ifPreheat: false, // 是否预热
    }
  },
  props: {
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
    componentContent: {
      type: Object
    }
  },
  components: {
    Swiper,
    SwiperSlide
  },
  directives: {
    swiper: directive
  },
  watch: {
    'componentContent': {
      handler(newVal, oldVal) {
        this.getData()
      },
      deep: true
    }
  },
  created() {
    this.getData()
  },
  methods: {
    async getData() {
      if(this.componentContent.discountId){
        let params = {
          ids: this.componentContent.discountId
        }, res;
        if(this.typeId === 1){
          const response = await getDiscount(params)
          res = response.data
        }
        if(this.typeId === 3){
          params.shopId = this.shopId
          const response = await getShopDiscounts(params)
          res = response.data
        }
        if(res.data.length> 0){
          this.productData = res.data[0]
          this.ifPreheat = this.productData.ifEnable === 2 && this.productData.state === 0
          // 只有进行中和未开始活动, 用倒计时
          if(this.productData.state !==2) {
            this.timer = setInterval(()=>{
              this.getTime(this.productData)
            }, 1000)
          }
        }
      } else {
        this.productData = {
          products:[]
        }
      }
    },
    getTime(info) {
      const date = new Date().getTime()
      const startTime = new Date(info.startTime.replace(/-/g,'/')).getTime()
      const endTime = new Date(info.endTime.replace(/-/g,'/')).getTime()
      if(startTime > date) {
        this.countDown(startTime-date,true) // 未开始
      } else {
        this.countDown(endTime-date) // 进行中
      }

    },
    countDown(time, isStart) {
      const fn = (v) =>  v < 10 ? `0${v}` : v
      const t = parseInt(time / 1000)
      const text = isStart ? '开始' : '结束'
      const hour = parseInt(t / 3600)
      const min = parseInt((t % 3600) / 60)
      const s = t % 60
      this.count = [text, fn(hour), fn(min), fn(s)]
    }
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
