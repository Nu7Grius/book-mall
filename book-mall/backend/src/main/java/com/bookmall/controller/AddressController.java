package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.Address;
import com.bookmall.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/address")
@CrossOrigin
public class AddressController {

    @Autowired
    private AddressService addressService;

    @GetMapping("/list")
    public Result<List<Address>> list(@RequestParam(required = false) Long userId) {
        List<Address> list;
        if (userId != null) {
            list = addressService.getByUserId(userId);
        } else {
            list = addressService.list();
        }
        return Result.success(list);
    }

    @GetMapping("/user/{userId}")
    public Result<List<Address>> getByUserId(@PathVariable Long userId) {
        List<Address> list = addressService.getByUserId(userId);
        return Result.success(list);
    }

    @GetMapping("/{id}")
    public Result<Address> getById(@PathVariable Long id) {
        Address address = addressService.getById(id);
        return Result.success(address);
    }

    @PostMapping
    public Result<?> add(@RequestBody Address address) {
        long count = addressService.lambdaQuery()
                .eq(Address::getUserId, address.getUserId())
                .count();
        if (count == 0) {
            address.setIsDefault(1);
        } else {
            address.setIsDefault(0);
        }
        addressService.save(address);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> update(@RequestBody Address address) {
        Address existAddress = addressService.getById(address.getId());
        if (existAddress == null) {
            return Result.error("地址不存在");
        }

        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            addressService.lambdaUpdate()
                    .eq(Address::getUserId, existAddress.getUserId())
                    .set(Address::getIsDefault, 0)
                    .update();
        }

        addressService.updateById(address);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        addressService.removeById(id);
        return Result.success("删除成功");
    }

    @PutMapping("/default/{id}")
    public Result<?> setDefault(@PathVariable Long id) {
        Address address = addressService.getById(id);
        if (address == null) {
            return Result.error("地址不存在");
        }

        addressService.lambdaUpdate()
                .eq(Address::getUserId, address.getUserId())
                .set(Address::getIsDefault, 0)
                .update();

        address.setIsDefault(1);
        addressService.updateById(address);

        return Result.success("设置默认地址成功");
    }
}
