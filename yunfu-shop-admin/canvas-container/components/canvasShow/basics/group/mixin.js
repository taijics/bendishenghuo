import { directive, Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import api from '../../config/api'
import {funMixin} from '../../config/mixin'
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
  computed: {
    ...mapGetters([
      'groupNum'
    ]),
  },
  watch: {
    'groupNum': {
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
        let _url = ''
        if(_.typeId === 1){
          this.beforeGetData()
          const params = {
            method: 'GET',
            url: `${api.getAdminGroupWorks}`,
          }
          this.sendReq(params, (res) => {
            _.afterGetData()
            _.productData.products = res.data
            _.$forceUpdate()
          },(err)=>{
            _.afterGetData()
          })
        } else if(_.typeId === 3) {
          if(_.componentContent.shopGroupWorkId){
            this.beforeGetData()
            const params = {
              method: 'GET',
              url: `${api.getGroupWorks}?shopId=${_.shopId}&ids=${_.componentContent.shopGroupWorkId}`,
            }
            this.sendReq(params, (res) => {
              _.afterGetData()
              _.productData = res.data[0]
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
