package com.bookmall.service;

import com.bookmall.entity.Address;
import com.baomidou.mybatisplus.extension.service.IService;
import java.util.List;

public interface AddressService extends IService<Address> {
  List<Address> getByUserId(Long userId);
}
