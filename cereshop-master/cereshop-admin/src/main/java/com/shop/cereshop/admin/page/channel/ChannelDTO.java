package com.shop.cereshop.admin.page.channel;

import com.shop.cereshop.commons.domain.channel.Channel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ChannelDTO extends Channel {

    @ApiModelProperty("注册人数")
    private Integer registerCount;

    @ApiModelProperty("下单人数")
    private Integer orderUserCount;

    @ApiModelProperty("下单数")
    private Integer orderCount;

    @ApiModelProperty("下单金额")
    private BigDecimal orderAmount;

}
