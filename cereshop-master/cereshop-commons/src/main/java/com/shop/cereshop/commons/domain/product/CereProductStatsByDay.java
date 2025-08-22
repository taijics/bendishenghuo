package com.shop.cereshop.commons.domain.product;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * cere_product_stats_by_day 商品日度统计表
 * @author
 */
@Data
@ApiModel(value = "CereProductStatsByDay", description = "商品日度统计表")
public class CereProductStatsByDay implements Serializable {

    @ApiModelProperty("日期")
    private String createDate;

    @ApiModelProperty("商品id")
    private Long productId;

    @ApiModelProperty("店铺id")
    private Long shopId;

    @ApiModelProperty("加购量")
    private Integer addCartCount;

    @ApiModelProperty("访问量")
    private Integer visitCount;

    @ApiModelProperty("销量")
    private Integer salesVolume;

}
