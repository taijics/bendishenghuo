/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.page.canvas.CanvasCoupon;
import com.shop.cereshop.admin.page.canvas.CanvasPlatformDiscount;
import com.shop.cereshop.admin.page.canvas.CanvasPlatformSeckill;
import com.shop.cereshop.admin.page.canvas.ToolProduct;
import com.shop.cereshop.admin.page.product.*;
import com.shop.cereshop.admin.param.canvas.CanvasCouponParam;
import com.shop.cereshop.admin.param.canvas.CanvasPageParam;
import com.shop.cereshop.admin.param.canvas.RenovationParam;
import com.shop.cereshop.admin.param.product.CanvasAdminProductParam;
import com.shop.cereshop.admin.param.product.ProductGetAllParam;
import com.shop.cereshop.admin.param.product.ProductGetByIdParam;
import com.shop.cereshop.admin.service.activity.CerePlatformActivityService;
import com.shop.cereshop.admin.service.canvas.CerePlatformCanvasCustomService;
import com.shop.cereshop.admin.service.canvas.CerePlatformCanvasService;
import com.shop.cereshop.admin.service.live.CereLiveService;
import com.shop.cereshop.admin.service.notice.CereNoticeService;
import com.shop.cereshop.admin.service.platformtool.CerePlatformDiscountService;
import com.shop.cereshop.admin.service.platformtool.CerePlatformSeckillService;
import com.shop.cereshop.admin.service.product.CereProductClassifyService;
import com.shop.cereshop.admin.service.product.CereProductMemberService;
import com.shop.cereshop.admin.service.product.CereShopProductService;
import com.shop.cereshop.commons.constant.RefreshSkuRealInfoSourceEnum;
import com.shop.cereshop.commons.domain.canvas.CerePlatformCanvas;
import com.shop.cereshop.commons.domain.canvas.CerePlatformCanvasCustom;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.notice.CereNotice;
import com.shop.cereshop.commons.domain.product.Classify;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import com.shop.cereshop.commons.utils.ProjectInvokeUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 画布模块
 */
@RestController
@RequestMapping("canvas")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "CanvasController")
@Api(value = "画布模块", tags = "画布模块")
public class CanvasController {

    @Autowired
    private CereShopProductService cereShopProductService;

    @Autowired
    private CereProductClassifyService cereProductClassifyService;

    @Autowired
    private CerePlatformCanvasService cerePlatformCanvasService;

    @Autowired
    private CerePlatformCanvasCustomService cerePlatformCanvasCustomService;

    @Autowired
    private CerePlatformActivityService cerePlatformActivityService;

    @Autowired
    private CereProductMemberService cereProductMemberService;

    @Autowired
    private CereNoticeService cereNoticeService;

    @Autowired
    private CerePlatformDiscountService cerePlatformDiscountService;

    @Autowired
    private CerePlatformSeckillService cerePlatformSeckillService;

    @Autowired
    private CereLiveService cereLiveService;

    @Autowired
    private ProjectInvokeUtil projectInvokeUtil;

    /**
     * 画布选择商品查询
     * @param param
     * @return
     */
    @GetMapping("getProducts")
    @ApiOperation(value = "画布选择商品查询")
    public Result<Page<CanvasProduct>> getProducts(CanvasAdminProductParam param) throws CoBusinessException,Exception{
        Page page=cereShopProductService.getProducts(param);
        return new Result(page);
    }


    /**
     * 查询会员商品数据
     * @return
     */
    @GetMapping("getMemberProducts")
    @ApiOperation(value = "查询会员商品数据")
    public Result<Page<MemberProduct>> getMemberProducts(CanvasAdminProductParam param) throws CoBusinessException{
        Page page=cereProductMemberService.getMemberProducts(param);
        return new Result(page);
    }

    /**
     * 获取公告数据
     * @return
     */
    @GetMapping("getNotices")
    @ApiOperation(value = "获取公告数据")
    public Result<List<CereNotice>> getNotices() throws CoBusinessException,Exception{
        List<CereNotice> list=cereNoticeService.getNotices();
        return new Result(list);
    }

    /**
     * 选择平台端限时折扣活动查询
     * @return
     */
    @GetMapping("getMinDiscount")
    @ApiOperation(value = "选择平台端限时折扣活动查询")
    public Result<List<CanvasPlatformDiscount>> getMinDiscount(RenovationParam param) throws CoBusinessException,Exception{
        List<CanvasPlatformDiscount> discounts=cerePlatformDiscountService.getMinDiscount(param);
        return new Result(discounts);
    }

    /**
     * 选择平台端秒杀活动查询
     * @return
     */
    @GetMapping("getPlatformSeckills")
    @ApiOperation(value = "选择平台端秒杀活动查询")
    public Result<List<CanvasPlatformSeckill>> getPlatformSeckills(RenovationParam param) throws CoBusinessException,Exception{
        List<CanvasPlatformSeckill> list=cerePlatformSeckillService.getPlatformSeckills(param);
        return new Result(list);
    }

    /**
     * 选择拼团活动查询
     * @return
     */
    @GetMapping("getGroupWorks")
    @ApiOperation(value = "选择拼团活动查询")
    public Result<List<ToolProduct>> getGroupWorks(RenovationParam param) throws CoBusinessException{
        List<ToolProduct> list=cerePlatformActivityService.getGroupWorkProducts(param);
        return new Result(list);
    }

    /**
     * 画布选择店铺查询
     * @param param
     * @return
     */
    @GetMapping("getShops")
    @ApiOperation(value = "画布选择店铺查询")
    public Result<Page<CanvasShop>> getShops(CanvasAdminProductParam param) throws CoBusinessException{
        Page page=cereShopProductService.getShops(param);
        return new Result(page);
    }

    /**
     * 查询分类层级
     * @return
     */
    @GetMapping("getClassify")
    @ApiOperation(value = "查询分类层级")
    public Result<Classify> getClassify() throws CoBusinessException{
        List<Classify> list=cereProductClassifyService.getClassify();
        return new Result(list);
    }

    /**
     * 查询所有平台优惠券
     * @return
     */
    @GetMapping("getCoupons")
    @ApiOperation(value = "查询分类层级")
    public Result<Page<CanvasCoupon>> getCoupons(CanvasCouponParam param) throws CoBusinessException{
        Page page=cerePlatformActivityService.getCoupons(param);
        return new Result(page);
    }

    /**
     * 保存画布
     * @return
     */
    @PostMapping("saveCanvas")
    @ApiOperation(value = "保存画布")
    @NoRepeatWebLog
    public Result saveCanvas(@RequestBody CerePlatformCanvas canvas,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformCanvasService.saveCanvas(canvas,user);
        return new Result(user.getUsername(),"保存画布", GsonUtil.objectToGson(canvas));
    }

    /**
     * 读取画布数据
     * @return
     */
    @GetMapping("getCanvas")
    @ApiOperation(value = "读取画布数据")
    public Result getCanvas(CerePlatformCanvas canvas) throws CoBusinessException{
        canvas=cerePlatformCanvasService.getCanvas(canvas);
        return new Result(canvas);
    }

    /**
     * 删除画布
     * @return
     */
    @PostMapping("delCanvas")
    @ApiOperation(value = "删除画布")
    @NoRepeatWebLog
    public Result delCanvas(@RequestBody CerePlatformCanvas canvas,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformCanvasService.delCanvas(canvas,user);
        return new Result(user.getUsername(),"删除画布", GsonUtil.objectToGson(canvas));
    }

    /**
     * 查询画布列表
     * @return
     */
    @PostMapping("selectCanvasList")
    @ApiOperation(value = "查询画布列表")
    public Result<Page<CerePlatformCanvas>> selectCanvasList(@RequestBody CanvasPageParam param) throws CoBusinessException{
        Page page = cerePlatformCanvasService.selectCanvasList(param);
        return new Result(page);
    }

    /**
     * 保存自定义页面
     * @return
     */
    @PostMapping("saveCanvasCustom")
    @ApiOperation(value = "保存自定义页面")
    @NoRepeatWebLog
    public Result saveCanvasCustom(@RequestBody CerePlatformCanvasCustom canvasCustom, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformCanvasCustomService.saveCanvasCustom(canvasCustom,user);
        return new Result(user.getUsername(),"保存自定义页面", GsonUtil.objectToGson(canvasCustom));
    }

    /**
     * 删除自定义页面
     * @return
     */
    @PostMapping("delCanvasCustom")
    @ApiOperation(value = "删除自定义页面")
    @NoRepeatWebLog
    public Result delCanvasCustom(@RequestBody CerePlatformCanvasCustom canvasCustom,HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cerePlatformCanvasCustomService.delCanvasCustom(canvasCustom,user);
        return new Result(user.getUsername(),"删除自定义页面", GsonUtil.objectToGson(canvasCustom));
    }

    /**
     * 查询自定义页面列表
     * @return
     */
    @PostMapping("selectCanvasCustomList")
    @ApiOperation(value = "查询自定义页面列表")
    public Result<Page<CerePlatformCanvasCustom>> selectCanvasCustomList(@RequestBody CanvasPageParam param) throws CoBusinessException{
        Page page = cerePlatformCanvasCustomService.selectCanvasCustomList(param);
        return new Result(page);
    }

    /**
     * 商品管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "商品管理查询")
    public Result<Page<ShopProduct>> getAll(@RequestBody ProductGetAllParam param) throws CoBusinessException{
        Page page=cereShopProductService.getAll(param);
        return new Result(page);
    }

    /**
     * 商品管理导出
     * @param param
     * @return
     */
    @PostMapping(value = "exportAll")
    @NoRepeatSubmit
    @ApiOperation(value = "商品管理导出")
    public void exportAll(@RequestBody ProductGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        List<ProductExportDTO> productExportList = cereShopProductService.getExportList(param);
        //定义导出的excel名字
        String excelName = "商品列表";
        ExcelExportUtils.exportExcel(request, response, excelName, productExportList, ProductExportDTO.class);
    }

    /**
     * 商品详情查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "商品详情查询")
    public Result<ProductDetail> getById(@RequestBody ProductGetByIdParam param) throws CoBusinessException{
        ProductDetail detail=cereShopProductService.getById(param.getProductId());
        return new Result(detail);
    }

    /**
     * 商品审核
     * @param param
     * @return
     */
    @PostMapping(value = "examine")
    @NoRepeatSubmit
    @ApiOperation(value = "商品审核")
    @NoRepeatWebLog
    public Result examine(@RequestBody ProductExamineParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        boolean ret = cereShopProductService.examine(param,user);
        if (ret) {
            //刷新实时信息
            projectInvokeUtil.postRefreshSkuRealInfo(param.getProductId(), RefreshSkuRealInfoSourceEnum.PUT_ON_SHELVE);
        }
        return new Result(user.getUsername(),"商品审核", GsonUtil.objectToGson(param));
    }

    /**
     * 设置虚拟销量
     * @param param
     * @return
     */
    @PostMapping(value = "setFictitious")
    @NoRepeatSubmit
    @ApiOperation(value = "设置虚拟销量")
    @NoRepeatWebLog
    public Result setFictitious(@RequestBody ProductUpdateParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereShopProductService.setFictitious(param,user);
        return new Result(user.getUsername(),"设置虚拟销量", GsonUtil.objectToGson(param));
    }

    /**
     * 强制下架
     * @param param
     * @return
     */
    @PostMapping(value = "forced")
    @NoRepeatSubmit
    @ApiOperation(value = "强制下架")
    @NoRepeatWebLog
    public Result forced(@RequestBody ProductUpdateParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereShopProductService.forced(param,user);
        return new Result(user.getUsername(),"强制下架", GsonUtil.objectToGson(param));
    }

    @GetMapping("selectLiveList")
    @ApiOperation("查询直播列表")
    public Result<List<CereLive>> selectLiveList() {
        List<CereLive> result = cereLiveService.selectLiveList();
        return new Result(result);
    }

}
