package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.Category;
import com.bookmall.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/category")
@CrossOrigin
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/list")
    public Result<List<Category>> list() {
        List<Category> treeList = categoryService.getTreeList();
        return Result.success(treeList);
    }

    @GetMapping("/flat-list")
    public Result<List<Category>> flatList() {
        List<Category> flatList = categoryService.getFlatList();
        return Result.success(flatList);
    }

    @GetMapping("/page")
    public Result<Map<String, Object>> getCategoryPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String categoryName,
            @RequestParam(required = false) Integer categoryLevel) {
        Map<String, Object> data = categoryService.getCategoryPage(page, pageSize, categoryName, categoryLevel);
        return Result.success("查询成功", data);
    }

    @GetMapping("/{id}")
    public Result<Category> getById(@PathVariable Long id) {
        Category category = categoryService.getById(id);
        return Result.success(category);
    }

    @PostMapping
    public Result<?> add(@RequestBody Category category) {
        categoryService.save(category);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> update(@RequestBody Category category) {
        category.setUpdateTime(null);
        categoryService.updateById(category);
        return Result.success("更新成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        categoryService.removeById(id);
        return Result.success("删除成功");
    }
}
