import request from '../utils/request.js'

export const getNoticeList = (params) => {
	return request({
		url: '/notice/list',
		method: 'GET',
		data: params
	})
}

export const getNoticeDetail = (id) => {
	return request({
		url: `/notice/${id}`,
		method: 'GET'
	})
}
