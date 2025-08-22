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
public class AfterExportDTO {
    /**
     * 店铺名称
     */
    @ApiModelProperty(value = "店铺名称")
    @ExcelResources(order=0,title = "店铺名称",cloumn = 20)
    private String shopName;

    /**
     * 店铺编码
     */
    @ApiModelProperty(value = "店铺编码")
    @ExcelResources(order=1,title = "店铺编码",cloumn = 20)
    private String shopCode;

    /**
     * 售后单号
     */
    @ApiModelProperty(value = "售后单号")
    @ExcelResources(order=2,title = "售后单号",cloumn = 20)
    private String afterFormid;

    /**
     * 售后类型  1-仅退款  2-退货退款
     */
    @ApiModelProperty(value = "售后类型  1-仅退款  2-退货退款")
    @ExcelResources(order=3,title = "售后类型",cloumn = 20)
    private String afterType;

    /**
     * 订单id
     */
    @ApiModelProperty(value = "订单id")
    @ExcelResources(order=4,title = "订单id",cloumn = 20)
    private Long orderId;

    /**
     * 订单状态
     */
    @ApiModelProperty(value = "订单状态")
    @ExcelResources(order=5,title = "订单状态",cloumn = 20)
    private String orderState;

    /**
     * 售后商品数量
     */
    @ApiModelProperty(value = "售后商品数量")
    @ExcelResources(order=6,title = "售后商品数量",cloumn = 20)
    private Integer number;

    /**
     * 售后商品名称
     */
    @ApiModelProperty(value = "售后商品名称")
    @ExcelResources(order=7,title = "售后商品名称",cloumn = 20)
    private String afterProductNames;

    /**
     * 退款金额
     */
    @ApiModelProperty(value = "退款金额")
    @ExcelResources(order=8,title = "退款金额",cloumn = 20)
    private BigDecimal refundMoney;

    /**
     * 下单账户
     */
    @ApiModelProperty(value = "买家账户")
    @ExcelResources(order=9,title = "买家账户",cloumn = 10)
    private String customerName;

    /**
     * 物流公司
     */
    @ApiModelProperty(value = "物流公司")
    @ExcelResources(order=10,title = "物流公司",cloumn = 20)
    private String express;

    /**
     * 物流单号
     */
    @ApiModelProperty(value = "物流单号")
    @ExcelResources(order=11,title = "物流单号",cloumn = 20)
    private String deliverFormid;

    /**
     * 支付时间
     */
    @ApiModelProperty(value = "支付时间")
    @ExcelResources(order=12,title = "支付时间",cloumn = 20)
    private String paymentTime;

    /**
     * 申请平台介入时间
     */
    @ApiModelProperty(value = "申请平台介入时间")
    @ExcelResources(order=13,title = "申请平台介入时间",cloumn = 20)
    private String platformAfterTime;

}
