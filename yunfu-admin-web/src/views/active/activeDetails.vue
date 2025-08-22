<template>
  <div>
    <div class="pending">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="活动信息" name="first">
          <div class="shop_info">
            <h3 class="detail_title">店铺信息</h3>
            <div class="shopInfo_left">
              <p class="detail_text">
                <span>活动名称：</span>
                <span class="text">{{ form.activityName }}</span>
              </p>
              <p class="detail_text">
                <span>活动介绍：</span>
                <span class="text">{{ form.activityIntroduce }}</span>
              </p>
              <p class="detail_text">
                <span>报名时间：</span>
                <span class="text"
                  >{{ form.signStartTime }}-{{ form.signEndTime }}</span
                >
              </p>
              <p class="detail_text">
                <span>起止时间：</span>
                <span class="text"
                  >{{ form.activityStartTime }}-{{ form.activityEndTime }}</span
                >
              </p>
              <p class="detail_text">
                <span>活动保证金：</span>
                <span class="text textColor">
                  <el-radio-group v-model="form.ifBond">
                    <el-radio :label="1" disabled>需要</el-radio>
                    <el-radio :label="0" disabled>不需要</el-radio>
                  </el-radio-group>
                </span>
              </p>
              <p v-if="form.ifBond" class="detail_text">
                <span>保证金金额：</span>
                <span class="text">{{ form.bondMoney }}</span>
              </p>
              <p class="detail_text">
                <span>活动标签：</span>
                <span class="mf">
                  <el-tag type="warning" effect="dark">{{
                    form.activityLabel
                  }}</el-tag>
                </span>
              </p>
            </div>
            <div class="shopInfo_right">
              <img :src="form.image" alt="" />
            </div>
          </div>
          <div class="shop_info">
            <h3 class="detail_title">优惠规则</h3>
            <p class="detail_text">
              <span>优惠方式：</span>
              <span class="text">
                <el-radio-group v-model="form.discountMode">
                  <el-radio :label="1" disabled>满减</el-radio>
                  <el-radio :label="2" disabled>优惠券</el-radio>
                </el-radio-group>
              </span>
            </p>
            <p class="detail_text">
              <span>优惠方案：</span>
              <span class="text">
                <el-radio-group v-model="form.discountMode">
                  <el-radio :label="1" disabled>叠加优惠</el-radio>
                  <el-radio :label="2" disabled>阶梯优惠</el-radio>
                </el-radio-group>
              </span>
            </p>
            <p class="detail_text">
              <span />
              <span class="text Margin">
                <span v-for="(item, index) in form.promotionDetail" :key="index"
                  >满{{ item.fullMoney }}减{{ item.reduceMoney }}</span
                >
              </span>
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="参与店铺" name="second">
          <!-- 搜索 -->
          <div class="formSearch">
            <el-form
              :inline="true"
              :model="formInline"
            >
              <el-form-item label="店铺名称">
                <el-input
                  v-model="formInline.shopName"
                  maxlength="20"
                  placeholder="请输入店铺名称"
                />
              </el-form-item>
              <el-form-item label="店铺编码">
                <el-input
                  v-model="formInline.shopCode"
                  maxlength="20"
                  placeholder="请输入店铺编码"
                />
              </el-form-item>
              <el-form-item label="审核状态">
                <el-select
                  v-model="formInline.state"
                  placeholder="请选择审核状态"
                >
                  <el-option label="待审核" value="0" />
                  <el-option label="报名成功" value="1" />
                  <el-option label="报名失败" value="2" />
                </el-select>
              </el-form-item>

              <el-form-item>
                <el-button type="primary" plain @click="search">查询</el-button>
              </el-form-item>
            </el-form>
          </div>
          <!-- 表格 -->
          <div class="tableBox">
            <el-table
              :data="tableData"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 100%"
            >
              <el-table-column label="店铺名称" width="220">
                <template #default="scope">{{ scope.row.shopName }}</template>
              </el-table-column>
              <el-table-column prop="shopCode" label="店铺编码" />
              <el-table-column prop="productNumber" label="参与商品数" />
              <el-table-column prop="examine" label="审核次数" />
              <el-table-column label="审核状态">
                <template #default="scope">
                  <span v-if="scope.row.state == 0">待审核</span>
                  <span v-if="scope.row.state == 1">报名成功</span>
                  <span v-if="scope.row.state == 2">报名失败</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" show-overflow-tooltip>
                <template #default="scope">
                  <div class="btnList">
                    <el-button type="text" @click="seeMore(scope.row)"
                      >查看商品</el-button
                    >
                    <el-button type="text" @click="checkList(scope.row)"
                      >审核记录</el-button
                    >
                    <el-button
                      v-if="scope.row.state === 0"
                      type="text"
                      @click="examine(scope.row)"
                      >审核</el-button
                    >

                    <el-button
                      v-if="scope.row.state === 1"
                      type="text"
                      @click="liquidation(scope.row)"
                      >清退</el-button
                    >
                  </div>
                </template>
              </el-table-column>
            </el-table>
            <div class="fenye">
              <el-pagination
                :current-page="currentPage"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="10"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
              />
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane label="活动数据" name="third">
          <List :list-id="info" />
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- ******************************************************弹框开始***************************************************************** -->
    <!-- 审核记录弹框 -->
    <el-dialog
      v-model="checkDIa"
      title="审核记录"
      center
      width="30%"
      :close-on-click-modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="checkLists"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column label="动态" width="220">
            <template #default="scope">{{
              scope.row.operationDescribtion
            }}</template>
          </el-table-column>
          <el-table-column prop="createTime" label="时间" />
          <el-table-column prop="name" label="操作人" />
          <el-table-column prop="remark" label="其他信息" />
        </el-table>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="checkDIa = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 活动商品记录弹框 -->
    <el-dialog
      title="活动商品"
      v-model="foodsDia"
      center
      width="70%"
      :close-on-click-modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="tableDatas"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column label="产品主图" width="220">
            <template #default="scope">
              <img :src="scope.row.image" width="50" height="50" alt srcset />
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="产品名称" />
          <el-table-column prop="productId" label="产品id" />
          <el-table-column prop="price" label="售价(元)" />
          <el-table-column prop="originalPrice" label="原价(元)" />
          <el-table-column prop="stockNumber" label="库存(件)" />
          <el-table-column prop="volume" label="累计销量(件)" />
          <el-table-column label="上架状态">
            <template #default="scope">
              <span v-if="scope.row.shelveState == 1">上架</span>
              <span v-if="scope.row.shelveState == 0">下架</span>
            </template>
          </el-table-column>
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="currentPages"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="10"
            layout="total, sizes, prev, pager, next, jumper"
            :total="totals"
            @size-change="handleSizeChanges"
            @current-change="handleCurrentChanges"
          />
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="foodsDia = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 审核清退 -->
    <el-dialog
      :title="checkObj.title"
      v-model="checkObj.show"
      center
      width="30%"
      :close-on-click-modal="false"
    >
      <div v-if="checkObj.type === 1" class="diaddStyle">
        <el-form ref="form" :model="addform" label-width="80px">
          <el-form-item label="审核状态">
            <el-radio-group v-model="addform.state">
              <el-radio label="1">报名成功</el-radio>
              <el-radio label="2">报名失败</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="备注">
            <el-input
              v-model="addform.remark"
              maxlength="200"
              type="textarea"
            />
          </el-form-item>
        </el-form>
      </div>
      <div v-else class="diaddStyle">
        <div class="text">确认要清退本商家吗？</div>
        <div class="text">清退后商家的所有商品将退出本次活动</div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="enter">确定</el-button>
          <el-button @click="checkDIa = checkObj.show = false">取消</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import {
  activeGetById,
  activeGetShops,
  activeGetExamines,
  activeGetProducts,
  activeLiquidation,
  activExamine,
} from '@/api/active'
import List from './component/index.vue'
export default {
  components: {
    List,
  },
  data() {
    // 这里存放数据
    return {
      activeName: 'first',
      radio: '1',
      formInline: {
        activityId: 0,
        shopName: '', // 店铺名称
        shopCode: '', // 店铺编码
        state: '', // 审核状态 0-待审核 1-报名成功 2-报名失败
        page: 1,
        pageSize: 10,
      },
      addform: {
        signId: '', // 报名id
        state: '1', // 审核状态 1-报名成功 2-报名失败
        remark: '', // 备注
      },
      checkObj: {},
      form: {},
      tableData: [],
      tableDatas: [],
      checkLists: [],
      total: 1,
      totals: 1,
      currentPage: 1,
      currentPages: 1,
      checkDIa: false,
      foodsDia: false,
      signId: '',
    }
  },
  // 监听属性 类似于data概念
  computed: {
    info() {
      return this.$route.query.info || {}
    },
  },
  created() {
    this.getDetails()
    this.formInline.activityId = this.info.activityId
    this.getAll(this.formInline)
    console.log(this.info)
  },
  // 方法集合
  methods: {
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    handleSizeChanges(val) {
      console.log(val)
      this.getProducts({
        signId: this.signId,
        page: 1,
        pageSize: val,
      })
    },
    handleCurrentChanges(val) {
      this.getProducts({
        signId: this.signId,
        page: val,
        pageSize: 10,
      })
    },
    handleClick(tab, event) {
      console.log(tab, event)
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 审核记录
    async checkList(row) {
      this.checkDIa = true
      const res = await activeGetExamines({
        only: `${row.shopId}-${row.activityId}-${row.signId}`,
      })
      this.checkLists = res.data
    },
    // 查看
    seeMore(row) {
      this.foodsDia = true
      this.signId = row.signId
      this.getProducts({
        signId: this.signId,
        page: 1,
        pageSize: 10,
      })
    },
    // 处理
    async examine(row) {
      this.addform.signId = row.signId
      this.checkObj = {
        title: '审核',
        show: true,
        arr: row,
        type: 1,
      }
    },
    // 清退
    async liquidation(row) {
      this.checkObj = {
        title: '清退',
        show: true,
        arr: row,
        type: 2,
      }
    },
    // 确定
    async enter() {
      if (this.checkObj.type === 1) {
        const res = await activExamine(this.addform)
        if (res.code === '') {
          this.$message({
            message: '处理成功',
            type: 'success',
          })
          this.checkObj.show = false
          this.getAll(this.formInline)
        }
      } else {
        const res = await activeLiquidation({
          signId: this.checkObj.arr.signId,
        })
        if (res.code === '') {
          this.$message({
            message: '清退成功',
            type: 'success',
          })
          this.checkObj.show = false
          this.getAll(this.formInline)
        }
      }
    },
    // 活动信息查询
    async getDetails() {
      const res = await activeGetById({ activityId: this.info.activityId })
      this.form = res.data
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await activeGetShops(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
    },
    // 初始化查询所有活动商品
    async getProducts(formInline) {
      const res = await activeGetProducts(formInline)
      this.tableDatas = res.data.list
      this.totals = res.data.total
    },
  },
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 30px;
}
.fenye {
  margin-top: 20px;
}
.diaddStyle {
  .text {
    text-align: center;
  }
}
.detail_title {
  font-size: 22px;
  color: #333333;
  position: relative;
  margin: 50px 20px 20px;
  &:before {
    content: '';
    display: block;
    position: absolute;
    top: 5px;
    left: -20px;
    width: 4px;
    height: 24px;
    background-color: #3a68f2;
  }
}
.detail_text {
  padding: 0 120px;
  //  font-size: 16px;
  .text {
    color: #666666;
    line-height: 40px;
    margin-left: 20px;
  }
  .Margin {
    margin-left: 90px;
  }
}
.shop_info {
  overflow: hidden;
  .shopInfo_left,
  .shopInfo_right {
    float: left;
  }
  .shopInfo_right {
    margin-left: 160px;
    width: 200px;
    height: 200px;
    img {
      width: 100%;
    }
  }
}
.mf {
  margin-left: 20px;
  .el-tag {
    margin-bottom: 20px;
  }
}
// radio默认选中修改颜色
.el-radio__input.is-disabled + span.el-radio__label {
  color: #409eff !important;
}
</style>
