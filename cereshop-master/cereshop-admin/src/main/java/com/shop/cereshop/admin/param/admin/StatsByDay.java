package com.shop.cereshop.admin.param.admin;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("按照日期统计数据")
public class StatsByDay {

    @ApiModelProperty("具体日期")
    private String statsDate;

    @ApiModelProperty("数量")
    private Integer totalCount;

}
