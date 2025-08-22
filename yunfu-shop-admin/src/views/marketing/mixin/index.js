export default {
  data() {
    return {
      activityVisible: false,
      activityId: 0,
      visitDetail: false
    }
  },
  methods: {
    addActivity() {
      this.activityId = 0
      this.activityVisible = true
      this.visitDetail = false
    },
    editActivity(id) {
      this.activityId = id
      this.activityVisible = true
      this.visitDetail = false
      if (this.$refs.addCoupon) {
        this.$refs.addCoupon.getCouponInfo()
      }
    },
    visitActivity(id) {
      this.activityId = id
      this.activityVisible = true
      this.visitDetail = true
      if (this.$refs.addCoupon) {
        this.$refs.addCoupon.getCouponInfo()
      }
    },
    reset() {
      this.activityVisible = false
      this.getAll(this.formInline)
    }
  }
}
