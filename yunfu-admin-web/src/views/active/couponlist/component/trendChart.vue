<template>
  <div class="trendChartPage">
    <div class="btns">
      <el-select
        v-model="value"
        placeholder="请选择"
      >
        <el-option
          v-for="item in options"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </el-select>
    </div>
    <div
      ref="trendChart"
      class="trendChart"
    ></div>
  </div>
</template>

<script setup>
import ChartOption from './module.js'
import { onMounted, ref, toRefs, watch } from 'vue';
import * as Echarts from 'echarts';
const props = defineProps({
  chartData: {
    type: Object,
    default: () => ({}),
  }
})
const { chartData } = toRefs(props)

const options = ref([
  {
    value: '1',
    label: '销售额趋势',
  },
  {
    value: '2',
    label: '访问量趋势',
  },
])
const value = ref('销售额趋势')
const chart = ref(new ChartOption('trendChart'))

watch(chartData, (nVal, oVal) => {
  setOptions(chart.value.chart, nVal)
}, {
  deep: true
})
watch(chartData, (nVal, oVal) => {
  setOptions(chart.value.chart, chartData.value)
})
onMounted(() => {
  initChart(chart.value)
})

const trendChart = ref()
function initChart (chartObj) {
  chartObj.chart = Echarts.init(trendChart.value)
  setOptions(chartObj.chart, chartData.value)
}
function setOptions (chart, data) {
  chart.setOption({
    title: {
      text: value.value === '1' ? '销售额趋势' : '访问量趋势',
      x: 'center',
      y: 'bottom',
    },
    xAxis: {
      type: 'category',
      data: data.times || [],
    },
    yAxis: {
      type: 'value',
    },
    series: [
      {
        itemStyle: {
          color: new Echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#83bff6' },
            { offset: 0.5, color: '#188df0' },
            { offset: 1, color: '#188df0' },
          ]),
        },
        name: value.value === '1' ? '销售' : '访问量',
        type: 'bar',
        data: value.value === '1' ? data.moneys : data.totals,
      },
    ],
  })
}
</script>

<style
    lang="scss"
    scoped
>
.trendChartPage {
  width: 100%;
  height: 100%;
  position: relative;

  .btns {
    display: flex;
    justify-content: flex-end;
  }

  .trendChart {
    width: 100%;
    height: 100%;
  }
}
</style>
