<template>
  <div class="commodityGroup">
    <div class="commodityBox">
      <div class="groupTit">{{ groupData.shopGroupId ? '修改分组' : '新建分组' }}</div>
      <div class="newGroupBox">
        <el-form class="formBox" :model="groupData" label-width="150px" :rules="groupBuyRules">
          <el-form-item label="分组名称" prop="groupName">
            <el-input v-model="groupData.groupName" maxlength="20" placeholder="请输入分组名称" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" />
          </el-form-item>
          <el-form-item label="分组描述">
            <el-input
              v-model="groupData.groupDescribe"
              maxlength="200"
              type="textarea"
              :rows="4"
              placeholder="请输入分组描述"
            />
          </el-form-item>
          <el-form-item label="分组商品">
            <div class="btnBox">
              <el-radio v-model="selectGroup" label="1" /><span @click="manualAdd">手动添加</span>
              <el-radio v-model="selectGroup" label="2" /> <span @click="intelligentAdd">智能添加</span>
            </div>
          </el-form-item>
          <div v-if="groupData.conditions.length !== 0 && selectGroup === '2'" class="intelDataBox">
            <div class="intelTit">智能添加已选条件</div>
            <div class="intelList">
              <div v-for="(item, index) of groupData.conditions" :key="index" class="intelItem">
                <div class="itemBox">
                  <span v-if="item.type === 1">库存</span>
                  <span v-if="item.type === 2">价格</span>
                  <span v-if="item.type === 3">重量</span>
                  <span v-if="item.type === 4">销量</span>
                  <span v-if="item.calculation === 1">大于</span>
                  <span v-if="item.calculation === 2">等于</span>
                  <span v-if="item.calculation === 3">小于</span>
                  <span>{{ item.number }}</span>
                </div>
              </div>
            </div>
          </div>
        </el-form>
        <div v-if="selectConditions.length === 0 && selectGroup === '1'" class="isSelectList">
          <h3 class="isSelectTit">已选商品</h3>
          <div class="tableBox">
            <el-table
              ref="multipleTable"
              :data="products"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 100%"
              max-height="400"
            >
              <el-table-column label="产品主图" width="220" align="center">
                <template slot-scope="scope">
                  <img height="80" width="80" :src="scope.row.image " alt srcset>
                </template>
              </el-table-column>
              <el-table-column prop="productName" label="产品名称" width="220" align="center" />
              <el-table-column prop="originalPrice" label="价格（元）" align="center" show-overflow-tooltip />
              <el-table-column prop="stockNumber" label="库存（件）" align="center" show-overflow-tooltip />
            </el-table>
            <div class="fenye">
              <el-pagination
                :current-page="productsPage"
                :page-sizes="[5, 10, 20, 50, 100]"
                :page-size="productsPageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="products.length"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
              />
            </div>
          </div>
        </div>
        <div class="submitBox">
          <el-button type="primary" @click="addGroup('ruleForm')">提 交</el-button>
          <el-button type="danger" @click="closeAddGroup">取 消</el-button>
        </div>
      </div>
    </div>
    <!-- 手动添加弹框 -->
    <el-dialog
      title="手动添加商品"
      :visible.sync="isShowManualAdd"
      width="65%"
      top="50px"
      class="group-dialog"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="商品名称">
            <el-input v-model="formInline.search" maxlength="20" placeholder="搜索商品名称或商品ID" />
          </el-form-item>
          <el-form-item class="tagCustomer" label="库存数量">
            <el-input v-model="formInline.minStock" maxlength="9" /><span>至</span><el-input v-model="formInline.maxStock" maxlength="9" />
          </el-form-item>
          <el-form-item class="tagCustomer" label="价格">
            <el-input v-model="formInline.minPrice" maxlength="9" /><span>至</span><el-input v-model="formInline.maxPrice" maxlength="9" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clearData">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div class="tableBox">
        <el-table
          ref="multipleTable"
          :data="shopListData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          max-height="550"
          @selection-change="handleSelectionChange"
        >
          <el-table-column
            type="selection"
            width="55"
          />
          <el-table-column label="产品主图" width="220" align="center">
            <template slot-scope="scope">
              <img height="80" width="80" :src="scope.row.image " alt srcset>
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="产品名称" width="220" align="center" />
          <el-table-column prop="originalPrice" label="价格（元）" align="center" show-overflow-tooltip />
          <el-table-column prop="stockNumber" label="库存（件）" align="center" show-overflow-tooltip />
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="formInline.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="formInline.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="shopTotal"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
          <span slot="footer" class="dialog-footer">
            <el-button type="primary" @click="saveIdList">确 定</el-button>
            <el-button @click="closeSelect">取 消</el-button>
          </span>
        </div>
      </div>
    </el-dialog>
    <!-- 智能添加弹框 -->
    <el-dialog
      title="智能添加商品"
      :visible.sync="isIntelligentAdd"
      width="50%"
      top="50px"
      class="group-dialog"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="znAddBox">
        <div class="conditionBox">
          <span class="anAddTit">满足条件</span>
          <el-radio v-model="condition" label="1">全部满足</el-radio>
          <el-radio v-model="condition" label="2">任意满足</el-radio>
        </div>
        <div class="screenBox">
          <span class="anAddTit">筛选条件</span>
          <div class="crowdOptions">
            <div v-for="(item, index) of selectConditions" :key="item.type" class="condition">
              <div class="flexBox">
                <div class="rightInfo">
                  <el-select v-model="item.type" placeholder="请选择" @change="changeType(item, index)">
                    <el-option
                      v-for="typeItem in options"
                      v-show="!types.includes(typeItem.type)"
                      :key="typeItem.type"
                      :label="typeItem.name"
                      :value="typeItem.type"
                    />
                  </el-select>
                </div>
                <div class="purchase">
                  <el-select v-model="item.calculation" placeholder="请选择">
                    <el-option
                      v-for="calculationItem in calculationList"
                      :key="calculationItem.value"
                      :label="calculationItem.label"
                      :value="calculationItem.value"
                    />
                  </el-select>
                </div>
                <div class="valueBox">
                  <el-input v-model="item.number" maxlength="9" />
                </div>
                <div v-if="selectConditions.length !== 1" class="deleteIcon" @click="deleteOptions(item, index)"><i class="el-icon-remove" /></div>
              </div>
            </div>
            <div v-if="groupData.conditions.length !== 4" class="addCondition" @click="addCondition">
              <i class="el-icon-circle-plus" />
              <span>添加筛选条件</span>
            </div>
          </div>
        </div>
      </div>
      <div class="fenye">
        <span slot="footer" class="dialog-footer">
          <el-button type="primary" @click="saveOptions">确 定</el-button>
          <el-button @click="closeOptions">取 消</el-button>
        </span>
      </div>
    </el-dialog>
  </div>
</template>
<script>
function GroupData() {
  this.condition = null // 满足条件 1-全部满足 2-任意满足
  this.conditions = [ // 筛选条件数组
    // {
    //   calculation: 1, // 运算符 1-大于 2-等于 3-小于
    //   ids: [], // 已满足部分条件的商品id数组
    //   number: null, // 数值
    //   type: 1 // 类型 1-库存 2-价格 3-重量 4-销量
    // }
  ]
  this.groupDescribe = '' // 分组描述
  this.groupImage = '' // 分组封面图片地址
  this.groupName = '' // 分组名称
  this.ids = [] // 商品id数组
  this.shopGroupId = null // 商品分组id
}
import { commodityListAdd, commodityListUpdate, getGroupList, commodityListGetById } from '@/api/commodity'
export default {
  name: 'CommodityGroup',
  props: {
    groupId: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      formInline: {
        maxPrice: null, // 价格最大值
        maxStock: null, // 库存数量最大值
        minPrice: null, // 价格最小值
        minStock: null, // 库存数量最小值
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        search: '' // 搜索字段
      },
      groupData: new GroupData(),
      isShowManualAdd: false, // 手动添加弹窗
      isIntelligentAdd: false, // 自动添加弹窗
      shopListData: [],
      shopTotal: 1,
      tableData: [],
      multipleSelection: [],
      // 智能添加
      condition: '1',
      types: [1],
      options: [
        {
          type: 1,
          name: '库存'
        },
        {
          type: 2,
          name: '价格'
        },
        {
          type: 3,
          name: '重量'
        },
        {
          type: 4,
          name: '销量'
        }
      ],
      calculationList: [
        {
          label: '大于',
          value: 1
        },
        {
          label: '等于',
          value: 2
        },
        {
          label: '小于',
          value: 3
        }
      ],
      groupBuyRules: {
        groupName: [
          { required: true, message: '请输入分组名称', trigger: 'blur' }
        ]
      },
      products: [], // 确定已选商品
      productsPage: 1,
      productsPageSize: 5,
      selectConditions: [], // 当前选择筛选条件
      // 分组选择
      selectGroup: '1',
      // 已选智能筛选条件
      intelData: []
    }
  },
  watch: {
    groupId: {
      handler(nVal, oVal) {
        if (!nVal) {
          this.groupData = new GroupData()
          this.products = []
          this.multipleSelection = []
        } else {
          this.groupData.shopGroupId = nVal
          this.getDetailFn()
        }
      }
    }
  },
  mounted() {
    // if (this.$route.query.shopGroupId) {
    //   this.groupData.shopGroupId = this.$route.query.shopGroupId
    //   this.getDetailFn()
    // }
    if (this.groupId) {
      this.groupData.shopGroupId = this.groupId
      this.getDetailFn()
    }
    this.getAll(this.formInline)
  },
  methods: {
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getGroupList(formInline)
      this.shopTotal = res.data.total
      this.shopListData = res.data.list
    },
    // 获取详情
    getDetailFn() {
      commodityListGetById({ shopGroupId: this.groupData.shopGroupId }).then(res => {
        if (res.code === '') {
          this.groupData.groupDescribe = res.data.groupDescribe
          this.groupData.groupName = res.data.groupName
          this.multipleSelection = res.data.products
          this.products = res.data.products
          const shopList = []
          this.products.forEach(i => {
            shopList.push(i.productId)
          })
          this.groupData.ids = shopList
          this.groupData.shopGroupId = res.data.shopGroupId
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    manualAdd() {
      this.selectGroup = '1'
      // this.groupData.conditions = []
      // this.groupData.condition = null
      this.isShowManualAdd = true
    },
    // 商品表格多选
    handleSelectionChange(val) {
      this.multipleSelection = val
      this.groupData.ids = []
    },
    // 分页大小
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    // 分页
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    intelligentAdd() {
      this.selectGroup = '2'
      if (this.selectConditions.length === 0) {
        this.selectConditions.push({
          calculation: 1, // 运算符 1-大于 2-等于 3-小于
          ids: [], // 已满足部分条件的商品id数组
          number: null, // 数值
          type: 1 // 类型 1-库存 2-价格 3-重量 4-销量
        })
      }
      // this.groupData.ids = []
      // if (this.multipleSelection.length) {
      //   this.$refs.multipleTable.clearSelection() // 清空已手动添加的商品
      // }
      // this.products = []
      // this.multipleSelection = []
      this.groupData.condition = 1
      this.isIntelligentAdd = true
    },
    // 保存手动选择商品
    saveIdList() {
      if (this.multipleSelection.length === 0) {
        this.groupData.ids = []
      }
      const shopList = []
      this.products = this.multipleSelection
      this.multipleSelection.forEach(i => {
        shopList.push(i.productId)
      })
      this.groupData.ids = shopList
      this.isShowManualAdd = false
    },
    // 取消手动选择商品
    closeSelect() {
      this.isShowManualAdd = false
    },
    // 更改当前选项
    changeType(item, index) {
      var crowdData = this.groupData.conditions
      this.types = []
      crowdData.forEach(i => {
        this.types.push(i.type)
      })
      if (item.type === 9 || item.type === 10) {
        this.groupData.conditions[index].calculation = 1
      }
    },
    // 删除当前筛选
    deleteOptions(item, index) {
      this.types.splice(index, 1)
      this.selectConditions.splice(index, 1)
    },
    // 保存智能匹配配置
    saveOptions() {
      var self = this
      var groupCond = self.selectConditions
      var options = self.options
      for (let i = 0; i < groupCond.length; i++) {
        if (groupCond[i].number === null || groupCond[i].number === '') {
          for (let j = 0; j < options.length; j++) {
            if (groupCond[i].type === options[j].type) {
              self.$message({
                message: `选项为${options[j].name}的内容不能为空!`,
                type: 'warning'
              })
              return false
            }
          }
        }
      }
      self.groupData.conditions = self.deepClone(self.selectConditions)
      self.isIntelligentAdd = false
    },
    // 保存提交
    addGroup() {
      var self = this
      if (self.groupData.groupName === '') {
        self.$message({
          message: '分组名称不能为空',
          type: 'warning'
        })
        return false
      }
      // if (self.selectGroup === '1') {
      //   if (self.groupData.ids.length === 0) {
      //     self.$message({
      //       message: '请选择手动添加分组商品',
      //       type: 'warning'
      //     })
      //     return false
      //   }
      // }
      // if (self.selectGroup === '2') {
      //   if (self.groupData.conditions.length === 0) {
      //     self.$message({
      //       message: '请添加智能筛选条件',
      //       type: 'warning'
      //     })
      //   }
      // }
      if (self.selectGroup === '1') {
        self.groupData.conditions = []
        self.groupData.condition = null
      } else {
        self.groupData.ids = []
        self.products = []
        self.multipleSelection = []
      }
      if (self.groupData.shopGroupId !== '' && self.groupData.shopGroupId !== null) {
        // 修改人群
        commodityListUpdate(self.groupData).then(res => {
          if (res.code === '') {
            this.closeAddGroup()
            self.$message({
              message: '修改成功',
              type: 'success'
            })
            self.$emit('reload')
          } else {
            self.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      } else {
        // 新增人群
        commodityListAdd(self.groupData).then(res => {
          if (res.code === '') {
            this.closeAddGroup()
            self.$message({
              message: '添加成功',
              type: 'success'
            })
            self.$emit('reload')
          } else {
            self.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }
    },
    // 取消提交
    closeAddGroup() {
      this.$emit('cancel')
    },
    // 取消智能匹配配置
    closeOptions() {
      this.isIntelligentAdd = false
      this.selectConditions = []
    },
    // 添加筛选
    addCondition() {
      for (let i = 1; i <= this.options.length; i++) {
        if (!this.types.includes(i)) {
          this.selectConditions.push(
            {
              calculation: 1, // 运算符 1-大于 2-等于 3-小于
              ids: [], // 已满足部分条件的商品id数组
              number: null, // 数值
              type: i // 类型 1-库存 2-价格 3-重量 4-销量
            }
          )
          this.types.push(i)
          break
        }
      }
    },
    // 手动查询商品
    search() {
      this.getAll(this.formInline)
    },
    clearData() {
      this.formInline = {
        maxPrice: null, // 价格最大值
        maxStock: null, // 库存数量最大值
        minPrice: null, // 价格最小值
        minStock: null, // 库存数量最小值
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        search: '' // 搜索字段
      }
      this.getAll(this.formInline)
    },
    deepClone(obj) {
      var _obj = JSON.stringify(obj)
      var objClone = JSON.parse(_obj)
      return objClone
    }
  }
}
</script>

<style lang="scss" scoped>
.commodityGroup {
  .commodityBox {
    background: #FFFFFF;
    .groupTit {
      font-size: 22px;
      color: #333333;
      font-weight: 500;
    }
    .newGroupBox {
      width: 800px;
      margin: 20px;
      .btnBox {
        display: flex;
        align-items: center;
        margin-left: 10px;
        span {
          display: block;
          width: 80px;
          height: 35px;
          line-height: 35px;
          background: #409EFF;
          color: #FFFFFF;
          font-size: 12px;
          text-align: center;
          border-radius: 4px;
          margin-right: 20px;
          cursor: pointer;
          position: relative;
        }
        i {
          display: block;
          font-style: normal;
          font-size: 12px;
          color: #409EFF;
          width: 30px;
          height: 30px;
          text-align: center;
          line-height: 30px;
          border: 1px solid #409EFF;
          border-radius: 50%;
          position: absolute;
          right: -10px;
          top: -10px;
          z-index: 999;
          background: #FFFFFF;
        }
      }
    }
  }
  .submitBox {
    width: 100%;
    margin: 20px 0;
    display: flex;
    justify-content: space-around;
  }
  .isSelectList {
    h3 {
      font-size: 14px;
      color: #666666;
      font-weight: 500;
      margin: 30px 0 20px 0;
    }
  }
}
  .znAddBox {
    padding: 30px 30px 0 30px;
    .screenBox {
      display: flex;
      margin-top: 30px;
      .crowdOptions {
        margin-left: 20px;
      }
    }
    .condition {
      margin-bottom: 20px;
      p {
        font-size: 14px;
        color: #666666;
        margin-left: 100px;
      }
      .flexBox {
        display: flex;
        align-items: center;
        .leftTit {
          width: 100px;
          text-align: right;
          font-size: 14px;
          color: #606260;
          font-weight: 700;
          padding-right: 12px;
        }
        .purchase {
          margin-left: 30px;
        }
        .tagList {
          margin-left: 30px;
        }
        .valueBox {
          display: flex;
          align-items: center;
          margin-left: 30px;
        }
        .deleteIcon {
          margin-left: 30px;
          .el-icon-remove:before {
            color: #ff5c5c;
            font-size: 22px;
            cursor: pointer;
          }
        }
      }
    }
  }
.addCondition {
  margin: 50px 0 0 0;
  display: flex;
  align-items: center;
  cursor: pointer;
  width: 160px;
  .el-icon-circle-plus:before {
    font-size: 24px;
    color: #999999;
  }
  span {
    margin-left: 10px;
  }
}
.intelDataBox {
  width: 200px;
  margin: 60px 0 0 150px;
  .intelTit {
    font-size: 14px;
    color: #666666;
    font-weight: 500;
  }
  .intelList {
    margin-top: 20px;
    border: 1px solid #eeeeee;
    .intelItem {
      display: flex;
      align-items: center;
      background: #fdfdfd;
      height: 35px;
      line-height: 35px;
      border-bottom: 1px solid #eeeeee;
      padding-left: 20px;
      span {
        font-size: 13px;
        color: #666666;
        font-weight: 600;
      }
    }
  }
}
</style>
<style scoped>
.newGroupBox /deep/ .formBox {
  width: 500px;
}
/*.group-dialog /deep/ .el-dialog__headerbtn .el-dialog__close {*/
/*  color: #FFFFFF;*/
/*}*/
.fenye {
  margin-top: 30px;
}
.fenye /deep/ .dialog-footer {
  margin: 30px auto 0 auto;
  display: flex;
  justify-content: center;
}
.znAddBox /deep/ .conditionBox {
  display: flex;
  align-items: center;
}
.znAddBox /deep/ .conditionBox .anAddTit {
  margin-right: 20px;
}
.tagCustomer /deep/ .el-form-item__content {
  display: flex;
  width: 260px;
}
.tagCustomer {
  display: flex !important;
}
.tagCustomer /deep/ .el-form-item__content span {
  margin: 0 5px;
}
.formSearch /deep/ .el-form {
  display: flex;
  flex-wrap: wrap;
}
.btnBox /deep/ .el-radio {
  margin-right: 8px;
}
.btnBox /deep/ .el-radio__label {
  display: none;
}
</style>
