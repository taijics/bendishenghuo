package com.shop.cereshop.business.param.channel;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class ChannelActivityCouponParam {

    @ApiModelProperty("渠道活动id")
    private Long id;

    @ApiModelProperty("渠道券id")
    private Long couponId;

    /** 店铺id */
    private Long shopId;
}
