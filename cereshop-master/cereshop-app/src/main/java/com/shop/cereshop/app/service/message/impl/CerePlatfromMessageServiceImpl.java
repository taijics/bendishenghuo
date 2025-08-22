/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.app.service.message.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.app.dao.message.CerePlatfromMessageDAO;
import com.shop.cereshop.app.param.message.MessageDeleteParam;
import com.shop.cereshop.app.param.message.MessageGetAllParam;
import com.shop.cereshop.app.param.message.MessageSaveParam;
import com.shop.cereshop.app.param.message.MessageUpdateParam;
import com.shop.cereshop.app.service.log.CerePlatformLogService;
import com.shop.cereshop.app.service.message.CerePlatfromMessageService;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.message.CerePlatfromMessage;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CerePlatfromMessageServiceImpl implements CerePlatfromMessageService {

    @Autowired
    private CerePlatfromMessageDAO cerePlatfromMessageDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void save(MessageSaveParam param, CereBuyerUser user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        CerePlatfromMessage message=new CerePlatfromMessage();
        //新增短信模板
        message.setCreateTime(time);
        message.setMessageProject(param.getMessageProject());
        message.setMessageTemplate(param.getMessageTemplate());
        message.setTemplateCode(param.getTemplateCode());
        message.setTemplateDescribe(param.getTemplateDescribe());
        message.setTemplateSign(param.getTemplateSign());
        cerePlatfromMessageDAO.insert(message);
        //新增日志
        cerePlatformLogService.addLog(user,"短信配置","平台端操作","添加短信模板",message.getMessageId(),time);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void update(MessageUpdateParam param, CereBuyerUser user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        CerePlatfromMessage message=new CerePlatfromMessage();
        //修改短信模板
        message.setUpdateTime(time);
        message.setMessageProject(param.getMessageProject());
        message.setMessageTemplate(param.getMessageTemplate());
        message.setTemplateCode(param.getTemplateCode());
        message.setTemplateDescribe(param.getTemplateDescribe());
        message.setTemplateSign(param.getTemplateSign());
        cerePlatfromMessageDAO.updateByPrimaryKeySelective(message);
        //新增日志
        cerePlatformLogService.addLog(user,"短信配置","平台端操作","修改短信模板",message.getMessageId(),time);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void delete(MessageDeleteParam param, CereBuyerUser user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        //删除短信模板
        cerePlatfromMessageDAO.deleteByPrimaryKey(param.getMessageId());
        //新增日志
        cerePlatformLogService.addLog(user,"短信配置","平台端操作","删除短信模板",param.getMessageId(),time);
    }

    @Override
    public CerePlatfromMessage getById(Long messageId) throws CoBusinessException {
        return cerePlatfromMessageDAO.getById(messageId);
    }

    @Override
    public Page getAll(MessageGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CerePlatfromMessage> list=cerePlatfromMessageDAO.getAll(param);
        PageInfo<CerePlatfromMessage> pageInfo=new PageInfo<>(list);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }
}
