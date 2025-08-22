/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.activity;

import com.shop.cereshop.commons.domain.activity.CerePlatformActivityDetail;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

/**
 * 营销活动接收参数实体类
 */
@Data
@ApiModel(value = "CerePlatformActivityParam", description = "修改营销活动接收参数实体类")
public class ActivityUpdateParam {

    /**
     * 活动id
     */
    @ApiModelProperty(value = "活动id")
    private Long activityId;

    /**
     * 活动名称
     */
    @ApiModelProperty(value = "活动名称")
    private String activityName;

    /**
     * 活动介绍
     */
    @ApiModelProperty(value = "活动介绍")
    private String activityIntroduce;

    /**
     * 报名开始时间
     */
    @ApiModelProperty(value = "报名开始时间")
    private String signStartTime;

    /**
     * 报名结束时间
     */
    @ApiModelProperty(value = "报名结束时间")
    private String signEndTime;

    /**
     * 活动开始时间
     */
    @ApiModelProperty(value = "活动开始时间")
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    @ApiModelProperty(value = "活动结束时间")
    private String activityEndTime;

    /**
     * 是否需要保证金  1-是 0-否
     */
    @ApiModelProperty(value = "是否需要保证金  1-是 0-否")
    private Integer ifBond;

    /**
     * 保证金金额
     */
    @ApiModelProperty(value = "保证金金额")
    private BigDecimal bondMoney;

    /**
     * 使用门槛满多少元，无门槛为0
     */
    @ApiModelProperty(value = "使用门槛满多少元，无门槛为0")
    @NotNull(message = "使用门槛不能为空")
    private BigDecimal threshold;

    /**
     * 优惠方式 1-满减 2-折扣
     */
    @ApiModelProperty(value = "优惠方式 1-满减 2-折扣")
    private Integer discountMode;

    /**
     * 优惠内容减多少元/打多少折
     */
    @ApiModelProperty(value = "优惠内容减多少元/打多少折")
    @NotNull(message = "优惠内容不能为空")
    private BigDecimal couponContent;

    /**
     * 发放数量
     */
    @ApiModelProperty(value = "发放数量")
    @NotNull(message = "发放数量不能为空")
    private Integer number;

    /**
     * 每人限领次数  1-无限次 2-限制几次
     */
    @ApiModelProperty(value = "每人限领次数  1-无限次 2-限制几次")
    @NotNull(message = "每人限领次数不能为空")
    private Integer receiveType;

    /**
     * 限制次数
     */
    @ApiModelProperty(value = "限制次数")
    private Integer frequency;

    /**
     * 图片地址
     */
    @ApiModelProperty(value = "图片地址")
    private String image;

    /**
     * 是否支持积分兑换
     */
    @ApiModelProperty(value = "是否支持积分兑换")
    private Integer ifCredit;

    /**
     * 兑换所需积分
     */
    @ApiModelProperty(value = "兑换所需积分")
    private Integer credit;

    @ApiModelProperty(value = "使用范围 1-全部 2-选择类别")
    private Integer applyType;

    @ApiModelProperty(value = "使用类别范围")
    private Long applyCategory;

    @ApiModelProperty(value = "是否同步卡券")
    private Integer syncCard;

    @ApiModelProperty(value = "卡券标题")
    private String cardTitle;

    @ApiModelProperty(value = "券主题色")
    private String cardColor;

    @ApiModelProperty(value = "使用须知")
    private String cardNotice;

    /**
     * 优惠方案明细数据
     */
    @ApiModelProperty(value = "优惠方案明细数据")
    private List<CerePlatformActivityDetail> promotionDetail;
}
