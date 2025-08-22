/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.param.live.LiveGetAllParam;
import com.shop.cereshop.admin.param.live.LiveParam;
import com.shop.cereshop.admin.param.live.LiveProductPageParam;
import com.shop.cereshop.admin.service.live.CereLiveService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 直播
 */
@RestController
@RequestMapping("live")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "LiveController")
public class LiveController {

    @Autowired
    private CereLiveService cereLiveService;

    /**
     * 直播间列表查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "直播间列表查询")
    public Result<Page<CereLive>> getAll(@RequestBody LiveGetAllParam param) throws Exception {
        Page page=cereLiveService.getAll(param);
        return new Result(page);
    }

    /**
     * 审核直播间
     * @param param
     * @return
     */
    @PostMapping(value = "audit")
    @NoRepeatSubmit
    @ApiOperation(value = "审核直播间")
    @NoRepeatWebLog
    public Result audit(@RequestBody LiveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereLiveService.audit(param,user);
        return new Result(user.getUsername(),"审核直播间", GsonUtil.objectToGson(param));
    }

    /**
     * 查询某个直播间
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @NoRepeatSubmit
    @ApiOperation(value = "查询某个直播间")
    @NoRepeatWebLog
    public Result getById(@RequestBody LiveParam param) throws CoBusinessException{
        CereLive live = cereLiveService.getById(param);
        return new Result(live);
    }

    /**
     * 查询直播间的关联商品
     * @param param
     * @return
     */
    @PostMapping(value = "getLiveProductRelPageByLiveId")
    @NoRepeatSubmit
    @ApiOperation(value = "查询直播间的关联商品")
    @NoRepeatWebLog
    public Result getLiveProductRelPageByLiveId(@RequestBody LiveProductPageParam param) {
        Page page = cereLiveService.getLiveProductRelPageByLiveId(param);
        return new Result(page);
    }

}
