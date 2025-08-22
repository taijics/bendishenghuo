<template>
  <!-- 地区分布统计 -->
  <div class="mapChartPage">
    <div
      ref="mapChart"
      class="mapChart"
    ></div>
  </div>
</template>

<script setup>
import { chinaMap } from '@/views/active/couponlist/component/map.js'
import ChartOption from './module.js'
import { onMounted, ref, toRefs, watch } from 'vue';
import * as Echarts from 'echarts';

const props = defineProps({
  cityData: {
    type: Array,
    default: () => [],
  }
})
const { cityData } = toRefs(props)
const chart = ref(new ChartOption('mapChart'))
watch(cityData, (nVal) => {
  setOptions(chart.value.chart, nVal)
}, {
  deep: true
})
onMounted(() => {
  initChart(chart.value)
})
const mapChart = ref()
// 访问分布情况
function initChart (chartObj) {
  chartObj.chart = Echarts.init(mapChart.value)
  Echarts.registerMap('mymap', chinaMap)
  setOptions(chartObj.chart, cityData.value)
}
function setOptions (chart, data) {
  chart.setOption({
    title: {
      text: '访问分布情况 ',
      left: 'left',
    },
    tooltip: {
      trigger: 'item',
      showDelay: 0,
      transitionDuration: 0.3,
      formatter: (params) => {
        if (params.value) {
          return (
            params.seriesName + '<br/>' + params.name + ' : ' + params.value
          )
        } else {
          return params.seriesName + '<br/>' + params.name + ' : ' + '0'
        }
      },
    },
    series: [
      {
        name: '访问量',
        type: 'map',
        zoom: 1.3,
        roam: true,
        map: 'mymap',
        emphasis: {
          label: {
            show: true,
          },
        },
        // 文本位置修正
        textFixed: {
          Alaska: [20, -20],
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
.mapChartPage {
  width: 100%;
  height: 100%;

  .mapChart {
    width: 100%;
    height: 100%;
  }
}
</style>
