/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.param.brand.BrandGetAllParam;
import com.shop.cereshop.admin.param.brand.BrandParam;
import com.shop.cereshop.admin.service.brand.BrandService;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 品牌管理
 */
@RestController
@RequestMapping("brand")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "BrandController")
@Api(value = "品牌管理模块", tags = "品牌管理模块")
public class BrandController {

    @Autowired
    private BrandService brandService;

    /**
     * 品牌管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "品牌管理查询")
    public Result<Page<Brand>> getAll(@RequestBody BrandGetAllParam param) throws CoBusinessException{
        Page<Brand> page = brandService.getAll(param);
        return new Result(page);
    }

    /**
     * 品牌详情查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "品牌详情查询")
    public Result<Brand> getById(@RequestBody BrandParam param) throws CoBusinessException{
        Brand brand = brandService.getById(param.getId());
        return new Result(brand);
    }

    /**
     * 新增品牌
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "新增品牌")
    @NoRepeatWebLog
    public Result<Integer> save(@RequestBody BrandParam param) throws CoBusinessException{
        return new Result(brandService.save(param));
    }

    /**
     * 更新品牌
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "更新品牌")
    @NoRepeatWebLog
    public Result update(@RequestBody BrandParam param) throws CoBusinessException{
        return new Result(brandService.update(param));
    }

    /**
     * 删除品牌
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除品牌")
    @NoRepeatWebLog
    public Result<Integer> delete(@RequestBody BrandParam param) throws CoBusinessException{
        return new Result(brandService.delete(param.getId()));
    }

}
