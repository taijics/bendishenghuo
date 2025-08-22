/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.page.credit.CereCreditRecordPage;
import com.shop.cereshop.admin.page.shop.ShopComment;
import com.shop.cereshop.admin.param.comment.CommentGetAllParam;
import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.admin.service.credit.CereCreditRecordService;
import com.shop.cereshop.admin.service.shop.CereShopCommentService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.credit.CereCreditRecord;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 积分记录
 */
@RestController
@RequestMapping("creditRecord")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "CreditRecordController")
@Api(value = "积分记录模块", tags = "积分记录模块")
public class CreditRecordController {

    @Autowired
    private CereCreditRecordService cereCreditRecordService;

    /**
     * 积分记录
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "积分记录")
    public Result<Page<CereCreditRecordPage>> getAll(@RequestBody CreditRecordGetAllParam param) throws CoBusinessException {
        Page page=cereCreditRecordService.getAll(param);
        return new Result(page);
    }

}
