package com.shop.cereshop.admin.service.brand.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.shop.cereshop.admin.dao.brand.BrandDAO;
import com.shop.cereshop.admin.dao.product.CereShopProductDAO;
import com.shop.cereshop.admin.param.brand.BrandGetAllParam;
import com.shop.cereshop.admin.param.brand.BrandParam;
import com.shop.cereshop.admin.service.brand.BrandService;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BrandServiceImpl implements BrandService {

    @Autowired
    private BrandDAO brandDAO;

    @Autowired
    private CereShopProductDAO cereShopProductDAO;

    @Override
    public int save(BrandParam brand) {
        Brand tmp = new Brand();
        String now = TimeUtils.yyMMddHHmmss();
        BeanUtils.copyProperties(brand, tmp);
        tmp.setCreateTime(now);
        tmp.setUpdateTime(now);
        return brandDAO.insert(tmp);
    }

    @Override
    public int update(BrandParam brand) {
        Brand tmp = new Brand();
        String now = TimeUtils.yyMMddHHmmss();
        BeanUtils.copyProperties(brand, tmp);
        tmp.setUpdateTime(now);
        return brandDAO.updateById(tmp);
    }

    @Override
    public int delete(Long id) {
        cereShopProductDAO.clearBrand(id);
        return brandDAO.deleteById(id);
    }

    @Override
    public Brand getById(Long id) {
        return brandDAO.selectById(id);
    }

    @Override
    public Page<Brand> getAll(BrandGetAllParam param) {
        com.github.pagehelper.Page<Brand> page = PageHelper.startPage(param.getPage(), param.getPageSize());
        List<Brand> brandList = brandDAO.selectList(Wrappers.<Brand>lambdaQuery().orderByDesc(Brand::getCreateTime));
        return new Page<>(brandList, page.getTotal());
    }

}
