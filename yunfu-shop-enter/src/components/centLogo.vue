<template>
  <div class="statusTop">
    <div class="
    ">
      <img src="static\imgs\pc\personal-logo.svg" alt="">
    </div>
    <p>请认真填写申请信息，以便我们为您提供更好的服务！</p>
  </div>
</template>

<script>
export default {
  name: 'centLogo'
}
</script>

<style lang="scss" scoped>
.statusTop {
  // width: 350px;
  width: 500px;
  margin: 50px auto 40px auto;
  .topLogo {
    text-align: center;
    width: 100%;
    height: 60px;
    background: url("../assets/images/personal-bc.webp") no-repeat bottom center;
    .img {
      width: 211px;
      height: 410px;
    }
  }
  p {
    color: #FFEBC4;
    font-size: 14px;
    margin-top: 20px;
    text-align: center;
  }
}
</style>
