package com.shop.cereshop.admin.param.brand;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class BrandGetAllParam extends PageParam {

    @ApiModelProperty("查询关键词")
    private String name;

}
