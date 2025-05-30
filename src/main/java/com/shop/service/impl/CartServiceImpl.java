package com.shop.service.impl;

import com.shop.entity.Cart;
import com.shop.entity.Product;
import com.shop.mapper.CartMapper;
import com.shop.mapper.ProductMapper;
import com.shop.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * 购物车服务实现类
 */
@Service
public class CartServiceImpl implements CartService {
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private ProductMapper productMapper;
    
    @Override
    public List<Cart> findByUserId(int userId) {
        return cartMapper.findByUserId(userId);
    }
    
    @Override
    public String addToCart(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return "参数错误";
        }
        
        Product product = productMapper.findById(productId);
        if (product == null || product.getStatus() != 1 || product.getStock() < quantity) {
            return "库存不足";
        }
        
        Cart existingCart = cartMapper.findByUserIdAndProductId(userId, productId);
        if (existingCart != null) {
            // 更新数量
            int newQuantity = existingCart.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                return "库存不足";
            }
            if (cartMapper.updateQuantity(userId, productId, newQuantity) > 0) {
                return null;
            }
        } else {
            // 新增购物车项
            Cart cart = new Cart(userId, productId, quantity, null);
            if (cartMapper.insert(cart) > 0) {
                return null;
            }
        }

        return "添加失败";
    }
    
    @Override
    public String updateQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return "参数错误";
        }
        
        // 检查库存
        Product product = productMapper.findById(productId);
        if (product == null || product.getStock() < quantity) {
            return "库存不足";
        }
        
        return cartMapper.updateQuantity(userId, productId, quantity) > 0 ? null : "更新失败";
    }
    
    @Override
    public boolean removeFromCart(int userId, int productId) {
        return cartMapper.deleteByUserIdAndProductId(userId, productId) > 0;
    }
    
    @Override
    public boolean clearCart(int userId) {
        return cartMapper.deleteByUserId(userId) > 0;
    }
    
    @Override
    public double getTotalAmount(int userId) {
        return findByUserId(userId).stream()
                .filter(cart -> cart.getProduct() != null && cart.getProduct().getPrice() != null)
                .map(cart -> cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .doubleValue();
    }
}