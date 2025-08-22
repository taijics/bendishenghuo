package com.shop.cereshop.business.service.channel;

import com.shop.cereshop.business.param.channel.ChannelActivityCouponPageParam;
import com.shop.cereshop.business.param.channel.ChannelActivityCouponParam;
import com.shop.cereshop.business.param.channel.ChannelActivityGetAllParam;
import com.shop.cereshop.business.param.channel.ChannelActivityParam;
import com.shop.cereshop.commons.domain.channel.ShopChannelActivity;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereShopCoupon;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface ShopChannelActivityService {

    int save(ChannelActivityParam param);

    int update(ChannelActivityParam param) throws CoBusinessException;

    int delete(ChannelActivityParam param);

    int deleteChannelActivityCoupon(ChannelActivityCouponParam param);

    Page<ShopChannelActivity> getAll(ChannelActivityGetAllParam param);

    Page<CereShopCoupon> selectChannelCouponByActivityId(ChannelActivityCouponPageParam param);

    ShopChannelActivity getByIdCheckShopId(ChannelActivityParam param);

    ShopChannelActivity selectById(Long channelActivityId);

    int updateById(ShopChannelActivity activity);
}
