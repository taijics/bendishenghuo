import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import {
  getFixedPrices
} from '../../config/api'
import {funMixin} from '../../config/mixin'

export const commonMixin = {
  name: 'price',
  mixins: [funMixin],
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
  data () {
    return {
      productData: []
    }
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
        console.log(this.componentContent)
        const ids = !this.componentContent.priceId ? this.componentContent.productData.productIdList : [this.componentContent.priceId]
        // 商家定价捆绑数据
        const response = await getFixedPrices({
          shopId: this.shopId,
          ids: ids.toString(),
          page: 1,
          pageSize: this.componentContent.productRowNum * this.componentContent.productNum
        })
        const res = response.data
        this.productData = res.data[0] || []
      },
  }
}
