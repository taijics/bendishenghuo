// const DOMAIN_PREFIX = 'http://127.0.0.1:9007'
const DOMAIN_PREFIX = 'https://ceres.zkthink.com/api'

export const VUE_APP_STATIC_URL = "https://ceres.zkthink.com/" // 静态资源路径

// https://ceresdev.zkthink.com
// #ifndef H5
const WX_API_BASE = DOMAIN_PREFIX // app
// const WX_API_BASE = 'http://3j073r3905.qicp.vip:29544'
// #endif

// #ifdef H5
// const WX_API_BASE = '/api' // h5
const WX_API_BASE = DOMAIN_PREFIX // app
const TERMINAL = 2
// #endif

// #ifdef APP-PLUS || APP-NVUE
const TERMINAL = 3
// #endif

// #ifdef MP
const TERMINAL = 1
// #endif

const API = {
	terminal: TERMINAL, // 画布设备 1 小程序，2 H5，3 App 4 电脑
	SettledMerchantPrefix: DOMAIN_PREFIX + '/settled-merchant', //商家入驻链接
	// shareLink: DOMAIN_PREFIX + '/h5', // 分享地址
	shareLink: 'https://ceres.zkthink.com/h5', // 分享地址

	//登录注册
	GetCaptcha: WX_API_BASE + '/code/captcha', //获取图片验证码
	Verify: WX_API_BASE + '/app/getCode', //  获取短信验证码
	Login: WX_API_BASE + '/app/login', //  手机号验证码登录、注册
	WxLogin: WX_API_BASE + '/app/wxLogin', //  微信登录
	AlipayLogin: WX_API_BASE + '/app/alipayLogin', //  支付宝登录
	GetSessionKey: WX_API_BASE + '/app/getSessionKey', //  获取微信手机号绑定
	SetWxPhone: WX_API_BASE + '/app/setWxPhone', //  获取微信手机号绑定
	UpdateWxPhone: WX_API_BASE + '/app/updateWxPhone', //  获取微信手机号绑定
	UpdateAliPhone: WX_API_BASE + '/app/updateAliPhone', //	获取支付宝小程序手机号绑定
	WxAppLogin: WX_API_BASE + '/app/wxAppLogin', // APP微信登录
	delUser: WX_API_BASE + '/user/delUser/',//账户注销


	// 查询直播间列表
	LiveRoomes: WX_API_BASE + '/canvas/selectLiveList',
	SubScribeLive: WX_API_BASE + '/live/subscribeLive',
	// 小程序客服查询
	CustomerService: WX_API_BASE + '/kf/getAppletKf',
	
	// 逛一逛、分享圈子
	CircleCategory: WX_API_BASE + '/recommend/type/getAll',
	CirclePage: WX_API_BASE + '/recommend/trend/page',
	CircleInfo: WX_API_BASE + '/recommend/trend/get',
	CircleCommentAdd: WX_API_BASE + '/recommend/comment/add',
	CircleCommentDel: WX_API_BASE + '/recommend/comment/delete',
	CircleCommentPage: WX_API_BASE + '/recommend/comment/page',
	CircleLike: WX_API_BASE + '/recommend/likes/like', //点赞
	CollectShop: WX_API_BASE + '/collect/collect', //关注店铺
	CancelCollect: WX_API_BASE + '/collect//new-cancel', //关注店铺
	CircleNotice: WX_API_BASE + '/recommend/comment/get-unread-count', //圈子未读消息
	CircleMyNotice: WX_API_BASE + '/recommend/comment//my-message', //圈子我的消息
	ReplyStatus: WX_API_BASE + '/recommend/comment/status', // 回复帖子状态


	//分类
	FindCategoryListByDepth: WX_API_BASE + '/classify/getFirstClassify', //  查询N级类目和查询子级类目

	// 查询热搜词
	SelectHotSearch: WX_API_BASE + '/app/selectHotSearch' , //获取搜索栏的热门搜索


	//商品相关接口
	GetClaasifyProducts: WX_API_BASE + '/classify/getClaasifyProducts', //  商品分类到商品列表
	ShopSearch: WX_API_BASE + '/shop/getShops', //  店铺列表搜索
	SearchHistory: WX_API_BASE + '/app/getHistory', //  查询最近的N条历史记录
	GgetSearchProducts: WX_API_BASE + '/app/getSearchProducts', //  商品搜索查询
	DeleteSearch: WX_API_BASE + '/app/deleteSearch', //  删除搜索记录
	Getindexdata: WX_API_BASE + '/app/index', //  首页数据查询
	GetremenList: WX_API_BASE + '/product/getRandomSortProduct', //  获取热门推荐

	QueryProductDetail: WX_API_BASE + '/product/getById', //  查询商品详情
	QueryProductSku: WX_API_BASE + '/product/getProducts', //  查询商品sku详情
	getCouponProducts: WX_API_BASE + '/coupon/getCouponProducts', //  优惠券商品列表查询


	QueryMemberAddres: WX_API_BASE + '/receive/getAll', //  查询用户所有收货地址
	AddresAdd: WX_API_BASE + '/receive/save', //  保存收货地址
	AddresDelete: WX_API_BASE + '/receive/delete', //  删除收货地址
	AddresUpdate: WX_API_BASE + '/receive/update', //  更新收货地址
	receiveGetInfo: WX_API_BASE + '/receive/getById', //  修改收货地址查询

	// 评价
	Comment: WX_API_BASE + '/order/addComment', //  评价
	AdditionalComment: WX_API_BASE + '/order/addToComment', //  追评接口
	MyCommentList: WX_API_BASE + '/comment/getAll', //  查看我的评论列表
	LikeOrUnLikeComment: WX_API_BASE + '/comment/like', //  点赞或取消点赞某个评论


	//我的
	GetDistributor: WX_API_BASE + '/distributor/getDistributor', //  我的账户信息查询
	FindCouponList: WX_API_BASE + '/coupon/getCoupons', //  我的卡券列表查询
	MemberAccountWithdraw: WX_API_BASE + '/distributor/save', //  提现申请
	GetUser: WX_API_BASE + '/user/getUser', //  个人系信息查询
	UpdateUser: WX_API_BASE + '/user/update', //  个人系信息查询



	// 店铺服务
	GetStore: WX_API_BASE + '/shop/getShopProducts', //  根据id查询店铺
	GetStoreShopClassify: WX_API_BASE + '/shop/getShopClassify', //  查询店铺分类
	GetShopBanner: WX_API_BASE + '/shop/getShopBanner', //  查询店铺banner
	getShopIndex: WX_API_BASE + '/shop/getIndex', // 查询店铺首页
	AddBusinessBuyerUser: WX_API_BASE + '/shop/addBusinessBuyerUser', // 成为商家的客户
	getShopSeckillIndex: WX_API_BASE + '/seckill/getIndex', // 查询店铺秒杀
	// http://127.0.0.1:9007/seckill/getIndex?shopSeckillId=78&page=1&pageSize=10

	//用户银行卡相关接口
	QueryBankcardList: WX_API_BASE + '/bank/getAll', //  查询用户所有银行卡
	SaveBankcard: WX_API_BASE + '/bank/save', //  添加银行卡
	UpdateBankcard: WX_API_BASE + '/bank/update', //  修改银行卡
	DelMemberBankcard: WX_API_BASE + '/bank/delete', //  删除用户银行卡
	GetByIdBankcard: WX_API_BASE + '/bank/getById', //  根据银行卡ID查询信息

	//  订单相关接口
	FindOrderList: WX_API_BASE + '/order/getAll', //  查询订单列表
	Settlement: WX_API_BASE + '/order/getSettlement', //  结算查询
	PlaceOrder: WX_API_BASE + '/order/submit', //  提交订单
	GetOrderDetail: WX_API_BASE + '/order/getById', //  订单详情查询
	CancelOrder: WX_API_BASE + '/order/cancel', //  取消订单
	DelOrder: WX_API_BASE + '/order/delete', //  删除订单
	ShippingTrace: WX_API_BASE + '/order/getDilevery', //  物流信息查询
	payOrder: WX_API_BASE + '/order/pay', //  支付成功业务处理接口
	gotoPay: WX_API_BASE + '/order/gotoPay', //  小程序支付
	paySuccess: WX_API_BASE + '/order/paySuccess', //  小程序支付成功
	gotoAppPay: WX_API_BASE + '/order/gotoAppPay', //  APP立即支付
	gotoH5Pay: WX_API_BASE + '/order/gotoH5Pay', //  H5支付
	ConfirmReceive: WX_API_BASE + '/order/confirm', //  确认收货
	Orderrefund: WX_API_BASE + '/order/refund', //  申请退款
	ReasonEnums: WX_API_BASE + '/after/getReasonSelect', //  选择退款原因查询
	ApplyReturnMoney: WX_API_BASE + '/after/submit', //  申请售后
	GetHuabeiConfig: WX_API_BASE + '/order/getHuabeiConfig', //查询花呗手续费配置
	GetRefundMoney:WX_API_BASE + '/after/getReturnPrice',// 获取退款金额

	//购物车
	ShoppingaddCart: WX_API_BASE + '/cart/addCart', //  加入购物车
	ShoppingCart: WX_API_BASE + '/cart/getCart', //  购物车列表
	UpdateNumberCart: WX_API_BASE + '/cart/updateNumber', //  修改购物车商品数量
	DeleteCart: WX_API_BASE + '/cart/delete', //  删除购物车商品
	SelectedCart: WX_API_BASE + '/cart/selected', //  选中商品
	UpdateSkuCart: WX_API_BASE + '/cart/updateSku', //  购物车更换商品规格

	//优惠券
	getCoupons: WX_API_BASE + '/canvas/getCoupons', // 优惠券查询
	ReceiveCoupon: WX_API_BASE + '/coupon/takeCoupon', //  领取优惠券
	buildParam4Plug: WX_API_BASE + '/coupon/buildParam4Plug', //  领取优惠券
	getCouponsByActivityId:WX_API_BASE + '/coupon/getChannelActivityCoupon', //  根据渠道活动ID获取优惠券


	//分销中心
	FindSaleStoreList: WX_API_BASE + '/distributor/getDistributorAll', //  分销中心列表查询
	QuerySalesMainInfo: WX_API_BASE + '/distributor/getShopDistributor', //  店铺分销数据查询
	FindSalesOrderPage: WX_API_BASE + '/distributor/getReward', //  累计奖励查询
	GetNotReward: WX_API_BASE + '/distributor/getNotReward', //  累计未结算奖励查询
	FindSalesCustomerList: WX_API_BASE + '/distributor/getBuyers', //  累计客户查询
	FindSubordinateSalesList: WX_API_BASE + '/distributor/getDistributors', //  累计分销员查询
	FindSalesPromConfig: WX_API_BASE + '/distributor/getShopExtension', //  店铺推广数据查询
	StoreProductList: WX_API_BASE + '/distributor/getExtensionProduct', //  推广商品查询
	FindMySalesPage: WX_API_BASE + '/distributor/getDistributorOrder', //  分销订单查询
	HasApply: WX_API_BASE + '/distributor/check', //  验证当前客户是否为分销员
	BindSalesCustomer: WX_API_BASE + '/distributor/bind', //  绑定关系
	getSharePic: WX_API_BASE + '/product/getSharePic', //  分享
	getShareProductParam: WX_API_BASE + '/product/getShareProductParam', //  查询分享所需的参数
	shopGetSharePic: WX_API_BASE + '/shop/getSharePic', //  推广店铺

	//售后
	FindReturnList: WX_API_BASE + '/after/getAll', //  售后列表查询
	CancelRefund: WX_API_BASE + '/after/returnRefund', //  撤销退款
	ReturnDetail: WX_API_BASE + '/after/getById', //  售后详情查询
	CancelReturnGoods: WX_API_BASE + '/after/returnGoods', //  撤销退货
	ShippingCompany: WX_API_BASE + '/order/getExpressSelect', //  选择快递公司查询
	SendReturnGoods: WX_API_BASE + '/order/returnExpress', //  填写退货物流单
	deleteAfter: WX_API_BASE + '/after/deleteAfter', //  删除售后记录

	//申请分销员
	Apply: WX_API_BASE + '/distributor/addDistributor', //  申请分销员

	// 画布模块
	getProducts: WX_API_BASE + '/canvas/getProducts', // 选择商品查询
	getProductsV2: WX_API_BASE + '/canvas/getProducts', // 选择商品查询


	//服务协议
	Query: WX_API_BASE + '/dict/getByName', // 查询分类层级

	DeleteAllSearch: WX_API_BASE + '/product/deleteAllSearch', // 清空历史搜索记录

	//消息
	getMessage: WX_API_BASE + '/notice/getAll', //消息列表查询
	getMessageDetails: WX_API_BASE + '/notice/getById', //消息详情
	readNotice: WX_API_BASE + '/notice/readNotice', // 消息已读
	getNotice: WX_API_BASE + '/notice/getGongGaoAll', //公告
	delMessage: WX_API_BASE + '/notice/removeById', //删除消息
	allMessage: WX_API_BASE + '/notice/readAll', //全部已读

	//我的收藏
	getProductCollect: WX_API_BASE + '/collect/getAllProduct', //收藏商品查询
	getStoreCollect: WX_API_BASE + '/collect/getAllShop', //收藏店铺查询
	cancelCollect: WX_API_BASE + '/collect/cancel', //取消收藏
	collect: WX_API_BASE + '/collect/collect', //收藏商品、店铺
	deleteCollect: WX_API_BASE + '/collect/delete', //批量删除收藏商品、店铺

	//秒杀专区
	addAnswer: WX_API_BASE + '/seckill/addAnswer', //回答
	addProblem: WX_API_BASE + '/seckill/addProblem', //提问
	getSeckillList: WX_API_BASE + '/seckill/getIndex', //秒杀专区首页数据查询
	getProblems: WX_API_BASE + '/seckill/getProblems', //商品问答数据查询
	getProblemDetail: WX_API_BASE + '/seckill/getProblemDetail', //问答详情查询
	getQueryPlatformSeckillList: WX_API_BASE + '/platform-seckill/queryPlatformSeckillList', //平台秒杀列表
	getPlatformSeckills: WX_API_BASE + '/canvas/getPlatformSeckills', //根据seckillId查询对应的秒杀商品列表

	//拼团专区
	getGroupSettlement: WX_API_BASE + '/work/getSettlement', //拼团单结算查询
	getGroupBuyList: WX_API_BASE + '/work/getIndex', //拼团专区首页数据查询
	getInviteSpell: WX_API_BASE + '/work/getInvite', //邀请好友拼单查询

	//限时折扣
	getDiscountList: WX_API_BASE + '/discount/getIndex', //专区首页数据查询

	//浏览足迹
	getFootprintList: WX_API_BASE + '/footprint/getAll', //我的足迹查询
	deleteFootprint: WX_API_BASE + '/footprint/delete', //删除足迹

	//我的问答
	getProblemList: WX_API_BASE + '/seckill/getProblem', //我的提问
	getAnswerList: WX_API_BASE + '/seckill/getAnswer', //我的回答
	deleteProblem: WX_API_BASE + '/seckill/deleteProblem', //批量删除提问
	deleteAnswer: WX_API_BASE + '/seckill/deleteAnswer', //批量删除回答

	//分享
	getShare: WX_API_BASE + '/work/getShare', //获取二维码和小程序码
	platform: WX_API_BASE + '/after/platform', // 申请平台介入
	UploadUrl: WX_API_BASE + '/file/upload', // 申请平台介入

	// 会员信息
	// getMemberShipList:    		     WX_API_BASE + '/member/getMemberShipList', //会员权益查询

	// 会员专区
	getMemberProducts: WX_API_BASE + '/canvas/getMemberProducts', //查询会员商品数据
	memberList: WX_API_BASE + '/member/getAllMemberLevelInfo', //查询会员所有等级

	// 会员中心
	getMemberShipList: WX_API_BASE + '/member/getMemberShipList', //会员权益查询
	selectSigninHistory: WX_API_BASE + '/member/selectSigninHistory', // 查询签到明细
	selectSigninRecordList: WX_API_BASE + '/member/selectSigninRecordList', // 查询签到列表
	signIn: WX_API_BASE + '/member/signIn', // 签到
	welfareProductList: WX_API_BASE + '/member/welfareProductList', // 会员专区
	getMemberByMemberLevel: WX_API_BASE + '/member/getMemberByMemberLevelId', // 会员图标
	// 组合套餐
	selectCompose: WX_API_BASE + '/product/selectCompose', // 查询组合套餐

	// 平台折扣
	queryPlatformDiscount: WX_API_BASE + '/platform-discount/queryPlatformDiscount',
	queryPlatformDiscountProductList: WX_API_BASE + '/platform-discount/queryPlatformDiscountProductList',
	// 平台秒杀
	queryProductListBySession: WX_API_BASE + '/platform-seckill/queryProductListBySession', // 根据场次时间查询商品列表
	querySession: WX_API_BASE + '/platform-seckill/querySession', // 平台秒杀查询今日场次
	// 定价捆绑
	selectByPriceId: WX_API_BASE + '/price/selectByPriceId', // 定价捆绑规则查询
	selectProductListByPriceId: WX_API_BASE + '/product/selectProductListByPriceId', // 捆绑商品查询
	// queryProductListBySession:				 WX_API_BASE + '/platform-seckill/queryProductListBySession' // 根据场次时间查询商品列表 /order/getOrderPolite
	// 支付有礼
	getOrderPolite: WX_API_BASE + '/order/getOrderPolite', // 支付有礼
	// 积分签到
	creditSignIn: WX_API_BASE + '/credit/signIn', // 积分签到
	exchangeCoupon: WX_API_BASE + '/credit/exchangeCoupon', // 积分兑换优惠券
	selectByMonth: WX_API_BASE + '/credit/selectByMonth', // 根据月份查询签到记录
	selectCreditCouponList: WX_API_BASE + '/credit/selectCreditCouponList', // 查询可以积分兑换的优惠券
	selectCreditRecord: WX_API_BASE + '/credit/selectCreditRecord', // 查询积分记录

	// 首页广告
	GetAd: WX_API_BASE + '/advert/selectByCondition', //  获取首页广告
	adClose: WX_API_BASE + '/advert/closeAdvert', //  关闭首页广告
	takeBatchCoupon: WX_API_BASE + '/coupon/takeBatchCoupon', //  批量领取优惠券
	takeChannelActivityCoupon: WX_API_BASE + '/coupon/takeChannelActivityCoupon', //  一键领取渠道优惠券

	// 渠道优惠券
	getChannelCoupon: WX_API_BASE + '/coupon/getChannelCouponDetail', // 获取渠道优惠券
	getChannelProduct: WX_API_BASE + '/credit/signIn', // 获取渠道优惠券推荐产品
	getRandomProduct: WX_API_BASE + '/product/getRandomSortProduct', // 查询随机排序的商品


	// 埋点
	doPointer:WX_API_BASE+'/user/trackReport'
}

export default API
