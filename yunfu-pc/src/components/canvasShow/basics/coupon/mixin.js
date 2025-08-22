import {
  getCoupons,
  getShopCoupons
} from '../../config/api'
import { funMixin } from '../../config/mixin'

export const commonMixin = {
  name: 'textComponent',
  mixins: [funMixin],
  data () {
    return {
      couponsData: []
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
      const _ = this
      if(_.componentContent.selectedCoupon && _.componentContent.selectedCoupon.length > 0){
        let params = {
          page: 1,
          pageSize: 99,
          ids: `${this.componentContent.selectedCoupon}`
        }
        if(this.typeId === 1){
          const response = await getCoupons(params)
          this.successCallback(response.data)
        } else if(this.typeId === 3) {
          params.shopId = this.shopId
          const response = await getShopCoupons(params)
          this.successCallback(response.data)
        }
      } else {
        this.couponsData = []
      }
    },
    successCallback(res) {
      this.couponsData = res.data.list
      if(JSON.stringify(this.componentContent.couponList) !== JSON.stringify(this.couponsData)){
        this.componentContent.couponList = this.couponsData
      }
    }
  }
}
