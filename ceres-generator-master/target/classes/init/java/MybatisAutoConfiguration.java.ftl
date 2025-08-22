package ${packageBase}.config.datasource;


import com.zkthink.oauth.api.UserApi;
import com.zkthink.database.datasource.BaseMybatisConfiguration;
import com.zkthink.database.mybatis.auth.DataScopeInterceptor;
import com.zkthink.database.properties.DatabaseProperties;
import com.zkthink.utils.SpringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;

/**
 * ${description}-Mybatis 常用重用拦截器
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
@Slf4j
@EnableConfigurationProperties({DatabaseProperties.class})
public class ${service}MybatisAutoConfiguration extends BaseMybatisConfiguration {

    public ${service}MybatisAutoConfiguration(DatabaseProperties databaseProperties) {
        super(databaseProperties);
    }

    /**
     * 数据权限插件
     *
     * @return DataScopeInterceptor
     */
    @Order(10)
    @Bean
    @ConditionalOnProperty(prefix = DatabaseProperties.PREFIX, name = "isDataScope", havingValue = "true", matchIfMissing = true)
    public DataScopeInterceptor dataScopeInterceptor() {
        return new DataScopeInterceptor((userId) -> SpringUtils.getBean(UserApi.class).getDataScopeById(userId));
    }

}
