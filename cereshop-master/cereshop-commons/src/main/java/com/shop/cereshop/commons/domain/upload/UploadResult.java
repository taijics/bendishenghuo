package com.shop.cereshop.commons.domain.upload;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("上传返回对象")
public class UploadResult {

    @ApiModelProperty("url")
    private String url;

    @ApiModelProperty("mediaId")
    private String mediaId;

}
