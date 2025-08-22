/**
  二级导航栏
 */
<template>
  <div class="secondNav">
    <div class="contentNav">
      <div class="logo">
        <router-link to="/">
          <icon-svg icon-class="logo" />
        </router-link>
      </div>
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
          <input type="text" v-model="keyword" @keyup.enter="searchPro" placeholder="请输入搜索商品">
        </div>
        <span class="btn cur-poi" @click="searchPro"><i class="icon el-icon-search"></i></span>
      </div>
    </div>
  </div>
</template>

<script>
import {mapMutations} from 'vuex'
export default {
  data () {
    return {
      searchVal: '宝贝',
      keyword: ''
    }
  },
  methods: {
    ...mapMutations({
        setSearchObj: 'SET_SEARCHOBJ'
    }),
    searchCommand (command) {
      this.searchVal = command
    },
    searchPro () {
      if (!this.keyword) { return this.$message.error('请输入搜索内容') }
      this.setSearchObj({
        keyword: this.keyword,
        searchVal: this.searchVal
      })
      if (this.$route.name !== 'search') {
        this.$router.push({
          path: '/activity/search'
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.secondNav{
  width: 100%;
  .contentNav{
    max-width: 1250px;
    height: 80px;
    margin: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .logo{
      font-size: 60px;
    }
    .search{
      width: 394px;
      height: 39px;
      border: 2px solid #F3F4F5;
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
}
</style>
