/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.recommend;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取种草类型列表请求
 */
@Data
@ApiModel(value = "RecommendTypePageParam", description = "获取种草类型列表请求")
public class RecommendTypePageParam extends PageParam {

    /**
     * 类型名称
     */
    @ApiModelProperty(value = "类型名称")
    private String name;
}
