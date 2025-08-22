package com.shop.cereshop.commons.domain.coupon;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@Data
@ApiModel("卡券参数请求返回对象")
public class PlugRequestParamVO {

    @ApiModelProperty("发券参数")
    private List<SendCouponParam> send_coupon_params;

    @ApiModelProperty("签名")
    private String sign;

    @ApiModelProperty("发券商户号")
    private String send_coupon_merchant;

    @ApiModelProperty("券id")
    private Integer cid;

}
