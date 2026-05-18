package com.bookmall.service;

import com.bookmall.entity.Category;
import com.baomidou.mybatisplus.extension.service.IService;
import java.util.List;
import java.util.Map;

public interface CategoryService extends IService<Category> {
  Map<String, Object> getCategoryPage(Integer page, Integer pageSize, String categoryName, Integer categoryLevel);

  List<Category> getTreeList();

  List<Long> getAllChildIds(Long parentId);
}
