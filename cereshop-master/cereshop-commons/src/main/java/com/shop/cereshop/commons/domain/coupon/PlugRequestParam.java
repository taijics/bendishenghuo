package com.shop.cereshop.commons.domain.coupon;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("查询卡券参数")
public class PlugRequestParam {

    @ApiModelProperty("优惠券批次id")
    private String stockId;

    @ApiModelProperty("优惠券id")
    private Integer cId;

}
