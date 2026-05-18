package com.bookmall.service;

import com.bookmall.entity.Cart;
import com.baomidou.mybatisplus.extension.service.IService;

public interface CartService extends IService<Cart> {
  void addToCart(Cart cart);
}
