package com.shop.cereshop.admin.param.channel;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 渠道参数
 */
@Data
@ApiModel(value = "ChannelParam", description = "渠道参数")
public class ChannelParam {

    @ApiModelProperty("渠道id")
    private Long id;

    @ApiModelProperty("渠道名称")
    private String channelName;

}
