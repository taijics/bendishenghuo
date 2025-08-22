/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.shop;

import com.shop.cereshop.commons.config.RsaProperties;
import com.shop.cereshop.commons.utils.RsaUtils;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.springframework.beans.BeanUtils;

/**
 * 更新商家请求
 */
@Data
@ApiModel(value = "ShopUpdateParam", description = "更新商家请求")
public class ShopUpdateParam {

    /**
     * 商家用户id
     */
    @ApiModelProperty(value = "商家用户id")
    private Long businessUserId;

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 店铺名称
     */
    @ApiModelProperty(value = "店铺名称")
    private String shopName;

    /**
     * 店铺账号
     */
    @ApiModelProperty(value = "店铺账号")
    private String shopPhone;

    /**
     * 店铺密码
     */
    @ApiModelProperty(value = "店铺密码")
    private String shopPassword;

    /**
     * 店铺负责人
     */
    @ApiModelProperty(value = "店铺负责人")
    private String chargePersonName;

    /**
     * 负责人电话
     */
    @ApiModelProperty(value = "负责人电话")
    private String chargePersonPhone;

    /**
     * 店铺地址
     */
    @ApiModelProperty(value = "店铺地址")
    private String shopAdress;

    /**
     * 生效日期
     */
    @ApiModelProperty(value = "生效日期")
    private String effectiveDate;

    /**
     * 生效时限（年）
     */
    @ApiModelProperty(value = "生效时限（年）")
    private Integer effectiveYear;

    /**
     * 合同状态 1-有效 0-无效
     */
    @ApiModelProperty(value = "合同状态 1-有效 0-无效")
    private Integer contractState;

    /**
     * 审核直播间
     */
    @ApiModelProperty(value = "审核直播间 1-开启 0-关闭")
    private Integer auditLive;

    /**
     * 审核直播间商品
     */
    @ApiModelProperty(value = "审核直播间商品 1-开启 0-关闭")
    private Integer auditLiveProduct;
    
    /**
     * RSA解密
     * @return 解密对象
     * @throws Exception
     */
    public ShopUpdateParam decrypt() throws Exception {
        ShopUpdateParam res = new ShopUpdateParam();
        BeanUtils.copyProperties(this, res);
        res.setShopPassword(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.shopPassword));
        return res;
    }
}
