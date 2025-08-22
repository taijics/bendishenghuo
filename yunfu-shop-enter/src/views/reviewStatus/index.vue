<template>
  <div class="warp12">
    <div class="statusBox">
      <cent-logo></cent-logo>
      <div class="statusCent">
        <div class="status">
<!--          <img src="../../assets/images/shenhezhong.png" alt="">-->
          <img src="../../assets/images/tijiaochengong.svg" alt="">
          <h3>提交成功</h3>
          <p>我们已收到您的入驻申请，将会在10个工作日内审核完毕， 审核结果将以短信形式发送至您的手机号</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CentLogo from '@/components/centLogo'
export default {
  name: 'index',
  components: {CentLogo},
  methods: {
    goToHome () {
      this.$router.push({name: 'home'})
    }
  }
}
</script>

<style lang="scss" scoped>
.statusBox {
  .statusCent {
    width: 100%;
    background: #ffffff;
    border-radius: 10px;
    height: 620px;
    display: flex;
    align-items: center;
    justify-content: center;
    .status {
      text-align: center;
      width: 460px;
      margin: 0 auto;
      img {
        width: 110px;
        margin-bottom: 28px;
      }
      h3 {
        color: #333333;
        font-size: 26px;
        font-weight: 400;
        margin-bottom: 28px;
      }
      p {
        color: #999999;
        font-size: 18px;
        line-height: 30px;
      }
    }
  }
}
</style>
