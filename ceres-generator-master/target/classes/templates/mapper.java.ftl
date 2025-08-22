/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package ${package.Mapper};

import ${superMapperClassPackage};
import ${package.Entity}.${entity};

import org.apache.ibatis.annotations.Mapper;

@Mapper
<#if kotlin>
interface ${table.mapperName} : ${superMapperClass}<${entity}>
<#else>
public interface ${entity}DAO extends ${superMapperClass}<${entity}> {

}
</#if>
