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
        String resolvedPath = resolveUploadPath(uploadPath);
        String filePath = "file:" + resolvedPath + File.separator;

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(filePath)
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        String avatarPath = "file:" + resolvedPath + File.separator + "avatar" + File.separator;
        registry.addResourceHandler("/avatar/**")
                .addResourceLocations(avatarPath)
                .setCachePeriod(3600)
                .resourceChain(true)
                .addResolver(new PathResourceResolver());
    }

    private String resolveUploadPath(String path) {
        if (path.startsWith("./")) {
            String userDir = System.getProperty("user.dir");
            String resolved = userDir + File.separator + path.substring(2);
            return resolved.replace("/", File.separator).replace("\\", File.separator);
        } else if (!new File(path).isAbsolute()) {
            String userDir = System.getProperty("user.dir");
            return userDir + File.separator + path;
        }
        return path;
    }
}
