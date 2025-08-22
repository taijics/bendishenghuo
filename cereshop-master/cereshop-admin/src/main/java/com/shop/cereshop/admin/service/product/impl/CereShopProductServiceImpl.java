/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.product.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.brand.BrandDAO;
import com.shop.cereshop.admin.dao.product.CereShopProductDAO;
import com.shop.cereshop.admin.page.product.*;
import com.shop.cereshop.admin.param.product.CanvasAdminProductParam;
import com.shop.cereshop.admin.param.product.ProductGetAllParam;
import com.shop.cereshop.admin.redis.service.api.StringRedisService;
import com.shop.cereshop.admin.service.log.CerePlatformLogService;
import com.shop.cereshop.admin.service.order.CereShopOrderService;
import com.shop.cereshop.admin.service.product.CereProductImageService;
import com.shop.cereshop.admin.service.product.CereProductSkuService;
import com.shop.cereshop.admin.service.product.CereShopProductService;
import com.shop.cereshop.commons.cache.constants.CacheKeyConstants;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.RefreshSkuRealInfoSourceEnum;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.express.HttpResult;
import com.shop.cereshop.commons.domain.product.CereProductSku;
import com.shop.cereshop.commons.domain.product.CereShopProduct;
import com.shop.cereshop.commons.domain.product.CereSkuName;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.ProjectInvokeUtil;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CereShopProductServiceImpl implements CereShopProductService {

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private CereShopProductDAO cereShopProductDAO;

    @Autowired
    private CereProductSkuService cereProductSkuService;

    @Autowired
    private CereProductImageService cereProductImageService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private ProjectInvokeUtil projectInvokeUtil;

    @Autowired
    private BrandDAO brandDAO;

    @Autowired
    private CereShopOrderService cereShopOrderService;

    @Override
    public Page getProducts(CanvasAdminProductParam param) throws CoBusinessException,Exception {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CanvasProduct> list=null;
        if(IntegerEnum.CANVAS_ACTIVITY_GROUP_WORK.getCode().equals(param.getType())){
            list=cereShopProductDAO.getGroupWorkProducts(param);
        }else if(IntegerEnum.CANVAS_ACTIVITY_SECKILL.getCode().equals(param.getType())){
            list=cereShopProductDAO.getSeckillProducts(param);
        }else if(IntegerEnum.CANVAS_ACTIVITY_DISCOUNT.getCode().equals(param.getType())){
            list=cereShopProductDAO.getDiscountProducts(param);
        }else {
            list=cereShopProductDAO.getProducts(param);
        }
        if(!EmptyUtils.isEmpty(list)){
            for (CanvasProduct product : list) {
                if(IntegerEnum.COUPON_STATE_START.getCode().equals(product.getState())){
                    //活动进行中
                    product.setIfEnable(IntegerEnum.NO.getCode());
                    //设置秒杀活动倒计时
                    product.setTime(TimeUtils.getCountDownByTime(TimeUtils.yyMMddHHmmss(),product.getEndTime()));
                }else if(IntegerEnum.COUPON_STATE_READY.getCode().equals(product.getState())){
                    if(IntegerEnum.ENABLE_START.getCode().equals(product.getIfEnable())
                            &&!EmptyUtils.isEmpty(product.getEnableTime())){
                        //如果开启活动预热,计算预热几小时前的时间
                        String enableTime= TimeUtils.headDate(product.getStartTime(),product.getEnableTime());
                        //判断当前时间是否处于预热时间和活动开始时间之间
                        if(TimeUtils.isBelong(enableTime,product.getStartTime())){
                            //如果处于,需要展示预热信息
                            product.setIfEnable(IntegerEnum.YES.getCode());
                        }
                    }
                }
            }
        }
        PageInfo<CanvasProduct> pageInfo=new PageInfo<>(list);
        return new Page(pageInfo.getList(),pageInfo.getTotal());
    }

    @Override
    public Page getShops(CanvasAdminProductParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CanvasShop> list=cereShopProductDAO.getShops(param);
        PageInfo<CanvasShop> pageInfo=new PageInfo<>(list);
        return new Page(pageInfo.getList(),pageInfo.getTotal());
    }

    @Override
    public Page getAll(ProductGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ShopProduct> list=cereShopProductDAO.getAll(param);
        PageInfo<ShopProduct> pageInfo=new PageInfo<>(list);
        return new Page(pageInfo.getList(),pageInfo.getTotal());
    }

    @Override
    public ProductDetail getById(Long productId) throws CoBusinessException {
        //查询商品信息
        ProductDetail detail=cereShopProductDAO.getById(productId);
        //查询商品图片信息
        List<String> images=cereProductImageService.findByProductId(productId);
        //查询规格信息
        List<Sku> skus=cereProductSkuService.findByProductId(productId);
        //查询规格名数据
        List<SkuNameParam> names = cereProductSkuService.findNameByProductId(productId);
        if(!EmptyUtils.isEmpty(names)){
            if(!EmptyUtils.isEmpty(names.get(0).getSkuName())){
                //多款式
                names.forEach(a -> a.setValues(cereProductSkuService.findByName(a.getSkuName(),productId)));
            }else {
                //单款式,查询规格值数据
                CereSkuName value = cereProductSkuService.findValueByProductId(productId);
                if(value!=null){
                    List<SkuValueParam> values=new ArrayList<>();
                    SkuValueParam skuValueParam=new SkuValueParam();
                    skuValueParam.setValueCode(value.getValueCode());
                    skuValueParam.setSkuValue(value.getSkuValue());
                    skuValueParam.setImage(value.getImage());
                    values.add(skuValueParam);
                    names.get(0).setValues(values);
                }
            }
        }
        //封装规格里面的规格名和值级别数据
        skus.forEach(sku -> sku.setSkuAttrCodeDTOList(cereProductSkuService.findBySkuId(sku.getSkuId())));
        detail.setImages(EmptyUtils.getImages(images));
        detail.setSkus(skus);
        detail.setNames(names);
        return detail;
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public boolean examine(ProductExamineParam param, CerePlatformUser user) throws CoBusinessException {
        String time =TimeUtils.yyMMddHHmmss();
        CereShopProduct cereShopProduct=new CereShopProduct();
        cereShopProduct.setProductId(param.getProductId());
        cereShopProduct.setShelveState(param.getShelveState());
        cereShopProduct.setReject(param.getReject());
        cereShopProduct.setUpdateTime(time);
        boolean ret = false;
        String describe="";
        if(IntegerEnum.PRODUCT_EXAMINE_YES.getCode().equals(param.getShelveState())){
            describe="审核通过该商品";
            //更新商品库存缓存
            updateProductStock(cereShopProduct.getProductId());
            ret = true;
        } else {
            describe="驳回该商品";
        }
        cereShopProductDAO.updateByPrimaryKeySelective(cereShopProduct);
        //新增日志
        cerePlatformLogService.addLog(user,"商品管理","平台端操作",describe,String.valueOf(cereShopProduct.getProductId()),time);
        return ret;
    }

    @Override
    public void setFictitious(ProductUpdateParam param, CerePlatformUser user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        HttpResult result = projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), null,
                RefreshSkuRealInfoSourceEnum.EDIT_FICTITIOUS_NUMBER, param.getFictitiousNumber());
        if (result.getStatus() == 200) {
            CereShopProduct cereShopProduct=new CereShopProduct();
            cereShopProduct.setProductId(param.getProductId());
            cereShopProduct.setFictitiousNumber(param.getFictitiousNumber());
            cereShopProduct.setUpdateTime(time);
            cereShopProductDAO.updateByPrimaryKeySelective(cereShopProduct);
            //新增日志
            cerePlatformLogService.addLog(user,"商品管理","平台端操作","设置虚拟销量",String.valueOf(cereShopProduct.getProductId()),time);
        } else {
            throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
        }
    }

    @Override
    public void forced(ProductUpdateParam param, CerePlatformUser user) throws CoBusinessException {
        String time =TimeUtils.yyMMddHHmmss();
        CereShopProduct cereShopProduct=new CereShopProduct();
        cereShopProduct.setProductId(param.getProductId());
        cereShopProduct.setShelveState(IntegerEnum.PRODUCT_SHELVSTATE_FORCED.getCode());
        cereShopProduct.setUpdateTime(time);
        cereShopProductDAO.updateByPrimaryKeySelective(cereShopProduct);
        //清除缓存
        triggerCacheUpdate(param.getProductId());
        //刷新实时信息
        projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), RefreshSkuRealInfoSourceEnum.PUT_OFF_SHELVE);
        //新增日志
        cerePlatformLogService.addLog(user,"商品管理","平台端操作","强制下架",String.valueOf(cereShopProduct.getProductId()),time);
    }

    @Override
    public void unShelveByShopId(Long shopId, CerePlatformUser user) throws CoBusinessException {
        String time =TimeUtils.yyMMddHHmmss();
        cereShopProductDAO.unShelveByShopId(shopId);
        List<Long> productIdList = cereShopProductDAO.findProudctIdListByShopId(shopId);
        for (Long productId:productIdList) {
            triggerCacheUpdate(productId);
        }
        //新增日志
        cerePlatformLogService.addLog(user,"商品管理","平台端操作","禁用店铺导致商品下架",String.valueOf(shopId),time);
    }

    @Override
    public void triggerCacheUpdate(Long productId) {
        if (productId == null || productId <= 0) {
            return;
        }
        List<Sku> skuList = cereProductSkuService.findByProductId(productId);
        for (Sku sku:skuList) {
            String key = CacheKeyConstants.SKU_CACHE_PREFIX + "_" + productId + "_" + sku.getSkuId();
            stringRedisService.delete(key);
        }
    }

    /**
     * 更新商品的活动库存
     * @param productId
     * @param activityType
     * @param activityStatus
     * @param activityStock
     * @param millSeconds
     */
    @Override
    public void updateActivityProductStock(Long productId, Integer activityType, Integer activityStatus, Integer activityStock, Integer totalStock, long millSeconds) {
        String activityProductStockKey = CacheKeyConstants.ACTIVITY_PRODUCT_STOCK_PREFIX + activityType + "_" + productId;
        String activityProductTotalStockKey = CacheKeyConstants.ACTIVITY_PRODUCT_TOTAL_STOCK_PREFIX + activityType + "_" + productId;
        if (IntegerEnum.ACTIVITY_START.getCode().equals(activityStatus)) {
            stringRedisService.set(activityProductStockKey, activityStock, millSeconds);
            stringRedisService.set(activityProductTotalStockKey, totalStock, millSeconds);
        } else {
            stringRedisService.delete(activityProductStockKey);
            stringRedisService.delete(activityProductTotalStockKey);
        }
    }

    @Override
    public List<ProductExportDTO> getExportList(ProductGetAllParam param) {
        List<ShopProduct> list = cereShopProductDAO.getAll(param);
        List<ProductExportDTO> result = new ArrayList<>();
        List<Long> brandIdList = list.stream().filter(obj -> obj.getBrandId() != null).map(ShopProduct::getBrandId).distinct().collect(Collectors.toList());
        Map<Long, String> brandMap = new HashMap<>();
        if (CollectionUtils.isNotEmpty(brandIdList)) {
            brandMap = brandDAO.selectBatchIds(brandIdList).stream().collect(Collectors.toMap(Brand::getId, Brand::getBrandName));
        }
        for (ShopProduct sp:list) {
            List<CereSkuName> skuNameList = cereShopProductDAO.findSkuNameListByProductId(sp.getProductId());
            Map<Long, List<CereSkuName>> skuNameMap = skuNameList.stream().collect(Collectors.groupingBy(CereSkuName::getSkuId));
            List<Long> skuIdList = new ArrayList<>(skuNameMap.keySet());
            if (skuIdList.size() == 0) {
                continue;
            }
            List<CereProductSku> skuList = cereProductSkuService.selectListBySkuIdList(skuIdList);
            Map<Long, CereProductSku> skuMap = skuList.stream().collect(Collectors.toMap(CereProductSku::getSkuId, Function.identity()));
            Map<Long, Integer> salesVolumeMap = cereShopOrderService.selectSalesVolumeBySkuIdList(skuIdList);
            String brandName = null;
            if (sp.getBrandId() != null) {
                brandName = brandMap.get(sp.getBrandId());
            }
            for (Long skuId:skuNameMap.keySet()) {
                ProductExportDTO dto = new ProductExportDTO();
                dto.setProductId(sp.getProductId());
                dto.setProductName(sp.getProductName());
                dto.setOriginalPrice(skuMap.get(skuId).getOriginalPrice());
                dto.setPrice(skuMap.get(skuId).getPrice());
                String shelveState = "已上架";
                if (IntegerEnum.PRODUCT_EXAMINE_STAY.getCode().equals(sp.getShelveState())) {
                    shelveState = "审核中";
                } else if (IntegerEnum.PRODUCT_EXAMINE_NO.getCode().equals(sp.getShelveState())) {
                    shelveState = "驳回";
                } else if (IntegerEnum.PRODUCT_SHELVSTATE_FORCED.getCode().equals(sp.getShelveState())) {
                    shelveState = "已下架";
                }
                dto.setShelveState(shelveState);
                dto.setSalesVolume(salesVolumeMap.get(skuId));
                dto.setStockNumber(skuMap.get(skuId).getStockNumber());
                dto.setSkuName(skuNameMap.get(skuId).stream().map(obj -> obj.getSkuName() + " " + obj.getSkuValue()).collect(Collectors.joining("\n")));
                dto.setBrandName(brandName);
                dto.setSKU(skuMap.get(skuId).getSKU());
                result.add(dto);
            }
        }
        return result;
    }

    /**
     * 更新商品库存
     * @param productId
     */
    private void updateProductStock(Long productId) {
        List<Sku> skuList = cereProductSkuService.findByProductId(productId);
        for (Sku sku:skuList) {
            String skuStockKey = CacheKeyConstants.SKU_STOCK_PREFIX + sku.getSkuId();
            stringRedisService.set(skuStockKey, sku.getStockNumber());

            String skuTotalStockKey = CacheKeyConstants.SKU_TOTAL_STOCK_PREFIX + sku.getSkuId();
            stringRedisService.set(skuTotalStockKey, sku.getTotal());
        }
    }
}
