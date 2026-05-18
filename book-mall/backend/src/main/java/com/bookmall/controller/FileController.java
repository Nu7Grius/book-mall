package com.bookmall.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

/**
 * 文件访问控制器 - 解决URL编码问题
 */
@RestController
@RequestMapping("/file")
@CrossOrigin
public class FileController {

    @Value("${file.upload.path}")
    private String uploadPath;

    /**
     * 解析上传路径，支持相对路径
     */
    private String resolveUploadPath() {
        if (uploadPath.startsWith("./")) {
            String basePath = System.getProperty("user.dir");
            return basePath + File.separator + uploadPath.substring(2);
        } else if (new File(uploadPath).isAbsolute()) {
            return uploadPath;
        } else {
            String basePath = System.getProperty("user.dir");
            return basePath + File.separator + uploadPath;
        }
    }

    /**
     * 获取图片文件
     *
     * @param path 图片路径（相对于upload目录）
     */
    @GetMapping("/image")
    public ResponseEntity<Resource> getImage(@RequestParam String path) {
        try {
            String resolvedPath = resolveUploadPath();
            String decodedPath = URLDecoder.decode(path, StandardCharsets.UTF_8.name());
            String fullPath = resolvedPath + File.separator + decodedPath;
            File file = new File(fullPath);

            if (!file.exists() || !file.isFile()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String filename = file.getName().toLowerCase();
            MediaType mediaType;
            if (filename.endsWith(".png")) {
                mediaType = MediaType.IMAGE_PNG;
            } else if (filename.endsWith(".gif")) {
                mediaType = MediaType.IMAGE_GIF;
            } else if (filename.endsWith(".jpg") || filename.endsWith(".jpeg")) {
                mediaType = MediaType.IMAGE_JPEG;
            } else {
                mediaType = MediaType.APPLICATION_OCTET_STREAM;
            }

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + file.getName() + "\"")
                    .body(resource);

        } catch (UnsupportedEncodingException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
