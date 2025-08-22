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
 * 商家登录请求
 */
@Data
@ApiModel(value = "BusinessLoginParam", description = "商家登录请求")
public class BusinessLoginParam {

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
     * 是否7日内自动登录
     */
    @ApiModelProperty(value = "是否7日内自动登录")
    private Boolean rememberMe;

    /**
     * RSA解密
     * @return 解密对象
     * @throws Exception
     */
    public BusinessLoginParam decrypt() throws Exception {
        BusinessLoginParam res = new BusinessLoginParam();
        res.setUsername(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.username));
        res.setPassword(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.password));
        res.setCode(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.code));
        res.setRememberMe(this.rememberMe);
        return res;
    }
}
