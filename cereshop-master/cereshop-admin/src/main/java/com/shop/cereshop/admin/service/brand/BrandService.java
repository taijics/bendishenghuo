package com.shop.cereshop.admin.service.brand;

import com.shop.cereshop.admin.param.brand.BrandGetAllParam;
import com.shop.cereshop.admin.param.brand.BrandParam;
import com.shop.cereshop.commons.domain.brand.Brand;
import com.shop.cereshop.commons.domain.common.Page;

public interface BrandService {

    int save(BrandParam brand);

    int update(BrandParam brand);

    int delete(Long id);

    Brand getById(Long id);

    Page<Brand> getAll(BrandGetAllParam param);

}
