package com.shop.controller;

import com.shop.entity.User;
import com.shop.entity.Order;
import com.shop.service.UserService;
import com.shop.service.OrderService;
import com.shop.util.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Random;
import java.util.List;

/**
 * 用户控制器
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private OrderService orderService;

    /**
     * 登录
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * 注册
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }

    /**
     * 用户登录
     */
    @ResponseBody
    @PostMapping("/login")
    public JsonResult<String> login(@RequestBody UserLoginRequest user, HttpSession session) {
        User loginedUser = userService.login(user.getUsername().trim(), user.getPassword());
        if (loginedUser != null) {
            // 登录成功，保存用户信息到session
            session.setAttribute("user", loginedUser);
            return JsonResult.success("登录成功", user.getRedirect());
        } else {
            return JsonResult.error("用户名或密码错误");
        }
    }

    /**
     * 用户注册
     */
    @ResponseBody
    @PostMapping("/register")
    public JsonResult<String> register(@RequestBody UserRegisterRequest user,
                                       HttpSession session) {
        String username = user.getUsername();
        if (username == null || username.length() < 3 || username.length() > 20) {
            return JsonResult.error("用户名长度为3-20个字符");
        }
        username = username.trim();
        if (userService.isUsernameExists(username.trim())) {
            return JsonResult.error("用户名已存在");
        }

        String password = user.getPassword();
        if (password == null || password.length() < 6) {
            return JsonResult.error("密码长度不少于6位");
        }

        String email = user.getEmail();
        if (!StringUtils.isEmail(email)) {
            return JsonResult.error("邮箱格式不正确");
        }
        if (userService.isEmailExists(email.trim())) {
            return JsonResult.error("邮箱已存在");
        }

        User registeredUser = User.forRegister(username, password, email);
        if (userService.register(registeredUser)) {
            session.setAttribute("user", registeredUser);
            return JsonResult.success("注册成功", user.getRedirect());
        } else {
            return JsonResult.error("注册失败，请稍后重试");
        }
    }

    /**
     * 用户退出
     */
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 个人中心
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 获取最新的用户信息
        User currentUser = userService.findById(user.getId());
        model.addAttribute("user", currentUser);

        return "profile";
    }

    /**
     * 更新个人信息
     */
    @ResponseBody
    @PostMapping("/profile")
    public JsonResult<Void> updateProfile(@RequestBody UpdateProfileRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (request.getEmail() != null && !StringUtils.isEmail(request.getEmail())) {
            return JsonResult.error("邮箱格式错误");
        }

        if (request.getEmail() != null && userService.isEmailExists(request.getEmail())) {
            return JsonResult.error("邮箱已存在");
        }

        if (request.getPhone() != null && !StringUtils.isPhone(request.getPhone())) {
            return JsonResult.error("手机号码格式错误");
        }

        user.apply(request);
        if (userService.updateUser(user)) {
            // 更新session中的用户信息
            User newUser = userService.findById(user.getId());
            session.setAttribute("user", newUser);
            return JsonResult.success("更新成功");
        } else {
            return JsonResult.error("更新失败");
        }
    }

    /**
     * 修改密码
     */
    @PostMapping("/password")
    @ResponseBody
    public JsonResult<String> updatePassword(@RequestBody UpdatePasswordRequest request, HttpSession session) {

        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return JsonResult.error("请先登录");
        }

        String oldPassword = request.getOldPassword();
        String newPassword = request.getNewPassword();

        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            return JsonResult.error("原密码不能为空");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            return JsonResult.error("新密码不能为空");
        }

        if (newPassword.length() < 6) {
            return JsonResult.error("新密码长度不能少于6位");
        }

        // 验证原密码
        User user = userService.findById(sessionUser.getId());
        if (!user.getPassword().equals(StringUtils.md5(oldPassword))) {
            return JsonResult.error("原密码错误");
        }

        // 更新密码
        user.setPassword(StringUtils.md5(newPassword));
        if (userService.updateUser(user)) {
            session.setAttribute("user", null);
            return JsonResult.success("密码修改成功");
        } else {
            return JsonResult.error("密码修改失败");
        }
    }

    /**
     * 提交订单并处理支付
     * 先模拟支付，支付成功后创建订单
     */
    @ResponseBody
    @PostMapping("/submitOrder")
    public JsonResult<OrderSubmissionResult> submitOrder(@RequestParam("productIds") List<Integer> productIds,
                                                        @RequestParam("paymentMethod") String paymentMethod,
                                                        @RequestParam(value = "shippingAddress", required = false) String shippingAddress,
                                                        HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (productIds == null || productIds.isEmpty()) {
            return JsonResult.error("请选择要购买的商品");
        }

        // 如果提供了新的收货地址，更新用户地址
        if (shippingAddress != null && !shippingAddress.trim().isEmpty()) {
            user.setAddress(shippingAddress.trim());
        }

        System.out.println("开始处理订单提交 - 用户ID: " + user.getId() + ", 商品数量: " + productIds.size() + ", 支付方式: " + paymentMethod);

        // 模拟支付处理时间
        try {
            Thread.sleep(1000 + new Random().nextInt(2000)); // 1-3秒随机延迟
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 随机生成支付结果 (80%成功率，提高成功率便于测试)
        Random random = new Random();
        boolean paymentSuccess = random.nextInt(100) < 80;
        
        OrderSubmissionResult result = new OrderSubmissionResult();
        result.setPaymentMethod(paymentMethod);
        result.setPaymentSuccess(paymentSuccess);
        
        if (paymentSuccess) {
            // 支付成功，创建订单
            try {
                Either<Order> orderResult = orderService.createOrder(user, productIds);
                if (orderResult.isSuccess()) {
                    Order order = orderResult.result();
                    // 更新订单状态为已支付
                    orderService.updateStatus(order.getId(), 1);
                    
                    result.setOrderId(order.getId());
                    result.setMessage("支付成功，订单已创建");
                    result.setTransactionId("TXN" + System.currentTimeMillis() + random.nextInt(1000));
                    
                    System.out.println("订单创建成功 - 订单ID: " + order.getId() + ", 交易号: " + result.getTransactionId());
                    
                    return JsonResult.success("订单提交成功", result);
                } else {
                    result.setMessage("支付成功但订单创建失败：" + orderResult.error());
                    System.out.println("订单创建失败: " + orderResult.error());
                    return JsonResult.error("订单创建失败：" + orderResult.error());
                }
            } catch (Exception e) {
                result.setMessage("支付成功但订单创建异常：" + e.getMessage());
                System.out.println("订单创建异常: " + e.getMessage());
                return JsonResult.error("订单创建异常：" + e.getMessage());
            }
        } else {
            // 支付失败
            String[] failureReasons = {
                "余额不足", 
                "银行卡被冻结", 
                "网络超时", 
                "支付密码错误", 
                "银行系统维护中"
            };
            result.setMessage("支付失败：" + failureReasons[random.nextInt(failureReasons.length)]);
            
            System.out.println("支付失败: " + result.getMessage());
            return JsonResult.error(result.getMessage(), result);
        }
    }

    /**
     * 模拟支付状态检查（保留原有接口兼容性）
     * 随机返回支付成功或失败，用于测试
     */
    @ResponseBody
    @PostMapping("/payment/status")
    public JsonResult<PaymentResult> checkPaymentStatus(@RequestParam("orderId") Integer orderId, 
                                                       @RequestParam("paymentMethod") String paymentMethod,
                                                       HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        // 验证订单是否存在且属于当前用户
        try {
            Order order = orderService.findById(orderId);
            if (order == null || order.getUserId() != user.getId()) {
                return JsonResult.error("订单不存在或无权限访问");
            }
        } catch (Exception e) {
            return JsonResult.error("订单验证失败");
        }

        // 模拟支付处理时间
        try {
            Thread.sleep(1000 + new Random().nextInt(2000)); // 1-3秒随机延迟
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 随机生成支付结果 (80%成功率，提高成功率便于测试)
        Random random = new Random();
        boolean success = random.nextInt(100) < 80;
        
        PaymentResult result = new PaymentResult();
        result.setOrderId(orderId);
        result.setPaymentMethod(paymentMethod);
        result.setSuccess(success);
        
        if (success) {
            result.setMessage("支付成功");
            result.setTransactionId("TXN" + System.currentTimeMillis() + random.nextInt(1000));
            
            // 记录支付成功的日志
            System.out.println("支付成功 - 订单ID: " + orderId + ", 交易号: " + result.getTransactionId());
        } else {
            String[] failureReasons = {
                "余额不足", 
                "银行卡被冻结", 
                "网络超时", 
                "支付密码错误", 
                "银行系统维护中"
            };
            result.setMessage("支付失败：" + failureReasons[random.nextInt(failureReasons.length)]);
            
            // 记录支付失败的日志
            System.out.println("支付失败 - 订单ID: " + orderId + ", 原因: " + result.getMessage());
        }
        
        return JsonResult.success("支付处理完成", result);
    }

    /**
     * 订单提交结果内部类
     */
    public static class OrderSubmissionResult {
        private Integer orderId;
        private String paymentMethod;
        private boolean paymentSuccess;
        private String message;
        private String transactionId;

        // Getters and Setters
        public Integer getOrderId() { return orderId; }
        public void setOrderId(Integer orderId) { this.orderId = orderId; }
        
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        
        public boolean isPaymentSuccess() { return paymentSuccess; }
        public void setPaymentSuccess(boolean paymentSuccess) { this.paymentSuccess = paymentSuccess; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public String getTransactionId() { return transactionId; }
        public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    }

    /**
     * 支付结果内部类
     */
    public static class PaymentResult {
        private Integer orderId;
        private String paymentMethod;
        private boolean success;
        private String message;
        private String transactionId;

        // Getters and Setters
        public Integer getOrderId() { return orderId; }
        public void setOrderId(Integer orderId) { this.orderId = orderId; }
        
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public String getTransactionId() { return transactionId; }
        public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    }
}