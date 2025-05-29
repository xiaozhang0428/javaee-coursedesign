package com.shop.controller;

import com.shop.entity.Cart;
import com.shop.entity.User;
import com.shop.service.CartService;
import com.shop.util.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 购物车控制器
 */
@Controller
@RequestMapping("/cart")
public class CartController {
    
    @Autowired
    private CartService cartService;
    
    /**
     * 购物车页面
     */
    @RequestMapping("/")
    public String cartPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<Cart> cartItems = cartService.findByUserId(user.getId());
        double totalAmount = cartService.getTotalAmount(user.getId());
        
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalAmount", totalAmount);
        
        return "cart";
    }
    
    /**
     * 添加商品到购物车
     */
    @PostMapping("/add")
    @ResponseBody
    public JsonResult<String> addToCart(@RequestParam Integer productId,
                                       @RequestParam(defaultValue = "1") Integer quantity,
                                       HttpSession session) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }
        
        if (productId == null || quantity == null || quantity <= 0) {
            return JsonResult.error("参数错误");
        }
        
        if (cartService.addToCart(user.getId(), productId, quantity)) {
            return JsonResult.success("添加成功");
        } else {
            return JsonResult.error("添加失败，可能是库存不足");
        }
    }
    
    /**
     * 更新购物车商品数量
     */
    @PostMapping("/update")
    @ResponseBody
    public JsonResult<String> updateQuantity(@RequestParam Integer productId,
                                            @RequestParam Integer quantity,
                                            HttpSession session) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }
        
        if (productId == null || quantity == null || quantity <= 0) {
            return JsonResult.error("参数错误");
        }
        
        if (cartService.updateQuantity(user.getId(), productId, quantity)) {
            return JsonResult.success("更新成功");
        } else {
            return JsonResult.error("更新失败，可能是库存不足");
        }
    }
    
    /**
     * 从购物车删除商品
     */
    @PostMapping("/remove")
    @ResponseBody
    public JsonResult<String> removeFromCart(@RequestParam Integer productId,
                                            HttpSession session) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }
        
        if (productId == null) {
            return JsonResult.error("参数错误");
        }
        
        if (cartService.removeFromCart(user.getId(), productId)) {
            return JsonResult.success("删除成功");
        } else {
            return JsonResult.error("删除失败");
        }
    }
    
    /**
     * 清空购物车
     */
    @PostMapping("/clear")
    @ResponseBody
    public JsonResult<String> clearCart(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }
        
        if (cartService.clearCart(user.getId())) {
            return JsonResult.success("清空成功");
        } else {
            return JsonResult.error("清空失败");
        }
    }
    
    /**
     * 获取购物车商品数量（用于页面显示）
     */
    @RequestMapping("/count")
    @ResponseBody
    public JsonResult<Integer> getCartCount(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.success(0);
        }
        
        List<Cart> cartItems = cartService.findByUserId(user.getId());
        int count = 0;
        if (cartItems != null) {
            for (Cart cart : cartItems) {
                count += cart.getQuantity();
            }
        }
        
        return JsonResult.success(count);
    }
}