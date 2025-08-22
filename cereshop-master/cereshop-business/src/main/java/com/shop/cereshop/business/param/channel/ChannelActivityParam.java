package com.shop.cereshop.business.param.channel;

import com.shop.cereshop.commons.domain.channel.ShopChannelActivityCoupon;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Data
public class ChannelActivityParam {

    private Long id;

    /**
     * 店铺id
     */
    @ApiModelProperty("店铺id")
    private Long shopId;


    /**
     * 活动名称
     */
    @ApiModelProperty(value = "活动名称")
    @NotEmpty(message = "活动名称不能为空")
    @Length(max = 64, message = "活动名称长度不能超过64")
    private String activityName;


    /**
     * 备注
     */
    @ApiModelProperty(value = "备注")
    @Length(max = 512, message = "备注长度不能超过512")
    private String remark;


    /**
     * 开始时间
     */
    @ApiModelProperty(value = "开始时间")
    @NotEmpty(message = "开始时间不能为空")
    @Length(max = 20, message = "开始时间长度不能超过20")
    private String startTime;


    /**
     * 结束时间
     */
    @ApiModelProperty(value = "结束时间")
    @NotEmpty(message = "结束时间不能为空")
    @Length(max = 20, message = "结束时间长度不能超过20")
    private String endTime;


    /**
     * 活动发放数量
     */
    @ApiModelProperty(value = "活动发放数量")
    @NotNull(message = "活动发放数量不能为空")
    private Integer publishCount;


    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    @Length(max = 20, message = "创建时间长度不能超过20")
    private String createTime;


    /**
     * 更新时间
     */
    @ApiModelProperty(value = "更新时间")
    @Length(max = 20, message = "更新时间长度不能超过20")
    private String updateTime;

    @ApiModelProperty("优惠券列表")
    private List<ShopChannelActivityCoupon> couponList;

}
