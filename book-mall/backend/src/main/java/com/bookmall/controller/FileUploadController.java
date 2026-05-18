package com.bookmall.controller;

import com.bookmall.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * 文件上传控制器
 */
@RestController
@RequestMapping("/upload")
@CrossOrigin
public class FileUploadController {

    @Value("${file.upload.path:D:/uploads}")
    private String uploadPath;

    /**
     * 图片上传接口
     */
    @PostMapping("/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        // 检查文件是否为空
        if (file.isEmpty()) {
            return Result.error(400, "请选择要上传的文件");
        }

        // 检查文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return Result.error(400, "只能上传图片文件");
        }

        // 检查文件大小（最大 5MB）
        if (file.getSize() > 5 * 1024 * 1024) {
            return Result.error(400, "文件大小不能超过 5MB");
        }

        try {
            // 创建上传目录
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成文件名
            String originalFilename = file.getOriginalFilename();
            String suffix = originalFilename != null ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".jpg";
            String filename = UUID.randomUUID().toString() + suffix;

            // 按日期创建子目录
            String datePath = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            File dateDir = new File(uploadPath, datePath);
            if (!dateDir.exists()) {
                dateDir.mkdirs();
            }

            // 保存文件
            File destFile = new File(dateDir, filename);
            file.transferTo(destFile);

            // 返回访问路径
            String fileUrl = "/uploads/" + datePath + "/" + filename;

            return Result.success("上传成功", fileUrl);

        } catch (IOException e) {
            return Result.error(500, "文件上传失败");
        }
    }

    /**
     * 获取上传的文件
     */
    @GetMapping("/file{datePath}/{filename}")
    public ResponseEntity<Resource> getFile(@PathVariable String datePath, @PathVariable String filename) {
        try {
            String fullPath = uploadPath + File.separator + datePath + File.separator + filename;
            File file = new File(fullPath);

            if (!file.exists()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String contentType = "image/jpeg";
            if (filename.toLowerCase().endsWith(".png")) {
                contentType = "image/png";
            } else if (filename.toLowerCase().endsWith(".gif")) {
                contentType = "image/gif";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + file.getName() + "\"")
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
}
