package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.entity.Category;
import com.bookmall.mapper.CategoryMapper;
import com.bookmall.service.CategoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

  @Override
  public List<Category> getTreeList() {
    LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
    wrapper.orderByAsc(Category::getSortOrder);
    List<Category> allCategories = this.list(wrapper);

    Map<Long, List<Category>> childrenMap = allCategories.stream()
        .filter(c -> c.getParentId() != null && c.getParentId() != 0)
        .collect(Collectors.groupingBy(Category::getParentId));

    List<Category> rootCategories = allCategories.stream()
        .filter(c -> c.getParentId() == null || c.getParentId() == 0)
        .collect(Collectors.toList());

    for (Category parent : rootCategories) {
      List<Category> children = childrenMap.get(parent.getId());
      if (children != null && !children.isEmpty()) {
        parent.setChildren(children);
      }
    }

    return rootCategories;
  }

  @Override
  public List<Category> getFlatList() {
    LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
    wrapper.orderByAsc(Category::getSortOrder);
    List<Category> allCategories = this.list(wrapper);
    return allCategories;
  }

  @Override
  public Map<String, Object> getCategoryPage(Integer page, Integer pageSize, String categoryName,
      Integer categoryLevel) {
    LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
    wrapper.like(categoryName != null && !categoryName.trim().isEmpty(), Category::getCategoryName, categoryName);
    wrapper.eq(categoryLevel != null, Category::getCategoryLevel, categoryLevel);
    wrapper.orderByAsc(Category::getSortOrder).orderByDesc(Category::getCreateTime);

    Page<Category> categoryPage = this.page(new Page<>(page, pageSize), wrapper);

    LambdaQueryWrapper<Category> parentWrapper = new LambdaQueryWrapper<>();
    parentWrapper.eq(Category::getParentId, 0);
    parentWrapper.select(Category::getId, Category::getCategoryName);
    Map<Long, String> parentMap = this.list(parentWrapper).stream()
        .collect(Collectors.toMap(Category::getId, Category::getCategoryName));

    categoryPage.getRecords().forEach(category -> {
      if (category.getParentId() != null && category.getParentId() != 0) {
        category.setParentName(parentMap.getOrDefault(category.getParentId(), "未知"));
      }
    });

    Map<String, Object> result = new HashMap<>();
    result.put("records", categoryPage.getRecords());
    result.put("total", categoryPage.getTotal());
    result.put("page", categoryPage.getCurrent());
    result.put("pageSize", categoryPage.getSize());
    return result;
  }

  @Override
  public List<Long> getAllChildIds(Long parentId) {
    List<Long> result = new ArrayList<>();
    result.add(parentId);

    LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
    wrapper.eq(Category::getParentId, parentId);
    List<Category> children = this.list(wrapper);

    for (Category child : children) {
      result.add(child.getId());
      List<Long> grandChildrenIds = getAllChildIds(child.getId());
      result.addAll(grandChildrenIds);
    }

    return result;
  }
}
