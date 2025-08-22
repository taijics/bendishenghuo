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
 * 人群列表
 */
@Data
@ApiModel(value = "ShopCrowd", description = "获取人群列表请求")
public class ShopCrowd implements Serializable {

    /**
     * 店铺人群id
     */
    @ApiModelProperty(value = "店铺人群id")
    private Long shopCrowdId;

    /**
     * 人群名称
     */
    @ApiModelProperty(value = "人群名称")
    private String crowdName;

    /**
     * 人群定义
     */
    @ApiModelProperty(value = "人群定义")
    private String content;

    /**
     * 人群数量
     */
    @ApiModelProperty(value = "人群数量")
    private Integer users;

    /**
     * 店铺有购买最近几天购买过本店商品的客户（以支付成功为准，不剔除退款）
     */
    private Integer shopBuyYes;

    /**
     * 店铺无购买最近几天没有购买过本店商品的客户（以支付成功为准，不剔除退款）
     */
    private Integer shopBuyNo;

    /**
     * 店铺有下单最近几天在店铺有下单行为的客户（包含未付款客户）
     */
    private Integer shopOrderYes;

    /**
     * 店铺无下单最近几天（在店铺没有下单行为的客户）
     */
    private Integer shopOrderNo;

    /**
     * 店铺有加购最近几天（加购过本店商品的客户）
     */
    private Integer shopAddYes;

    /**
     * 店铺无加购最近几天（没有加购过本店商品的客户）
     */
    private Integer shopAddNo;

    /**
     * 店铺有访问最近几天（访问过本店的客户）
     */
    private Integer shopVisitYes;

    /**
     * 店铺无访问最近几天（没有访问过本店的客户）
     */
    private Integer shopVisitNo;

    /**
     * 有效购买次数比较类型  1-大于 2-等于 3-小于
     */
    private Integer effectiveBuy;

    /**
     * 有效购买次数，客户累计在店铺交易成功的订单数量（剔除退款的订单）
     */
    private Integer effectiveBuyCount;

    /**
     * 有效购买金额比较类型 1-大于 2-等于 3-小于
     */
    private Integer effectivePrice;

    /**
     * 有效购买金额，客户累计在店铺交易成功的金额数量（剔除退款金额）
     */
    private BigDecimal effectivePriceCount;

    /**
     * 商家标签id，多个以逗号隔开
     */
    private String labelName;

    private static final long serialVersionUID = 1L;

}
