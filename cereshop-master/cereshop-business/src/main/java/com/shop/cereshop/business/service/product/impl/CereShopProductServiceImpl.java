/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.product.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.brand.BrandDAO;
import com.shop.cereshop.business.dao.product.CereProductClassifyDAO;
import com.shop.cereshop.business.dao.product.CereShopProductDAO;
import com.shop.cereshop.business.page.canvas.CanvasProduct;
import com.shop.cereshop.business.page.canvas.CanvasProductParam;
import com.shop.cereshop.business.page.canvas.CanvasShop;
import com.shop.cereshop.business.page.member.ProductMember;
import com.shop.cereshop.business.page.product.ProductExportDTO;
import com.shop.cereshop.business.page.product.ShopProduct;
import com.shop.cereshop.business.page.product.Sku;
import com.shop.cereshop.business.page.product.SyncShopProduct;
import com.shop.cereshop.business.param.product.*;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.checkImport.ImportCheckService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.business.service.order.CereShopOrderService;
import com.shop.cereshop.business.service.product.*;
import com.shop.cereshop.business.service.tool.CereShopCouponDetailService;
import com.shop.cereshop.business.service.tool.CereShopCouponService;
import com.shop.cereshop.business.service.tool.CereShopDiscountDetailService;
import com.shop.cereshop.business.service.tool.CereShopSeckillDetailService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.cache.constants.CacheKeyConstants;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.RefreshSkuRealInfoSourceEnum;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.image.Image;
import com.shop.cereshop.commons.domain.product.*;
import com.shop.cereshop.commons.domain.tool.CereShopCoupon;
import com.shop.cereshop.commons.domain.tool.CereShopCouponDetail;
import com.shop.cereshop.commons.domain.tool.CereShopDiscountDetail;
import com.shop.cereshop.commons.domain.tool.CereShopSeckillDetail;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.ImportExeclUtil;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.ProjectInvokeUtil;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@Service
public class CereShopProductServiceImpl implements CereShopProductService {

    @Autowired
    private CereShopProductDAO cereShopProductDAO;

    @Autowired
    private CereProductImageService cereProductImageService;

    @Autowired
    private CereProductSkuService cereProductSkuService;

    @Autowired
    private ImportCheckService importCheckService;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private CereSkuNameService cereSkuNameService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private CereShopCouponService cereShopCouponService;

    @Autowired
    private CereShopCouponDetailService cereShopCouponDetailService;

    @Autowired
    private CereProductMemberService cereProductMemberService;

    @Autowired
    private CereShopSeckillDetailService cereShopSeckillDetailService;

    @Autowired
    private CereShopDiscountDetailService cereShopDiscountDetailService;

    @Autowired
    private ProjectInvokeUtil projectInvokeUtil;

    @Autowired
    private CereShopOrderService cereShopOrderService;

    @Autowired
    private BrandDAO brandDAO;

    @Autowired
    private CereProductClassifyDAO cereProductClassifyDAO;

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void save(ProductSaveParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        //新增商品数据
        CereShopProduct cereShopProduct = new CereShopProduct();
        cereShopProduct.setProductName(param.getProductName());
        cereShopProduct.setProductBrief(param.getProductBrief());
        cereShopProduct.setProductText(param.getProductText());
        cereShopProduct.setClassifyId(param.getClassifyId());
        setClassify(cereShopProduct);
        cereShopProduct.setShopGroupId(param.getShopGroupId());
        cereShopProduct.setSupplierId(param.getSupplierId());
        cereShopProduct.setSupplierName(param.getSupplierName());
        cereShopProduct.setIfLogistics(Integer.parseInt(param.getIfLogistics()));
        cereShopProduct.setIfOversold(Integer.parseInt(param.getIfOversold()));
        cereShopProduct.setIfHuabei(Integer.parseInt(param.getIfHuabei()));
        cereShopProduct.setIfCredit(param.getIfCredit());
        cereShopProduct.setCreditLimit(param.getCreditLimit());
        cereShopProduct.setBrandId(param.getBrandId());
        if (IntegerEnum.PRODUCT_EXAMINE_YES.getCode().equals(Integer.parseInt(param.getShelveState()))) {
            //如果是已上架,修改状态为审核中
            cereShopProduct.setShelveState(IntegerEnum.PRODUCT_EXAMINE_STAY.getCode());
        } else {
            //已下架
            cereShopProduct.setShelveState(Integer.parseInt(param.getShelveState()));
        }
        cereShopProduct.setCreateTime(time);
        cereShopProduct.setUpdateTime(time);
        cereShopProduct.setShopId(param.getShopId());
        cereShopProductDAO.insert(cereShopProduct);
        if (!EmptyUtils.isEmpty(param.getImages())) {
            List<CereProductImage> list = new ArrayList<>();
            //新增商品图片数据
            Stream.iterate(0, i -> i + 1).limit(param.getImages().size()).forEach(i -> {
                CereProductImage cereProductImage = new CereProductImage();
                cereProductImage.setProductId(cereShopProduct.getProductId());
                cereProductImage.setProductImage(param.getImages().get(i).getImgPath());
                cereProductImage.setSort(i + 1);
                list.add(cereProductImage);
            });
            cereProductImageService.insertBatch(list);
        }
        //封装规格名和规格值数据到map中
        Map<String, NameValue> map = new HashMap<>();
        param.getNames().forEach(a -> {
            a.getValues().forEach(value -> {
                NameValue nameValue = new NameValue();
                nameValue.setSkuName(a.getSkuName());
                nameValue.setSkuValue(value.getSkuValue());
                nameValue.setImage(value.getImage());
                if (a.getNeedImg()) {
                    nameValue.setNeed(IntegerEnum.YES.getCode());
                } else {
                    nameValue.setNeed(IntegerEnum.NO.getCode());
                }
                map.put(a.getCode() + "-" + value.getValueCode(), nameValue);
            });
        });
        //查询当前是否有全部商品且进行中状态的优惠券
        List<CereShopCoupon> coupons = cereShopCouponService.findAllByShopId(cereShopProduct.getShopId());
        if (!EmptyUtils.isEmpty(coupons)) {
            //如果有,将新增的商品插入到优惠券商品明细表中
            List<CereShopCouponDetail> details = coupons.stream().map(coupon -> {
                CereShopCouponDetail detail = new CereShopCouponDetail();
                detail.setProductId(cereShopProduct.getProductId());
                detail.setShopCouponId(coupon.getShopCouponId());
                return detail;
            }).collect(Collectors.toList());
            //批量插入数据
            cereShopCouponDetailService.insertBatch(details);
        }
        //新增规格数据
        saveSkus(param.getSkus(), cereShopProduct, null, time, map, param.getNames());
        //新增日志
        cerePlatformLogService.addLog(user, "商品管理", "商户端操作", "添加商品", cereShopProduct.getProductId(), time);
    }

    /**
     * 设置商品分类
     *
     * @param cereShopProduct
     * @throws CoBusinessException
     */
    private void setClassify(CereShopProduct cereShopProduct) throws CoBusinessException {
        CereProductClassify classify = cereProductClassifyDAO.selectByPrimaryKey(cereShopProduct.getClassifyId());
        if (classify != null) {
            if (classify.getClassifyLevel() == 1) {
                cereShopProduct.setClassifyId1(classify.getClassifyId());
            } else if (classify.getClassifyLevel() == 2) {
                cereShopProduct.setClassifyId1(classify.getClassifyPid());
                cereShopProduct.setClassifyId2(classify.getClassifyId());
            } else {
                String hierarchy = classify.getClassifyLevelHierarchy();
                if (hierarchy != null) {
                    if (hierarchy.startsWith("/")) {
                        hierarchy = hierarchy.substring(1);
                    }
                    String[] arr = hierarchy.split("/");
                    if (arr.length == 3) {
                        cereShopProduct.setClassifyId1(Long.parseLong(arr[0]));
                    } else {
                        throw new CoBusinessException("商品分类异常");
                    }
                } else {
                    throw new CoBusinessException("商品分类异常");
                }

                cereShopProduct.setClassifyId2(classify.getClassifyPid());
                cereShopProduct.setClassifyId3(classify.getClassifyId());
            }
        }
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void update(ProductUpdateParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        //更新商品数据
        CereShopProduct cereShopProduct = new CereShopProduct();
        cereShopProduct.setProductId(param.getProductId());
        cereShopProduct.setProductName(param.getProductName());
        cereShopProduct.setProductBrief(param.getProductBrief());
        cereShopProduct.setProductText(param.getProductText());
        cereShopProduct.setClassifyId(param.getClassifyId());
        setClassify(cereShopProduct);
        cereShopProduct.setShopGroupId(param.getShopGroupId());
        cereShopProduct.setSupplierId(param.getSupplierId());
        cereShopProduct.setSupplierName(param.getSupplierName());
        cereShopProduct.setIfLogistics(param.getIfLogistics());
        cereShopProduct.setIfOversold(param.getIfOversold());
        cereShopProduct.setIfHuabei(param.getIfHuabei());
        cereShopProduct.setIfCredit(param.getIfCredit());
        cereShopProduct.setCreditLimit(param.getCreditLimit());
        cereShopProduct.setBrandId(param.getBrandId());
        if (IntegerEnum.PRODUCT_EXAMINE_YES.getCode().equals(param.getShelveState())) {
            //如果是已上架,修改状态为审核中
            cereShopProduct.setShelveState(IntegerEnum.PRODUCT_EXAMINE_STAY.getCode());
        } else {
            //已下架
            cereShopProduct.setShelveState(param.getShelveState());
        }
        //不管是审核中，还是已下架，sku实时信息都要改成下架
        projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), null, RefreshSkuRealInfoSourceEnum.PUT_OFF_SHELVE, null);

        cereShopProduct.setUpdateTime(time);
        cereShopProduct.setShopId(param.getShopId());
        cereShopProductDAO.updateByPrimaryKeySelective(cereShopProduct);
        if (!EmptyUtils.isEmpty(param.getImages())) {
            //清空商品图片
            cereProductImageService.deleteByProductId(param.getProductId());
            List<CereProductImage> list = new ArrayList<>();
            //新增商品图片数据
            Stream.iterate(0, i -> i + 1).limit(param.getImages().size()).forEach(i -> {
                CereProductImage cereProductImage = new CereProductImage();
                cereProductImage.setProductId(cereShopProduct.getProductId());
                cereProductImage.setProductImage(param.getImages().get(i).getImgPath());
                cereProductImage.setSort(i + 1);
                list.add(cereProductImage);
            });
            cereProductImageService.insertBatch(list);
        }
        //封装规格名和规格值数据到map中
        Map<String, NameValue> map = new HashMap<>();
        param.getNames().forEach(a -> {
            a.getValues().forEach(value -> {
                NameValue nameValue = new NameValue();
                nameValue.setSkuName(a.getSkuName());
                nameValue.setSkuValue(value.getSkuValue());
                nameValue.setImage(value.getImage());
                if (a.getNeedImg()) {
                    nameValue.setNeed(IntegerEnum.YES.getCode());
                } else {
                    nameValue.setNeed(IntegerEnum.NO.getCode());
                }
                map.put(a.getCode() + "-" + value.getValueCode(), nameValue);
            });
        });
        //更新规格数据
        saveSkus(param.getSkus(), cereShopProduct, param.getDeletes(), time, map, param.getNames());
        //清除缓存
        triggerCacheUpdate(param.getProductId());
        //商品删除之后需删除购物车相关的商品
        cereShopProductDAO.deleteShopCartByProductId(param.getProductId());
        //新增日志
        cerePlatformLogService.addLog(user, "商品管理", "商户端操作", "修改商品", cereShopProduct.getProductId(), time);
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void delete(ProductDeleteParam param, CerePlatformBusiness user) throws CoBusinessException {
        //校验商品是否参与正在进行的活动
        Long productId = cereShopProductDAO.checkActivity(param.getProductId());
        if (EmptyUtils.isLongEmpty(productId)) {
            productId = cereShopProductDAO.checkGroupWork(param.getProductId());
            if (EmptyUtils.isLongEmpty(productId)) {
                productId = cereShopProductDAO.checkSeckill(param.getProductId());
                if (EmptyUtils.isLongEmpty(productId)) {
                    productId = cereShopProductDAO.checkDiscount(param.getProductId());
                    if (!EmptyUtils.isLongEmpty(productId)) {
                        throw new CoBusinessException(CoReturnFormat.PRODUCT_WITH_ACTIVITY);
                    }
                } else {
                    throw new CoBusinessException(CoReturnFormat.PRODUCT_WITH_ACTIVITY);
                }
            } else {
                throw new CoBusinessException(CoReturnFormat.PRODUCT_WITH_ACTIVITY);
            }
        } else {
            throw new CoBusinessException(CoReturnFormat.PRODUCT_WITH_ACTIVITY);
        }
        String time = TimeUtils.yyMMddHHmmss();
        //删除商品数据
        cereShopProductDAO.deleteByPrimaryKey(param.getProductId());
        //删除规格属性数据
        cereSkuNameService.deleteByProductId(param.getProductId());
        //删除规格数据
        cereProductSkuService.deleteByProductId(param.getProductId());
        //删除商品图片数据
        cereProductImageService.deleteByProductId(param.getProductId());
        //清空缓存
        triggerCacheUpdate(param.getProductId());
        //调用接口删除实时信息
        projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), null, RefreshSkuRealInfoSourceEnum.PUT_OFF_SHELVE, null);
        //新增日志
        cerePlatformLogService.addLog(user, "商品管理", "商户端操作", "删除商品", param.getProductId(), time);
    }

    @Override
    public ShopProduct getById(Long productId) throws CoBusinessException {
        //查询商品信息
        ShopProduct shopProduct = cereShopProductDAO.getById(productId);
        //查询商品图片信息
        List<String> images = cereProductImageService.findByProductId(productId);
        //查询规格信息
        List<Sku> skus = cereProductSkuService.findByProductId(productId);
        //查询规格名数据
        List<SkuNameParam> names = cereSkuNameService.findNameByProductId(productId);
        if (!EmptyUtils.isEmpty(names)) {
            if (!EmptyUtils.isEmpty(names.get(0).getSkuName())) {
                //多款式
                names.forEach(a -> a.setValues(cereSkuNameService.findByName(a.getSkuName(), productId)));
            } else {
                //单款式,查询规格值数据
                CereSkuName value = cereSkuNameService.findValueByProductId(productId);
                if (value != null) {
                    List<SkuValueParam> values = new ArrayList<>();
                    SkuValueParam skuValueParam = new SkuValueParam();
                    skuValueParam.setValueCode(value.getValueCode());
                    skuValueParam.setSkuValue(value.getSkuValue());
                    skuValueParam.setImage(value.getImage());
                    values.add(skuValueParam);
                    names.get(0).setValues(values);
                }
            }
        }
        //封装规格里面的规格名和值级别数据
        skus.forEach(sku -> sku.setSkuAttrCodeDTOList(cereSkuNameService.findBySkuId(sku.getSkuId())));
        shopProduct.setImages(EmptyUtils.getImages(images));
        shopProduct.setSkus(skus);
        shopProduct.setNames(names);
        return shopProduct;
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void start(ProductUpDownParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        CereShopProduct cereShopProduct = new CereShopProduct();
        cereShopProduct.setProductId(param.getProductId());
        cereShopProduct.setShelveState(param.getShelveState());
        String describe = "";
        if (IntegerEnum.YES.getCode().equals(param.getShelveState())) {
            describe = "上架商品";
            cereShopProduct.setShelveState(IntegerEnum.PRODUCT_EXAMINE_STAY.getCode());
        } else {
            describe = "下架商品";
            projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), null, RefreshSkuRealInfoSourceEnum.PUT_OFF_SHELVE, null);
        }
        cereShopProductDAO.updateByPrimaryKeySelective(cereShopProduct);
        //清空缓存
        triggerCacheUpdate(param.getProductId());
        //新增日志
        cerePlatformLogService.addLog(user, "商品管理", "商户端操作", describe, cereShopProduct.getProductId(), time);
    }

    @Override
    public Page getAll(ProductGetAllParam param) throws CoBusinessException {
        //定义最低会员价map
        Map<Long, BigDecimal> minMap = new HashMap<>();
        //定义最高会员价map
        Map<Long, BigDecimal> maxMap = new HashMap<>();
        //定义模式map
        Map<Long, Integer> modeMap = new HashMap<>();
        //查询所有商品会员价格最低值数据
        List<CereProductMember> minMembers = cereProductMemberService.findAllMin();
        if (!EmptyUtils.isEmpty(minMembers)) {
            minMap = minMembers.stream().collect(Collectors.toMap(CereProductMember::getProductId, CereProductMember::getPrice));
            modeMap = minMembers.stream().collect(Collectors.toMap(CereProductMember::getProductId, CereProductMember::getMode));
        }
        //查询所有商品会员价格最高值数据
        List<CereProductMember> maxMembers = cereProductMemberService.findAllMax();
        if (!EmptyUtils.isEmpty(maxMembers)) {
            maxMap = maxMembers.stream().collect(Collectors.toMap(CereProductMember::getProductId, CereProductMember::getPrice));
        }
        PageHelper.startPage(param.getPage(), param.getPageSize());
        List<ShopProduct> list = cereShopProductDAO.getAllByPage(param);
        if (!EmptyUtils.isEmpty(list)) {
            Map<Long, BigDecimal> finalMinMap = minMap;
            Map<Long, BigDecimal> finalMaxMap = maxMap;
            Map<Long, Integer> finalModeMap = modeMap;
            List<Long> productIdList = list.stream().map(ShopProduct::getProductId).collect(Collectors.toList());
            Map<Long, ShopProduct> extMap = cereShopProductDAO.getProductExtInfo(productIdList);
            List<CereProductSku> stockSku = cereProductSkuService.selectStockNumberProductIdList(productIdList);
            Map<Long, Integer> stockNumMap = new HashMap<>();
            for (CereProductSku sku : stockSku) {
                stockNumMap.put(sku.getProductId(), sku.getStockNumber());
            }
            list.forEach((shopProduct -> {
                ShopProduct extInfo = extMap.get(shopProduct.getProductId());
                if (extInfo != null) {
                    shopProduct.setProductImage(extInfo.getProductImage());
                    shopProduct.setPrice(extInfo.getPrice());
                    shopProduct.setOriginalPrice(extInfo.getOriginalPrice());
                    shopProduct.setMaxPrice(extInfo.getMaxPrice());
                    shopProduct.setSection("￥" + extInfo.getPrice() + "~￥" + extInfo.getMaxPrice());
                }

                //查询规格商品销量
                Integer total = cereProductSkuService.findVolumeByProductId(shopProduct.getProductId());
                shopProduct.setVolume(total);
                Integer stockNumber = stockNumMap.get(shopProduct.getProductId());
                if (stockNumber != null) {
                    shopProduct.setStockNumber(stockNumber);
                }
                if (!EmptyUtils.isEmpty(finalMinMap) && !EmptyUtils.isEmpty(finalMinMap.get(shopProduct.getProductId()))) {
                    Integer mode = finalModeMap.get(shopProduct.getProductId());
                    BigDecimal min = finalMinMap.get(shopProduct.getProductId());
                    BigDecimal max = finalMaxMap.get(shopProduct.getProductId());
                    if (IntegerEnum.MEMBER_PRODUCT_MODE_DISCOUNT.getCode().equals(mode)
                            && min != null && max != null
                            && shopProduct.getPrice() != null
                            && shopProduct.getMaxPrice() != null) {
                        BigDecimal minPrice = shopProduct.getPrice().multiply(min).divide(BigDecimal.TEN, 2, BigDecimal.ROUND_HALF_UP);
                        BigDecimal maxPrice = shopProduct.getMaxPrice().multiply(max).divide(BigDecimal.TEN, 2, BigDecimal.ROUND_HALF_UP);
                        shopProduct.setMemberSection("￥" + minPrice + "~￥" + maxPrice);
                    } else {
                        //设置会员价格区间
                        shopProduct.setMemberSection("￥" + min + "~￥" + max);
                    }
                }
            }));
        }
        PageInfo<ShopProduct> pageInfo = new PageInfo<>(list);
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }

    @Override
    public void importProduct(Workbook wb) throws CoBusinessException, Exception {
        Long shopId = ContextUtil.getShopId();
        List<ProductImport> list = ImportExeclUtil.readDateListT(wb, new ProductImport());
        String time = TimeUtils.yyMMddHHmmss();
        //校验有效数据
        List<ProductSaveParam> products = importCheckService.checkProduct(list, shopId);
        if (!EmptyUtils.isEmpty(products)) {
            List<CereSkuName> skuNames = new ArrayList<>();
            for (ProductSaveParam param : products) {
                //新增商品数据
                CereShopProduct cereShopProduct = new CereShopProduct();
                cereShopProduct.setProductName(param.getProductName());
                cereShopProduct.setClassifyId(param.getClassifyId());
                cereShopProduct.setSupplierName(param.getSupplierName());
                cereShopProduct.setIfLogistics(Integer.parseInt(param.getIfLogistics()));
                cereShopProduct.setIfOversold(Integer.parseInt(param.getIfOversold()));
                if (IntegerEnum.PRODUCT_EXAMINE_YES.getCode().equals(Integer.parseInt(param.getShelveState()))) {
                    //如果是已上架,修改状态为审核中
                    cereShopProduct.setShelveState(IntegerEnum.PRODUCT_EXAMINE_STAY.getCode());
                } else {
                    //已下架
                    cereShopProduct.setShelveState(Integer.parseInt(param.getShelveState()));
                }
                cereShopProduct.setCreateTime(time);
                cereShopProduct.setUpdateTime(time);
                cereShopProduct.setShopId(param.getShopId());
                cereShopProductDAO.insert(cereShopProduct);
                //查询当前是否有全部商品且进行中状态的优惠券
                List<CereShopCoupon> coupons = cereShopCouponService.findAllByShopId(cereShopProduct.getShopId());
                if (!EmptyUtils.isEmpty(coupons)) {
                    //如果有,将新增的商品插入到优惠券商品明细表中
                    List<CereShopCouponDetail> details = coupons.stream().map(coupon -> {
                        CereShopCouponDetail detail = new CereShopCouponDetail();
                        detail.setProductId(cereShopProduct.getProductId());
                        detail.setShopCouponId(coupon.getShopCouponId());
                        return detail;
                    }).collect(Collectors.toList());
                    //批量插入数据
                    cereShopCouponDetailService.insertBatch(details);
                }
                //新增规格数据
                saveExcelSkus(param.getSkus(), cereShopProduct.getProductId(), skuNames, time);
            }
            cereSkuNameService.insertBatch(skuNames);
        }
    }

    @Override
    public CereShopProduct checkName(Long shopId, Long classifyId, String productName) {
        return cereShopProductDAO.checkName(shopId, classifyId, productName);
    }

    @Override
    public Page getProducts(CanvasProductParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(), param.getPageSize());
        List<CanvasProduct> list = cereShopProductDAO.getProducts(param);
        PageInfo<CanvasProduct> pageInfo = new PageInfo<>(list);
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }

    @Override
    public Page getShops(CanvasProductParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(), param.getPageSize());
        List<CanvasShop> list = cereShopProductDAO.getShops(param);
        PageInfo<CanvasShop> pageInfo = new PageInfo<>(list);
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }

    @Override
    public List<Long> findAllZeroStockNumber() {
        return cereShopProductDAO.findAllZeroStockNumber();
    }

    @Override
    public void updateBatchShelveState(List<Long> ids, String time) throws CoBusinessException {
        cereShopProductDAO.updateBatchShelveState(ids, time);
        //清空缓存
        for (Long id : ids) {
            triggerCacheUpdate(id);
        }
    }

    @Override
    public List<CereShopProduct> selectAll() {
        return cereShopProductDAO.selectAll();
    }

    @Override
    public List<ProductMember> getProductMembers(Long productId) throws CoBusinessException {
        //查询所有规格数据
        List<ProductMember> members = cereShopProductDAO.getProductMembers(productId);
        if (!EmptyUtils.isEmpty(members)) {
            members.forEach(member -> {
                //设置会员价格
                member.setMemberPrices(cereProductMemberService.getProductMembers(member.getSkuId()));
            });
        }
        return members;
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void setProductMember(ProductMemberParam param) throws CoBusinessException {
        //清空原有数据
        cereProductMemberService.deleteByProductId(param.getProductId());
        List<CereProductMember> members = new ArrayList<>();
        if (!EmptyUtils.isEmpty(param.getMembers())) {
            param.getMembers().forEach(productMember -> {
                if (!EmptyUtils.isEmpty(productMember.getMemberPrices())) {
                    productMember.getMemberPrices().forEach(memberPrice -> {
                        CereProductMember cereProductMember = new CereProductMember();
                        cereProductMember.setProductId(productMember.getProductId());
                        cereProductMember.setSkuId(productMember.getSkuId());
                        cereProductMember.setMemberLevelId(memberPrice.getMemberLevelId());
                        cereProductMember.setMode(memberPrice.getMode());
                        cereProductMember.setPrice(memberPrice.getPrice());
                        //计算最终价格
                        if (memberPrice.getMode().equals(1)) {
                            //折扣
                            BigDecimal discount = memberPrice.getPrice().divide(BigDecimal.TEN, 2, BigDecimal.ROUND_HALF_UP);
                            cereProductMember.setTotal(productMember.getPrice().multiply(discount).setScale(2, BigDecimal.ROUND_HALF_UP));
                        } else {
                            //价格
                            cereProductMember.setTotal(productMember.getPrice());
                        }
                        members.add(cereProductMember);
                    });
                }
            });
            if (!EmptyUtils.isEmpty(members)) {
                //批量插入会员价格数据
                cereProductMemberService.insertBatch(members);
            }
        }
        //triggerCacheUpdate(param.getProductId());
    }

    @Override
    public void clearProductMember(Long productId) {
        //查询商品信息
        ShopProduct shopProduct = cereShopProductDAO.getById(productId);
        //判断商品是否存在
        if (shopProduct != null) {
            //存在则清空
            //清空该商品会员价数据
            cereProductMemberService.deleteByProductId(productId);
            //刷新sku实时信息
            projectInvokeUtil.postRefreshSkuRealInfo(productId, null, RefreshSkuRealInfoSourceEnum.CLEAR_MEMBER_PRODUCT, null);
        }
    }

    @Override
    public void triggerCacheUpdate(Long productId) {
        if (productId == null || productId <= 0) {
            return;
        }
        List<Sku> skuList = cereProductSkuService.findByProductId(productId);
        for (Sku sku : skuList) {
            String key = CacheKeyConstants.SKU_CACHE_PREFIX + "_" + productId + "_" + sku.getSkuId();
            stringRedisService.delete(key);
        }
    }

    /**
     * 更新sku的活动库存
     *
     * @param skuId
     * @param activityType
     * @param activityStatus
     * @param activityStock
     * @param millSeconds
     */
    @Override
    public void updateActivitySkuStock(Long skuId, Integer activityType, Integer activityStatus, Integer activityStock, Integer totalStock, long millSeconds) {
        String activitySkuStockKey = CacheKeyConstants.ACTIVITY_SKU_STOCK_PREFIX + activityType + "_" + skuId;
        String activitySkuTotalStockKey = CacheKeyConstants.ACTIVITY_SKU_TOTAL_STOCK_PREFIX + activityType + "_" + skuId;
        if (IntegerEnum.COUPON_STATE_START.getCode().equals(activityStatus)) {
            stringRedisService.set(activitySkuStockKey, activityStock, millSeconds);
            stringRedisService.set(activitySkuTotalStockKey, totalStock, millSeconds);
        } else {
            stringRedisService.delete(activitySkuStockKey);
            stringRedisService.delete(activitySkuTotalStockKey);
        }
    }

    @Override
    public List<SyncShopProduct> syncProductList(Long shopId, Long lastProductId, Integer pageSize) {
        List<CereShopProduct> productList = cereShopProductDAO.selectList(Wrappers.<CereShopProduct>lambdaQuery()
                .eq(CereShopProduct::getShopId, shopId)
                .gt(lastProductId != null, CereShopProduct::getProductId, lastProductId)
                .orderByAsc(CereShopProduct::getProductId).last("limit " + pageSize));
        List<SyncShopProduct> syncList = new ArrayList<>();
        List<Long> classifyIdList = productList.stream().filter(obj -> obj.getClassifyId() != null).map(CereShopProduct::getClassifyId).collect(Collectors.toList());
        Map<Long, String> classifyMap = new HashMap<>();
        if (CollectionUtils.isNotEmpty(classifyIdList)) {
            classifyMap = cereProductClassifyDAO.selectBatchIds(classifyIdList).stream().collect(Collectors.toMap(CereProductClassify::getClassifyId, CereProductClassify::getClassifyName));
        }
        for (CereShopProduct shopProduct : productList) {
            List<Sku> skuList = cereProductSkuService.findByProductId(shopProduct.getProductId());
            SyncShopProduct syncProduct = new SyncShopProduct();
            BeanUtils.copyProperties(shopProduct, syncProduct);
            syncProduct.setSkuList(skuList);
            List<String> productImages = cereProductImageService.findByProductId(shopProduct.getProductId());
            List<Image> imageList = productImages.stream().map(obj -> {
                Image image = new Image();
                image.setImgPath(obj);
                return image;
            }).collect(Collectors.toList());
            syncProduct.setImages(imageList);
            syncProduct.setClassifyName(classifyMap.get(syncProduct.getClassifyId()));
            syncList.add(syncProduct);
        }
        return syncList;
    }

    @Override
    public List<ProductExportDTO> getExportList(ProductGetAllParam param) {
        //PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ShopProduct> list = cereShopProductDAO.getAll(param);
        List<ProductExportDTO> result = new ArrayList<>();
        List<Long> brandIdList = list.stream().filter(obj -> obj.getBrandId() != null).map(ShopProduct::getBrandId).distinct().collect(Collectors.toList());
        Map<Long, String> brandMap = new HashMap<>();
        if (CollectionUtils.isNotEmpty(brandIdList)) {
            brandMap = brandDAO.selectBatchIds(brandIdList).stream().collect(Collectors.toMap(Brand::getId, Brand::getBrandName));
        }
        for (ShopProduct sp : list) {
            List<CereSkuName> skuNameList = cereSkuNameService.findSkuNameListByProductId(sp.getProductId());
            List<CereProductSku> skuList = cereProductSkuService.selectListBySkuIdList(skuNameList.stream().map(CereSkuName::getSkuId).collect(Collectors.toList()));
            Map<Long, CereProductSku> skuMap = skuList.stream().collect(Collectors.toMap(CereProductSku::getSkuId, Function.identity()));
            Map<Long, List<CereSkuName>> skuNameMap = skuNameList.stream().collect(Collectors.groupingBy(CereSkuName::getSkuId));
            List<Long> skuIdList = new ArrayList<>(skuNameMap.keySet());
            Map<Long, Integer> salesVolumeMap = cereShopOrderService.selectSalesVolumeBySkuIdList(skuIdList);
            String brandName = null;
            if (sp.getBrandId() != null) {
                brandName = brandMap.get(sp.getBrandId());
            }
            for (Long skuId : skuNameMap.keySet()) {
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

    private void saveExcelSkus(List<SkuParam> skus, Long productId, List<CereSkuName> skuNames, String time) throws CoBusinessException {
        if (!EmptyUtils.isEmpty(skus)) {
            for (SkuParam sku : skus) {
                CereProductSku cereProductSku = new CereProductSku();
                cereProductSku.setStyle(IntegerEnum.SKU_STYLE_ONE.getCode());
                cereProductSku.setOriginalPrice(sku.getOriginalPrice());
                cereProductSku.setPrice(sku.getPrice());
                cereProductSku.setSkuImage(sku.getSkuImage());
                cereProductSku.setSKU(sku.getSku());
                cereProductSku.setStockNumber(sku.getStockNumber());
                cereProductSku.setWeight(sku.getWeight());
                cereProductSku.setProductId(productId);
                cereProductSku.setCreateTime(time);
                //新增规格
                cereProductSkuService.insert(cereProductSku);
                //将商品库存数量放到redis中
                stringRedisService.set(String.valueOf(cereProductSku.getSkuId()), cereProductSku.getStockNumber());
                //同步新增规格名和规格值关联数据
                CereSkuName cereSkuName = new CereSkuName();
                cereSkuName.setSkuValue(sku.getNameValue().getSkuValue());
                cereSkuName.setSkuId(cereProductSku.getSkuId());
                cereSkuName.setNameCode("attr_code_0");
                cereSkuName.setValueCode("attr_code_0_value_0");
                cereSkuName.setNeed(0);
                skuNames.add(cereSkuName);
            }
        }
    }

    private void saveSkus(List<SkuParam> skus, CereShopProduct cereShopProduct, List<DeleteSkuParam> deletes,
                          String time, Map<String, NameValue> map, List<SkuNameParam> names) throws CoBusinessException {
        if (!EmptyUtils.isEmpty(skus)) {
            for (SkuParam sku : skus) {
                CereProductSku cereProductSku = new CereProductSku();
                if (sku.getSkuId() != null) {
                    cereProductSku.setSkuId(sku.getSkuId());
                }
                cereProductSku.setOriginalPrice(sku.getOriginalPrice());
                cereProductSku.setPrice(sku.getPrice());
                cereProductSku.setSkuImage(sku.getSkuImage());
                cereProductSku.setSKU(sku.getSku());
                cereProductSku.setStockNumber(sku.getStockNumber());
                cereProductSku.setTotal(sku.getStockNumber());
                cereProductSku.setStyle(sku.getStyle());
                cereProductSku.setWeight(sku.getWeight());
                if (EmptyUtils.isEmpty(sku.getSkuId())) {
                    cereProductSku.setProductId(cereShopProduct.getProductId());
                    cereProductSku.setCreateTime(time);
                    //新增规格
                    cereProductSkuService.insert(cereProductSku);
                    //将商品库存数量放到redis中
                    //stringRedisService.set(String.valueOf(cereProductSku.getSkuId()),cereProductSku.getStockNumber());
                    //同步新增规格名和规格值关联数据
                    if (IntegerEnum.SKU_STYLE_ONE.getCode().equals(cereProductSku.getStyle())) {
                        //如果是单款式
                        CereSkuName cereSkuName = new CereSkuName();
                        cereSkuName.setSkuName(names.get(0).getValues().get(0).getSkuValue());
                        cereSkuName.setSkuValue(names.get(0).getValues().get(0).getSkuValue());
                        cereSkuName.setSkuId(cereProductSku.getSkuId());
                        cereSkuName.setNeed(IntegerEnum.NO.getCode());
                        cereSkuNameService.insert(cereSkuName);
                    } else {
                        //多款式
                        if (!EmptyUtils.isEmpty(sku.getSkuAttrCodeDTOList())) {
                            List<CereSkuName> collect = sku.getSkuAttrCodeDTOList().stream()
                                    .map(a -> {
                                        CereSkuName cereSkuName = new CereSkuName();
                                        NameValue nameValue = map.get(a.getCode() + "-" + a.getValueCode());
                                        if (nameValue != null) {
                                            cereSkuName.setSkuValue(nameValue.getSkuValue());
                                            cereSkuName.setSkuName(nameValue.getSkuName());
                                            cereSkuName.setImage(nameValue.getImage());
                                            cereSkuName.setSkuId(cereProductSku.getSkuId());
                                            cereSkuName.setNameCode(a.getCode());
                                            cereSkuName.setValueCode(a.getValueCode());
                                            cereSkuName.setNeed(nameValue.getNeed());
                                            return cereSkuName;
                                        } else {
                                            return null;
                                        }
                                    })
                                    //过滤空对象
                                    .filter(Objects::nonNull)
                                    .collect(Collectors.toList());
                            if (!EmptyUtils.isEmpty(collect)) {
                                cereSkuNameService.insertBatch(collect);
                            }
                        }
                    }
                } else {
                    //查询规格原有库存数量
                    //int stockNumber=cereProductSkuService.findStockNumber(cereProductSku.getSkuId());
                    //获取redis中库存数量
                    /*int redis=0;
                    if(!EmptyUtils.isEmpty(stringRedisService.get(String.valueOf(cereProductSku.getSkuId())))){
                        redis= (int) stringRedisService.get(String.valueOf(cereProductSku.getSkuId()));
                    }else {
                        redis=stockNumber;
                    }*/
                    //计算库存差值=修改后的库存-原有库存
                    //int number=cereProductSku.getStockNumber()-stockNumber;
                    //将商品库存数量放到redis中
                    //stringRedisService.set(String.valueOf(cereProductSku.getSkuId()),number+redis);
                    //更新规格
                    cereProductSku.setUpdateTime(time);
                    cereProductSkuService.update(cereProductSku);
                    //同步更新秒杀活动商品价格
                    updateSeckillProduct(cereProductSku, cereShopProduct.getShopId());
                    //同步更新限时折扣活动商品价格
                    updateDiscountProduct(cereProductSku, cereShopProduct.getShopId());
                    //清空规格属性数据
                    cereSkuNameService.deleteBySkuId(cereProductSku.getSkuId());
                    if (IntegerEnum.SKU_STYLE_ONE.getCode().equals(cereProductSku.getStyle())) {
                        //单款式
                        CereSkuName cereSkuName = new CereSkuName();
                        cereSkuName.setSkuName(names.get(0).getValues().get(0).getSkuValue());
                        cereSkuName.setSkuValue(names.get(0).getValues().get(0).getSkuValue());
                        cereSkuName.setSkuId(cereProductSku.getSkuId());
                        cereSkuName.setNeed(IntegerEnum.NO.getCode());
                        cereSkuNameService.insert(cereSkuName);
                    } else {
                        //多款式
                        if (!EmptyUtils.isEmpty(sku.getSkuAttrCodeDTOList())) {
                            List<CereSkuName> collect = sku.getSkuAttrCodeDTOList().stream()
                                    .map(a -> {
                                        CereSkuName cereSkuName = new CereSkuName();
                                        NameValue nameValue = map.get(a.getCode() + "-" + a.getValueCode());
                                        if (nameValue != null) {
                                            cereSkuName.setSkuValue(nameValue.getSkuValue());
                                            cereSkuName.setSkuName(nameValue.getSkuName());
                                            cereSkuName.setImage(nameValue.getImage());
                                            cereSkuName.setSkuId(cereProductSku.getSkuId());
                                            cereSkuName.setNameCode(a.getCode());
                                            cereSkuName.setValueCode(a.getValueCode());
                                            cereSkuName.setNeed(nameValue.getNeed());
                                            return cereSkuName;
                                        } else {
                                            return null;
                                        }
                                    })
                                    //过滤空对象
                                    .filter(Objects::nonNull)
                                    .collect(Collectors.toList());
                            if (!EmptyUtils.isEmpty(collect)) {
                                //批量插入规格数据
                                cereSkuNameService.insertBatch(collect);
                            }
                        }
                    }
                }

            }
        }
        if (!EmptyUtils.isEmpty(deletes)) {
            //删除规格,查询满足删除规格属性的所有规格id
            List<Long> ids = cereSkuNameService.findDeleteSkuIds(deletes, cereShopProduct.getProductId());
            if (!EmptyUtils.isEmpty(ids)) {
                cereProductSkuService.deleteByIds(ids);
                //清空规格名和规格值关联数据
                cereSkuNameService.deleteByIds(ids);
            }
        }
    }

    private void updateDiscountProduct(CereProductSku cereProductSku, Long shopId) throws CoBusinessException {
        //查询当前所有未开始和进行中的限时折扣活动商品
        List<CereShopDiscountDetail> details = cereShopDiscountDetailService.findBySkuId(cereProductSku.getSkuId(), shopId);
        if (!EmptyUtils.isEmpty(details)) {
            //重新计算折扣价格
            details.forEach(detail -> {
                //折扣价格=商品原价*折扣
                BigDecimal decimal = detail.getDiscount().divide(new BigDecimal(10), 2, BigDecimal.ROUND_HALF_UP);
                detail.setPrice(cereProductSku.getOriginalPrice().multiply(decimal).setScale(2, BigDecimal.ROUND_HALF_UP));
            });
            //批量更新折扣价格
            cereShopDiscountDetailService.updateBatchDiscountPrice(details);
        }
    }

    private void updateSeckillProduct(CereProductSku cereProductSku, Long shopId) throws CoBusinessException {
        //查询当前所有未开始和进行中的秒杀活动商品
        List<CereShopSeckillDetail> details = cereShopSeckillDetailService.findBySkuId(cereProductSku.getSkuId(), shopId);
        if (!EmptyUtils.isEmpty(details)) {
            //重新计算秒杀价格
            for (CereShopSeckillDetail detail : details) {
                //秒杀价格=商品原价-直降
                if (cereProductSku.getOriginalPrice().compareTo(detail.getDownPrice()) <= 0) {
                    throw new CoBusinessException(CoReturnFormat.UPDATE_PRODUCT_PRICE_ACTIVITY_ERROR);
                }
                detail.setSeckillPrice(cereProductSku.getOriginalPrice().subtract(detail.getDownPrice()));
            }
            //批量更新秒杀价格
            cereShopSeckillDetailService.updateBatchSeckillPrice(details);
        }
    }
}
