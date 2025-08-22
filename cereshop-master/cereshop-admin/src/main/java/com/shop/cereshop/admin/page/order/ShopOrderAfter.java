/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.page.order;

import com.shop.cereshop.admin.page.product.Product;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * 订单返回数据实体类
 */
@Data
@ApiModel(value = "ShopOrderAfter", description = "售后返回数据实体类")
public class ShopOrderAfter {


    /**
     * 订单id
     */
    @ApiModelProperty(value = "订单id")
    private Long orderId;

    /**
     * 售后ID
     */
    @ApiModelProperty(value = "售后ID")
    private Long afterId;
    /**
     * 售后状态
     */
    @ApiModelProperty(value = "售后状态")
    private Integer afterState;
}
