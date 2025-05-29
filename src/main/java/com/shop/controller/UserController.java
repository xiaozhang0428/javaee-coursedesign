package com.shop.controller;

import com.shop.entity.User;
import com.shop.service.UserService;
import com.shop.util.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

/**
 * 用户控制器
 */
@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    /**
     * 登录页面
     */
    @RequestMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    /**
     * 注册页面
     */
    @RequestMapping("/register")
    public String registerPage() {
        return "register";
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/doLogin")
    @ResponseBody
    public JsonResult<User> doLogin(@RequestParam("username") String username,
                                   @RequestParam("password") String password,
                                   HttpSession session) {
        
        if (username == null || username.trim().isEmpty()) {
            return JsonResult.error("用户名不能为空");
        }
        
        if (password == null || password.trim().isEmpty()) {
            return JsonResult.error("密码不能为空");
        }
        
        User user = userService.login(username.trim(), password);
        if (user != null) {
            // 登录成功，保存用户信息到session
            session.setAttribute("user", user);
            return JsonResult.success("登录成功", user);
        } else {
            return JsonResult.error("用户名或密码错误");
        }
    }
    
    /**
     * 用户注册
     */
    @PostMapping("/doRegister")
    @ResponseBody
    public JsonResult<String> doRegister(@RequestParam("username") String username,
                                        @RequestParam("password") String password,
                                        @RequestParam("confirmPassword") String confirmPassword,
                                        @RequestParam(value = "email", required = false) String email) {
        
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            return JsonResult.error("用户名不能为空");
        }
        
        if (password == null || password.trim().isEmpty()) {
            return JsonResult.error("密码不能为空");
        }
        
        if (!password.equals(confirmPassword)) {
            return JsonResult.error("两次密码输入不一致");
        }
        
        if (username.length() < 3 || username.length() > 20) {
            return JsonResult.error("用户名长度必须在3-20个字符之间");
        }
        
        if (password.length() < 6) {
            return JsonResult.error("密码长度不能少于6位");
        }
        
        // 检查用户名是否已存在
        if (userService.isUsernameExists(username.trim())) {
            return JsonResult.error("用户名已存在");
        }
        
        // 检查邮箱是否已存在
        if (email != null && !email.trim().isEmpty() && userService.isEmailExists(email.trim())) {
            return JsonResult.error("邮箱已被注册");
        }
        
        // 创建用户
        User user = new User(username.trim(), password, email != null ? email.trim() : null);
        
        if (userService.register(user)) {
            return JsonResult.success("注册成功");
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
    @RequestMapping("/profile")
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
    @PostMapping("/updateProfile")
    @ResponseBody
    public JsonResult<String> updateProfile(@RequestParam(value = "email", required = false) String email,
                                           @RequestParam(value = "phone", required = false) String phone,
                                           @RequestParam(value = "address", required = false) String address,
                                           HttpSession session) {
        
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return JsonResult.error("请先登录");
        }
        
        User user = new User();
        user.setId(sessionUser.getId());
        user.setEmail(email != null ? email.trim() : null);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setAddress(address != null ? address.trim() : null);
        
        if (userService.updateUser(user)) {
            // 更新session中的用户信息
            User updatedUser = userService.findById(sessionUser.getId());
            session.setAttribute("user", updatedUser);
            return JsonResult.success("更新成功");
        } else {
            return JsonResult.error("更新失败");
        }
    }
    
    /**
     * 我的订单页面
     */
    @RequestMapping("/orders")
    public String orders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        // 这里可以添加订单查询逻辑
        // List<Order> orders = orderService.findByUserId(user.getId());
        // model.addAttribute("orders", orders);
        
        return "orders";
    }
    
    /**
     * 修改密码
     */
    @PostMapping("/changePassword")
    @ResponseBody
    public JsonResult<String> changePassword(@RequestParam("oldPassword") String oldPassword,
                                            @RequestParam("newPassword") String newPassword,
                                            @RequestParam("confirmPassword") String confirmPassword,
                                            HttpSession session) {
        
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return JsonResult.error("请先登录");
        }
        
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            return JsonResult.error("原密码不能为空");
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return JsonResult.error("新密码不能为空");
        }
        
        if (!newPassword.equals(confirmPassword)) {
            return JsonResult.error("两次密码输入不一致");
        }
        
        if (newPassword.length() < 6) {
            return JsonResult.error("新密码长度不能少于6位");
        }
        
        // 验证原密码
        User user = userService.findById(sessionUser.getId());
        if (!user.getPassword().equals(oldPassword)) {
            return JsonResult.error("原密码错误");
        }
        
        // 更新密码
        user.setPassword(newPassword);
        if (userService.updateUser(user)) {
            return JsonResult.success("密码修改成功");
        } else {
            return JsonResult.error("密码修改失败");
        }
    }
}