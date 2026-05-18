package com.bookmall.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import javax.servlet.Filter;
import javax.servlet.http.HttpServletResponse;

/**
 * CORS 跨域配置类
 * 配置后端允许跨域请求
 */
@Configuration
public class CorsConfig {

    /**
     * 配置跨域过滤器
     */
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        
        // 允许所有来源（生产环境应限制具体域名）
        config.addAllowedOriginPattern("*");
        
        // 允许携带认证信息（cookies、Authorization头等）
        config.setAllowCredentials(true);
        
        // 允许所有请求头
        config.addAllowedHeader("*");
        
        // 允许所有请求方法（GET、POST、PUT、DELETE等）
        config.addAllowedMethod("*");
        
        // 暴露响应头（让前端可以访问这些响应头）
        config.addExposedHeader("Authorization");

        // 允许跨域资源加载（解决 Firefox OpaqueResponseBlocking 问题）
        config.addExposedHeader("Cross-Origin-Resource-Policy");

        // 预检请求的缓存时间（秒）
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }

    /**
     * 添加跨域资源策略头
     */
    @Bean
    public Filter corsResourcePolicyFilter() {
        return (request, response, chain) -> {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setHeader("Cross-Origin-Resource-Policy", "cross-origin");
            chain.doFilter(request, response);
        };
    }
}
