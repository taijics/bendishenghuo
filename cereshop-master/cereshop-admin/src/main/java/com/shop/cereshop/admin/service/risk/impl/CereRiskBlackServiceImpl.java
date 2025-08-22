/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.risk.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.risk.CereRiskBlackDAO;
import com.shop.cereshop.admin.page.risk.CereRiskUserBlack;
import com.shop.cereshop.admin.param.risk.CereRiskBlackPageParam;
import com.shop.cereshop.admin.service.risk.CereRiskBlackService;
import com.shop.cereshop.admin.utils.EncodeUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.risk.CereRiskBlack;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

/**
 * <p>
 * 业务实现类
 * 黑名单表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-06
 */
@Slf4j
@Service
public class CereRiskBlackServiceImpl implements CereRiskBlackService {

    @Autowired
    private CereRiskBlackDAO cereRiskBlackDAO;

    @Autowired
    private EncodeUtil encodeUtil;

    @Override
    public Page<CereRiskBlack> getAllIpBlackList(CereRiskBlackPageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        LambdaQueryWrapper<CereRiskBlack> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isNotEmpty(param.getIp())) {
            wrapper.like(CereRiskBlack::getIp, "%" + param.getIp() + "%");
        }
        if (param.getState() != null) {
            wrapper.eq(CereRiskBlack::getState, param.getState());
        }
        wrapper.orderByDesc(CereRiskBlack::getUpdateTime);
        List<CereRiskBlack> list=cereRiskBlackDAO.selectList(wrapper);
        PageInfo<CereRiskBlack> pageInfo=new PageInfo<>(list);
        Page<CereRiskBlack> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public Page<CereRiskUserBlack> getUserBlackList(CereRiskBlackPageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereRiskUserBlack> list=cereRiskBlackDAO.getUserBlackList(param);
        for (CereRiskUserBlack black:list) {
            black.setName(encodeUtil.encodeInfo(black.getName()));
            black.setPhone(encodeUtil.encodePhone(black.getPhone()));
            black.setOpenId(encodeUtil.encodeInfo(black.getOpenId()));
        }
        PageInfo<CereRiskUserBlack> pageInfo=new PageInfo<>(list);
        Page<CereRiskUserBlack> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CereRiskBlack param) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        param.setCreateTime(time);
        param.setUpdateTime(time);
        if (IntegerEnum.RISK_BLACK_TYPE_IP.getCode().equals(param.getType())) {
            String[] ipArr = StringUtils.trimToEmpty(param.getIp()).split(",");
            if (ipArr.length == 0) {
                return 0;
            }
            List<String> ipList = Arrays.asList(ipArr);
            LambdaQueryWrapper<CereRiskBlack> wrapper = new LambdaQueryWrapper<>();
            wrapper.in(CereRiskBlack::getIp, ipList);
            int count = cereRiskBlackDAO.selectCount(wrapper);
            if (count > 0) {
                throw new CoBusinessException(CoReturnFormat.RISK_BLACK_IP_EXISTS);
            }
            count = 0;
            for (String ip:ipList) {
                CereRiskBlack cereRiskBlack = new CereRiskBlack();
                BeanUtils.copyProperties(param, cereRiskBlack);
                cereRiskBlack.setIp(ip);
                count += cereRiskBlackDAO.insert(cereRiskBlack);
            }
            return count;
        } else {
            return cereRiskBlackDAO.insert(param);
        }
    }

    @Override
    public int update(CereRiskBlack param) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        param.setUpdateTime(time);
        param.setIp(null);
        param.setBuyerUserId(null);
        param.setType(null);
        return cereRiskBlackDAO.updateById(param);
    }

    @Override
    public int delete(CereRiskBlack param) {
        return cereRiskBlackDAO.deleteById(param.getId());
    }

}
