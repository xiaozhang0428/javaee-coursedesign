/**
 * @template T
 * @param success {boolean}
 * @param message {string}
 * @param data {T}
 */
class JsonResult {
}

/**
 * GET 请求
 *
 * @template T
 * @param url {string} api 路径
 * @param data {any | undefined}
 * @returns {Promise<JsonResult<T>>}
 */
async function get(url, data = undefined) {
    const postfix = data ? '?' + new URLSearchParams(data).toString() : '';
    const response = await fetch(window.APP_CONTEXT_PATH + url + postfix);
    /**
     * @template T
     * @type {JsonResult<T>}
     */
    const result = await response.json();

    if (result.success) {
        return result;
    }

    throw new Error(result.message);
}

/**
 * POST 请求
 *
 * @template T
 * @param url {string} api 路径
 * @param data {any | undefined}
 * @returns {Promise<JsonResult<T>>}
 */
async function post(url, data) {
    const response = await fetch(window.APP_CONTEXT_PATH + url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: data ? JSON.stringify(data) : null
    });
    /**
     * @template T
     * @type {JsonResult<T>}
     */
    const result = await response.json();

    if (result.success) {
        return result;
    }

    throw new Error(result.message);
}

// user

/**
 * 登录
 *
 * @param username {string}
 * @param password {string}
 * @param redirect {string}
 * @returns {Promise<string>}
 */
async function login(username, password, redirect = '/') {
    const result = await post(`/user/login`, {username, password, redirect});
    return result.data;
}

/**
 * 注册
 *
 * @param username {string}
 * @param password {string}
 * @param email {string}
 * @param redirect {string}
 * @returns {Promise<string>}
 */
async function register(username, password, email, redirect = '/') {
    const result = await post(`/user/register`, {username, password, email, redirect});
    return result.data;
}

// cart

/**
 * 获取购物车数量
 *
 * @returns {Promise<number>}
 */
async function getCartCount() {
    const result = await get(`/cart/count`);
    return result.data;
}

/**
 * 添加到购物车
 *
 * @param productId {number}
 * @param quantity {number}
 * @returns {Promise<string>}
 */
async function addToCart(productId, quantity = 1) {
    const result = await get(`/cart/add`, {productId, quantity});
    return result.message;
}

/**
 * 修改购物车某商品数量
 *
 * @param productId
 * @param quantity
 * @returns {Promise<string>}
 */
async function updateCartProductCount(productId, quantity) {
    const result = await get('/cart/update', {productId, quantity});
    return result.message;
}

/**
 * 删除购物车中某个物品
 *
 * @param productId {number}
 * @returns {Promise<void>}
 */
async function removeCartItem(productId) {
    await get('/cart/remove', {productId});
}

/**
 * 批量删除 购物车物品
 * @param productIds
 * @returns {Promise<int[]>}
 */
async function removeCartItems(productIds) {
    const result = await post('/cart/remove', productIds)
    return result.data;
}

async function checkoutCart(productIds) {
    const result = await post('/cart/checkout', productIds);
    return result.message;
}