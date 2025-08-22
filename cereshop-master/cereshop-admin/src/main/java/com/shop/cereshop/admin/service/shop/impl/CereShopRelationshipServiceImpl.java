/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.shop.impl;

import com.shop.cereshop.admin.dao.shop.CereShopRelationshipDAO;
import com.shop.cereshop.admin.service.shop.CereShopRelationshipService;
import com.shop.cereshop.commons.domain.shop.CereShopRelationship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CereShopRelationshipServiceImpl implements CereShopRelationshipService {

    @Autowired
    private CereShopRelationshipDAO cereShopRelationshipDAO;

    @Override
    public int save(CereShopRelationship relationship) {
        return cereShopRelationshipDAO.insert(relationship);
    }
}
