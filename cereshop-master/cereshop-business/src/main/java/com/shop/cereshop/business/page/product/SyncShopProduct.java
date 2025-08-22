package com.shop.cereshop.business.page.product;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@ApiModel("同步给scrm的商品对象")
@Data
public class SyncShopProduct extends ShopProduct {

    private List<Sku> skuList;

    @ApiModelProperty("分类名称")
    private String classifyName;

}
