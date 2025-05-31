package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.User;
import com.shop.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 我的订单页面
     */
    @RequestMapping("/orders")
    public String orders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Order> orders = orderService.findByUserId(user.getId());
        model.addAttribute("orders", orders);
        return "orders";
    }
}
