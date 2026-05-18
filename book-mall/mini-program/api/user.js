import request from '../utils/request.js'
import config from '../config/index.js'

// 用户登录
export const userLogin = (data) => {
	return request({
		url: '/user/login',
		method: 'POST',
		data
	})
}

// 用户注册
export const userRegister = (data) => {
	return request({
		url: '/user/register/user',
		method: 'POST',
		data
	})
}

// 获取用户信息
export const getUserInfo = () => {
	return request({
		url: '/user/getUserInfo',
		method: 'GET'
	})
}

// 根据ID获取用户信息
export const getUserInfoById = (id) => {
	return request({
		url: `/user/${id}`,
		method: 'GET'
	})
}

// 更新用户信息
export const updateUserInfo = (data) => {
	return request({
		url: '/user/profile',
		method: 'PUT',
		data
	})
}

// 修改密码
export const updatePassword = (data) => {
	return request({
		url: '/user/password',
		method: 'PUT',
		data
	})
}

// 上传头像
export const uploadAvatar = (filePath) => {
	return new Promise((resolve, reject) => {
		const token = uni.getStorageSync('token')
		uni.uploadFile({
			url: config.baseUrl + '/user/uploadAvatar',
			filePath: filePath,
			name: 'file',
			header: {
				'Authorization': token
			},
			success: (res) => {
				const data = JSON.parse(res.data)
				if (data.code === 200) {
					resolve(data)
				} else {
					uni.showToast({
						title: data.msg || '上传失败',
						icon: 'none'
					})
					reject(data)
				}
			},
			fail: (err) => {
				uni.showToast({
					title: '上传失败',
					icon: 'none'
				})
				reject(err)
			}
		})
	})
}
