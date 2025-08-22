/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.business.service.customer_service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.shop.cereshop.business.dao.customer_service.CereCustomerServiceDAO;
import com.shop.cereshop.business.dao.customer_service.CereCustomerServiceReceptionistDAO;
import com.shop.cereshop.business.service.customer_service.CereCustomerServiceService;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.customer_service.CereCustomerService;
import com.shop.cereshop.commons.domain.customer_service.CereCustomerServiceReceptionist;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 客服表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-08
 */
@Slf4j
@Service
public class CereCustomerServiceServiceImpl implements CereCustomerServiceService {
/*
    @Autowired
    private CereCustomerServiceDAO cereCustomerServiceDAO;

    @Autowired
    private CereCustomerServiceReceptionistDAO cereCustomerServiceReceptionistDAO;

    @Override
    public int save(CereCustomerService param) {
        String time = TimeUtils.yyMMddHHmmss();
        param.setCreateTime(time);
        param.setUpdateTime(time);
        param.setState(IntegerEnum.YES.getCode());
        return cereCustomerServiceDAO.insert(param);
    }

    @Override
    public int update(CereCustomerService param) {
        String time = TimeUtils.yyMMddHHmmss();
        param.setUpdateTime(time);
        param.setState(IntegerEnum.YES.getCode());
        return cereCustomerServiceDAO.updateById(param);
    }

    @Override
    public int delete(Long shopId, Long id) {
        LambdaQueryWrapper<CereCustomerServiceReceptionist> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CereCustomerServiceReceptionist::getServiceId, id);
        cereCustomerServiceReceptionistDAO.delete(wrapper);

        LambdaQueryWrapper<CereCustomerService> wrapper2 = new LambdaQueryWrapper<>();
        wrapper2.eq(CereCustomerService::getShopId, shopId);
        wrapper2.eq(CereCustomerService::getId, id);
        cereCustomerServiceReceptionistDAO.delete(wrapper);
        return cereCustomerServiceDAO.delete(wrapper2);
    }

    @Override
    public CereCustomerService getById(Long id) {
        return cereCustomerServiceDAO.selectById(id);
    }

    @Override
    public int saveReceptionist(CereCustomerServiceReceptionist param) {
        String time = TimeUtils.yyMMddHHmmss();
        param.setCreateTime(time);
        param.setUpdateTime(time);
        param.setState(IntegerEnum.NO.getCode());
        return cereCustomerServiceReceptionistDAO.insert(param);
    }

    @Override
    public int deleteReceptionist(Long id) {
        return cereCustomerServiceReceptionistDAO.deleteById(id);
    }

    @Override
    public List<CereCustomerService> getAll() {
        return cereCustomerServiceDAO.selectList(new QueryWrapper<>());
    }

    @Override
    public List<CereCustomerServiceReceptionist> getAllReceptionist(Long serviceId) {
        LambdaQueryWrapper<CereCustomerServiceReceptionist> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CereCustomerServiceReceptionist::getServiceId, serviceId);
        return cereCustomerServiceReceptionistDAO.selectList(wrapper);
    }*/

}
