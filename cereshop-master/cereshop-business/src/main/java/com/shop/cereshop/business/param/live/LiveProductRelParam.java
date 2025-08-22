/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.live;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * 直播间导入商品请求参数
 */
@Data
@ApiModel("直播间导入商品请求参数")
public class LiveProductRelParam {

    @ApiModelProperty("主键id")
    private Long liveId;

    @ApiModelProperty("店铺id")
    private Long shopId;

    @ApiModelProperty("直播商品id列表")
    private List<Long> liveProductIdList;

}
