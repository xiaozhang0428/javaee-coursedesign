package com.shop.controller;

import com.shop.entity.Cart;
import com.shop.entity.User;
import com.shop.service.CartService;
import com.shop.util.JsonResult;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
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
        double totalAmount = cartItems.stream()
                .filter(cart -> cart.getProduct() != null && cart.getProduct().getPrice() != null)
                .map(cart -> cart.getProduct().getPrice().multiply(new BigDecimal(cart.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .doubleValue();

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalAmount", totalAmount);

        return "cart";
    }

    /**
     * 获取购物车商品数量
     */
    @GetMapping("/count")
    @ResponseBody
    public JsonResult<Integer> getCartCount(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.success(0);
        }

        List<Cart> cartItems = cartService.findByUserId(user.getId());
        return JsonResult.success(cartItems.stream()
                .mapToInt(Cart::getQuantity)
                .sum());
    }

    /**
     * 添加商品到购物车，返回购物车中物品数量
     */
    @GetMapping("/add")
    @ResponseBody
    public JsonResult<Void> addToCart(@RequestParam("productId") int productId,
                                      @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                      HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (quantity <= 0) {
            return JsonResult.error("参数错误");
        }

        String addResult = cartService.addToCart(user.getId(), productId, quantity);
        if (addResult == null) {
            return JsonResult.success("添加成功");
        } else {
            return JsonResult.error(addResult);
        }
    }

    /**
     * 更新购物车商品数量
     */
    @GetMapping("/update")
    @ResponseBody
    public JsonResult<Integer> updateQuantity(@RequestParam("productId") int productId,
                                              @RequestParam("quantity") int quantity,
                                              HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (quantity <= 0) {
            return JsonResult.error("参数错误");
        }

        String updateResult = cartService.updateQuantity(user.getId(), productId, quantity);
        if (updateResult == null) {
            return getCartCount(session);
        } else {
            return JsonResult.error(updateResult);
        }
    }

    /**
     * 从购物车删除商品
     */
    @GetMapping("/remove")
    @ResponseBody
    public JsonResult<Void> removeFromCart(@RequestParam("productId") int productId,
                                           HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (cartService.removeFromCart(user.getId(), productId)) {
            return JsonResult.success("删除成功");
        } else {
            return JsonResult.error("删除失败");
        }
    }

    /**
     * 批量删除购物车商品
     */
    @PostMapping("/remove")
    @ResponseBody
    public JsonResult<List<Integer>> removeBatchFromCart(@RequestBody List<Integer> productIds,
                                                HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录", List.of());
        }

        if (productIds.isEmpty()) {
            return JsonResult.error("请选择要移除的商品", List.of());
        }

        List<Integer> deletedProducts = productIds.stream()
                .filter(pid -> cartService.removeFromCart(user.getId(), pid))
                .toList();
        if (deletedProducts.size() != productIds.size()) {
            return JsonResult.error("部分商品删除失败", deletedProducts);
        }
        return JsonResult.success("删除成功", deletedProducts);
    }
}