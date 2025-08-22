/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.channel.impl;


import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.buyer.CereBuyerUserDAO;
import com.shop.cereshop.admin.dao.channel.ChannelDAO;
import com.shop.cereshop.admin.dao.order.CereShopOrderDAO;
import com.shop.cereshop.admin.page.channel.ChannelDTO;
import com.shop.cereshop.admin.param.channel.ChannelGetAllParam;
import com.shop.cereshop.admin.param.channel.ChannelParam;
import com.shop.cereshop.admin.service.channel.ChannelService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.channel.Channel;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * 业务实现类
 * 渠道表
 * </p>
 *
 * @author
 * @date 2022-08-25
 */
@Slf4j
@Service
public class ChannelServiceImpl implements ChannelService {

    @Autowired
    private ChannelDAO channelDAO;

    @Value("${channelRegisterUrl}")
    private String channelRegisterUrl;

    @Autowired
    private CereBuyerUserDAO cereBuyerUserDAO;

    @Autowired
    private CereShopOrderDAO cereShopOrderDAO;

    @Override
    public void save(ChannelParam param, CerePlatformUser user) throws CoBusinessException {
        Channel channel = new Channel();
        String now = TimeUtils.yyMMddHHmmss();
        channel.setChannelName(param.getChannelName());
        int count = 0;
        while (true) {
            if (count > 100) {
                throw new CoBusinessException(CoReturnFormat.SYS_ERROR);
            }
            String channelCode = IdUtil.simpleUUID().substring(0,6);
            int existsCount = channelDAO.selectCount(Wrappers.<Channel>lambdaQuery().eq(Channel::getChannelCode, channelCode));
            if (existsCount == 0) {
                channel.setChannelCode(channelCode);
                break;
            }
            count++;
        }
        channel.setRegisterUrl(channelRegisterUrl + channel.getChannelCode());
        channel.setCreateTime(now);
        channel.setUpdateTime(now);
        channelDAO.insert(channel);
    }

    @Override
    public void update(ChannelParam param, CerePlatformUser user) throws CoBusinessException {
        Channel channel = new Channel();
        channel.setId(param.getId());
        channel.setChannelName(param.getChannelName());
        channelDAO.updateById(channel);
    }

    @Override
    public void delete(ChannelParam param, CerePlatformUser user) throws CoBusinessException {
        channelDAO.deleteById(param.getId());
    }

    @Override
    public Page<ChannelDTO> getAll(ChannelGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<Channel> list=channelDAO.selectList(Wrappers.emptyWrapper());
        List<ChannelDTO> channelDTOList = new ArrayList<>();
        for (Channel channel:list) {
            ChannelDTO channelDTO = new ChannelDTO();
            BeanUtils.copyProperties(channel, channelDTO);
            channelDTO.setRegisterCount(cereBuyerUserDAO.selectCount(Wrappers.<CereBuyerUser>lambdaQuery().eq(CereBuyerUser::getChannelCode, channel.getChannelCode())));
            channelDTO.setOrderUserCount(cereShopOrderDAO.selectChannelOrderUserCount(channel.getChannelCode()));
            channelDTO.setOrderCount(cereShopOrderDAO.selectChannelOrderCount(channel.getChannelCode()));
            channelDTO.setOrderAmount(cereShopOrderDAO.selectChannelOrderAmount(channel.getChannelCode()));
            channelDTOList.add(channelDTO);
        }
        PageInfo<ChannelDTO> pageInfo=new PageInfo<>(channelDTOList);
        return new Page<>(pageInfo.getList(),pageInfo.getTotal());
    }

    @Override
    public List<Channel> selectByChannelCodeList(List<String> channelCodeList) {
        return channelDAO.selectList(Wrappers.<Channel>lambdaQuery().in(Channel::getChannelCode, channelCodeList));
    }
}
