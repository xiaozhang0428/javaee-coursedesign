package com.shop.controller;

import com.shop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 搜索控制器
 */
@Controller
@RequestMapping("/api/search")
public class SearchController {

    @Autowired
    private ProductService productService;

    /**
     * 获取搜索建议（自动补全）
     */
    @GetMapping("/suggestions")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSearchSuggestions(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "limit", defaultValue = "10") int limit) {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<String> suggestions = productService.getSearchSuggestions(keyword, limit);
            int totalCount = 0;
            
            // 如果有关键词，获取搜索结果总数
            if (keyword != null && !keyword.trim().isEmpty()) {
                totalCount = productService.countSearchResults(keyword);
            }
            
            result.put("success", true);
            result.put("suggestions", suggestions);
            result.put("totalCount", totalCount);
            result.put("keyword", keyword);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取搜索建议失败");
            return ResponseEntity.ok(result);
        }
    }

    /**
     * 获取热门搜索关键词
     */
    @GetMapping("/hot-keywords")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getHotSearchKeywords(
            @RequestParam(value = "limit", defaultValue = "10") int limit) {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<String> hotKeywords = productService.getHotSearchKeywords(limit);
            result.put("success", true);
            result.put("keywords", hotKeywords);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取热门关键词失败");
            return ResponseEntity.ok(result);
        }
    }
}