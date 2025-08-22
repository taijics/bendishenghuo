/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.param.admin.IndexCharts;
import com.shop.cereshop.admin.param.admin.IndexStats;
import com.shop.cereshop.admin.service.admin.AdminService;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 统计模块
 */
@RestController
@RequestMapping("index")
@Slf4j(topic = "IndexController")
@Api(value = "统计模块", tags = "统计模块")
public class IndexController {

    @Autowired
    private AdminService adminService;

    /**
     * 查询平台统计数据
     *
     * @return
     */
    @PostMapping(value = "indexStats")
    @ApiOperation(value = "查询平台首页统计数据(新增用户、浏览量、访客数、店铺数)")
    public Result<IndexStats> indexStats() {
        IndexStats stats = adminService.indexStats();
        return new Result<>(stats);
    }

    /**
     * 查询平台首页统计图表
     *
     * @return
     */
    @PostMapping(value = "indexCharts")
    @NoRepeatSubmit
    @ApiOperation(value = "查询平台首页统计图表(订单金额、订单数)")
    public Result<IndexCharts> indexCharts() {
        IndexCharts charts = adminService.indexCharts();
        return new Result<>(charts);
    }

}
