import request from '../utils/request.js'

// 创建订单
export const createOrder = (data) => {
	return request({
		url: '/order/create',
		method: 'POST',
		data
	})
}

// 获取用户订单列表
export const getOrderList = (userId, params = {}) => {
	return request({
		url: `/order/user/${userId}`,
		method: 'GET',
		params: params
	})
}

// 获取订单详情
export const getOrderDetail = (id) => {
	return request({
		url: `/order/${id}`,
		method: 'GET'
	})
}

// 取消订单
export const cancelOrder = (id) => {
	return request({
		url: '/order/cancel',
		method: 'PUT',
		data: { id }
	})
}

// 确认收货
export const confirmReceive = (id) => {
	return request({
		url: '/order/confirm',
		method: 'PUT',
		data: { id }
	})
}

// 支付订单
export const payOrder = (id) => {
	return request({
		url: '/order/pay',
		method: 'PUT',
		data: { id }
	})
}

// 提醒发货
export const remindShip = (id) => {
	return request({
		url: '/order/remind-ship',
		method: 'PUT',
		data: { id }
	})
}

// 标记订单完成（评价后调用）
export const completeOrder = (orderId) => {
	return request({
		url: `/order/${orderId}/complete`,
		method: 'PUT'
	})
}

// 获取退款列表
export const getRefundList = (params) => {
	return request({
		url: '/refund/list',
		method: 'GET',
		params: params
	})
}
