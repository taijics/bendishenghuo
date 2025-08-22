package com.shop.cereshop.admin.controller;


import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.admin.page.recommend.CereRecommendTypePage;
import com.shop.cereshop.admin.param.recommend.*;
import com.shop.cereshop.admin.redis.service.api.StringRedisService;
import com.shop.cereshop.admin.service.recommend.CereRecommendTrendsService;
import com.shop.cereshop.admin.service.recommend.CereRecommendTypeService;
import com.shop.cereshop.commons.constant.RedisConstants;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

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
    private CereRecommendTypeService cereRecommendTypeService;

    @Autowired
    private CereRecommendTrendsService cereRecommendTrendsService;

    @Autowired
    private StringRedisService stringRedisService;

    /**
     * 新增种草类型
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/type/save")
    @NoRepeatSubmit
    @ApiOperation(value = "新增种草类型")
    @NoRepeatWebLog
    public Result saveType(@RequestBody @Validated RecommendTypeSaveParam param, HttpServletRequest request) throws CoBusinessException, Exception {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereRecommendTypeService.save(param);
        return new Result(user.getUsername(), "新增种草类型", GsonUtil.objectToGson(param));
    }

    /**
     * 修改种草类型
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/type/update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改种草类型")
    @NoRepeatWebLog
    public Result updateType(@RequestBody @Validated RecommendTypeUpdateParam param, HttpServletRequest request) throws CoBusinessException, Exception {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereRecommendTypeService.update(param);
        return new Result(user.getUsername(), "修改种草类型", GsonUtil.objectToGson(param));
    }

    /**
     * 获取种草类型
     *
     * @param recommendTypeId
     * @return
     */
    @GetMapping(value = "/type/get")
    @ApiOperation(value = "获取种草类型")
    public Result<CereRecommendTypePage> getType(@Validated Long recommendTypeId) throws CoBusinessException, Exception {
        return new Result(cereRecommendTypeService.get(recommendTypeId));
    }

    /**
     * 种草类型分页
     *
     * @param param
     * @return
     */
    @GetMapping(value = "/type/page")
    @ApiOperation(value = "种草类型分页")
    public Result<Page<CereRecommendTypePage>> typePage(@Validated RecommendTypePageParam param) throws CoBusinessException {
        return new Result(cereRecommendTypeService.page(param));
    }

    /**
     * 删除种草类型
     *
     * @param recommendTypeId
     * @return
     */
    @DeleteMapping(value = "/type/delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除种草类型")
    @NoRepeatWebLog
    public Result deleteType(@Validated Long recommendTypeId, HttpServletRequest request) throws CoBusinessException, Exception {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereRecommendTypeService.delete(recommendTypeId);
        return new Result(user.getUsername(), "删除种草类型", GsonUtil.objectToGson(recommendTypeId));
    }

    /**
     * 种草动态分页
     *
     * @param param
     * @return
     */
    @GetMapping(value = "/trends/page")
    @ApiOperation(value = "种草动态分页")
    public Result<Page<CereRecommendTrendsPage>> trendsPage(@Validated RecommendTrendPageParam param) throws CoBusinessException {
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
    public Result<CereRecommendTrendsDetail> getTrends(@Validated Long recommendId) throws CoBusinessException, Exception {
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
    public Result deleteTrends(@Validated Long recommendId, HttpServletRequest request) throws CoBusinessException, Exception {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereRecommendTrendsService.deleteTrends(recommendId);
        return new Result(user.getUsername(), "删除种草动态", GsonUtil.objectToGson(recommendId));
    }

    /**
     * 种草动态审核
     *
     * @param param
     * @return
     */
    @PostMapping(value = "/trends/review")
    @NoRepeatSubmit
    @ApiOperation(value = "种草动态审核")
    @NoRepeatWebLog
    public Result trendsReview(@RequestBody @Validated RecommendTrendReviewParam param, HttpServletRequest request) throws CoBusinessException, Exception {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        cereRecommendTrendsService.trendsReview(param);
        return new Result(user.getUsername(), "种草动态审核", GsonUtil.objectToGson(param));
    }


    /**
     * 设置风控
     *
     * @return
     */
    @GetMapping(value = "/risk-control/set")
    @NoRepeatSubmit
    @ApiOperation(value = "设置风控")
    @NoRepeatWebLog
    public Result setRiskControl(@Validated Boolean enable, HttpServletRequest request){
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        stringRedisService.set(RedisConstants.RISK_CONTROL, enable);
        return new Result(user.getUsername(), "设置风控", GsonUtil.objectToGson(enable));
    }

    /**
     * 获取风控状态
     *
     * @return
     */
    @GetMapping(value = "/risk-control/get")
    @NoRepeatSubmit
    @ApiOperation(value = "获取风控状态")
    @NoRepeatWebLog
    public Result<Boolean> getRiskControl(){
        return new Result(stringRedisService.get(RedisConstants.RISK_CONTROL));
    }


}
