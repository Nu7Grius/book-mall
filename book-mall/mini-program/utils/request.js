import config from '../config/index.js'

const getImageUrl = (url) => {
	if (!url || typeof url !== 'string') return ''

	let cleanUrl = url.trim()
	if (cleanUrl.startsWith('`') && cleanUrl.endsWith('`')) {
		cleanUrl = cleanUrl.slice(1, -1)
	}
	cleanUrl = cleanUrl.trim()

	if (!cleanUrl) return ''

	if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
		return cleanUrl
	}
	if (cleanUrl.startsWith('/')) {
		return config.imgUrl + cleanUrl
	}
	return config.imgUrl + '/' + cleanUrl
}

const processBookData = (data) => {
	if (!data) return data

	if (Array.isArray(data)) {
		try {
			return data.map(item => {
				if (item && typeof item === 'object') {
					const newItem = { ...item }
					if (newItem.coverImage) {
						newItem.coverImage = getImageUrl(newItem.coverImage)
					}
					if (newItem.images && Array.isArray(newItem.images)) {
						newItem.images = newItem.images.map(img => getImageUrl(img))
					}
					return newItem
				}
				return item
			})
		} catch (e) {
			console.error('处理图书数据失败:', e)
			return data
		}
	}

	if (typeof data === 'object' && data !== null) {
		const result = { ...data }
		if (result.coverImage) {
			result.coverImage = getImageUrl(result.coverImage)
		}
		if (result.images && Array.isArray(result.images)) {
			result.images = result.images.map(img => getImageUrl(img))
		}
		return result
	}

	return data
}

const request = (options) => {
	return new Promise((resolve, reject) => {
		const userInfo = uni.getStorageSync('userInfo')
		const token = userInfo ? userInfo.id : ''

		let url = config.baseUrl + options.url

		if (options.params) {
			const paramParts = []
			for (const key in options.params) {
				if (options.params[key] !== null && options.params[key] !== undefined) {
					paramParts.push(key + '=' + encodeURIComponent(options.params[key]))
				}
			}
			if (paramParts.length > 0) {
				url += '?' + paramParts.join('&')
			}
		}

		uni.request({
			url: url,
			method: options.method || 'GET',
			data: options.data || {},
			header: {
				'Content-Type': 'application/json',
				'Authorization': token ? String(token) : '',
				...options.header
			},
			timeout: config.timeout,
			success: (res) => {
				if (res.data.code === 200) {
					res.data.data = processBookData(res.data.data)
					resolve(res.data)
				} else if (res.data.code === 401) {
					uni.removeStorageSync('token')
					uni.removeStorageSync('userInfo')
					uni.showToast({
						title: '请先登录',
						icon: 'none'
					})
					setTimeout(() => {
						uni.navigateTo({
							url: '/pages/login/login'
						})
					}, 1500)
					reject(res.data)
				} else {
					uni.showToast({
						title: res.data.msg || '请求失败',
						icon: 'none'
					})
					reject(res.data)
				}
			},
			fail: (err) => {
				uni.showToast({
					title: '网络请求失败',
					icon: 'none'
				})
				reject(err)
			}
		})
	})
}

export default request
