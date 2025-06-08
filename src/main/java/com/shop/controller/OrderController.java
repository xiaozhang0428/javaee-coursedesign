package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.User;
import com.shop.service.OrderService;
import com.shop.util.Either;
import com.shop.util.JsonResult;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

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

    /**
     * 订单详情页面
     */
    @RequestMapping("/detail/{id}")
    public String orderDetail(@PathVariable("id") int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Order order = orderService.findById(id);
        if (order == null || order.getUserId() != user.getId()) {
            return "redirect:/order/orders";
        }

        model.addAttribute("order", order);
        return "order-detail";
    }

    /**
     * 结算页面
     */
    @RequestMapping("/checkout")
    public String checkout(@RequestParam("productIds") List<Integer> productIds, 
                          HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        if (productIds == null || productIds.isEmpty()) {
            return "redirect:/cart";
        }

        model.addAttribute("productIds", productIds);
        model.addAttribute("user", user);
        return "checkout";
    }

    /**
     * 创建订单
     */
    @PostMapping("/create")
    @ResponseBody
    public JsonResult<Order> createOrder(@RequestParam("productIds") List<Integer> productIds,
                                        @RequestParam(value = "shippingAddress", required = false) String shippingAddress,
                                        HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        // 如果提供了新的收货地址，更新用户地址
        if (shippingAddress != null && !shippingAddress.trim().isEmpty()) {
            user.setAddress(shippingAddress.trim());
        }

        Either<Order> result = orderService.createOrder(user, productIds);
        if (!result.isSuccess()) {
            return JsonResult.error(result.error());
        }

        return JsonResult.success(result.result());
    }

    /**
     * 更新订单状态
     */
    @PostMapping("/updateStatus")
    @ResponseBody
    public JsonResult<String> updateOrderStatus(@RequestParam int orderId, 
                                               @RequestParam int status,
                                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        // 验证订单是否属于当前用户
        Order order = orderService.findById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            return JsonResult.error("订单不存在");
        }

        // 根据当前状态和目标状态判断是否允许操作
        switch (status) {
            case -1: // 取消订单
                if (order.getStatus() == 0) {
                    boolean success = orderService.updateStatus(orderId, -1);
                    return success ? JsonResult.success("订单已取消") : JsonResult.error("取消失败");
                } else {
                    return JsonResult.error("只能取消待支付的订单");
                }
            
            case 1: // 支付订单
                if (order.getStatus() == 0) {
                    boolean success = orderService.updateStatus(orderId, 1);
                    return success ? JsonResult.success("支付成功") : JsonResult.error("支付失败");
                } else {
                    return JsonResult.error("订单状态不正确，无法支付");
                }
            
            case 2: // 发货（管理员操作，这里暂不实现）
                return JsonResult.error("无权限执行此操作");
            
            case 3: // 确认收货
                if (order.getStatus() == 2) {
                    boolean success = orderService.updateStatus(orderId, 3);
                    return success ? JsonResult.success("确认收货成功") : JsonResult.error("确认收货失败");
                } else {
                    return JsonResult.error("订单状态不正确，无法确认收货");
                }
            
            default:
                return JsonResult.error("无效的状态参数");
        }
    }

    /**
     * 根据状态筛选订单
     */
    @GetMapping("/filter")
    @ResponseBody
    public JsonResult<List<Order>> filterOrders(@RequestParam(required = false) Integer status,
                                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        List<Order> orders;
        if (status == null) {
            orders = orderService.findByUserId(user.getId());
        } else {
            // 这里需要在OrderService中添加根据用户ID和状态查询的方法
            orders = orderService.findByUserId(user.getId());
            orders = orders.stream()
                    .filter(order -> order.getStatus() == status)
                    .toList();
        }

        return JsonResult.success(orders);
    }

    /**
     * 再次购买（将订单中的商品添加到购物车）
     */
    @PostMapping("/buyAgain")
    @ResponseBody
    public JsonResult<String> buyAgain(@RequestBody Map<String, Integer> request,
                                      HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        Integer orderId = request.get("orderId");
        if (orderId == null) {
            return JsonResult.error("订单ID不能为空");
        }

        // 验证订单是否属于当前用户
        Order order = orderService.findById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            return JsonResult.error("订单不存在");
        }

        Either<String> result = orderService.buyAgain(user.getId(), orderId);
        if (!result.isSuccess()) {
            return JsonResult.error(result.error());
        }

        return JsonResult.success(result.result());
    }
}
