/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.page.buyer;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * 客户返回数据实体类
 */
@Data
@ApiModel(value = "BuyerUser", description = "客户返回数据实体类")
public class BuyerUser {

    /**
     * 用户id
     */
    @ApiModelProperty(value = "用户id")
    private Long buyerUserId;

    /**
     * 用户昵称
     */
    @ApiModelProperty(value = "用户昵称")
    private String name;

    /**
     * 手机号
     */
    @ApiModelProperty(value = "手机号")
    private String phone;

    /**
     * 会员等级名称
     */
    @ApiModelProperty(value = "会员等级名称")
    private String memberLevelName;

    /**
     * 积分
     */
    @ApiModelProperty("积分")
    private Integer credit;

    /**
     * 消费总额
     */
    @ApiModelProperty(value = "消费总额")
    private BigDecimal total;

    /**
     * 购买次数
     */
    @ApiModelProperty(value = "购买次数")
    private Integer buyers;

    /**
     * 最近消费时间
     */
    @ApiModelProperty(value = "最近消费时间")
    private String time;

    /**
     * 注册时间
     */
    @ApiModelProperty(value = "注册时间")
    private String createTime;

    /**
     * 是否加入黑名单 1-是 0-否
     */
    @ApiModelProperty(value = "是否加入黑名单 1-是 0-否")
    private Integer ifBlack;

    @ApiModelProperty("标签id列表")
    private List<Long> labelIds;

    /**
     * 注册ip
     */
    @ApiModelProperty(value = "注册ip")
    private String registerIp;

    /**
     * 上次登录的ip
     */
    @ApiModelProperty(value = "上次登录的ip")
    private String lastLoginIp;

    /**
     * 注册来源
     */
    @ApiModelProperty(value = "注册来源")
    private Integer terminal;

    /**
     * 注册渠道
     */
    @ApiModelProperty(value = "注册渠道")
    private String channelCode;
}
