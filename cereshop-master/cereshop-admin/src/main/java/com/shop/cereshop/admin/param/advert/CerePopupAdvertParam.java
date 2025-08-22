package com.shop.cereshop.admin.param.advert;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 弹窗广告请求
 * @author
 */
@Data
@ApiModel(value = "CerePopupAdvertParam", description = "弹窗广告请求")
public class CerePopupAdvertParam extends PageParam {

    @ApiModelProperty("广告名称")
    private String name;

    @ApiModelProperty("状态 1-有效 0-无效")
    private Integer state;

}
