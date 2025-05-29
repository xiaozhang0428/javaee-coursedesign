package com.shop.service.impl;

import com.shop.mapper.CartMapper;
import com.shop.mapper.ProductMapper;
import com.shop.entity.Cart;
import com.shop.entity.Product;
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
    public List<Cart> findByUserId(Integer userId) {
        if (userId == null) {
            return null;
        }
        return cartMapper.findByUserId(userId);
    }
    
    @Override
    public boolean addToCart(Integer userId, Integer productId, int quantity) {
        if (userId == null || productId == null || quantity <= 0) {
            return false;
        }
        
        // 检查商品是否存在且有库存
        Product product = productMapper.findById(productId);
        if (product == null || product.getStatus() != 1 || product.getStock() < quantity) {
            return false;
        }
        
        // 检查购物车中是否已有该商品
        Cart existingCart = cartMapper.findByUserIdAndProductId(userId, productId);
        if (existingCart != null) {
            // 更新数量
            int newQuantity = existingCart.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                return false;
            }
            return cartMapper.updateQuantity(userId, productId, newQuantity) > 0;
        } else {
            // 新增购物车项
            Cart cart = new Cart(userId, productId, quantity);
            return cartMapper.insert(cart) > 0;
        }
    }
    
    @Override
    public boolean updateQuantity(Integer userId, Integer productId, int quantity) {
        if (userId == null || productId == null || quantity <= 0) {
            return false;
        }
        
        // 检查库存
        Product product = productMapper.findById(productId);
        if (product == null || product.getStock() < quantity) {
            return false;
        }
        
        return cartMapper.updateQuantity(userId, productId, quantity) > 0;
    }
    
    @Override
    public boolean removeFromCart(Integer userId, Integer productId) {
        if (userId == null || productId == null) {
            return false;
        }
        return cartMapper.deleteByUserIdAndProductId(userId, productId) > 0;
    }
    
    @Override
    public boolean clearCart(Integer userId) {
        if (userId == null) {
            return false;
        }
        return cartMapper.deleteByUserId(userId) > 0;
    }
    
    @Override
    public double getTotalAmount(Integer userId) {
        if (userId == null) {
            return 0.0;
        }
        
        List<Cart> cartItems = findByUserId(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return 0.0;
        }
        
        BigDecimal total = BigDecimal.ZERO;
        for (Cart cart : cartItems) {
            if (cart.getProduct() != null && cart.getProduct().getPrice() != null) {
                BigDecimal subtotal = cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity()));
                total = total.add(subtotal);
            }
        }
        
        return total.doubleValue();
    }
}