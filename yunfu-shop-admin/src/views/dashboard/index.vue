<template>
  <div class="home-page">
    <div class="total-data">
      <p class="p-title">今日数据</p>
      <ul>
        <li v-for="(item, index) in dataList" :key="index">
          <p>{{ (index === 3 ? MoneyUnit(item.value) : item.value) || 0 }}</p>
          <p>{{ item.name }}</p>
        </li>
      </ul>
    </div>
    <div class="sketch_map">
      <div class="tab_list">
        <ul>
          <li
            v-for="(item,index) in tabList"
            :key="index"
            :class="[{'active':item.show}]"
            @click="changeTab(item)"
          >{{ item.name }}</li>
        </ul>
      </div>
      <div class="echart_list">
        <div class="echart_item">
          <p class="title">用户访问趋势</p>
          <p class="title">访问用户数{{ info.count }} 次</p>
          <div ref="myEchart" class="full-size" />
          <el-button type="success" class="exportBtn" plain @click="userVisitExport">导出</el-button>
        </div>
        <div class="echart_item">
          <p class="title">订单转换漏斗</p>
          <p class="title">总转化率{{ info.rate }}%</p>
          <div ref="myEcharts" class="full-size" />
          <el-button type="success" class="exportBtn" plain @click="orderConvertExport">导出</el-button>
        </div>
        <div class="echart_item">
          <p class="title">热卖商品</p>
          <ul v-if="info.hotSellProducts&&info.hotSellProducts.length">
            <li v-for="(item, index) in info.hotSellProducts" :key="index">
              <p>{{ index + 1 }}</p>
              <p :title="item.productName">{{ item.productName }}</p>
              <p>{{ `已售 ${item.number} 件` }}</p>
            </li>
          </ul>
          <div v-else class="empty">
            <img :src="empty" alt>
            <p>暂无数据</p>
          </div>
          <el-button type="success" class="exportBtn" plain @click="hotProductsExport">导出</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import Dashboard from '@/api/Dashboard'
import echarts from 'echarts'
import empty from '@/assets/images/empty.png'
import { dashIndex, userVisitExport, orderConvertExport, hotProductsExport } from '@/api/dashboard'
export default {
  data() {
    return {
      empty: empty,
      form: {
        condition: 1
      },
      dataList: [
        { name: '店铺访问次数 (次)', value: '', field: 'total' },
        { name: '待处理订单 (件)', value: '', field: 'stayOrders' },
        { name: '售后订单 (件)', value: '', field: 'stayAfters' },
        { name: '成交金额 (万元)', value: '', field: 'money' }
      ],
      tabList: [
        { name: '最近30天', type: 4, date: '30' },
        { name: '最近7天', type: 3, date: '7' },
        { name: '昨天', type: 2, date: '1' },
        { name: '今天', type: 1, show: true, date: '0' }
      ],
      info: {},
      date: '0',
      orderData: {}
    }
  },
  mounted() {
    this.getTotalData()
  },
  methods: {
    async getTotalData() {
      const res = await dashIndex(this.form)
      if (res.code === '') {
        const d = res.data
        // 小于100元，单位为 元
        if (d.money < 10000) {
          this.dataList[3].name = '成交金额 (元)'
        }
        this.dataList.map(item => {
          item.value = d[item.field]
        })
        this.draw(res.data.visitWeek)
        this.draws(res.data.conversion)
        this.info = d
      }
    },

    turnTime(v) {
      const t = v.split('-')
      return `${Number(t[1])}/${Number(t[2])}`
    },
    changeTab(v) {
      this.tabList.map(item => {
        item.show = item.date === v.date
      })
      this.form.condition = v.type
      this.date = v.date
      this.getTotalData()
    },
    // 导出用户访问数据
    async userVisitExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      const res = await userVisitExport(this.form)
      if (!res) {
        return
      }
      this.doExportFile(res, '用户访问数据')
    },
    // 导出订单统计数据
    async orderConvertExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      const res = await orderConvertExport(this.form)
      if (!res) {
        return
      }
      this.doExportFile(res, '订单统计数据')
    },
    // 导出热卖商品数据
    async hotProductsExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      const res = await hotProductsExport(this.form)
      if (!res) {
        return
      }
      this.doExportFile(res, '热卖商品数据')
    },
    doExportFile(res, fileName) {
      const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
      if ('download' in document.createElement('a')) {
        // 非IE下载
        const elink = document.createElement('a')
        elink.download = fileName
        elink.style.display = 'none'
        elink.href = URL.createObjectURL(blob)
        document.body.appendChild(elink)
        elink.click()
        URL.revokeObjectURL(elink.href) // 释放URL 对象
        document.body.removeChild(elink)
      } else {
        // IE10+下载
        navigator.msSaveBlob(blob, fileName)
      }
    },
    draw(arr) {
      const myEchart = echarts.init(this.$refs.myEchart, 'light')
      const option = {
        xAxis: {
          type: 'category',
          data: arr.time
        },
        yAxis: {
          type: 'value',
          name: '次数'
        },
        series: [
          {
            data: arr.total,
            type: 'line'
          }
        ]
      }

      myEchart.setOption(option)
    },
    draws(arr) {
      const myEchart = echarts.init(this.$refs.myEcharts, 'light')
      // const o = this.chartData
      const option = {
        // color: ["#74d1fd", "#009ae4", "#0071c1"],
        // 设置图表的位置
        grid: {
          x: 110, // 左间距
          y: 0, // 上间距
          x2: 60, // 右间距
          y2: 40 // 下间距
        },
        // 提示框组件
        tooltip: {
          trigger: 'axis', // 触发类型, axis: 坐标轴触发
          axisPointer: {
            // 指示器类型  'line' 直线指示器 'shadow' 阴影指示器 'none' 无指示器
            // 'cross' 十字准星指示器 其实是种简写，表示启用两个正交的轴的 axisPointer
            type: 'none'
          },
          textStyle: {
            color: '#cdd3ee' // 文字颜色
          },
          // 提示框浮层内容格式器，支持字符串模板和回调函数两种形式 折线（区域）图、柱状（条形）图、K线图
          // {a}（系列名称），{b}（类目值），{c}（数值）, {d}（无）
          formatter: '{b}<br />{a0}: {c0}%'
        },
        // // 图例组件
        // legend: {
        //   textStyle: {
        //     // 文本样式
        //     fontSize: 16,
        //     color: "#cdd3ee"
        //   },
        //   top: 13, // 定位
        //   data: ["已完成", "进行中", "未完成"] // 图例的数据数组
        // },
        // X轴
        xAxis: {
          type: 'value', // 坐标轴类型,   'value' 数值轴，适用于连续数据
          // 坐标轴刻度
          axisTick: {
            show: false // 是否显示坐标轴刻度 默认显示
          },
          // 坐标轴轴线
          axisLine: {
            // 是否显示坐标轴轴线 默认显示
            show: false // 是否显示坐标轴轴线 默认显示
          },
          // 坐标轴在图表区域中的分隔线
          splitLine: {
            show: false // 是否显示分隔线。默认数值轴显示
          },
          // 坐标轴刻度标签
          axisLabel: {
            show: false // 是否显示刻度标签 默认显示
          }
        },
        yAxis: [
          // 左侧Y轴
          {
            // 坐标轴类型,  'category' 类目轴，适用于离散的类目数据
            // 为该类型时必须通过 data 设置类目数据
            type: 'category',
            // 坐标轴刻度
            axisTick: {
              show: false // 是否显示坐标轴刻度 默认显示
            },
            // 坐标轴轴线
            axisLine: {
              // 是否显示坐标轴轴线 默认显示
              show: false, // 是否显示坐标轴轴线 默认显示
              lineStyle: {
                // 坐标轴线线的颜色
                color: '#cdd3ee'
              }
            },
            // 坐标轴在图表区域中的分隔线
            splitLine: {
              show: false // 是否显示分隔线。默认数值轴显示
            },
            // 坐标轴刻度标签
            axisLabel: {
              show: true, // 是否显示刻度标签 默认显示
              fontSize: 16, // 文字的字体大小
              color: '#cdd3ee', // 刻度标签文字的颜色
              // 使用字符串模板，模板变量为刻度默认标签 {value}
              formatter: '{value}'
            },
            // 类目数据，在类目轴（type: 'category'）中有效
            data: arr.names.reverse()
          }
        ],
        // 系列列表
        series: [
          {
            type: 'bar', // 系列类型
            name: '已完成',
            barMaxWidth: 20, // 柱条的最大宽度，不设时自适应
            // label: {
            //   show: true,
            //   position: "inside"
            // },
            itemStyle: {
              barBorderRadius: [10, 0, 0, 10] // 圆角半径, 单位px, 支持传入数组分别指定 4 个圆角半径
            },
            data: arr.rates.reverse() // 系列中的数据内容数组
          }
        ]
      }

      myEchart.setOption(option)
    },
    MoneyUnit(v) {
      if (!v) return 0
      if (v < 10000) {
        return v.toFixed(2)
      } else {
        return (v / 10000).toFixed(2)
      }
    }
  }
}
</script>

<style lang='scss' scoped>
ul {
  list-style: none;
}
.home-page {
  height: 100%;
  .total-data {
    .p-title {
      padding-left: 20px;
      font-size: 24px;
      font-weight: 400;
      color: rgba(51, 51, 51, 1);
      line-height: 50px;
      height: 50px;
      margin: 0;
    }
    ul {
      overflow: hidden;
      display: flex;
      padding: 0;
      li {
        padding: 0;
        box-sizing: border-box;
        flex: 4;
        width: 400px;
        height: 140px;
        background: rgba(255, 255, 255, 1);
        border: 1px solid rgba(224, 229, 235, 1);
        border-radius: 4px;
        margin: 20px;
        p {
          margin: 0;
          height: 70px;
          line-height: 70px;
          text-align: center;
          &:nth-child(1) {
            font-size: 48px;
            font-weight: 600;
          }
          &:nth-child(2) {
            font-size: 18px;
          }
        }
        &:nth-child(1) {
          p:nth-child(1) {
            color: #1acda1;
          }
        }
        &:nth-child(2) {
          p:nth-child(1) {
            color: #ffae11;
          }
        }
        &:nth-child(3) {
          p:nth-child(1) {
            color: #ff7911;
          }
        }
        &:nth-child(4) {
          p:nth-child(1) {
            color: #3a68f2;
          }
        }
      }
    }
  }

  .sketch_map {
    height: calc(100% - 260px);
    box-sizing: border-box;
    background: #fff;
    padding: 0 20px;
    .tab_list {
      border-bottom: 1px solid #e0e5eb;
      overflow: hidden;
      margin-bottom: 20px;
      ul {
        overflow: hidden;
        float: right;
        width: 60%;
        padding: 0;
        margin: 0;
        li {
          padding: 0 20px;
          margin: 0;
          float: right;
          height: 60px;
          line-height: 60px;
          color: #999999;
          font-size: 18px;
          &:hover {
            cursor: pointer;
          }
          &:nth-child(1) {
            padding-right: 0;
          }
        }
        .active {
          color: #3a68f2;
          border-bottom: 3px solid #3a68f2;
        }
      }
    }
    .echart_list {
      height: calc(100% - 100px);
      .echart_item {
        position: relative;
        padding-left: 20px;
        box-sizing: border-box;
        height: calc(100% - 30px);
        width: calc((100% - 40px) / 3);
        background: rgba(255, 255, 255, 1);
        border: 1px solid rgba(224, 229, 235, 1);
        box-shadow: 0px 5px 10px 0px rgba(51, 51, 51, 0.15);
        border-radius: 4px;
        float: left;
        .echart {
          height: calc(100% - 100px);
        }
        &:nth-child(-n + 2) {
          margin-right: 20px;
        }
        .title {
          margin: 0;
          height: 50px;
          line-height: 50px;
          font-size: 18px;
          color: #333333;
          &:nth-child(2) {
            text-align: center;
            color: #3a68f2;
            font-size: 14px;
          }
        }
        ul {
          height: calc(100% - 50px);
          margin: 0;
          padding: 0;
          li {
            height: 10%;
            display: flex;
            margin-bottom: 20px;
            p {
              float: left;
              // text-align: center;
              text-indent: 2em;
              padding: 0;
              margin: 0;
              color: #333333;
              font-size: 14px;
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;
              &:nth-child(1) {
                flex: 2;
              }
              &:nth-child(2) {
                flex: 6;
              }
              &:nth-child(3) {
                flex: 4;
              }
            }
          }
        }
        .exportBtn {
          position: absolute;
          right: 10px;
          top: 10px;
        }
      }
    }
  }
}
.empty {
  height: 450px;
  img {
    width: 80px;
    height: 80px;
    margin: 100px auto 10px;
    display: block;
  }
  p {
    text-align: center;
    color: #333333;
  }
}
.full-size {
  height: 500px;
}
</style>
