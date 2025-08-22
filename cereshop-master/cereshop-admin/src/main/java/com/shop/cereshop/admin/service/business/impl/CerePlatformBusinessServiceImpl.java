/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.business.impl;

import com.shop.cereshop.admin.dao.business.CerePlatformBusinessDAO;
import com.shop.cereshop.admin.service.business.CerePlatformBusinessService;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.exception.CoBusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CerePlatformBusinessServiceImpl implements CerePlatformBusinessService {

    @Autowired
    private CerePlatformBusinessDAO cerePlatformBusinessDAO;

    @Override
    public void insert(CerePlatformBusiness cerePlatformBusiness) throws CoBusinessException {
        cerePlatformBusinessDAO.insert(cerePlatformBusiness);
    }

    @Override
    public void update(CerePlatformBusiness cerePlatformBusiness) throws CoBusinessException {
        cerePlatformBusinessDAO.updateByPrimaryKeySelective(cerePlatformBusiness);
    }

    @Override
    public CerePlatformBusiness findByPhone(String phone) {
        return cerePlatformBusinessDAO.findByPhone(phone);
    }
}
