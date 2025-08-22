package com.shop.cereshop.admin.page.activity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("活动统计数据")
public class ActivityStatsData {

    /**
     * 成交总额
     */
    @ApiModelProperty(value = "成交总额")
    private BigDecimal money;

    /**
     * 支付订单数
     */
    @ApiModelProperty(value = "支付订单数")
    private Integer orders;

    /**
     * 支付客户数
     */
    @ApiModelProperty(value = "支付客户数")
    private Integer users;

    /**
     * 参与商家数
     */
    @ApiModelProperty(value = "参与商家数")
    private Integer business;

    /**
     * 参与商品数
     */
    @ApiModelProperty(value = "参与商品数")
    private Integer products;

}
