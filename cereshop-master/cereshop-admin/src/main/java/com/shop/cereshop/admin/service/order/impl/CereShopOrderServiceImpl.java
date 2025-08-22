/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.order.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.order.CereShopOrderDAO;
import com.shop.cereshop.admin.page.order.ShopOrder;
import com.shop.cereshop.admin.page.product.Product;
import com.shop.cereshop.admin.param.order.OrderGetAllParam;
import com.shop.cereshop.admin.service.order.CereShopOrderService;
import com.shop.cereshop.admin.utils.EncodeUtil;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.order.CereShopOrder;
import com.shop.cereshop.commons.domain.product.CereProductSku;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EmptyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CereShopOrderServiceImpl implements CereShopOrderService {

    @Autowired
    private CereShopOrderDAO cereShopOrderDAO;

    @Autowired
    private EncodeUtil encodeUtil;

    @Override
    public void updateAfterState(CereShopOrder cereShopOrder) throws CoBusinessException {
        cereShopOrderDAO.updateAfterState(cereShopOrder);
    }

    @Override
    public void insert(CereShopOrder order) throws CoBusinessException {
        cereShopOrderDAO.insert(order);
    }

    @Override
    public void updateState(CereShopOrder cereShopOrder) throws CoBusinessException {
        cereShopOrderDAO.updateState(cereShopOrder);
    }

    @Override
    public void updateBatchStock(List<CereProductSku> skus) throws CoBusinessException {
        cereShopOrderDAO.updateBatchStock(skus);
    }

    @Override
    public Page getAll(OrderGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ShopOrder> list=cereShopOrderDAO.getAll(param);
        for(ShopOrder order:list) {
            order.setCustomerName(encodeUtil.encodeInfo(order.getCustomerName()));
            order.setReceiveName(encodeUtil.encodeInfo(order.getReceiveName()));
            order.setReceivePhone(encodeUtil.encodePhone(order.getReceivePhone()));
            List<Product> products=cereShopOrderDAO.getProducts(order.getOrderId());
            order.setProducts(products);
            order.setTotal(cereShopOrderDAO.getOrderTotals(order.getBuyerUserId()));
            if(order.getPaymentState()==0){
                order.setPaymentMode(null);
            }
        }
        PageInfo<ShopOrder> pageInfo=new PageInfo<>(list);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public ShopOrder getById(Long orderId) throws CoBusinessException {
        ShopOrder shopOrder=cereShopOrderDAO.getById(orderId);
        if(shopOrder!=null){
            //设置详细地址
            shopOrder.setReceiveAdress(encodeUtil.encodeInfo(shopOrder.getReceiveAdress()+" "+shopOrder.getAddress()));
            //根据买家账户查询下单总数
            shopOrder.setTotal(cereShopOrderDAO.getOrderTotals(shopOrder.getBuyerUserId()));
            //查询商品信息
            List<Product> products=cereShopOrderDAO.getProducts(orderId);
            if(!EmptyUtils.isEmpty(products)){
                //封装规格属性数据
                products.forEach(product -> product.setSkuDetails(cereShopOrderDAO.findSkuAttribute(product.getOrderProductId())));
            }
            shopOrder.setProducts(products);
            shopOrder.setReceiveName(encodeUtil.encodeInfo(shopOrder.getReceiveName()));
            shopOrder.setCustomerName(encodeUtil.encodeInfo(shopOrder.getCustomerName()));
            shopOrder.setReceivePhone(encodeUtil.encodePhone(shopOrder.getReceivePhone()));
        }
        return shopOrder;
    }

    @Override
    public Map<Long, Integer> selectSalesVolumeBySkuIdList(List<Long> skuIdList) {
        List<Map<String, Object>> map = cereShopOrderDAO.selectSalesVolumeBySkuIdList(skuIdList);
        Map<Long, Integer> salesVolumeMap = new HashMap<>();
        map.forEach(item -> {
            salesVolumeMap.put(Long.parseLong(item.get("sku_id").toString()), Integer.parseInt(item.get("sales_volume").toString()));
        });
        for (Long skuId:skuIdList) {
            salesVolumeMap.putIfAbsent(skuId, 0);
        }
        return salesVolumeMap;
    }
}
