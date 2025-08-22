import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import {funMixin} from '../../config/mixin'
import 'swiper/css/swiper.css'
import {
  getProducts
} from '../../config/api'

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
      productData: []
    }
  },
  mounted() {
    this.getData(true)
  },
  watch: {
    'componentContent': {
      handler(newVal, oldVal) {
        this.getData()
      },
      deep: true
    }
  },
  computed: {
    swiper() {
      if(this.$refs.mySwiper){
        return this.$refs.mySwiper.$swiper
      }
    }
  },
  methods: {
    async getData(isFirst) {
      const _ = this
      let params = {
        page: 1,
        pageSize: 99
      }
      if (this.componentContent.productData.sourceType === '1') {

        if(this.componentContent.productData.productIdList
          && this.componentContent.productData.productIdList.length > 0){
            params.ids = `${this.componentContent.productData.productIdList}`
        } else {
          this.productData = []
          return
        }
      } else if(this.componentContent.productData.sourceType === '2'){
        if(this.componentContent.productData.categoryId) {
          params.classifyId = this.componentContent.productData.categoryId
        } else {
          this.productData = {
            products:[]
          }
          return
        }
      } else {
        return
      }
      console.log('newProduct')
      const response = await getProducts(params)
      const res = response.data
      this.productData = res.data.list
      if(isFirst){
        this.componentContent.productData.imgTextData = this.productData
      }
      this.$forceUpdate() // 刷新轮播图
    },
  }
}
