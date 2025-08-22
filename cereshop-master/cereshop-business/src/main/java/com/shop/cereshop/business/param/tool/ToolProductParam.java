/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.tool;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 营销活动选择商品请求参数
 */
@Data
@ApiModel(value = "ToolProductParam", description = "营销活动选择商品请求参数")
public class ToolProductParam extends PageParam {

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 活动id
     */
    @ApiModelProperty(value = "活动id")
    private Long activityId;

    /**
     * 查询类型 2-指定商品可用 3-指定商品不可用
     */
    @ApiModelProperty(value = "查询类型")
    private Integer queryType;
}
