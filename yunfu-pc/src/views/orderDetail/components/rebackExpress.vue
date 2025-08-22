/**
  录入退货物流
 */
<template>
  <div class="rebackExpress">
    <h1>退货物流</h1>
    <div class="inputContainer">
      <div>
        <span>物流公司：</span>
        <el-select
          v-model="express"
          filterable
          placeholder="请选择物流公司（可输入内容进行搜索）"
        >
          <el-option
            v-for="item in options"
            :key="item.dictId"
            :label="item.dictName"
            :value="item.dictId">
          </el-option>
        </el-select>
      </div>
      <div>
        <span>物流单号：</span>
        <el-input v-model="expressid" placeholder="请输入物流单号" />
      </div>
    </div>
    <el-button @click="submitExpress">确认提交</el-button>
  </div>
</template>

<script>
import {
  getExpressCompany
} from '@/api/user/express.js'
export default {
  data () {
    return {
      options: [],
      expressid: '',
      express: '',
      value: null
    }
  },
  created () {
    this.getExpressOption()
  },
  methods: {
    async getExpressOption () {
      const response = await getExpressCompany()
      const res = response.data
      if (res.code === '200') {
        this.options = res.data
      } else {
        this.$message({
            message: res.message,
            type: 'warning'
        })
      }
    },
    submitExpress () {
      this.$emit('submit', {
        deliverFormid: this.expressid,
        express: this.express
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.rebackExpress{
  height: 200px;
  padding: 20px 30px;
  border: 1px solid #F3F4F5;
  .inputContainer{
    height: 40px;
    margin-top: 10px;
    display: flex;
    div{
      flex: 1;
      display: flex;
      align-items: center;
      span{
        width: 150px;
        text-align: right;
      }
      >>>.el-input__inner{
        border-radius: 0;
      }
    }
  }
  .el-button{
    width: 200px;
    height: 50px;
    display: block;
    margin: 30px auto;
    color: #FFEBC4;
    background-color: #333333;
    border-radius: 0;
  }
}
</style>
