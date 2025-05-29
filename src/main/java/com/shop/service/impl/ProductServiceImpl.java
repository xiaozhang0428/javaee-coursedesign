package com.shop.service.impl;

import com.shop.mapper.ProductMapper;
import com.shop.entity.Product;
import com.shop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 商品服务实现类
 */
@Service
public class ProductServiceImpl implements ProductService {
    
    @Autowired
    private ProductMapper productMapper;
    
    @Override
    public List<Product> findAll() {
        return productMapper.findAll();
    }
    
    @Override
    public Product findById(Integer id) {
        return productMapper.findById(id);
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return productMapper.searchByKeyword(keyword.trim());
    }
    
    @Override
    public List<Product> searchProducts(String keyword, String sort) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findByPage(1, 100, sort); // 返回前100个商品
        }
        return productMapper.searchByKeywordWithSort(keyword.trim(), sort);
    }
    
    @Override
    public List<Product> findHotProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productMapper.findHotProducts(limit);
    }
    
    @Override
    public List<Product> findLatestProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productMapper.findLatestProducts(limit);
    }
    
    @Override
    public List<Product> findByPage(int page, int size) {
        if (page < 1) {
            page = 1;
        }
        if (size <= 0) {
            size = 10;
        }
        int offset = (page - 1) * size;
        return productMapper.findByPage(offset, size);
    }
    
    @Override
    public List<Product> findByPage(int page, int size, String sort) {
        if (page < 1) {
            page = 1;
        }
        if (size <= 0) {
            size = 10;
        }
        int offset = (page - 1) * size;
        return productMapper.findByPageWithSort(offset, size, sort);
    }
    
    @Override
    public int getTotalCount() {
        return productMapper.countAll();
    }
    
    @Override
    public boolean addProduct(Product product) {
        if (product == null) {
            return false;
        }
        product.setCreateTime(new Date());
        if (product.getStatus() == null) {
            product.setStatus(1);
        }
        if (product.getSales() == null) {
            product.setSales(0);
        }
        return productMapper.insert(product) > 0;
    }
    
    @Override
    public boolean updateProduct(Product product) {
        if (product == null || product.getId() == null) {
            return false;
        }
        return productMapper.update(product) > 0;
    }
    
    @Override
    public boolean deleteProduct(Integer id) {
        if (id == null) {
            return false;
        }
        return productMapper.deleteById(id) > 0;
    }
}