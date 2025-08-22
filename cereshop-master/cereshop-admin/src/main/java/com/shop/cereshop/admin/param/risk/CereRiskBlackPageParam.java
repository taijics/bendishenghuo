package com.shop.cereshop.admin.param.risk;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("ip黑名单请求")
public class CereRiskBlackPageParam extends PageParam {

    @ApiModelProperty("ip")
    private String ip;

    @ApiModelProperty("状态")
    private Integer state;

    @ApiModelProperty("search 用于查询用户黑名单")
    private String search;
}
