/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.business.dao.tool;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.business.page.tool.ChannelCouponDetail;
import com.shop.cereshop.business.param.tool.ChannelCouponParam;
import com.shop.cereshop.commons.domain.tool.CereChannelCoupon;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CereChannelCouponDAO extends BaseMapper<CereChannelCoupon> {

    List<ChannelCouponDetail> getAll(ChannelCouponParam param);
}
