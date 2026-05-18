package com.bookmall.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bookmall.entity.BookComment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BookCommentMapper extends BaseMapper<BookComment> {
}
