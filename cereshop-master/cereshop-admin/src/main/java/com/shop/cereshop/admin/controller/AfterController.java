/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.page.after.*;
import com.shop.cereshop.admin.page.order.ShopOrderExportDTO;
import com.shop.cereshop.admin.param.after.*;
import com.shop.cereshop.admin.service.after.CereOrderAfterService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.enums.OrderStateEnum;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 售后管理
 */
@RestController
@RequestMapping("after")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "AfterController")
@Api(value = "售后管理模块", tags = "售后管理模块")
public class AfterController {

    @Autowired
    private CereOrderAfterService cereOrderAfterService;

    /**
     * 售后管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "售后管理查询")
    public Result<Page<After>> getAll(@RequestBody AfterGetAllParam param) throws CoBusinessException{
        Page page=cereOrderAfterService.getAll(param);
        return new Result(page);
    }

    /**
     * 售后详情查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "售后详情查询")
    public Result<AfterDetail> getById(@RequestBody AfterGetByIdParam param) throws CoBusinessException,Exception{
        AfterDetail detail=cereOrderAfterService.getById(param.getAfterId());
        return new Result(detail);
    }

    /**
     * 物流信息查询
     * @param param
     * @return
     */
    @PostMapping(value = "getDilevery")
    @ApiOperation(value = "物流信息查询")
    public Result<List<AfterDilevery>> getDilevery(@RequestBody AfterGetDileveryParam param) throws CoBusinessException,Exception{
        List<AfterDilevery> dileveries=cereOrderAfterService.getDilevery(param);
        return new Result(dileveries);
    }

    /**
     * 买家信息查询
     * @param param
     * @return
     */
    @PostMapping(value = "getBuyer")
    @ApiOperation(value = "买家信息查询")
    public Result<AfterBuyer> getBuyer(@RequestBody AfterGetBuyerParam param) throws CoBusinessException{
        AfterBuyer buyer=cereOrderAfterService.getBuyer(param.getBuyerUserId());
        return new Result(buyer);
    }

    /**
     * 售后处理
     * @param param
     * @return
     */
    @PostMapping(value = "handle")
    @NoRepeatSubmit
    @ApiOperation(value = "售后处理")
    @NoRepeatWebLog
    public Result handle(@RequestBody AfterhandleParam param,
                         HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereOrderAfterService.handle(param,user);
        return new Result(user.getUsername(),"售后处理", GsonUtil.objectToGson(param));
    }

    /**
     * 售后管理导出
     * @param param
     * @return
     */
    @PostMapping(value = "export")
    @ApiOperation(value = "售后管理导出")
    public void export(@RequestBody AfterGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        Page<After> page=cereOrderAfterService.getAll(param);
        List<AfterExportDTO> list = page.getList().stream().map(s -> {
            AfterExportDTO afterExportDTO = new AfterExportDTO();
            afterExportDTO.setAfterType(s.getAfterType());
            afterExportDTO.setAfterFormid(s.getAfterFormid());
            afterExportDTO.setAfterProductNames(s.getAfterProductNames());
            afterExportDTO.setExpress(s.getExpress());
            afterExportDTO.setCustomerName(s.getCustomerName());
            afterExportDTO.setOrderId(s.getOrderId());
            afterExportDTO.setNumber(s.getNumber());
            afterExportDTO.setPaymentTime(s.getPaymentTime());
            afterExportDTO.setDeliverFormid(s.getDeliverFormid());
            afterExportDTO.setPlatformAfterTime(s.getPlatformAfterTime());
            afterExportDTO.setShopName(s.getShopName());
            afterExportDTO.setShopCode(s.getShopCode());
            afterExportDTO.setOrderState(OrderStateEnum.getMsgByCode(s.getOrderState()));
            afterExportDTO.setRefundMoney(s.getRefundMoney());
            return afterExportDTO;
        }).collect(Collectors.toList());
        //定义导出的excel名字
        String excelName = "售后订单列表";
        ExcelExportUtils.exportExcel(request,response,excelName,list, AfterExportDTO.class);
    }
}
