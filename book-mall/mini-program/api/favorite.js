import request from '../utils/request.js'

// 获取用户收藏列表
export const getFavoriteList = (userId) => {
	return request({
		url: `/favorite/user/${userId}`,
		method: 'GET'
	})
}

// 添加收藏
export const addFavorite = (data) => {
	return request({
		url: '/favorite/add',
		method: 'POST',
		data
	})
}

// 取消收藏
export const removeFavorite = (data) => {
	return request({
		url: '/favorite/remove',
		method: 'DELETE',
		params: data
	})
}

// 检查是否已收藏
export const checkFavorite = (userId, bookId) => {
	return request({
		url: '/favorite/check',
		method: 'GET',
		params: { userId, bookId }
	})
}
