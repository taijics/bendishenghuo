<template>
  <div class="footer">
      <div class="banxin">
        <div class="top">
            <div class="leftBox">
                <p class="title">客服电话</p>
                <p class="number">188 1411 4118</p>
                <p class="time">09:00-23:00</p>
                <div class="consult">咨询客服</div>
            </div>
            <div class="centerBox">
                <p class="title">关注CERESHOP</p>
                <p>专注于客单价，转化率提升！</p>
                <p>便捷高效，助力各大商家提升客单价，</p>
                <p>客户引导，提高复购，</p>
                <p>只为更好的服务每一位用户。</p>
            </div>
            <div class="rightBox">
                <div class="aboutUs">
                    <p class="title">关于我们</p>
                    <p class="cur-poi">了解我们</p>
                    <p class="cur-poi">合作咨询</p>
                    <p class="cur-poi">联系我们</p>
                </div>
                <div class="qrCode">
                    <p class="title">下载CERESHOP</p>
                    <img src="../../../static/image/qrcode.png" alt="">
                </div>
            </div>
        </div>
        <p class="bottom">&copy;2017-2021CERESHOP版权所有，并保留所有权利 粤ICP备19086489号-3</p>
      </div>
  </div>
</template>
<script>
export default {
  data () {
    return {}
  }
}
</script>
<style lang = "scss" scoped>
.footer{
    width: 100%;
    height: 384px;
    background-color: #000000;
    opacity: 0.82;
    color: #FFFFFF;
    overflow: hidden;
    .banxin{
        width: 1252px;
        height: 100%;
        margin: 0 auto;
        .top{
            margin-top: 100px;
            display: flex;
            margin-bottom: 38px;
            text-align: center;
            .leftBox{
                flex: 1;
                display: flex;
                flex-direction: column;
                .title{
                    font-size: 16px;
                    margin-bottom: 33px;
                }
                .number{
                    font-size: 40px;
                    margin-bottom: 12px;
                    font-weight: 500;
                }
                .time{
                    font-size: 18px;
                    margin-bottom: 33px;
                }
                .consult{
                    cursor: pointer;
                    margin: 0 auto;
                    width: 220px;
                    height: 36px;
                    line-height: 36px;
                    border: 1px solid #FFFFFF;
                    box-sizing: border-box;
                    opacity: 0.6;
                }
            }
            .centerBox{
                flex: 1;
                border-left: 2px solid rgba($color: #FFFFFF, $alpha: 0.15);
                border-right: 2px solid rgba($color: #FFFFFF, $alpha: 0.15);
                p{
                    font-size: 16px;
                    line-height: 25px;
                }
                .title{
                    margin-bottom: 33px;
                }
            }
            .rightBox{
                flex: 1;
                display: flex;
                .aboutUs{
                    flex: 1;
                    p{
                        margin-bottom: 20px;
                    }
                    .title{
                        margin-bottom: 33px;
                    }
                }
                .qrCode{
                    flex: 1;
                    .title{
                        margin-bottom: 33px;
                    }
                    img{
                        width: 106px;
                        height: 106px;
                    }
                }
            }
        }
        .bottom{
            text-align: center;
            font-size: 12px;
            line-height: 24px;
            color: #444444;
        }
    }
}
</style>
