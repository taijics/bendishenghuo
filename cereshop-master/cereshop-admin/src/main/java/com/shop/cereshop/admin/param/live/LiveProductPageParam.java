/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.live;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 直播间关联商品分页请求参数
 */
@Data
@ApiModel("直播间关联商品分页请求参数")
public class LiveProductPageParam extends PageParam {

    @ApiModelProperty("直播间id")
    private Long liveId;

    @ApiModelProperty("店铺id")
    private Long shopId;

}
