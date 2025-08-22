/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.permission;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取权限请求实体
 */
@Data
@ApiModel(value = "UserBuildParam", description = "获取权限请求实体")
public class UserBuildParam {

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 账户id
     */
    @ApiModelProperty(value = "账户id")
    private Long businessUserId;
}
