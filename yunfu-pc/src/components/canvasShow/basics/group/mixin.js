import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import {
  getGroupWorks,
  getShopGroupWorks
} from '@/components/canvasShow/config/api'
import {funMixin} from '@/components/canvasShow/config/mixin'

export const commonMixin = {
  name: 'productList',
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
      productData: {}
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
        if(this.typeId === 1){
          const response = await getGroupWorks()
          const res = response.data
          this.productData.products = res.data
          this.$forceUpdate()
        } else if(this.typeId === 3) {
          if(this.componentContent.shopGroupWorkId){
            const response = await getShopGroupWorks({
              shopId: this.shopId,
              ids: this.componentContent.shopGroupWorkId
            })
            const res = response.data
            this.productData = res.data[0]
          } else {
            this.productData = {
              products:[]
            }
          }
        }
      },
  }
}
