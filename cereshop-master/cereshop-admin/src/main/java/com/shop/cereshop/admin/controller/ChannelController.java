package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.param.channel.ChannelGetAllParam;
import com.shop.cereshop.admin.param.channel.ChannelParam;
import com.shop.cereshop.admin.service.channel.ChannelService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.dict.CerePlatformDict;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
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
 * 渠道模块
 */
@RestController
@RequestMapping("channel")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "ChannelController")
@Api(value = "渠道模块", tags = "渠道模块")
public class ChannelController {

    @Autowired
    private ChannelService channelService;

    /**
     * 添加渠道
     *
     * @param param
     * @return
     */
    @PostMapping(value = "save")
    @NoRepeatSubmit
    @ApiOperation(value = "添加渠道")
    @NoRepeatWebLog
    public Result save(@RequestBody @Validated ChannelParam param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        channelService.save(param, user);
        return new Result(user.getUsername(), "添加渠道", GsonUtil.objectToGson(param));
    }

    /**
     * 修改渠道
     *
     * @param param
     * @return
     */
    @PostMapping(value = "update")
    @NoRepeatSubmit
    @ApiOperation(value = "修改渠道")
    @NoRepeatWebLog
    public Result update(@RequestBody ChannelParam param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        channelService.update(param, user);
        return new Result(user.getUsername(), "修改渠道", GsonUtil.objectToGson(param));
    }

    /**
     * 删除渠道
     *
     * @param param
     * @return
     */
    @PostMapping(value = "delete")
    @NoRepeatSubmit
    @ApiOperation(value = "删除渠道")
    @NoRepeatWebLog
    public Result delete(@RequestBody ChannelParam param, HttpServletRequest request) throws CoBusinessException {
        //获取当前登录账户
        CerePlatformUser user = (CerePlatformUser) request.getAttribute("user");
        channelService.delete(param, user);
        return new Result(user.getUsername(), "删除渠道", GsonUtil.objectToGson(param));
    }

    /**
     * 渠道管理查询
     *
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "渠道管理查询")
    public Result<Page<CerePlatformDict>> getAll(@RequestBody ChannelGetAllParam param) throws CoBusinessException {
        Page page = channelService.getAll(param);
        return new Result(page);
    }

}
