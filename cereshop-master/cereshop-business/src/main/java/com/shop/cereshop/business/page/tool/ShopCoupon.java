/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.page.tool;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 满减券/折扣券列表
 */
@Data
@ApiModel(value = "ShopCoupon", description = "满减/折扣券列表返回数据")
public class ShopCoupon implements Serializable {
    /**
     * 店铺优惠券id
     */
    @ApiModelProperty(value = "店铺优惠券id")
    private Long shopCouponId;

    /**
     * 优惠券名称
     */
    @ApiModelProperty(value = "优惠券名称")
    private String couponName;

    /**
     * 优惠券类型 1-满减券 2-折扣券
     */
    @ApiModelProperty(value = "优惠券类型 1-满减券 2-折扣券")
    private Integer couponType;

    /**
     * 优惠券状态  0-未开始 1-进行中 2-已结束
     */
    @ApiModelProperty(value = "优惠券状态  0-未开始 1-进行中 2-已结束")
    private Integer state;

    /**
     * 优惠内容
     */
    @ApiModelProperty(value = "优惠内容")
    private String content;

    /**
     * 使用门槛满多少元，无门槛为0
     */
    @ApiModelProperty(value = "使用门槛满多少元，无门槛为0")
    private BigDecimal threshold;

    /**
     * 优惠内容减多少元
     */
    @ApiModelProperty(value = "优惠内容减多少元")
    private BigDecimal couponContent;

    @ApiModelProperty(value = "用券时间 1-固定时间 2-领券开始几天内")
    private Integer timeType;

    @ApiModelProperty(value = "领券开始时间")
    private String takeStart;

    @ApiModelProperty(value = "领券结束时间")
    private String takeEnd;

    @ApiModelProperty(value = "用券开始时间")
    private String effectiveStart;

    @ApiModelProperty(value = "用券结束时间")
    private String effectiveEnd;

    @ApiModelProperty(value = "领券后几天内")
    private Integer effectiveDay;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;

    private static final long serialVersionUID = 1L;

}
