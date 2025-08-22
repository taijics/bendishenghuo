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