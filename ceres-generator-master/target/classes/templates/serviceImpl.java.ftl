/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package ${package.ServiceImpl};

import ${package.Mapper}.${entity}DAO;
import ${package.Entity}.${entity};
import ${package.Service}.${table.serviceName};

import lombok.extern.slf4j.Slf4j;
<#if superServiceImplClass?? && superServiceImplClass == "SuperCacheServiceImpl">
import org.springframework.aop.framework.AopContext;
import org.springframework.cache.annotation.CacheConfig;
</#if>
import org.springframework.stereotype.Service;

/**
 * <p>
 * 业务实现类
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
@Slf4j
@Service
<#if superServiceImplClass?? && superServiceImplClass == "SuperCacheServiceImpl">
@CacheConfig(cacheNames = ${table.serviceImplName}.${entity?upper_case})
</#if>
<#if kotlin>
open class ${table.serviceImplName} : ${superServiceImplClass}<${table.mapperName}, ${entity}>(), ${table.serviceName} {
}
<#else>
<#if superServiceImplClass??>
public class ${table.serviceImplName} implements ${table.serviceName} {
<#else>
public class ${table.serviceImplName} {
</#if>
<#if superServiceImplClass?? && superServiceImplClass == "SuperCacheServiceImpl">
    /**
     * 建议将改变量移动到CacheKey工具类中统一管理，并在 caffeine.properties 文件中合理配置有效期
     */
    protected static final String ${entity?upper_case} = "${entity?lower_case}";

    @Override
    protected String getRegion() {
        return ${entity?upper_case};
    }

    protected ${table.serviceName} currentProxy() {
        return ((${table.serviceName}) AopContext.currentProxy());
    }
</#if>
}
</#if>
