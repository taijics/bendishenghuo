/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.service.credit.CereCreditSignSettingService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.credit.CereCreditSignSetting;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 积分签到配置
 */
@RestController
@RequestMapping("creditSignSetting")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "CreditSignSettingController")
@Api(value = "积分签到配置", tags = "积分签到配置")
public class CreditSignSettingController {

    @Autowired
    private CereCreditSignSettingService cereCreditSignSettingService;

    /**
     * 积分签到配置
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "积分签到配置")
    public Result<Page<CereCreditSignSetting>> getAll(@RequestBody PageParam param) throws CoBusinessException {
        Page page=cereCreditSignSettingService.getAll(param);
        return new Result(page);
    }

    /**
     * 新增积分签到配置
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @ApiOperation(value = "新增积分签到配置")
    public Result<Integer> save(@RequestBody CereCreditSignSetting param) throws CoBusinessException {
        int result = cereCreditSignSettingService.save(param);
        return new Result(result);
    }

    /**
     * 修改积分签到配置
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @ApiOperation(value = "修改积分签到配置")
    public Result<Integer> update(@RequestBody CereCreditSignSetting param) throws CoBusinessException {
        int result=cereCreditSignSettingService.update(param);
        return new Result(result);
    }

    /**
     * 删除积分签到配置
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @ApiOperation(value = "删除积分签到配置")
    public Result<Integer> delete(@RequestBody CereCreditSignSetting param) throws CoBusinessException {
        int result=cereCreditSignSettingService.delete(param.getId());
        return new Result(result);
    }

}
