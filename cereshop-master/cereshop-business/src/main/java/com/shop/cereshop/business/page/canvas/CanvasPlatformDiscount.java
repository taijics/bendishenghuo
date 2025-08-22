/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.page.canvas;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 画布平台端限时折扣数据
 */
@Data
@ApiModel(value = "CanvasPlatformDiscount", description = "画布平台端限时折扣数据")
public class CanvasPlatformDiscount implements Serializable {
    /**
     * 平台限时折扣活动id
     */
    @ApiModelProperty(value = "平台限时折扣活动id")
    private Long discountId;

    /**
     * 活动名称
     */
    @ApiModelProperty(value = "活动名称")
    private String discountName;

    /**
     * 备注
     */
    @ApiModelProperty(value = "备注")
    private String remark;

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
    private String startTime;

    /**
     * 活动结束时间
     */
    @ApiModelProperty(value = "活动结束时间")
    private String endTime;

    /**
     * 商品限购 1-不限购 2-限购
     */
    @ApiModelProperty(value = "商品限购 1-不限购 2-限购")
    private Integer ifLimit;

    /**
     * 限购几件/人
     */
    @ApiModelProperty(value = "限购几件/人")
    private Integer limitNumber;

    /**
     * 优惠券是否叠加 1-是 0-否
     */
    @ApiModelProperty(value = "优惠券是否叠加 1-是 0-否")
    private Integer ifAdd;

    /**
     * 活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
     */
    @ApiModelProperty(value = "活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束")
    private Integer state;

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
     * 折扣
     */
    @ApiModelProperty(value = "折扣")
    private BigDecimal discount;

    private static final long serialVersionUID = 1L;

}
