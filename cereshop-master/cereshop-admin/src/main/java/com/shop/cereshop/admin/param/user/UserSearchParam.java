package com.shop.cereshop.admin.param.user;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("用户搜索条件")
public class UserSearchParam extends PageParam {

    @ApiModelProperty("buyerUserId/openId/昵称/手机号")
    private String searchKey;

}
