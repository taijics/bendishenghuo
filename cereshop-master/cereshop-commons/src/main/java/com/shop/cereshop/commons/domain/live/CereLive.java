/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.live;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("直播对象")
public class CereLive {

    @ApiModelProperty("id")
    @TableId(type = IdType.AUTO)
    private Long id;

    @ApiModelProperty("店铺id")
    private Long shopId;

    @ApiModelProperty("标题")
    private String title;

    @ApiModelProperty("主播昵称")
    private String anchorNickname;

    @ApiModelProperty("主播微信号")
    private String anchorWechat;

    @ApiModelProperty("主播头像")
    private String anchorHeadImg;

    @ApiModelProperty("直播间类型 0-手机直播 1-推流 ")
    private Integer liveType;

    @ApiModelProperty("屏幕类型 0-竖屏 1-横屏")
    private Integer screenType;

    @ApiModelProperty("关闭点赞 0-开启 1-关闭")
    private Integer closeLike;

    @ApiModelProperty("关闭货架 0-开启 1-关闭")
    private Integer closeGoodsShelf;

    @ApiModelProperty("关闭评论 0-开启 1-关闭")
    private Integer closeComment;

    @ApiModelProperty("关闭回放 0-开启 1-关闭")
    private Integer closePlayback;

    @ApiModelProperty("关闭分享 0-开启 1-关闭")
    private Integer closeShare;

    @ApiModelProperty("关闭客服 0-开启 1-关闭")
    private Integer closeService;

    @ApiModelProperty("关闭预定 0-开启 1-关闭")
    private Integer closeAppointment;

    @ApiModelProperty("开始时间")
    private String startTime;

    @ApiModelProperty("结束时间")
    private String endTime;

    @ApiModelProperty("直播间背景图")
    private String coverImg;

    @ApiModelProperty("直播间分享图片")
    private String shareImg;

    @ApiModelProperty("封面图")
    private String feedsImg;

    /**
     * 直播间背景图媒体id
     */
    @ApiModelProperty(value = "直播间背景图媒体id")
    @TableField(value = "cover_media_id")
    private String coverMediaId;

    /**
     * 分享图媒体id
     */
    @ApiModelProperty(value = "分享图媒体id")
    @TableField(value = "share_media_id")
    private String shareMediaId;

    /**
     * 封面图媒体id
     */
    @ApiModelProperty(value = "封面图媒体id")
    @TableField(value = "feeds_media_id")
    private String feedsMediaId;

    /**
     * 微信端-直播间id
     */
    @ApiModelProperty(value = "微信端-直播间id")
    @TableField("room_id")
    private Integer roomId;

    @ApiModelProperty("状态 0-待审核 1-审核通过 2-审核不通过")
    private Integer state;

    @ApiModelProperty("备注")
    private String remark;

    @ApiModelProperty("创建时间")
    private String createTime;

    @ApiModelProperty("修改时间")
    private String updateTime;

}
