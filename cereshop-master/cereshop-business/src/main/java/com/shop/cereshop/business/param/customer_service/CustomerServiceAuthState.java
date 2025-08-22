package com.shop.cereshop.business.param.customer_service;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("客服授权相关状态")
public class CustomerServiceAuthState {

    @ApiModelProperty("授权状态 1-未授权 2-已授权 3-获取授权链接异常")
    private Integer state;

    @ApiModelProperty("授权页面链接, 当state = 1时返回授权链接")
    private String authPageUrl;
}
