/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.buyer.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.buyer.CereBuyerUserDAO;
import com.shop.cereshop.admin.dao.credit.CereCreditRecordDAO;
import com.shop.cereshop.admin.page.buyer.BuyerUser;
import com.shop.cereshop.admin.page.buyer.BuyerUserDetail;
import com.shop.cereshop.admin.param.buyer.*;
import com.shop.cereshop.admin.param.credit.UpdateCreditParam;
import com.shop.cereshop.admin.param.user.UserSearchParam;
import com.shop.cereshop.admin.service.buyer.CereBuyerUserService;
import com.shop.cereshop.admin.service.label.CereBuyerLabelService;
import com.shop.cereshop.admin.service.log.CerePlatformLogService;
import com.shop.cereshop.admin.utils.EncodeUtil;
import com.shop.cereshop.commons.cache.constants.CacheKeyConstants;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.CreditOptTypeEnum;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.buyer.CereBuyerReceive;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.credit.CereCreditRecord;
import com.shop.cereshop.commons.domain.label.CereBuyerLabel;
import com.shop.cereshop.commons.domain.label.CerePlatformLabel;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
public class CereBuyerUserServiceImpl implements CereBuyerUserService {

    @Autowired
    private CereBuyerUserDAO cereBuyerUserDAO;

    @Autowired
    private CereBuyerLabelService cereBuyerLabelService;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private RedissonClient redissonClient;

    @Autowired
    private CereCreditRecordDAO cereCreditRecordDAO;

    @Autowired
    private EncodeUtil encodeUtil;

    @Override
    public Page<BuyerUser> getAll(BuyerGetAllParam param) throws CoBusinessException {
        if (param.getPage() != null && param.getPageSize() != null) {
            PageHelper.startPage(param.getPage(),param.getPageSize());
        }
        long start = System.currentTimeMillis();
        log.info("start " + start);
        List<BuyerUser> list = cereBuyerUserDAO.getAll(param);
        log.info("end " + (System.currentTimeMillis() - start));
        for(BuyerUser user:list) {
            List<Long> labelIds = cereBuyerLabelService.findByBuyerUserId(user.getBuyerUserId());
            user.setLabelIds(labelIds);
            user.setPhone(encodeUtil.encodePhone(user.getPhone()));
            user.setName(encodeUtil.encodeInfo(user.getName()));
        }
        PageInfo<BuyerUser> pageInfo=new PageInfo<>(list);
        Page<BuyerUser> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public BuyerUserDetail getById(BuyerGetByIdParam param) throws CoBusinessException {
        //查询客户数据
        BuyerUserDetail detail=cereBuyerUserDAO.getById(param.getBuyerUserId());
        if(detail!=null){
            detail.setName(encodeUtil.encodeInfo(detail.getName()));
            detail.setPhone(encodeUtil.encodePhone(detail.getPhone()));
            //查询用户标签数据
            detail.setLabels(cereBuyerUserDAO.findLabels(param.getBuyerUserId()));
            //查询标签id
            detail.setLabelIds(cereBuyerLabelService.findByBuyerUserId(detail.getBuyerUserId()));
            //查询下单数
            detail.setOrders(cereBuyerUserDAO.findOrders(param.getBuyerUserId()));
            //查询支付成功数
            detail.setPays(cereBuyerUserDAO.findPays(param.getBuyerUserId()));
            //查询购买商品数
            detail.setProducts(cereBuyerUserDAO.findProducts(param.getBuyerUserId()));
            //查询累计消费额
            detail.setPrice(cereBuyerUserDAO.findPrice(param.getBuyerUserId()));
            //查询售后次数
            detail.setAfters(cereBuyerUserDAO.findAfters(param.getBuyerUserId()));
            //查询售后单数
            detail.setAfterOrders(cereBuyerUserDAO.findAfterOrders(param.getBuyerUserId()));
            //查询售后成功单数
            detail.setSuccessAfters(cereBuyerUserDAO.findSuccessAfters(param.getBuyerUserId()));
            //查询订单列表
            detail.setOrderList(cereBuyerUserDAO.findOrderList(param));
            //查询评论列表
            detail.setComments(cereBuyerUserDAO.findComments(param.getBuyerUserId()));
            //查询收货地址列表
            List<CereBuyerReceive> receiveList = cereBuyerUserDAO.findReceives(param.getBuyerUserId());
            for (CereBuyerReceive receive:receiveList) {
                receive.setReceivePhone(encodeUtil.encodePhone(receive.getReceivePhone()));
                receive.setReceiveName(encodeUtil.encodeInfo(receive.getReceiveName()));
                receive.setReceiveAdress(encodeUtil.encodeInfo(receive.getReceiveAdress()));
                receive.setAddress(encodeUtil.encodeInfo(receive.getAddress()));
            }
            detail.setReceives(receiveList);
        }
        return detail;
    }

    @Override
    public List<CerePlatformLabel> getLabels(BuyerGetLabelsParam param) throws CoBusinessException {
        return cereBuyerUserDAO.getLabels(param);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void saveUserLabel(BuyerSaveUserLabelParam param, CerePlatformUser user) throws CoBusinessException {
        String time= TimeUtils.yyMMddHHmmss();
        if(!EmptyUtils.isEmpty(param.getBuyerLabelIds())){
            //查询客户已有标签的
            List<Long> ids=cereBuyerLabelService.findAlreadyByUser(param);
            if(!EmptyUtils.isEmpty(ids)){
                //过滤已有标签
                for (int i = 0; i < param.getBuyerLabelIds().size(); i++) {
                    if(ids.contains(param.getBuyerLabelIds().get(i))){
                        param.getBuyerLabelIds().remove(i);
                        i--;
                    }
                }
            }
            if(!EmptyUtils.isEmpty(param.getBuyerLabelIds())){
                for (Long id:param.getBuyerLabelIds()) {
                    CereBuyerLabel cereBuyerLabel=new CereBuyerLabel();
                    cereBuyerLabel.setBuyerUserId(param.getBuyerUserId());
                    cereBuyerLabel.setBuyerLabelId(id);
                    cereBuyerLabelService.insert(cereBuyerLabel);
                    //新增日志
                    cerePlatformLogService.addLog(user,"客户管理","平台端操作","贴标签",String.valueOf(cereBuyerLabel.getBuyerUserId()),time);
                }
            }
        }
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void blacklist(BuyerBlackListParam param, CerePlatformUser user) throws CoBusinessException {
        String time =TimeUtils.yyMMddHHmmss();
        String describe="";
        CereBuyerUser cereBuyerUser=new CereBuyerUser();
        cereBuyerUser.setBuyerUserId(param.getBuyerUserId());
        cereBuyerUser.setIfBlack(param.getIfBlack());
        cereBuyerUser.setUpdateTime(time);
        cereBuyerUserDAO.updateByPrimaryKeySelective(cereBuyerUser);
        if(IntegerEnum.YES.getCode().equals(param.getIfBlack())){
            //加入黑名单
            describe="加入黑名单";
        }else {
            //取消黑名单
            describe="取消黑名单";
        }
        //新增日志
        cerePlatformLogService.addLog(user,"客户管理","平台端操作",describe,String.valueOf(param.getBuyerUserId()),time);
    }

    @Override
    public List<CerePlatformLabel> getUserLabels(BuyerGetLabelsParam param) throws CoBusinessException {
        return cereBuyerUserDAO.getUserLabels(param);
    }

    @Override
    public void updateCredit(UpdateCreditParam param, CerePlatformUser user) throws CoBusinessException {
        //定义加锁key
        String key = CacheKeyConstants.CREDIT_LOCK + param.getBuyerUserId();
        //加锁
        RLock redissonLock = redissonClient.getLock(key);
        String time = TimeUtils.yyMMddHHmmss();
        long buyerUserId = param.getBuyerUserId();
        Integer credit = param.getCredit();
        if (credit == 0) {
            return;
        }
        Integer absCredit = Math.abs(param.getCredit());
        boolean notEnoughCredit = false;
        try {
            redissonLock.lock();
            CereBuyerUser buyerUser = cereBuyerUserDAO.selectById(buyerUserId);
            if (credit < 0 && buyerUser.getCredit() < absCredit) {
                notEnoughCredit = true;
            } else {
                CreditOptTypeEnum typeEnum = CreditOptTypeEnum.ADMIN_ADD;
                String describe = "增加"+absCredit+"积分";
                if (credit < 0) {
                    typeEnum = CreditOptTypeEnum.ADMIN_SUB;
                    describe = "扣减"+absCredit+"积分";
                }
                cereBuyerUserDAO.increaseCredit(buyerUserId, param.getCredit());
                //增加积分记录
                CereCreditRecord record = CreditOptTypeEnum.initRecord(typeEnum);
                record.setBuyerUserId(buyerUserId);
                record.setCreateTime(time);
                record.setUpdateTime(time);
                record.setCredit(absCredit);
                record.setRemainCredit(buyerUser.getCredit() + credit);
                cereCreditRecordDAO.insert(record);
                //新增日志
                cerePlatformLogService.addLog(user,"客户管理","平台端操作",describe,String.valueOf(param.getBuyerUserId()),time);
            }
        } catch (Exception e) {
            log.error("increaseCredit fail: buyerUserId = {}, credit = {}" + e.getMessage(),
                    buyerUserId, credit, e);
        } finally {
            redissonLock.unlock();
        }
        if (notEnoughCredit) {
            throw new CoBusinessException(CoReturnFormat.CREDIT_NOT_ENOUGH);
        }
    }

    @Override
    public Page<CereBuyerUser> searchUser(UserSearchParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        LambdaQueryWrapper<CereBuyerUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CereBuyerUser::getBuyerUserId, param.getSearchKey())
                .or()
                .eq(CereBuyerUser::getWechatOpenId, param.getSearchKey())
                .or()
                .like(CereBuyerUser::getName, param.getSearchKey())
                .or()
                .eq(CereBuyerUser::getPhone, param.getSearchKey());
        List<CereBuyerUser> userList = cereBuyerUserDAO.selectList(wrapper);
        PageInfo<CereBuyerUser> pageInfo=new PageInfo<>(userList);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }
}
