<template>
  <div class="orderList">
    <div class="head">
        <div style="flex:4;padding-left:20px;">
          <span style="flex:2;">宝贝</span>
          <span style="flex:1;">单价</span>
          <span style="flex:1;">数量</span>
        </div>
        <div style="flex:4;padding-right:20px;">
          <span style="flex:1;">退款金额</span>
          <span style="flex:1;">申请时间</span>
          <span style="flex:1;">状态</span>
          <span style="flex:1;">操作</span>
        </div>
    </div>
    <div v-if="afterSaleList.length>0">
        <div class="content" v-for="(item,index) in afterSaleList" :key="index">
            <div class="top">
                <div class="left">
                    <span class="shopName" @click="toStore(item.shopId)"><img :src="item.shopLogo" alt="">{{item.shopName}}</span>
                    <span class="orderCode">售后编号：{{item.afterFormid}}</span>
                </div>
            </div>
            <div class="productBox">
                <div class="product">
                    <div class="left fs13">
                        <div class="box" v-for="(pro,inx) in item.skus" :key="inx">
                            <div class="desc cur-poi" @click="toProductDetail(pro,item.shopId)">
                                <img :src="pro.image" alt="">
                                <div>
                                    <p class="name">{{pro.productName}}</p>
                                    <p class="size font-color-999"><span v-for="(val,idx) in pro.values" :key="idx">{{val}}</span></p>
                                </div>
                            </div>
                            <div class="price">¥{{pro.price}}</div>
                            <div class="num">{{pro.number}}</div>
                        </div>
                    </div>
                    <div class="right" :class="item.skus.length>1?'right_line':''">
                        <div class="actualPay">
                            <div>
                            <p class="fs13 mar-bot-5">¥{{item.price}}</p>
                            </div>
                        </div>
                        <div class="applicationTime">{{item.createTime}}</div>
                        <div class="status">
                            <div>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==1">审核中</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==2">退款中</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==3">退货中</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==4">退款成功</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==5">退款失败</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==6">审核不通过</p>
                                <p class="fs13 mar-bot-5" v-if="item.afterState==7">评审中</p>
                                <p class="fs13 mar-bot-5 font-color-999" v-if="item.afterState==8">退货完成，拒绝退款</p>
                                <p class="fs13 mar-bot-5 font-color-999" v-if="item.afterState==9">已关闭</p>
                                <p class="fs13 mar-bot-5 font-color-71B" v-if="item.afterState==10">审核通过</p>
                            </div>
                        </div>
                        <div class="operate">
                            <el-button size="small"
                                @click="toAfterSaleDetail(item.afterId,item.orderId)"
                            >售后详情</el-button>
                            <p class="fs13 tex-und cur-poi mar-top-10"
                              @click="platform(item.afterId,item.orderId)"
                              v-if="item.afterState==6 || item.afterState==8"
                              v-throttle
                            >申请平台介入</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <el-pagination
          :current-page="page"
          :page-size="5"
          :total='total'
          @current-change="handleCurrentChange"
          background
          layout='prev, pager, next'
        ></el-pagination>
    </div>
    <div class="noorder" v-else>
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
        <p class="fs20 font-color-999">你还没有售后订单哦～</p>
    </div>
    <el-dialog
        title="申请平台介入"
        :visible.sync="interventionShow"
        width="25%"
        center
    >
        <el-input
            type="textarea"
            :rows="7"
            placeholder="请输入内容"
            v-model="reason">
        </el-input>

        <span slot="footer" class="dialog-footer">
            <el-button type="primary" @click="interventionFn">确 定</el-button>
            <el-button @click="closeIntervention">取 消</el-button>
        </span>
    </el-dialog>
  </div>
</template>
<script>
import {
  requestPlatform
} from '@/api/user/afterSale.js'
export default {
  props: ['afterSaleList', 'page', 'total'],
  data () {
    return {
      state: 1,
      reason: '',
      images: '',
      interventionShow: false,
      afterId: '',
      orderId: ''
    }
  },
  methods: {
    // 分页器跳转
    handleCurrentChange (val) {
      this.$emit('handleCurrentChange', val)
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store',
        query: {
          shopData: {shopId: id}
        }
      })
    },
    // 跳转到售后详情
    toAfterSaleDetail (aid, oid) {
      this.$router.push({
        path: '/orderDetail',
        query: {
          afterId: aid, // 售后id
          orderId: oid, // 订单id
          type: 3
        }
      })
    },
    // 平台介入
    platform (afterId, orderId) {
      this.afterId = afterId
      this.orderId = orderId
      this.interventionShow = true
    },
    // 跳转到商品详情
    toProductDetail (item, id) {
      let data = {
        productId: item.productId,
        skuId: item.skuId,
        shopId: id
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    closeIntervention () {
      this.afterId = ''
      this.orderId = ''
      this.reason = ''
      this.interventionShow = false
    },
    // 申请平台介入
    async interventionFn () {
      const response = await requestPlatform({
        afterId: this.afterId,
        orderId: this.orderId,
        image: this.images,
        reason: this.reason
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('申请平台介入成功')
        this.interventionShow = false
      } else {
        this.$message.warning(res.message)
        this.interventionShow = false
      }
    }
  }
}
</script>
<style lang="scss" scoped>
.orderList{
  width: 100%;
  .noorder{
    width: 100%;
    text-align: center;
    padding: 100px 0;
    p{
      margin-bottom: 20px;
    }
    .el-button{
      background-color: $mainGlod;
      color: #FFFFFF;
      font-weight: normal;
      border-radius: 0;
    }
  }
  .head{
    box-sizing: border-box;
    width: 100%;
    height: 44px;
    background-color: #F1F2F7;
    display: flex;
    align-items: center;
    text-align: center;
    margin-bottom: 20px;
    div{
      display: flex;
    }
  }
  .content{
    width: 100%;
    margin-bottom: 20px;
    border: 1px solid #E5E5E5;
    border-bottom: 0;
    box-sizing: border-box;
    .top{
      width: 100%;
      font-size: 13px;
      height: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #F3F3F3;
      .left{
        display: flex;
        .shopName{
          margin-left: 20px;
          margin-right: 60px;
          cursor: pointer;
          display: flex;
          align-items: center;
          img{
            width: 16px;
            height: 16px;
            vertical-align: middle;
            margin-right: 5px;
          }
        }
        .time{
          margin-right: 60px;
        }
      }
    }
    .productBox{
      width: 100%;
      box-sizing: border-box;
      .product{
        width: 100%;
        display: flex;
        .left{
          flex: 4;
          .box{
            padding: 20px 0 20px 20px;
            display: flex;
            border-bottom: 1px solid #E5E5E5;
            .desc{
              flex: 2;
              display: flex;
              img{
                width: 86px;
                height: 86px;
                margin-right: 10px;
              }
              div{
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                .name{
                  font-size: 14px;
                }
                .size{
                  font-size: 13px;
                  span{
                    margin-right: 10px;
                  }
                  span:last-child{
                    margin-right: 0;
                  }
                }
              }
            }
            .price,.num{
              flex: 1;
              display: flex;
              align-items: center;
              justify-content: center;
            }
          }
        }
        .right{
          padding: 20px 20px 20px 0;
          flex: 4;
          display: flex;
          border-bottom: 1px solid #E5E5E5;
          .actualPay,.applicationTime,.status,.operate{
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            div{
              text-align: center;
            }
            .el-button{
              border: 1px solid $mainGlod;
              color: $mainGlod;
              border-radius: 0;
            }
          }
          .status{
            p{
              color: #C83732;
            }
          }
          .operate{
            flex-direction: column;
          }
        }
        .right_line{
          border-left: 1px solid #E5E5E5;
        }
      }
    }
  }
  >>>.el-pagination{
    margin-top: 40px;
    text-align: right;
    .el-pager{
      li:not(.disabled):hover{
        color: $mainGlod;
      }
      li:not(.disabled).active{
        background-color: $mainGlod;
      }
      li:not(.disabled).active:hover{
        color: #F4F4F5;
      }
    }
  }
}
</style>
