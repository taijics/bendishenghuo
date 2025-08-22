package com.shop.cereshop.business.service.brand.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.shop.cereshop.business.dao.brand.BrandDAO;
import com.shop.cereshop.business.service.brand.BrandService;
import com.shop.cereshop.commons.domain.brand.Brand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BrandServiceImpl implements BrandService {

    @Autowired
    private BrandDAO brandDAO;

    @Override
    public List<Brand> getBrandList() {
        return brandDAO.selectList(Wrappers.emptyWrapper());
    }

}
