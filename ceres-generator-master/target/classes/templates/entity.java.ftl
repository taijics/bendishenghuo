/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package ${package.Entity};

<#list table.importPackages as pkg>
import ${pkg};
</#list>
<#if swagger2>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.Range;
import java.time.LocalDateTime;
<#if entityLombokModel>
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.experimental.Accessors;
</#if>
<#if cfg.filedTypes??>
<#list cfg.filedTypes as fieldType>
    <#list table.fields as field>
        <#if field.propertyName == fieldType.name && table.name==fieldType.table && field.propertyType=="String">
import ${fieldType.packagePath};
            <#break>
        </#if>
    </#list>
</#list>
</#if>

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

<#assign tableComment = "${table.comment!''}"/>
<#if table.comment?? && table.comment!?contains('\n')>
    <#assign tableComment = "${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
</#if>
/**
 * <p>
 * 实体类
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @since ${date}
 */
<#if entityLombokModel>
@Data
@NoArgsConstructor
@ToString(callSuper = true)
</#if>
<#if table.convert>
@TableName("${table.name}")
</#if>
<#if swagger2>
@ApiModel(value = "${entity}", description = "${tableComment}")
</#if>
<#if superEntityClass??>
@AllArgsConstructor
<#assign hasCustomAnno="0"/>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
    <#assign hasCustomAnno="1"/>
</#if>
public class ${entity} {
<#elseif activeRecord>
@AllArgsConstructor
public class ${entity} extends Model<${entity}> {
<#else>
public class ${entity} implements Serializable {
</#if>

    private static final long serialVersionUID = 1L;

<#setting number_format="0">
<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list table.fields as field>
    <#if field.keyFlag>
        <#assign keyPropertyName="${field.propertyName}"/>
    </#if>
    <#assign fieldComment="${field.comment!}"/>
    <#if field.comment!?length gt 0>
    /**
     * ${field.comment!?replace("\n","\n     * ")}
     */
    <#if field.comment!?contains("\n") >
        <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
    </#if>
    </#if>
    <#if swagger2>
    @ApiModelProperty(value = "${fieldComment}")
    </#if>
    <#assign myPropertyType="${field.propertyType}"/>
    <#assign isEnumType="1"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="${fieldType.type}"/>
            <#assign isEnumType="2"/>
        </#if>
    </#list>
    <#if field.customMap.Null == "NO" >
        <#if (field.columnType!"") == "STRING" && isEnumType == "1">
    @NotEmpty(message = "${fieldComment}不能为空")
        <#else>
    @NotNull(message = "${fieldComment}不能为空")
        </#if>
    </#if>
    <#if (field.columnType!"") == "STRING" && isEnumType == "1">
        <#assign max = 255/>
        <#if field.type?starts_with("varchar") || field.type?starts_with("char")>
            <#if field.type?contains("(")>
                <#assign max = field.type?substring(field.type?index_of("(") + 1, field.type?index_of(")"))/>
            </#if>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("text")>
        <#assign max = 65535/>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("mediumtext")>
        <#assign max = 16777215/>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("longtext")>

        </#if>
    <#else>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Byte")>
    @Range(min = Byte.MIN_VALUE, max = Byte.MAX_VALUE, message = "${fieldComment}长度不能超过"+Byte.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
    </#if>
    <#if field.keyFlag>
    <#-- 主键 -->
        <#if field.keyIdentityFlag>
    @TableId(value = "${field.name}", type = IdType.AUTO)
        <#elseif idType??>
    @TableId(value = "${field.name}", type = IdType.${idType})
        <#elseif field.convert>
    @TableId("${field.name}")
        </#if>
    <#-- 普通字段 -->
    <#elseif field.fill??>
    <#-- -----   存在字段填充设置   ----->
        <#if field.convert>
    @TableField(value = "${field.name}", fill = FieldFill.${field.fill})
        <#else>
    @TableField(fill = FieldFill.${field.fill})
        </#if>
    <#elseif field.convert>
        <#if (field.type?starts_with("varchar") || field.type?starts_with("char")) && myPropertyType == "String">
    @TableField(value = "${field.name}", condition = LIKE)
        <#else>
    @TableField("${field.name}")
        </#if>
    </#if>
    <#-- 乐观锁注解 -->
    <#if (versionFieldName!"") == field.name>
    @Version
    </#if>
    <#-- 逻辑删除注解 -->
    <#if (logicDeleteFieldName!"") == field.name>
    @TableLogic
    </#if>
    <#assign myPropertyName="${field.propertyName}"/>
    <#-- 自动注入注解 -->
    <#if field.customMap.annotation??>
    ${field.customMap.annotation}
    @ExcelEntity(name = "")
        <#assign myPropertyType="${field.customMap.type}"/>
        <#if field.propertyName?ends_with("Id")>
            <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
        </#if>
    </#if>
    private ${myPropertyType} ${myPropertyName};


</#list>
<#------------  END 字段循环遍历  ---------->
<#if !entityLombokModel>

    <#list table.fields as field>
        <#if field.propertyType == "boolean">
            <#assign getprefix="is"/>
        <#else>
            <#assign getprefix="get"/>
        </#if>
    public ${field.propertyType} ${getprefix}${field.capitalName}() {
        return ${field.propertyName};
    }

        <#if entityBuilderModel>
    public ${entity} set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        <#else>
    public void set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        </#if>
        this.${field.propertyName} = ${field.propertyName};
        <#if entityBuilderModel>
        return this;
        </#if>
    }
    </#list>
</#if>

<#if activeRecord>

    @Override
    protected Serializable pkVal() {
    <#if keyPropertyName??>
        return this.${keyPropertyName};
    <#else>
        return null;
    </#if>
    }
</#if>
<#if !entityLombokModel>

    @Override
    public String toString() {
        return "${entity}{" +
    <#list table.fields as field>
        <#if field_index==0>
        "${field.propertyName}=" + ${field.propertyName} +
        <#else>
        ", ${field.propertyName}=" + ${field.propertyName} +
        </#if>
    </#list>
        "}";
    }
</#if>

}
