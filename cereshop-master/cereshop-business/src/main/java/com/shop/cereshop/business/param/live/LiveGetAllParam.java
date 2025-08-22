/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.live;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取直播列表请求
 * @author
 */
@Data
@ApiModel(value = "LiveGetAllParam", description = "获取直播列表请求")
public class LiveGetAllParam extends PageParam {

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 状态 0-待审核 1-审核已通过 2-审核未通过
     */
    @ApiModelProperty(value = "状态 0-待审核 1-审核已通过 2-审核未通过")
    private Integer state;


    /**
     * 搜索关键字
     */
    @ApiModelProperty(value = "搜索关键字")
    private String search;
}
