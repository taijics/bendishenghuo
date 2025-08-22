/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.channel;

import com.shop.cereshop.admin.page.channel.ChannelDTO;
import com.shop.cereshop.admin.param.channel.ChannelGetAllParam;
import com.shop.cereshop.admin.param.channel.ChannelParam;
import com.shop.cereshop.commons.domain.channel.Channel;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

import java.util.List;

/**
 * <p>
 * 业务接口
 * 渠道表
 * </p>
 *
 * @author
 * @date 2022-08-25
 */
public interface ChannelService {

    void save(ChannelParam param, CerePlatformUser user) throws CoBusinessException;

    void update(ChannelParam param, CerePlatformUser user) throws CoBusinessException;

    void delete(ChannelParam param, CerePlatformUser user) throws CoBusinessException;

    Page<ChannelDTO> getAll(ChannelGetAllParam param) throws CoBusinessException;

    List<Channel> selectByChannelCodeList(List<String> channelCodeList);
}
