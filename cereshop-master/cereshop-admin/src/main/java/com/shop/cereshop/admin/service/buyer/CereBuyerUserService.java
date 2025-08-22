/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.buyer;

import com.shop.cereshop.admin.page.buyer.BuyerUser;
import com.shop.cereshop.admin.page.buyer.BuyerUserDetail;
import com.shop.cereshop.admin.param.buyer.*;
import com.shop.cereshop.admin.param.credit.UpdateCreditParam;
import com.shop.cereshop.admin.param.user.UserSearchParam;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.label.CerePlatformLabel;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

import java.util.List;

public interface CereBuyerUserService {
    /**
     * 分页查询客户
     * @param param
     * @return
     * @throws CoBusinessException
     */
    Page<BuyerUser> getAll(BuyerGetAllParam param) throws CoBusinessException;

    /**
     * 根据主键查询客户
     * @param param
     * @return
     * @throws CoBusinessException
     */
    BuyerUserDetail getById(BuyerGetByIdParam param) throws CoBusinessException;

    /**
     * 查询客户标签
     * @param param
     * @return
     * @throws CoBusinessException
     */
    List<CerePlatformLabel> getLabels(BuyerGetLabelsParam param) throws CoBusinessException;

    /**
     * 保存用户标签
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void saveUserLabel(BuyerSaveUserLabelParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 将客户加入/取消黑名单
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void blacklist(BuyerBlackListParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 条件查询标签
     * @param param
     * @return
     * @throws CoBusinessException
     */
    List<CerePlatformLabel> getUserLabels(BuyerGetLabelsParam param) throws CoBusinessException;

    /**
     * 增加/减少客户积分
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void updateCredit(UpdateCreditParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 搜索用户
     * @param param
     * @return
     */
    Page<CereBuyerUser> searchUser(UserSearchParam param);
}
