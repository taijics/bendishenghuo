package com.shop.cereshop.admin.page.live;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("直播间商品分页查询")
public class LiveProductPage {

    @ApiModelProperty("商品id")
    private Long productId;

    @ApiModelProperty("商品名称")
    private String productName;

    @ApiModelProperty("商品图像")
    private String productImage;

    @ApiModelProperty("库存")
    private Integer stockNumber;

    @ApiModelProperty("价格类型")
    private Integer priceType;

    @ApiModelProperty("一口价 当priceType = 1时有值")
    private BigDecimal fixedPrice;

    @ApiModelProperty("市场价当priceType = 3时有值")
    private BigDecimal marketPrice;

    @ApiModelProperty("价格区间最低值 当priceType = 2时有值")
    private BigDecimal minPrice;

    @ApiModelProperty("价格区间最高值 当priceType = 2时有值")
    private BigDecimal maxPrice;

    @ApiModelProperty("商品id")
    private Integer saleNumber;

    @ApiModelProperty("商品id")
    private BigDecimal saleAmount;
}
