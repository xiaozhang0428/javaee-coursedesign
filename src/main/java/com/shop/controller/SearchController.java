package com.shop.controller;

import com.shop.service.ProductService;
import com.shop.util.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 搜索控制器
 */
@RestController
@RequestMapping("/search")
public class SearchController {

    @Autowired
    private ProductService productService;

    /**
     * 搜索建议
     */
    @GetMapping("/suggestions")
    public JsonResult<List<String>> getSuggestions(
            @RequestParam(value = "keyword") String keyword,
            @RequestParam(value = "limit", defaultValue = "6") int limit) {
        try {
            List<String> suggestions = productService.getSuggestions(keyword, limit);
            return JsonResult.success(suggestions);
        } catch (Exception e) {
            return JsonResult.error(e.getMessage());
        }
    }
}