package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.bookmall.entity.Cart;
import com.bookmall.entity.Book;
import com.bookmall.mapper.CartMapper;
import com.bookmall.service.CartService;
import com.bookmall.service.BookService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CartServiceImpl extends ServiceImpl<CartMapper, Cart> implements CartService {

  @Autowired
  private BookService bookService;

  @Override
  public void addToCart(Cart cart) {
    LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
    wrapper.eq(Cart::getUserId, cart.getUserId())
        .eq(Cart::getBookId, cart.getBookId());
    Cart existCart = this.getOne(wrapper);

    if (existCart != null) {
      existCart.setQuantity(existCart.getQuantity() + cart.getQuantity());
      existCart.setUpdateTime(LocalDateTime.now());
      this.updateById(existCart);
    } else {
      cart.setCreateTime(LocalDateTime.now());
      cart.setUpdateTime(LocalDateTime.now());
      this.save(cart);
    }
  }

  @Override
  public List<Cart> list() {
    QueryWrapper<Cart> wrapper = new QueryWrapper<>();
    wrapper.orderByDesc("update_time").orderByDesc("id");
    List<Cart> carts = baseMapper.selectList(wrapper);

    for (Cart cart : carts) {
      Book book = bookService.getById(cart.getBookId());
      if (book != null) {
        cart.setBook(book);
        cart.setBookName(book.getBookName());
        cart.setBookPrice(book.getPrice());
        cart.setCoverImage(book.getCoverImage());
      }
    }
    return carts;
  }
}
