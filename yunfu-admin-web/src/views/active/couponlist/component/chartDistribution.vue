<template>
  <!-- 分布统计 -->
  <div class="distributionChart">
    <div
      v-for="(item, index) in charts"
      :key="index"
      :ref="(e)=>setChart(e,item)"
      class="pieChart"
    ></div>
  </div>
</template>

<script setup>
import ChartOption from './module.js'
import * as Echarts from 'echarts'
import { onMounted, ref, toRefs, watch } from 'vue';

const props = defineProps({
  chartData: {
    type: Object,
    default: () => ({}),
  }
})
const { chartData } = toRefs(props)
const charts = ref([
  new ChartOption('chart1'),
  new ChartOption('chart2'),
  new ChartOption('chart3'),
  new ChartOption('chart4'),
])

watch(() => chartData.value, (nVal) => {
  chartFns1(charts.value[0].chart, nVal.cityPeople)
  chartFns2(charts.value[1].chart, nVal.newOlds)
  chartFns3(charts.value[2].chart, nVal.terminals)
  chartFns4(charts.value[3].chart, nVal.newOlds)
}, { deep: true })
onMounted(() => {
  charts.value.forEach((item) => {
    initChart(item)
  })
  chartFns1(charts.value[0].chart, chartData.value.cityPeople || [])
  chartFns2(charts.value[1].chart, chartData.value.newOlds || [])
  chartFns3(charts.value[2].chart, chartData.value.terminals || [])
  chartFns4(charts.value[3].chart, chartData.value.newOlds || [])
})
let chartObject = {}
function setChart (e, item) {
  chartObject[item.name] = e
}

function initChart (chartObj) {
  chartObj.chart = Echarts.init(chartObject[chartObj.name])
  chartObj.chart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)',
    },
    label: {
      show: false,
      position: 'center',
    },
    labelLine: {
      normal: {
        length: 20,
        length2: 70,
        lineStyle: {
          color: '#333',
        },
      },
    },
  })
}

function chartFns1 (chart, data) {
  if (!data || !data.length) {
    data = [{ name: '暂无数据', value: 0 }]
  }
  chart.setOption({
    title: {
      text: '省份分布',
      x: 'center',
      y: 'bottom',
    },
    color: ['#3A68F2', '#DDDDDD', '#48B9C1', '#A27DE2', '#32C0D6'],
    series: [
      {
        name: '访问来源',
        type: 'pie',
        // radius: ["50", "40"],
        itemStyle: {
          normal: {
            formatter: '{b|{b}}{a|{d}%}\n\n',
            borderWidth: 20,
            borderRadius: 4,
            padding: [0, -120],
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
        data: data,
      },
    ],
  })
}

function chartFns2 (chart, data) {
  if (!data || !data.length) {
    data = [{ name: '暂无数据', value: 0 }]
  }
  chart.setOption({
    title: {
      text: '访问类型',
      x: 'center',
      y: 'bottom',
    },
    color: ['#3A68F2', '#DDDDDD'],
    series: [
      {
        name: '访问来源',
        type: 'pie',
        radius: ['50%', '70%'],
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
        data,
      },
    ],
  })
}

function chartFns3 (chart, data) {
  if (!data || !data.length) {
    data = [{ name: '暂无数据', value: 0 }]
  }
  chart.setOption({
    title: {
      text: '终端分布',
      x: 'center',
      y: 'bottom',
    },
    color: ['#3A68F2', '#DDDDDD'],
    series: [
      {
        name: '访问来源',
        type: 'pie',
        radius: ['50%', '70%'],
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
        data,
      },
    ],
  })
}

function chartFns4 (chart, data) {
  if (!data || !data.length) {
    data = [{ name: '暂无数据', value: 0 }]
  }
  chart.setOption({
    title: {
      text: '操作系统情况',
      x: 'center',
      y: 'bottom',
    },
    color: ['#3A68F2', '#DDDDDD'],
    series: [
      {
        name: '访问来源',
        type: 'pie',
        radius: ['50%', '70%'],
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
        data,
      },
    ],
  })
}

</script>

<style
    lang="scss"
    scoped
>
.distributionChart {
  width: 100%;
  height: 100%;
  display: flex;
  flex-wrap: wrap;

  .pieChart {
    width: 50%;
    height: 300px;
  }
}
</style>
