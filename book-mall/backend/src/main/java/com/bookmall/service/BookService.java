package com.bookmall.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bookmall.entity.Book;
import java.util.List;

/**
 * 图书 Service 接口
 */
public interface BookService extends IService<Book> {

    /**
     * 模糊搜索图书（按名称、作者、出版社搜索）
     */
    List<Book> searchBooks(String keyword);

    /**
     * 根据分类ID获取图书列表
     */
    List<Book> getBooksByCategory(Long categoryId);

    /**
     * 根据多个分类ID获取图书列表
     */
    List<Book> getBooksByCategories(List<Long> categoryIds);
}
