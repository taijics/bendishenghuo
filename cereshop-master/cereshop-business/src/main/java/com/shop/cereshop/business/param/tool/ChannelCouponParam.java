package com.shop.cereshop.business.param.tool;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;

@Data
@ApiModel("渠道优惠券查询对象")
public class ChannelCouponParam extends PageParam {

    @ApiModelProperty("店铺id")
    private Long shopId;

    @ApiModelProperty("搜索字段")
    private String search;

}
