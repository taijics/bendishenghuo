/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.shopcheck;

import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.utils.EmptyUtils;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 获取入驻申请记录列表请求
 */
@Data
@ApiModel(value = "CheckGetAllParam", description = "获取入驻申请记录列表请求")
public class CheckGetAllParam extends PageParam {

    /**
     * 商家名称
     */
    @ApiModelProperty(value = "商家名称")
    private String shopName;

    /**
     * 手机号
     */
    @ApiModelProperty(value = "手机号")
    private String shopPhone;

    /**
     * 店铺类型 1-个人 2-个体工商户 3-企业 4-其他组织
     */
    @ApiModelProperty(value = "店铺类型 1-个人 2-个体工商户 3-企业 4-其他组织")
    private Integer authenType;

    /**
     * 入驻处理状态 0-未处理 1-通过 2-拒绝
     */
    @ApiModelProperty(value = "入驻处理状态 0-未处理 1-通过 2-拒绝")
    private Integer checkState;

    /**
     * 申请日期数组
     */
    @ApiModelProperty(value = "申请日期数组")
    private List<String> dates;

    public void setDates(List<String> dates) {
        if(!EmptyUtils.isEmpty(dates)&&dates.size()>1){
            this.startTime=dates.get(0);
            this.endTime=dates.get(1);
        }
    }

    /**
     * 申请日期开始时间
     */
    @ApiModelProperty(value = "申请日期开始时间")
    private String startTime;

    /**
     * 申请日期结束时间
     */
    @ApiModelProperty(value = "申请日期结束时间")
    private String endTime;
}
