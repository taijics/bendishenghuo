/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.param.live.LiveProductGetAllParam;
import com.shop.cereshop.admin.param.live.LiveProductParam;
import com.shop.cereshop.admin.service.live.CereLiveProductService;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 直播间商品管理
 */
@RestController
@RequestMapping("liveProduct")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "LiveProductController")
public class LiveProductController {

    @Autowired
    private CereLiveProductService cereLiveProductService;

    /**
     * 直播间商品列表查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "直播间商品列表查询")
    public Result<Page<CereLiveProduct>> getAll(@RequestBody LiveProductGetAllParam param) throws Exception{
        Page page= cereLiveProductService.getAll(param);
        return new Result(page);
    }

    /**
     * 审核直播间商品
     * @param param
     * @return
     */
    @PostMapping(value = "audit")
    @NoRepeatSubmit
    @ApiOperation(value = "审核直播间商品")
    @NoRepeatWebLog
    public Result audit(@RequestBody @Validated LiveProductParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereLiveProductService.audit(param,user);
        return new Result(user.getUsername(),"审核直播间商品", GsonUtil.objectToGson(param));
    }

    /**
     * 查询某个直播间商品
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @NoRepeatSubmit
    @ApiOperation(value = "查询某个直播间商品")
    @NoRepeatWebLog
    public Result getById(@RequestBody LiveProductParam param) throws CoBusinessException{
        CereLiveProduct liveProduct = cereLiveProductService.getById(param);
        return new Result(liveProduct);
    }

}
