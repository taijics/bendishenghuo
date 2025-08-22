/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.page.order.Product;
import com.shop.cereshop.business.page.order.ShopOrder;
import com.shop.cereshop.business.page.order.ShopOrderExportDTO;
import com.shop.cereshop.business.param.business.BusinessSyncToScrmParam;
import com.shop.cereshop.business.param.order.OrderDileveryParam;
import com.shop.cereshop.business.param.order.OrderGetAllParam;
import com.shop.cereshop.business.param.order.OrderGetByIdParam;
import com.shop.cereshop.business.param.order.UpdateOrderPriceParam;
import com.shop.cereshop.business.service.order.CereOrderDileverService;
import com.shop.cereshop.business.service.order.CereShopOrderService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.business.utils.ScrmSyncVerifyUtil;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.enums.OrderStateEnum;
import com.shop.cereshop.commons.enums.PaymentModeEnum;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.naming.Context;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 订单
 */
@RestController
@RequestMapping("order")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "OrderController")
@Api(value = "订单模块", tags = "订单模块")
public class OrderController {

    @Autowired
    private CereShopOrderService cereShopOrderService;

    @Autowired
    private CereOrderDileverService cereOrderDileverService;

    @Autowired
    private ScrmSyncVerifyUtil scrmSyncVerifyUtil;

    /**
     * 订单管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "订单管理查询")
    public Result<Page<ShopOrder>> getAll(@RequestBody OrderGetAllParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        Page page=cereShopOrderService.getAll(param);
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
        ShopOrder shopOrder=cereShopOrderService.getById(ContextUtil.getShopId(), param.getOrderId());
        return new Result(shopOrder);
    }

    /**
     * 发货
     * @param param
     * @return
     */
    @PostMapping(value = "dilevery")
    @NoRepeatSubmit
    @ApiOperation(value = "发货")
    @NoRepeatWebLog
    public Result dilevery(@RequestBody OrderDileveryParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderDileverService.dilevery(param,user);
        return new Result(user.getUsername(),"发货", GsonUtil.objectToGson(param));
    }

    /**
     * 订单管理导出
     * @return
     */
    @PostMapping(value = "export")
    @ApiOperation(value = "订单管理导出")
    public void export(@RequestBody OrderGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException {
        param.setShopId(ContextUtil.getShopId());
        param.setPage(1);
        param.setPageSize(10000);
        Page<ShopOrder> page = cereShopOrderService.getAll(param);
        //Map<Long, Integer> buyerUserCountMap = new HashMap<>();
        Map<Long, Integer> tmpCountMap = new HashMap<>();
        if (param.getState() != null && param.getState() == 2) {
            Map<Long, Integer> countMap = page.getList().stream().collect(Collectors.groupingBy(ShopOrder::getBuyerUserId,
                    Collectors.collectingAndThen(Collectors.toList(), List::size)));
            tmpCountMap.putAll(countMap);
        } else {
            for (ShopOrder shopOrder:page.getList()) {
                tmpCountMap.put(shopOrder.getBuyerUserId(), 1);
            }
        }
        List<ShopOrderExportDTO> list = page.getList().stream().map(s -> {
            ShopOrderExportDTO shopOrderExportDTO = new ShopOrderExportDTO();
            shopOrderExportDTO.setOrderId(s.getOrderId());
            shopOrderExportDTO.setCreateTime(s.getCreateTime());
            shopOrderExportDTO.setCustomerName(s.getCustomerName());
            shopOrderExportDTO.setNumber(s.getNumber());
            shopOrderExportDTO.setPrice(s.getPrice());
            shopOrderExportDTO.setPaymentTime(s.getPaymentTime());
            shopOrderExportDTO.setReceiveName(s.getReceiveName());
            shopOrderExportDTO.setReceiveAdress(s.getReceiveAdress() + " " + s.getAddress());
            shopOrderExportDTO.setReceivePhone(s.getReceivePhone());
            shopOrderExportDTO.setRemark(s.getRemark());
            shopOrderExportDTO.setTransactionId(s.getTransactionId());
            shopOrderExportDTO.setState(OrderStateEnum.getMsgByCode(s.getState()));
            shopOrderExportDTO.setPaymentMode(PaymentModeEnum.getMsgByCode(s.getPaymentMode()));
            if(EmptyUtils.isNotEmpty(s.getProducts())){
                //Map<Long, List<Product>> pMap = s.getProducts().stream().collect(Collectors.groupingBy(Product::getProductId));
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
            if (param.getState() != null && param.getState() == 2) {
                shopOrderExportDTO.setHistoryOrderNum(s.getTotal() - tmpCountMap.get(s.getBuyerUserId()));
                tmpCountMap.put(s.getBuyerUserId(), tmpCountMap.get(s.getBuyerUserId()) - 1);
            } else {
                shopOrderExportDTO.setHistoryOrderNum(s.getTotal() - tmpCountMap.get(s.getBuyerUserId()));
                tmpCountMap.put(s.getBuyerUserId(), tmpCountMap.get(s.getBuyerUserId()) + 1);
            }
            return shopOrderExportDTO;

        }).collect(Collectors.toList());

        //定义导出的excel名字
        String excelName = "订单列表";
        ExcelExportUtils.exportExcel(request,response,excelName,list, ShopOrderExportDTO.class);
    }

    /**
     * 同步订单列表到scrm
     * @return
     */
    @PostMapping(value = "syncOrderList")
    @ApiOperation(value = "同步订单列表到scrm")
    public Result<List<ShopOrder>> syncOrderList(@RequestBody BusinessSyncToScrmParam param) throws CoBusinessException {
        if (param == null || param.getSecret() == null || param.getPageSize() == null) {
            return new Result<>(Collections.emptyList());
        }
        scrmSyncVerifyUtil.verify(param.getShopId(), param.getSecret());
        List<ShopOrder> list=cereShopOrderService.syncOrderList(param.getShopId(), param.getLastId(), param.getPageSize());
        return new Result(list);
    }

    /**
     * 查询订单详情给scrm
     * @return
     */
    @PostMapping(value = "getOrderDetailForScrm")
    @ApiOperation(value = "查询订单详情给scrm")
    public Result<ShopOrder> getOrderDetailForScrm(@RequestBody BusinessSyncToScrmParam param) throws CoBusinessException {
        if (param == null || param.getSecret() == null) {
            return new Result<>(null);
        }
        scrmSyncVerifyUtil.verify(param.getShopId(), param.getSecret());
        ShopOrder shopOrder = cereShopOrderService.getById(param.getShopId(), param.getBusinessId());
        return new Result(shopOrder);
    }

    /**
     * 订单改价
     * @param param
     * @return
     */
    @PostMapping(value = "updateOrderPrice")
    @NoRepeatSubmit
    @ApiOperation(value = "订单改价")
    @NoRepeatWebLog
    public Result updateOrderPrice(@RequestBody UpdateOrderPriceParam param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereShopOrderService.updateOrderPrice(param,user);
        return new Result(user.getUsername(),"订单改价", GsonUtil.objectToGson(param));
    }
}
