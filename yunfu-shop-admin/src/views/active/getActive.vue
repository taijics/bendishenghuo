<template>
  <!-- 卡片 -->
  <el-card class="activityCardPage">
    <div slot="header">
      <span>活动列表/报名</span>
      <el-button
        v-if="active !== 3"
        type="primary"
        size="small"
        class="cardNext"
        @click="next"
      >下一步
      </el-button>
      <el-button
        v-if="active === 3"
        type="primary"
        size="small"
        class="cardNext"
        @click="cancel"
      >返回
      </el-button>
    </div>
    <div>
      <!-- 步骤条  -->
      <div
        v-if="form.ifBond"
        class="stepsLIst"
      >
        <el-steps :active="active">
          <el-step title="选择商品" />
          <el-step
            v-if="form.ifBond"
            title="缴纳保证金"
          />
          <el-step title="完成" />
        </el-steps>
      </div>
      <div v-if="active === 1">
        <!-- 顶部搜索 -->
        <nav class="formSearch">
          <el-input
            v-model="formInline.search"
            maxlength="20"
            class="searchInput"
            placeholder="请输入内容"
          >
            <el-select
              slot="prepend"
              v-model="formInline.condition"
              style="width:130px"
              placeholder="请选择"
            >
              <el-option
                label="商品id"
                value="1"
              />
              <el-option
                label="商品名称"
                value="2"
              />
            </el-select>
          </el-input>
          <div class="searchItem">
            <span>官方分类：</span>
            <el-cascader
              v-model="formInline.classifyId"
              maxlength="20"
              :options="categoryList"
              clearable
              :props="{
                checkStrictly: true,
                expandTrigger: 'hover',
                label:'categoryName',
                value:'id',
                children:'childs'
              }"
            />
          </div>
          <div class="searchItem">
            <span>商品分组：</span>
            <el-select
              v-model="formInline.groupId"
              class="type"
              placeholder="请选择商品分组"
            >
              <el-option
                v-for="(item,index) in groupLists"
                :key="index"
                :label="item.groupName"
                :value="item.shopGroupId"
              />
            </el-select>
          </div>
          <el-button
            type="primary"
            plain
            @click="search"
          >查询
          </el-button>
          <el-button
            type="primary"
            plain
            @click="clear"
          >重置
          </el-button>
        </nav>
        <!-- <div class="formSearch">
          <el-form :inline="true" :model="formInline" class="demo-form-inline">
            <el-form-item>
              <div>
                <el-input v-model="formInline.search" placeholder="请输入内容">
                  <el-select
                    slot="prepend"
                    v-model="formInline.condition"
                    style="width:130px"
                    placeholder="请选择"
                  >
                    <el-option label="商品id" value="1" />
                    <el-option label="商品名称" value="2" />
                  </el-select>
                </el-input>
              </div>
            </el-form-item>
            <el-form-item label="官方分类">
              <el-cascader
                v-model="formInline.classifyId"
                :options="categoryList"
                clearable
                :props="{
                  checkStrictly: true,
                  expandTrigger: 'hover',
                  label:'categoryName',
                  value:'id',
                  children:'childs'
                }"
              />
            </el-form-item>
            <el-form-item label="商品分组">
              <el-select v-model="formInline.groupId" placeholder="请选择商品分组">
                <el-option
                  v-for="(item,index) in groupLists"
                  :key="index"
                  :label="item.groupName"
                  :value="item.shopGroupId"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" plain @click="search">查询</el-button>
              <el-button type="primary" plain @click="clear">重置</el-button>
            </el-form-item>
          </el-form>
        </div> -->
        <!-- 表格 -->
        <div class="tableBox">
          <div class="text">
            已选中
            <span>{{ multipleSelection.length }}</span>商品
          </div>
          <el-table
            ref="multipleTable"
            v-loading="loading"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
            :row-key="getRowKeys"
            height="600"
            @selection-change="handleSelectionChange"
          >
            <el-table-column
              type="selection"
              :reserve-selection="true"
              width="55"
            />
            <el-table-column
              prop="productId"
              label="商品id"
            />
            <el-table-column label="商品主图">
              <template slot-scope="scope">
                <img
                  height="80"
                  width="80"
                  :src="scope.row.image"
                  alt
                  srcset
                >
              </template>
            </el-table-column>
            <el-table-column
              prop="productName"
              label="商品名称"
            />
            <el-table-column
              prop="sectionPrice"
              label="售价区间"
            />
            <el-table-column
              prop="stockNumber"
              label="库存"
            />
            <el-table-column label="商品限量（件）">
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.number"
                  maxlength="9"
                  value="$page"
                  oninput="value=value.replace(/[^\d]/g,'')"
                  @blur="BlurNumber(scope.row)"
                />
              </template>
            </el-table-column>
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="formInline.page"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="10"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>
      <!-- 缴纳保证金 -->
      <div
        v-if="active === 2"
        class="pay_page"
      >
        <div class="pay_content">
          <p>
            <span>保 证 金:</span>
            ¥{{ form.bondMoney }}
          </p>
          <!--<div class="pay_type">
            <span>支付方式:</span>
            微信
          </div>-->
          <div class="pay_img">
            <div
              id="qrcode"
              class="img"
            >
              <img
                :src="image"
                alt
                srcset
              >
            </div>
            <p>扫我付钱</p>
          </div>
          <ul>
            <li>tips:</li>
            <li
              v-for="(item,index) in list"
              :key="index"
            >
              {{ index + 1 }}
              {{ item }}
            </li>
          </ul>
        </div>
      </div>
      <!-- 报名成功 -->
      <div
        v-if="active === 3"
        class="finish_page"
      >
        <div class="pay_content">
          <div class="finish_pay" />
          <p>报名成功</p>
          <p v-if="infoData.signCode !== ''">成功支付¥{{ infoData.price }}</p>
          <p v-if="infoData.signCode !== ''">
            <span>交易类型:{{ infoData.type }}</span>
            <span>交易流水号:{{ infoData.signCode }}</span>
          </p>
          <div class="btn">
            <el-button
              type="primary"
              @click="cancel"
            >返回活动列表
            </el-button>
          </div>
          <ul v-if="form.signCode !== ''">
            <li>tips:</li>
            <li
              v-for="(item,index) in list"
              :key="index"
            >
              {{ index + 1 }}
              {{ item }}
            </li>
          </ul>
        </div>
      </div>
    </div>
  </el-card>
</template>

<script>
import { getClassify } from '@/api/commodity'
import { getGroups, getProducts, activitySave, checkPay } from '@/api/active'

export default {
  props: {
    form: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      // 新增
      getRowKeys(row) {
        return row.productId
      },
      formInline: {
        condition: '1', // 商品模糊搜索条件 1-商品id 2-商品名称
        search: '', // 搜索字段
        classifyId: '', // 分类id
        groupId: '', // 商品分组id
        page: 1,
        pageSize: 10
      },
      infoData: {
        signCode: ''
      },
      total: 1,
      tableData: [],
      groupLists: [],
      active: 1,
      categoryList: [],
      giveMoney: false,
      multipleSelection: [],
      image: '',
      list: [
        '、缴纳保证金是为了防止活动中出现纠纷或退款时账户无钱退返的情况。',
        '、平台不接触保证金，会由第三方存管机构冻结。',
        '、活动结束后15天内将退返保证金',
        '、活动开始后未完成审核将自动退返保证金',
        '、报名失败且3天内未重新报名也会自动退返保证金'
      ],
      timer: null,
      loading: false,
      inputTableData: [] // 存储输入框有值的数据
    }
  },
  // computed: {
  //   info() {
  //     return this.$route.params
  //   }
  // },
  watch: {
    form: {
      handler(nVal, oVal) {
        console.log('watch', nVal)
        if (Object.keys(nVal).length > 0) {
          this.getGroup()
          this.getAll(this.formInline)
          this.queryAllCategory()
        }
      },
      deep: true
    }
  },
  beforeDestroy() {
    clearInterval(this.timer)
  },
  mounted() {
    this.getGroup()
    this.getAll(this.formInline)
    this.queryAllCategory()
    // this.initSignProcess()
  },
  methods: {
    BlurNumber(data) {
      const index = this.inputTableData.findIndex(item => item.productId === data.productId)
      // console.log(index,'index')
      if (index === -1) {
        this.inputTableData.push(data)
      } else {
        this.inputTableData[index].number = data.number
      }
    },
    async initSignProcess() {
      /* const res = await getActivitySignDetail({
        activityId: this.form.activityId
      })
      if (res.code === '') {
        console.dir(res.data)
        if (res.data) {
          this.active = 2
        }
      } */
    },
    handleSelectionChange(val) {
      console.log(val, 'val')
      this.multipleSelection = val
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    async next() {
      if (this.active === 2) {
        if (this.infoData.signCode === '') {
          this.$message.error('请支付保证金')
          return false
        }
      }
      if (this.multipleSelection.length === 0) {
        this.$message.error('请选择商品')
        return
      }
      if (this.active === 1) {
        const arr = []
        var limitFlag = true
        this.multipleSelection.forEach(element => {
          var item = {}
          item.productId = element.productId
          if (element.number) {
            if (element.number > element.stockNumber) {
              this.$message.warning('商品限量不能大于库存数')
              limitFlag = false
            } else {
              item.number = parseInt(element.number)
            }
          }
          arr.push(item)
        })
        if (!limitFlag) {
          return false
        }
        if (this.form.ifBond) {
          const res = await activitySave({
            activityId: this.form.activityId,
            signType: this.form.signType,
            bondMoney: this.form.bondMoney,
            products: arr
          })
          if (res.code === '') {
            this.image = res.data.url
            this.timer = setInterval(this.getResult, 3000)
          } else {
            return
          }
        } else {
          const res = await activitySave({
            activityId: this.form.activityId,
            signType: this.form.signType,
            products: arr
          })
          if (res.code === '') {
            this.active = 2
          } else {
            return
          }
        }
      }
      if (this.active++ > 2) this.active = 1
    },
    // 查询
    search() {
      if (this.formInline.classifyId.length === 0) {
        this.formInline.classifyId = ''
      }
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 返回活动列表
    cancel() {
      this.active = 1
      this.$emit('cancel')
    },
    // 查询付款结果
    async getResult() {
      const res = await checkPay({
        activityId: this.form.activityId
      })
      if (res.data.code === 'SUCCESS') {
        this.active = 3
        this.infoData = res.data
        clearInterval(this.timer)
      }
    },
    // 清除
    clear() {
      this.formInline = {
        condition: '1', // 商品模糊搜索条件 1-商品id 2-商品名称
        search: '', // 搜索字段
        classifyId: '', // 分类id
        groupId: '', // 商品分组id
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 初始化查询商品分组
    async getGroup() {
      const res = await getGroups({})
      if (res.code === '') {
        this.groupLists = res.data
      }
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      this.loading = true
      this.formInline.classifyId =
        this.formInline.classifyId[2] ||
        this.formInline.classifyId[1] ||
        this.formInline.classifyId[0] ||
        this.formInline.classifyId
      const res = await getProducts(formInline)
      const dataList = res.data.list
      // 处理切换分页输入框内容保留
      if (this.inputTableData.length > 0) {
        dataList.forEach(item => {
          const index = this.inputTableData.findIndex(cItem => cItem.productId === item.productId)
          if (index !== -1) {
            item.number = this.inputTableData[index].number
          }
        })
      }
      // 处理库存
      dataList.forEach(item => {
        item.number = item.stockNumber
      })
      this.tableData = dataList
      this.total = res.data.total
      this.loading = false
    },
    // 初始化查询所有分类
    async queryAllCategory() {
      const res = await getClassify()
      this.categoryList = res.data
    },
    // 重置table和input内容
    reset() {
      this.inputTableData = []
      this.$refs.multipleTable.clearSelection()
    }
  }
}
</script>

<style
  scoped
  lang="scss"
>
@import url("../../styles/elDialog.scss");

.activityCardPage {
  font-size: 24px;

  .cardNext {
    float: right;
    background: #3a68f2;
    border-radius: 4px;
  }

  .formSearch {
    height: 40px;
    margin-bottom: 12px;
    display: flex;

    .searchInput {
      max-width: 350px;
      margin-right: 20px;

      ::v-deep.el-input__inner {
        width: 100%;
      }
    }

    .searchItem {
      margin-right: 20px;
      display: flex;
      line-height: 40px;

      span {
        min-width: 80px;
        font-size: 16px;
      }

      .type {
        max-width: 150px;
      }
    }
  }

  .text {
    margin-bottom: 20px;

    span {
      color: #ff7a12;
      margin-right: 5px;
    }
  }

  .stepsLIst {
    width: 70%;
    margin: 0 auto;
    margin-bottom: 30px;
    margin-top: 20px;
  }

  .pay_page {
    height: 100%;
    width: 100%;

    .pay_content {
      width: 550px;
      margin: 0 auto;
      box-sizing: border-box;
      padding: 40px 0;

      span {
        margin-right: 10px;
      }
    }

    .pay_img {
      width: 200px;
      margin: 20px auto 30px;

      .img {
        width: 200px;
        height: 200px;
        border: 1px #dedede solid;

        img {
          width: 100%;
          height: 100%;
        }
      }

      p {
        text-align: center;
        color: #666666;
        font-size: 16px;
        margin-top: 20px;
      }
    }

    ul {
      list-style: none;
      margin: 0;
      padding: 0;

      li {
        font-size: 16px;
        color: #666666;
        line-height: 25px;
      }
    }
  }

  .finish_page {
    height: 100%;
    width: 100%;
    box-shadow: 1px 5px 20px 0px rgba(52, 52, 52, 0.15);

    .pay_content {
      width: 550px;
      margin: 0 auto;
      box-sizing: border-box;
      padding: 40px 0;

      .finish_pay {
        background: url("../../assets/images/finish_pay.png") center no-repeat;
        width: 110px;
        height: 110px;
        margin: 30px auto;
      }

      p {
        &:nth-of-type(1),
        &:nth-of-type(2) {
          font-size: 16px;
          color: #666666;
          text-align: center;
          margin: 0;
        }

        &:nth-of-type(1) {
          font-size: 24px;
          font-weight: 600;
        }

        &:nth-of-type(2) {
          margin: 20px 0;
        }

        &:nth-of-type(3) {
          color: #343434;
          font-size: 16px;

          span {
            &:nth-child(2) {
              float: right;
            }
          }
        }
      }

      .btn {
        margin: 40px auto 20px;
        width: 128px;
      }
    }

    ul {
      list-style: none;
      margin: 0;
      padding: 0;

      li {
        font-size: 16px;
        color: #666666;
        line-height: 25px;
      }
    }
  }
}

</style>
