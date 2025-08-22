/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.shop.impl;

import com.shop.cereshop.business.dao.shop.CereShopOtherOrganizationsDAO;
import com.shop.cereshop.business.param.shop.CereShopOtherOrganizationsParam;
import com.shop.cereshop.business.service.business.CereBusinessShopService;
import com.shop.cereshop.business.service.business.CerePlatformBusinessService;
import com.shop.cereshop.business.service.common.CommonService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.business.service.shop.CerePlatformShopService;
import com.shop.cereshop.business.service.shop.CereShopOtherOrganizationsService;
import com.shop.cereshop.business.utils.TokenProvider;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.business.CereBusinessShop;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.shop.CerePlatformShop;
import com.shop.cereshop.commons.domain.shop.CereShopOtherOrganizations;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EncryptUtil;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CereShopOtherOrganizationsServiceImpl implements CereShopOtherOrganizationsService {

    @Autowired
    private CereShopOtherOrganizationsDAO cereShopOtherOrganizationsDAO;

    @Autowired
    private CerePlatformShopService cerePlatformShopService;

    @Autowired
    private CommonService commonService;

    @Autowired
    private CerePlatformBusinessService cerePlatformBusinessService;

    @Autowired
    private CereBusinessShopService cereBusinessShopService;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private TokenProvider tokenProvider;

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void organizations(CereShopOtherOrganizations otherOrganizations, CerePlatformBusiness user) throws CoBusinessException {
        String time= TimeUtils.yyMMddHHmmss();
        otherOrganizations.setCreateTime(time);
        cereShopOtherOrganizationsDAO.insert(otherOrganizations);
        //更新店铺认证状态
        CerePlatformShop cerePlatformShop=new CerePlatformShop();
        cerePlatformShop.setShopId(otherOrganizations.getShopId());
        cerePlatformShop.setAuthenticationState(IntegerEnum.UNDER_REVIEW.getCode());
        cerePlatformShop.setAuthenType(IntegerEnum.ORGANIZATION.getCode());
        cerePlatformShop.setUpdateTime(time);
        cerePlatformShopService.updateState(cerePlatformShop);
        //新增日志
        cerePlatformLogService.addLog(user,"店铺管理","商户端操作","提交其他组织认证信息",otherOrganizations.getShopId(),time);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void updateOrganizations(CereShopOtherOrganizations otherOrganizations, CerePlatformBusiness user) throws CoBusinessException {
        String time= TimeUtils.yyMMddHHmmss();
        otherOrganizations.setUpdateTime(time);
        cereShopOtherOrganizationsDAO.updateData(otherOrganizations);
        //新增日志
        cerePlatformLogService.addLog(user,"店铺管理","商户端操作","修改其他组织认证信息",otherOrganizations.getShopId(),time);
    }

    @Override
    public CereShopOtherOrganizations findByShopId(Long shopId) {
        return cereShopOtherOrganizationsDAO.findByShopId(shopId);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void organizationsCheck(CereShopOtherOrganizationsParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time=TimeUtils.yyMMddHHmmss();
        //新增店铺数据
        CerePlatformShop cerePlatformShop=new CerePlatformShop();
        cerePlatformShop.setShopPhone(param.getShopPhone());
        cerePlatformShop.setShopCode(commonService.getShopCode());
        cerePlatformShop.setAuthenticationState(IntegerEnum.UNDER_REVIEW.getCode());
        cerePlatformShop.setAuthenType(IntegerEnum.ORGANIZATION.getCode());
        cerePlatformShop.setCheckState(IntegerEnum.UNTREATED.getCode());
        cerePlatformShop.setCreateTime(time);
        cerePlatformShop.setShopName(param.getShopName());
        cerePlatformShop.setChargePersonName(param.getChargePersonName());
        cerePlatformShop.setChargePersonPhone(param.getChargePersonPhone());
        cerePlatformShop.setShopAdressProvince(param.getShopAdressProvince());
        cerePlatformShop.setShopAdressCity(param.getShopAdressCity());
        cerePlatformShop.setShopAdressDetail(param.getShopAdressDetail());
        cerePlatformShop.setShopAdress(param.getShopAdressProvince() + param.getShopAdressCity() + StringUtils.trimToEmpty(param.getShopAdressDetail()));
        cerePlatformShop.setState(IntegerEnum.YES.getCode());
        cerePlatformShop.setContractState(IntegerEnum.YES.getCode());
        cerePlatformShop.setEffectiveDate(time);
        cerePlatformShop.setEffectiveYear(1);
        cerePlatformShop.setShopPassword(EncryptUtil.encrypt("123456"));
        cerePlatformShopService.insert(cerePlatformShop);
        //同步新增商家用户数据
        CerePlatformBusiness cerePlatformBusiness=new CerePlatformBusiness();
        cerePlatformBusiness.setCreateTime(time);
        cerePlatformBusiness.setUsername(cerePlatformShop.getShopPhone());
        cerePlatformBusiness.setPassword(cerePlatformShop.getShopPassword());
        cerePlatformBusiness.setName(cerePlatformShop.getChargePersonName());
        cerePlatformBusiness.setState(IntegerEnum.YES.getCode());
        cerePlatformBusinessService.insert(cerePlatformBusiness);
        //同步新增商家用户绑定店铺数据
        CereBusinessShop cereBusinessShop=new CereBusinessShop();
        cereBusinessShop.setBusinessUserId(cerePlatformBusiness.getBusinessUserId());
        cereBusinessShop.setShopId(cerePlatformShop.getShopId());
        cereBusinessShop.setIfBinding(IntegerEnum.YES.getCode());
        cereBusinessShopService.insert(cereBusinessShop);
        //新增店铺认证个人数据
        param.setCreateTime(time);
        param.setShopId(cereBusinessShop.getShopId());
        cereShopOtherOrganizationsDAO.insertSelective(param);
        //新增日志 这里没有user，所以new一个，并且设置userId 为shopId
        user = new CerePlatformBusiness();
        user.setBusinessUserId(cerePlatformShop.getShopId());
        cerePlatformLogService.addLog(user,"入驻申请","商户端操作","提交其他组织入驻申请",cerePlatformShop.getShopId(),time);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void updateOrganizationsCheck(CereShopOtherOrganizationsParam param, CerePlatformBusiness user) throws CoBusinessException {
        //更新店铺数据
        String time=TimeUtils.yyMMddHHmmss();
        CerePlatformShop cerePlatformShop=new CerePlatformShop();
        cerePlatformShop.setShopId(param.getShopId());
        cerePlatformShop.setShopName(param.getShopName());
        cerePlatformShop.setShopPhone(param.getShopPhone());
        cerePlatformShop.setChargePersonPhone(param.getChargePersonPhone());
        cerePlatformShop.setChargePersonName(param.getChargePersonName());
        cerePlatformShop.setShopAdressProvince(param.getShopAdressProvince());
        cerePlatformShop.setShopAdressCity(param.getShopAdressCity());
        cerePlatformShop.setShopAdressDetail(param.getShopAdressDetail());
        cerePlatformShop.setShopAdress(param.getShopAdressProvince() + param.getShopAdressCity() + StringUtils.trimToEmpty(param.getShopAdressDetail()));
        cerePlatformShop.setUpdateTime(time);
        cerePlatformShopService.update(cerePlatformShop);
        //查询是否存在认证数据
        CereShopOtherOrganizations cereShopOtherOrganizations=cereShopOtherOrganizationsDAO.findByShopId(param.getShopId());
        if(cereShopOtherOrganizations!=null){
            //更新认证数据
            param.setUpdateTime(time);
            cereShopOtherOrganizationsDAO.updateParam(param);
        }else {
            //新增认证数据
            param.setCreateTime(time);
            cereShopOtherOrganizationsDAO.insertParam(param);
        }
        //新增日志 这里没有user，所以new一个，并且设置userId 为shopId
        user = new CerePlatformBusiness();
        user.setBusinessUserId(cerePlatformShop.getShopId());
        cerePlatformLogService.addLog(user,"入驻申请","商户端操作","修改其他组织入驻申请",cerePlatformShop.getShopId(),time);
    }
}
