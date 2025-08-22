import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import api from '../../config/api'
import {funMixin} from '../../config/mixin'
import { mapGetters } from 'vuex'

export const commonMixin = {
  name: 'discountList',
  mixins: [funMixin],
  data () {
    return {
      value: 100,
      productData: {},
      count: [],
      timer: null
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
  computed: {
    ...mapGetters([
      'discountNum'
    ]),
  },
  watch: {
    'discountNum': {
      handler(newVal, oldVal) {
        this.getData()
      },
      deep: true
    }
  },
  mounted() {
      this.getData()
  },
  methods: {
    getData() {
      const _ = this
      if(_.componentContent.discountId){
        this.beforeGetData()
        var _url= ''
        if(this.typeId === 1){
          _url= `${api.getMinDiscount}?ids=${_.componentContent.discountId}`
        }
        if(this.typeId === 3){
          _url= `${api.getDiscounts}?shopId=${_.shopId}&ids=${_.componentContent.discountId}`
        }
        const params = {
          method: 'GET',
          url: _url,
        }
        this.sendReq(params, (res) => {
          _.afterGetData()
          if(res.data.length> 0){
            _.productData = res.data[0]
            // 只有进行中和未开始活动, 用倒计时
            if(_.productData.state !==2) {
              this.timer = setInterval(()=>{
                _.getTime(_.productData)
              }, 1000)
            }
          }
        },(err)=>{
          _.afterGetData()
        })
      } else {
        _.productData = {
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
