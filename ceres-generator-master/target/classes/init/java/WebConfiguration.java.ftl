package ${packageBase}.config;

import com.zkthink.boot.config.BaseConfig;
import org.springframework.context.annotation.Configuration;
import com.zkthink.oauth.api.LogApi;
import com.zkthink.log.event.SysLogListener;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;

/**
 * ${description}-Web配置
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
public class ${service}WebConfiguration extends BaseConfig {

    /**
    * ceres.log.enabled = true 并且 ceres.log.type=DB时实例该类
    *
    * @param optLogService
    * @return
    */
    @Bean
    @ConditionalOnExpression("${r'${'}ceres.log.enabled:true${r'}'} && 'DB'.equals('${r'${'}ceres.log.type:LOGGER${r'}'}')")
    public SysLogListener sysLogListener(LogApi logApi) {
        return new SysLogListener((log) -> logApi.save(log));
    }
}
