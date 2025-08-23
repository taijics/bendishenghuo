export default {
  props: {
    // 装修器会传进来的配置对象（命名保持宽松，避免未传时报错）
    value: {
      type: Object,
      default: () => ({})
    },
    // 是否为编辑态（装修画布内）
    edit: {
      type: Boolean,
      default: true
    }
  },
  computed: {
    conf() {
      const defaults = {
        title: '商家列表',
        style: {
          cardRadius: 12,
          cardShadow: true,
          padding: 12,
          gap: 12,
          titleSize: 16,
          titleColor: '#111111',
          subTextColor: '#666666',
          statusColor: '#18C46E',
          tagBg: '#E9F7EE',
          tagColor: '#18C46E'
        },
        show: {
          businessStatus: true,
          distance: true,
          soldCount: true,
          category: true,
          address: true,
          scoreTag: true
        },
        dataSource: {
          type: 'api',            // api | manual
          api: '/api/merchant/list',
          method: 'GET',
          params: { page: 1, size: 10, sort: 'distance' }
        },
        // 仅编辑态预览
        mock: {
          list: [
            {
              id: 1,
              name: '祥龙饭店',
              cover: 'https://dummyimage.com/200x150/efefef/333&text=Shop',
              sold: 1,
              status: '营业中',
              distance: '3.12km',
              category: '餐饮美食',
              address: '宣汉县幸福家园',
              scorePercent: 0.1,
              scoreTagText: '积 10.00%'
            },
            {
              id: 2,
              name: '通川区百宏建材经营部',
              cover: 'https://dummyimage.com/200x150/efefef/333&text=Shop',
              sold: 4,
              status: '营业中',
              distance: '26.77km',
              category: '建材家居',
              address: '邦泰·天著',
              scorePercent: 0.2,
              scoreTagText: '积 20.00%'
            }
          ]
        }
      }
      return Object.assign({}, defaults, this.value || {})
    },
    // 编辑态使用 mock，运行态等上层传 list 或组件内自行拉取
    list() {
      if (this.edit && this.conf.mock && Array.isArray(this.conf.mock.list)) {
        return this.conf.mock.list
      }
      if (Array.isArray(this.conf.list)) return this.conf.list
      return []
    }
  }
}