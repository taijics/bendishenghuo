/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.param.advert.CerePopupAdvertParam;
import com.shop.cereshop.admin.service.advert.CerePopupAdvertService;
import com.shop.cereshop.commons.domain.advert.CerePopupAdvert;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 广告
 */
@RestController
@RequestMapping("advert")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "AdvertController")
@Api(value = "广告模块", tags = "广告模块")
public class AdvertController {

    @Autowired
    private CerePopupAdvertService cerePopupAdvertService;

    /**
     * 弹窗广告列表
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "弹窗广告列表")
    public Result<Page<CerePopupAdvert>> getAll(@RequestBody CerePopupAdvertParam param) throws CoBusinessException {
        Page page=cerePopupAdvertService.getAll(param);
        return new Result(page);
    }

    /**
     * 新增弹窗广告
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @ApiOperation(value = "新增弹窗广告")
    public Result<Integer> save(@RequestBody CerePopupAdvert param) throws CoBusinessException {
        int result = cerePopupAdvertService.save(param);
        return new Result(result);
    }

    /**
     * 修改弹窗广告
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @ApiOperation(value = "修改弹窗广告")
    public Result<Integer> update(@RequestBody CerePopupAdvert param) throws CoBusinessException {
        int result=cerePopupAdvertService.update(param);
        return new Result(result);
    }

    /**
     * 删除弹窗广告
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @ApiOperation(value = "删除弹窗广告")
    public Result<Integer> delete(@RequestBody CerePopupAdvert param) throws CoBusinessException {
        int result=cerePopupAdvertService.delete(param.getId());
        return new Result(result);
    }

    /**
     * 上架或下架弹窗广告
     * @param param
     * @return
     */
    @PostMapping(value = "toggle")
    @ApiOperation(value = "上架或下架弹窗广告")
    public Result<Integer> toggle(@RequestBody CerePopupAdvert param) throws CoBusinessException {
        int result=cerePopupAdvertService.toggleState(param.getId(), param.getState());
        return new Result(result);
    }

}
