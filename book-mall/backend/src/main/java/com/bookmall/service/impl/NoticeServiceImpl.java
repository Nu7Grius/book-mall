package com.bookmall.service.impl;

import com.bookmall.entity.Notice;
import com.bookmall.mapper.NoticeMapper;
import com.bookmall.service.NoticeService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class NoticeServiceImpl extends ServiceImpl<NoticeMapper, Notice> implements NoticeService {
}
