<template>
  <div class="header">
    <nav class="nav">
      <ul>
        <li class="on">
          <router-link to="/">
            首页
          </router-link>
        </li>
        <li v-for="(item,index) in categoryList.slice(0, 6)" :key="index" @click="jumpCategory(item)">
          {{item.classifyName}}
        </li>
      </ul>
    </nav>
    <div class="search">
      <div class="searchSelect">
        <el-dropdown @command="searchCommand" trigger="click">
              <span class="el-dropdown-link">{{searchVal}}
                <i class="el-icon-arrow-down cur-poi el-icon--right"></i>
              </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="宝贝">宝贝</el-dropdown-item>
            <el-dropdown-item command="店铺">店铺</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
      <div class="searchRight">
        <input type="text"
          v-model="keyword"
          @keyup.enter="searchPro"
          placeholder="请输入搜索商品"
        >
      </div>
      <span class="btn cur-poi" @click="searchPro">
        <i class="icon el-icon-search"></i>
      </span>
    </div>
  </div>
</template>

<script>
import {
  getCategory
} from '@/api/nav.js'
import { mapMutations } from 'vuex'
export default {
  name: 'homHeader',
  data () {
    return {
      searchVal: '宝贝',
      keyword: '',
      categoryList: []
    }
  },
  mounted () {
    this.getCategoryData()
  },
  methods: {
    ...mapMutations({
      setSearchObj: 'SET_SEARCHOBJ'
    }),
    searchCommand (command) {
      this.searchVal = command
    },
    // 查找
    searchPro () {
      this.setSearchObj({
        keyword: this.keyword,
        searchVal: this.searchVal
      })
      if (this.$route.name !== 'search') {
        this.$router.push({
          path: '/activity/search'
        })
      }
    },
    async getCategoryData () {
      const response = await getCategory()
      const res = response.data
      if (res.code === '200') {
        this.categoryList = res.data
      }
    },
    // 跳转到类别主页
    jumpCategory (item) {
      this.$router.push({
        name: 'category',
        query: {
          classifyData: JSON.stringify(item)
        }
      })
    }
  }
}
</script>

<style scoped lang="scss">
$lightBlack: #666666;
$navSearchHeight: 39px;
.header{
  height: 80px;
  width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: nowrap;
  .nav{
    float: left;
    padding-top: 30px;
    ul{
      width: 760px;
      display: flex;
      justify-content: space-between;
    }
    li{
      font-size: 16px;
      line-height: 21px;
      padding-bottom: 24px;
      color: #333;
      cursor: pointer;
      border-bottom: 3px solid #fff;
      &.on,&:hover{
        color: #C5AA7B;
        border-color: #C5AA7B;
      }
    }
  }
  .search{
    width: 394px;
    height: 39px;
    border: 2px solid #F3F4F5;
    float: right;
    // margin-top: 21px;
    display: flex;
    .searchSelect{
      width: 82px;
      height: 30px;
      margin-top: 2px;
      border-right: 1px solid #CCCCCC;
      text-align: center;
      line-height: 30px;
      .el-dropdown{
        color: #C5AA7B;
      }
    }
    .searchRight{
      flex: 1;
      input{
        padding-left: 15px;
        font-size: 14px;
        color: #333;
        line-height: 35px;
      }
    }
    .btn{
      font-size: 20px;
      line-height: 35px;
      padding-right: 15px;
    }
  }
}
</style>
