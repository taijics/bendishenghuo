// 导入api接口模块
export const panelList = [{
    title: '基础组件',
    type: 1,
    classList: [{
        title: '商城头部',
        iconClass: 'icon-dianputoubu',
        type: 'header',
        undraggable: true, // 不可拖动
        onlyAdmin: true, // 平台端显示
        onlyApp: true, // 只在app显示
        componentContent: {
          logoType: 1,
          imageUrl: '',
          title: '',
          fontSizeNum: '',
          textFontW: 'normal',
          titColor: '#CD5353',
        },
      },
      {
        title: '轮播图',
        iconClass: 'icon-lunbo',
        type: 'banner',
        componentContent: {
          height: 500,
          bannerData: [{
            bannerUrl: '',
            linkObj: {
              selectValue: '',
              selectName: '',
              typeText: '',
              url: '',
            },
          }, ],
        },
      },
      {
        title: '标题文本',
        iconClass: 'icon-wenben',
        type: 'text',
        componentContent: {
          title: '标题', // 标题内容
          describe: '描述', // 描述内容
          textPos: 'left', // 文本对齐方向
          fontSizeNum: '16', // 文本字体大小
          describeSizeNum: '14', // 描述字体大小
          textFontW: 'normal', // 文本粗细
          describeFontW: 'normal', // 描述粗细
          titColor: '#333333', // 文本颜色
          describeColor: '#666666', // 描述颜色
          bgColor: '#FFFFFF', // 文本背景
          showLine: false, // 显示隐藏下划线
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样式
          link: '', // 查看更多链接
        },
      },
      {
        title: '公告',
        iconClass: 'icon-gonggao1',
        type: 'notice',
        onlyAdmin: true, // 平台端显示
        componentContent: {
          titColor: '#FFFFFF', // 文本颜色
          bgColor: '#333333', // 文本背景
        },
      },
      {
        title: '品牌列表',
        iconClass: 'icon-pinpailiebiao',
        type: 'brandList',
        componentContent: {
          title: '品牌列表',
          imgList: [{
              title: '标题一',
              imgData: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
            {
              title: '标题二',
              imgData: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
            {
              title: '标题三',
              imgData: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
            {
              title: '标题四',
              imgData: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
          ],
          textAlign: 'left',
          imgCurrent: null,
        },
      },
      {
        title: '图文',
        iconClass: 'icon-tuwen',
        type: 'imageText',
        componentContent: {
          imageUrl: '',
          linkObj: {
            selectValue: '',
            selectName: '',
            typeText: '',
            url: '',
          },
          positionValue: 'left',
          title: 'title',
          content: '',
        },
      },
      {
        title: '图文列表',
        iconClass: 'icon-tuwenliebiao',
        type: 'imageTextList',
        componentContent: {
          title: '标题',
          textAlign: 'left',
          imgTextData: [{
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              isShow: true,
              title: '图文标题',
              describe: '告别生活，畅享便携生活',
              imgData: '',
            },
            {
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              isShow: true,
              title: '图文标题',
              text: '告别生活，畅享便携生活',
              imgData: '',
            },
            {
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              isShow: true,
              title: '图文标题',
              describe: '告别生活，畅享便携生活',
              imgData: '',
            },
          ],
        },
      },
      {
        title: '图文导航',
        iconClass: 'icon-tuwendaohang',
        type: 'imageTextNav',
        componentContent: {
          imgTextData: [{
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              title: '标题',
              img: '',
            },
            {
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              title: '标题',
              img: '',
            },
            {
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
              title: '标题',
              img: '',
            },
          ],
        },
      },
      {
        title: '九宫格菜单',
        iconClass: 'icon-tuwendaohang', // 或其它icon
        type: 'gridMenu',
        componentContent: {
          gridMenuData: [{
              img: '',
              text: '餐饮美食',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '休闲玩乐',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '酒店民宿',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '运动健身',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '看病买药',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '按摩足疗',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '超市便利',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '宠物天地',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '亲子乐园',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            },
            {
              img: '',
              text: '更多优选',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: ''
              }
            }
          ]
        }
      },
      {
        title: '铺助分割',
        iconClass: 'icon-fuzhufenge',
        type: 'assistDiv',
        componentContent: {
          height: 20,
          bgColor: '#ffffff',
        },
      },
      {
        title: '自定义',
        iconClass: 'icon-mofang1',
        type: 'custom',
        componentContent: {
          layoutType: 'L1',
          density: '4',
          maxH: 0,
          imgClearance: 0,
          pageSpacing: 0,
          averageBoxData: [], // 记录格子的激活状态
          imgBoxActive: 0, // 记录框的位置
          elementNum: 1, // 生成格子数量
          imgData: [{
              src: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
            {
              src: '',
              linkObj: {
                selectValue: '',
                selectName: '',
                typeText: '',
                url: '',
              },
            },
          ],
        },
      },
      {
        title: '视频',
        iconClass: 'icon-shipin',
        type: 'videoBox',
        componentContent: {
          title: '标题',
          videoUrl: 'http://cereshop.oss-cn-shenzhen.aliyuncs.com/0000/2020/05/432bb17e-536c-4762-a699-b3f5a2642742.mp4',
          mainBody: '描述',
          coverImg: '',
        },
      },
      {
        title: '直播',
        iconClass: 'icon-zhibo',
        onlyAdmin: true, // 平台端显示
        onlyWeixin: true, // 只在小程序显示
        type: 'live',
        componentContent: {
          showMore: false,
        },
      },
      {
        title: '商家列表',
        iconClass: 'icon-toubu',
        type: 'merchantList',
        componentContent: {
          // 将 style 重命名为 uiStyle，避免被当成 :style 透传到容器上
          uiStyle: {
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
            type: 'api',
            api: '/api/merchant/list',
            method: 'GET',
            params: {
              page: 1,
              size: 10,
              sort: 'distance'
            }
          }
        }
      },

    ],

  },
  {
    title: '商品组件',
    type: 1,
    classList: [{
        title: '商品列表',
        iconClass: 'icon-shangpin',
        type: 'productList',
        componentContent: {
          title: '商品列表',
          productData: {
            sourceType: '1',
            categoryId: 0,
            categoryName: '',
            imgTextData: [],
            productIdList: [],
          },
          productRowNum: 1, // 展示行数
          productNum: 4, //  展示列数
          arrangeType: '多行多列', // 布局方式
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样式
          openBottomLoad: false, // 是否开启触底加载
          linkObj: {
            selectValue: '',
            selectName: '',
            typeText: '',
            url: '',
          }, // 查看更多链接
        },
      },
      {
        title: '类别列表',
        iconClass: 'icon-leibieliebiao',
        type: 'categoryList',
        componentContent: {
          title: '类别列表',
          categoryData: [{
              id: 1,
              selClassData: [],
              img: '',
            },
            {
              id: 2,
              selClassData: [],
              img: '',
            },
            {
              id: 3,
              selClassData: [],
              img: '',
            },
            {
              id: 4,
              selClassData: [],
              img: '',
            },
          ],
          textAlign: 'center',
        },
      },
    ],
  },
  {
    title: '店铺组件',
    type: 2,
    classList: [{
        title: '拼团专区',
        iconClass: 'icon-pintuan1',
        type: 'groupList',
        componentContent: {
          // title: '拼团专区',
          productData: {
            products: [],
          },
          productRowNum: 1, // 展示行数
          productNum: 4, //  展示列数
          arrangeType: '多行多列', // 布局方式
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样式
          shopGroupWorkId: '',
        },
      },
      {
        title: '秒杀专区',
        iconClass: 'icon-miaosha1',
        type: 'spikeList',
        componentContent: {
          // title: '秒杀专区',
          productData: {
            products: [],
          },
          shopSeckillId: '',
        },
      },
      {
        title: '限时折扣',
        iconClass: 'icon-zhekou1',
        type: 'discountList',
        componentContent: {
          // title: '限时折扣',
          productData: {},
          discountId: '',
          arrangeType: '多行多列', // 布局方式
          moreBg: '',
        },
      },
      {
        title: '定价捆绑',
        iconClass: 'icon-price',
        type: 'priceList',
        onlyMerchant: true, // 商家端显示
        componentContent: {
          // title: '定价捆绑',
          productData: {
            composeProducts: [],
          },
          productRowNum: 1, // 展示行数
          productNum: 4, //  展示列数
          arrangeType: '多行多列', // 布局方式
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样Z
          priceId: '',
        },
      },
      {
        title: '会员专区',
        iconClass: 'icon-huiyuan',
        type: 'vip',
        onlyAdmin: true, // 平台端显示
        componentContent: {
          // title: '会员专区',
          productData: {
            productIdList: [],
          },
          productRowNum: 1, // 展示行数
          productNum: 4, //  展示列数
          arrangeType: '多行多列', // 布局方式
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样式
        },
      },
      {
        title: '优惠券',
        iconClass: 'icon-youhuiquan',
        type: 'coupon',
        componentContent: {
          arrangeActiveIndex: 2,
          cardActiveIndex: 1,
          colorActiveIndex: 0,
          selectedCoupon: [],
        },
      },
      {
        title: '每日上新',
        iconClass: 'icon-new',
        type: 'newProduct',
        onlyApp: true, // 只在app显示
        componentContent: {
          productData: {
            sourceType: '1',
            imgTextData: [],
            productIdList: [],
          },
          showMore: false, // 显示隐藏更多
          styleValue: '1', // 查看更多样式
          linkObj: {
            selectValue: '',
            selectName: '',
            typeText: '',
            url: '',
          }, // 查看更多链接
        },
      },
      {
        title: '每日好店',
        iconClass: 'icon-toubu',
        type: 'shop',
        onlyApp: true, // 只在app显示
        componentContent: {
          imgTextData: [{
            linkObj: {
              selectValue: '',
              selectName: '',
              typeText: '',
              url: '',
            },
            img: '',
          }, ],
        },
      },
    ],
  },
]
export default panelList