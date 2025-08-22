<template>
  <div class="header">
    <nav class="nav">
      <ul>
        <li class="on">
          <router-link to="/"> 首页 </router-link>
        </li>
        <li
          v-for="(item, index) in classifyData.slice(0, 6)"
          :key="index"
          @click="jumpCategory(item)"
        >
          {{ item.categoryName }}
        </li>
      </ul>
    </nav>
    <div class="search">
      <div class="searchSelect">
        <el-dropdown trigger="click">
          <span class="el-dropdown-link">宝贝
            <el-icon class="cur-poi el-icon--right"><el-icon-arrow-down /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="宝贝">宝贝</el-dropdown-item>
              <el-dropdown-item command="店铺">店铺</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
      <div class="searchRight">
        <input type="text" maxlength="20" placeholder="请输入搜索商品">
      </div>
      <span class="btn cur-poi">
        <el-icon class="icon"><el-icon-search /></el-icon>
      </span>
    </div>
  </div>
</template>
<script setup>
import commonMixin from '../mixin';
import {
  ArrowDown as ElIconArrowDown,
  Search as ElIconSearch,
} from '@element-plus/icons-vue';
const { classifyData, jumpCategory } = commonMixin();
</script>

<style lang="scss" scoped>
.header {
  height: 80px;
  width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: nowrap;
  .nav {
    float: left;
    padding-top: 30px;
    ul {
      width: 760px;
      display: flex;
      justify-content: space-between;
    }
    li {
      font-size: 16px;
      line-height: 21px;
      padding-bottom: 24px;
      color: #333;
      cursor: pointer;
      border-bottom: 3px solid #fff;
      &.on,
      &:hover {
        color: #c5aa7b;
        border-color: #c5aa7b;
      }
    }
  }
  .search {
    width: 394px;
    height: 39px;
    border: 2px solid #f3f4f5;
    float: right;
    // margin-top: 21px;
    display: flex;
    .searchSelect {
      width: 82px;
      height: 30px;
      margin-top: 2px;
      border-right: 1px solid #cccccc;
      text-align: center;
      line-height: 30px;
      .el-dropdown {
        color: #c5aa7b;
      }
    }
    .searchRight {
      flex: 1;
      input {
        padding-left: 15px;
        font-size: 14px;
        color: #333;
        line-height: 35px;
      }
    }
    .btn {
      font-size: 20px;
      line-height: 35px;
      padding-right: 15px;
      cursor: pointer;
    }
  }
}
</style>
