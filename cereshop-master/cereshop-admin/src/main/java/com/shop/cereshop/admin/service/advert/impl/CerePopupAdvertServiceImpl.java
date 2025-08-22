/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.advert.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.advert.CerePopupAdvertDAO;
import com.shop.cereshop.admin.param.advert.CerePopupAdvertParam;
import com.shop.cereshop.admin.service.advert.CerePopupAdvertService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.advert.CerePopupAdvert;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 弹窗广告表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Slf4j
@Service
public class CerePopupAdvertServiceImpl implements CerePopupAdvertService {

    @Autowired
    private CerePopupAdvertDAO cerePopupAdvertDAO;

    @Override
    public Page<CerePopupAdvert> getAll(CerePopupAdvertParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CerePopupAdvert> list=cerePopupAdvertDAO.getAll(param);
        PageInfo<CerePopupAdvert> pageInfo=new PageInfo<>(list);
        Page<CerePopupAdvert> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CerePopupAdvert advert) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        advert.setState(IntegerEnum.NO.getCode());
        advert.setState(IntegerEnum.NO.getCode());
        advert.setCreateTime(time);
        advert.setUpdateTime(time);
        return cerePopupAdvertDAO.insert(advert);
    }

    @Override
    public int update(CerePopupAdvert advert) throws CoBusinessException {
        if (IntegerEnum.YES.getCode().equals(advert.getState())) {
            int count = cerePopupAdvertDAO.checkConflict(advert);
            if (count > 0) {
                throw new CoBusinessException(CoReturnFormat.POPUP_ADVERT_CONFLICT);
            }
        }
        String time = TimeUtils.yyMMddHHmmss();
        advert.setUpdateTime(time);
        return cerePopupAdvertDAO.updateById(advert);
    }

    @Override
    public int delete(Long id) {
        return cerePopupAdvertDAO.deleteById(id);
    }

    @Override
    public int toggleState(Long id, Integer state) throws CoBusinessException {
        if (IntegerEnum.NO.getCode().equals(state)) {
            CerePopupAdvert advert = new CerePopupAdvert();
            advert.setId(id);
            advert.setState(state);
            return cerePopupAdvertDAO.updateById(advert);
        }
        CerePopupAdvert advert = cerePopupAdvertDAO.selectById(id);
        if (advert != null) {
            int count = cerePopupAdvertDAO.checkConflict(advert);
            if (count > 0) {
                throw new CoBusinessException(CoReturnFormat.POPUP_ADVERT_CONFLICT);
            }
            advert.setState(state);
            String time = TimeUtils.yyMMddHHmmss();
            advert.setUpdateTime(time);
            return cerePopupAdvertDAO.updateById(advert);
        }
        return 0;
    }
}
