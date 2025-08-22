package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.page.credit.CereCreditRecordPage;
import com.shop.cereshop.admin.page.risk.CereRiskUserBlack;
import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.admin.param.risk.CereRiskBlackPageParam;
import com.shop.cereshop.admin.service.risk.CereRiskBlackService;
import com.shop.cereshop.admin.service.risk.CereRiskRuleService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.risk.CereRiskBlack;
import com.shop.cereshop.commons.domain.risk.CereRiskRule;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiModelProperty;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 风控模块
 */
@RestController
@RequestMapping("risk")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "RiskController")
@Api(value = "风控模块", tags = "风控模块")
public class RiskController {

    @Autowired
    private CereRiskBlackService cereRiskBlackService;

    @Autowired
    private CereRiskRuleService cereRiskRuleService;

    /**
     * 查询ip黑名单列表
     * @param param
     * @return
     */
    @PostMapping(value = "getAllIpBlackList")
    @ApiOperation(value = "查询ip黑名单列表")
    public Result<Page<CereRiskBlack>> getAllIpBlackList(@RequestBody CereRiskBlackPageParam param) throws CoBusinessException {
        Page page=cereRiskBlackService.getAllIpBlackList(param);
        return new Result(page);
    }

    /**
     * 查询用户黑名单列表
     * @param param
     * @return
     */
    @PostMapping(value = "getAllUserBlackList")
    @ApiOperation(value = "查询用户黑名单列表")
    public Result<Page<CereRiskUserBlack>> getAllUserBlackList(@RequestBody CereRiskBlackPageParam param) throws CoBusinessException {
        Page page=cereRiskBlackService.getUserBlackList(param);
        return new Result(page);
    }

    /**
     * 新增ip或用户黑名单
     * @param param
     * @return
     */
    @PostMapping(value = "saveRiskBlack")
    @ApiOperation(value = "新增ip或用户黑名单")
    public Result<Integer> saveRiskBlack(@RequestBody CereRiskBlack param) throws CoBusinessException {
        int result = cereRiskBlackService.save(param);
        return new Result(result);
    }

    /**
     * 更新ip或用户黑名单
     * @param param
     * @return
     */
    @PostMapping(value = "updateRiskBlack")
    @ApiOperation(value = "更新ip或用户黑名单")
    public Result<Integer> updateRiskBlack(@RequestBody CereRiskBlack param) throws CoBusinessException {
        int result = cereRiskBlackService.update(param);
        return new Result(result);
    }

    /**
     * 删除ip或用户黑名单
     * @param param
     * @return
     */
    @PostMapping(value = "deleteRiskBlack")
    @ApiOperation(value = "删除ip或用户黑名单")
    public Result<Integer> deleteRiskBlack(@RequestBody CereRiskBlack param) throws CoBusinessException {
        int result = cereRiskBlackService.delete(param);
        return new Result(result);
    }

    /**
     * 查询规则列表
     * @param param
     * @return
     */
    @PostMapping(value = "getAllRiskRule")
    @ApiOperation(value = "查询规则列表")
    public Result<Page<CereRiskRule>> getAllRiskRule(@RequestBody PageParam param) throws CoBusinessException {
        Page page = cereRiskRuleService.getAllRiskRule(param);
        return new Result(page);
    }

    /**
     * 新增规则配置
     * @param param
     * @return
     */
    @PostMapping(value = "saveRiskRule")
    @ApiOperation(value = "新增规则配置")
    public Result<Integer> saveRiskRule(@RequestBody CereRiskRule param) throws CoBusinessException {
        int result = cereRiskRuleService.save(param);
        return new Result(result);
    }

    /**
     * 更新规则配置
     * @param param
     * @return
     */
    @PostMapping(value = "updateRiskRule")
    @ApiOperation(value = "更新规则配置")
    public Result<Integer> updateRiskRule(@RequestBody CereRiskRule param) throws CoBusinessException {
        int result = cereRiskRuleService.update(param);
        return new Result(result);
    }

    /**
     * 删除规则配置
     * @param param
     * @return
     */
    @PostMapping(value = "deleteRiskRule")
    @ApiOperation(value = "删除规则配置")
    public Result<Integer> deleteRiskRule(@RequestBody CereRiskRule param) throws CoBusinessException {
        int result = cereRiskRuleService.delete(param);
        return new Result(result);
    }
}
