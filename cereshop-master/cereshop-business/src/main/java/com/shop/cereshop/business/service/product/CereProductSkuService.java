/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.product;

import com.shop.cereshop.business.page.product.Sku;
import com.shop.cereshop.business.page.tool.ToolProduct;
import com.shop.cereshop.commons.domain.product.CereProductSku;
import com.shop.cereshop.commons.exception.CoBusinessException;

import java.util.List;

public interface CereProductSkuService {
    void update(CereProductSku cereProductSku) throws CoBusinessException;

    void insertBatch(List<CereProductSku> adds) throws CoBusinessException;

    void deleteByIds(List<Long> ids) throws CoBusinessException;

    void deleteByProductId(Long productId) throws CoBusinessException;

    List<Sku> findByProductId(Long productId);

    Integer findVolumeByProductId(Long productId);

    void insert(CereProductSku cereProductSku) throws CoBusinessException;

    int findStockNumber(Long skuId);

    List<ToolProduct> getToolSkus(Long productId);

    List<CereProductSku> findStockNumberByOrderId(Long orderId);

    List<CereProductSku> selectListBySkuIdList(List<Long> skuIdList);

    int findStockNumberBySkuId(Long skuId);

    void updateBatchSkus(List<CereProductSku> productSkus);

    List<CereProductSku> selectStockNumberProductIdList(List<Long> productIdList);
}
