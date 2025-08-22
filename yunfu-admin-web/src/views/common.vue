<template>
  <div class="">
    <!-- 常用插件展示 -->
    <!-- 1.选项卡 -->
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="待处理" name="first">待处理</el-tab-pane>
      <el-tab-pane label="已通过" name="second">已通过</el-tab-pane>
      <el-tab-pane label="已拒绝" name="third">已拒绝</el-tab-pane>
    </el-tabs>

    <!-- 2.顶部搜索表单 -->
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item label="商家名称">
          <el-input
            v-model="formInline.user"
            maxlength="20"
            placeholder="请输入商家名称"
          />
        </el-form-item>
        <el-form-item label="注册手机号">
          <el-input
            v-model="formInline.user"
            maxlength="11"
            placeholder="请输入注册手机号"
          />
        </el-form-item>
        <el-form-item label="店铺类型">
          <el-select v-model="formInline.region" placeholder="请选择">
            <el-option label="区域一" value="shanghai" />
            <el-option label="区域二" value="beijing" />
          </el-select>
        </el-form-item>
        <el-form-item label="申请时间">
          <el-date-picker
            v-model="formInline.region"
            type="datetimerange"
            value-format="yyyy-MM-dd"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="onSubmit">查询</el-button>
          <el-button type="success" plain @click="onSubmit">新建商家</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 3.表格 -->
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column label="商家名称" width="220">
          <template #default="scope">{{ scope.row.date }}</template>
        </el-table-column>
        <el-table-column prop="name" label="店铺类型" />
        <el-table-column prop="name" label="注册手机号" />
        <el-table-column prop="name" label="申请时间" />
        <el-table-column label="操作" show-overflow-tooltip>
          <template #default="scope">
            <div class="btnList">
              <el-button type="text" @click="run(scope.row)">处理</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="currentPage4"
          :page-sizes="[100, 200, 300, 400]"
          :page-size="100"
          layout="total, sizes, prev, pager, next, jumper"
          :total="400"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>
  </div>
</template>

<script>
// 0是false 1是true
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';

export default {
  // import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    // 这里存放数据
    return {}
  },
  // 监听属性 类似于data概念
  computed: {},
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {},
  beforeCreate() {}, // 生命周期 - 创建之前
  beforeMount() {}, // 生命周期 - 挂载之前
  beforeUpdate() {}, // 生命周期 - 更新之前
  updated() {}, // 生命周期 - 更新之后
  beforeDestroy() {}, // 生命周期 - 销毁之前
  destroyed() {}, // 生命周期 - 销毁完成
  activated() {},
  // 方法集合
  methods: {}, // 如果页面有keep-alive缓存功能，这个函数会触发
}
</script>

<style lang="scss" scoped>
//@import url(); 引入公共css类
</style>
