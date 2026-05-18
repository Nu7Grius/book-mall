import request from '../utils/request.js'

// 获取购物车列表
export const getCartList = () => {
	return request({
		url: '/cart/list',
		method: 'GET'
	})
}

// 添加到购物车
export const addToCart = (data) => {
	return request({
		url: '/cart/add',
		method: 'POST',
		data
	})
}

// 更新购物车商品数量
export const updateCartItem = (data) => {
	return request({
		url: '/cart',
		method: 'PUT',
		data
	})
}

// 删除购物车商品
export const deleteCartItem = (id) => {
	return request({
		url: `/cart/${id}`,
		method: 'DELETE'
	})
}

// 清空购物车
export const clearCart = () => {
	return request({
		url: '/cart/clear',
		method: 'DELETE'
	})
}
