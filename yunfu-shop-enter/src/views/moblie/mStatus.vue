<template>
  <div class="mStatus">
    <div class="statusCent">
      <div class="status">
        <!--          <img src="../../assets/images/shenhezhong.png" alt="">-->
        <img src="../../assets/images/tijiaochengong.png" alt="">
        <h3>提交成功</h3>
        <p>我们已收到您的入驻申请，将会在10个工作日内审核完毕， 审核结果将以短信形式发送至您的手机号</p>
      </div>
      <div class="btnBack" @click="goToHome">返回首页</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'mStatus',
  methods: {
    goToHome () {
      this.$router.push({name: 'home'})
    }
  }
}
</script>

<style lang="scss" scoped>
  .mStatus {
    display: flex;
    height: 100%;
    align-items: center;
    justify-content: center;
    .statusCent {
      .status {
        text-align: center;
        img {
          width: 140px;
          height: 140px;
        }
        h3 {
          font-size: 18px;
          color: #333333;
          margin: 20px 0;
        }
        p {
          width: 80%;
          margin: 0 auto;
          color: #999999;
          font-size: 12px;
          line-height: 25px;
        }
      }
      .btnBack {
        width: 80px;
        height: 35px;
        line-height: 35px;
        background: #FFEBC4;
        color: #FFFFFF;
        font-size: 14px;
        text-align: center;
        cursor: pointer;
        margin: 30px auto 0 auto;
        border-radius: 4px;
      }
    }
  }
</style>
