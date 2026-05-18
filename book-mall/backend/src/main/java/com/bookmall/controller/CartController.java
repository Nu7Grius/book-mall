package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.Cart;
import com.bookmall.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cart")
@CrossOrigin
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/list")
    public Result<List<Cart>> list() {
        List<Cart> list = cartService.list();
        return Result.success(list);
    }

    @GetMapping("/{id}")
    public Result<Cart> getById(@PathVariable Long id) {
        Cart cart = cartService.getById(id);
        return Result.success(cart);
    }

    @PostMapping("/add")
    public Result<?> addToCart(@RequestBody Cart cart) {
        cartService.addToCart(cart);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> update(@RequestBody Cart cart) {
        cart.setUpdateTime(null);
        cartService.updateById(cart);
        return Result.success("更新成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        cartService.removeById(id);
        return Result.success("删除成功");
    }
}
