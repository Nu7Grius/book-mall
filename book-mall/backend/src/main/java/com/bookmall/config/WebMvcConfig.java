package com.bookmall.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

import java.io.File;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${file.upload.path}")
    private String uploadPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String basePath = System.getProperty("user.dir");
        String resolvedPath;

        if (uploadPath.startsWith("./")) {
            resolvedPath = basePath + uploadPath.substring(1);
        } else if (new File(uploadPath).isAbsolute()) {
            resolvedPath = uploadPath;
        } else {
            resolvedPath = basePath + File.separator + uploadPath;
        }

        resolvedPath = resolvedPath.replace("\\", File.separator).replace("/", File.separator);

        String filePath = "file:" + resolvedPath + File.separator;

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(filePath)
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        registry.addResourceHandler("/avatar/**")
                .addResourceLocations(filePath + "avatar" + File.separator)
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());
    }
}
