package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.Book;
import com.bookmall.entity.BookFavorite;
import com.bookmall.service.BookFavoriteService;
import com.bookmall.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/favorite")
@CrossOrigin
public class BookFavoriteController {

    @Autowired
    private BookFavoriteService bookFavoriteService;

    @Autowired
    private BookService bookService;

    @GetMapping("/user/{userId}")
    public Result<List<Book>> getUserFavorites(@PathVariable Long userId) {
        List<BookFavorite> favorites = bookFavoriteService.getByUserId(userId);
        if (favorites.isEmpty()) {
            return Result.success(Collections.emptyList());
        }

        List<Long> bookIds = favorites.stream()
                .map(BookFavorite::getBookId)
                .collect(Collectors.toList());

        List<Book> books = bookService.listByIds(bookIds);

        Map<Long, Book> bookMap = books.stream()
                .collect(Collectors.toMap(Book::getId, b -> b));

        List<Book> orderedBooks = favorites.stream()
                .map(fav -> bookMap.get(fav.getBookId()))
                .filter(b -> b != null)
                .collect(Collectors.toList());

        return Result.success(orderedBooks);
    }

    @GetMapping("/check")
    public Result<Boolean> checkFavorite(@RequestParam Long userId, @RequestParam Long bookId) {
        boolean isFavorited = bookFavoriteService.isFavorited(userId, bookId);
        return Result.success(isFavorited);
    }

    @PostMapping("/add")
    public Result<?> addFavorite(@RequestBody Map<String, Long> params) {
        Long userId = params.get("userId");
        Long bookId = params.get("bookId");

        if (userId == null || bookId == null) {
            return Result.error("参数错误");
        }

        bookFavoriteService.addFavorite(userId, bookId);
        return Result.success("收藏成功");
    }

    @DeleteMapping("/remove")
    public Result<?> removeFavorite(@RequestParam Long userId, @RequestParam Long bookId) {
        bookFavoriteService.removeFavorite(userId, bookId);
        return Result.success("取消收藏成功");
    }
}
