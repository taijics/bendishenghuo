/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.page.order.ShopOrder;
import com.shop.cereshop.admin.page.order.ShopOrderExportDTO;
import com.shop.cereshop.admin.page.product.Product;
import com.shop.cereshop.admin.param.order.OrderGetAllParam;
import com.shop.cereshop.admin.param.order.OrderGetByIdParam;
import com.shop.cereshop.admin.service.order.CereShopOrderService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.enums.OrderStateEnum;
import com.shop.cereshop.commons.enums.PaymentModeEnum;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 订单管理
 */
@RestController
@RequestMapping("order")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "OrderController")
@Api(value = "订单管理", tags = "订单管理")
public class OrderController {

    @Autowired
    private CereShopOrderService cereShopOrderService;

    /**
     * 订单管理查询
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "订单管理查询")
    public Result<Page<ShopOrder>> getAll(@RequestBody OrderGetAllParam param) throws CoBusinessException {
        Page page =cereShopOrderService.getAll(param);
        return new Result(page);
    }

    /**
     * 订单详情查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "订单详情查询")
    public Result<ShopOrder> getById(@RequestBody OrderGetByIdParam param) throws CoBusinessException{
        ShopOrder shopOrder=cereShopOrderService.getById(param.getOrderId());
        return new Result(shopOrder);
    }

    /**
     * 订单管理导出
     * @return
     */
    @PostMapping(value = "export")
    @ApiOperation(value = "订单管理导出")
    public void export(@RequestBody OrderGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException {
        param.setPage(1);
        param.setPageSize(10000);
        Page<ShopOrder> page = cereShopOrderService.getAll(param);
        List<ShopOrderExportDTO> list = page.getList().stream().map(s -> {
            ShopOrderExportDTO shopOrderExportDTO = new ShopOrderExportDTO();
            shopOrderExportDTO.setOrderId(s.getOrderId());
            shopOrderExportDTO.setCreateTime(s.getCreateTime());
            shopOrderExportDTO.setCustomerName(s.getCustomerName());
            shopOrderExportDTO.setShopName(s.getShopName());
            shopOrderExportDTO.setNumber(s.getNumber());
            shopOrderExportDTO.setPrice(s.getPrice());
            shopOrderExportDTO.setPaymentTime(s.getPaymentTime());
            shopOrderExportDTO.setReceiveName(s.getReceiveName());
            shopOrderExportDTO.setReceiveAdress(s.getReceiveAdress());
            shopOrderExportDTO.setReceivePhone(s.getReceivePhone());
            shopOrderExportDTO.setRemark(s.getRemark());
            shopOrderExportDTO.setTransactionId(s.getTransactionId());
            shopOrderExportDTO.setState(OrderStateEnum.getMsgByCode(s.getState()));
            shopOrderExportDTO.setPaymentMode(PaymentModeEnum.getMsgByCode(s.getPaymentMode()));
            if(EmptyUtils.isNotEmpty(s.getProducts())){
                StringBuilder builder = new StringBuilder();
                for (Product p:s.getProducts()) {
                    builder.append(p.getProductName())
                            .append(" ").append(p.getNumber())
                            .append(StringUtils.isNotBlank(p.getBrandName()) ? " " + p.getBrandName() : "")
                            .append(StringUtils.isNotBlank(p.getSKU()) ? " " + p.getSKU() : "")
                            .append("\n");
                }
                //String productNames=s.getProducts().stream().map(Product::getProductName).collect(Collectors.joining("\n"));
                builder.deleteCharAt(builder.length() - 1);
                shopOrderExportDTO.setProductNames(builder.toString());
            }
            shopOrderExportDTO.setHistoryOrderNum(s.getTotal());
            return shopOrderExportDTO;

        }).collect(Collectors.toList());
        //定义导出的excel名字
        String excelName = "订单列表";
        ExcelExportUtils.exportExcel(request,response,excelName,list, ShopOrderExportDTO.class);
    }

}
