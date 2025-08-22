<template>
  <div class="typeChartPage">
    <div ref="typeChart" class="typeChart"></div>
  </div>
</template>

<script setup>
import ChartOption from './module.js'
import * as Echarts from 'echarts';
import { onMounted, ref, toRefs, watch } from 'vue';
const props = defineProps({
  classifyData: {
    type: Array,
    default: () => [],
  }
})
const { classifyData } = toRefs(props)
const chart = ref(new ChartOption('typeChart'))
watch(classifyData, (nVal, oVal) => { setOptions(chart.value.chart, nVal) }, { deep: true })
onMounted(() => {
  initChart(chart.value)
})
const typeChart = ref()
function initChart (chartObj) {
  chartObj.chart = Echarts.init(typeChart.value)
  setOptions(chartObj.chart, classifyData.value)
}
// 销售类别分布
function setOptions (chart, data) {
  chart.setOption({
    title: {
      text: '销售类别分布',
    },
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)',
    },
    color: ['#3AA0FF', '#35CACA', '#FAD337', '#F1627B', '#965DE4'],
    legend: {
      orient: 'vertical',
      right: 10,
      top: 20,
    },
    series: [
      {
        name: '访问来源',
        type: 'pie',
        radius: ['50%', '70%'],
        labelLine: {
          normal: {
            length: 20,
            length2: 70,
            lineStyle: {
              color: '#333',
            },
          },
        },
        label: {
          show: false,
          position: 'center',
        },
        itemStyle: {
          normal: {
            formatter: '{b|{b}}{a|{d}%}\n\n',
            borderWidth: 20,
            borderRadius: 4,
            padding: [0, -70],
            rich: {
              a: {
                color: '#333',
                fontSize: 12,
                lineHeight: 20,
              },
              b: {
                fontSize: 12,
                lineHeight: 20,
                color: '#333',
              },
            },
          },
        },
        data: data || [
          {
            classifyId: 0,
            name: '无',
            value: 0,
          },
        ],
      },
    ],
  })
}
</script>

<style lang="scss" scoped>
.typeChartPage {
  width: 100%;
  height: 100%;
  .typeChart {
    width: 100%;
    height: 100%;
  }
}
</style>
