package com.shop.cereshop.business.service.recommend.impl;

import com.shop.cereshop.business.dao.recommend.CereRecommendTypeDAO;
import com.shop.cereshop.business.page.recommend.CereRecommendTypeVO;
import com.shop.cereshop.business.service.recommend.CereRecommendTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CereRecommendTypeServiceImpl implements CereRecommendTypeService {

    @Autowired
    private CereRecommendTypeDAO cereRecommendTypeDAO;

    @Override
    public List<CereRecommendTypeVO> getAll() {
        return cereRecommendTypeDAO.getAll();
    }

}
