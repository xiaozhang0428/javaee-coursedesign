package com.shop.service.impl;

import com.shop.entity.*;
import com.shop.mapper.OrderItemMapper;
import com.shop.mapper.OrderMapper;
import com.shop.service.CartService;
import com.shop.service.OrderService;
import com.shop.service.ProductService;
import com.shop.util.Either;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
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

    @Autowired
    private ProductService productService;

    @Override
    public List<Order> findByUserId(int userId) {
        return orderMapper.findByUserId(userId);
    }

    @Override
    public Order findById(int id) {
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
    public Either<Order> createOrder(User user, List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return Either.error("空订单");
        }

        // 获取购物车中选中的商品
        List<Cart> cartItems = cartService.findByUserId(user.getId());
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
            return Either.error("空订单");
        }

        // 创建订单
        Order order = new Order(user.getId(), totalAmount, 0, user.getAddress(), new Date());
        if (orderMapper.insert(order) <= 0) {
            return Either.error("订单创建失败");
        }

        // 删除库存 建立订单明细
        List<OrderItem> orderItems = new ArrayList<>();
        for (Cart item : selectedItems) {
            Product product = productService.findById(item.getProductId());
            if (product == null) {
                return Either.error("商品 %s 不存在", item.getProduct().getName());
            }
            if (product.getStock() >= item.getQuantity()) {
                product.setStock(product.getStock() - item.getQuantity());
                product.setSales(product.getSales() + item.getQuantity());
                if (!productService.updateProduct(product)) {
                    // 更新失败
                    return Either.error("商品 %s 更新失败", product.getName());
                }
            } else {
                // 库存不足
                return Either.error("商品 %s 库存不足", product.getName());
            }

            // 订单明细
            orderItems.add(OrderItem.forCreate(order.getId(), item.getProductId(), item.getQuantity(), item.getProduct().getPrice(), product));
        }

        if (orderItemMapper.batchInsert(orderItems) < orderItems.size()) {
            // 未全部插入
            return Either.error("订单明细更新失败");
        }

        // 从购物车中删除已结算的商品
        for (Cart item : selectedItems) {
            cartService.removeFromCart(user.getId(), item.getProductId());
        }

        return Either.of(order);
    }

    @Override
    public boolean updateStatus(int orderId, int status) {
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
    public int countByUserId(int userId) {
        return orderMapper.countByUserId(userId);
    }

    @Override
    public Either<String> buyAgain(int userId, int orderId) {
        // 获取订单详情
        Order order = findById(orderId);
        if (order == null) {
            return Either.error("订单不存在");
        }
        
        if (order.getUserId() != userId) {
            return Either.error("无权限操作此订单");
        }
        
        // 获取订单商品列表
        List<OrderItem> orderItems = order.getOrderItems();
        if (orderItems == null || orderItems.isEmpty()) {
            return Either.error("订单中没有商品");
        }
        
        int addedCount = 0;
        StringBuilder errorMessages = new StringBuilder();
        
        // 将订单中的商品添加到购物车
        for (OrderItem item : orderItems) {
            String result = cartService.addToCart(userId, item.getProductId(), item.getQuantity());
            if (result == null) {
                addedCount++;
            } else {
                if (errorMessages.length() > 0) {
                    errorMessages.append("; ");
                }
                errorMessages.append(item.getProduct().getName()).append(": ").append(result);
            }
        }
        
        if (addedCount == 0) {
            return Either.error("所有商品添加失败: " + errorMessages.toString());
        } else if (addedCount < orderItems.size()) {
            return Either.error("部分商品添加成功(" + addedCount + "/" + orderItems.size() + "), 失败原因: " + errorMessages.toString());
        } else {
            return Either.of("成功添加 " + addedCount + " 件商品到购物车");
        }
    }
}