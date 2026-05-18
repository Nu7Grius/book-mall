import request from '../utils/request.js'

// 获取图书分类列表
export const getCategoryList = () => {
	return request({
		url: '/category/list',
		method: 'GET'
	})
}

// 获取图书列表
export const getBookList = (params) => {
	return request({
		url: '/book/list',
		method: 'GET',
		params: params
	})
}

// 获取热门图书
export const getHotBooks = (limit = 10) => {
	return request({
		url: '/book/hot',
		method: 'GET',
		params: { limit }
	})
}

// 获取图书详情
export const getBookDetail = (id) => {
	return request({
		url: `/book/${id}`,
		method: 'GET'
	})
}

// 获取图书评论列表
export const getBookComments = (bookId) => {
	return request({
		url: `/comment/book/${bookId}`,
		method: 'GET'
	})
}

// 添加图书评论
export const addComment = (data) => {
	return request({
		url: '/comment',
		method: 'POST',
		data
	})
}

// 搜索图书
export const searchBooks = (keyword) => {
	return request({
		url: '/book/search',
		method: 'GET',
		params: { keyword }
	})
}
