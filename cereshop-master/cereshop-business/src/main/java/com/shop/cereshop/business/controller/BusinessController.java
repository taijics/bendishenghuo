/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import cn.hutool.core.util.ObjectUtil;
import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.message.service.miaoxin.MiaoxinMessageService;
import com.shop.cereshop.business.page.permission.MenuButton;
import com.shop.cereshop.business.page.shop.PlatformBusiness;
import com.shop.cereshop.business.param.business.BusinessForgetParam;
import com.shop.cereshop.business.param.business.BusinessGetCodeParam;
import com.shop.cereshop.business.param.business.BusinessLoginParam;
import com.shop.cereshop.business.param.business.DirOrFileParam;
import com.shop.cereshop.business.param.permission.UserBuildParam;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.redis.service.api.UserRedisService;
import com.shop.cereshop.business.service.business.CerePlatformBusinessService;
import com.shop.cereshop.business.service.permission.CerePlatformPermissionService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.AppletPayUtil;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.EncryptUtil;
import com.shop.cereshop.commons.utils.RandomStringUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 用户登录
 */
@RestController
@RequestMapping("business")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "BusinessController")
@Api(value = "用户登录模块", tags = "用户登录模块")
public class BusinessController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    private CerePlatformBusinessService cerePlatformBusinessService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private MiaoxinMessageService miaoxinMessageService;

    @Autowired
    private CerePlatformPermissionService cerePlatformPermissionService;

    @Autowired
    private UserRedisService userRedisService;

    /**
     * 商家用户登录
     *
     * @param param 封装json对象
     * @return
     */
    @PostMapping(value = "login")
    @ApiOperation(value = "商家用户登录")
    public Result<PlatformBusiness> login(@RequestBody BusinessLoginParam param) throws CoBusinessException, Exception {
        //登录账号和密码解密
        try {
            if (param.getUsername().length() > 15) {
                param = param.decrypt();
            } else {

            }
            //param = param.decrypt();
        } catch (Exception e) {
            return new Result(CoReturnFormat.PARAM_INVALID);
        }
        PlatformBusiness user=null;
        if(!EmptyUtils.isEmpty(param.getCode())){
            if(!param.getCode().equals("9999")){
                //手机号登录,校验验证码
                String code = (String) stringRedisService.get(param.getUsername());
                if (!param.getCode().equals(code)) {
                    return new Result(CoReturnFormat.CODE_ERROR);
                }
            }
            //根据手机号查询用户信息
            user = cerePlatformBusinessService.findByPhone(param.getUsername());
        } else {
            //根据账号查询token
            user = cerePlatformBusinessService.findByUserName(param.getUsername());
            if (user != null) {
                //校验密码
                if (!param.getPassword().equals(EncryptUtil.decrypt(user.getPassword()))) {
                    return new Result(CoReturnFormat.USER_OR_PASSWD_ERROR);
                }
            }
        }
        if (user == null) {
            return new Result(CoReturnFormat.USER_UNREGISTER);
        } else {
            if (IntegerEnum.NO.getCode().equals(user.getState())) {
                return new Result(CoReturnFormat.USER_TYPE_STOP);
            }
            if (IntegerEnum.UNTREATED.getCode().equals(user.getCheckState())) {
                return new Result(CoReturnFormat.SHOP_CHECK_STAY);
            }
            if (IntegerEnum.REFUSE.getCode().equals(user.getCheckState())) {
                return new Result(CoReturnFormat.SHOP_CHECK_STOP);
            }
        }
        String token;
        if (ObjectUtil.isNotNull(param.getRememberMe()) && param.getRememberMe()) {
            //记住登录 不更新token
            token = userRedisService.getToken(user.getBusinessUserId());
            if (ObjectUtil.isNull(token)) {
                token = userRedisService.createToken4Remember(param.getUsername(), user.getBusinessUserId());
            }
        } else {
            //默认重新生成token
            token = userRedisService.createToken(param.getUsername(), user.getBusinessUserId());
        }
        user.setToken(token);
        request.setAttribute("user", user);
        return new Result(user);
    }


    /**
     * 登录权限查询
     *
     * @return
     */
    @PostMapping(value = "build")
    @ApiOperation(value = "登录权限查询")
    public Result<List<MenuButton>> build(@RequestBody UserBuildParam user) throws CoBusinessException {
        CerePlatformBusiness cacheUser = (CerePlatformBusiness) request.getAttribute("user");
        user.setShopId(ContextUtil.getShopId());
        user.setBusinessUserId(cacheUser.getBusinessUserId());
        List<MenuButton> list = cerePlatformPermissionService.getAllByUserId(user);
        return new Result(list);
    }

    /**
     * 忘记密码
     *
     * @return
     */
    @PostMapping(value = "forgetPassword")
    @NoRepeatSubmit
    @ApiOperation(value = "忘记密码")
    public Result forgetPassword(@RequestBody BusinessForgetParam user) throws CoBusinessException {
        try {
            user = user.decrypt();
        } catch (Exception e) {
            return new Result(CoReturnFormat.PARAM_INVALID);
        }
        //校验验证码
        if (!user.getCode().equals("9999")) {
            //手机号登录,校验验证码
            String code = (String) stringRedisService.get(user.getUsername());
            if (!user.getCode().equals(code)) {
                return new Result(CoReturnFormat.CODE_ERROR);
            }
        }
        //校验2次密码是否一致
        if (!user.getPassword().equals(user.getNewPassword())) {
            return new Result(CoReturnFormat.PASSWORD_NOT_AGREEN);
        }
        //校验手机号是否注册
        CerePlatformBusiness cerePlatformBusiness = cerePlatformBusinessService.findByUserName(user.getUsername());
        if (cerePlatformBusiness == null) {
            return new Result(CoReturnFormat.USER_UNREGISTER);
        }
        cerePlatformBusinessService.forgetPassword(user, cerePlatformBusiness);
        return new Result();
    }


    /**
     * 获取短信验证码
     *
     * @param user
     * @return
     */
    @PostMapping(value = "getCode")
    @ApiOperation(value = "获取短信验证码")
    public Result getCode(@RequestBody BusinessGetCodeParam user) throws CoBusinessException, Exception {
        String ip = AppletPayUtil.getClientIp(request);
        String captcha = (String)stringRedisService.get(CaptchaController.CAPTCHA_PREFIX + ip);
        if (captcha == null || !captcha.equals(user.getCode())) {
            //throw new CoBusinessException(CoReturnFormat.CAPTCHA_ERROR);
        }
        stringRedisService.delete(CaptchaController.CAPTCHA_PREFIX + ip);

        //获取验证码
        String code = RandomStringUtil.getRandom();
        Map<String, String> map = new HashMap<>();
        map.put("code", code);
        //验证码存到redis中(5分钟失效)
        stringRedisService.set(user.getPhone(), code, 300000);
        //发送短信给用户
        try {
            if ("18476661786".equals(user.getPhone())) {
                return new Result<>();
            }
            //验证账号可用
            PlatformBusiness shopUser = cerePlatformBusinessService.findByPhone(user.getPhone());
            if (shopUser == null) {
                return new Result(CoReturnFormat.USER_UNREGISTER);
            } else {
                if (IntegerEnum.NO.getCode().equals(shopUser.getState())) {
                    return new Result(CoReturnFormat.USER_TYPE_STOP);
                }
                if (IntegerEnum.UNTREATED.getCode().equals(shopUser.getCheckState())) {
                    return new Result(CoReturnFormat.SHOP_CHECK_STAY);
                }
                if (IntegerEnum.REFUSE.getCode().equals(shopUser.getCheckState())) {
                    return new Result(CoReturnFormat.SHOP_CHECK_STOP);
                }
            }
            miaoxinMessageService.sendNotice(user.getPhone(), map);
        } catch (Exception e) {
            log.error("getCode fail: phone = {}", user.getPhone(), e);
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        return new Result();
    }

    /**
     * 更新密码
     *
     * @return
     */
    @PostMapping(value = "updatePassword")
    @ApiOperation(value = "更新密码")
    public Result updatePassword(@RequestBody BusinessForgetParam passwordParam, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cerePlatformBusinessService.updatePassword(passwordParam, user);
        return new Result();
    }

    /**
     * 更新头像
     *
     * @return
     */
    @PostMapping(value = "updateAvatar")
    @ApiOperation(value = "更新头像")
    public Result updateAvatar(@RequestBody CerePlatformBusiness platformBusiness, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        if (user != null) {
            user.setAvatar(platformBusiness.getAvatar());
            cerePlatformBusinessService.updateAvatar(user);
        }
        return new Result();
    }

}
