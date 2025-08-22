/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.activity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * cere_platform_activity 营销活动信息实体类
 * @author
 */
@Data
public class CerePlatformActivity implements Serializable {

    /**
     * 活动id
     */
    @TableId(type = IdType.AUTO)
    private Long activityId;

    /**
     * 活动名称
     */
    private String activityName;

    /**
     * 活动介绍
     */
    private String activityIntroduce;

    /**
     * 报名开始时间
     */
    private String signStartTime;

    /**
     * 报名结束时间
     */
    private String signEndTime;

    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    /**
     * 是否需要保证金  1-是 0-否
     */
    private Integer ifBond;

    /**
     * 保证金金额
     */
    private BigDecimal bondMoney;

    /**
     * 使用门槛满多少元，无门槛为0
     */
    private BigDecimal threshold;

    /**
     * 优惠方式 1-满减 2-优惠券
     */
    private Integer discountMode;

    /**
     * 优惠内容减多少元/打多少折
     */
    private BigDecimal couponContent;

    /**
     * 发放数量
     */
    private Integer number;

    /**
     * 库存数量
     */
    private Integer stockNumber;

    /**
     * 每人限领次数  1-无限次 2-限制几次
     */
    private Integer receiveType;

    /**
     * 限制次数
     */
    private Integer frequency;

    /**
     * 图片地址
     */
    private String image;

    /**
     * 是否支持积分兑换
     */
    private Integer ifCredit;

    /**
     * 兑换所需积分
     */
    private Integer credit;

    @ApiModelProperty(value = "使用范围 1-全部 2-选择类别")
    private Integer applyType;

    @ApiModelProperty(value = "使用类别范围")
    private Long applyCategory;

    @ApiModelProperty(value = "是否同步卡券")
    private Integer syncCard;

    @ApiModelProperty(value = "卡券标题")
    private String cardTitle;

    @ApiModelProperty(value = "券主题色")
    private String cardColor;

    @ApiModelProperty(value = "使用须知")
    private String cardNotice;

    @ApiModelProperty(value = "关联的微信卡券id")
    private String cardId;

    /**
     * 活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
     */
    private Integer state;

    /**
     * 创建时间
     */
    private String createTime;

    /**
     * 更新时间
     */
    private String updateTime;

    private static final long serialVersionUID = 1L;

}
