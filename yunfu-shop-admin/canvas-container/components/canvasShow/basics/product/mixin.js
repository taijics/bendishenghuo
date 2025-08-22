import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import {funMixin} from '../../config/mixin'
import 'swiper/css/swiper.css'
import api from '../../config/api'
import { mapGetters } from 'vuex'

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
  watch: {
    'productNum': {
      handler(newVal, oldVal) {
        this.getData()
      },
      deep: true
    }
  },
  mounted() {
    this.getData(true)
  },
  computed: {
    ...mapGetters([
      'productNum'
    ]),
    swiper() {
      if(this.$refs.mySwiper){
        return this.$refs.mySwiper.$swiper
      }
    }
  },
  methods: {
    getData(isFirst) {
      const _ = this
      if (_.componentContent.productData.sourceType === '1') {
        if(_.componentContent.productData.productIdList && _.componentContent.productData.productIdList.length>0){
          this.beforeGetData()
          _.sendReq({
            url: `${api.getProducts}?page=1&pageSize=99&ids=${_.componentContent.productData.productIdList}`,
            method: 'GET'
          }, (proRes) => {
            _.afterGetData()
            _.productData = proRes.data.list
            if(isFirst){
              _.componentContent.productData.imgTextData = _.productData
            }
          },(err)=>{
            _.afterGetData()
          })
        } else {
          _.productData = []
        }
      } else if(_.componentContent.productData.sourceType === '2'){
        if(_.componentContent.productData.categoryId) {
          this.beforeGetData()
          _.sendReq({
            url: `${api.getProducts}?page=1&pageSize=99&classifyId=${_.componentContent.productData.categoryId}`,
            method: 'GET'
          }, (proRes) => {
            _.afterGetData()
            _.productData = proRes.data.list
            if(isFirst){
              _.componentContent.productData.imgTextData = _.productData
            }
            // _.swiper.update()
          },(err)=>{
            _.afterGetData()
          })
        } else {
          _.productData = {
            products:[]
          }
        }
      }
    },
  }
}
