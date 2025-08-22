/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.param.live.*;
import com.shop.cereshop.business.service.live.CereLiveService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
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
    public Result<Page<CereLive>> getAll(@RequestBody LiveGetAllParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        Page page=cereLiveService.getAll(param);
        return new Result(page);
    }

    /**
     * 添加直播间
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "添加直播间")
    @NoRepeatWebLog
    public Result save(@RequestBody @Validated CereLive param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        cereLiveService.save(param,user);
        return new Result(user.getUsername(),"添加直播间", GsonUtil.objectToGson(param));
    }

    /**
     * 修改直播间
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改直播间")
    @NoRepeatWebLog
    public Result update(@RequestBody CereLive param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        cereLiveService.update(param,user);
        return new Result(user.getUsername(),"修改直播间", GsonUtil.objectToGson(param));
    }

    /**
     * 删除直播间
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除直播间")
    @NoRepeatWebLog
    public Result delete(@RequestBody LiveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereLiveService.delete(param.getId(),user);
        return new Result(user.getUsername(),"删除直播间", GsonUtil.objectToGson(param));
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
    public Result getById(@RequestBody LiveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        CereLive live = cereLiveService.getById(param);
        return new Result(live);
    }

    /**
     * 导入直播间商品
     * @param param
     * @return
     */
    @PostMapping(value = "importProduct")
    @NoRepeatSubmit
    @ApiOperation(value = "导入直播间商品")
    @NoRepeatWebLog
    public Result importProduct(@RequestBody LiveProductRelParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        cereLiveService.importProduct(param, user);
        return new Result();
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
    public Result getLiveProductRelPageByLiveId(@RequestBody LiveProductPageParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        Page page = cereLiveService.getLiveProductRelPageByLiveId(param);
        return new Result(page);
    }

    /**
     * 重新审核某个直播间
     * @param param
     * @return
     */
    @PostMapping(value = "reExamine")
    @NoRepeatSubmit
    @ApiOperation(value = "重新审核某个直播间")
    @NoRepeatWebLog
    public Result<Integer> reExamine(@RequestBody LiveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        int result = cereLiveService.reExamine(param);
        return new Result(result);
    }

    /**
     * 验证主播账号
     * @param param
     * @return
     */
    @PostMapping(value = "verifyAnchor")
    @NoRepeatSubmit
    @ApiOperation(value = "验证主播账号")
    @NoRepeatWebLog
    public Result<Boolean> verifyAnchor(@RequestBody AnchorWechatParam param) throws CoBusinessException{
        boolean verifyResult = cereLiveService.verifyAnchor(param);
        return new Result(verifyResult);
    }
}
