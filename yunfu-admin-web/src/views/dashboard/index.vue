<template>
  <div class="dashboardPage">
    <div class="top">
      <CardBox
        v-for="item in cardList"
        :key="item.value"
        :card-data="item"
        :title="item.title"
        :color="item.color"
        :background-color="item.background"
        :today-color="item.todayColor"
        class="cardbox"
      />
    </div>
    <div class="chartContainer">
      <h2>当日订单金额</h2>
      <div ref="chartMoney" class="chartMoney"></div>
      <h2>数据统计</h2>
      <div class="chartCard">
        <div class="dailyCard">
          <div class="cardContainer">
            <MiniCard
              :title="'当日订单数'"
              :precent="'日同比'"
              :nums="orderData.dayNum"
              :precent-data="orderData.dayPrecent"
            />
            <MiniCard
              :title="'当月订单数'"
              :precent="'月同比'"
              :nums="orderData.mounthNum"
              :precent-data="orderData.mounthPrecent"
            />
          </div>
          <div ref="orderTotal" class="chart"></div>
        </div>
        <div class="dailyCard">
          <div class="cardContainer">
            <MiniCard
              :title="'当日支付人数'"
              :precent="'日同比'"
              :nums="payData.dayNum"
              :precent-data="payData.dayPrecent"
            />
            <MiniCard
              :title="'当月支付人数'"
              :precent="'月同比'"
              :nums="payData.mounthNum"
              :precent-data="payData.mounthPrecent"
            />
          </div>
          <div ref="orderPeople" class="chart"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import CardBox from '@/views/dashboard/components/HomeCard.vue'
import MiniCard from '@/views/dashboard/components/miniCard.vue'
import { homeGetChartData, homeGetFormData } from '@/api/home.js'
import { onMounted, ref } from 'vue';
import * as echarts from 'echarts'

const cardList = ref([
  {
    title: '新增用户',
    color: '#1B55AF',
    background: '#F4F7FB',
    todayColor: '#C9D7EC',
    nums: '',
    precent: '',
    lastNums: '',
    value: 1,
  },
  {
    title: '新增店铺',
    color: '#F45F20',
    background: '#FEF7F4',
    todayColor: '#FCD9CA',
    nums: '',
    precent: '',
    lastNums: '',
    value: 2,
  },
  {
    title: '访客',
    color: '#427A0A',
    background: '#F2F6EE',
    todayColor: '#CFDDC0',
    nums: '',
    precent: '',
    lastNums: '',
    value: 3,
  },
  {
    title: '浏览量',
    color: '#623CE7',
    background: '#F4F1FD',
    todayColor: '#D7CDF9',
    nums: '',
    precent: '',
    lastNums: '',
    value: 4,
  },
])
const chart = ref([
  new ChartObj('chartMoney', '订单金额'),
  new ChartObj('orderTotal', '订单数'),
  new ChartObj('orderPeople', '订单支付人数'),
])
const orderData = ref(new CardData())
const payData = ref(new CardData())

onMounted(() => {
  chartList = {
    chartMoney,
    orderTotal,
    orderPeople
  }
  getFormData()
  getChartData()
  chart.value.forEach((item) => {
    initChart(item)
  })
})

function getFormData () {
  homeGetFormData().then(res => {
    cardList.value[0] = Object.assign(cardList.value[0], {
      nums: res.data.todayNewUser,
      precent: res.data.weekRelativeRatioNewUser,
      lastNums: res.data.yesterdayNewUser,
    })
    cardList.value[1] = Object.assign(cardList.value[1], {
      nums: res.data.todayShopCount,
      precent: res.data.weekRelativeRatioShopCount,
      lastNums: res.data.yesterdayShopCount,
    })
    cardList.value[2] = Object.assign(cardList.value[2], {
      nums: res.data.todayVisitUser,
      precent: res.data.weekRelativeRatioVisitUser,
      lastNums: res.data.yesterdayVisitUser,
    })
    cardList.value[3] = Object.assign(cardList.value[3], {
      nums: res.data.todayVisitCount,
      precent: res.data.weekRelativeRatioVisitCount,
      lastNums: res.data.yesterdayVisitCount,
    })
  })
}

function getChartData () {
  homeGetChartData().then(res => {
    // 过去一个月订单金额列表
    res.data.orderAmountList.forEach((item) => {
      if (!item.statsDate.split) {
        return
      }
      const xAxis = `${item.statsDate.split('-')[1]}.${
        item.statsDate.split('-')[2]
      }`
      chart.value[0].xAxis.push(xAxis)
      chart.value[0].series.push(item.amount)
    })
    // 过去一个月订单量
    res.data.orderCountList.forEach((item) => {
      if (!item.statsDate.split) {
        return
      }
      const xAxis = `${item.statsDate.split('-')[1]}.${
        item.statsDate.split('-')[2]
      }`
      chart.value[1].xAxis.push(xAxis)
      chart.value[1].series.push(item.totalCount)
    })
    // 过去一个月支付人数
    res.data.payUserCountList.forEach((item) => {
      if (!item.statsDate.split) {
        return
      }
      const xAxis = `${item.statsDate.split('-')[1]}.${
        item.statsDate.split('-')[2]
      }`
      chart.value[2].xAxis.push(xAxis)
      chart.value[2].series.push(item.totalCount)
    })
    orderData.value = {
      dayNum: res.data.todayOrderCount || 0,
      dayPrecent: res.data.dayToDayOrderCountRelativeRate || 0,
      mounthNum: res.data.curMonthOrderCount || 0,
      mounthPrecent: res.data.monthToMonthOrderCountRelativeRate || 0,
    }
    payData.value = {
      dayNum: res.data.todayPayUserCount || 0,
      dayPrecent: res.data.dayToDayPayUserCountRelativeRate || 0,
      mounthNum: res.data.curMonthPayUserCount || 0,
      mounthPrecent: res.data.monthToMonthPayUserCountRelativeRate || 0,
    }
    paintLineChart(chart.value[0])
    paintLineChart(chart.value[1])
    paintLineChart(chart.value[2])
  })
}

const chartMoney = ref()
const orderTotal = ref()
const orderPeople = ref()
let chartList;
function initChart (chartObj) {
  chartObj.chart = echarts.init(chartList[chartObj.name].value)
  chartObj.chart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c}',
      axisPointer: {
        type: 'cross',
      },
    },
  })
}

function paintLineChart (chartObj) {
  chartObj.chart.setOption({
    color: ['#5470c6'],
    xAxis: {
      type: 'category',
      axis: 'auto',
      data: chartObj.xAxis,
    },
    yAxis: {
      type: 'value',
      axisPointer: {
        snap: true,
      },
    },
    series: [
      {
        name: chartObj.title,
        data: chartObj.series,
        type: 'line',
        smooth: true, // 是否平滑
      },
    ],
  })
}

function ChartObj (ref, title) {
  this.name = ref
  this.chart = null
  this.title = title
  this.xAxis = []
  this.yAxis = []
  this.series = []
}

function CardData () {
  this.dayNum = 0
  this.dayPrecent = 0
  this.mounthNum = 0
  this.mounthPrecent = 0
}

</script>

<style
    lang="scss"
    scoped
>
.dashboardPage {
  width: 100%;

  .top {
    padding: 28px 10px;
    background-color: #fff;
    display: flex;
    justify-content: space-between;

    .cardbox {
      margin: 0 10px;
      cursor: default;
      flex: 1;
    }
  }

  .chartContainer {
    margin: 20px;
    padding: 20px;
    background-color: #fff;

    h2 {
      margin: 12px 0;
      font-weight: bold;
    }

    .chartMoney {
      width: 100%;
      height: 400px;
    }

    .chartCard {
      min-height: 300px;
      display: flex;

      .dailyCard {
        flex: 1;
        padding: 12px 20px;

        .cardContainer {
          display: flex;
        }

        .chart {
          min-height: 300px;
        }
      }
    }
  }
}
</style>
