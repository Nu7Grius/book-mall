import request from '../utils/request.js'

// 获取地址列表
export const getAddressList = (userId) => {
	return request({
		url: '/address/list',
		method: 'GET',
		params: userId ? { userId } : {}
	})
}

// 获取地址详情
export const getAddressDetail = (id) => {
	return request({
		url: `/address/${id}`,
		method: 'GET'
	})
}

// 添加地址
export const addAddress = (data) => {
	return request({
		url: '/address',
		method: 'POST',
		data
	})
}

// 更新地址
export const updateAddress = (data) => {
	return request({
		url: '/address',
		method: 'PUT',
		data
	})
}

// 删除地址
export const deleteAddress = (id) => {
	return request({
		url: `/address/${id}`,
		method: 'DELETE'
	})
}

// 设置默认地址
export const setDefaultAddress = (id) => {
	return request({
		url: `/address/default/${id}`,
		method: 'PUT'
	})
}
