package com.bookmall;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 图书商城系统启动类
 */
@SpringBootApplication
@MapperScan("com.bookmall.mapper") // 扫描 Mapper 接口
public class BookMallApplication {
  public static void main(String[] args) {
    SpringApplication.run(BookMallApplication.class, args);
  }
}
