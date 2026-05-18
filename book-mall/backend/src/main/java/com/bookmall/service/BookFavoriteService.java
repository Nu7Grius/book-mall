package com.bookmall.service;

import com.bookmall.entity.BookFavorite;
import java.util.List;

public interface BookFavoriteService {

    List<BookFavorite> getByUserId(Long userId);

    boolean isFavorited(Long userId, Long bookId);

    void addFavorite(Long userId, Long bookId);

    void removeFavorite(Long userId, Long bookId);

    void removeById(Long id);
}
