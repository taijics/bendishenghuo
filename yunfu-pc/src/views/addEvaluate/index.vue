<template>
  <div class="evaluate">
    <div class="banxin">
      <div class='head'>
        <router-link to="/myEvaluate">
          <div class='all'>我的评价</div>
        </router-link>
        <div class='arrow'></div>
        <div class='keyword'>追加评价</div>
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
            <div class="title">填写商品评价：</div>
            <el-form ref="form" label-width="80px">
              <el-form-item label="初次评价">
                <p class="mar-bot-10">{{evaluateData.comment}}</p>
                <el-rate disabled-void-color="#E5E5E5" disabled class="mar-bot-10" v-model="evaluateData.star"></el-rate>
                <p class="mar-bot-10" v-show="evaluateData.impression">
                  <span class="tag active" v-for="(imp,inx) in impression" :key="inx">{{imp}}</span>
                </p>
                <el-image
                  v-for="(url,ix) in evaluateData.images"
                  :key="ix"
                  style="width: 100px; height: 100px"
                  :src="url"
                  :preview-src-list="images">
                </el-image>
              </el-form-item>
              <el-form-item class="additional" label="追加评价">
                <el-input
                  type="textarea"
                  placeholder="请输入您的评语"
                  v-model="text"
                  rows=5
                  resize=none
                ></el-input>
                <br>
                <el-upload
                  :action="action"
                  list-type="picture-card"
                  :limit="5"
                  :on-success="handSuccess"
                  :on-remove="handleRemove">
                  <i class="el-icon-plus"></i>
                </el-upload>
                <div class="imgNum">
                  共<span class="text">{{urls.length}}</span>张，还可以上传<span class="text">{{5-(urls.length)}}</span>张
                </div>
              </el-form-item>
            </el-form>
            <el-button class="subEva" plain @click="addToComment" v-throttle>提交评价</el-button>
          </div>
        </div>
      </div>
    </div>
    <el-dialog
      :visible.sync="evaluateDialog"
      width="30%"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      center
    >
      <div>
        <icon-svg style="font-size: 100px;" icon-class="eva-success" />
        <p>您的评价已成功提交</p>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button class="again"
        v-if="product.collageId==0"
        @click="buyAgain()"
        v-throttle
        >再次购买</el-button>
        <el-button class="back" @click="$router.push('/')">返回首页</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import {
  upload
} from '@/api/upload.js'
import {
  getEvaluateDetail,
  addMoreEvaluate
} from '@/api/user/evaluate.js'
export default {
  data () {
    return {
      text: '',
      images: [],
      product: {},
      colors: [
        '#FF7800',
        '#FF7800',
        '#FF7800'
      ],
      urls: [],
      evaluateDialog: false,
      evaluateData: {},
      commentId: '',
      evaluateList: {},
      action: upload,
      productData: '',
      impression: []
    }
  },
  created () {
      this.productData = JSON.parse(this.$route.query.data)
  },
  mounted () {
      this.getEvaluateData()
  },
  methods: {
      // 获取评价详情
      async getEvaluateData () {
          const response = await getEvaluateDetail({ commentId: this.productData.commentId })
          const res = response.data
          if (res.code === '200') {
            this.evaluateData = res.data
            this.impression = res.data.impression.split(',')
          } else {
            this.$message.warning(res.message)
          }
      },
    // 追加评论
    async addToComment () {
      if (this.text === '') {
        this.$message({
          showClose: true,
          message: '内容不能为空',
          type: 'warning'
        })
        return
      }
      if (this.text) {
        this.evaluateDialog = true
        return
      }
      const response = await addMoreEvaluate({
        params: [{
          commentId: this.productData.commentId,
          image: this.urls.join(','),
          comment: this.text
        }]
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('追评成功')
        this.evaluateDialog = true
      } else {
        this.$message.error(res.message)
      }
    },
    // 删除上传的图片
    handleRemove (file, fileList) {
      this.urls = fileList
    },
    // 上传图片
    handSuccess (res) {
      this.urls.push(res.data.url)
    }
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
        color: #C83732;
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
          .box{
            width: 260px;
            img{
              margin-bottom: 23px;
              width: 100%;
            }
            .name{
              margin-bottom: 20px;
              font-size: 14px;
            }
            .price{
              margin-bottom: 23px;
              color: #C83732;
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
            padding-bottom: 12px;
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
              margin-bottom: 50px;
              display: flex;
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
                  margin: 0 10px 10px 0;
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
                img{
                  width: 80px;
                  height: 80px;
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
                  margin-top: 20px;
                  color: #999999;
                  .text{
                    color: #C83732;
                  }
                }
              }
            }
          }
          .subEva{
            width: 200px;
            height: 50px;
            margin: 30px 0;
            color: $mainGlod;
            background: #333333;
            border-radius: 0;
            &:hover{
              border: 1px solid $mainGlod;
              background-color: #FFF;
            }
          }
        }
      }
    }
  }
  >>>.el-dialog{
    .el-dialog__body{
      display: flex;
      justify-content: center;
      div{
        text-align: center;
        img{
          width: 80px;
          height: 80px;
          margin-bottom: 40px;
        }
        p{
          font-size: 22px;
        }
      }
    }
    .el-dialog__footer{
      .again{
        background-color: #E5E5E5;
        color: #333;
        border-radius: 0;
      }
      .back{
        color: $mainGlod;
        background-color: #333;
        box-sizing: border-box;
        border-radius: 0;
      }
    }
  }
}
</style>
