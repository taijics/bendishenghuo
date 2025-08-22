/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.page.index.HotProductDTO;
import com.shop.cereshop.business.page.index.Index;
import com.shop.cereshop.business.page.index.OrderConvertDTO;
import com.shop.cereshop.business.page.index.UserVisitDTO;
import com.shop.cereshop.business.param.index.IndexParam;
import com.shop.cereshop.business.service.shop.CerePlatformShopService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 首页概况
 */
@RestController
@RequestMapping("index")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "IndexController")
@Api(value = "首页概况", tags = "首页概况")
public class IndexController {

    @Autowired
    private CerePlatformShopService cerePlatformShopService;

    /**
     * 商户端首页概况数据查询
     * @param param
     * @return
     */
    @PostMapping(value = "index")
    @ApiOperation(value = "商户端首页概况数据查询")
    public Result<Index> index(@RequestBody IndexParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        Index index=cerePlatformShopService.index(param);
        return new Result(index);
    }

    /**
     * 导出用户访问趋势
     * @param param
     * @return
     */
    @RequestMapping(value = "exportUserVisit", method = RequestMethod.POST)
    @ApiOperation(value = "商户端首页概况数据查询")
    public void exportUserVisit(@RequestBody IndexParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        List<UserVisitDTO> visitDTOList = cerePlatformShopService.selectUserVisitForExport(param);
        log.info("visitDTOList {}", visitDTOList);
        String excelName = "用户访问统计表";
        ExcelExportUtils.exportExcel(request, response, excelName, visitDTOList, UserVisitDTO.class);
    }

    /**
     * 导出订单转换漏斗
     * @param param
     * @return
     */
    @RequestMapping(value = "exportOrderConvert", method = RequestMethod.POST)
    @ApiOperation(value = "导出订单转换漏斗")
    public void exportOrderConvert(@RequestBody IndexParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        List<OrderConvertDTO> visitDTOList = cerePlatformShopService.selectOrderConvertForExport(param);
        String excelName = "订单转化统计表";
        ExcelExportUtils.exportExcel(request, response, excelName, visitDTOList, OrderConvertDTO.class);
    }

    /**
     * 导出热卖商品
     * @param param
     * @return
     */
    @RequestMapping(value = "exportHotProducts", method = RequestMethod.POST)
    @ApiOperation(value = "导出热卖商品")
    public void exportHotProducts(@RequestBody IndexParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        List<HotProductDTO> visitDTOList = cerePlatformShopService.selectHotProductForExport(param);
        String excelName = "热卖商品统计表";
        ExcelExportUtils.exportExcel(request, response, excelName, visitDTOList, HotProductDTO.class);
    }
}
