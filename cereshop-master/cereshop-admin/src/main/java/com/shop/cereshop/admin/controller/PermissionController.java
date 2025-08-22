/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.page.permission.Permission;
import com.shop.cereshop.admin.param.permission.*;
import com.shop.cereshop.admin.service.permission.CerePlatformPermissionService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.permission.CerePlatformPermission;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 菜单权限
 */
@RestController
@RequestMapping("permission")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "PermissionController")
@Api(value = "菜单权限模块", tags = "菜单权限模块")
public class PermissionController {

    @Autowired
    private CerePlatformPermissionService cerePlatformPermissionService;

    /**
     * 添加菜单权限
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "添加菜单权限")
    @NoRepeatWebLog
    public Result insert(@RequestBody @Validated PermissionSaveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformPermissionService.save(param,user);
        return new Result(user.getUsername(),"添加菜单权限", GsonUtil.objectToGson(param));
    }

    /**
     * 修改菜单权限
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改菜单权限")
    @NoRepeatWebLog
    public Result update(@RequestBody PermissionUpdateParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformPermissionService.update(param,user);
        return new Result(user.getUsername(),"修改菜单权限", GsonUtil.objectToGson(param));
    }

    /**
     * 删除菜单权限
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除菜单权限")
    @NoRepeatWebLog
    public Result delete(@RequestBody PermissionDeleteParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformPermissionService.delete(param,user);
        return new Result(user.getUsername(),"删除菜单权限", GsonUtil.objectToGson(param));
    }

    /**
     * 菜单权限编辑查询
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "菜单权限编辑查询")
    public Result<CerePlatformPermission> getById(@RequestBody PermissionGetByIdParam param) throws CoBusinessException{
        CerePlatformPermission cerePlatformPermission=cerePlatformPermissionService.getById(param.getPermissionId());
        return new Result(cerePlatformPermission);
    }

    /**
     * 查询当前最大排序值
     * @return
     */
    @PostMapping(value = "getMaxSort")
    @ApiOperation(value = "查询当前最大排序值")
    public Result<Integer> getMaxSort() throws CoBusinessException{
        Integer sort=cerePlatformPermissionService.getMaxSort();
        return new Result(sort);
    }

    /**
     * 菜单权限管理查询
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "菜单权限管理查询")
    public Result<Page<Permission>> getAll(@RequestBody PermissionGetAllParam param) throws CoBusinessException{
        Page page =cerePlatformPermissionService.getAll(param);
        return new Result(page);
    }

}
