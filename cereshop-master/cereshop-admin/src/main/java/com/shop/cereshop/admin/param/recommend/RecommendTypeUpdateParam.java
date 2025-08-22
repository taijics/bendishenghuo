/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.recommend;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 种草类型修改
 */
@Data
@ApiModel(value = "RecommendTypeUpdateParam", description = "种草类型修改")
public class RecommendTypeUpdateParam {

    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendTypeId;

    /**
     * 类型名称
     */
    @ApiModelProperty(value = "类型名称")
    private String name;
    /**
     * 排序
     */
    @ApiModelProperty(value = "排序")
    private Integer sort;

}
