import request from '../utils/request.js'

export const applyRefund = (data) => {
	return request({
		url: '/refund/apply',
		method: 'POST',
		data
	})
}

export const applyRefundByItem = (data) => {
	return request({
		url: '/refund/apply-by-item',
		method: 'POST',
		data
	})
}

export const getUserRefundList = (params) => {
	return request({
		url: '/refund/user/list',
		method: 'GET',
		params: params
	})
}

export const getRefundDetail = (id) => {
	return request({
		url: `/refund/detail/${id}`,
		method: 'GET'
	})
}

export const getRefundByOrderItem = (orderItemId) => {
	return request({
		url: `/refund/latest/${orderItemId}`,
		method: 'GET'
	})
}
