/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.risk.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.risk.CereRiskRuleDAO;
import com.shop.cereshop.admin.service.risk.CereRiskRuleService;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.risk.CereRiskRule;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 风控规则表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-06
 */
@Slf4j
@Service
public class CereRiskRuleServiceImpl implements CereRiskRuleService {

    @Autowired
    private CereRiskRuleDAO cereRiskRuleDAO;

    @Override
    public Page<CereRiskRule> getAllRiskRule(PageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        LambdaQueryWrapper<CereRiskRule> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(CereRiskRule::getUpdateTime);
        List<CereRiskRule> list = cereRiskRuleDAO.selectList(wrapper);
        PageInfo<CereRiskRule> pageInfo=new PageInfo<>(list);
        Page<CereRiskRule> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CereRiskRule param) {
        String time = TimeUtils.yyMMddHHmmss();
        param.setCreateTime(time);
        param.setUpdateTime(time);
        return cereRiskRuleDAO.insert(param);
    }

    @Override
    public int update(CereRiskRule param) {
        String time = TimeUtils.yyMMddHHmmss();
        param.setUpdateTime(time);
        if (IntegerEnum.YES.getCode().equals(param.getStatus())) {
            cereRiskRuleDAO.switchOffAll();
        }
        return cereRiskRuleDAO.updateById(param);
    }

    @Override
    public int delete(CereRiskRule param) {
        return cereRiskRuleDAO.deleteById(param.getId());
    }
}
