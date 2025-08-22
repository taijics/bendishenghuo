<template>
  <el-dialog :close-on-click-modal="false" :title="isAdd ? '新建人群' : '修改人群'" width="80%" :visible.sync="visible">
    <div class="pending">
      <div class="addClustering pending">
        <div class="addCrowd">
          <el-form class="demo-form-inline" label-width="100px">
            <el-form-item class="inputWide" label="人群名称">
              <el-input v-model.trim="crowdData.crowdName" placeholder="请输入2-10个中文字符" maxlength="10" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" show-word-limit />
            </el-form-item>
          </el-form>
          <div class="crowdOptions">
            <div v-for="(item, index) of crowdData.conditions" :key="item.type" class="condition">
              <div class="flexBox">
                <div class="leftTit" v-text="index === 0 ? '特征筛选' : ''" />
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
                <div v-if="item.type === 9 || item.type === 10" class="purchase">
                  <el-select v-model="item.calculation" placeholder="请选择">
                    <el-option
                      v-for="calculationItem in calculationList"
                      :key="calculationItem.value"
                      :label="calculationItem.label"
                      :value="calculationItem.value"
                    />
                  </el-select>
                </div>
                <div v-if="item.type === 11" class="tagList">
                  <el-select
                    v-model="item.labelIds"
                    multiple
                    collapse-tags
                    placeholder="请选择"
                  >
                    <el-option
                      v-for="tagItem in tagList"
                      :key="tagItem.labelId"
                      :label="tagItem.labelName"
                      :value="tagItem.labelId"
                    />
                  </el-select>
                </div>
                <div v-if="item.type !== 11" class="valueBox">
                  <span v-if="item.type !== 9 && item.type !== 10">最近</span>
                  <el-input v-model="item.number" maxlength="3" oninput="value=value.replace(/[^\d]/g,'')" :placeholder="item.type !== 9 && item.type !== 10 ? '请输入1-365' : ''" />
                  <span v-if="item.type !== 9 && item.type !== 10">天</span>
                  <span v-if="item.type === 9">次</span>
                  <span v-if="item.type === 10">元</span>
                </div>
                <div class="deleteIcon" @click="deleteOptions(item, index)"><i class="el-icon-remove" /></div>
              </div>
              <p v-if="item.type === 1">选定时间内，购买过本店商品的客户（以支付成功为准，不剔除退款）</p>
              <p v-if="item.type === 2">选定时间内，没有购买过本店商品的客户（以支付成功为准，不剔除退款）</p>
              <p v-if="item.type === 3">选定时间内，在店铺有下单行为的客户（包含未付款客户）</p>
              <p v-if="item.type === 4">选定时间内，在店铺没有下单行为的客户</p>
              <p v-if="item.type === 5">选定时间内，加购过本店商品的客户</p>
              <p v-if="item.type === 6">选定时间内，没有加购过本店商品的客户</p>
              <p v-if="item.type === 7">选定时间内，访问过本店的客户</p>
              <p v-if="item.type === 8">选定时间内，没有访问过本店的客户</p>
              <p v-if="item.type === 9">客户累计在店铺交易成功的订单数量（剔除退款的订单）</p>
              <p v-if="item.type === 10">客户累计在店铺交易成功的金额数量（剔除退款金额）</p>
              <p v-if="item.type === 11">当前拥有以上任意标签的客户</p>
            </div>
            <div v-if="crowdData.conditions.length !== 11" class="addCondition" @click="addCondition">
              <i class="el-icon-circle-plus" />
              <span>添加筛选条件</span>
            </div>
          </div>
          <div class="saveBox">
            <el-button type="primary" @click="saveClustering">保 存</el-button>
            <el-button @click="closeClustering">取 消</el-button>
          </div>
        </div>
      </div>
    </div>
  </el-dialog>
</template>

<script>
import { getLabelData, addCrowd, getCrowdDetail, crowdUpdate } from '@/api/customer'
export default {
  name: 'AddClustering',
  data() {
    return {
      visible: false,
      isAdd: false,
      crowdName: '',
      shopCrowdId: '',
      crowdData: {
        conditions: [
          {
            calculation: null,
            ids: [],
            labelIds: [],
            number: null,
            type: 1,
            userIds: []
          }
        ],
        crowdName: '',
        shopCrowdId: null
      },
      tagList: [], // 标签列表
      types: [1],
      options: [
        {
          type: 1,
          name: '店铺有购买'
        },
        {
          type: 2,
          name: '店铺无购买'
        },
        {
          type: 3,
          name: '店铺有下单'
        },
        {
          type: 4,
          name: '店铺无下单'
        },
        {
          type: 5,
          name: '店铺有加购'
        },
        {
          type: 6,
          name: '店铺无加购'
        },
        {
          type: 7,
          name: '店铺有访问'
        },
        {
          type: 8,
          name: '店铺无访问'
        },
        {
          type: 9,
          name: '有效购买次数'
        },
        {
          type: 10,
          name: '有效购买金额'
        },
        {
          type: 11,
          name: '任意满足一个标签'
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
      ]
    }
  },
  mounted() {
    this.getTagList()
  },
  methods: {
    show(id) {
      this.visible = true
      if (id) {
        this.isAdd = false
        this.shopCrowdId = id
        this.getDetail()
      } else {
        this.shopCrowdId = null
        this.isAdd = true
        this.crowdData = {
          conditions: [
            {
              calculation: null,
              ids: [],
              labelIds: [],
              number: null,
              type: 1,
              userIds: []
            }
          ],
          crowdName: '',
          shopCrowdId: null
        }
      }
    },
    // 获取编辑详情
    getDetail() {
      getCrowdDetail({ shopCrowdId: this.shopCrowdId }).then(res => {
        if (res.code === '') {
          console.log(res.data)
          this.crowdData = res.data
          this.crowdData.conditions.forEach(item => {
            if (item.labelIds.length > 0) {
              let ids = []
              ids = item.labelIds.map(Number)
              item.labelIds = ids
              console.log(item.labelIds, 'fsdfsd')
            }
          })
          this.types = []
          this.crowdData.conditions.forEach(i => {
            this.types.push(i.type)
          })
        } else {
          self.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    // 添加筛选
    addCondition() {
      for (let i = 1; i <= this.options.length; i++) {
        if (!this.types.includes(i)) {
          console.log(this.crowdData.conditions, 'conditions')
          this.crowdData.conditions.push(
            {
              calculation: i === 9 || i === 10 ? 1 : null,
              ids: [],
              labelIds: [],
              number: null,
              type: i,
              userIds: []
            }
          )
          this.types.push(i)
          break
        }
      }
    },
    // 保存提交新客户
    saveClustering() {
      var self = this
      var crowds = self.crowdData.conditions
      var options = self.options
      if (this.crowdData.crowdName === '') {
        self.$message({
          message: '人群名称不能为空',
          type: 'warning'
        })
        return false
      } else if (this.crowdData.crowdName.length < 2) {
        self.$message({
          message: '人群名称长度在2-10个字符之间',
          type: 'warning'
        })
        return false
      }
      // eslint-disable-next-line no-labels
      for (let i = 0; i < crowds.length; i++) {
        if (crowds[i].type === 11) {
          if (crowds[i].labelIds.length === 0) {
            self.$message({
              message: '请选择商家标签',
              type: 'warning'
            })
            return false
          }
        } else if (crowds[i].number === null || crowds[i].number === '') {
          for (let j = 0; j < options.length; j++) {
            if (crowds[i].type === options[j].type) {
              self.$message({
                message: `选项为${options[j].name}的内容不能为空!`,
                type: 'warning'
              })
              // eslint-disable-next-line no-labels
              return false
            }
          }
        }
      }
      if (this.shopCrowdId !== '' && this.shopCrowdId !== null) {
        // 修改人群
        crowdUpdate(self.crowdData).then(res => {
          if (res.code === '') {
            self.$message({
              message: '修改成功',
              type: 'success'
            })
            this.visible = false
            this.$emit('reset')
          } else {
            self.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      } else {
        // 新增人群
        addCrowd(self.crowdData).then(res => {
          if (res.code === '') {
            self.$message({
              message: '添加成功',
              type: 'success'
            })
            this.visible = false
            this.$emit('reset')
          } else {
            self.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }
    },
    // 取消新增
    closeClustering() {
      this.visible = false
    },
    // 初始化标签数据
    async getTagList() {
      const res = await getLabelData()
      if (res.code === '') {
        this.tagList = res.data
      } else {
        this.$message({
          message: res.message,
          type: 'error'
        })
      }
    },
    // 更改当前选项
    changeType(item, index) {
      var crowdData = this.crowdData.conditions
      this.types = []
      crowdData.forEach(i => {
        this.types.push(i.type)
      })
      if (item.type === 9 || item.type === 10) {
        this.crowdData.conditions[index].calculation = 1
      }
    },
    // 删除当前筛选
    deleteOptions(item, index) {
      this.types.splice(index, 1)
      this.crowdData.conditions.splice(index, 1)
    }
  }
}
</script>

<style lang="scss" scoped>
//@import url(); 引入公共css类
@import url("../../styles/elDialog.scss");
.addClustering {
  background: #FFFFFF;
  h3 {
    font-size: 20px;
    color: #333333;
    font-weight: 500;
  }
  .addCrowd {
    margin-left: 200px;
    .crowdOptions {
      .condition {
        margin-top: 30px;
        p {
          font-size: 14px;
          color: #666666;
          margin-left: 100px;
          margin-top: 10px;
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
            margin-left: 50px;
          }
          .tagList {
            margin-left: 50px;
          }
          .valueBox {
            display: flex;
            align-items: center;
            margin-left: 50px;
            span {
              display: block;
              width: 60px;
              text-align: center;
              color: #666666;
            }
          }
          .deleteIcon {
            margin-left: 100px;
            .el-icon-remove:before {
              color: #ff5c5c;
              font-size: 22px;
              cursor: pointer;
            }
          }
        }
      }
    }
    .saveBox {
      display: flex;
      margin: 120px 0 20px 200px;
    }
    .addCondition {
      margin: 60px 0 0 80px;
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
  }
}
.pending {
  padding: 30px;
}
</style>
<style scoped>
.inputWide /deep/ .el-form-item__content {
  width: 300px;
}
.inputWide /deep/ .el-select {
  width: 100%;
}
.addCrowd /deep/ .demo-form-inline {
  margin-bottom: 20px;
}
</style>
