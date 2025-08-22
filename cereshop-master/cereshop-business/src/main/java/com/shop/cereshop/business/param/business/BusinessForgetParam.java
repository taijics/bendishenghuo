/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.business;

import com.shop.cereshop.commons.config.RsaProperties;
import com.shop.cereshop.commons.utils.RsaUtils;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 商家忘记密码请求
 */
@Data
@ApiModel(value = "BusinessForgetParam", description = "商家忘记密码请求")
public class BusinessForgetParam {

    /**
     * 用户名
     */
    @ApiModelProperty(value = "用户名")
    private String username;

    /**
     * 密码
     */
    @ApiModelProperty(value = "密码")
    private String password;

    /**
     * 验证码
     */
    @ApiModelProperty(value = "验证码")
    private String code;

    /**
     * 新密码
     */
    @ApiModelProperty(value = "新密码")
    private String newPassword;

    /**
     * RSA解密
     * @return 解密对象
     * @throws Exception
     */
    public BusinessForgetParam decrypt() throws Exception {
        BusinessForgetParam res = new BusinessForgetParam();
        res.setUsername(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.username));
        res.setPassword(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.password));
        res.setCode(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.code));
        res.setNewPassword(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.newPassword));
        return res;
    }
}
