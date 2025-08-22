/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.page.member.ProductMember;
import com.shop.cereshop.business.page.product.ProductExportDTO;
import com.shop.cereshop.business.page.product.ShopProduct;
import com.shop.cereshop.business.page.product.SyncShopProduct;
import com.shop.cereshop.business.page.tool.ToolProduct;
import com.shop.cereshop.business.param.business.BusinessSyncToScrmParam;
import com.shop.cereshop.business.param.product.*;
import com.shop.cereshop.business.param.tool.ToolSkuParam;
import com.shop.cereshop.business.service.brand.BrandService;
import com.shop.cereshop.business.service.product.CereProductClassifyService;
import com.shop.cereshop.business.service.product.CereProductSkuService;
import com.shop.cereshop.business.service.product.CereShopProductService;
import com.shop.cereshop.business.service.shop.CereShopGroupService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.business.utils.ScrmSyncVerifyUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.RefreshSkuRealInfoSourceEnum;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.product.CereProductClassify;
import com.shop.cereshop.commons.domain.product.Classify;
import com.shop.cereshop.commons.domain.shop.CereShopGroup;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.GsonUtil;
import com.shop.cereshop.commons.utils.ProjectInvokeUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;

/**
 * 商品
 */
@RestController
@RequestMapping("product")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "ProductController")
@Api(value = "商品模块", tags = "商品模块")
public class ProductController {

    @Autowired
    private CereShopProductService cereShopProductService;

    @Autowired
    private CereProductClassifyService cereProductClassifyService;

    @Autowired
    private CereShopGroupService cereShopGroupService;

    @Autowired
    private CereProductSkuService cereProductSkuService;

    @Autowired
    private ScrmSyncVerifyUtil scrmSyncVerifyUtil;

    @Autowired
    private BrandService brandService;

    @Autowired
    private ProjectInvokeUtil projectInvokeUtil;

    /**
     * 查询分类层级
     * @return
     */
    @PostMapping(value = "getClassify")
    @ApiOperation(value = "查询分类层级")
    public Result<Classify> getClassify() throws CoBusinessException{
        List<Classify> list=cereProductClassifyService.getClassify();
        return new Result(list);
    }

    /**
     * 添加商品
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "添加商品")
    @NoRepeatWebLog
    public Result save(@RequestBody @Validated ProductSaveParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        cereShopProductService.save(param,user);
        return new Result(user.getUsername(),"添加商品", GsonUtil.objectToGson(param));
    }

    /**
     * 修改商品
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改商品")
    @NoRepeatWebLog
    public Result update(@RequestBody ProductUpdateParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        cereShopProductService.update(param,user);
        return new Result(user.getUsername(),"修改商品", GsonUtil.objectToGson(param));
    }

    /**
     * 删除商品
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除商品")
    @NoRepeatWebLog
    public Result delete(@RequestBody ProductDeleteParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereShopProductService.delete(param,user);
        return new Result(user.getUsername(),"删除商品", GsonUtil.objectToGson(param));
    }

    /**
     * 商品上下架
     * @param param
     * @return
     */
    @PostMapping(value = "start")
    @NoRepeatSubmit
    @ApiOperation(value = "商品上下架")
    @NoRepeatWebLog
    public Result start(@RequestBody ProductUpDownParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereShopProductService.start(param,user);
        return new Result(user.getUsername(),"商品上下架", GsonUtil.objectToGson(param));
    }

    /**
     * 修改商品查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "修改商品查询")
    public Result<ShopProduct> getById(@RequestBody ProductGetByIdParam param) throws CoBusinessException{
        ShopProduct shopProduct=cereShopProductService.getById(param.getProductId());
        return new Result(shopProduct);
    }

    /**
     * 商品管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "商品管理查询")
    public Result<Page<ShopProduct>> getAll(@RequestBody ProductGetAllParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        Page page=cereShopProductService.getAll(param);
        return new Result(page);
    }

    /**
     * 商品会员价格数据查询
     * @param param
     * @return
     */
    @PostMapping(value = "getProductMembers")
    @ApiOperation(value = "商品会员价格数据查询")
    public Result<List<ProductMember>> getProductMembers(@RequestBody ProductGetByIdParam param) throws CoBusinessException{
        List<ProductMember> list=cereShopProductService.getProductMembers(param.getProductId());
        return new Result(list);
    }

    /**
     * 商品设置会员价
     * @param param
     * @return
     */
    @PostMapping(value = "setProductMember")
    @ApiOperation(value = "商品设置会员价")
    public Result setProductMember(@RequestBody ProductMemberParam param,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereShopProductService.setProductMember(param);
        //刷新sku实时信息
        projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), null, RefreshSkuRealInfoSourceEnum.EDIT_MEMBER_PRODUCT, null);
        return new Result(user.getUsername(),"设置会员价格", GsonUtil.objectToGson(param));
    }
    /**
     * 商品清除会员价
     * @param param
     * @return
     */
    @PostMapping(value = "clearProductMember")
    @ApiOperation(value = "商品清除会员价")
    public Result clearProductMember(@RequestBody ProductGetByIdParam param,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereShopProductService.clearProductMember(param.getProductId());
        return new Result(user.getUsername(),"清除会员价格", GsonUtil.objectToGson(param));
    }
    /**
     * 选择类别查询(根据上级节点查询下级)
     * @return
     */
    @PostMapping(value = "getClassifySelect")
    @ApiOperation(value = "选择类别查询(根据上级节点查询下级)")
    public Result<List<CereProductClassify>> getClassifySelect(@RequestBody ProductGetClassifyParam param) throws CoBusinessException{
        List<CereProductClassify> list=cereProductClassifyService.getClassifySelect(param);
        return new Result(list);
    }

    /**
     * 选择商品分组查询
     * @return
     */
    @PostMapping(value = "getGroupSelect")
    @ApiOperation(value = "选择商品分组查询")
    public Result<List<CereShopGroup>> getGroupSelect(@RequestBody ProductGetGroupParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        List<CereShopGroup> list=cereShopGroupService.getGroupSelect(param);
        return new Result(list);
    }

    /**
     * 导入商品模板表下载
     * @param response
     */
    @PostMapping(value = "downloadTemplate")
    @ApiOperation(value = "导入商品模板表下载")
    public void downloadTemplate(HttpServletResponse response){
        try {
            ClassPathResource resource = new ClassPathResource("static/导入商品模板表.xlsx");
            InputStream in = resource.getInputStream();
            XSSFWorkbook excel= new XSSFWorkbook(in);
            String str = "商品导入模板表";
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setHeader("Content-disposition", "attachment;filename=" + str +".xlsx");// 默认Excel名称
            response.flushBuffer();
            excel.write(response.getOutputStream());
            excel.close();
        } catch (IOException e) {
            log.error(e.getMessage());
        }
    }

    /**
     * 导入商品数据
     * @param file
     * @return
     */
    @PostMapping(value = "importProduct")
    @NoRepeatSubmit
    @ApiOperation(value = "导入商品数据")
    public Result importProduct(MultipartFile file) throws CoBusinessException,Exception{
        if(EmptyUtils.isEmpty(file)){
            return new Result(CoReturnFormat.NOT_FILE);
        }
        Workbook wb= WorkbookFactory.create(file.getInputStream());
        cereShopProductService.importProduct(wb);
        return new Result();
    }

    /**
     * 商品规格查询
     * @return
     */
    @PostMapping(value = "getSkus")
    @ApiOperation(value = "商品规格查询")
    public Result<List<ToolProduct>> getToolSkus(@RequestBody ToolSkuParam param) throws CoBusinessException{
        List<ToolProduct> list=cereProductSkuService.getToolSkus(param.getProductId());
        return new Result(list);
    }

    /**
     * 同步商品列表到scrm
     * @return
     */
    @PostMapping(value = "syncProductList")
    @ApiOperation(value = "同步商品列表到scrm")
    public Result<List<SyncShopProduct>> syncProductList(@RequestBody BusinessSyncToScrmParam param) throws CoBusinessException {
        if (param == null || param.getSecret() == null || param.getPageSize() == null) {
            return new Result<>(Collections.emptyList());
        }
        scrmSyncVerifyUtil.verify(param.getShopId(), param.getSecret());
        List<SyncShopProduct> list=cereShopProductService.syncProductList(param.getShopId(), param.getLastId(), param.getPageSize());
        return new Result(list);
    }

    /**
     * 导出商品数据
     * @param param
     * @return
     */
    @PostMapping(value = "exportProduct")
    @NoRepeatSubmit
    @ApiOperation(value = "导出商品数据")
    public void exportProduct(@RequestBody ProductGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException {
        param.setShopId(ContextUtil.getShopId());
        List<ProductExportDTO> productExportList = cereShopProductService.getExportList(param);
        //定义导出的excel名字
        String excelName = "商品列表";
        ExcelExportUtils.exportExcel(request, response, excelName, productExportList, ProductExportDTO.class);
    }

    /**
     * 查询品牌列表
     * @return
     */
    @PostMapping(value = "getBrandList")
    @ApiOperation(value = "查询品牌列表")
    public Result<Brand> getBrandList() {
        List<Brand> list = brandService.getBrandList();
        return new Result(list);
    }
}
