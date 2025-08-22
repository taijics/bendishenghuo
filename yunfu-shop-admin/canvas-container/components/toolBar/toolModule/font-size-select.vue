<template>
  <el-select class="fontSizeSelect" v-model="fontVal" placeholder="请选择" @change="fontChange">
    <el-option
      v-for="item in fontList"
      :key="item.value"
      :label="item.label"
      :value="item.value">
      <span :style="{fontSize:item.value+'px'}">{{ item.label }}</span>
    </el-option>
  </el-select>
</template>

<script>
  export default {
    name: 'font-size-select',
    props: {
      fontSize: {
        type: String,
        default: '12'
      }
    },
    data () {
      return {
        fontVal: '',
        fontList: [{
          value: '12',
          label: '12px'
        }, {
          value: '14',
          label: '14px'
        }, {
          value: '16',
          label: '16px'
        }, {
          value: '18',
          label: '18px'
        }, {
          value: '20',
          label: '20px'
        }, {
          value: '22',
          label: '22px'
        }, {
          value: '24',
          label: '24px'
        }, {
          value: '28',
          label: '28px'
        }, {
          value: '32',
          label: '32px'
        }, {
          value: '36',
          label: '36px'
        }]
      }
    },
    mounted () {
      this.fontVal = this.fontSize
    },
    methods: {
      // 获取类别
      fontChange (val) {
        this.$emit('update:fontSize', val)
      }
    }
  }
</script>

<style lang="scss" scoped>
  .fontSizeSelect{
    width: 100px;
  }
</style>
