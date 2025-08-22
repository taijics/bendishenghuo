/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import cn.binarywang.wx.miniapp.api.WxMaService;
import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.page.tool.*;
import com.shop.cereshop.business.param.tool.*;
import com.shop.cereshop.business.service.tool.CereChannelCouponService;
import com.shop.cereshop.business.service.tool.CereShopCouponService;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereChannelCoupon;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * 渠道优惠券管理
 */
@RestController
@RequestMapping("channelCoupon")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "ChannelCouponController")
@Api(value = "渠道优惠券管理模块", tags = "渠道优惠券管理模块")
public class ChannelCouponController {

    @Autowired
    private CereChannelCouponService cereChannelCouponService;

    /**
     * 分页查询渠道优惠券
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @NoRepeatSubmit
    @ApiOperation(value = "分页查询渠道优惠券")
    @NoRepeatWebLog
    public Result<Page<ChannelCouponDetail>> getAll(@RequestBody @Validated ChannelCouponParam param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        Page<ChannelCouponDetail> result = cereChannelCouponService.getAll(param);
        return new Result(result);
    }

    /**
     * 新增渠道优惠券
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "新增渠道优惠券")
    @NoRepeatWebLog
    public Result save(@RequestBody CereChannelCoupon param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        cereChannelCouponService.save(param);
        return new Result(user.getUsername(),"新增渠道优惠券", GsonUtil.objectToGson(param));
    }

    /**
     * 生成渠道页链接
     * @param param
     * @return
     */
    @PostMapping(value = "generateLink")
    @NoRepeatSubmit
    @ApiOperation(value = "生成渠道页链接")
    @NoRepeatWebLog
    public Result<String> generateLink(@RequestBody CereChannelCoupon param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        String link = cereChannelCouponService.generateLink(param);
        Result<String> result = new Result();
        result.setData(link);
        return result;
    }

}
