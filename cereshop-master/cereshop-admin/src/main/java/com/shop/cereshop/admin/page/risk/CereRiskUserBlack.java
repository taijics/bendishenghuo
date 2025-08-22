package com.shop.cereshop.admin.page.risk;

import com.shop.cereshop.commons.domain.risk.CereRiskBlack;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("用户黑名单分页对象")
public class CereRiskUserBlack extends CereRiskBlack {

    @ApiModelProperty("用户昵称")
    private String name;

    @ApiModelProperty("微信openId")
    private String openId;

    @ApiModelProperty("手机号")
    private String phone;

}
