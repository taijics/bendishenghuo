export const bgColors = [
  {
    value: 'Color010',
    label: '#638359',
  },
  {
    value: 'Color020',
    label: '#2C9F67',
  },
  {
    value: 'Color030',
    label: '#509FC9',
  },
  {
    value: 'Color040',
    label: '#5885CF',
  },
  {
    value: 'Color050',
    label: '#9062C0',
  },
  {
    value: 'Color060',
    label: '#D09A45',
  },
  {
    value: 'Color070',
    label: '#E48138',
  },
  {
    value: 'Color080',
    label: '#EE903C',
  },
  {
    value: 'Color090',
    label: '#DD6549',
  },
  {
    value: 'Color100',
    label: '#CC463D',
  },
]

export function getCouponColor (key) {
  let res = ''
  bgColors.forEach(item => {
    if (item.value === key) {
      res = item.label
    }
  })
  return res
}