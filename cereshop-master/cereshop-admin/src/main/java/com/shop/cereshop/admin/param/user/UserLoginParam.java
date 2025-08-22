/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.user;

import com.shop.cereshop.commons.config.RsaProperties;
import com.shop.cereshop.commons.utils.RsaUtils;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 登录请求实体
 */
@Data
@ApiModel(value = "UserLoginParam", description = "登录请求实体")
public class UserLoginParam {

    /**
     * 账号
     */
    @ApiModelProperty(value = "账号")
    private String username;

    /**
     * 验证码
     */
    @ApiModelProperty(value = "验证码")
    private String code;

    /**
     * 密码
     */
    @ApiModelProperty(value = "密码")
    private String password;

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
    public UserLoginParam decrypt() throws Exception {
        UserLoginParam res = new UserLoginParam();

        res.setUsername(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.username));
        res.setPassword(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.password));
        res.setCode(RsaUtils.decryptByPrivateKey(RsaProperties.privateKey,this.code));
        res.setRememberMe(this.rememberMe);

        return res;
    }
}
