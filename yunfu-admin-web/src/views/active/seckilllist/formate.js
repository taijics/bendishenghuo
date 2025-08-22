export const activityStatusSelect = [
  {
    index: 0,
    label: '报名未开始',
    value: 0,
  },
  {
    index: 1,
    label: '报名进行中',
    value: 1,
  },
  {
    index: 2,
    label: '活动待开始',
    value: 2,
  },
  {
    index: 3,
    label: '活动进行中',
    value: 3,
  },
  {
    index: 4,
    label: '活动已结束',
    value: 4,
  },
]
export function seckillTimeStatus (status) {
  let res = ''
  activityStatusSelect.forEach(item => {
    if (status === item.value) {
      res = item.label
    }
  })
  return res
}

function formateInfoList (res) {
  return [
    {
      name: '浏览量',
      value: res.data.visit || 0,
    },
    {
      name: '支付订单数',
      value: res.data.orders || 0,
    },
    {
      name: '	支付买家数',
      value: res.data.pays || 0,
    },
    {
      name: '支付转化率',
      value: res.data.conversion || 0,
    },
    {
      name: '参与商家数',
      value: res.data.shops || 0,
    },
    {
      name: '参与商品数',
      value: res.data.products || 0,
    },
    {
      name: '活动成交金额',
      value: res.data.total || 0,
    },
  ]
}