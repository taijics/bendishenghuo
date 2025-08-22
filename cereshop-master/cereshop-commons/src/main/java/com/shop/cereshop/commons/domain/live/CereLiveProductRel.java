package com.shop.cereshop.commons.domain.live;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("直播间和直播间商品的关联")
public class CereLiveProductRel {

    @ApiModelProperty("直播间id")
    private Long liveId;

    @ApiModelProperty("直播间商品id")
    private Long liveProductId;

    @ApiModelProperty("创建时间")
    private String createTime;

    @ApiModelProperty("更新时间")
    private String updateTime;

}
