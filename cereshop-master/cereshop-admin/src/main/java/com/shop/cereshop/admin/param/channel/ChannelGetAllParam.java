package com.shop.cereshop.admin.param.channel;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import lombok.Data;

/**
 * 获取渠道列表请求
 */
@Data
@ApiModel(value = "ChannelGetAllParam", description = "获取渠道列表请求")
public class ChannelGetAllParam extends PageParam {
}
