package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.Book;
import com.bookmall.entity.User;
import com.bookmall.mapper.OrderItemMapper;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.BookService;
import com.bookmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderItemServiceImpl extends ServiceImpl<OrderItemMapper, OrderItem> implements OrderItemService {

    @Autowired
    private BookService bookService;

    @Autowired
    private UserService userService;

    @Override
    public List<OrderItem> getOrderItems(Long orderId) {
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = this.list(wrapper);

        for (OrderItem item : items) {
            Book book = bookService.getById(item.getBookId());
            if (book != null) {
                item.setBookName(book.getBookName());
                item.setCoverImage(book.getCoverImage());
                item.setMerchantId(book.getMerchantId());
                item.setAuthor(book.getAuthor());

                if (book.getMerchantId() != null) {
                    User merchant = userService.getById(book.getMerchantId());
                    if (merchant != null) {
                        item.setMerchantName(
                                merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
                        item.setMerchantPhone(merchant.getPhone());
                    }
                }
            }
        }

        return items;
    }

    @Override
    public void updateStatusByOrderId(Long orderId, String status) {
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        OrderItem updateItem = new OrderItem();
        updateItem.setStatus(status);
        this.update(updateItem, wrapper);
    }
}
