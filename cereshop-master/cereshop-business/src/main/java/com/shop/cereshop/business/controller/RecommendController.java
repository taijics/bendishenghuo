package com.shop.cereshop.business.controller;


import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.page.recommend.CereRecommendCommentPage;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.business.page.recommend.CereRecommendTypeVO;
import com.shop.cereshop.business.param.recommend.*;
import com.shop.cereshop.business.service.recommend.CereRecommendCommentService;
import com.shop.cereshop.business.service.recommend.CereRecommendTrendsService;
import com.shop.cereshop.business.service.recommend.CereRecommendTypeService;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 种草模块
 */
@RestController
@RequestMapping("recommend")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "RecommendController")
@Api(value = "种草模块", tags = "种草模块")
public class RecommendController {


    @Autowired
    private CereRecommendTrendsService cereRecommendTrendsService;

    @Autowired
    private CereRecommendTypeService cereRecommendTypeService;

    @Autowired
    private CereRecommendCommentService cereRecommendCommentService;


    /**
     * 新增种草动态
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/trends/save")
    @NoRepeatSubmit
    @ApiOperation(value = "新增种草动态")
    public Result saveTrends(@Validated @RequestBody RecommendTrendsSaveParam param, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        cereRecommendTrendsService.saveTrends(param);
        return new Result(user.getUsername(), "新增种草动态", GsonUtil.objectToGson(param));
    }

    /**
     * 修改种草动态
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/trends/update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改种草动态")
    public Result updateTrends(@Validated @RequestBody RecommendTrendsUpdateParam param, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        cereRecommendTrendsService.updateTrends(param);
        return new Result(user.getUsername(), "修改种草动态", GsonUtil.objectToGson(param));
    }

    /**
     * 种草动态分页
     *
     * @param param
     * @return
     */
    @GetMapping(value = "/trends/page")
    @ApiOperation(value = "种草动态分页")
    public Result<Page<CereRecommendTrendsPage>> trendsPage(@Validated RecommendTrendPageParam param, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        return new Result(cereRecommendTrendsService.trendsPage(param));
    }

    /**
     * 获取种草动态明细
     *
     * @param recommendId
     * @return
     */
    @GetMapping(value = "/trends/get")
    @ApiOperation(value = "获取种草动态明细")
    public Result<CereRecommendTrendsDetail> getTrends(@Validated Long recommendId){
        return new Result(cereRecommendTrendsService.getTrendsDetail(recommendId));
    }

    /**
     * 删除种草动态
     *
     * @param recommendId
     * @return
     */
    @DeleteMapping(value = "/trends/delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除种草动态")
    public Result deleteTrends(@Validated Long recommendId, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereRecommendTrendsService.deleteTrends(recommendId);
        return new Result(user.getUsername(), "删除种草动态", GsonUtil.objectToGson(recommendId));
    }

    /**
     * 获取所有种草类型
     *
     * @return
     */
    @GetMapping(value = "/type/getAll")
    @ApiOperation(value = "获取所有种草类型")
    public Result<List<CereRecommendTypeVO>> getAllType(){
        return new Result(cereRecommendTypeService.getAll());
    }

    /**
     * 种草评论分页
     *
     * @param param
     * @return
     */
    @GetMapping(value = "/comment/page")
    @ApiOperation(value = "种草评论分页")
    public Result<Page<CereRecommendCommentPage>> commentPage(@Validated RecommendCommentPageParam param, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId());
        return new Result(cereRecommendCommentService.commentPage(param));
    }

    /**
     * 删除种草评论
     *
     * @param recommendCommentId
     * @return
     */
    @DeleteMapping(value = "/comment/delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除种草评论")
    public Result deleteComment(@Validated Long recommendCommentId, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereRecommendCommentService.deleteComment(recommendCommentId);
        return new Result(user.getUsername(), "删除种草评论", GsonUtil.objectToGson(recommendCommentId));
    }

    /**
     * 种草评论回复
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/comment/reply")
    @NoRepeatSubmit
    @ApiOperation(value = "种草评论回复")
    public Result replyComment(@Validated @RequestBody RecommendCommentReplyParam param, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setUserId(user.getBusinessUserId());
        cereRecommendCommentService.replyComment(param);
        return new Result(user.getUsername(), "种草评论回复", GsonUtil.objectToGson(param));
    }
}
