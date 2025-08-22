/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.channel;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import lombok.Data;

/**
 * 获取渠道活动列表请求
 * @author
 */
@Data
@ApiModel(value = "ChannelActivityGetAllParam", description = "获取渠道活动列表请求")
public class ChannelActivityGetAllParam extends PageParam {

    private Long shopId;

}
