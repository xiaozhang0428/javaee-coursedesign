package com.shop.service.impl;

import com.shop.entity.Order;
import com.shop.entity.OrderItem;
import com.shop.entity.Cart;
import com.shop.mapper.OrderMapper;
import com.shop.mapper.OrderItemMapper;
import com.shop.service.OrderService;
import com.shop.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单服务实现类
 */
@Service
public class OrderServiceImpl implements OrderService {
    
    @Autowired
    private OrderMapper orderMapper;
    
    @Autowired
    private OrderItemMapper orderItemMapper;
    
    @Autowired
    private CartService cartService;
    
    @Override
    public List<Order> findByUserId(Integer userId) {
        if (userId == null) {
            return new ArrayList<>();
        }
        return orderMapper.findByUserId(userId);
    }
    
    @Override
    public Order findById(Integer id) {
        if (id == null) {
            return null;
        }
        Order order = orderMapper.findById(id);
        if (order != null) {
            // 加载订单明细
            List<OrderItem> orderItems = orderItemMapper.findByOrderId(id);
            order.setOrderItems(orderItems);
        }
        return order;
    }
    
    @Override
    @Transactional
    public Order createOrder(Integer userId, List<Integer> productIds) {
        if (userId == null || productIds == null || productIds.isEmpty()) {
            return null;
        }
        
        // 获取购物车中选中的商品
        List<Cart> cartItems = cartService.findByUserId(userId);
        List<Cart> selectedItems = new ArrayList<>();
        BigDecimal totalAmount = BigDecimal.ZERO;
        
        for (Cart cart : cartItems) {
            if (productIds.contains(cart.getProductId())) {
                selectedItems.add(cart);
                BigDecimal itemTotal = cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity()));
                totalAmount = totalAmount.add(itemTotal);
            }
        }
        
        if (selectedItems.isEmpty()) {
            return null;
        }
        
        // 创建订单
        Order order = new Order(userId, totalAmount);
        Integer result = orderMapper.insert(order);
        
        if (result > 0 && order.getId() != null) {
            // 创建订单明细
            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart cart : selectedItems) {
                OrderItem orderItem = new OrderItem(
                    order.getId(),
                    cart.getProductId(),
                    cart.getQuantity(),
                    cart.getProduct().getPrice()
                );
                orderItems.add(orderItem);
            }
            
            // 批量插入订单明细
            orderItemMapper.batchInsert(orderItems);
            
            // 从购物车中删除已结算的商品
            for (Integer productId : productIds) {
                cartService.removeFromCart(userId, productId);
            }
            
            return order;
        }
        
        return null;
    }
    
    @Override
    public boolean updateStatus(Integer orderId, Integer status) {
        if (orderId == null || status == null) {
            return false;
        }
        return orderMapper.updateStatus(orderId, status) > 0;
    }
    
    @Override
    public List<Order> findByPage(int page, int size) {
        int offset = (page - 1) * size;
        return orderMapper.findByPage(offset, size);
    }
    
    @Override
    public int countAll() {
        return orderMapper.countAll();
    }
    
    @Override
    public int countByUserId(Integer userId) {
        if (userId == null) {
            return 0;
        }
        return orderMapper.countByUserId(userId);
    }
}