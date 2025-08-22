/**
  会员专区页面
 */
<template>
  <div class="vipPage">
    <!-- <div v-if="proList.length > 0"> -->
    <div v-if="true">
        <ActivitySlot class="activityRabatt" :imgTitle="imgTitle">
          <template v-slot:section>
            <div class="vipList">
              <div class="item"
                v-for="item in proList"
                :key="item.productId"
              >
                <ItemSlot :data="item" @toDetail="toProductDetail(item)">
                  <template v-slot:extra>
                    <div class="progress">
                      <span>限量{{item.stockNumber || 0}}件</span>
                      <el-progress
                        :color="'#C83732'"
                        :show-text="false"
                        :stroke-width="26"
                        :percentage="(item.number / item.stockNumber) * 100 || 0"></el-progress>
                    </div>
                  </template>
                  <template v-slot:icon>
                    <icon-svg style="font-size:57px;" icon-class="activity-vip" />
                  </template>
                  <template v-slot:button>
                    <button class="buy" @click="toProductDetail(item)">立即购买</button>
                  </template>
                </ItemSlot>
              </div>
            </div>
          </template>
        </ActivitySlot>
        <el-pagination
          style="margin:20px 0;"
          background
          layout="prev, pager, next, jumper"
          :page-size="listquery.pageSize"
          :current-page="listquery.page"
          @current-change="changePage"
          :total="total">
        </el-pagination>
      </div>
      <div v-else class="noproduct">
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
        <p class="fs20 font-color-999">该活动没有商品～</p>
      </div>
  </div>
</template>

<script>
import ActivitySlot from '@/components/activity/activitySlot.vue'
import ItemSlot from '@/views/promotions/components/itemSlot.vue'

import {
  getVipList
} from '@/api/Activity/ActivityVip.js'
export default {
  name: 'rabatt',
  components: { ActivitySlot, ItemSlot },
  data () {
    return {
      imgTitle: 'static/image/activity/vipTitle.webp',
      listquery: {
        page: 1,
        pageSize: 10,
        type: 0,
        volume: 0
      },
      total: 0,
      proList: []
    }
  },
  created () {
    this.getVipList()
  },
  methods: {
    async getVipList () {
      const response = await getVipList(this.listquery)
      const res = response.data
      this.proList = res.data.list.map(item => {
        if (item.mode === 2) {
          item.price = item.discount
        }
        // item.price = item.discount || 0
        return item
      })
      this.total = res.data.total
    },
    // 翻页
    changePage (val) {
      this.listquery.page = val
      this.getVipList()
    },
    toProductDetail (row) {
      let data = {
        productId: row.productId,
        shopId: row.shopId,
        skuId: row.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.vipPage{
  max-width: 1250px;
  min-height: 600px;
  margin: auto;
  .noproduct{
    margin: 80px 0;
    text-align: center;
  }
  .vipList {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    .item {
      width: 23%;
      margin: 20px 1%;
      transition: all 0.3s linear;
      .progress{
        width: 100%;
        height: 40px;
        background-color: #DADBDC;
        position: absolute;
        bottom: 0;
        display: flex;
        align-items: center;
        span{
          margin-left: 10px;
        }
        >>> .el-progress{
          flex: 1;
          height: 10px;
          margin: 0 10px;
          // .el-progress-bar{
          //   height: 10px;
          // }
          .el-progress-bar__outer,.el-progress-bar__inner{
            border-radius: 0;
            height: 10px !important;
          }
        }
      }
      .buy{
        width: 100%;
        height: 40px;
        padding: 0;
        margin: 15px 0 0;
        background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
        box-shadow: 0px 3px 6px rgba(233, 0, 0, 0.3);
        cursor: pointer;
      }
    }
    .item:hover{
      box-shadow:0 0 20px #cccccc;
    }
  }
}
</style>
