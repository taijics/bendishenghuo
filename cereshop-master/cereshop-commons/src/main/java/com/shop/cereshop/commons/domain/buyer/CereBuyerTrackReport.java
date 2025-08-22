/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.buyer;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import lombok.Data;

import java.io.Serializable;

/**
 * cere_buyer_track_report 埋点上报信息
 * @author
 */
@Data
@ApiModel(value = "CereBuyerTrackReport", description = "埋点上报信息")
public class CereBuyerTrackReport implements Serializable {

    /**
     * id
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 事件类型
     */
    private Integer eventType;

    /**
     * 商品id列表 用,分割
     */
    private String productIds;

    /**
     * 创建时间
     */
    private String createTime;

    /**
     * 创建人id
     */
    private Long createUser;

    private static final long serialVersionUID = 1L;

}
