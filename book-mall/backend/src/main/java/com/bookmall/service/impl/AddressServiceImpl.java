package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.bookmall.entity.Address;
import com.bookmall.mapper.AddressMapper;
import com.bookmall.service.AddressService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AddressServiceImpl extends ServiceImpl<AddressMapper, Address> implements AddressService {

  @Override
  public List<Address> getByUserId(Long userId) {
    LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
    wrapper.eq(Address::getUserId, userId)
        .orderByDesc(Address::getIsDefault)
        .orderByDesc(Address::getCreateTime)
        .orderByDesc(Address::getId);
    return this.list(wrapper);
  }
}
