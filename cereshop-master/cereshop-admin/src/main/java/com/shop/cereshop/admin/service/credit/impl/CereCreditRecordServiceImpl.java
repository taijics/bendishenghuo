/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.credit.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.credit.CereCreditRecordDAO;
import com.shop.cereshop.admin.page.credit.CereCreditRecordPage;
import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.admin.service.credit.CereCreditRecordService;
import com.shop.cereshop.admin.utils.EncodeUtil;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 积分流水表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Slf4j
@Service
public class CereCreditRecordServiceImpl implements CereCreditRecordService {

    @Autowired
    private CereCreditRecordDAO cereCreditRecordDAO;

    @Autowired
    private EncodeUtil encodeUtil;

    @Override
    public Page getAll(CreditRecordGetAllParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereCreditRecordPage> list=cereCreditRecordDAO.getAll(param);
        for (CereCreditRecordPage record:list) {
            record.setName(encodeUtil.encodeInfo(record.getName()));
            record.setPhone(encodeUtil.encodePhone(record.getPhone()));
        }
        PageInfo<CereCreditRecordPage> pageInfo=new PageInfo<>(list);
        Page<CereCreditRecordPage> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }
}
