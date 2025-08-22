package com.shop.cereshop.business.service.channel.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.shop.cereshop.business.dao.channel.ShopChannelActivityCouponDAO;
import com.shop.cereshop.business.dao.channel.ShopChannelActivityDAO;
import com.shop.cereshop.business.param.channel.ChannelActivityCouponPageParam;
import com.shop.cereshop.business.param.channel.ChannelActivityCouponParam;
import com.shop.cereshop.business.param.channel.ChannelActivityGetAllParam;
import com.shop.cereshop.business.param.channel.ChannelActivityParam;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.channel.ShopChannelActivityService;
import com.shop.cereshop.business.service.redis.CereRedisKeyServcice;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.StringEnum;
import com.shop.cereshop.commons.domain.channel.ShopChannelActivity;
import com.shop.cereshop.commons.domain.channel.ShopChannelActivityCoupon;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereShopCoupon;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class ShopChannelActivityServiceImpl implements ShopChannelActivityService {

    @Autowired
    private ShopChannelActivityDAO shopChannelActivityDAO;

    @Autowired
    private ShopChannelActivityCouponDAO shopChannelActivityCouponDAO;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private CereRedisKeyServcice cereRedisKeyServcice;

    @Value("${channelCouponActivityUrl}")
    private String channelCouponActivityUrl;


    @Override
    public int save(ChannelActivityParam param) {
        String now = TimeUtils.yyMMddHHmmss();
        ShopChannelActivity activity = new ShopChannelActivity();
        BeanUtils.copyProperties(param, activity);
        try {
            if (TimeUtils.compareTo(now, param.getEndTime())) {
                activity.setState(IntegerEnum.TOOL_END.getCode());
            } else if (TimeUtils.compareTo(now, param.getStartTime()) && !TimeUtils.compareTo(now, param.getEndTime())) {
                activity.setState(IntegerEnum.TOOL_HAND.getCode());
            } else {
                activity.setState(IntegerEnum.TOOL_NOT_START.getCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        activity.setRemainCount(activity.getPublishCount());
        activity.setCreateTime(now);
        activity.setUpdateTime(now);
        int result = shopChannelActivityDAO.insert(activity);

        Long activityId = activity.getId();
        if (CollectionUtils.isNotEmpty(param.getCouponList())) {
            for (ShopChannelActivityCoupon coupon:param.getCouponList()) {
                coupon.setId(activityId);
                coupon.setShopId(param.getShopId());
                coupon.setCreateTime(now);
                coupon.setUpdateTime(now);
                result += shopChannelActivityCouponDAO.insert(coupon);
            }
        }
        try {
            if (IntegerEnum.TOOL_HAND.getCode().equals(activity.getState())) {
                //如果状态为进行中,新增redis延时任务修改状态为已结束
                stringRedisService.set(StringEnum.CHANNEL_ACTIVITY_END.getCode()+"-"+activity.getId(),1,
                        TimeUtils.getCountDownByTime(now,activity.getEndTime()));
                //新增延时任务记录
                cereRedisKeyServcice.add(StringEnum.CHANNEL_ACTIVITY_END.getCode()+"-"+activity.getId(),activity.getEndTime());
            } else if (IntegerEnum.TOOL_NOT_START.getCode().equals(activity.getState())) {
                //如果状态为未开始,新增redis延时任务修改状态为进行中
                stringRedisService.set(StringEnum.CHANNEL_ACTIVITY_START.getCode()+"-"+activity.getId(),1,
                        TimeUtils.getCountDownByTime(now,activity.getStartTime()));
                //新增延时任务记录
                cereRedisKeyServcice.add(StringEnum.CHANNEL_ACTIVITY_START.getCode()+"-"+activity.getId(),activity.getStartTime());
            }
        } catch (Exception e) {
            log.error("save channelActivity fail: " + e.getMessage(), e);
        }
        return result;
    }

    @Override
    public int update(ChannelActivityParam param) throws CoBusinessException {
        ShopChannelActivity oldActivity = shopChannelActivityDAO.selectById(param.getId());
        if (oldActivity == null) {
            throw new CoBusinessException(CoReturnFormat.ACTIVITY_NOT_EXISTS);
        }
        String now = TimeUtils.yyMMddHHmmss();
        /*boolean compareResult = true;
        try {
            compareResult = TimeUtils.compareTo(oldActivity.getStartTime(), now);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (!compareResult) {
            throw new CoBusinessException(CoReturnFormat.EDIT_BEFORE_ACTIVITY_START);
        }*/

        shopChannelActivityCouponDAO.delete(Wrappers.<ShopChannelActivityCoupon>lambdaQuery()
                .eq(ShopChannelActivityCoupon::getId, param.getId())
                .eq(ShopChannelActivityCoupon::getShopId, param.getShopId()));
        if (CollectionUtils.isNotEmpty(param.getCouponList())) {
            for (ShopChannelActivityCoupon coupon:param.getCouponList()) {
                coupon.setId(param.getId());
                coupon.setShopId(param.getShopId());
                coupon.setCreateTime(now);
                coupon.setUpdateTime(now);
                shopChannelActivityCouponDAO.insert(coupon);
            }
        }
        ShopChannelActivity activity = new ShopChannelActivity();
        BeanUtils.copyProperties(param, activity);
        activity.setUpdateTime(now);
        try {
            if (TimeUtils.compareTo(now, param.getEndTime())) {
                activity.setState(IntegerEnum.TOOL_END.getCode());
            } else if (TimeUtils.compareTo(now, param.getStartTime()) && !TimeUtils.compareTo(now, param.getEndTime())) {
                activity.setState(IntegerEnum.TOOL_HAND.getCode());
            } else {
                activity.setState(IntegerEnum.TOOL_NOT_START.getCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (IntegerEnum.TOOL_HAND.getCode().equals(activity.getState())) {
                //如果状态为进行中,新增redis延时任务修改状态为已结束
                stringRedisService.set(StringEnum.CHANNEL_ACTIVITY_END.getCode()+"-"+activity.getId(),1,
                        TimeUtils.getCountDownByTime(now,activity.getEndTime()));
                //新增延时任务记录
                cereRedisKeyServcice.add(StringEnum.CHANNEL_ACTIVITY_END.getCode()+"-"+activity.getId(),activity.getEndTime());
            } else if (IntegerEnum.TOOL_NOT_START.getCode().equals(activity.getState())) {
                //如果状态为未开始,新增redis延时任务修改状态为进行中
                stringRedisService.set(StringEnum.CHANNEL_ACTIVITY_START.getCode()+"-"+activity.getId(),1,
                        TimeUtils.getCountDownByTime(now,activity.getStartTime()));
                //新增延时任务记录
                cereRedisKeyServcice.add(StringEnum.CHANNEL_ACTIVITY_START.getCode()+"-"+activity.getId(),activity.getStartTime());
            }
        } catch (Exception e) {
            log.error("update channelActivity fail: " + e.getMessage(), e);
        }
        return shopChannelActivityDAO.update(activity, Wrappers.<ShopChannelActivity>lambdaQuery()
                .eq(ShopChannelActivity::getId, param.getId())
                .eq(ShopChannelActivity::getShopId, param.getShopId()));
    }

    @Override
    public int delete(ChannelActivityParam param) {
        shopChannelActivityCouponDAO.delete(Wrappers.<ShopChannelActivityCoupon>lambdaQuery()
                .eq(ShopChannelActivityCoupon::getId, param.getId())
                .eq(ShopChannelActivityCoupon::getShopId, param.getShopId()));
        return shopChannelActivityDAO.delete(Wrappers.<ShopChannelActivity>lambdaQuery()
                .eq(ShopChannelActivity::getId, param.getId())
                .eq(ShopChannelActivity::getShopId, param.getShopId()));
    }

    @Override
    public int deleteChannelActivityCoupon(ChannelActivityCouponParam param) {
        return shopChannelActivityCouponDAO.delete(Wrappers.<ShopChannelActivityCoupon>lambdaQuery()
                .eq(ShopChannelActivityCoupon::getId, param.getId())
                .eq(ShopChannelActivityCoupon::getCouponId, param.getCouponId()).eq(ShopChannelActivityCoupon::getShopId, param.getShopId()));
    }

    @Override
    public ShopChannelActivity getByIdCheckShopId(ChannelActivityParam param) {
        return shopChannelActivityDAO.selectOne(Wrappers.<ShopChannelActivity>lambdaQuery()
                .eq(ShopChannelActivity::getId, param.getId())
                .eq(ShopChannelActivity::getShopId, param.getShopId()));
    }

    @Override
    public ShopChannelActivity selectById(Long channelActivityId) {
        return shopChannelActivityDAO.selectById(channelActivityId);
    }

    @Override
    public int updateById(ShopChannelActivity activity) {
        return shopChannelActivityDAO.updateById(activity);
    }

    @Override
    public Page<ShopChannelActivity> getAll(ChannelActivityGetAllParam param) {
        com.github.pagehelper.Page<ShopChannelActivity> page = PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ShopChannelActivity> list = shopChannelActivityDAO.selectList(Wrappers.<ShopChannelActivity>lambdaQuery()
                .eq(ShopChannelActivity::getShopId, param.getShopId())
                .orderByDesc(ShopChannelActivity::getCreateTime));
        list.forEach(obj -> {
            obj.setActivityUrl(channelCouponActivityUrl + obj.getId());
            obj.setReleaseCount(obj.getPublishCount() - obj.getRemainCount());
        });
        return new Page<>(list, page.getTotal());
    }

    @Override
    public Page<CereShopCoupon> selectChannelCouponByActivityId(ChannelActivityCouponPageParam param) {
        com.github.pagehelper.Page<ShopChannelActivity> page = PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereShopCoupon> list = shopChannelActivityCouponDAO.selectChannelCouponByActivityId(param.getChannelActivityId(), param.getShopId());
        return new Page<>(list, page.getTotal());
    }
}
