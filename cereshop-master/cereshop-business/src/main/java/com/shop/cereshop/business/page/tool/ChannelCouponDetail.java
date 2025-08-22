package com.shop.cereshop.business.page.tool;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("渠道券列表对象")
public class ChannelCouponDetail extends ShopCoupon {

    private static final long serialVersionUID = -3321460971424382984L;

    @ApiModelProperty("商品id")
    private Long productId;

    @ApiModelProperty("商品名称")
    private String productName;

    @ApiModelProperty("商品图像")
    private String productImage;

    @ApiModelProperty("发放数量")
    private Integer number;

    @ApiModelProperty("库存数量")
    private Integer stockNumber;

    @ApiModelProperty("开始时间")
    private String effectiveStart;

    @ApiModelProperty("结束时间")
    private String effectiveEnd;

}
