package com.bookmall.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.common.Result;
import com.bookmall.entity.Notice;
import com.bookmall.entity.User;
import com.bookmall.service.NoticeService;
import com.bookmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notice")
@CrossOrigin
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Result<List<Notice>> list(@RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(Notice::getStatus, status);
        }
        wrapper.orderByDesc(Notice::getPublishTime)
                .orderByDesc(Notice::getId);
        List<Notice> list = noticeService.list(wrapper);
        return Result.success(list);
    }

    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @RequestParam(defaultValue = "1") Long page,
            @RequestParam(defaultValue = "10") Long pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String noticeType,
            @RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(title != null && !title.trim().isEmpty(), Notice::getTitle, title);
        wrapper.eq(noticeType != null && !noticeType.trim().isEmpty(), Notice::getNoticeType, noticeType);
        wrapper.eq(status != null, Notice::getStatus, status);
        wrapper.orderByDesc(Notice::getPublishTime)
                .orderByDesc(Notice::getId);

        Page<Notice> noticePage = noticeService.page(new Page<>(page, pageSize), wrapper);

        // 查询发布人用户名
        for (Notice notice : noticePage.getRecords()) {
            if (notice.getPublisherId() != null) {
                User user = userService.getById(notice.getPublisherId());
                if (user != null) {
                    notice.setPublisherName(user.getRealName() != null ? user.getRealName() : user.getUsername());
                }
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("records", noticePage.getRecords());
        data.put("total", noticePage.getTotal());
        data.put("page", noticePage.getCurrent());
        data.put("pageSize", noticePage.getSize());
        return Result.success(data);
    }

    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id) {
        Notice notice = noticeService.getById(id);
        return Result.success(notice);
    }

    @PostMapping
    public Result<?> add(@RequestBody Notice notice) {
        noticeService.save(notice);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> update(@RequestBody Notice notice) {
        notice.setUpdateTime(null);
        noticeService.updateById(notice);
        return Result.success("更新成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        noticeService.removeById(id);
        return Result.success("删除成功");
    }
}
