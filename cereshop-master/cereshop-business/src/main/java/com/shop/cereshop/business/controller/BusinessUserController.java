/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.message.service.miaoxin.MiaoxinMessageService;
import com.shop.cereshop.business.page.shop.PlatformBusiness;
import com.shop.cereshop.business.page.user.Business;
import com.shop.cereshop.business.param.business.BusinessLoginParam;
import com.shop.cereshop.business.param.user.*;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.business.CerePlatformBusinessService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.GsonUtil;
import com.shop.cereshop.commons.utils.RandomStringUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户管理
 */
@RestController
@RequestMapping("user")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "BusinessUserController")
@Api(value = "用户管理", tags = "用户管理")
public class BusinessUserController {

    @Autowired
    private CerePlatformBusinessService cerePlatformBusinessService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private MiaoxinMessageService miaoxinMessageService;

    @Value("${globalAdminPhone}")
    private String globalAdminPhone;

    /* 记录发送二次隐私认证的验证码的时间 */
    private static final String PRIVACY_CODE_SEND_TIME = "business_privacy_code_send_time_";

    /* 超过次数 */
    private static final String PRIVACY_BEYOND_COUNT = "business_privacy_beyond_count_";

    /* 隐私开关 */
    private static final String PRIVACY_SHOW_SWITCH = "business_privacy_show_switch_";

    /* 记录发送修改管理员手机号的验证码的时间 */
    private static final String UPDATE_PHONE_CODE_SEND_TIME = "business_update_phone_code_send_time";

    /* 修改管理员手机号-发送验证码-超过次数 */
    private static final String UPDATE_PHONE_BEYOND_COUNT = "business_update_phone_beyond_count";

    /**
     * 添加用户
     * @param business
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "添加用户")
    @NoRepeatWebLog
    public Result save(@RequestBody @Validated BusinessSaveUser business, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        business.setShopId(user.getShopId());
        cerePlatformBusinessService.save(business,user);
        return new Result(user.getUsername(),"添加用户", GsonUtil.objectToGson(business));
    }

    /**
     * 修改用户
     * @param business
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改用户")
    @NoRepeatWebLog
    public Result update(@RequestBody BusinessUpdateUser business, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        interceptUpdate(business);
        cerePlatformBusinessService.update(business,user);
        return new Result(user.getUsername(),"修改用户", GsonUtil.objectToGson(business));
    }

    private void interceptUpdate(BusinessUpdateUser business) throws CoBusinessException {
        if (business != null && business.getBusinessUserId() != null && business.getBusinessUserId() == 125) {
            throw new CoBusinessException("演示环境不允许修改默认用户信息");
        }
    }

    /**
     * 删除用户
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除用户")
    @NoRepeatWebLog
    public Result delete(@RequestBody BusinessDeleteUser param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        ContextUtil.interceptDelete(user);
        cerePlatformBusinessService.delete(param,user);
        return new Result(user.getUsername(),"删除用户", GsonUtil.objectToGson(param));
    }

    /**
     * 修改用户查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "修改用户查询")
    public Result<PlatformBusiness> getById(@RequestBody BusinessDeleteUser param) throws CoBusinessException,Exception{
        Business business=cerePlatformBusinessService.getById(param.getBusinessUserId());
        return new Result(business);
    }

    /**
     * 用户管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "用户管理查询")
    @NoRepeatSubmit
    public Result<Page<CerePlatformBusiness>> getAll(@RequestBody BusinessGetAllUser param,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        Page page=cerePlatformBusinessService.getAll(param);
        return new Result(page);
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
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        if (user == null) {
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
        String phone = cerePlatformBusinessService.findAdminPhone(user.getShopId());
        if (phone == null) {
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
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
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        if (user == null) {
            return new Result<>(false);
        }
        //获取验证码
        String code = RandomStringUtil.getRandom();
        Map<String, String> map = new HashMap<>();
        map.put("code", code);
        //查询超时记录
        String beyondCountKey = PRIVACY_BEYOND_COUNT + user.getBusinessUserId();
        Integer beyondCount = (Integer)stringRedisService.get(beyondCountKey);
        if (beyondCount != null && beyondCount == 1) {
            throw new CoBusinessException(CoReturnFormat.SEND_CODE_ERR);
        }
        String sendTimeKey = PRIVACY_CODE_SEND_TIME + user.getBusinessUserId();
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
     * 验证二次隐私开启
     *
     * @param param 封装json对象
     * @return
     */
    @PostMapping(value = "verifyPrivacyCode")
    @ApiOperation(value = "验证二次隐私开启")
    public Result<Boolean> verifyPrivacyCode(@RequestBody BusinessLoginParam param, HttpServletRequest request) throws CoBusinessException, Exception {
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
            //获取当前登录账户
            CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
            if (user == null) {
                return new Result<>(false);
            }
            stringRedisService.set(PRIVACY_SHOW_SWITCH + user.getBusinessUserId(), System.currentTimeMillis(), 24 * 60 * 60 * 1000L);
        } else {
            result = false;
        }
        return new Result<>(result);
    }

    /**
     * 获取更新管理员手机号的短信验证码
     *
     * @param user
     * @return
     */
    @PostMapping(value = "getUpdatePhoneCode")
    @ApiOperation(value = "获取更新管理员手机号的短信验证码")
    public Result<Boolean> getUpdatePhoneCode(@RequestBody UserGetCodeParam user) throws CoBusinessException, Exception {
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
        return new Result<>(true);
    }

    /**
     * 更新管理员手机号
     *
     * @return
     */
    @PostMapping(value = "updatePhone")
    @ApiOperation(value = "更新管理员手机号")
    public Result<Boolean> updatePhone(@RequestBody UserUpdatePhoneParam param, HttpServletRequest request) throws CoBusinessException {
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        boolean result = true;
        try {
            if (param.getPhone().length() > 15) {
                param = param.decrypt();
            } else {

            }
            //param = param.decrypt();
        } catch (Exception e) {
            return new Result<>(CoReturnFormat.PARAM_INVALID);
        }
        if (!EmptyUtils.isEmpty(param.getCode())) {
            //手机号登录,校验验证码
            String code = (String) stringRedisService.get(param.getPhone());
            if (!param.getCode().equals(code)) {
                return new Result<>(CoReturnFormat.CODE_ERROR);
            }
            cerePlatformBusinessService.updatePhone(param, user);
        } else {
            result = false;
        }
        return new Result<>(result);
    }

    /**
     * 查询当前用户是否进行过二次认证
     *
     * @return
     */
    @PostMapping(value = "getPrivacySwitch")
    @ApiOperation(value = "查询当前用户是否进行过二次认证")
    public Result<Long> getPrivacySwitch(HttpServletRequest request) {
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        if (user != null) {
            Long switchTimestamp = (Long)stringRedisService.get(PRIVACY_SHOW_SWITCH + user.getBusinessUserId());
            if (switchTimestamp != null && switchTimestamp > 0) {
                return new Result<>(switchTimestamp);
            }
        }
        return new Result<>(0L);
    }
}
