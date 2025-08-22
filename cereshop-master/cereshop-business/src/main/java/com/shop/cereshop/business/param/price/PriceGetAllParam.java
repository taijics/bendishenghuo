/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.price;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取定价捆绑列表请求
 * @author
 */
@Data
@ApiModel(value = "PriceGetAllParam", description = "获取定价捆绑列表请求")
public class PriceGetAllParam extends PageParam {

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;
}
