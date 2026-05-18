package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.BookFavorite;
import com.bookmall.mapper.BookFavoriteMapper;
import com.bookmall.service.BookFavoriteService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class BookFavoriteServiceImpl extends ServiceImpl<BookFavoriteMapper, BookFavorite>
        implements BookFavoriteService {

    @Override
    public List<BookFavorite> getByUserId(Long userId) {
        LambdaQueryWrapper<BookFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookFavorite::getUserId, userId)
                .orderByDesc(BookFavorite::getCreateTime)
                .orderByDesc(BookFavorite::getId);
        return this.list(wrapper);
    }

    @Override
    public boolean isFavorited(Long userId, Long bookId) {
        LambdaQueryWrapper<BookFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookFavorite::getUserId, userId)
                .eq(BookFavorite::getBookId, bookId);
        return this.count(wrapper) > 0;
    }

    @Override
    public void addFavorite(Long userId, Long bookId) {
        if (!isFavorited(userId, bookId)) {
            BookFavorite favorite = new BookFavorite();
            favorite.setUserId(userId);
            favorite.setBookId(bookId);
            favorite.setCreateTime(LocalDateTime.now());
            this.save(favorite);
        }
    }

    @Override
    public void removeFavorite(Long userId, Long bookId) {
        LambdaQueryWrapper<BookFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookFavorite::getUserId, userId)
                .eq(BookFavorite::getBookId, bookId);
        this.remove(wrapper);
    }

    @Override
    public void removeById(Long id) {
        baseMapper.deleteById(id);
    }
}
