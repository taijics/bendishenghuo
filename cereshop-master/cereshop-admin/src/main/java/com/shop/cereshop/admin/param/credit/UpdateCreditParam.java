package com.shop.cereshop.admin.param.credit;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("修改积分的参数")
public class UpdateCreditParam {

    @ApiModelProperty("用户id")
    private Long buyerUserId;

    @ApiModelProperty("积分值 扣减积分则传负数")
    private Integer credit;
}
