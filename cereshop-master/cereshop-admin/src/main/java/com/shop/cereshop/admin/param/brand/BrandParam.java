package com.shop.cereshop.admin.param.brand;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

@Data
public class BrandParam {

    /**
     * 品牌id
     */
    @ApiModelProperty(value = "品牌id")
    @NotNull(message = "品牌id不能为空")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;


    /**
     * 品牌名称
     */
    @ApiModelProperty(value = "品牌名称")
    @NotEmpty(message = "品牌名称不能为空")
    @Length(max = 64, message = "品牌名称长度不能超过64")
    @TableField(value = "brand_name", condition = LIKE)
    private String brandName;


    /**
     * 品牌图标
     */
    @ApiModelProperty(value = "品牌图标")
    @NotEmpty(message = "品牌图标不能为空")
    @Length(max = 1024, message = "品牌图标长度不能超过1024")
    @TableField(value = "brand_logo", condition = LIKE)
    private String brandLogo;

}
