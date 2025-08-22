/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.credit.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.credit.CereCreditSignSettingDAO;
import com.shop.cereshop.admin.service.credit.CereCreditSignSettingService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.credit.CereCreditSignSetting;
import com.shop.cereshop.commons.exception.CoBusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 积分签到配置
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Slf4j
@Service
public class CereCreditSignSettingServiceImpl implements CereCreditSignSettingService {

    @Autowired
    private CereCreditSignSettingDAO cereCreditSignSettingDAO;

    @Override
    public Page getAll(PageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereCreditSignSetting> list=cereCreditSignSettingDAO.getAll(param);
        PageInfo<CereCreditSignSetting> pageInfo=new PageInfo<>(list);
        Page<CereCreditSignSetting> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CereCreditSignSetting param) throws CoBusinessException {
        int count = cereCreditSignSettingDAO.selectExistsDay(param.getDay(), param.getId());
        if (count > 0) {
            throw new CoBusinessException(CoReturnFormat.CREDIT_SETTING_EXISTS);
        }
        return cereCreditSignSettingDAO.insert(param);
    }

    @Override
    public int update(CereCreditSignSetting param) throws CoBusinessException {
        int count = cereCreditSignSettingDAO.selectExistsDay(param.getDay(), param.getId());
        if (count > 0) {
            throw new CoBusinessException(CoReturnFormat.CREDIT_SETTING_EXISTS);
        }
        return cereCreditSignSettingDAO.updateById(param);
    }

    @Override
    public int delete(Long id) {
        return cereCreditSignSettingDAO.deleteById(id);
    }
}
