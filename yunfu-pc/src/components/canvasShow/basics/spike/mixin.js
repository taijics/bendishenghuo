import {
  getPlatformSeckills,
  getSeckills
} from '../../config/api'
import {funMixin} from '../../config/mixin'

export const commonMixin = {
  name: 'spikeList',
  mixins: [funMixin],
  data () {
    return {
      productData: {
        products: []
      },
      count: [],
      state: 0,
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
  created() {
    this.getData()
  },
  methods: {
    async getData() {
      if(this.componentContent.shopSeckillId){
        console.log(this.componentContent)
        let params = {
          ids: `${this.componentContent.shopSeckillId}`
        }
        if(this.typeId === 1){
          const response = await getPlatformSeckills(params)
          const res = response.data
          if(res.data.length> 0){
            this.successCallback(res)
            this.timer = setInterval(()=>{
              this.getTime(this.productData)
            }, 1000)
          }
        }
        if(this.typeId === 3){
          params.shopId = this.shopId
          const response = await getSeckills(params)
          const res = response.data
          if(res.data.length> 0){
            this.successCallback(res)
            // 只有进行中和未开始活动, 用倒计时
            if(this.productData.state !==2) {
              this.timer = setInterval(()=>{
                this.getTime(this.productData)
              }, 1000)
            }
          } else {
            this.productData = {
              products:[]
            }
          }
        }
      } else {
        this.productData = {
          products:[]
        }
      }
    },
    successCallback(res) {
      this.productData = res.data[0]
      this.productData.products.map(function(value){
        value.sliderVal = (value.stockNumber/value.total*100).toFixed(2)
        return value;
      });
    },
    getTime(info) {
      const date = new Date().getTime()
      let startTime = ''
      let endTime = ''
      if(this.typeId === 1){
        startTime = new Date(info.startTime.replace(/-/g,'/')).getTime()
        endTime = new Date(info.endTime.replace(/-/g,'/')).getTime()
      } else {
        startTime = new Date(info.effectiveStart.replace(/-/g,'/')).getTime()
        endTime = new Date(info.effectiveEnd.replace(/-/g,'/')).getTime()
      }
      if(date > endTime){
        this.state = 2
      } else if(startTime > date) {
        this.state = 0
        this.countDown(startTime-date) // 未开始
      } else {
        this.state = 1
        this.countDown(endTime-date) // 进行中
      }

    },

    countDown(time) {
      const fn = (v) =>  v < 10 ? `0${v}` : v
      const t = parseInt(time / 1000)
      const text = this.state == 0 ? '开始' : '结束'
      const hour = parseInt(t / 3600)
      const min = parseInt((t % 3600) / 60)
      const s = t % 60
      // console.log(min, '分',t)
      this.count = [text, fn(hour), fn(min), fn(s)]
      // console.log(text, fn(hour), fn(min), fn(s))
    }
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
