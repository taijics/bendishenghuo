package com.shop.cereshop.business.param.customer_service;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel("企业微信接待员列表")
public class CpServiceReceptionist {

    @ApiModelProperty("名称")
    private String name;

    @ApiModelProperty("id 暂时没有作用，后续对接或许用得上")
    private String id;

}
