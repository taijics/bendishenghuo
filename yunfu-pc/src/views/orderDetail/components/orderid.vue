<template>
  <div class="topOrderId">
    <div class="orderid">
      <div>订单号: {{ data.orderId }}</div>
      <div class="countdown" v-if="data.payment === 0 && data.resetTime > 0 && data.state <= 1">
        <icon-svg style="font-size: 20px;" icon-class="order-detail-time" />
        剩余时间：<span>{{ data.resetTime | formatHours}} : {{ data.resetTime | formatMinutes}} : {{ data.resetTime | formatSeconds}}</span>
      </div>
    </div>
    <div class="btns">
      <!-- type 0普通商品 1拼团商品 3售后 -->
      <!-- status 各自类型对应的状态 -->
      <button v-if="(type === 0 && data.status < 2)
      || (type === 1 && data.status === 0)"
        @click="emitIt('cancel')"
      >取消订单</button>
      <button v-if="(type === 0 && data.status === 1 && data.payment === 0)
      || (type === 1 && data.state === 0 && data.payment === 0)"
        class="blackBtn"
        @click="emitIt('pay')"
      >付款</button>
      <button v-if="type === 1 && data.status === 0"
        class="blackBtn"
        @click="emitIt('invite')"
      >邀请好友</button>
      <button v-if="type === 1 && data.status > 0"
        class="blackBtn"
        @click="emitIt('pin')"
      >再开一团</button>
      <button v-if="type === 3 && (data.status === 1 || data.status === 10)"
        class="blackBtn"
        @click="emitIt('revoke')"
      >撤销申请</button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => ({
        orderId: '',
        resetTime: '',
        payment: 0,
        status: null,
        type: null
      })
    },
    type: {
      type: Number,
      default: 0
    }
  },
  data () {
    return {
      setTime: null
    }
  },
  filters: {
    formatHours: function (value) {
      if (!value) {
        return `00`
      }
      let hours = Math.floor(value / (1000 * 60 * 60))
      if (hours < 10 && hours > 0) {
        return '0' + hours
      } else if (hours > 10) {
        return hours
      } else {
        return '00'
      }
    },
    formatMinutes: function (value) {
      if (!value) {
        return `00`
      }
      let minutes = Math.floor((value % (1000 * 60 * 60)) / (1000 * 60))
      if (minutes < 10 && minutes > 0) {
        return '0' + minutes
      } else if (minutes > 10) {
        return minutes
      } else {
        return '00'
      }
    },
    formatSeconds: function (value) {
      if (!value) {
        return `00`
      }
      let seconds = Math.round((value % (1000 * 60)) / 1000)
      if (seconds < 10 && seconds > 0) {
        return '0' + seconds
      } else if (seconds > 10) {
        return seconds
      } else {
        return '00'
      }
    }
  },
  watch: {
    data: {
      handler (nVal, oVal) {
        if (!this.setTime && this.data.payment === 0) {
          this.countDown()
        }
      },
      deep: true
    }
  },
  destroyed () {
    console.log(this.data)
    clearInterval(this.setTime)
  },
  methods: {
    emitIt (emit) {
      if (typeof (emit) !== 'string') {
        return emit
      }
      this.$emit(emit)
    },
    countDown () {
      clearInterval(this.setTime)
      this.setTime = setInterval(() => {
        if (this.data.resetTime >= 1000) {
          this.data.resetTime -= 1000
        } else {
          this.data.resetTime = 0
          clearInterval(this.setTime)
          // window.location.reload()
        }
      }, 1000)
    }
  }
}
</script>

<style lang="scss" scoped>
.topOrderId{
  height: 80px;
  padding: 0 30px;
  background-color: #FAFAFA;
  display: flex;
  justify-content: space-between;
  align-items: center;
  .orderid{
    width: 40%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .countdown{
      span{
        color: #C83732;
      }
    }
  }
  button{
    width: 200px;
    height: 50px;
    color: $mainGlod;
    background-color: #FFF;
    font-family: Microsoft YaHei;
    cursor: pointer;
  }
  .blackBtn{
    background-color: #333;
  }
}
</style>
