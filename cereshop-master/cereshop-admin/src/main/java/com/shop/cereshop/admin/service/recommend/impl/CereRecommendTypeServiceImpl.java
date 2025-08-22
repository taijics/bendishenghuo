package com.shop.cereshop.admin.service.recommend.impl;

import cn.hutool.core.util.ObjectUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.recommend.CereRecommendTypeDAO;
import com.shop.cereshop.admin.page.recommend.CereRecommendTypePage;
import com.shop.cereshop.admin.param.recommend.RecommendTypePageParam;
import com.shop.cereshop.admin.param.recommend.RecommendTypeSaveParam;
import com.shop.cereshop.admin.param.recommend.RecommendTypeUpdateParam;
import com.shop.cereshop.admin.service.recommend.CereRecommendTypeService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.recommend.CereRecommendType;
import com.shop.cereshop.commons.exception.CoBusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CereRecommendTypeServiceImpl implements CereRecommendTypeService {

    @Autowired
    private CereRecommendTypeDAO cereRecommendTypeDAO;

    @Override
    public int save(RecommendTypeSaveParam param) throws CoBusinessException {
        CereRecommendType type = new CereRecommendType();
        type.setName(param.getName());
        if (ObjectUtil.isNotNull(cereRecommendTypeDAO.checkName(type))) {
            throw new CoBusinessException(CoReturnFormat.RECOMMEND_TYPE_REPEAT);
        }
        type.setSort(param.getSort());
        return cereRecommendTypeDAO.insertRecommendType(type);
    }

    @Override
    public int update(RecommendTypeUpdateParam param) throws CoBusinessException {
        CereRecommendType type = new CereRecommendType();
        type.setRecommendTypeId(param.getRecommendTypeId());
        type.setName(param.getName());
        if (ObjectUtil.isNotNull(cereRecommendTypeDAO.checkName(type))) {
            throw new CoBusinessException(CoReturnFormat.RECOMMEND_TYPE_REPEAT);
        }
        return cereRecommendTypeDAO.updateRecommendType(param);
    }

    @Override
    public CereRecommendTypePage get(Long recommendTypeId) {
        return cereRecommendTypeDAO.getRecommendTypeById(recommendTypeId);
    }

    @Override
    public Page<CereRecommendTypePage> page(RecommendTypePageParam param) {
        PageHelper.startPage(param.getPage(), param.getPageSize());
        PageInfo<CereRecommendTypePage> pageInfo = new PageInfo<>(cereRecommendTypeDAO.recommendTypePage(param));
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }


    @Override
    public int delete(Long recommendTypeId) {
        return cereRecommendTypeDAO.deleteRecommendType(recommendTypeId);
    }
}
