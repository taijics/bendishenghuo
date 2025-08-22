/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.business.service.tool.impl;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.urllink.GenerateUrlLinkRequest;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.tool.CereChannelCouponDAO;
import com.shop.cereshop.business.dao.tool.CereShopCouponDAO;
import com.shop.cereshop.business.dao.tool.CereShopCouponDetailDAO;
import com.shop.cereshop.business.page.tool.ChannelCouponDetail;
import com.shop.cereshop.business.param.tool.ChannelCouponParam;
import com.shop.cereshop.business.service.tool.CereChannelCouponService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereChannelCoupon;
import com.shop.cereshop.commons.domain.tool.CereShopCoupon;
import com.shop.cereshop.commons.domain.tool.CereShopCouponDetail;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 业务实现类
 * 渠道券表
 * </p>
 *
 * @date 2021-12-12
 */
@Slf4j
@Service
public class CereChannelCouponServiceImpl implements CereChannelCouponService {

    @Autowired
    private CereChannelCouponDAO cereChannelCouponDAO;

    @Autowired
    private CereShopCouponDAO cereShopCouponDAO;

    @Autowired
    private CereShopCouponDetailDAO cereShopCouponDetailDAO;

    @Autowired
    private WxMaService wxMaService;

    @Override
    public Page<ChannelCouponDetail> getAll(ChannelCouponParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ChannelCouponDetail> list = cereChannelCouponDAO.getAll(param);
        PageInfo<ChannelCouponDetail> pageInfo=new PageInfo<>(list);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CereChannelCoupon channelCoupon) throws CoBusinessException {
        //判断是否已经有对应的渠道优惠券
        LambdaQueryWrapper<CereChannelCoupon> wrapperChannel = new LambdaQueryWrapper<>();
        wrapperChannel.eq(CereChannelCoupon::getShopCouponId, channelCoupon.getShopCouponId());
        long existsCount = cereChannelCouponDAO.selectCount(wrapperChannel);
        if (existsCount > 0) {
            throw new CoBusinessException(CoReturnFormat.CHANNEL_COUPON_REPEAT);
        }
        CereShopCoupon shopCoupon = cereShopCouponDAO.selectByPrimaryKey(channelCoupon.getShopCouponId());
        if (shopCoupon != null && !IntegerEnum.APPLY_TYPE_ALL.getCode().equals(shopCoupon.getApplyType())) {
            LambdaQueryWrapper<CereShopCouponDetail> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(CereShopCouponDetail::getShopCouponId, channelCoupon.getShopCouponId());
            List<CereShopCouponDetail> detailList = cereShopCouponDetailDAO.selectList(wrapper);
            long count = detailList.stream().filter(obj->obj.getProductId().equals(channelCoupon.getProductId())).count();
            if (count == 0) {
                throw new CoBusinessException(CoReturnFormat.CHANNEL_COUPON_NOT_MATCHED);
            }
        }
        String time = TimeUtils.yyMMddHHmmss();
        channelCoupon.setCreateTime(time);
        channelCoupon.setUpdateTime(time);
        return cereChannelCouponDAO.insert(channelCoupon);
    }

    @Override
    public String generateLink(CereChannelCoupon channelCoupon) {
//        String path = String.format("/pages_category_page2/channelCoupon/index?shopId=2&productId=%s&shopCouponId=%s",
//                channelCoupon.getShopId(), channelCoupon.getProductId(), channelCoupon.getShopCouponId());
        String path = "/pages_category_page2/channelCoupon/index";
        String query = String.format("shopId=%s&productId=%s&shopCouponId=%s", channelCoupon.getShopId(), channelCoupon.getProductId(), channelCoupon.getShopCouponId());
        log.info("query: {}", query);
        //String path = "/pages/tabbar/user/index";
        GenerateUrlLinkRequest request = GenerateUrlLinkRequest.builder().path(path).query(query).build();
        try {
            return wxMaService.getLinkService().generateUrlLink(request);
        } catch (Exception e) {
            log.error("generateLink: " + e.getMessage(), e);
        }
        return "";
    }


}
