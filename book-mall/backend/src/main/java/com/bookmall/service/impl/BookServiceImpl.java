package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.Book;
import com.bookmall.mapper.BookMapper;
import com.bookmall.service.BookService;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 图书 Service 实现类
 */
@Service
public class BookServiceImpl extends ServiceImpl<BookMapper, Book> implements BookService {

    @Override
    public List<Book> searchBooks(String keyword) {
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(Book::getBookName, keyword)
                .or()
                .like(Book::getAuthor, keyword)
                .or()
                .like(Book::getPublisher, keyword);
        queryWrapper.eq(Book::getStatus, 1);
        return this.list(queryWrapper);
    }

    @Override
    public List<Book> getBooksByCategory(Long categoryId) {
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Book::getCategoryId, categoryId);
        queryWrapper.eq(Book::getStatus, 1);
        List<Book> books = this.list(queryWrapper);
        return books;
    }

    @Override
    public List<Book> getBooksByCategories(List<Long> categoryIds) {
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(Book::getCategoryId, categoryIds);
        queryWrapper.eq(Book::getStatus, 1);
        List<Book> books = this.list(queryWrapper);
        return books;
    }
}
