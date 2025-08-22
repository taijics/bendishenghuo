<template>
  <div class="evaluate">
    <div class="banxin">
      <div class='head'>
        <router-link to="/myEvaluate">
          <div class='all'>我的评价</div>
        </router-link>
        <div class='arrow'></div>
        <div class='keyword'>评价详情</div>
      </div>
      <div class="content">
        <div class="top">
          <div class="left">
            <div class="box">
              <img :src="productData.productImage" alt="">
              <p class="name">{{productData.productName}}</p>
              <div class="price">
                <span class="currency">¥</span>
                <span class="money">{{productData.productPrice}}</span>
              </div>
              <p class="size"><span v-for="(val,idx) in productData.values" :key="idx">{{val}}</span></p>
            </div>
          </div>
          <div class="right">
            <div class="title"></div>
            <el-form ref="form" label-width="80px">
              <el-form-item label="初次评价">
                <p class="mar-bot-10">{{productData.comment}}</p>
                <el-rate disabled-void-color="#C5AA7B" disabled class="mar-bot-10" v-model="productData.star"></el-rate>
                <p class="mar-bot-10" v-show="productData.impression">
                  <span class="tag active" v-for="(imp,inx) in impression" :key="inx">{{imp}}</span>
                </p>
                <el-image
                  v-show="productData.image"
                  v-for="(urls,ixs) in image"
                  :key="ixs"
                  style="width: 100px; height: 100px"
                  :src="urls"
                  :preview-src-list="image">
                </el-image>
              </el-form-item>
              <el-form-item class="additional" label="追加评价" v-if="productData.ifAdd==1">
                <p class="mar-bot-10">{{productData.addComment}}</p>
                <el-image
                  v-show="productData.addImage"
                  v-for="(url,ix) in addImage"
                  :key="ix"
                  style="width: 100px; height: 100px"
                  :src="url"
                  :preview-src-list="addImage">
                </el-image>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      productData: '',
      impression: [],
      image: [],
      addImage: []
    }
  },
  created () {
      this.productData = JSON.parse(this.$route.query.data)
      this.image = this.productData.image.split(',')
      this.addImage = this.productData.addImage.split(',')
      this.impression = this.productData.impression.split(',')
      // console.log(this.image)
  }
}
</script>
<style lang="scss" scoped>
.evaluate{
  width: 100%;
  height: 100%;
  background-color: #f0f0f0;
  padding-bottom: 143px;
  text-align: center;
  .banxin{
    width: 1252px;
    margin: 0 auto;
    height: 100%;
    .head {
      width: 100%;
      height: 64px;
      line-height: 64px;
      font-size: 16px;
      display: flex;
      align-items: center;
      .all {
        margin-right: 20px;
      }
      .keyword {
        margin: 0 20px;
        color: #333333;
      }
      .arrow {
        background-image: url('../../../static/image/xiangyou@2x.png');
        width: 5px;
        height: 10px;
      }
    }
    .content{
      width: 100%;
      background-color: #FFFFFF;
      .top{
        width: 100%;
        display: flex;
        border-bottom: 1px solid #E5E5E5;
        .left{
          border-right: 1px solid #EAEAEA;
          flex: 1;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 36px 0;
          box-sizing: border-box;
          .box{
            width: 260px;
            img{
              width: 100%;
              margin-bottom: 23px;
            }
            .name{
              margin-bottom: 20px;
              font-size: 14px;
            }
            .price{
              color: #C83732;
              margin-bottom: 23px;
              .currency{
                font-size: 12px;
              }
              .money{
                font-size: 18px;
              }
            }
            .size{
              font-size: 12px;
              color: #999999;
              span{
                margin-right: 10px;
              }
              span:last-child{
                margin-right: 0;
              }
            }
          }
        }
        .right{
          flex: 2;
          padding: 36px 36px 0;
          box-sizing: border-box;
          .title{
            width: 100%;
            text-align: left;
            border-bottom: 1px dashed #EAEAEA;
          }
          >>>.el-form{
              text-align: left;
              padding-top: 20px;
              .additional{
                padding-top: 22px;
                box-sizing: border-box;
                border-top: 1px dashed #E5E5E5;
              }
            .el-form-item{
              display: flex;
              margin-bottom: 50px;
              .el-form-item__label{
                flex: 1;
                text-align: left;
                color: #999999;
              }
              .el-form-item__content{
                margin-left: 10px !important;
                flex: 6;
                .el-rate{
                  transform: scale(1.4);
                  margin-left: 105px;
                }
                .tag{
                  display: inline-block;
                  width: 100px;
                  box-sizing: border-box;
                  text-align: center;
                  border: 1px solid #EAEAEA;
                  margin: 20px 10px 10px 0;
                  cursor: pointer;
                }
                .active{
                  color: $mainGlod;
                  border-color: $mainGlod;
                }
                .el-textarea{
                  margin-bottom: 20px;
                }
                p{
                  font-size: 14px;
                }
                .el-image{
                  margin-right: 15px;
                }
                .el-upload--picture-card,.el-upload-list--picture-card{
                  width: 80px;
                  height: 80px;
                  line-height: 80px;
                  .el-upload-list__item-actions,.el-upload-list__item{
                    width: 80px;
                    height: 80px;
                  }
                  i{
                    line-height: 2.1;
                  }
                  .el-icon-delete,.el-icon-zoom-in{
                    font-size: 20px;
                  }
                  .el-icon-upload-success{
                    line-height: 1;
                  }
                }
                .imgNum{
                  display: inline-block;
                  height: 60px;
                  margin-top: 50px;
                  color: #999999;
                  .text{
                    color: $mainGlod;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
</style>
