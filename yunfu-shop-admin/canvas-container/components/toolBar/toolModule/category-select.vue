<template>
  <el-cascader style="width: 100%"
               ref="cascader"
               :options="categoryList"
               :props="{ checkStrictly: true,label: 'categoryName',value: 'id',children: 'childs' }"
               clearable></el-cascader>
</template>

<script>
  import api from '@@/components/canvasShow/config/api'
  import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
  import {checkEmptyChild} from '@@/config/common'
  export default {
    name: 'category-select',
    mixins: [sendReqMixin],
    data () {
      return {
        categoryList: []
      }
    },
    mounted () {
      this.getCategory()
    },
    methods: {
      // 获取类别
      getCategory () {
        var _this = this
        let params = {
          url: api.getClassify,
          method: 'GET'
        }
        this.sendReq(params, (res) => {
          _this.categoryList = res.data
          checkEmptyChild(_this.categoryList)
        })
      }
    }
  }
</script>
