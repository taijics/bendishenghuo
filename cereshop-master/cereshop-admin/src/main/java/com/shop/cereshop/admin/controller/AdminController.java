/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import cn.hutool.core.util.ObjectUtil;
import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.message.service.miaoxin.MiaoxinMessageService;
import com.shop.cereshop.admin.page.permission.MenuButton;
import com.shop.cereshop.admin.param.user.UserBuildParam;
import com.shop.cereshop.admin.param.user.UserForgetPasswordParam;
import com.shop.cereshop.admin.param.user.UserGetCodeParam;
import com.shop.cereshop.admin.param.user.UserLoginParam;
import com.shop.cereshop.admin.redis.service.UserRedisService;
import com.shop.cereshop.admin.redis.service.api.StringRedisService;
import com.shop.cereshop.admin.service.permission.CerePlatformPermissionService;
import com.shop.cereshop.admin.service.redis.CereRedisKeyServcice;
import com.shop.cereshop.admin.service.shop.CereShopCheckService;
import com.shop.cereshop.admin.service.user.CerePlatformUserService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 用户登录
 */
@RestController
@RequestMapping("admin")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "AdminController")
@Api(value = "用户登录模块", tags = "用户登录模块")
public class AdminController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    private CerePlatformUserService cerePlatformUserService;

    @Autowired
    private CerePlatformPermissionService cerePlatformPermissionService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private MiaoxinMessageService miaoxinMessageService;

    @Autowired
    private CereRedisKeyServcice cereRedisKeyServcice;

    @Autowired
    private UserRedisService userRedisService;

    @Autowired
    private CereShopCheckService cereShopCheckService;

    @Value("${globalAdminPhone}")
    private String globalAdminPhone;

    /* 记录发送二次隐私认证的验证码的时间 */
    private static final String PRIVACY_CODE_SEND_TIME = "privacy_code_send_time_";

    /* 超过次数 */
    private static final String PRIVACY_BEYOND_COUNT = "privacy_beyond_count_";

    /* 隐私开关 */
    private static final String PRIVACY_SHOW_SWITCH = "privacy_show_switch_";

    /* 记录发送修改管理员手机号的验证码的时间 */
    private static final String UPDATE_PHONE_CODE_SEND_TIME = "update_phone_code_send_time";

    /* 修改管理员手机号-发送验证码-超过次数 */
    private static final String UPDATE_PHONE_BEYOND_COUNT = "update_phone_beyond_count";

    /**
     * 平台账户登录
     *
     * @param param 封装json对象
     * @return
     */
    @PostMapping(value = "login")
    @ApiOperation(value = "平台账户登录")
    public Result<CerePlatformUser> login(@RequestBody UserLoginParam param) throws CoBusinessException, Exception {
        //登录账号和密码解密
        try {
            if (param.getUsername().length() > 15) {
                param = param.decrypt();
            } else {

            }
            //param = param.decrypt();
        } catch (Exception e) {
        	e.printStackTrace();
            return new Result(CoReturnFormat.PARAM_INVALID);
        }
        CerePlatformUser user = null;
        if (!EmptyUtils.isEmpty(param.getCode())) {
            if (!param.getCode().equals("9999") /*|| noDemoAccount(param)*/) {
                //手机号登录,校验验证码
                String code = (String) stringRedisService.get(param.getUsername());
                if (!param.getCode().equals(code)) {
                    return new Result(CoReturnFormat.CODE_ERROR);
                }
            }
            //根据手机号查询账户信息
            user = cerePlatformUserService.findByPhone(param.getUsername());
            log.info("user: {}", user);
        } else {
            //根据账号查询token
            user = cerePlatformUserService.findByUserName(param.getUsername());
            if (user != null) {
                //校验密码
                if (!param.getPassword().equals(EncryptUtil.decrypt(user.getPassword()))) {
                    return new Result(CoReturnFormat.USER_OR_PASSWD_ERROR);
                }
            }
        }
        if (user == null) {
            return new Result(CoReturnFormat.USER_UNREGISTER);
        }
        if (IntegerEnum.NO.getCode().equals(user.getState())) {
            return new Result(CoReturnFormat.USER_TYPE_STOP);
        }

        String token;
        if (ObjectUtil.isNotNull(param.getRememberMe()) && param.getRememberMe()) {
            //记住我 不重新生成token
            token = userRedisService.getToken(user.getPlatformUserId());
            if (ObjectUtil.isNull(token)) {
                token = userRedisService.createToken4Remember(param.getUsername(), user.getPlatformUserId());
            }
            user.setToken(token);
            log.info("rememberMe token: {}", token);
        } else {
            //不记住我 重新生成token
            token = userRedisService.createToken(param.getUsername(), user.getPlatformUserId());
            log.info("not rememberMe token: {}", token);
        }
        user.setToken(token);
        request.setAttribute("user", user);
        return new Result(user);
    }

    private boolean noDemoAccount(UserLoginParam param) {
        CerePlatformUser user = cerePlatformUserService.findById(1L);
        if (user.getPhone().equals(param.getUsername())) {
            return false;
        }
        return true;
    }

//    @GetMapping("bigReq")
//    public Result bigReqList() {
//        List<String> result = new ArrayList<>(2048);
//        for (int i = 0; i < 204800; i++) {
//            result.add(UUID.randomUUID().toString());
//        }
//        return new Result(result,CoReturnFormat.SUCCESS);
//    }

    /**
     * 登录权限查询
     *
     * @return
     */
    @PostMapping(value = "build")
    @ApiOperation(value = "登录权限查询")
    public Result<List<MenuButton>> build(@RequestBody UserBuildParam user) throws CoBusinessException {
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
    public Result forgetPassword(@RequestBody UserForgetPasswordParam user) throws CoBusinessException {
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
        CerePlatformUser cerePlatformUser = cerePlatformUserService.findByPhone(user.getUsername());
        if (cerePlatformUser == null) {
            return new Result(CoReturnFormat.USER_UNREGISTER);
        }
        cerePlatformUserService.forgetPassword(user, cerePlatformUser);
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
    public Result getCode(@RequestBody UserGetCodeParam user) throws CoBusinessException, Exception {
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
            miaoxinMessageService.sendNotice(user.getPhone(), map);
        } catch (Exception e) {
            log.error("getCode fail: phone = {}", user.getPhone(), e);
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        return new Result();
    }

    /**
     * 获取管理员手机号
     *
     * @return
     */
    @PostMapping(value = "getAdminPhone")
    @ApiOperation(value = "获取管理员手机号")
    public Result<String> getAdminPhone(HttpServletRequest request) throws CoBusinessException, Exception {
        Result<String> result = new Result<>();
        if (StringUtils.isNotBlank(globalAdminPhone)) {
            result.setData(globalAdminPhone);
            return result;
        }
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        if (user == null) {
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        String phone = cerePlatformUserService.getAdminPhone();

        if (phone == null) {
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        //String desensitizationPhone = com.shop.cereshop.commons.utils.StringUtils.showStartAndEnd(phone,3,4);
        result.setData(phone);
        return result;
    }

    /**
     * 获取隐私短信验证码
     *
     * @param param
     * @return
     */
    @PostMapping(value = "getPrivacyCode")
    @ApiOperation(value = "获取隐私短信验证码")
    public Result<Boolean> getPrivacyCode(@RequestBody UserGetCodeParam param, HttpServletRequest request) throws CoBusinessException, Exception {
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        if (user == null) {
            return new Result<>(false);
        }
        //获取验证码
        String code = RandomStringUtil.getRandom();
        Map<String, String> map = new HashMap<>();
        map.put("code", code);
        //查询超时记录
        String beyondCountKey = PRIVACY_BEYOND_COUNT + user.getPlatformUserId();
        Integer beyondCount = (Integer)stringRedisService.get(beyondCountKey);
        if (beyondCount != null && beyondCount == 1) {
            throw new CoBusinessException(CoReturnFormat.SEND_CODE_ERR);
        }
        String sendTimeKey = PRIVACY_CODE_SEND_TIME + user.getPlatformUserId();
        //存储当前发送的时间
        String privacyCodeSendTime = (String)stringRedisService.get(sendTimeKey);
        log.info("privacyCodeSendTime: {}", privacyCodeSendTime);
        if (StringUtils.isNotBlank(privacyCodeSendTime)) {
            String[] timeArr = privacyCodeSendTime.split(",");
            if (timeArr.length >= 3) {
                log.info("timeArr.length >= 3");
                long compareTime = Long.parseLong(timeArr[timeArr.length - 3]);
                log.info("compareTime {}", compareTime);
                if (System.currentTimeMillis() - compareTime <= 30 * 60 * 1000) {
                    //超过之后，需要设置1小时不可再发送
                    stringRedisService.set(beyondCountKey, 1, 60 * 60 * 1000);
                    throw new CoBusinessException(CoReturnFormat.SEND_CODE_ERR);
                } else {
                    StringBuilder builder = new StringBuilder();
                    for (int i=timeArr.length-2;i<timeArr.length;i++) {
                        builder.append(timeArr[i]).append(",");
                    }
                    builder.append(System.currentTimeMillis());
                    privacyCodeSendTime = builder.toString();
                }
            } else {
                privacyCodeSendTime = privacyCodeSendTime + "," + System.currentTimeMillis();
            }
        } else {
            privacyCodeSendTime = System.currentTimeMillis() + "";
        }
        //发送短信给用户
        try {
            //验证码存到redis中(5分钟失效)
            stringRedisService.set(param.getPhone(), code, 300000);
            miaoxinMessageService.sendNotice(param.getPhone(), map);
            log.info("privacyCodeSendTime save: {}", privacyCodeSendTime);
            stringRedisService.set(sendTimeKey, privacyCodeSendTime);
        } catch (Exception e) {
            log.error("getPrivacyCode fail: phone = {}", param.getPhone(), e);
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        return new Result<>(true);
    }

    /**
     * 获取更新管理员手机号的短信验证码
     *
     * @param user
     * @return
     */
    @PostMapping(value = "getUpdatePhoneCode")
    @ApiOperation(value = "获取更新管理员手机号的短信验证码")
    public Result getUpdatePhoneCode(@RequestBody UserGetCodeParam user) throws CoBusinessException, Exception {
        //获取验证码
        String code = RandomStringUtil.getRandom();
        Map<String, String> map = new HashMap<>();
        map.put("code", code);
        //查询超时记录
        Integer beyondCount = (Integer)stringRedisService.get(UPDATE_PHONE_BEYOND_COUNT);
        if (beyondCount != null && beyondCount == 1) {
            throw new CoBusinessException(CoReturnFormat.SEND_CODE_ERR);
        }
        //存储当前发送的时间
        String updatePhoneCodeSendTime = (String)stringRedisService.get(UPDATE_PHONE_CODE_SEND_TIME);
        if (StringUtils.isNotBlank(updatePhoneCodeSendTime)) {
            String[] timeArr = updatePhoneCodeSendTime.split(",");
            if (timeArr.length >= 3) {
                long compareTime = Long.parseLong(timeArr[timeArr.length - 3]);
                if (System.currentTimeMillis() - compareTime <= 30 * 60 * 1000) {
                    //超过之后，需要设置1小时不可再发送
                    stringRedisService.set(UPDATE_PHONE_BEYOND_COUNT, 1, 60 * 60 * 1000);
                    throw new CoBusinessException(CoReturnFormat.SEND_CODE_ERR);
                } else {
                    StringBuilder builder = new StringBuilder();
                    for (int i=timeArr.length-2;i<timeArr.length;i++) {
                        builder.append(timeArr[i]).append(",");
                    }
                    builder.append(System.currentTimeMillis());
                    updatePhoneCodeSendTime = builder.toString();
                }
            } else {
                updatePhoneCodeSendTime = updatePhoneCodeSendTime + "," + System.currentTimeMillis();
            }
        } else {
            updatePhoneCodeSendTime = System.currentTimeMillis() + "";
        }
        //发送短信给用户
        try {
            //验证码存到redis中(5分钟失效)
            stringRedisService.set(user.getPhone(), code, 300000);
            miaoxinMessageService.sendNotice(user.getPhone(), map);
            stringRedisService.set(UPDATE_PHONE_CODE_SEND_TIME, updatePhoneCodeSendTime);
        } catch (Exception e) {
            log.error("getUpdatePhoneCode fail: phone = {}", user.getPhone(), e);
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        return new Result();
    }

    /**
     * 验证二次隐私开启
     *
     * @param param 封装json对象
     * @return
     */
    @PostMapping(value = "verifyPrivacyCode")
    @ApiOperation(value = "验证二次隐私开启")
    public Result<Boolean> verifyPrivacyCode(@RequestBody UserLoginParam param, HttpServletRequest request) throws CoBusinessException, Exception {
        //登录账号和密码解密
        try {
            if (param.getUsername().length() > 15) {
                param = param.decrypt();
            } else {

            }
            //param = param.decrypt();
        } catch (Exception e) {
            return new Result<>(CoReturnFormat.PARAM_INVALID);
        }
        boolean result = true;
        if (!EmptyUtils.isEmpty(param.getCode())) {
            //手机号登录,校验验证码
            String code = (String) stringRedisService.get(param.getUsername());
            if (!param.getCode().equals(code)) {
                return new Result<>(CoReturnFormat.CODE_ERROR);
            }
            CerePlatformUser user = (CerePlatformUser)request.getAttribute("user");
            if (user == null) {
                return new Result<>(false);
            }
            stringRedisService.set(PRIVACY_SHOW_SWITCH + user.getPlatformUserId(), System.currentTimeMillis(), 24 * 60 * 60 * 1000L);
        } else {
            result = false;
        }
        return new Result<>(result);
    }

    /**
     * 一键初始化redis延时任务
     *
     * @return
     */
    @PostMapping(value = "initializationRedis")
    @NoRepeatSubmit
    @ApiOperation(value = "一键初始化redis延时任务")
    public Result initializationRedis() throws Exception {
        cereRedisKeyServcice.initializationRedis();
        return new Result();
    }

    /**
     * 初始化店铺角色权限数据
     *
     * @return
     */
    @PostMapping(value = "initializationShopPermission")
    @NoRepeatSubmit
    @ApiOperation(value = "初始化店铺角色权限数据")
    public Result initializationShopPermission() throws CoBusinessException {
        cereShopCheckService.setInitPermission(2L, TimeUtils.yyMMddHHmmss());
        return new Result();
    }

}
