<template>
  <div>
    <!-- 顶部数据 -->
    <div class="topCard">
      <div v-for="(item, index) in infoList" :key="index" class="details">
        <div class="textOne">{{ item.value }}</div>
        <div class="textTwo">
          <div class="l_text">{{ item.name }}</div>
          <div class="r_text">
            <img src="../../../assets/images/shuoming.png" alt srcset />
          </div>
        </div>
      </div>
    </div>
    <div class="centerCard">
      <div class="leftCard">
        <div id="mapChart" />
      </div>
      <div class="rightCard">
        <div class="r_sCard">
          <div id="LpieChart" />
          <div id="RpieChart" />
        </div>
        <div class="r_sCard">
          <div id="LpieCharts" />
          <div id="RpieCharts" />
        </div>
      </div>
    </div>
    <div class="botCard">
      <div class="botLeftCard">
        <el-tabs
          v-model="activeName"
          style="padding-left: 20px"
          @tab-click="handleClick"
        >
          <el-tab-pane label="销售额" name="first" />
          <el-tab-pane label="访问量" name="second" />
        </el-tabs>
        <div id="mains" ref="mains" style="width: 1100px; height: 520px" />
      </div>
      <div class="botRightCard">
        <div class="ri_top">
          <div class="text">商家成交排行榜</div>
          <div class="text">成交额/元</div>
        </div>
        <div class="ri_details">
          <div
            v-for="(item, index) in details.shopRankings"
            :key="index"
            class="list"
          >
            <span :class="[index <= 2 ? 'spanAct' : '']">{{ index + 1 }}</span>
            <span>{{ item.shopName }}</span>
            <span>{{ item.money }}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="botCard">
      <div class="botLeftCard">
        <div id="botLeftCardMain" />
      </div>
      <div class="botRightCard">
        <div class="ri_top">
          <div class="text">畅销商品排行榜</div>
          <div class="text">售卖个数/个</div>
        </div>
        <div class="ri_details">
          <div
            v-for="(item, index) in details.productRankings"
            :key="index"
            class="list"
          >
            <span :class="[index <= 2 ? 'spanAct' : '']">{{ index + 1 }}</span>
            <span>{{ item.productName }}</span>
            <span>{{ item.total }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { chinaMap } from '@/views/active/couponlist/component/map.js'
import { getChartData } from '@/api/active/active_coupon.js'
export default {
  name: 'List',
  props: {
    listId: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      activeName: 'first',
      infoList: [
        { name: '成交总额(元)', value: '0', fields: 'money' },
        { name: '支付订单数(笔)', value: '0', fields: 'orders' },
        { name: '支付客户数(人)', value: '0', fields: 'users' },
        { name: '参与商家数(家)', value: '0', fields: 'business' },
        { name: '参与商品数(件)', value: '0', fields: 'products' },
      ],
      formInline: {
        activityId: this.listId,
        page: 1,
        pageSize: 10,
      },
      details: '',
    }
  },
  mounted() {
    this.getAll()
  },
  methods: {
    async getAll() {
      // const res = await getActivitys(this.formInline)
      const res = await getChartData(this.formInline)
      if (res.code === '') {
        this.details = res.data
        this.activeName = 'first'
        this.getInfo(res.data)
        this.chartFns1(this.details)
        this.chartFns2(this.details)
        this.chartFns3(this.details)
        this.chartFns4(this.details)
        this.chartFns5(this.details, this.activeName)
        this.chartFns6(this.details)
        this.chartFns7(this.details)
      }
    },
    getInfo(o) {
      this.infoList.map((item) => {
        item.value = o[item.fields] || ''
      })
    },
    handleClick(tab, event) {
      this.activeName = tab.name
      this.chartFns5(this.details, tab.name)
    },
    chartFns1(arr) {
      // 基于准备好的dom，初始化echarts实例
      var LpieChart = this.$echarts.init(document.getElementById('LpieChart'))
      LpieChart.setOption({
        title: {
          text: '省份分布',
          x: 'center',
          y: 'bottom',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
        },
        color: ['#3A68F2', '#DDDDDD', '#48B9C1', '#A27DE2', '#32C0D6'],
        series: [
          {
            name: '访问来源',
            type: 'pie',
            // radius: ["50", "40"],
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
            data: arr.cityPeople,
          },
        ],
      })
    },
    chartFns2(arr) {
      // 基于准备好的dom，初始化echarts实例
      var RpieChart = this.$echarts.init(document.getElementById('RpieChart'))
      RpieChart.setOption({
        title: {
          text: '访问类型',
          x: 'center',
          y: 'bottom',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
        },
        color: ['#3A68F2', '#DDDDDD'],
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
            data: arr.newOlds,
          },
        ],
      })
    },
    chartFns3(arr) {
      // 基于准备好的dom，初始化echarts实例
      var LpieCharts = this.$echarts.init(document.getElementById('LpieCharts'))
      LpieCharts.setOption({
        title: {
          text: '终端分布',
          x: 'center',
          y: 'bottom',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
        },
        color: ['#3A68F2', '#DDDDDD'],
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
            data: arr.terminals,
          },
        ],
      })
    },
    chartFns4(arr) {
      // 基于准备好的dom，初始化echarts实例
      var RpieCharts = this.$echarts.init(document.getElementById('RpieCharts'))
      RpieCharts.setOption({
        title: {
          text: '操作系统情况',
          x: 'center',
          y: 'bottom',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
        },
        color: ['#3A68F2', '#DDDDDD'],
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
            data: arr.systems,
          },
        ],
      })
    },
    // 销售额趋势' : '访问量趋势
    chartFns5(arr, activeName) {
      var mains = this.$echarts.init(this.$refs.mains)
      console.log(mains)
      mains.setOption({
        tooltip: {},
        title: {
          text: activeName === 'first' ? '销售额趋势' : '访问量趋势',
          x: 'center',
          y: 'bottom',
        },
        xAxis: {
          type: 'category',
          data: arr.trend.times,
        },
        yAxis: {
          type: 'value',
        },
        series: [
          {
            itemStyle: {
              color: new this.$echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#83bff6' },
                { offset: 0.5, color: '#188df0' },
                { offset: 1, color: '#188df0' },
              ]),
            },
            name: '销量',
            type: 'bar',
            data: activeName === 'first' ? arr.trend.moneys : arr.trend.totals,
          },
        ],
      })
    },
    // 销售类别分布
    chartFns6(arr) {
      console.log('index', arr)
      // 基于准备好的dom，初始化echarts实例
      var botLeftCardMain = this.$echarts.init(
        document.getElementById('botLeftCardMain')
      )
      botLeftCardMain.setOption({
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
          data: arr.classifyName,
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
            data: arr.classifies,
          },
        ],
      })
    },
    // 访问分布情况
    chartFns7(arr) {
      var botLeftCardMain = this.$echarts.init(
        document.getElementById('mapChart')
      )
      this.$echarts.registerMap('mymap', chinaMap)
      botLeftCardMain.setOption({
        title: {
          text: '访问分布情况 ',
          subtext: '',
          sublink: '',
          left: 'left',
        },
        tooltip: {
          trigger: 'item',
          showDelay: 0,
          transitionDuration: 0.2,
          formatter: function (params) {
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
            data: arr.cities,
          },
        ],
      })
    },
  },
}
</script>

<style lang="scss" scoped>
#LpieChart {
  width: 410px;
  height: 250px;
}
#RpieChart {
  width: 410px;
  height: 250px;
}
#LpieCharts {
  width: 410px;
  height: 250px;
}
#mapChart {
  width: 610px;
  height: 500px;
}
#RpieCharts {
  width: 410px;
  height: 250px;
}
#botLeftCardMain {
  width: 1000px;
  height: 500px;
}
.topCard {
  width: 100%;
  height: 140px;
  background: #ffffff;
  box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: space-around;
  .details {
    .textOne {
      font-size: 40px;
      font-weight: bold;
      color: #ffae11;
    }
    .textTwo {
      font-size: 18px;
      color: #333333;
      display: flex;
      justify-content: center;
      align-items: center;
      .l_text {
        height: 20px;
      }
      .r_text {
        img {
          width: 20px;
          height: 20px;
          margin-left: 5px;
        }
      }
    }
  }
}
.centerCard {
  display: flex;
  margin: 20px auto;
  align-items: center;
  .leftCard {
    width: 55%;
    height: 520px;
    background: #ffffff;
    box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
    border-radius: 4px;
  }
  .rightCard {
    margin-left: 20px;
    .r_sCard {
      width: 820px;
      height: 250px;
      background: #ffffff;
      box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
      border-radius: 4px;
      margin-bottom: 10px;
      display: flex;
    }
    .r_sCard {
      width: 820px;
      height: 250px;
      background: #ffffff;
      box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
      border-radius: 4px;
    }
  }
}
.botCard {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  .botLeftCard {
    width: 1100px;
    height: 600px;
    background: #ffffff;
    box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
    border-radius: 4px;
  }
  .botRightCard {
    margin-left: 20px;
    width: 540px;
    height: 560px;
    background: #ffffff;
    box-shadow: 0px 0px 10px 0px rgba(51, 51, 51, 0.15);
    border-radius: 4px;
    .ri_top {
      width: 440px;
      display: flex;
      justify-content: space-around;
      align-items: center;
      margin-top: 20px;
      .text {
        font-size: 18px;
        color: #333333;
      }
      .text:nth-child(1) {
        margin-right: 140px;
      }
    }
    .ri_details {
      width: 440px;
      .list {
        display: flex;
        justify-content: space-around;
        align-items: center;
        margin-top: 20px;
        span {
          color: #666666;
        }
        .spanAct {
          width: 26px;
          height: 26px;
          background: #ff7911 !important;
          border-radius: 50% !important;
          display: flex;
          justify-content: space-around;
          align-items: center;
          color: #ffffff !important;
        }
        span:nth-child(1) {
          display: flex;
          justify-content: space-around;
          align-items: center;
          color: #666666;
          width: 26px;
          height: 26px;
          background: #dddddd;
          border-radius: 50%;
        }
        span:nth-child(2) {
          width: 135px;
        }
        span:nth-child(3) {
          width: 50px;
        }
      }
    }
  }
}
.botTable {
  width: 100%;
  .box-card {
    .clearfix {
      button {
        width: 60px;
        height: 38px;
        background: #3a68f2;
        border-radius: 4px;
        float: right;
        padding: 3px 0;
      }
    }
  }
}
</style>
