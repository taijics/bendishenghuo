/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.constant;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
@Getter
public enum IntegerEnum {

    YES("是",1),
    NO("否",0),
    SCENE_TIME_MONTH("营销时间类型-每月",1),
    SCENE_TIME_WEEK("营销时间类型-每周",2),
    SCENE_TIME_DAY("营销时间类型-每日",3),
    COMPOSE_TYPE_DIRECT("组合捆绑类型-直接定价",1),
    SCENE_TIME_FIXED("组合捆绑类型-固定减价",2),
    SCENE_TIME_DISCOUNT("组合捆绑类型-折扣",3),
    SCENE_TIME_BIRTHDAY("营销时间类型-生日当天",4),
    SCENE_TIME_BIRTHDAY_WEEK("营销时间类型-生日当周",5),
    SCENE_TIME_BIRTHDAY_MONTH("营销时间类型-生日当月",6),
    SCEME_RULE_ALL("场景营销规则-所有等级会员，同一规则",1),
    SCEME_RULE_APPOINT("场景营销规则-不同等级会员,不同规则",2),
    SCEME_STATE_NOT("场景营销状态-未开始",0),
    SCEME_STATE_START("场景营销状态-进行中",1),
    SCEME_STATE_STOP("场景营销状态-已停止",2),
    SHOP_COMPOSE_STATE_NOT("捆绑销售状态-未开始",0),
    SHOP_COMPOSE_STATE_START("捆绑销售状态-进行中",1),
    SHOP_COMPOSE_STATE_END("捆绑销售状态-已结束",2),
    SHOP_COMPOSE_STATE_STOP("捆绑销售状态-已停止",3),
    SCENE_TYPE_FESTIVAL("场景营销类型-节日营销",1),
    SCENE_TYPE_MEMBER("场景营销类型-会员日营销",2),
    SCENE_TYPE_BIRTHDAY("场景营销类型-生日营销",3),
    POLITE_BUYER_MONEY("支付有礼活消费方式-购买一定金额商品",1),
    POLITE_BUYER_NUMBER("支付有礼活消费方式-购买一定数量商品",2),
    ACTIVITY_COUPON("报名活动类型-平台优惠券",1),
    ACTIVITY_SECKILL("报名活动类型-平台秒杀",2),
    ACTIVITY_DISCOUNT("报名活动类型-平台限时折扣",3),
    PRODUCT_EXAMINE_YES("商品状态-已上架",1),
    PRODUCT_EXAMINE_STAY("商品状态-审核中",2),
    PRODUCT_EXAMINE_NO("商品状态-驳回",3),
    PRODUCT_SHELVSTATE_FORCED("商品状态-已下架",0),
    REQUEST_TYPE_ADMIN("请求类型-平台端",1),
    REQUEST_TYPE_BUSINESS("请求类型-商家端",2),
    REQUEST_TYPE_APP("请求类型-C端",3),
    ENABLE_STOP("活动预热-关闭",1),
    ENABLE_START("活动预热-开启",2),
    REGIST("类型-注册",1),
    LOGIN("类型-登录",2),
    MEMBER_PRODUCT_MODE_DISCOUNT("商品会员价优惠方式-折扣",1),
    MEMBER_PRODUCT_MODE_PRICE("商品会员价优惠方式-指定价格",2),
    BUYER_COLLECT_PRODUCT("收藏类型-商品",1),
    BUYER_COLLECT_SHOPID("收藏类型-店铺",2),
    SKU_STYLE_ONE("规格样式-单款式",0),
    SKU_STYLE_MORE("规格样式-多款式",1),
    HANDLE_HAVE("店铺认证状态-已处理",1),
    NOT_CERTIFIED("店铺认证状态-未认证",1),
    UNDER_REVIEW("店铺认证状态-审核中",2),
    APPROVED("店铺认证状态-审核通过",3),
    AUDIT_FAILURE("店铺认证状态-审核失败",4),
    SIGN_SUCCESS("店铺认证状态-签约成功",5),
    UNTREATED("入驻状态-未处理",0),
    ADOPT("入驻状态-通过",1),
    REFUSE("入驻状态-拒绝",2),
    CANVAS_ACTIVITY_GROUP_WORK("画布活动类型条件-拼团",1),
    CANVAS_ACTIVITY_SECKILL("画布活动类型条件-秒杀",2),
    CANVAS_ACTIVITY_DISCOUNT("画布活动类型条件-限时折扣",3),
    PERSONAL("主体类型-个人",1),
    INDIVIDUAL("主体类型-个体工商户",2),
    ENTERPRICE("主体类型-企业",3),
    ORGANIZATION("主体类型-其他组织",4),
    AFTER_STAY("售后状态-审核中",1),
    AFTER_REFUND_STAY("售后状态-退款中",2),
    AFTER_RETURN_STAY("售后状态-退货中",3),
    AFTER_REFUND_SUCCESS("售后状态-退款成功",4),
    AFTER_REFUND_ERRPR("售后状态-退款失败",5),
    AFTER_STAY_NO("售后状态-审核不通过",6),
    AFTER_PLATFORM_STAY("售后状态-评审中",7),
    AFTER_RETURN_SUCCESS_NOT_REFUND("售后状态-退货完成，拒绝退款",8),
    AFTER_CANCEL("售后状态-已关闭",9),
    AFTER_STAY_YES("售后状态-审核通过",10),
    AFTER_REFUND("售后类型-仅退款",1),
    AFTER_REFUND_DILEVERY("售后类型-退货退款",2),
    ORDER_STAY_PAY("订单状态-待付款",1),
    ORDER_STAY_DILEVERY("订单状态-待发货",2),
    ORDER_HAVE_DILEVERY("订单状态-待收货",3),
    ORDER_FINISH("订单状态-已完成",4),
    ORDER_STOP("订单状态-已取消",5),
    ORDER_STAY_COLLAGE("订单状态-待成团",6),
    ORDER_PAY_SUCCESS("订单支付状态-已支付",1),
    ORDER_PAY_STAY("订单支付状态-待支付",0),
    ORDER_PAY_WX("订单支付方式-微信",1),
    ORDER_PAY_ALI("订单支付方式-支付宝",2),
    ORDER_PAY_HUABEI("订单支付方式-花呗分期",3),
    ORDER_SUB_PAYMENT_MODE_XCX("微信具体支付方式-小程序",1),
    ORDER_SUB_PAYMENT_MODE_APP("微信具体支付方式-APP支付",2),
    ORDER_SUB_PAYMENT_MODE_H5("微信具体支付方式-H5支付",3),
    DISTRIBUTOR_STAY("分销员审核状态-待处理",0),
    DISTRIBUTOR_SUCCESS("分销员审核状态-审核通过",1),
    DISTRIBUTOR_ERROR("分销员审核状态-审核不通过",2),
    DIRECT_DISTRIBUTION_MONEY("分销员等级升级规则-累计直接分销金额",1),
    INVITE_SUBORDINATES("分销员等级升级规则-邀请下级满",2),
    FULL_CUSTOMERS("分销员等级升级规则-客户满",3),
    TOOL_NOT_START("营销工具状态-未开始",0),
    TOOL_HAND("营销工具状态-进行中",1),
    TOOL_END("营销工具状态-已结束",2),
    DAY_CONDITION("日汇总条件",1),
    MONTH_CONDITION("月汇总条件",2),
    WITHDRAWAL_STAY("提现申请状态-待处理",0),
    WITHDRAWAL_ALREADY("提现申请状态-已处理",1),
    WITHDRAWAL_SUCCESS("用户提现处理状态-同意",1),
    WITHDRAWAL_ERROR("用户提现处理状态-拒绝",2),
    BOND_NOT_PAY("保证金状态-未支付",0),
    BOND_PAY("保证金状态-冻结中",1),
    BOND_REFUND("保证金状态-已退回",2),
    BOND_PAY_WEIXIN("保证金支付方式-微信",1),
    BOND_PAY_ALIPAY("保证金支付方式-支付宝",2),
    SIGN_ACTIVITY_STAY("报名审核状态-待审核",0),
    SIGN_ACTIVITY_SUCCESS("报名审核状态-报名成功",1),
    SIGN_ACTIVITY_ERROR("报名审核状态-报名失败",2),
    SIGN_ACTIVITY_ING("报名审核状态-报名进心中",3),
    SHOP_CHECK_SUCCESS("入驻处理状态-同意",1),
    SHOP_CHECK_ERROR("入驻处理状态-拒绝",0),
    POLITE_NOT_START("平台支付有礼活动状态-未开始",0),
    POLITE_ON("平台支付有礼活动状态-进行中",1),
    POLITE_END("平台支付有礼活动状态-已结束",2),
    ACTIVITY_NOT_START("营销活动状态-报名未开始",0),
    ACTIVITY_SIGN_ON("营销活动状态-报名进行中",1),
    ACTIVITY_STAY_START("营销活动状态-活动待开始",2),
    ACTIVITY_START("营销活动状态-活动进行中",3),
    ACTIVITY_END("营销活动状态-活动已结束",4),
    SIGN_STAY("商家活动操作-立即报名（高亮）",1),
    SIGN_STAY_NOT("商家活动操作-立即报名（置灰）",2),
    SIGN_ALREADY("商家活动操作-报名详情",3),
    SIGN_AGAIN("商家活动操作-重新报名",4),
    SIGN_CONTINUE("商家活动操作-继续报名",5),
    AFTER_ADMIN_SUCCESS("平台介入售后状态-同意",1),
    AFTER_ADMIN_ERROR("平台介入售后状态-拒绝",2),
    EXPRESS_100("物流查询策略-快递100",1),
    EXPRESS_NIAO("物流查询策略-快递鸟",2),
    MESSAGE_SUCCESS("短信发送状态-成功",1),
    MESSAGE_ERROR("短信发送状态-失败",2),
    DIRECT_TYPE("佣金类型-直接",1),
    IN_DIRECT_TYPE("佣金类型-间接",2),
    RELATIONSHIP_FROZEN("对账单-冻结",1),
    RELATIONSHIP_SOLVE_FROZEN("对账单-解冻",2),
    RELATIONSHIP_INCOME("对账单-收入(付款)",1),
    RELATIONSHIP_ONCOME("对账单-支出(退款)",2),
    BUYER_WITHDRAWAL_STAY("客户提现申请状态-审核中",0),
    BUYER_WITHDRAWAL_SUCCESS("客户提现申请状态-通过",1),
    BUYER_WITHDRAWAL_ERROR("客户提现申请状态-拒绝",2),
    SENSITIVE_STOP("敏感词发布状态-禁止发布",1),
    SENSITIVE_APPROVE("敏感词发布状态-需审核",2),
    CONDITION_TODAY("日期条件-今日",1),
    CONDITION_YESTERDAY("日期条件-昨日",2),
    CONDITION_WEEK("日期条件-近7天",3),
    CONDITION_THIRD("日期条件-近30天",4),
    CLASSIFY_LEVEL_ONE("分类级别-一级",1),
    CLASSIFY_LEVEL_TWO("分类级别-二级",2),
    CLASSIFY_LEVEL_THREE("分类级别-三级",3),
    SOURCE_TYPE_IMAGE("素材类型-图片",1),
    SOURCE_TYPE_VIDEO("素材类型-视频",2),
    COUPON_HAVE("优惠券状态-已领取",0),
    COUPON_USE("优惠券状态-已使用",1),
    COUPON_OVERDUE("优惠券状态-已过期",2),
    COUPON_NOT_HAVE("优惠券状态-未领取",3),
    COUPON_RECEIVE_TYPE_INFINITE("优惠券限制状态-无限制领取",1),
    COUPON_RECEIVE_TYPE_LIMITED("优惠券限制状态-有限领取",2),
    SOURCE_IMAGE("素材类型-图片",1),
    SOURCE_REDIO("素材类型-视频",2),
    CAN_GRAB_USER("抢客条件-随时可抢",1),
    NOT_GRAB_USER("抢客条件-不允许抢客",2),
    DAY_GRAB_USER("抢客条件-保护期内允许抢客",3),
    APPLY_TYPE_ALL("优惠券-适用商品-全部",1),
    APPLY_TYPE_YES("优惠券-适用商品-指定可用",2),
    APPLY_TYPE_NO("优惠券-适用商品-指定不可用",3),
    TIME_TYPE_FIXED("优惠券-用券时间-固定时间",1),
    COUPON_TYPE_REDUTION("优惠券类型-满减",1),
    COUPON_TYPE_DISCOUNT("优惠券类型-折扣",2),
    TIME_TYPE_CHANGE("优惠券-用券时间-领券当日起几天有效",2),
    COUPON_STATE_READY("运营工具-状态-未开始",0),
    COUPON_STATE_START("运营工具-状态-进行中",1),
    COUPON_STATE_END("运营工具-状态-已结束",2),
    COUPON_STATE_PRE_HOT("运营工具-状态-预热",-1),
    GROUP_CONDITION_STOCK("商品分组-智能添加-库存条件",1),
    GROUP_CONDITION_PRICE("商品分组-智能添加-价格条件",2),
    GROUP_CONDITION_WEIGHT("商品分组-智能添加-重量条件",3),
    GROUP_CONDITION_SALES("商品分组-智能添加-销量条件",4),
    GROUP_CONDITION_GREATER("商品分组-运算符-大于",1),
    GROUP_CONDITION_EQUAL("商品分组-运算符-等于",2),
    GROUP_CONDITION_LESS("商品分组-运算符-小于",3),
    GROUP_CONDITION_ALL("商品分组-筛选条件-全部满足",1),
    GROUP_CONDITION_ONE("商品分组-筛选条件-任意满足",2),
    OPERATE_PLAN_MODE_AUTOMATIC("运营计划方式-自动长期计划",1),
    OPERATE_PLAN_MODE_MANUAL("运营计划方式-手动定时计划",2),
    NOTICE_TYPE_SYSTEM("消息类型-系统消息",1),
    NOTICE_TYPE_NOTICE("消息类型-公告",2),
    NOTICE_TYPE_STATION_MESSAGE("消息类型-站内信",3),
    NOTICE_JUMP_ORDER("消息跳转类型-订单",2),
    NOTICE_JUMP_PRODUCT("消息跳转类型-商品",1),
    PRODUCT_IF_LIMIT_NO("商品是否限购-不限购",1),
    PRODUCT_IF_LIMIT_YES("商品是否限购-限购",2),
    GROUP_WORK_LAUNCH("拼团活动-发起拼团",1),
    GROUP_WORK_JOIN("拼团活动-参与拼团",2),
    SECKILL_SUBMIT("秒杀活动-下单",3),
    DISCOUNT_SUBMIT("限时折扣活动-下单",4),
    COLLAGE_STATE_STAY("拼单状态-待成团",0),
    COLLAGE_STATE_SUCCESS("拼单状态-拼团成功",1),
    COLLAGE_STATE_ERROR("拼单状态-拼团失败",2),
    NORMAL_PRODUCT("商品详情所属-正常商品",0),
    GROUP_PRODUCT("商品详情所属-拼团活动商品",1),
    SECKILL_PRODUCT("商品详情所属-秒杀活动商品",2),
    DISCOUNT_PRODUCT("商品详情所属-限时折扣活动商品",3),
    PLATFORM_AFTER_STAY("平台售后处理状态-未处理",0),
    PLATFORM_AFTER_SUCCESS("平台售后处理状态-同意",1),
    PLATFORM_AFTER_ERROR("平台售后处理状态-拒绝",2),
    ACTIVITY_TYPE_NORMAL("普通商品",0),
    ACTIVITY_TYPE_SHOP_GROUP("拼团",1),
    ACTIVITY_TYPE_SHOP_SECKILL("秒杀",2),
    ACTIVITY_TYPE_SHOP_DISCOUNT("限时折扣",3),
    ACTIVITY_TYPE_PLATFORM_SECKILL("平台秒杀",4),
    ACTIVITY_TYPE_PLATFORM_DISCOUNT("平台限时折扣",5),
    ACTIVITY_TYPE_PRICE("定价捆绑",6),
    ACTIVITY_TYPE_COMPOSE("组合捆绑",7),
    ACTIVITY_TYPE_SCENE("场景营销",8),
    ACTIVITY_TYPE_MEMBER("会员活动",9),
    POLITE_TYPE_GROWTH("成长值",1),
    POLITE_TYPE_REDUCTION("满减券",2),
    POLITE_TYPE_DISCOUNT("折扣券",3),
    POLITE_TYPE_CREDIT("积分",4),
    COUPON_SOURCE_TAKE("正常领取",1),
    COUPON_SOURCE_MARKET_SEND("场景营销发放",2),
    COUPON_SOURCE_CREDIT_EXCHANGE("积分兑换",3),
    COUPON_SOURCE_POLITE("支付有礼",4),
    COUPON_SOURCE_CHANNEL_ACTIVITY("渠道券活动",5),
    COMMON_WAIT_AUDIT("待审核",0),
    COMMON_AUDIT_SUCCESS("审核通过",1),
    COMMON_AUDIT_FAIL("审核失败",2),
    LIVE_PRODUCT_PRICE_TYPE_FIXED("一口价",1),
    LIVE_PRODUCT_PRICE_TYPE_RANGE("价格区间",2),
    LIVE_PRODUCT_PRICE_TYPE_DISCOUNT("折扣价",3),
    RISK_BLACK_TYPE_IP("ip",1),
    RISK_BLACK_TYPE_USER("用户",2),
    RISK_RULE_TYPE_ANY("满足任意一项",1),
    RISK_RULE_TYPE_ALL("满足所有",2),
    JUMP_TYPE_PRODUCT("商品",1),
    JUMP_TYPE_CATEGORY("分类",2),
    JUMP_TYPE_COUPON("优惠券",3),
    JUMP_TYPE_APPLET("小程序",4),
    JUMP_TYPE_ARTICLE("公众号文章",5),
    TERMINAL_0("未知",0),
    TERMINAL_1("APP",1),
    TERMINAL_2("微信小程序",2),
    TERMINAL_3("H5",3),
    TERMINAL_4("支付宝小程序",4),
    TERMINAL_5("PC",5),
    TERMINAL_6("商家端后台",6);



    String name;
    Integer code;

    private static Map<String, IntegerEnum> valueMap = new HashMap<>();

    public static Map<Integer, IntegerEnum> terminalMap = new HashMap<>();

    private static List<IntegerEnum> terminalEnumList = Arrays.asList(TERMINAL_0, TERMINAL_1, TERMINAL_2,
            TERMINAL_3, TERMINAL_4, TERMINAL_5, TERMINAL_6);

    static {
        for(IntegerEnum enumItem : IntegerEnum.values()) {
            valueMap.put(enumItem.name, enumItem);
        }
        for (IntegerEnum enumItem:terminalEnumList) {
            terminalMap.put(enumItem.getCode(), enumItem);
        }
    }

    IntegerEnum(String name,Integer code) {
        this.code = code;
        this.name=name;
    }

    public static Integer getByName(String name) {
        IntegerEnum result = valueMap.get(name);
        if(result == null) {
            throw new IllegalArgumentException("No element matches " + name);
        }
        return result.code;
    }

    /* 只有运单的售后状态为以下情况时，才允许自动确认收货 */
    public static final List<Integer> CONFIRM_DELIVERY_AFTER_STATE_LIST = Arrays.asList(
            IntegerEnum.AFTER_STAY_NO.getCode(),
            IntegerEnum.AFTER_CANCEL.getCode());

    public static final List<IntegerEnum> ACTIVITY_LIST = Arrays.asList(
            IntegerEnum.ACTIVITY_TYPE_NORMAL,
            IntegerEnum.ACTIVITY_TYPE_SHOP_GROUP,
            IntegerEnum.ACTIVITY_TYPE_SHOP_SECKILL,
            IntegerEnum.ACTIVITY_TYPE_SHOP_DISCOUNT,
            IntegerEnum.ACTIVITY_TYPE_PLATFORM_SECKILL,
            IntegerEnum.ACTIVITY_TYPE_PLATFORM_DISCOUNT,
            IntegerEnum.ACTIVITY_TYPE_PRICE,
            IntegerEnum.ACTIVITY_TYPE_COMPOSE,
            IntegerEnum.ACTIVITY_TYPE_SCENE,
            IntegerEnum.ACTIVITY_TYPE_MEMBER);

    public static String getActivityName(Integer activityType) {
        for (IntegerEnum enumItem:ACTIVITY_LIST) {
            if (enumItem.getCode().equals(activityType)) {
                return enumItem.getName();
            }
        }
        return null;
    }
}
