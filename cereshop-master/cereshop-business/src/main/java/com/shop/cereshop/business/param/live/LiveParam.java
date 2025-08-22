package com.shop.cereshop.business.param.live;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 直播请求
 */
@Data
@ApiModel(value = "LiveParam", description = "直播请求")
public class LiveParam {

    @ApiModelProperty("id")
    private Long id;

    @ApiModelProperty("店铺id")
    private Long shopId;

}
