/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.page.after;

import com.shop.cereshop.commons.poi.export.ExcelResources;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 售后返回数据实体类
 */
@Data
@ApiModel(value = "After", description = "售后返回数据实体类")
public class After {

    /**
     * 店铺名称
     */
    @ApiModelProperty(value = "店铺名称")
    private String shopName;

    /**
     * 店铺编码
     */
    @ApiModelProperty(value = "店铺编码")
    private String shopCode;

    /**
     * 售后单号
     */
    @ApiModelProperty(value = "售后单号")
    private String afterFormid;

    /**
     * 售后类型  1-仅退款  2-退货退款
     */
    @ApiModelProperty(value = "售后类型  1-仅退款  2-退货退款")
    private String afterType;

    /**
     * 订单id
     */
    @ApiModelProperty(value = "订单id")
    private Long orderId;

    /**
     * 订单状态
     */
    @ApiModelProperty(value = "订单状态")
    private Integer orderState;

    /**
     * 售后商品数量
     */
    @ApiModelProperty(value = "售后商品数量")
    private Integer number;

    /**
     * 售后商品名称
     */
    @ApiModelProperty(value = "售后商品名称")
    private String afterProductNames;

    /**
     * 退款金额
     */
    @ApiModelProperty(value = "退款金额")
    private BigDecimal refundMoney;

    /**
     * 下单账户
     */
    @ApiModelProperty(value = "买家账户")
    private String customerName;

    /**
     * 物流公司
     */
    @ApiModelProperty(value = "物流公司")
    private String express;

    /**
     * 物流单号
     */
    @ApiModelProperty(value = "物流单号")
    private String deliverFormid;

    /**
     * 支付时间
     */
    @ApiModelProperty(value = "支付时间")
    private String paymentTime;

    /**
     * 申请平台介入时间
     */
    @ApiModelProperty(value = "申请平台介入时间")
    private String platformAfterTime;

    /**
     * 售后单id
     */
    @ApiModelProperty(value = "售后单id")
    private Long afterId;
    /**
     * 订单编号
     */
    @ApiModelProperty(value = "订单编号")
    private String orderFormid;

}
