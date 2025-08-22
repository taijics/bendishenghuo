package com.shop.cereshop.admin.page.credit;

import com.shop.cereshop.commons.domain.credit.CereCreditRecord;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("直播间商品分页查询")
public class CereCreditRecordPage extends CereCreditRecord {

    /**
     * 用户昵称
     */
    @ApiModelProperty("用户昵称")
    private String name;

    /**
     * 用户手机号
     */
    @ApiModelProperty("用户手机号")
    private String phone;

}
