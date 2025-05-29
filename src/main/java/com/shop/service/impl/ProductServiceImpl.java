package com.shop.service.impl;

import com.shop.dao.ProductDao;
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
    private ProductDao productDao;
    
    @Override
    public List<Product> findAll() {
        return productDao.findAll();
    }
    
    @Override
    public Product findById(Integer id) {
        return productDao.findById(id);
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return productDao.searchByKeyword(keyword.trim());
    }
    
    @Override
    public List<Product> findHotProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productDao.findHotProducts(limit);
    }
    
    @Override
    public List<Product> findLatestProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productDao.findLatestProducts(limit);
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
        return productDao.findByPage(offset, size);
    }
    
    @Override
    public int getTotalCount() {
        return productDao.countAll();
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
        return productDao.insert(product) > 0;
    }
    
    @Override
    public boolean updateProduct(Product product) {
        if (product == null || product.getId() == null) {
            return false;
        }
        return productDao.update(product) > 0;
    }
    
    @Override
    public boolean deleteProduct(Integer id) {
        if (id == null) {
            return false;
        }
        return productDao.deleteById(id) > 0;
    }
}