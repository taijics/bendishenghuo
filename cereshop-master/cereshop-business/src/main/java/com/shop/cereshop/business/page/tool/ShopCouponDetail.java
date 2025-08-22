/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.page.tool;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 满减券/折扣券详情
 */
@Data
@ApiModel(value = "ShopCouponDetail", description = "满减/折扣券详情返回数据")
public class ShopCouponDetail implements Serializable {
    /**
     * 店铺优惠券id
     */
    @ApiModelProperty(value = "店铺优惠券id")
    private Long shopCouponId;

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 优惠券名称
     */
    @ApiModelProperty(value = "优惠券名称")
    private String couponName;

    /**
     * 备注
     */
    @ApiModelProperty(value = "备注")
    private String remark;

    /**
     * 优惠券类型 1-满减券 2-折扣券
     */
    @ApiModelProperty(value = "优惠券类型 1-满减券 2-折扣券")
    private Integer couponType;

    /**
     * 适用商品 1-全部商品 2-指定商品可用 3-指定商品不可用
     */
    @ApiModelProperty(value = "适用商品 1-全部商品 2-指定商品可用 3-指定商品不可用")
    private Integer applyType;

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

    /**
     * 用券时间 1-固定时间 2-领券当日起几天内可用
     */
    @ApiModelProperty(value = "用券时间 1-固定时间 2-领券当日起几天内可用")
    private Integer timeType;

    /**
     * 领券开始时间
     */
    @ApiModelProperty(value = "用券开始时间")
    private String takeStart;

    /**
     * 领券结束时间
     */
    @ApiModelProperty(value = "用券结束时间")
    private String takeEnd;

    /**
     * 用券开始时间
     */
    @ApiModelProperty(value = "用券开始时间")
    private String effectiveStart;

    /**
     * 用券结束时间
     */
    @ApiModelProperty(value = "用券结束时间")
    private String effectiveEnd;

    /**
     * 领券当日几天内（天数）
     */
    @ApiModelProperty(value = "领券当日几天内（天数）")
    private Integer effectiveDay;

    /**
     * 发放数量
     */
    @ApiModelProperty(value = "发放数量")
    private Integer number;

    /**
     * 每人限领次数  1-无限次 2-限制几次
     */
    @ApiModelProperty(value = "每人限领次数  1-无限次 2-限制几次")
    private Integer receiveType;

    /**
     * 限制次数
     */
    @ApiModelProperty(value = "限制次数")
    private Integer frequency;

    /**
     * 选中的商品id数组
     */
    @ApiModelProperty(value = "选中的商品id数组")
    private List<Long> ids;

    /**
     * 是否叠加平台优惠券 1-是 0-否
     */
    @ApiModelProperty(value = "是否叠加平台优惠券 1-是 0-否")
    private Integer ifAdd;

    /**
     * 优惠券分类 1-普通券 2-渠道券
     */
    @ApiModelProperty(value = "优惠券分类 1-普通券 2-渠道券")
    @NotNull(message = "优惠券分类不能为空")
    private Integer type;

    /**
     * 选中商品数据
     */
    @ApiModelProperty(value = "选中商品数据")
    private List<ToolProduct> products;

    /**
     * 指定商品不可用列表
     */
    @ApiModelProperty(value = "指定商品不可用列表")
    private List<Long> excludeIds;

    private static final long serialVersionUID = 1L;

}
