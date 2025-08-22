/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.page.order;

import com.shop.cereshop.commons.poi.export.ExcelResources;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 订单导出实体类
 */
@Data
@ApiModel(value = "ShopOrderExportDTO", description = "订单导出实体类")
public class ShopOrderExportDTO {
    /**
     * 商户名称
     */
    @ApiModelProperty(value = "商户名称")
    @ExcelResources(order=0,title = "商户名称",cloumn = 10)
    private String shopName;
    /**
     * 订单id
     */
    @ApiModelProperty(value = "订单id")
    @ExcelResources(order=0,title = "订单id",cloumn = 15)
    private Long orderId;

    /**
     * 订单状态
     */
    @ApiModelProperty(value = "订单状态")
    @ExcelResources(order=1,title = "订单状态",cloumn = 10)
    private String state;

    /**
     * 支付方式
     */
    @ApiModelProperty(value = "支付方式")
    @ExcelResources(order=2,title = "支付方式",cloumn = 10)
    private String paymentMode;

    /**
     * 支付金额
     */
    @ApiModelProperty(value = "支付金额")
    @ExcelResources(order=3,title = "支付金额",cloumn = 10)
    private BigDecimal price;

    /**
     * 商品数量
     */
    @ApiModelProperty(value = "商品数量")
    @ExcelResources(order=4,title = "商品数量",cloumn = 10)
    private Integer number=0;


    /**
     * 商品信息数据
     */
    @ApiModelProperty(value = "商品信息数据")
    @ExcelResources(order=5,title = "全部商品名称/品牌/国际条码",cloumn = 20)
    private String productNames;

    /**
     * 下单账户
     */
    @ApiModelProperty(value = "下单账户")
    @ExcelResources(order=6,title = "下单账户",cloumn = 10)
    private String customerName;

    /**
     * 历史订单总数
     */
    @ApiModelProperty(value = "历史订单总数")
    @ExcelResources(order=7,title = "历史订单总数",cloumn = 20)
    private Integer historyOrderNum;

    /**
     * 支付单号
     */
    @ApiModelProperty(value = "支付单号")
    @ExcelResources(order=8,title = "支付单号",cloumn = 20)
    private String transactionId;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    @ExcelResources(order=9,title = "创建时间",cloumn = 20)
    private String createTime;

    /**
     * 支付时间
     */
    @ApiModelProperty(value = "支付时间")
    @ExcelResources(order=10,title = "支付时间",cloumn = 20)
    private String paymentTime;

    /**
     * 收货人姓名
     */
    @ApiModelProperty(value = "收货人姓名")
    @ExcelResources(order=11,title = "收货人姓名",cloumn = 15)
    private String receiveName;

    /**
     * 收货人手机号
     */
    @ApiModelProperty(value = "收货人手机号")
    @ExcelResources(order=12,title = "收货手机号",cloumn = 15)
    private String receivePhone;

    /**
     * 收货人地址
     */
    @ApiModelProperty(value = "收货人地址")
    @ExcelResources(order=13,title = "收货地址",cloumn = 20)
    private String receiveAdress;

    /**
     * 下单备注
     */
    @ApiModelProperty(value = "下单备注")
    @ExcelResources(order=14,title = "下单备注",cloumn = 20)
    private String remark;

}
