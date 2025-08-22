/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.channel;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取渠道活动关联券列表请求
 * @author
 */
@Data
@ApiModel(value = "ChannelActivityCouponPageParam", description = "获取渠道活动关联券列表请求")
public class ChannelActivityCouponPageParam extends PageParam {

    @ApiModelProperty("渠道活动id")
    private Long channelActivityId;

    /** 店铺id */
    private Long shopId;

}
