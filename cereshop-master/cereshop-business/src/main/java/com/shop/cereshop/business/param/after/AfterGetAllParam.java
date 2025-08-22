/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.after;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 获取售后单列表请求
 */
@Data
@ApiModel(value = "AfterGetAllParam", description = "获取售后单列表请求")
public class AfterGetAllParam extends PageParam {

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;

    /**
     * 搜索类型  1-订单ID 2-买家账户 3-收件人姓名 4-收件人手机号 5-商品ID
     */
    @ApiModelProperty(value = "搜索类型  1-订单ID 2-买家账户 3-收件人姓名 4-收件人手机号 5-商品ID")
    private Integer searchType;

    /**
     * 搜索字段
     */
    @ApiModelProperty(value = "搜索字段")
    private String search;

    /**
     * 订单状态 1-待付款 2-待<if test="keyWord != null and keyWord!=''"> 3-已<if test="keyWord != null and keyWord!=''"> 4-已完成 5-已关闭
     */
    @ApiModelProperty(value = "订单状态 1-待付款 2-待发货 3-已发货 4-已完成 5-已关闭")
    private Integer state;

    /**
     * 售后状态 1-售后中 2-售后成功 3-售后关闭
     */
    @ApiModelProperty(value = "售后状态 1-售后中 2-售后成功 3-售后关闭")
    private Integer afterState;

    /**
     * 售后类型  1-仅退款  2-退货退款
     */
    @ApiModelProperty(value = "售后类型  1-仅退款  2-退货退款")
    private Integer afterType;
    /**
     * 售后状态集合  1-审核中 2-退款中 3-退货中 4-退款成功 5-退款失败 6-审核不通过 7-评审中 8-退货完成，拒绝退款 9-已关闭 10-审核通过
     * 1、2、3、5、6、7、8、10 售后中
     * 4 售后成功
     * 9 售后关闭
     */
    @ApiModelProperty(value = "售后状态")
    private List<Integer> afterStateList;
    /**
     * 列表累心 1-待商家处理 2-待商家收货
     */
    @ApiModelProperty(value = "列表累心 1-待商家处理 2-待商家收货")
    private Integer type;
}
