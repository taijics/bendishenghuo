<template>
  <div class="evaluate">
    <div class="banxin">
      <div class='head'>
        <router-link to="/myOrder">
          <div class='all'>我的订单</div>
        </router-link>
        <div class='arrow'></div>
        <div class='keyword'>评价</div>
      </div>
      <div class="content">
        <div class="top"
          v-for="(item, index) of product.skus"
          :key="index"
        >
          <div class="left">
            <div class="box">
              <img :src="item.image" alt="">
              <p class="name">{{item.productName}}</p>
              <div class="price">
                <span class="currency">¥</span>
                <span class="money">{{item.price}}</span>
              </div>
              <p class="size">
                <span
                  v-for="(val, idx) in item.values"
                  :key="idx"
                >
                  {{val}}
                </span>
              </p>
            </div>
          </div>
          <div class="right" v-if="item.commentId === 0">
            <div class="title">填写商品评价：</div>
            <el-form ref="form" label-width="80px">
              <el-form-item label="商品满意度评分" style="display:flex;align-items: center;">
                <el-rate style="margin-left:110px;"
                  :colors=colors
                  v-model="item.score"
                  @change="changeScore"
                ></el-rate>
              </el-form-item>
              <el-form-item label="商品印象">
                <div class="tag"
                :class="item.impression.indexOf(tagItem)!=-1?'active':''"
                v-for="(tagItem, tagIndex) in tag"
                :key="tagIndex"
                @click="tagClick(tagItem, index)">{{tagItem}}</div>
              </el-form-item>
              <el-form-item label="评价晒单">
                <el-input
                  type="textarea"
                  placeholder="请输入您的评语"
                  v-model="item.text"
                  rows=5
                  resize=none
                ></el-input>
                <br>
                <el-upload
                  :action="action"
                  list-type="picture-card"
                  :limit="5"
                  :on-success="(res,file)=>{
                    return handSuccess(res, file, index)
                  }"
                  :on-remove="(file, fileList)=>{
                    return handleRemove(file, fileList, index)
                  }">
                  <i class="el-icon-plus"></i>
                </el-upload>
                <div class="imgNum">
                  共<span class="text">{{item.imgNum}}</span>张，还可以上传<span class="text">{{5-(item.imgNum)}}</span>张
                </div>
              </el-form-item>
            </el-form>
            <el-button class="subEva" plain @click="addComment" v-throttle>提交评价</el-button>
          </div>
          <div class="right" v-else>
            <icon-svg
              style="width: 240px; height: 240px; margin-bottom: 20px;"
              icon-class="user-order-nodata"
            />
            <p class="fs20 font-color-999">商品无法评价或已评价！</p>
          </div>
        </div>
      </div>
      <el-dialog
        :visible.sync="centerDialogVisible"
        width="30%"
        :show-close="false"
        :close-on-click-modal="false"
        :close-on-press-escape="false"
        center>
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
  </div>
</template>
<script>
import {
  upload
} from '@/api/upload.js'
import {
  addEvaluate
} from '@/api/user/evaluate.js'
import {
  buyItAgain
} from '@/api/user/order.js'
export default {
  data () {
    return {
      status: 1,
      score: 5,
      text: '',
      impression: [],
      impressions: [],
      images: [],
      product: {},
      colors: [
        '#C5AA7B',
        '#C5AA7B',
        '#C5AA7B'
      ],
      tag: [
        '物美价廉',
        '物流很快',
        '值得买',
        '一般',
        '还可以',
        '差评'
      ],
      urls: [],
      dialogVisible: false,
      disabled: false,
      centerDialogVisible: false,
      evaluateData: {},
      commentId: '',
      evaluateList: {},
      action: upload
    }
  },
  created () {
    this.product = JSON.parse(this.$route.query.product)
    this.product.skus.forEach(item => {
      this.$set(item, 'imgNum', 0)
      item['impression'] = []
      item['images'] = []
      item['score'] = 5
      item['urls'] = []
    })
    // let evaluate = []
    // this.product.skus.forEach(j => {
    //   j['impression'] = []
    //   j['images'] = []
    //   j['score'] = 5
    //   j['urls'] = []
    // })
  },
  methods: {
    // 添加评论
    async addComment () {
      let flag = true
      this.product.skus.map(j => {
        if (j.text === '' || j.text === undefined) {
          this.$message({
            showClose: true,
            message: '评价内容不能为空',
            type: 'warning'
          })
          flag = false
        }
      })
      if (flag) {
        let params = []
        this.product.skus.map(j => {
          params.push({
            orderId: this.product.orderId,
            skuId: j.skuId,
            productId: j.productId,
            image: j.urls.join(','),
            comment: j.text,
            star: j.score,
            impression: j.impression.join(',')
          })
        })
        const response = await addEvaluate({params})
        const res = response.data
        if (res.code === '200') {
          this.centerDialogVisible = true
        } else {
          this.$message.error(res.message)
        }
      }
    },
    // 再次购买
    async buyAgain () {
      const response = await buyItAgain({ orderId: this.orderId })
      const res = response.data
      if (res.code === '200') {
        this.$router.push('/shopping-trolley')
      }
    },
    // 选择印象
    tagClick (tag, index) {
      if (this.product.skus[index].impression.indexOf(tag) === -1) {
        this.product.skus[index].impression.push(tag)
      } else {
        this.product.skus[index].impression.splice(this.product.skus[index].impression.indexOf(tag), 1)
      }
      this.$forceUpdate()
    },
    // 删除上传的图片
    handleRemove (file, fileList, index) {
      this.product.skus[index].urls = []
      for (var i in fileList) {
        this.product.skus[index].urls.push(fileList[i].response.data.url)
      }
      this.product.skus[index].imgNum = this.product.skus[index].urls.length
    },
    // 上传图片
    handSuccess (res, file, index) {
      this.product.skus[index].urls.push(res.data.url)
        this.product.skus[index].imgNum = this.product.skus[index].urls.length
    },
    changeScore () {
      this.$forceUpdate()
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
        min-height: 600px;
        display: flex;
        .left{
          border-right: 1px solid #EAEAEA;
          flex: 1;
          display: flex;
          align-items: center;
          justify-content: center;
          .box{
            width: 260px;
            font-family: Microsoft YaHei;
            img{
              width: 240px;
              max-height: 300px;
              margin-bottom: 23px;
            }
            .name{
              margin-bottom: 20px;
              font-size: 16px;
              color: #333333;
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
            .el-form-item{
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
                  margin-left: 10px;
                  transform: scale(1.4);
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
                  margin-top: 50px;
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
}
</style>
