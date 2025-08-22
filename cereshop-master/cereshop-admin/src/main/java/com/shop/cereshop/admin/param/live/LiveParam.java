package com.shop.cereshop.admin.param.live;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 直播请求
 */
@Data
@ApiModel(value = "LiveParam", description = "直播请求")
public class LiveParam {

    @ApiModelProperty("id")
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

    @ApiModelProperty("直播间类型 1-推流 2-手机直播")
    private Integer liveType;

    @ApiModelProperty("屏幕类型 1-竖屏 2-横屏")
    private Integer screenType;

    @ApiModelProperty("关闭点赞")
    private Integer closeLike;

    @ApiModelProperty("关闭货架")
    private Integer closeGoodsShelf;

    @ApiModelProperty("关闭评论")
    private Integer closeComment;

    @ApiModelProperty("关闭回放")
    private Integer closePlayback;

    @ApiModelProperty("关闭分享")
    private Integer closeShare;

    @ApiModelProperty("关闭客服")
    private Integer closeService;

    @ApiModelProperty("关闭预定")
    private Integer closeAppointment;

    @ApiModelProperty("开始时间")
    private String startTime;

    @ApiModelProperty("结束时间")
    private String endTime;

    @ApiModelProperty("背景图片")
    private String backgroundImg;

    @ApiModelProperty("分享图片")
    private String shareImg;

    @ApiModelProperty("封面图")
    private String coverImg;

    @ApiModelProperty("状态 0-待审核 1-审核通过 2-审核不通过")
    private Integer state;

    @ApiModelProperty("备注")
    private String remark;


}
