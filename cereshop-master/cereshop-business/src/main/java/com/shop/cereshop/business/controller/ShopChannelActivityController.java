package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.param.channel.ChannelActivityCouponPageParam;
import com.shop.cereshop.business.param.channel.ChannelActivityGetAllParam;
import com.shop.cereshop.business.param.channel.ChannelActivityParam;
import com.shop.cereshop.business.service.channel.ShopChannelActivityService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.channel.ShopChannelActivity;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereShopCoupon;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * 商家渠道活动
 */
@RestController
@RequestMapping("shopChannelActivity")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "ShopChannelActivityController")
@Api(value = "商家渠道活动控制器", tags = "商家渠道活动控制器")
public class ShopChannelActivityController {

    @Autowired
    private ShopChannelActivityService shopChannelActivityService;

    /**
     * 新增渠道活动
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "新增渠道活动")
    @NoRepeatWebLog
    public Result save(@RequestBody @Validated ChannelActivityParam param, HttpServletRequest request) throws CoBusinessException{
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        shopChannelActivityService.save(param);
        return new Result(user.getUsername(),"新增渠道活动", GsonUtil.objectToGson(param));
    }

    /**
     * 更换账户
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "更换账户")
    @NoRepeatWebLog
    public Result update(@RequestBody ChannelActivityParam param, HttpServletRequest request) throws CoBusinessException{
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        shopChannelActivityService.update(param);
        return new Result(user.getUsername(),"编辑渠道活动", GsonUtil.objectToGson(param));
    }

    /**
     * 删除渠道活动
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除渠道活动")
    @NoRepeatWebLog
    public Result delete(@RequestBody ChannelActivityParam param, HttpServletRequest request) throws CoBusinessException {
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(ContextUtil.getShopId());
        shopChannelActivityService.delete(param);
        return new Result(user.getUsername(),"删除渠道活动", GsonUtil.objectToGson(param));
    }

    /**
     * 收款账户信息查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "收款账户信息查询")
    public Result<ShopChannelActivity> getById(@RequestBody ChannelActivityParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        return new Result<>(shopChannelActivityService.getByIdCheckShopId(param));
    }

    /**
     * 分页查询渠道活动
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "分页查询渠道活动")
    public Result<Page<ShopChannelActivity>> getAll(@RequestBody ChannelActivityGetAllParam param) throws CoBusinessException {
        param.setShopId(ContextUtil.getShopId());
        return new Result<>(shopChannelActivityService.getAll(param));
    }

    /**
     * 分页查询渠道活动
     * @param param
     * @return
     */
    @PostMapping(value = "selectChannelCouponByActivityId")
    @ApiOperation(value = "分页查询渠道活动关联优惠券")
    public Result<Page<CereShopCoupon>> selectChannelCouponByActivityId(@RequestBody ChannelActivityCouponPageParam param) throws CoBusinessException {
        param.setShopId(ContextUtil.getShopId());
        return new Result<>(shopChannelActivityService.selectChannelCouponByActivityId(param));
    }
}
