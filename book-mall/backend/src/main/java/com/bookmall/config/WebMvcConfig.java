package com.bookmall.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${file.upload.path}")
    private String uploadPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String uploadDir = uploadPath.replace("\\", "/");
        if (!uploadDir.endsWith("/")) {
            uploadDir = uploadDir + "/";
        }
        String filePath = "file:" + uploadDir;

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(filePath)
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        registry.addResourceHandler("/avatar/**")
                .addResourceLocations("file:" + uploadDir + "avatar/")
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());
    }
}
